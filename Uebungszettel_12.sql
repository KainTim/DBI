--Aufgabe 12.1
CREATE OR REPLACE PACKAGE manage_students
AS
  v_current_date DATE;

  PROCEDURE find_sname
  (i_student_id IN student.student_id%TYPE,
  o_first_name OUT student.first_name%TYPE,
  o_last_name OUT student.last_name%TYPE
  );

  PROCEDURE display_student_count;
  
  FUNCTION id_is_good
  (i_student_id IN student.student_id%TYPE)
  RETURN BOOLEAN;
END manage_students;
/
-- a) Es wird eine Package SPECIFICATION gemacht.

DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  manage_students.find_sname(125, v_first_name, v_last_name);
  DBMS_OUTPUT.PUT_LINE(v_first_name||' '||v_last_name);
END;
/
-- b) Es kommt ein Error da noch kein Body für manage_students gemacht wurde. 


--Aufgabe 12.2
CREATE OR REPLACE PACKAGE BODY manage_students
AS
  PROCEDURE find_sname
  (i_student_id IN student.student_id%TYPE,
  o_first_name OUT student.first_name%TYPE,
  o_last_name OUT student.last_name%TYPE)
  IS
    v_student_id student.student_id%TYPE;
  BEGIN
    SELECT first_name, last_name
    INTO o_first_name, o_last_name
    FROM student
    WHERE student_id = i_student_id;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in finding student_id: '||v_student_id);
  END find_sname;

  FUNCTION id_is_good
  (i_student_id IN student.student_id%TYPE)
  RETURN BOOLEAN
  IS
    v_id_cnt number;
  BEGIN
    SELECT COUNT(*)
    INTO v_id_cnt
    FROM student
    WHERE student_id = i_student_id;
    
	RETURN 1 = v_id_cnt;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END id_is_good;
END manage_students;
/

-- a) der Body für die vorherige SPECIFICATION manage_students wird erstellt.

--b)
DECLARE
    o_first_name student.first_name%TYPE;
    o_last_name student.last_name%TYPE;
    v_return_value BOOLEAN;
BEGIN
    manage_students.find_sname(5, o_first_name, o_last_name);
    v_return_value := manage_students.id_is_good(101);
END;
/


--Aufgabe 12.3
CREATE OR REPLACE PACKAGE BODY manage_students
AS
  PROCEDURE find_sname
  (i_student_id IN student.student_id%TYPE,
  o_first_name OUT student.first_name%TYPE,
  o_last_name OUT student.last_name%TYPE)
  IS
    v_student_id student.student_id%TYPE;
  BEGIN
    SELECT first_name, last_name
    INTO o_first_name, o_last_name
    FROM student
    WHERE student_id = i_student_id;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in finding student_id: '||v_student_id);
  END find_sname;

  FUNCTION id_is_good
  (i_student_id IN student.student_id%TYPE)
  RETURN BOOLEAN
  IS
    v_id_cnt number;
  BEGIN
    SELECT COUNT(*)
    INTO v_id_cnt
    FROM student
    WHERE student_id = i_student_id;
    
	RETURN 1 = v_id_cnt;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END id_is_good;

  FUNCTION get_num_students
  RETURN NUMBER
  IS
    v_id_cnt number;
  BEGIN
    SELECT COUNT(*)
    INTO v_id_cnt
    FROM student;
    
	RETURN v_id_cnt;
  END get_num_students;

  PROCEDURE display_student_count
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(get_num_students);
  END display_student_count;

END manage_students;
/

BEGIN
    manage_students.display_student_count;
END;
/

--Aufgabe 12.4
CREATE OR REPLACE PACKAGE BODY manage_students
AS
  PROCEDURE find_sname
  (i_student_id IN student.student_id%TYPE,
  o_first_name OUT student.first_name%TYPE,
  o_last_name OUT student.last_name%TYPE)
  IS
    v_student_id student.student_id%TYPE;
  BEGIN
    SELECT first_name, last_name
    INTO o_first_name, o_last_name
    FROM student
    WHERE student_id = i_student_id;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in finding student_id: '||v_student_id);
  END find_sname;

  FUNCTION id_is_good
  (i_student_id IN student.student_id%TYPE)
  RETURN BOOLEAN
  IS
    v_id_cnt number;
  BEGIN
    SELECT COUNT(*)
    INTO v_id_cnt
    FROM student
    WHERE student_id = i_student_id;
    
	RETURN 1 = v_id_cnt;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END id_is_good;

  FUNCTION get_num_students
  RETURN NUMBER
  IS
    v_id_cnt number;
  BEGIN
    SELECT COUNT(*)
    INTO v_id_cnt
    FROM student;
    
	RETURN v_id_cnt;
  END get_num_students;

  PROCEDURE display_student_count
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(get_num_students);
  END display_student_count;
  
BEGIN
    v_current_date := trunc(sysdate, 'DD');

END manage_students;
/