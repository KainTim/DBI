Create or replace Package manage_students
Is
    Procedure display_student_count;
    Procedure find_student_name
    (i_student_id In student.id%Type,
     o_last_name Out student.last_name%Type,
     o_first_name Out student.first_name%Type);
    Function id_is_good
    (i_student_id In student.id%Type)
    Return Boolean;
Begin
End manage_students;

Create or replace Package Body manage_students
Is
    Procedure display_student_count
    Is
        v_count Integer;
    Begin
        select Count(*)
        Into v_count
        From student;
        dbms(v_count);
    End display_student_count;

    Procedure find_student_name
    (i_student_id In student.id%Type,
     o_last_name Out student.last_name%Type,
     o_first_name Out student.first_name%Type)
     Is
     Begin
        select first_name, last_name
        Into o_first_name, o_last_name
        From student
        Where i_student_id = student_id;
     End find_student_name;

    Function id_is_good
    (i_student_id In student.id%Type)
    Return Boolean
    Is
        v_count Integer;
    Begin
        Select Count(*)
        Into v_count
        From student;
        Return Count=1;
    Exception
        When others Then
            Return False;
    End id_is_good;
Begin
End manage_students;

Create or replace Trigger student_bi
Before Insert on student
For each Row
Begin
    -- :New.student_id := sequence_student.NextVal;
    :New.created_By := User;
    :New.created_Date := Sysdate;
    if(TRUE<>manage_students.id_is_good(:New.student_id)) Then
        Raise_Application_Error(-20000, 'Id already in Use');
    Endif;
End student_bi;
Create Or replace Trigger student_ai
After Insert On student
Begin
    Insert Into protocol (t_table, t_action, t_date)
    Values('student', 'insert', Sysdate);
End student_ai;


Declare
    Cursor c_students (v_student_Id student.id%type)
    Is
        Select * From student
        Where student_id = v_student_Id;
Begin
    For v_student In c_students(1) Loop
        dbms(v_student.first_name);
    End Loop;
End;