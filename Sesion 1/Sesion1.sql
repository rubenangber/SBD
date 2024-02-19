/*START Sesion1*/

/*
1. Mandar los resultados de realizar la siguiente consulta a un fichero de cola al que
daremos el nombre que estimemos. Devolver el nombre y los apellidos de todos los
lectores que vivan en Salamanca y hayan realizado préstamos en el 2011. Para ello
será necesario en SQL*Plus
    a. Mandar el Spool al fichero de cola identificado con el nombre elegido
    b. Realizar la consulta
    c. Cerrar el Spool y comprobar que ha sido cerrado
    d. Verificar que tenemos un archivo *.lst generado
*/

spool Ejercicio1
ttitle 'Lectores de Salamanca con prestamos en 2011'
SELECT DISTINCT nombre, ape_1, ape_2 FROM LECTOR l, PRESTAMO p WHERE l.codigo = p.cod_lector AND 
to_char(fecha_ini, 'YYYY') = 2011 AND poblacion = 'SALAMANCA';
ttitle OFF
spool OFF

/*
2. Generar un fichero de comandos que realice un listado de todos los préstamos
ordenados por sucursales y para cada sucursal ordenar dichos préstamos
cronológicamente.
*/

spool Ejercicio2 SET echo OFF
ttitle 'Listado de préstamos ordenados por sucursal y fecha'
SELECT * FROM PRESTAMO p ORDER BY p.cod_suc, fecha_ini;
ttitle OFF
spool OFF
show spool

/*
3. Guardar en un fichero de comandos a través del comando save la siguiente
consulta: mostrar la información de todos los autores de los que o bien no se conoce
su fecha de nacimiento o de muerte. Para ello será necesario
    a. Realizar la consulta en el entorno de SQL*Plus
    b. Salvar el contenido del buffer indicando el nombre del fichero
    save nombre
    c. Verificar que se ha creado correctamente el archivo generado
    nombre.sql
*/

spool Ejercicio3
SELECT * FROM AUTOR WHERE ano_nac IS NULL OR ano_fall IS NULL;
spool OFF
SAVE Ejercicio3

/*
4. Volver a cargar el fichero de comandos del ejercicio anterior y ejecutarlo activando
la visualización del contenido a través del comando echo
*/

SET echo ON @Ejercicio3

/*
5. Volver a realizar un archivo de comandos que saque el listado de todos los libros
con los que cuenta la sucursal 1, 2 y 3 ordenados por ISBN y por sucursal,
estableciendo pausas para su mejor visualización a través del comando pause.
*/

SET PAUSE 'Pulse alguna tecla para continuar' 
SET PAUSE ON
SELECT l.isbn, cod_suc, titulo FROM LIBRO l, DISPONE d WHERE l.isbn = d.isbn
AND cod_suc in (1, 2, 3) ORDER BY l.isbn, cod_suc;

/*
6. Volver a realizar un archivo de comandos que saque el listado de todos los libros
con los que cuenta una sucursal, cuyo código se pasará como parámetro, ordenados
por ISBN, estableciendo pausas para su mejor visualización a través del comando
pause.
*/

SET PAUSE 'Pulse alguna tecla para continuar' 
SET PAUSE ON
spool Ejercicio6 
ttitle 'Listado de libros de una sucursal &1'
SELECT l.isbn, titulo FROM LIBRO l, DISPONE d WHERE l.isbn = d.isbn AND
cod_suc = &1 ORDER BY l.isbn;
ttitle OFF
spool OFF

/*
7. Sacar la información de todos los autores de los que o bien no se conoce su fecha de
nacimiento o de muerte indicando además su nacionalidad y no el código de ésta.
*/

SELECT a.nombre, apellido, ano_nac, ano_fall, n.nombre FROM AUTOR a, NACIONALIDAD n
WHERE a-cod_nacion = n.codigo AND (ano_nac IS NULL OR ano_nac IS NULL);

/*
8. Ejecutaremos la consulta anterior con un formato que genere una salida más legible:
    a. Seleccione un tamaño de página igual a 50
    b. Seleccione un tamaño de línea igual a 80
    c. Añada un título en la parte superior de la página con el texto ‘Informe de
    autores’ y ‘con fechas no conocidas’ en dos líneas separadas.
    d. Añada un pie de página con el texto ‘SERVICIO DE BIBLIOTECAS’
    e. Formatee el apellido para que ocupe exactamente 12 caracteres.
    f. Formatee el nombre de las columnas ANO_NAC y ANO_FALL para
    que se muestre en cada caso el título ANO NACIMIENTO o ANO
    MUERTE en dos líneas separadas.
    g. Formatee la nacionalidad empleando NACION como título y fijando la
    longitud de los datos en 15 caracteres.
*/

SET pagesize 50
SET linesize 80
title 'INFORME DE AUTORES | CON FECHAS NO CONOCIDAS'
btitle 'SERVICIO DE BIBLIOTECAS' column nombre 
format a12 column apellido 
format a12 column ano_nac wrap heading 'ANO NACIMIENTO' column ano_ fall wrap heading 'ANO|MUERTE' 
SET PAUSE 'Una tecla...' 
SET PAUSE ON 
column nombre format a15 heading 'NACION'
SELECT a.nombre, apellido, ano_nac, ano_fall, n.nombre FROM AUTOR a, NACIONALIDAD n 
WHERE a.cod_nacion = n.codigo AND (ano_fall IS NULL OR ano_nac IS NULL); 
title OFF 
btitle OFF 
CLEAR columns
SET PAUSE OFF

/*
9. Volver a realizar la consulta anterior insertando ‘???’ en los lugares donde no se
conoce la fecha de nacimiento o defunción de los autores.
*/

SET pagesize 50
SET linesize 80
ttitle 'INFORME DE AUTORES | CON FECHAS NO CONOCIDAS'
btitle 'SERVICIO DE BIBLIOTECAS' column nombre
format a12 column apellido
format a12 column ano_nac wrap heading 'ANO | NACIMIENTO' NULL '???'
column ano_fall wrap heading 'ANO | MUERTE' NULL '???'
SET PAUSE 'Pulse una tecla ' 
SET PAUSE ON
column nombre format a15 heading 'NACION'
SELECT a.nombre, apellido, ano_nac, ano_fall, n.nombre FROM AUTOR a, NACIONALIDAD n
WHERE a.cod_nacion = n.codigo AND (ano_fall IS NULL OR ano_nac IS NULL);
ttitle OFF
btitle OFF 
CLEAR columns
SET PAUSE OFF