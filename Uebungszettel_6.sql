-- Aufgabe 6.1
DECLARE
  vr_zip ZIPCODE%ROWTYPE;

BEGIN
  SELECT *
  INTO vr_zip
  FROM zipcode
  WHERE rownum < 2;

  DBMS_OUTPUT.PUT_LINE('City: '||vr_zip.city);
  DBMS_OUTPUT.PUT_LINE('State: '||vr_zip.state);
  DBMS_OUTPUT.PUT_LINE('Zip: '||vr_zip.zip);
END;
/

-- Es wird die Stadt, der State und die Postleitzahl vom ersten Datensatz in der zipcode Tabelle angezeigt.

-- Aufgabe 6.2
DECLARE
    CURSOR c_zip IS
    SELECT *
    FROM zipcode;
    vr_zip ZIPCODE%ROWTYPE;
BEGIN
    OPEN c_zip;
    LOOP
        FETCH c_zip INTO vr_zip;
        EXIT WHEN c_zip%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vr_zip.zip || vr_zip.city || vr_zip.state);
    END LOOP;
    CLOSE c_zip;
END;
/

-- Aufgabe 6.3
DECLARE
    CURSOR c_student_name IS
    SELECT *
    FROM STUDENT
    WHERE rownum <= 5;
    vr_student STUDENT%ROWTYPE;
BEGIN
    OPEN c_student_name;
    LOOP
        FETCH c_student_name INTO vr_student;
        EXIT WHEN c_student_name%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Student name: ' || vr_student.FIRST_NAME || ' ' || vr_student.LAST_NAME);
    END LOOP;
    CLOSE c_student_name;
END;
/


-- Aufgabe 6.4
--     EXIT WHEN c_student%NOTFOUND;
	
-- 	DBMS_OUTPUT.PUT_LINE('STUDENT ID : '||v_sid);
--   END LOOP;

--   CLOSE c_student;
  
-- EXCEPTION
--   WHEN OTHERS THEN
--     IF c_student%ISOPEN THEN
--       CLOSE c_student;
--     END IF;
-- END;
--/
-- a): %NOTFOUND -> Prüft ob keine weiteren Einträge gefunden werden. %ISOPEN -> Prüft ob akutell noch der Cursor offen ist. 
-- b):
DECLARE
    CURSOR c_student IS
        SELECT student_id
        FROM student;
    v_sid student.student_id%TYPE;
BEGIN
    OPEN c_student;
    LOOP
        FETCH c_student INTO v_sid;
        EXIT WHEN c_student%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Student Id: '||v_sid);
    END LOOP;
    CLOSE c_student;
EXCEPTION
    WHEN OTHERS THEN
        IF c_student%ISOPEN THEN
            CLOSE c_student;
        END IF;
        RAISE;
END;
/

-- Aufgabe 6.5
DECLARE
    CURSOR c_student IS
    SELECT student_id, first_name, last_name, (SELECT COUNT(*) FROM enrollment e WHERE e.student_id = s.student_id) AS class_count
    FROM student s
    WHERE student_id < 110;
    vr_student c_student%ROWTYPE;
BEGIN
    OPEN c_student;
    LOOP
        FETCH c_student INTO vr_student;
        EXIT WHEN c_student%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Student INFO: ID ' || vr_student.student_id || ' is ' || vr_student.first_name || ' ' || vr_student.last_name || ' is enrolled in ' || vr_student.class_count || ' classes.');
        END LOOP;
    CLOSE c_student;
END;
/

-- Aufgabe 6.6
DECLARE
    CURSOR c_group_discount IS
        SELECT co.course_no, co.cost
        FROM course co
        WHERE (SELECT COUNT(*) FROM enrollment e 
            JOIN section s ON e.section_id = s.section_id 
            WHERE s.course_no = co.course_no) >= 8;
BEGIN
    FOR r_group_discount IN c_group_discount LOOP
        UPDATE course
        SET cost = cost * 0.95
        WHERE course_no = r_group_discount.course_no;
    END LOOP;
END;
/
SELECT 'Course No: ' ||  course_no || ', Cost: ' || cost FROM Course;