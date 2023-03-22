/*
1. Obtener el número de sucursal, la dirección y provincia de las distintas sucursales de
la biblioteca.
*/

SET SERVEROUTPUT ON
DECLARE
    poblacion_suc SUCURSAL.poblacion%TYPE;
    provincia_suc SUCURSAL.provincia%TYPE;
    codigo_suc SUCURSAL.codigo%TYPE;
    CURSOR C1 IS SELECT codigo, poblacion, provincia FROM sucursal;
BEGIN
    DBMS_OUTPUT.PUT_LINE('DIRECCIÓN DE LAS SUCURSALES');
    DBMS_OUTPUT.PUT_LINE(rpad('CODIGO', 8, ' ') || ' ' || rpad('POBLACION', 15, ' ') || chr(9) || rpad('PROVINCIA',15, ' '));
 OPEN C1;
 LOOP
 FETCH C1 INTO codigo_suc, poblacion_suc, provincia_suc;
 EXIT WHEN C1%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(rpad(codigo_suc,8, ' ')|| ' ' || rpad(poblacion_suc, 15, ' ') || chr(9) || rpad(provincia_suc, 15, ' '));

END LOOP;
    CLOSE C1;
END;
/

/*
2. Realizar un programa en el que dada una provincia se indique qué sucursales y
poblaciones de dicha provincia existen para la biblioteca.
*/

SET SERVEROUTPUT ON
SET VERIFY ON
ACCEPT provincia PROMPT 'Introduzca la provincia, por favor: ';
DECLARE
    pobla_suc SUCURSAL.poblacion%TYPE;
    cod_suc SUCURSAL.codigo%TYPE;
    prov SUCURSAL.provincia%TYPE :=&provincia;
    CURSOR C1 IS SELECT codigo, poblacion FROM sucursal WHERE provincia = upper(prov);
BEGIN
2
DBMS_OUTPUT.PUT_LINE('CODIGO_SUC' || chr(9) || 'POBLACION_SUC');
    OPEN C1;
    LOOP
    FETCH C1 INTO cod_suc, pobla_suc;
    EXIT WHEN C1%NOTFOUND;  
    DBMS_OUTPUT.PUT_LINE(cod_suc || chr(9) || chr(9) || pobla_suc);  
    END LOOP;
    CLOSE C1;
END;
/

/*
3. Obtener un listado de los lectores que tienen actualmente en préstamo el libro con
identificado por su ISBN, desglosado por sucursales y ordenado alfabéticamente
dentro de cada sucursal.
*/

CREATE OR REPLACE PROCEDURE PRESTAMOSLIBRO (L_ISBN IN libro.isbn%TYPE) IS
suc PRESTAMO.cod_suc%TYPE;
suc_actual PRESTAMO.cod_suc%TYPE := 0;
nom LECTOR.nombre%TYPE;
ap1 LECTOR.ape_1%TYPE;
ap2 LECTOR.ape_2%TYPE;
CURSOR MICUR (miisbn libro.isbn%TYPE) IS
SELECT cod_suc, nombre, ape_1, ape_2 FROM univ.prestamo p, lector l
WHERE isbn=miisbn AND p.cod_lector=l.codigo AND p.fecha_dev IS NULL
ORDER BY cod_suc;
BEGIN
DBMS_OUTPUT.PUT_LINE(' ISBN: ' || L_isbn);
OPEN MICUR(L_ISBN);
LOOP
    FETCH micur INTO suc, nom, ap1, ap2;
    exit WHEN micur%notfound;
    IF suc <> suc_actual
    THEN
    suc_actual := suc;
    DBMS_OUTPUT.PUT_LINE(chr(9) || 'SUCURSAL: ' || suc );
    END IF;
    DBMS_OUTPUT.PUT_LINE(chr(9) || chr(9) || nom || ' ' || ap1 || ' ' || ap2);
    END LOOP;
    CLOSE MICUR;
END;
/
EXEC prestamosLibro (5024932)

/*
4. Obtener el expediente de préstamos realizados por un lector cualquiera del que se
conoce su código. En el expediente debe aparecer el código y nombre del lector y a
continuación un listado de los libros tomados en préstamo por orden cronológico de
la fecha en la que se inició dicho préstamo. El expediente mostrará el ISBN de
dichos libros, la fecha de devolución, si ha sido devuelto, y la sucursal en la que
realizó dicho préstamo. Al final de dicho expediente se dará el número total de
préstamos realizados y pendientes.
*/

CREATE OR REPLACE FUNCTION TOTALPRESTAMOSLECTOR (COD_L IN lector.codigo%TYPE)
RETURN INTEGER IS
    n INTEGER;
BEGIN
    SELECT count (*) INTO n FROM prestamo WHERE cod_lector=cod_l;
    RETURN n;
END;
/

CREATE OR REPLACE FUNCTION PRESTAMOSPENDIENTESLECTOR (COD_L IN lector.codigo%TYPE)
RETURN INTEGER IS
    n INTEGER;
BEGIN
    SELECT count (*) INTO n FROM prestamo WHERE cod_lector=cod_l
    AND fecha_dev IS NULL;
    RETURN n;
END;
/

CREATE OR REPLACE PROCEDURE PRESTAMOSLECTOR (COD_L IN lector.codigo%TYPE) IS
suc univ.prestamo.cod_suc%TYPE;
isbn univ.prestamo.isbn%TYPE;
f_i univ.prestamo.fecha_ini%TYPE;
f_d univ.prestamo.fecha_dev%TYPE;
nom lector.nombre%TYPE;
ap1 lector.ape_1%TYPE;
ap2 lector.ape_2%TYPE;
TotalPres INTEGER;
PresPend INTEGER;
5
CURSOR MICUR (lector lector.codigo%TYPE) IS
SELECT cod_suc, isbn, Fecha_ini, fecha_dev FROM univ.prestamo p
WHERE cod_lector=lector
ORDER BY fecha_ini;
BEGIN
SELECT nombre, ape_1, ape_2 INTO nom, ap1, ap2 FROM lector WHERE codigo = cod_l;
DBMS_OUTPUT.PUT_LINE(' CODIGO: ' || COD_L || chr(9) || ' NOMBRE: ' || nom || ' ' || ap1|| ' ' || ap2);
DBMS_OUTPUT.PUT_LINE('SUCURSAL ' || 'ISBN'|| chr(9) || 'FECHA_INICIO'|| chr(9) ||'FECHA_DEVOLUCION');
OPEN MICUR(COD_L);
LOOP
    FETCH micur INTO suc, isbn, f_i, f_d;
    exit WHEN micur%notfound;
    DBMS_OUTPUT.PUT_LINE(suc || chr(9) || isbn || chr(9) || f_i|| chr(9) || f_d);
END LOOP;
CLOSE MICUR;

TotalPres := TOTALPRESTAMOSLECTOR (COD_L);
PresPend := PRESTAMOSPENDIENTESLECTOR (COD_L);
DBMS_OUTPUT.PUT_LINE(' NUMERO TOTAL DE PRESTAMOS: '|| TotalPres || chr(9) || ' PENDIENTES: '|| PresPend );
END;
/
EXEC prestamoslector(94246322)