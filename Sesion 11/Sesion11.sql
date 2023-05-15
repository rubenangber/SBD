/*
1. Desde la shell de MongoDB, ejecutar el comando use biblioteca.
Listar las colecciones que haya y, si hay alguna, eliminarlas.
*/

/*
2. Ejecutar el archivo cargaautor.js: load("Path_de_cargaautor.js").
Es importante tener en cuenta que si el path incluye el caracteres de barra invertida ("\""),
éstos se deberen escribir duplicados.
*/

/*
3.	Ver el contenido completo de la tabla AUTOR. 
Observar que no todos los autores tienen añoo de fallecimiento
y que, incluso, algunos no tienen apellido.
*/

db.AUTOR.find()

/*
4. Obtener los datos de ARISTOTELES.
*/

db.AUTOR.find({"NOMBRE":"ARISTOTELES"})

/*
5. Obtener los datos se SANTIAGO POSTEGUILLO.
*/

db.AUTOR.find({"NOMBRE":"SANTIAGO", "APELLIDO":"POSTEGUILLO"})
db.AUTOR.find({$and:[{"NOMBRE":"SANTIAGO"}, {"APELLIDO":"POSTEGUILLO"}]})

/*
6. Obtener los datos de FERNANDO DE ROJAS.
Observar que los documentos obtenidos en estas tres últimas consultas
 no tienen todos los mismos campos.
*/

db.AUTOR.find({"NOMBRE":"FERNANDO", "APELLIDO":"DE ROJAS"})

/*
7. Obtener los apellidos de todos los autores llamados MARIO.
*/

db.AUTOR.find({"NOMBRE":"MARIO"}, {"APELLIDO":1})

/*
8. Obtener los títulos de los libros escritos por los autores de la consulta anterior.
*/

db.AUTOR.find({"NOMBRE":"MARIO"}, {"APELLIDO":1, "LIBROS.TITULO":1, "_id":0})

/*
9. Obtener los datos de los autores británicos anteriores al siglo XX.
*/

db.AUTOR.find({"NACION":"REINO UNIDO", "ANO_FALL":{$lt:1900}})

/*
10.	Obtener los nombres, apellidos y año de nacimiento de
los autores argentinos del siglo XX o españoles del siglo XIX.
*/

db.AUTOR.find({$or:[{"NACION":"ARGENTINA", "ANO_NAC":{$gte:1900, $lt:2000}}, 
        {"NACION":"ESPANA", "ANO_NAC":{$gte:1800, $lt:1900}}]},
        {"NOMBRE":1, "APELLIDO":1, "ANO_NAC":1, "NACION":1, "_id":0})

/*
11.	Obtener los nombres de los autores que han fallecido
*/

db.AUTOR.find({"ANO_FALL":{$exists:true}})

/*
12.	Obtener los nombres de los autores franceses que están vivos
*/

db.AUTOR.find({"NACION":"FRANCIA", "ANO_FALL":{$exists:false}}, {"NOMBRE":1, "APELLIDO":1, "_id":0})

/*
13. Obtener los autores que no sean ni italianos ni alemanes
*/

db.AUTOR.find({"NACION":{"$nin":["ITALIA", "ALEMANIA"]}}, {"NOMBRE":1, "APELLIDO":1, "NACION":1, "_id":0}).sort({"NACION":1})

db.AUTOR.find({"NACION":{$not:{"$in":["ITALIA", "ALEMANIA"]}}}, {"NOMBRE":1, "APELLIDO":1, "NACION":1, "_id":0}).sort({"NACION":1})

db.AUTOR.find({"$and":[{"NACION":{"$ne":"ITALIA"}}, {"NACION":{"$ne":"ALEMANIA"}}]}, {"NOMBRE":1, "APELLIDO":1, "NACION":1, "_id":0}).sort({"NACION":1})

/* 
14. Obtener la información del autor de "LA DIVINA COMEDIA"
*/

db.AUTOR.find({"LIBROS.TITULO":"LA DIVINA COMEDIA"})

/*
15.	Añade al autor JAVIER SIERRA los datos de su libro 
"El fuego invisible", con ISBN 9788408178941, editado en 2017.
*/

db.AUTOR.update({"APELLIDO":"SIERRA"}, {$push:{"LIBROS":{"TITULO":"EL FUEGO INVISIBLE", "ISBN":"9788408178941", "ANO_EDICION":2017}}})

/*
16.	Añade una nueva autora a la base de datos: Ayanta Barilli, 
de nacionalidad españoola e italiana, nacida en 1969 y 
autora de los libros "Pacto de sangre", editado en 2013 y 
"Un mar violeta oscuro", editado por Planeta en 2018. 
*/

db.AUTOR.insert({"NOMBRE":"AYANTA", "APELLIDO":"BARILLI", "ANO_NAC":1969, "NACION":["ESPANA", "ITALIA"],
   LIBROS:[{"TITULO":"PACTO DE SANGRE", "ANO_EDICION":2013}, {"TITULO":"UN MAR VIOLETA OSCURO", "ANO_EDICION":2018}]})

/*
17.	Elimina la información del primero de los libros indicados en el ejercicio anterior.
*/

db.AUTOR.update({"NOMBRE":"AYANTA"}, {$pop:{"LIBROS":-1}})

/*
18.	Cambia el año de nacimiento de Ayanta Barilli a 1969.
*/

db.AUTOR.update({"NOMBRE":"AYANTA"}, {$set:{ANO_NAC:1969}})

/*
19.	Elimina todos los datos de QUEVEDO
*/

db.AUTOR.remove({"APELLIDO":"QUEVEDO"})

/*
20.	Elimina la colección AUTOR
*/

db.AUTOR.drop()

/*
21. Comprueba que ya no existe la base de datos biblioteca
*/

show databases