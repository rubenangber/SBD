/*
EJEMPLO
    ALOJAMIENTO(ID, CAPACIDAD, TIPO)
                --
                PK
    NIÑO(ID, NOMBRE, EDAD, ALOJAMIENTO_EN)
         --                - - - - - - - -
         PK                FK sobre ALOJAMIENTO.ID

Si la edad de los niños < 12 --> cabaña
Si edad >= 12 --> tienda

drop table nino;
drop table alojamiento;
create table alojamiento (
id integer not null primary key,
capacidad integer,
tipo char(1) check (tipo='T' OR tipo='C'));

insert into alojamiento values (1, 3, 'C');
insert into alojamiento values (2, 3, 'C');
insert into alojamiento values (3, 3, 'C');
insert into alojamiento values (4, 3, 'C');
insert into alojamiento values (5, 3, 'T');
insert into alojamiento values (6, 3, 'T');
insert into alojamiento values (7, 3, 'T');
insert into alojamiento values (8, 3, 'T');



create table nino (
id integer not null primary key,
nombre varchar(20),
edad integer,
alojado_en integer references alojamiento);


Regla de integridad
Los niños hasta 12 años se alojarán en cabañas (alojamiento tipo C)
Los niños mayores de 12 años se alojarán en tiendas (alojamiento tipo T)


CREATE OR REPLACE TRIGGER binino
before insert on nino
FOR EACH ROW
when (new.alojado_en is not null and new.edad is not null)

 declare 
   tipoaloj alojamiento.tipo%TYPE;
   Mal_Alojamiento EXCEPTION;
   Alojamiento_Completo EXCEPTION;
   ocupacion integer;
   ocupmax integer;
 begin
   select tipo, capacidad into tipoaloj, ocupmax from alojamiento where id=:new.alojado_en;
   if tipoaloj='C' and :new.edad > 12 or tipoaloj='T' and :new.edad <= 12
    then raise Mal_Alojamiento;
   end if;
   select count(*) into ocupacion from nino where alojado_en=:new.alojado_en;
   if ocupacion=ocupmax
    then raise Alojamiento_Completo;
   end if;

EXCEPTION
-- rutina genérica de tratamiento de cualquier tipo de error
WHEN Mal_Alojamiento then raise_application_error (-20101,'ERROR Infante alojado en tipo incorrecto');
WHEN Alojamiento_Completo then raise_application_error (-20102,'ERROR El alojamiento asignado está completo');
WHEN others then raise_application_error (-20100,'error#'||sqlcode||'
desc#: '|| sqlerrm);
END;
/


insert into nino values (1, 'PEPE', 10, 1);
insert into nino values (2, 'JUAN', 11, 1);
insert into nino values (3, 'LOLA', 9, 1);
insert into nino values (4, 'MARIO', 12, 1);
insert into nino values (5, 'CLARA', 13, 5);
insert into nino values (6, 'INES', 14, 6);
insert into nino values (7, 'JUAN', 12, 1);
insert into nino values (8, 'MARIA', 10, 8);
insert into nino values (9, 'CARLA', 15, 1);
*/

/*
1. Escribir un bloque PL/SQL que calcule la media de tres números y saque el
resultado por pantalla.
*/

SET SERVEROUTPUT ON
DECLARE 
    NUM1 NUMBER;
    NUM2 NUMBER;
    NUM3 NUMBER;
    MEDIA NUMBER;
BEGIN
    NUM1 := 5;
    NUM2 := 3.4;
    NUM3 := 5.9;
    MEDIA := (NUM1 + NUM2 + NUM3) / 3;
    DBMS_OUTPUT.PUT_LINE('La media de los numeros es >> ' || MEDIA);
END;
/

/*
2. Escribir un bloque en PL/SQL que acceda a la base de datos UNIV y saque por
pantalla los datos del autor MARIO VARGAS LLOSA. Realice el tratamiento de
errores necesario.
*/

SET SERVEROUTPUT ON
DECLARE 
    CODIGO univ.AUTOR.Codigo%TYPE;
    NOMBRE univ.AUTOR.Nombre%TYPE;
    APELLIDO univ.AUTOR.Apellido%TYPE;
    ANONAC univ.AUTOR.Ano_Nac%TYPE;
    ANOFALL univ.AUTOR.Ano_Fall%TYPE;
    CODNACION univ.AUTOR.Cod_Nacion%TYPE;
BEGIN
    SELECT *
    INTO CODIGO, NOMBRE, APELLIDO, ANONAC, ANOFALL, CODNACION
    FROM AUTOR
    WHERE Nombre = 'MARIO' AND Apellido = 'VARGAS LLOSA';
    DBMS_OUTPUT.PUT_LINE(CODIGO || ',' || NOMBRE || ',' || APELLIDO || ',' || ANONAC || ',' || ANOFALL || ',' || CODNACION);
EXCEPTION
    WHEN others THEN raise_application_error (-20100, 'ERROR#' || sqlcode || 'desc#: ' || sqlerrm);
END;
/

/*
3. Escribir un bloque PL/SQL que muestre por pantalla el número total de libros,
autores, editoriales, sucursales y lectores que hay en la base de datos UNIV.
    a. Realice el tratamiento de errores necesario.
    b. En caso de que el número de lectores supere en un 20% al número de
    libros. Sacar un mensaje por pantalla que indique “Aumentar fondo de
    préstamo”.
*/

