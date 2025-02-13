-- Aufgabe 5.1
DECLARE
  v_total NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM enrollment e
  JOIN section s USING (section_id)
  WHERE s.course_no = 25
  AND s.section_no = 1;
  
  -- check if section 1 of course 25 is full
  IF v_total >= 15 THEN
    DBMS_OUTPUT.PUT_LINE('Section 1 of course 25 is full');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Section 1 of course 25 is not full');
  END IF;
END;
/

-- Aufgabe 5.1 (a)
-- Ausgabe: 'Section 1 of course 25 is full'

-- Aufgabe 5.1 (b)
-- Ausgabe: 'Section 1 of course 25 is not full'

-- Aufgabe 5.1 (c)
-- Ausgabe: 'Section 1 of course 25 is not full'

-- Aufgabe 5.1 (d)
DECLARE
    v_total NUMBER;
    v_course_no NUMBER := &course_no;
    v_section_no NUMBER := &section_no;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM enrollment e
    JOIN section s USING (section_id)
    WHERE s.course_no = v_course_no
    AND s.section_no = v_section_no;
    
    -- check if section is full
    IF v_total >= 15 THEN
        DBMS_OUTPUT.PUT_LINE('Section ' || v_section_no || ' of course ' || v_course_no || ' is full');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Section ' || v_section_no || ' of course ' || v_course_no || ' is not full');
        DBMS_OUTPUT.PUT_LINE('There are ' || (15 - v_total) || ' places left');
    END IF;
END;
/
-- Aufgabe 5.1 (e)
DECLARE
    v_total NUMBER;
    v_course_no NUMBER := &course_no;
    v_section_no NUMBER := &section_no;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM enrollment e
    JOIN section s USING (section_id)
    WHERE s.course_no = v_course_no
    AND s.section_no = v_section_no;
    
    -- check if section is full
    IF v_total >= 15 THEN
        DBMS_OUTPUT.PUT_LINE('Section ' || v_section_no || ' of course ' || v_course_no || ' is full');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Section ' || v_section_no || ' of course ' || v_course_no || ' is not full');
        DBMS_OUTPUT.PUT_LINE('There are ' || (15 - v_total) || ' places left');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such section in the course');
END;
/





-- Aufgabe 5.2
DECLARE
  v_student_id NUMBER := 102;
  v_section_id NUMBER := 89;
  v_final_grade NUMBER;
  v_letter_grade CHAR(1);
BEGIN
  SELECT final_grade
  INTO v_final_grade
  FROM enrollment
  WHERE student_id = v_student_id
  AND section_id = v_section_id;
  
  IF v_final_grade BETWEEN 90 AND 100 THEN
    v_letter_grade := 'A';
  ELSIF v_final_grade BETWEEN 80 AND 89 THEN
    v_letter_grade := 'B';
  ELSIF v_final_grade BETWEEN 70 AND 79 THEN
    v_letter_grade := 'C';
  ELSIF v_final_grade BETWEEN 60 AND 69 THEN
    v_letter_grade := 'D';
  ELSE
    v_letter_grade := 'F';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;
/
-- Aufgabe 5.2 (a)
-- Aufgabe 5.2 (a) (1)
-- Ausgabe: 'Letter grade is: B'

-- Aufgabe 5.2 (a) (2)
-- Ausgabe: 'There is no such student or section'

-- Aufgabe 5.2 (a) (3)
-- Ausgabe: 'Letter grade is: F'

-- Aufgabe 5.2 (b)
DECLARE
    v_student_id NUMBER := 102;
    v_section_id NUMBER := 89;
    v_final_grade NUMBER;
    v_letter_grade CHAR(1);
BEGIN
    SELECT final_grade
    INTO v_final_grade
    FROM enrollment
    WHERE student_id = v_student_id
    AND section_id = v_section_id;
    
    IF v_final_grade IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('v final grade is null');
    ELSIF v_final_grade >= 90 THEN
        v_letter_grade := 'A';
    ELSIF v_final_grade >= 80 THEN
        v_letter_grade := 'B';
    ELSIF v_final_grade >= 70 THEN
        v_letter_grade := 'C';
    ELSIF v_final_grade >= 60 THEN
        v_letter_grade := 'D';
    ELSE
        v_letter_grade := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;
/

-- Aufgabe 5.2 (c)
DECLARE
    v_student_id NUMBER := &student_id;
    v_section_id NUMBER := &section_id;
    v_final_grade NUMBER;
    v_letter_grade CHAR(1);
