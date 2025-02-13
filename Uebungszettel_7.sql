-- Aufgabe 7.1
DECLARE
  v_num NUMBER := &sv_num;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Square root of '||v_num||
  ' is '||SQRT(v_num));

EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;
/

--a) Was wird ausgegeben, wenn das Skript einmal mit 4 und -4 ausgeführt wird
--  4: Square root of 4 is 2
-- -4: An error has occured

--b) Wieso ist der zweite Durchlauf anders?
--  Der zweite Durchlauf ist anders, weil die Funktion SQRT keine negative Zahlen akzeptiert.

--c) Angenommen es gibt keine VALUE-ERROR Exception. Wie müsste das Skript umgebaut werden, um den Fehler zu behandeln/vermeiden?
-- Man müsste mit einem IF vorher schauen, ob die Zahl negativ ist.



-- Aufgabe 7.2
DECLARE
  v_exists NUMBER(1);
  v_total_students NUMBER(1);
  v_zip CHAR(5):= '&sv_zip';
BEGIN
  SELECT count(*)
  INTO v_exists
  FROM zipcode
  WHERE zip = v_zip;

  IF v_exists != 0 THEN
    SELECT COUNT(*)
    INTO v_total_students
    FROM student
    WHERE zip = v_zip;
    
	DBMS_OUTPUT.PUT_LINE('There are '||v_total_students||' students');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_zip||' is not a valid zip');
  END IF;

EXCEPTION
  WHEN VALUE_ERROR OR INVALID_NUMBER THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;
/

--a) Was wird ausgegeben, wenn das Skript für 07024, 00914 und 12345 aufgerufen wird.
--  07024: There are 1 students
--  00914: 00914 is not a valid zip
--  12345: 12345 is not a valid zip

--b) Wieso wurde keine Exception geworfen?
-- Da wir vorher im IF geschaut haben, ob die Zahl existiert und wir auch das richtige Format eingegeben haben.

--c) Füge folgenden Studenten hinzu
INSERT INTO student (student_id, salutation, first_name,
last_name, zip, registration_date, created_by, created_date,
modified_by, modified_date)
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'Mr.', 'John', 'Smith', '07024',
SYSDATE, 'STUDENT', SYSDATE, 'STUDENT', SYSDATE); COMMIT;

--d) Führe nach dem Hinzufügen aus Schritt c. das Skript mit 07024 aus. Wieso ändert sich jetzt das Ergebnis?
-- Error, weil Exists nur eine Stelle hat und der eingefügt Student der 10. existierende Schüler wäre.

--e)Ändere das Skript so, dass nun Vor- und Nachname des ersten Studenten für die angegeben 
--PLZ anstelle der Gesamtanzahl ausgegeben wird. (vgl. rownum) — Achte dabei auf korrektes
--Error-Handling!

DECLARE
    v_exists NUMBER(1);
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_zip CHAR(5) := '&sv_zip';
BEGIN
    SELECT count(*)
    INTO v_exists
    FROM zipcode
    WHERE zip = v_zip;

    IF v_exists != 0 THEN
        BEGIN
            SELECT first_name, last_name
            INTO v_first_name, v_last_name
            FROM STUDENT
            WHERE zip = v_zip AND ROWNUM = 1;

            DBMS_OUTPUT.PUT_LINE('First student: ' || v_first_name || ' ' || v_last_name);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No students found for zip ' || v_zip);
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_zip || ' is not a valid zip');
    END IF;

EXCEPTION
    WHEN VALUE_ERROR OR INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('An error has occurred');
END;
/

-- Aufgabe 7.3
DECLARE
    v_student_id NUMBER(10) := '&sv_user_id';
    v_first_name VARCHAR2(50);
BEGIN
    SELECT first_name
    INTO v_first_name
    FROM STUDENT
    WHERE student_id = v_student_id;

    DBMS_OUTPUT.PUT_LINE('Is here: ' || v_first_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
    INSERT INTO student (STUDENT_ID, salutation, first_name,
    last_name, zip, registration_date, created_by, created_date,
    modified_by, modified_date)
    VALUES (v_student_id, 'Mr.', 'John', 'Smith', '07024',
    SYSDATE, 'STUDENT', SYSDATE, 'STUDENT', SYSDATE); COMMIT;
END;
/


-- Aufgabe 7.4
DECLARE
    v_instructor_id NUMBER := &sv_instructor_id;
    v_sections_count NUMBER;
    v_firstname VARCHAR2(50);
BEGIN
    SELECT COUNT(*), first_name
    INTO v_sections_count, v_firstname
    FROM instructor
    INNER JOIN SECTION USING(instructor_id) 
    WHERE instructor_id = v_instructor_id
    GROUP BY first_name;

    DBMS_OUTPUT.PUT_LINE('Sections: ' || v_sections_count);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for instructor ID: ' || v_instructor_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error has occurred');
END;
/

-- Aufgabe 7.5
DECLARE
  v_zip VARCHAR2(5) := '&sv_zip';
  v_total NUMBER(1);

-- outer block
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Check if provided zipcode is valid');

  SELECT zip
  INTO v_zip
  FROM zipcode
  WHERE zip = v_zip;

  -- inner block
  BEGIN
    
	SELECT count(*)
    INTO v_total
    FROM student
    WHERE zip = v_zip;

    DBMS_OUTPUT.PUT_LINE ('There are '||v_total||' students for zipcode '||v_zip);
  END;

  DBMS_OUTPUT.PUT_LINE ('Done...');
