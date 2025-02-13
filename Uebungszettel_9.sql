--Aufgabe 1
--es wird ein Error geschmissen weil das Extend für das Varray fehlt

--Aufgabe 2

DECLARE
  CURSOR city_cur IS
    SELECT city
    FROM zipcode
    WHERE rownum <= 10;

  TYPE city_type IS VARRAY(10) OF zipcode.city%TYPE;
  
  city_varray city_type := city_type();
  v_counter INTEGER := 0;

BEGIN
  FOR city_rec IN city_cur LOOP
    city_varray.Extend;
    v_counter := v_counter + 1;
    city_varray(v_counter) := city_rec.city;
    DBMS_OUTPUT.PUT_LINE('city_varray('||v_counter||'): '||
      city_varray(v_counter));
  END LOOP;
END;
/

--Aufgabe 3

DECLARE
  CURSOR city_cur IS
    SELECT city
    FROM zipcode
    WHERE rownum <= 10;

  TYPE city_type IS VARRAY(20) OF zipcode.city%TYPE;
  
  city_varray city_type := city_type();
  v_counter INTEGER := 0;

BEGIN
  FOR city_rec IN city_cur LOOP
    city_varray.Extend;
    v_counter := v_counter + 1;
    city_varray(v_counter) := city_rec.city;
    DBMS_OUTPUT.PUT_LINE('city_varray('||v_counter||'): '||city_varray(v_counter));
  END LOOP;
  FOR i IN 1..10 LOOP
    city_varray.EXTEND;
    city_varray(10 + i) := city_varray(i);
    DBMS_OUTPUT.PUT_LINE('city_varray('||(10 + i)||'): '||city_varray(10 + i));
  END LOOP;
END;
/


--Aufgabe 4
DECLARE
  TYPE table_type1 IS TABLE OF INTEGER
    INDEX BY BINARY_INTEGER;

  TYPE table_type2 IS TABLE OF TABLE_TYPE1
    INDEX BY BINARY_INTEGER;

  table_tab1 table_type1;
  table_tab2 table_type2;

BEGIN
  FOR i IN 1..2 LOOP
    FOR j IN 1..3 LOOP
      IF i = 1 THEN
        table_tab1(j) := j;
      ELSE
        table_tab1(j) := 4 - j;
      END IF;

      table_tab2(i)(j) := table_tab1(j);
      DBMS_OUTPUT.PUT_LINE ('table_tab2('||i||')('||j||'): '||
      table_tab2(i)(j));
    END LOOP;
  END LOOP;
END;
/

--Es werden in die Zahlen ein bis drei und dann drei bis eins ausgegeben.

--Aufgabe 5
DECLARE
  TYPE table_type1 IS TABLE OF INTEGER --associative array
  INDEX BY BINARY_INTEGER;

  TYPE table_type2 IS TABLE OF TABLE_TYPE1; --nested Table

  table_tab1 table_type1;
  table_tab2 table_type2 := table_type2();

  counter Number(4) := 1;
BEGIN
  FOR i IN 1..2 LOOP
    FOR j IN 1..3 LOOP
      IF i = 1 THEN
        table_tab1(j) := j;
      ELSE
        table_tab1(j) := 4 - j;
      END IF;

      table_tab2.extend;
      table_tab2(i)(j) := table_tab1(j);
      DBMS_OUTPUT.PUT_LINE ('table_tab2('||i||')('||j||'): '||
      table_tab2(i)(j));

    END LOOP;
  END LOOP;
END;
/

--Aufgabe 6
DECLARE
    TYPE varray_type IS VARRAY(3) OF INTEGER;

    TYPE nested_table_type IS TABLE OF varray_type;

    nested_table nested_table_type := nested_table_type();

BEGIN
    FOR i IN 1..2 LOOP
        nested_table.EXTEND;
        nested_table(i) := varray_type();

        FOR j IN 1..3 LOOP
            IF i = 1 THEN
                nested_table(i).EXTEND;
                nested_table(i)(j) := j;
            ELSE
                nested_table(i).EXTEND;
                nested_table(i)(j) := 4 - j;
            END IF;
            DBMS_OUTPUT.PUT_LINE('nested_table(' || i || ')(' || j || '): ' || nested_table(i)(j));
        END LOOP;
    END LOOP;
END;
/

--Aufgabe 7
DECLARE
  CURSOR c_instructor IS SELECT FIRST_NAME, LAST_NAME, SALUTATION FROM INSTRUCTOR;

  TYPE type_instructor IS TABLE OF VARCHAR2(100)
    INDEX BY BINARY_INTEGER;

  instructor_varray type_instructor;

  counter Number(10) := 0;
BEGIN
    FOR rec_instructor IN c_instructor LOOP
        counter := counter + 1;
        instructor_varray(counter) := 'name(' || counter || '): ' || rec_instructor.SALUTATION || ' ' || rec_instructor.FIRST_NAME || ' ' || rec_instructor.LAST_NAME;
        DBMS_OUTPUT.PUT_LINE(instructor_varray(counter));
    END LOOP;
END;
/