BEGIN
    SELECT final_grade
    INTO v_final_grade
    FROM enrollment
    WHERE student_id = v_student_id
    AND section_id = v_section_id;
    
    IF v_final_grade IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('v final grade is null');
    ELSIF v_final_grade >= 90 THEN
        v_letter_grade := 'A';
    ELSIF v_final_grade >= 80 THEN
        v_letter_grade := 'B';
    ELSIF v_final_grade >= 70 THEN
        v_letter_grade := 'C';
    ELSIF v_final_grade >= 60 THEN
        v_letter_grade := 'D';
    ELSE
        v_letter_grade := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;
/

-- Aufgabe 5.2 (d)
DECLARE
    v_student_id NUMBER := &student_id;
    v_section_id NUMBER := &section_id;
    v_final_grade NUMBER;
    v_letter_grade CHAR(1);
BEGIN
    SELECT final_grade
    INTO v_final_grade
    FROM enrollment
    WHERE student_id = v_student_id
    AND section_id = v_section_id;
    
    IF v_final_grade IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('v final grade is null');
    ELSIF v_final_grade >= 90 THEN
        v_letter_grade := 'A';
    ELSIF v_final_grade >= 80 THEN
        v_letter_grade := 'B';
    ELSIF v_final_grade >= 70 THEN
        v_letter_grade := 'C';
    ELSIF v_final_grade >= 60 THEN
        v_letter_grade := 'D';
    ELSE
        v_letter_grade := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;
/





-- Aufgabe 5.3
DECLARE
  v_temp_in NUMBER := &sv_temp_in;
  v_scale_in CHAR := '&sv_scale_in';
  v_temp_out NUMBER;
  v_scale_out CHAR;
BEGIN
  IF v_scale_in != 'C' AND v_scale_in != 'F' THEN
    DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
  ELSE
    IF v_scale_in = 'C' THEN
      v_temp_out := ( (9 * v_temp_in) / 5 ) + 32;
      v_scale_out := 'F';
    ELSE
      v_temp_out := ( (v_temp_in - 32) * 5 ) / 9;
      v_scale_out := 'C';
    END IF;
    DBMS_OUTPUT.PUT_LINE ('New scale is: '|| v_scale_out);
    DBMS_OUTPUT.PUT_LINE ('New temperature is: '|| v_temp_out);
  END IF;
END;
/

-- Aufgabe 5.3 (a)
-- Ausgabe: 
-- New scale is: F
-- New temperature is: 212

-- Aufgabe 5.3 (b)
-- Ausgabe: 
-- ORA-06502: PL/SQL: numeric or value error: character to number conversion error

-- Aufgabe 5.3 (c)
-- Ausgabe: 
-- This is not a valid scale

-- Aufgabe 5.3 (d)
DECLARE
    v_temp_in NUMBER := &sv_temp_in;
    v_scale_in CHAR := '&sv_scale_in';
    v_temp_out NUMBER;
    v_scale_out CHAR;
BEGIN
    IF v_scale_in != 'C' AND v_scale_in != 'F' THEN
        v_temp_out := 0;
        v_scale_out := 'C';
        DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
    ELSE
        IF v_scale_in = 'C' THEN
            v_temp_out := ( (9 * v_temp_in) / 5 ) + 32;
            v_scale_out := 'F';
        ELSE
            v_temp_out := ( (v_temp_in - 32) * 5 ) / 9;
            v_scale_out := 'C';
        END IF;
        DBMS_OUTPUT.PUT_LINE ('New scale is: '|| v_scale_out);
        DBMS_OUTPUT.PUT_LINE ('New temperature is: '|| v_temp_out);
    END IF;
END;
/





-- Aufgabe 5.4
DECLARE
  v_date DATE := TO_DATE('&sv_user_date', 'DD-MM-YYYY');
  v_day VARCHAR2(1);
BEGIN
  v_day := TO_CHAR(v_date, 'D');
  CASE v_day
  WHEN '1' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Sunday');
  WHEN '2' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Monday');
  WHEN '3' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Tuesday');
  WHEN '4' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Wednesday');
  WHEN '5' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Thursday');
  WHEN '6' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Friday');
  WHEN '7' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Saturday');
  END CASE;
END;
/





-- Aufgabe 5.5
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    -- if EXIT condition yields TRUE exit the loop
    IF v_counter = 5 THEN
      EXIT;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;
/





-- Aufgabe 5.6
DECLARE
  v_counter BINARY_INTEGER := 1;
  v_sum NUMBER := 0;
BEGIN
  WHILE v_counter <= 10 LOOP
    v_sum := v_sum + v_counter;
    DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
    -- increment loop counter by one
    v_counter := v_counter + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('The sum of integers between 1 '||'and 10 is: '||v_sum);
END;
/





-- Aufgabe 5.7
DECLARE
  v_factorial NUMBER := 1;
BEGIN
  FOR v_counter IN 1..10 LOOP
    v_factorial := v_factorial * v_counter;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Factorial of ten is: '||v_factorial);
END;
/