END;
/

--a) Was wird ausgegeben, wenn das Skript für 07024 ausgeführt wird?
-- Es soll die v_total auf NUMBER(2) oder höher geändert werden, sodass kein Error mehr kommt. Danach würde folgendes ausgegeben werden:
--Check if provided zipcode is valid
--There are 11 students for zipcode 07024
--Done...

--b) Auf Basis der Ausgabe von a. welches Exception-Handling muss hinzugefügt werden?
-- EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--         DBMS_OUTPUT.PUT_LINE('No valid zipcode found: ' || v_zip);
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An error has occurred: ' || SQLERRM);


-- Aufgabe 7.6
DECLARE
  v_instructor_id NUMBER := &sv_instructor_id;
  v_tot_sections NUMBER;
  v_name VARCHAR2(30);
  e_too_many_sections EXCEPTION;

BEGIN
  SELECT COUNT(*)
  INTO v_tot_sections
  FROM section
  WHERE instructor_id = v_instructor_id;
  
  IF v_tot_sections >= 10 THEN
    RAISE e_too_many_sections;
  ELSE
    SELECT RTRIM(first_name)||' '||RTRIM(last_name)
    INTO v_name
    FROM instructor
    WHERE instructor_id = v_instructor_id;

    DBMS_OUTPUT.PUT_LINE ('Instructor, '||v_name||', teaches '||
    v_tot_sections||' sections');
  END IF;
EXCEPTION
  WHEN e_too_many_sections THEN
    DBMS_OUTPUT.PUT_LINE ('This instructor teaches too much');
END;
/

--a) Was wird ausgegeben, wenn das Skript für 101 und 102 ausgeführt wird?
--  101: This instructor teaches too much
--  102: Instructor, John Smith, teaches 2 sections

--b) Welche Anweisung löst die User-Defined Exception aus?
--  RAISE e_too_many_sections;

--c) Ändere das Skript so, dass auch der Nachname in der Fehlermeldung ausgegeben wird.
DECLARE
  v_instructor_id NUMBER := &sv_instructor_id;
  v_tot_sections NUMBER;
  v_name VARCHAR2(30);
  e_too_many_sections EXCEPTION;

BEGIN
  SELECT COUNT(*)
  INTO v_tot_sections
  FROM section
  WHERE instructor_id = v_instructor_id;

  SELECT RTRIM(first_name)||' '||RTRIM(last_name)
    INTO v_name
    FROM instructor
    WHERE instructor_id = v_instructor_id;

  IF v_tot_sections >= 10 THEN
    RAISE e_too_many_sections;
  ELSE
    SELECT RTRIM(first_name)||' '||RTRIM(last_name)
    INTO v_name
    FROM instructor
    WHERE instructor_id = v_instructor_id;

    DBMS_OUTPUT.PUT_LINE ('Instructor, '||v_name||', teaches '||
    v_tot_sections||' sections');
  END IF;
EXCEPTION
  WHEN e_too_many_sections THEN
    DBMS_OUTPUT.PUT_LINE ('This instructor ' || v_name || ' teaches too much');
END;
/

-- Aufgabe 7.7
DECLARE
  v_my_name VARCHAR2(15) := 'ELENA SILVESTROVA';

BEGIN
  DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);

  DECLARE
    v_your_name VARCHAR2(15);
  BEGIN
    v_your_name := '&sv_your_name';
    DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
  EXCEPTION
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
  END;

EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
    DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;
/

--a) Da der default wert für v_my_name zu lang ist, wird eine string buffer exception geworfen
--b) Nein es wird der Rest nicht ausgeführt
--c)
DECLARE
BEGIN
    DECLARE
    v_my_name VARCHAR2(15) := 'ELENA SILVESTROVA';

    BEGIN
    DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);

    DECLARE
        v_your_name VARCHAR2(15);
    BEGIN
        v_your_name := '&sv_your_name';
        DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
    EXCEPTION
        WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
        DBMS_OUTPUT.PUT_LINE ('This name is too long');
    END;

    EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
        DBMS_OUTPUT.PUT_LINE ('This name is too long');
    END;

EXCEPTION
    WHEN others THEN
    DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
    DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;
/

-- Aufgabe 7.8)
DECLARE
  v_section_id NUMBER := &sv_section_id;
  v_total_students NUMBER;
  e_too_many_students EXCEPTION;

BEGIN
  SELECT COUNT(*)
  INTO v_total_students
  FROM enrollment
  WHERE section_id = v_section_id;

  IF v_total_students >= 10 THEN
    RAISE e_too_many_students;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Number of students: ' || v_total_students);
  END IF;

EXCEPTION
  WHEN e_too_many_students THEN
    DBMS_OUTPUT.PUT_LINE('Too many students in section ' || v_section_id);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error has occurred.');
END;
/

-- Aufgabe 7.9)
DECLARE
BEGIN
  DECLARE
    v_my_name VARCHAR2(15) := 'ELENA SILVESTROVA';
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);

    DECLARE
      v_your_name VARCHAR2(15);
    BEGIN
      v_your_name := '&sv_your_name';
      DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
    EXCEPTION
      WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
        DBMS_OUTPUT.PUT_LINE ('This name is too long');
        RAISE; -- Reraise the exception to be handled by the outer block
    END;

  EXCEPTION
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the outer inner block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
      RAISE;
  END;

EXCEPTION
    WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE ('Error in the outer outer block');
    DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;