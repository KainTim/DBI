--4.1)
--a)
CREATE TABLE UEBUNG4 (
    ID NUMBER,
    NAME VARCHAR2(20)
);
--b)
CREATE SEQUENCE UEBUNG4_SEQ
START WITH 1
INCREMENT BY 5;
--c)
DECLARE
    v_name VARCHAR2(20);
    v_id NUMBER;
BEGIN
    -- Insert the student with the most enrollments
    INSERT INTO UEBUNG4 (ID, NAME)
    SELECT UEBUNG4_SEQ.NEXTVAL, NAME
    FROM students
    WHERE enrollments = (SELECT MAX(enrollments) FROM students);
    DBMS_OUTPUT.PUT_LINE('Inserted student with most enrollments');
    SAVEPOINT A;

    -- Insert the student with the fewest enrollments
    INSERT INTO UEBUNG4 (ID, NAME)
    SELECT UEBUNG4_SEQ.NEXTVAL, NAME
    FROM students
    WHERE enrollments = (SELECT MIN(enrollments) FROM students);
    DBMS_OUTPUT.PUT_LINE('Inserted student with fewest enrollments');
    SAVEPOINT B;

    -- Insert the instructor with the most courses
    INSERT INTO UEBUNG4 (ID, NAME)
    SELECT UEBUNG4_SEQ.NEXTVAL, NAME
    FROM instructors
    WHERE courses = (SELECT MAX(courses) FROM instructors);
    DBMS_OUTPUT.PUT_LINE('Inserted instructor with most courses');
    SAVEPOINT C;

    -- Store the ID of the inserted instructor
    SELECT ID INTO v_id
    FROM UEBUNG4
    WHERE NAME = (SELECT NAME FROM instructors WHERE courses = (SELECT MAX(courses) FROM instructors));
    DBMS_OUTPUT.PUT_LINE('Stored ID of instructor with most courses: ' || v_id);

    -- Rollback the insertion of the instructor with the most courses
    ROLLBACK TO SAVEPOINT C;
    DBMS_OUTPUT.PUT_LINE('Rolled back insertion of instructor with most courses');

    -- Insert the instructor with the fewest courses using v_id
    INSERT INTO UEBUNG4 (ID, NAME)
    SELECT v_id, NAME
    FROM instructors
    WHERE courses = (SELECT MIN(courses) FROM instructors);
    DBMS_OUTPUT.PUT_LINE('Inserted instructor with fewest courses using stored ID');

    -- Insert the instructor with the most courses using the sequence
    INSERT INTO UEBUNG4 (ID, NAME)
    SELECT UEBUNG4_SEQ.NEXTVAL, NAME
    FROM instructors
    WHERE courses = (SELECT MAX(courses) FROM instructors);
    DBMS_OUTPUT.PUT_LINE('Inserted instructor with most courses using sequence ID');

    COMMIT;
END;
/
--4.2)
DECLARE
    v_date DATE := TO_DATE('&sv_user_date ' , 'DD-MM-YYYY' ) ;
    v_day VARCHAR2( 15 ) ;
BEGIN
    v_day := RTRIM(TO_CHAR( v_date , 'DAY' ) ) ;
    IF v_day IN ( 'SATURDAY' , 'SUNDAY') THEN
    DBMS_OUTPUT. PUT_LINE ( v_date||' falls on weekend');
    END IF;
    --control resumes here
    DBMS_OUTPUT. PUT_LINE ( 'Done . . . ' ) ;
END;
/
-- For 14.10.2023
DECLARE
    v_date DATE := TO_DATE('14-10-2023', 'DD-MM-YYYY');
    v_day VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    IF v_day IN ('SATURDAY', 'SUNDAY') THEN
        DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done...');
END;
/

-- For 16.10.2023
DECLARE
    v_date DATE := TO_DATE('16-10-2023', 'DD-MM-YYYY');
    v_day VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    IF v_day IN ('SATURDAY', 'SUNDAY') THEN
        DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/
--Remove RTRIM
DECLARE
    v_date DATE := TO_DATE('14-10-2023', 'DD-MM-YYYY');
    v_day VARCHAR2(15);
