
1. join 

select *
from takes
    natural inner join course

select *
from takes
    inner join course using(course_id)

select *
from takes as t
    inner join course as c on t.course_id = c.course_id

select *
from takes 
    natural left outer join course

select *
from takes 
    natural right outer join course
    
select *
from takes 
    natural full outer join course


2. view

create view student_id_name as 
    select id, name
    from student

create materialized view student_id_name2 as 
    select id, name
    from student

3. transaction 

begin transaction; 
commit; / rollback;

4. constraints

    1) not null, unique,  check, primary key, 


        create table tmp22(
            id varchar(5) not null,
            pw varchar(5),
            primary key(id),
            unique(pw)
        )
        create table tmp11(
            id varchar(5) not null,
            pw varchar(5), 
            primary key(id),
            foreign key(id) references tmp22(pw),
            foreign key(pw) references tmp22(id)
                on update cascade 
                on delete cascade 
                initially deferred
                ,
            check(pw like '_____')
        )

5. assertion 

create assertion a1 check(~)

6. user defined type

create type Dollars as numeric(12,2) final;

7. domains

create domain person_name char(20) not null;
create domain Dollars numeric(12, 2) not null;

create table tmp (
    dollar Dollars
)

8. index

create index student_id on student(id)
빠른 접근이 가능하지만, attiribute의 변화가 생겼을 시에는 다시 index를 지정해줘야함.

9. authorization

grant all privileges on takes to sangyeob with grant option
revoke all privileges on takes from sangyeob cascade
revoke all privileges on takes from sangyeob restrict

