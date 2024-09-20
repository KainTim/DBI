DECLARE
NUMBER# VARCHAR2(10);
BEGIN
NULL;
END;
/
-- Aufgabe 2.1
-- a, b, d, e, g, h

--Aufgabe 2.2
DECLARE
by_when DATE:= SYSDATE+1;
BEGIN
NULL;
END;
/
--a, d

--Aufgabe 2.3
-- a

--Aufgabe 2.4
DECLARE
today DATE :=SYSDATE;
tomorrow today%TYPE;
BEGIN
tomorrow := today+1;

DBMS_OUTPUT.PUT_LINE('Hello World '|| today || ' '|| tomorrow);
End;
/

--Aufgabe 2.5
DECLARE
   pi CONSTANT NUMBER := 3.1415;
   v_kreis_umfang NUMBER(10, 4);
   v_kreis_flaeche NUMBER(10, 4);
   v_kugel_oberflaeche NUMBER(10, 4);
   v_kugel_volumen NUMBER(10, 4);
   v_radius NUMBER(10, 4):= 5;
BEGIN
   v_kreis_umfang := 2 * pi * v_radius;
   v_kreis_flaeche := pi * v_radius * v_radius;
   v_kugel_oberflaeche := 4 * pi * v_radius * v_radius;
   v_kugel_volumen := (4 / 3) * pi * v_radius * v_radius * v_radius;
   DBMS_OUTPUT.PUT_LINE('Kreisumfang: ' || v_kreis_umfang || ' Einheiten');
   DBMS_OUTPUT.PUT_LINE('Kreisfläche: ' || v_kreis_flaeche || ' Quadrat-Einheiten');
   DBMS_OUTPUT.PUT_LINE('Kugeloberfläche: ' || v_kugel_oberflaeche || ' Quadrat-Einheiten');
   DBMS_OUTPUT.PUT_LINE('Kugelvolumen: ' || v_kugel_volumen || ' Kubik-Einheiten');
END;
/

--Aufgabe 2.6
DECLARE
v_day VARCHAR2( 20 ) ;
BEGIN
v_day := TO_CHAR(SYSDATE-2, 'FMDay, HH24:MI' ) ;
DBMS_OUTPUT. PUT_LINE ( 'Today is '|| v_day ) ;
END;