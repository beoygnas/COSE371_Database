1.

// primary key constraints
insert into advisor values('00128', '12345');
// foreign key constraints
insert into student values('99999', 'sangyeob', 'data science', 135);
// not null constraints
insert into  student values(null, null, 'Comp. Sci.', 135);


2. 

begin transaction;
insert into student values('99999', 'sangyeob', 'Comp. Sci.', 135);
commit;

begin transaction;
delete from student where name = 'sangyeob';
commit;


3. 
create user sangyeob -p '9240';
grant select, insert on student to sangyeob;
delete from student where name = 'sangyeob';
revoke insert on student from sangyeob;
insert into student values('99998', 'yeobsang', 'Comp. Sci.', 135);

4. 

// simple case
create view student_info as
    select id, name, dept_name from student;

insert into student_info values ('99999', 'sangyeob', 'Comp. Sci.');


// from 2 tables
create view student_info2 as 
    select id, name, budget
    from student, department
    where student.dept_name = department.dept_name;

insert into student_info2 values('99999', 'sangyeob', 100000);

// 조건이 다를 경우
create view student_comp as
    select id, name, dept_name 
    from student
    where dept_name = 'Comp. Sci.'

insert into student_comp values ('99999', 'sangyeob', 'History')

// 
create view dept_tot_cred as 
    select dept_name, avg(tot_cred)
    from student
    group by dept_name

insert into dept_tot_cred values('Data Science', '100')