/*
1. Aumentar en 3 el número de ejemplares del libro con ISBN 5025496 para la
sucursal 9. Comprobar que la actualización ha sido correcta.
*/

SELECT num_ejemplares, num_disponibles FROM DISPONE WHERE ISBN = 5025496 AND cod_suc = 9;

UPDATE DISPONE SET num_ejemplares = num_ejemplares + 3, num_disponibles = num_disponibles + 2
WHERE ISBN = 5025496 AND cod_suc = 9;

SELECT num_ejemplares, num_disponibles FROM DISPONE WHERE ISBN = 5025496 AND cod_suc = 9;


/*
2. El lector con código 7395860 ha cambiado su dirección a la C/Sevilla, 1 de
Aldeadávila en la provincia de Salamanca. Actualice sus datos en la base de datos.
*/

SELECT direccion, poblacion, provincia FROM LECTOR WHERE codigo = 15838332;

UPDATE LECTOR 
SET direccion = 'C/Sevilla, 1', poblacion = 'Aldeadavila', provincia = 'Salamanca'
WHERE codigo = 15838332;

SELECT direccion, poblacion, provincia FROM LECTOR WHERE codigo = 15838332;

/*
3. Actualizar la tabla SUCURSAL la sucursal con código 15 para que pase a estar
ubicada en la ciudad de SEGOVIA con dirección en C/ SAN AGUSTÍN, 10.
*/

SELECT * FROM SUCURSAL WHERE codigo = 15;

UPDATE SUCURSAL 
SET provincia = 'Segovia', direccion = 'C/SAN AGUSTIN, 10' 
WHERE codigo = 15;

SELECT * FROM SUCURSAL WHERE codigo = 15;

/*
4. Actualizar la dirección de los lectores con códigos 71259836 y 94246322 a Av. de
Alemania, 49, Miajadas, Cáceres y Daoiz y Velarde, 24, Benavente, Zamora,
respectivamente.
*/

SELECT * FROM LECTOR WHERE codigo = 71259836 OR codigo = 94246322;

UPDATE LECTOR
SET direccion = 'AVD/Alemania, 49', poblacion = 'Miajadas', provincia = 'Caceres'
WHERE codigo = 71259836;
UPDATE LECTOR
SET direccion = 'Daoiz y Velarde, 24', poblacion = 'Benavente', provincia = 'Zamora'
WHERE codigo = 94246322;

SELECT * FROM LECTOR WHERE codigo = 71259836 OR codigo = 94246322;

/*
5. Se acaban de comprar 15 ejemplares, 1 para cada una de las 15 sucursales, del
premio Planeta 2001 titulada ‘EL PREMIO ERES TÚ’ con ISBN 8408104829
escrita por de Javier Moro (Madrid, 1955) y publicada por la editorial Planeta en el
2001. Realizar su inserción en el sistema añadiendo los datos correspondientes en
todas las tablas que sea necesario.
*/

INSERT INTO AUTOR (codigo, nombre, apellido, ano_nac, cod_nacion)
VALUES (159, 'JAVIER', 'MORO', 1955, 9);
INSERT INTO ESCRIBE VALUES (159, 8408104829);
INSERT INTO EDITORIAL VALUES (12, 'PLANETA');
INSERT INTO LIBRO VALUES (8408104829, 'EL PREMIO ERES TÚ', 2011, 12);
INSERT INTO DISPONE VALUES (1, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (2, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (3, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (4, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (5, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (6, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (7, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (8, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (9, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (10, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (11, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (12, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (13, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (14, 8408104829, 1, 1);
INSERT INTO DISPONE VALUES (15, 8408104829, 1, 1);

/*
6. Añadir una nueva sucursal en la ciudad de Soria, en la dirección “Calle de los
Caballeros, 32”. Esta sucursal tendrá asociado el código 16.
*/

INSERT INTO SUCURSAL VALUES (16, 'Calle de los Caballeros, 32', 'Soria', 'Soria');

SELECT * FROM SUCURSAL WHERE codigo = 16;

/*
7. La nueva sucursal creada en la ciudad de Soria en el ejercicio anterior, se dota con
los mismos ejemplares que tiene la sucursal 2.
*/

INSERT INTO DISPONE (SELECT s.codigo, isbn, num_ejemplares FROM SUCURSAL s, DISPONE d
WHERE s.codigo = 16 AND d.cod_suc = 2);

/*
8. El lector Francisco Roldán se ha dado de baja en la biblioteca, por tanto debe ser
dado de baja en la base de datos. (Atención, deberá dar de baja todos los registros
que tengan que ver con ese alumno en todas las tablas y además en el orden
adecuado).
*/

DELETE FROM PRESTAMO WHERE codigo = (SELECT codigo FROM LECTOR 
WHERE nombre = 'Francisco' AND ape_1 = 'Roldán');
DELETE FROM LECTOR WHERE nombre = 'Francisco' AND ape_1 = 'Roldán';

/*
9. Incrementar en dos unidades disponibles por sucursal el libro del que más préstamos
se realizan.
*/

UPDATE DISPONE SET num_ejemplares = num_ejemplares  + 2, num_disponibles = num_disponibles + 2
WHERE isbn IN (SELECT isbn FROM PRESTAMO p GROUP BY isbn HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM PRESTAMO GROUP BY isbn));

/*
10. Realizar un incremento en 1 ejemplar en todas las sucursales de aquellos libros para
los se han contabilizado más de 4 préstamos.
*/

UPDATE DISPONE
SET num_ejemplares = num_ejemplares + 1, num_disponibles = num_disponibles + 1
WHERE isbn IN (SELECT isbn FROM PRESTAMO p GROUP BY cod_suc, isbn HAVING COUNT(*) > 4);

/*
11. Eliminar todos los préstamos de los lectores de la provincia de Zamora.
*/

DELETE FROM PRESTAMO 
WHERE codigo IN (SELECT codigo FROM LECTOR WHERE poblacion = 'Zamora');
