SET SERVEROUTPUT On

-- 13.1
CREATE OR REPLACE PROCEDURE Discount
AS
  CURSOR c_group_discount
  IS
  SELECT distinct s.course_no, c.description
  FROM section s, enrollment e, course c
  WHERE s.section_id = e.section_id
  AND c.course_no = s.course_no
  GROUP BY s.course_no, c.description,
  e.section_id, s.section_id
  HAVING COUNT(*) >=8;

BEGIN
  FOR r_group_discount IN c_group_discount LOOP
    UPDATE course
    SET cost = cost * .95
    WHERE course_no = r_group_discount.course_no;
    DBMS_OUTPUT.PUT_LINE('A 5% discount has been given to '||
    r_group_discount.course_no||' '||r_group_discount.description);
  END LOOP;
END;
/
-- a) Es wird eine PROCEDURE namens Discount erstellt

-- b)
BEGIN
  Discount;
END;
/

-- c) Commit ist nicht notwendig, da Autocommit an ist

--13.2
CREATE OR REPLACE FUNCTION new_student_id
RETURN student.student_id%TYPE
AS
    v_new_id student.student_id%TYPE;
BEGIN
    SELECT student_id_seq.NEXTVAL INTO v_new_id FROM dual;
    RETURN v_new_id;
END;
/


-- 13.3
-- a)
CREATE OR REPLACE PACKAGE school_api as
  PROCEDURE discount;
  FUNCTION new_instructor_id
  RETURN instructor.instructor_id%TYPE;
END school_api;
/

CREATE OR REPLACE PACKAGE BODY school_api 
AS
    PROCEDURE discount IS
        CURSOR c_group_discount IS
            SELECT DISTINCT s.course_no, c.description
            FROM section s, enrollment e, course c
            WHERE s.section_id = e.section_id
            AND c.course_no = s.course_no
            GROUP BY s.course_no, c.description,
            e.section_id, s.section_id
            HAVING COUNT(*) >= 8;

    BEGIN
        FOR r_group_discount IN c_group_discount LOOP
            UPDATE course
            SET cost = cost * .95
            WHERE course_no = r_group_discount.course_no;
            DBMS_OUTPUT.PUT_LINE('A 5% discount has been given to '||
            r_group_discount.course_no||' '||r_group_discount.description);
        END LOOP;
    END discount;

    FUNCTION new_instructor_id
    RETURN instructor.instructor_id%TYPE IS
        v_new_id instructor.instructor_id%TYPE;
    BEGIN
        SELECT instructor_id_seq.NEXTVAL INTO v_new_id FROM dual;
        RETURN v_new_id;
    END new_instructor_id;

END school_api;
/

--13.4
DECLARE
  v_new_id instructor.instructor_id%TYPE;
BEGIN
  v_new_id := school_api.new_instructor_id;
  DBMS_OUTPUT.PUT_LINE('New instructor ID: ' || v_new_id);
END;
/

--13.5
CREATE OR REPLACE PACKAGE BODY school_api 
AS
  PROCEDURE discount IS
    CURSOR c_group_discount IS
      SELECT DISTINCT s.course_no, c.description
      FROM section s, enrollment e, course c
      WHERE s.section_id = e.section_id
      AND c.course_no = s.course_no
      GROUP BY s.course_no, c.description,
      e.section_id, s.section_id
      HAVING COUNT(*) >= 8;

  BEGIN
    FOR r_group_discount IN c_group_discount LOOP
      UPDATE course
      SET cost = cost * .95
      WHERE course_no = r_group_discount.course_no;
      DBMS_OUTPUT.PUT_LINE('A 5% discount has been given to '||
      r_group_discount.course_no||' '||r_group_discount.description);
    END LOOP;
  END discount;

  FUNCTION new_instructor_id
  RETURN instructor.instructor_id%TYPE IS
    v_new_id instructor.instructor_id%TYPE;
  BEGIN
    SELECT instructor_id_seq.NEXTVAL INTO v_new_id FROM dual;
    RETURN v_new_id;
  END new_instructor_id;

  FUNCTION get_course_descript_private (
    p_course_no course.course_no%TYPE
  ) RETURN course.description%TYPE IS
    v_description course.description%TYPE;
  BEGIN
    SELECT description INTO v_description
    FROM course
    WHERE course_no = p_course_no;
    
    RETURN v_description;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_course_descript_private;

END school_api;
/