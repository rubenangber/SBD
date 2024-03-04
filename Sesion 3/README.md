# Lenguaje de definición de datos, DDL

## INDEX
Un índice es una estructura asociada con una tabla o una vista que acelera la recuperación de filas de la tabla o de la vista <br>
```
CREATE [UNIQUE] INDEX nombre_index
ON tabla (columna1, columna2, columna3...);
```
UNIQUE indica que no se aceptarán valores duplicados en el conjunto de las columnas que forman el índice (UNIQUE se utiliza al diseñar la estructura de la base de datos para garantizar la unicidad de los valores en una columna o conjunto de columnas, mientras que DISTINCT se usa en consultas SELECT para filtrar y obtener valores únicos en el conjunto de resultados de una consulta) <br>

## VIEW
Define una tabla virtual cuyo contenido será el resultado de la ejecución de la sentencia SELECT <br>
```
CREATE VIEW nombre_view (columna1, columna2...)
AS (sentencia_select)
[WITH CHECK OPTION]
[WITH READ ONLY];
```
WITH CHECK OPTION, garantiza que las filas que se insertan o actualizan a través de la vista cumplan con la condición especificada en la cláusula WHERE de la vista <br>
WITH READ ONLY, indica que la vista es de solo lectura y no se pueden realizar operaciones de inserción, actualización o eliminación a través de la vista <br>

## SYNONYM
Crea un sinónimo/alias (un nombre alternativo) para una tabla, vista o índice <br>
```
CREATE SYNONYM nombre_synonym
FOR (tabla / view / index);
```

## SEQUENCE
Es un mecanismo para obtener listas de números secuenciales, pueden ser utilizadas para obtener valores que s epuedan usar como claves primarias <br>
```
CREATE SEQUENCE nombre_sequence
[INCREMENT BY incremento] [START WITH inicio];
```
Ejemplo:
```
create table mitabla (
    codigo integer not null primary key,
    otro integer
);

create sequence clave_mitabla;

insert into mitabla
values (clave_mitabla.nextval, 55);

insert into mitabla
values (clave_mitabla.nextval, 23);
```

## DROP
Se utiliza para eliminar objetos de la base de datos, como tablas, vistas, índices, procedimientos almacenados, y otros elementos
```
DROP (nombre_tabla / nombre_view / nombre_index / nombre_ synonym / nombre_sequence);
```

## PRIVILEGIOS
Al crear una tabla o vista, el propietario es el único que puede acceder a ella hasta que este no les conceda los privilegios de acceso, estos privilegios pueden ser: ```SELECT, UPDATE, DELETE, INSERT, INDEX, REFERENCES, ALTER, ALL```
```
GRANT (ALL PRIVILEGES) / privilegio1, privilegio2...
ON nombre_tabla / nombre_view...
TO PUBLIC / usuario1, usuario2...
[WITH GRANT OPTION];
```
WITH GRANT OPTION se refiere a la capacidad de un usuario para otorgar los mismos privilegios a otros usuarios. Al utilizar WITH GRANT OPTION, estás permitiendo que el usuario al que le estás otorgando los privilegios tenga la capacidad de otorgar esos mismos privilegios a otros usuarios