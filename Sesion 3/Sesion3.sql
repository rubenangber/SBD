/*
1. Se ha observado que una parte importante de las consultas a la base de datos que
requieren mejorar su eficiencia acceden a los datos de la tabla LECTOR según el
valor de la PROVINCIA. ¿Qué podemos hacer para mejorar los tiempos de
respuesta de dichas consultas?
*/

CREATE INDEX PROV_LECTOR ON LECTOR (provincia);


/*
2. Crear una vista para seleccionar los códigos de los préstamos activos (libros no
devueltos) junto a los códigos de los lectores.
*/

CREATE VIEW PRESTAMOSACT AS
SELECT codigo, cod_lector FROM PRESTAMO WHERE fecha_dev IS NULL;

/*
3. Crear una vista que liste los libros que se encuentran en la actualidad prestados,
incluyendo el ISBN y título. Generar dicha esta vista eliminando las filas
duplicadas.
*/

CREATE VIEW LIBROSPRESTAMO AS
SELECT DISTINCT l.isbn, titulo FROM PRESTAMO p, LIBRO l 
WHERE l.isbn = p.isbn AND fecha_dev IS NULL;

/*
4. Crear una vista para el fondo de préstamo de la sucursal 3, indicando el ISBN, título
del libro y el número de ejemplares asignados y disponibles para dicha sucursal.
*/

CREATE VIEW LIBROSUC3 AS
SELECT l.isbn, titulo, num_ejemplares, num_disponibles FROM LIBRO l, DISPONE dado
WHERE l.isbn = d.isbn AND cod_suc = 3;

/*
5. Crear una vista que liste todas las columnas de la tabla PRESTAMO para aquellos
prestamos finalizados en la sucursal 1.
*/

CREATE VIEW FINSUC1 AS
SELECT * FROM PRESTAMO 
WHERE fecha_dev IS NOT NULL AND cod_suc = 1;

/*
6. Usar la vista anterior para insertar una nueva tupla en la tabla PRESTAMO
correspondiente a un préstamo de la sucursal 4. Comprobar la diferencia de
comportamiento si la vista está creada con la claúsula WITH CHECK OPTION o
no.
*/



/*
7. Modificar la vista anterior de forma que no pueda realizarse ninguna modificación
sobre ella. Intentar borrar con esa vista los préstamos finalizados hace más de 5
años. ¿Cuál es la salida?
*/



/*
8. Examínese la diferencia entre tener un privilegio sobre una tabla y tenerlo sobre una
vista definida sobre esa tabla. En especial, la manera en que un usuario puede tener
un privilegio (por ejemplo SELECT) sobre una vista sin tenerlo también sobre todas
las tablas subyacentes.
*/



/*
9. Crear un sinónimo para la tabla dispone y hacer uso de él para consultar un listado
por sucursal de los ISBN que tienen a su disposición.
*/



/*
10. Un análisis de la base de datos muestra que es necesario añadir un campo más a la
tabla sucursal, para almacenar el nombre de la sucursal. Haga una copia de la tabla
sucural y posteriormente, realice en esa tabla las operaciones necesarias para incluir
el nuevo dato.
*/



/*
11. Se desea disponer de una nueva tabla AUTORESP que contenga información de los
autores de nacionalidad española. En esa tabla, cada autor tendrá un nuevo atributo
que llamaremos CodAutorEsp que será la clave primaria de esa tabla. El valor del
atributo CodAutorEsp no tiene por qué coincidir con el código que el autor tenga en
la tabla AUTOR. El valor de este código se generará de manera automática
mediante una secuencia.
a. Crear la secuencia necesaria.
b. Crear la tabla que contenga los siguientes atributos: CodAutorEsp,
Nombre, Apellido.
c. Rellenar la nueva tabla con los datos de los escritores españoles que se
obtengan de la tabla AUTOR.
*/



/*
12. Crear una relación ANUNCIO que permita que los distintos usuarios de la base de
datos inserten anuncios de cualquier tipo. El esquema de la relación será:
ANUNCIO (Codigo, autor, texto). El Código deberá ser único y creado
automáticamente mediante una secuencia. El atributo autor se rellenará por defecto
con el user de quien realice la inserción. Se darán permisos para que cualquier
usuario pueda hacer insercciones y consultas en la tabla. Probar a insertar alguna
tupla en nuestra tabla y también en la creada por algún compañero.
*/



/*
13. Crear una vista MISANUNCIOS que recupere los datos de los anuncios cuyo autor
coincida con el usuario que está consultando la vista. Dar los permisos adecuados a
dicha vista. Realizar las pruebas del funcionamiento de esta vista cooperando con un
compañero. Hay que recordar que varios usuarios pueden crear objetos con el
mismo nombre y que se puede acceder a los objetos creados por otros usuarios
mediante esquema.objeto, siendo esquema el usuario propietario del objeto.
*/



/*
14. Eliminar todos los índices, vistas, tablas, sinónimos y secuencias creados en los
ejercicios anteriores.
*/