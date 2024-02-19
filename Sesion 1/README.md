# CREACIÓN DE INFORMES

### spool
Se vuelcan todos los resultados obtenidos desde el momento en que se habilita el “spool” hasta el momento en que se cierra. <br>

Para mandar los resultados de la proxima consulta ```spool <nombre_fichero>``` <br>
```spool Ejercicio1```

Para cerrar el fichero spool ```spool off``` <br>
Comprobar el estado del spool ```show spool``` <br>

### Archivos .sql
Se puden ejecutar los archivos de dos maneras: <br>
```START <archivo.sql> [<&argumentos>]``` <br>
```@<archivo.sql [<&argumentos>]>``` <br>
Se puede omitir el ".sql" a no ser que no sea esa extension, en ese caso habría que indicarlo <br>
Para salvar el contenido del buffer en un fichero .sql se usa: ```SAVE <nombre>``` si se desea sobreescribir el fichero: ```SAVE <nombre> REPLACE``` <br>
Limpiar el buffer: ```clear buffer``` <br>
Mostrar u ocultar el contenido del fichero de comandos que se va a ejecutar: ```SET echo ON/OFF``` (predeterminado OFF)<br>
Hacer pausas o no en la salida de un informe: ```SET pause ON/OF text``` (Predeterminado OFF)<br>
Ancho de la pagina, número máximo de carácteres por línea: ```SET linesize <tamaño>``` <br>
Longitud de la pagina, número de filas de la salida: ```SET linesize <tamaño>``` <br>
Título de pagina, este saldrá centrado, "|" se utiliza cuando queremos que el título aparezca en 2 lineas. Muestra la fecha y el número de pagina <br>
```
ttitle 'titulo | siguiente linea'
COMANDOS
ttitle OFF
```