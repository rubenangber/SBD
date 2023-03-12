/*
1. Se desea llevar un control de las actualizaciones que se realizan sobre una base de
datos que está compuesta por las siguientes tablas:
    PROYECTO (COD_PROY, NOMBRE, PRESUPUESTO)
    DEPARTAMENTO (COD_DPTO, NOMBRE, DIRECCION, NUM_EMPLEADOS)
Para ello, se crea una tabla donde se registrará cada acción que se realice sobre las
tablas anteriores. Dicha tabla tendrá el siguiente esquema:
    REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION)
En la tabla REGISTRO se incluirá una tupla por cada acción que se realice en las
tablas anteriores y que contendrá los siguientes atributos:
    - ID. Será la clave de la tabla registro y se gestionará automáticamente mediante
    un disparador que obtenga el valor correspondiente a partir de una secuencia.
    - Fecha en la que se ha realizado la modificación
    - Usuario que ha realizado la acción
    - Nombre de la tabla modificada (PROYECTO o DEPARTAMENTO)
    - Clave de la tupla insertada, cambiada o borrada
    - Acción que se ha realizado (INSERT, UPDATE o DELETE)
        a) Crear las tres tablas indicadas y los disparadores necesarios para registrar los
        datos de modificación de las tablas.
        b) Insertar, modificar y borrar varias tuplas en las tablas PROYECTO y
        DEPARTAMENTO y consultar el contenido de la tabla REGISTRO para
        comprobar que los disparadores han funcionado correctamente.
*/

CREATE TABLE PROYECTO (
    cod_proy INTEGER PRIMARY KEY,
    nombre VARCHAR(20),
    presupuesto DECIMAL(8,2)
);

CREATE TABLE DEPARTAMENTO (
    cod_dpto INTEGER PRIMARY KEY,
    nombre VARCHAR(20),
    direccion VARCHAR(50),
    num_empleados INTEGER
);

CREATE TABLE REGISTRO (
    id INTEGER PRIMARY KEY,
    fecha DATE DEFAULT SYSDATE,
    usuario VARCHAR(20),
    tabla VARCHAR(20) CHECK (tabla = 'PROYECTO' OR tabla = 'DEPARTAMENTO'),
    cod_item INTEGER,
    accion VARCHAR(6) CHECK (accion = 'INSERT' OR accion = 'UPDATE' OR accion = 'DELETE')
);

CREATE SEQUENCE clave_reg;

CREATE OR REPLACE TRIGGER clave_reg
BEFORE INSERT ON REGISTRO
FOR EACH ROW
BEGIN
SELECT clave_reg.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER ins_proy
AFTER INSERT ON PROYECTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'PROYECTO', :new.cod_proy, 'INSERT');
END;
/

CREATE OR REPLACE TRIGGER up_proy
AFTER UPDATE ON PROYECTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'PROYECTO', :new.cod_proy, 'UPDATE');
END;
/

CREATE OR REPLACE TRIGGER del_proy
AFTER DELETE ON PROYECTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'PROYECTO', :new.cod_proy, 'DELETE');
END;
/

CREATE OR REPLACE TRIGGER ins_dep
AFTER INSERT ON DEPARTAMENTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'DEPARTAMENTO', :new.cod_proy, 'INSERT');
END;
/

CREATE OR REPLACE TRIGGER up_dep
AFTER UPDATE ON DEPARTAMENTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'DEPARTAMENTO', :new.cod_proy, 'UPDATE');
END;
/

CREATE OR REPLACE TRIGGER del_dep
AFTER DELETE ON DEPARTAMENTO
FOR EACH ROW
BEGIN
INSERT INTO REGISTRO (usuario, tabla, cod_item, accion) VALUES (user, 'DEPARTAMENTO', :new.cod_proy, 'DELETE');
END;
/

/*
Hacer IMPORT, UPDATE Y DELETE para comprobar el funcionamiento de los TRIGGERS
*/
SELECT * FROM REGISTRO;

/*
2. Crear una nueva tabla EMPLEADO (DNI, NOMBRE, APELLIDO, COD_DEPTO).
Crear los disparadores precisos para que el atributo derivado NUM_EMPLEADOS
de la tabla DEPARTAMENTO se mantenga consistente con el contenido de la tabla
EMPLEADOS de modo automático. Comprobar el funcionamiento de los
disparadores en los siguientes casos:
    - Se insertan varios empleados en distintos departamentos
    - Se cambia el departamento al que está asignado un empleado
    - Se elimina un usuario
    - Se eliminan varios usuarios
    - Se inserta un empleado sin departamentos asignado y posteriormente se
    modifica para asignarlo a un departamento existente
    - Se modifica un empleado asignado a un departamento para que deje de estar
    asignado a ninguno
*/

CREATE TABLE EMPLEADO (
    DNI INTEGER PRIMARY KEY,
    NOMBRE VARCHAR(20),
    APELLIDO VARCHAR(50),
    COD_DEPTO INTEGER REFERENCES DEPARTAMENTO
);

CREATE OR REPLACE TRIGGER I_EMP
AFTER INSERT ON EMPLEADO
FOR EACH ROW
WHEN (new.COD_DEPTO IS NOT NULL)
BEGIN
UPDATE DEPARTAMENTO SET num_empleados = num_empleados + 1
WHERE cod_dpto = :new.COD_DEPTO;
END;
/

CREATE OR REPLACE TRIGGER D_EMP
AFTER DELETE ON EMPLEADO
FOR EACH ROW
WHEN (new.COD_DEPTO IS NOT NULL)
BEGIN
UPDATE DEPARTAMENTO SET num_empleados = num_empleados - 1
WHERE cod_dpto = :old.COD_DEPTO;
END;
/

