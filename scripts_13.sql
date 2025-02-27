-- section 1
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

-- section 3
CREATE OR REPLACE PACKAGE school_api as
  PROCEDURE discount;
  FUNCTION new_instructor_id
  RETURN instructor.instructor_id%TYPE;
END school_api;