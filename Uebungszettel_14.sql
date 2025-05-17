SET SERVEROUTPUT ON;

Drop table IdVal;

CREATE TABLE IdVal (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY ,
    val NUMBER(3)
);

DECLARE
    v_count NUMBER := 300;
    v_num NUMBER := 1;
BEGIN

    FOR a IN 0..900 LOOP
        IF a >= v_count THEN
            v_count := v_count + 300;
            v_num := v_num + 1;
        END IF;

        Insert into IdVal (val) values (v_num);
    END LOOP;
END;
/

CREATE OR REPLACE PACKAGE delete_counter
AS
    v_oldTable NUMBER;
    v_newTable NUMBER;
END delete_counter;
/

CREATE OR REPLACE TRIGGER delete_trigger_before
BEFORE DELETE
ON IdVal
BEGIN
    SELECT COUNT(*) INTO delete_counter.v_oldTable 
    FROM IdVal; 
END delete_trigger_before;
/

CREATE OR REPLACE TRIGGER delete_trigger_after
AFTER DELETE
ON IdVal
BEGIN
    SELECT COUNT(*) INTO delete_counter.v_newTable 
    FROM IdVal; 

    DBMS_OUTPUT.PUT_LINE('NEW: '||delete_counter.v_newTable);
    DBMS_OUTPUT.PUT_LINE('OLD: '||delete_counter.v_oldTable);

    IF delete_counter.v_newTable < (delete_counter.v_oldTable/2) THEN
        Raise_Application_error(-20001, 'TOOO mUch DelEteED!?=');
    END IF;
END delete_trigger_after;
/


DELETE FROM IdVal WHERE ROWNUM < 500;