BEGIN
    v_day := TO_CHAR(v_date, 'DAY');
    DBMS_OUTPUT.PUT_LINE(v_day);
    IF v_day IN ('SATURDAY', 'SUNDAY') THEN
        DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/
--Rewrite using LIKE
DECLARE
    v_date DATE := TO_DATE('&sv_user_date', 'DD-MM-YYYY');
    v_day VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    DBMS_OUTPUT.PUT_LINE(v_day);
    IF v_day LIKE 'SATURDAY%' OR v_day LIKE 'SUNDAY%' THEN
        DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/
--Rewrite using if-else
DECLARE
    v_date DATE := TO_DATE('&sv_user_date', 'DD-MM-YYYY');
    v_day VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    IF v_day LIKE 'SATURDAY%' OR v_day LIKE 'SUNDAY%' THEN
        DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_date || ' does not fall on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/
--rewrite using SYSDATE
DECLARE
    v_date DATE := SYSDATE;
    v_day VARCHAR2(15);
    v_time VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    v_time := TO_CHAR(v_date, 'HH24:MI');
    IF v_day LIKE 'SATURDAY%' OR v_day LIKE 'SUNDAY%' THEN
        IF TO_NUMBER(TO_CHAR(v_date, 'HH24')) < 12 THEN
            DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend in the morning');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend in the afternoon');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_date || ' does not fall on weekend');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/
--4.3)
DECLARE
    v_instructor_id NUMBER;
    v_section_count NUMBER;
BEGIN
    -- Prompt the user to input the instructor ID
    v_instructor_id := &instructor_id;

    -- Query to count the number of sections taught by the instructor
    SELECT COUNT(*)
    INTO v_section_count
    FROM section
    WHERE instructor_id = v_instructor_id;

    -- Check if the number of sections is greater than 3
    IF v_section_count > 3 THEN
        DBMS_OUTPUT.PUT_LINE('Instructor ' || v_instructor_id || ' needs a vacation');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Instructor ' || v_instructor_id || ' teaches ' || v_section_count || ' sections');
    END IF;
END;
/
--Aufgabe 4.4
--Block 1
DECLARE
    v_num NUMBER;
BEGIN
    IF v_num > 0 THEN
        DBMS_OUTPUT.PUT_LINE('v_num is greater than 0');
    ELSE
        DBMS_OUTPUT.PUT_LINE('v_num is not greater than 0');
    END IF;
END;
/ 
--Block 2
DECLARE
    v_num NUMBER;
BEGIN
    IF v_num > 0 THEN
        DBMS_OUTPUT.PUT_LINE('v_num is greater than 0');
    END IF;
    IF NOT (v_num > 0) THEN
        DBMS_OUTPUT.PUT_LINE('v_num is not greater than 0');
    END IF;
END;
/

--Aufgabe 4.5
DECLARE
    v_date DATE := SYSDATE;
    v_day VARCHAR2(15);
    v_time VARCHAR2(15);
BEGIN
    v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
    v_time := TO_CHAR(v_date, 'HH24:MI');

    CASE 
        WHEN v_day LIKE 'SATURDAY%' OR v_day LIKE 'SUNDAY%' THEN
            CASE 
                WHEN TO_NUMBER(TO_CHAR(v_date, 'HH24')) < 12 THEN
                    DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend in the morning');
                ELSE
                    DBMS_OUTPUT.PUT_LINE(v_date || ' falls on weekend in the afternoon');
            END CASE;
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_date || ' does not fall on weekend');
    END CASE;

    DBMS_OUTPUT.PUT_LINE('Done . . .');
END;
/

--Aufgabe 4.6
DECLARE
    v_instructor_id NUMBER;
    v_section_count NUMBER;
BEGIN
    -- Prompt the user to input the instructor ID
    v_instructor_id := &instructor_id;

    -- Query to count the number of sections taught by the instructor
    SELECT COUNT(*)
    INTO v_section_count
    FROM section
    WHERE instructor_id = v_instructor_id;

    -- Use a CASE statement to determine the output message
    CASE 
        WHEN v_section_count > 3 THEN
            DBMS_OUTPUT.PUT_LINE('Instructor ' || v_instructor_id || ' needs a vacation');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Instructor ' || v_instructor_id || ' teaches ' || v_section_count || ' sections');
    END CASE;
END;
/