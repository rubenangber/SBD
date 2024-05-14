SET SERVEROUTPUT ON
DECLARE 
    NUM1 NUMBER;
    NUM2 NUMBER;
    NUM3 NUMBER;
    MEDIA NUMBER;
BEGIN
    NUM1 := &1;
    NUM2 := &2;
    NUM3 := &3;
    MEDIA := (NUM1 + NUM2 + NUM3) / 3;
    DBMS_OUTPUT.PUT_LINE('La media de los numeros es >> ' || MEDIA);
END;
/