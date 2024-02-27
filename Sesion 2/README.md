# MODIFICACIÓN DE LA INFORMACIÓN

## ACTUALIZACIÓN
```
UPDATE tabla
SET columna = expresión {, columna = expresión }
[ WHERE condición ] ;
```
Si se omite la clausula ```WHERE``` se modificará todas las filas de la tabla <br>
Ejemplo:
```
UPDATE lector
SET direccion = 'RAMON Y CAJAL, 25'
WHERE codigo = 94246322;
```
<br>

## INSERCIÓN DE UNA FILA
```
INSERT INTO tabla [(lista_columnas)]
VALUES (lista_valores);
```
Si la tabla está relacionada con otra, se seguirán las reglas de integridad referencial <br>
Ejemplo:
```
INSERT INTO dispone
VALUES (4, ‘9789588640051’, 2, 2);
```

<br>

## INSERCIÓN DE VARIAS FILAS

```
INSERT INTO tabla [(lista_columnas)] subselect;
```
Ejemplo:
```
INSERT INTO dispone
SELECT s.codigo, ISBN, num_ejemplares,
num_ejemplares FROM sucursal s, dispone d
WHERE s.codigo = 16 and d.cod_suc = 5;
```

<br>

## ELIMINACIÓN
```
DELETE FROM tabla
[ WHERE condición ] ;
```
Si se omite la clausula ```WHERE``` se modificará (eliminaran) todas las filas de la tabla <br>
Ejemplo:
```
DELETE FROM lector
WHERE codigo = 7334556;
```