SET SERVEROUTPUT ON
DECLARE 
    LIBROS NUMBER;
    EDITORIALES NUMBER;
    AUTORES NUMBER;
    LECTORES NUMBER;
    SUCURSALES NUMBER;
BEGIN
    SELECT COUNT(*) INTO LIBROS FROM LIBRO;
    SELECT COUNT(*) INTO EDITORIALES FROM EDITORIAL;
    SELECT COUNT(*) INTO AUTORES FROM AUTOR;
    SELECT COUNT(*) INTO LECTORES FROM LECTOR;
    SELECT COUNT(*) INTO SUCURSALES FROM SUCURSAL;
    DBMS_OUTPUT.PUT_LINE('Total de libros >> ' || LIBROS);
    DBMS_OUTPUT.PUT_LINE('Total de editoriales >> ' || EDITORIALES);
    DBMS_OUTPUT.PUT_LINE('Total de autores >> ' || AUTORES);
    DBMS_OUTPUT.PUT_LINE('Total de lectores >> ' || LECTORES);
    DBMS_OUTPUT.PUT_LINE('Total de sucursales >> ' || SUCURSALES);
    IF (LECTORES > (1.2 * LIBROS)) THEN
        DBMS_OUTPUT.PUT_LINE('Aumentar fondo de préstamo');
    END IF;
EXCEPTION
    WHEN others THEN raise_application_error (-20100, 'ERROR#' || sqlcode || 'desc#: ' || sqlerrm);
END;
/

/*
4. Se desea llevar un control de las actualizaciones que se realizan sobre una base de
datos que está compuesta por las siguientes tablas:
    PROYECTO (COD_PROY, NOMBRE, PRESUPUESTO)
    DEPARTAMENTO (COD_DPTO, NOMBRE, DIRECCION, NUM_EMPLEADOS)
Para ello, se crea una tabla donde se registrará cada acción que se realice sobre las
tablas anteriores. Dicha tabla tendrá el siguiente esquema:
    REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION)
En la tabla REGISTRO se incluirá una tupla por cada acción que se realice en las
tablas anteriores y que contendrá los siguientes atributos:
    - Fecha en la que se ha realizado la modificación
    - Usuario que ha realizado la acción
    - Nombre de la tabla modificada (PROYECTO o DEPARTAMENTO)
    - Clave de la tupla insertada, cambiada o borrada
    - Acción que se ha realizado (INSERT, UPDATE o DELETE)
Una vez creadas las tablas, crear mediante los mecanismos de control del PL/SQL
los dos disparadores necesarios para registrar los datos de modificación en cada una
de las tablas PROYECTO y DEPARTAMENTO. Consultar el contenido de la tabla
REGISTRO para comprobar que los disparadores han funcionado correctamente
*/

CREATE TABLE PROYECTO (
    COD_PROY INTEGER PRIMARY KEY,
    NOMBRE VARCHAR(20),
    PRESUPUESTO INTEGER
);

CREATE TABLE DEPARTAMENTO (
    COD_DPTO INTEGER PRIMARY KEY,
    NOMBRE VARCHAR(20),
    DIRECCION VARCHAR (50),
    NUM_EMPLEADOS INTEGER
);

CREATE TABLE REGISTRO (
    ID INTEGER PRIMARY KEY,
    FECHA DATE,
    USAUARIO VARCHAR(20),
    TABLA VARCHAR(10),
    COD_ITEM INTEGER,
    ACCION VARCHAR(10)
);

CREATE OR REPLACE TRIGGER TABLA_REGISTRO_PROYECTO
BEFORE DELETE OR INSERT OR UPDATE ON PROYECTO
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
        VALUES (:new.ID, SYSDATE, user, 'PROYECTO', :new.COD_ITEM, 'INSERT');
    END IF;
    IF DELETING THEN
        INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
        VALUES (:new.ID, SYSDATE, user, 'PROYECTO', :new.COD_ITEM, 'DELETE');
    END IF;
    IF UPDATING THEN
        INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
        VALUES (:new.ID, SYSDATE, user, 'PROYECTO', :new.COD_ITEM, 'UPDATE');
    END IF;
EXCEPTION
    WHEN others THEN raise_application_error (-20100, 'ERROR#' || sqlcode || 'desc#: ' || sqlerrm);
END;
/

CREATE OR REPLACE TRIGGER TABLA_REGISTRO_DEPARTAMENTO
BEFORE DELETE OR INSERT OR UPDATE ON DEPARTAMENTO
FOR EACH ROW
BEGIN
IF INSERTING THEN
    INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
    VALUES (:new.ID, SYSDATE, user, 'DEPARTAMENTO', :new.COD_ITEM, 'INSERT');
END IF;
IF DELETING THEN
    INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
    VALUES (:new.ID, SYSDATE, user, 'DEPARTAMENTO', :new.COD_ITEM, 'DELETE');
END IF;
IF UPDATING THEN
    INSERT INTO REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION) 
    VALUES (:new.ID, SYSDATE, user, 'DEPARTAMENTO', :new.COD_ITEM, 'UPDATE');
END IF;
EXCEPTION
    WHEN others THEN raise_application_error (-20100, 'ERROR#' || sqlcode || 'desc#: ' || sqlerrm);
END;
/   