CREATE OR REPLACE TRIGGER U_EMP
AFTER UPDATE ON EMPLEADO
FOR EACH ROW
WHEN (new.COD_DEPTO IS NOT NULL OR old.COD_DEPTO IS NOT NULL)
BEGIN
UPDATE DEPARTAMENTO SET num_empleados = num_empleados + 1
WHERE cod_dpto = :new.COD_DEPTO;
UPDATE DEPARTAMENTO SET num_empleados = num_empleados - 1
WHERE cod_dpto = :old.COD_DEPTO;
END;
/

/*
3. Crear dos tablas con los mismos esquemas de las tablas DISPONE y la tabla
PRESTAMO de la base de datos usada en las prácticas (no es necesario definir en
ellas las claves externas correspondientes al resto de las tablas de la base de datos
de prácticas). Crear los disparadores necesarios para que el atributo derivado
NUM_DISPONIBLES de la tabla creada a imagen de DISPONE se mantenga
consistente de manera automática.
Se desea impedir que en la tabla creada a imagen de PRESTAMO se realicen
modificaciones sobre las columnas ISBN o COD_SUC. Crear un disparador que
garantice que no se producirán modificaciones de este tipo.
*/

CREATE TABLE DISPONE2 (
    cod_suc INTEGER,
    isbn VARCHAR(20),
    num_ejemplares INTEGER,
    num_disponibles INTEGER,
    PRIMARY KEY (cod_suc, isbn),
    CHECK (num_disponibles <= num_ejemplares AND num_disponibles >= 0 AND num_ejemplares >= 0)
);

CREATE TABLE PRESTAMO2 (
    codigo INTEGER PRIMARY KEY,
    cod_lector INTEGER;
    isbn VARCHAR(20),
    cod_suc INTEGER,
    fecha_ini date,
    fecha_dev date,
    FOREIGN KEY (cod_suc, isbn) REFERENCES DISPONE2 (cod_suc, isbn)
);

CREATE OR REPLACE TRIGGER I_PRESTAMO
AFTER INSERT ON PRESTAMO2
FOR EACH ROW
WHEN (new.fecha_dev IS NULL)
BEGIN
UPDATE DISPONE2 SET num_disponibles = num_disponibles - 1
WHERE isbn = :new.isbn AND cod_suc = :new.cod_suc;
END;
/

CREATE OR REPLACE TRIGGER D_PRESTAMO
AFTER DELETE ON PRESTAMO2
FOR EACH ROW
WHEN (old.fecha_dev IS NULL)
BEGIN
UPDATE DISPONE2 SET num_disponibles = num_disponibles + 1
WHERE isbn = :old.isbn AND cod_suc = :old.cod_suc;
END;
/

/*
4. La biblioteca desea incentivar los hábitos de lectura de sus socios estableciendo una
clasificación de los mismos en función del número de prestamos que han realizado.
Solo se incluirán en la clasificación aquellos lectores que hayan realizado como
mínimo 10 préstamos. En el caso de que varios lectores coincidan con el mismo nº
de prestamos, se les asignarán números consecutivos en la clasificación sin importar
el criterio. Para ello, se desea crear una tabla que contenga las siguientes columnas:
nº de orden en la clasificación a fecha de hoy, código del lector y nº de prestamos
realizados.
    a. Crear la tabla anterior tomando como clave primaria el nº de orden en la
    clasificación.
    b. Crear una secuencia que se utilizará para obtener los valores de la clave
    primaria de la tabla anterior.
    c. Crear un trigger que genere de forma automática durante la inserción los
    valores para la clave de la tabla.
    d. Rellenar la tabla con los valores correspondientes a partir del contenido
    de la Base de Datos en el momento actual.
*/

CREATE TABLE CLASIFICACION (
    num_orden INTEGER PRIMARY KEY,
    cod_lector INTEGER,
    num_prestamo INTEGER CHECK (num_prestamo >= 10)
);

CREATE SEQUENCE secuencia;

CREATE OR REPLACE TRIGGER trigger
BEFORE INSERT ON CLASIFICACION
FOR EACH ROW
BEGIN
SELECT secuencia.NEXTVAL INTO :NEW.num_orden FROM DUAL;
END;
/

INSERT INTO CLASIFICACION (cod_lector, num_prestamo) 
SELECT cod_lector, COUNT(*) FROM CLASIFICACION 
GROUP BY cod_lector
HAVING COUNT(*) >= 10
ORDER BY 2 DESC;

/*
5. Eliminar todos los objetos de la base de datos creados a lo largo de esta sesión.
*/

DROP TABLE PROYECTO;
DROP TABLE DEPARTAMENTO;
DROP TABLE REGISTRO;
DROP SEQUENCE clave_reg;
DROP TRIGGER ins_proy;
DROP TRIGGER up_proy;
DROP TRIGGER del_proy;
DROP TRIGGER ins_dep;
DROP TRIGGER up_dep;
DROP TRIGGER del_dep;
DROP TRIGGER clave_reg;

DROP TABLE EMPLEADO;
DROP TRIGGER I_EMP;
DROP TRIGGER D_EMP;
DROP TRIGGER U_EMP;

DROP TABLE DISPONE2;
DROP TABLE PRESTAMO2;
DROP TRIGGER I_PRESTAMO;
DROP TRIGGER D_PRESTAMO;

DROP TABLE CLASIFICACION;
DROP SEQUENCE secuencia;
DROP TRIGGER trigger;