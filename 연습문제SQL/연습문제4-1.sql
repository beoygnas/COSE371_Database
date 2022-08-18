1 

select name, title, instructor.dept_name, course.dept_name
from instructor
    inner join teaches using(id)
    -- inner join section using(course_id, sec_id, semester, year)
    inner join course using(course_id)
where semester = 'Spring' and year = 2017

select name, title
from student natural join takes natural join course

select name, title
from student 
    inner join takes using(id)
    inner join section using(course_id, sec_id, semester, year)
    inner join course using(course_id)

2. 
    a) join 쓰는 법

        select id, count(sec_id)
        from instructor natural left outer join teaches
        group by id

    b) subquery로 작성 

        select id, 
            (select count(*) 
            from teaches as t
            where t.id = i.id)
        from instructor as i 
    //진짜 미쳣다 이거 씨발..

    c) null인거 확인 -> is null 사용

        select id, name, 
            case 
                when course_id is null then '-'
                else course_id
            end as course_id,
            sec_id, semester, year
        from section
            natural full outer join teaches
            natural full outer join instructor

      select id, decode(salary, null, 'N/A', salary) as salary
      from instructor

      select id, 
        case when name is null then '-' else name end as name,
        course_id, sec_id, semester, year
        from instructor
            full outer join teaches using(id)
            full outer join section using(course_id, sec_id, semester, year)
        where semester = 'Spring' and year= 2018

    d)
        select dept_name, count(id)
        from department 
            natural left outer join instructor
        group by dept_name
3번 
    select * from student natural left outer join takes

    (select *
    from student 
        natural inner join takes)
    union
    select id, name, dept_name, tot_cred, null, null, null, null, null
    from student as s
    where not exists(
        select * 
        from takes as t
        where s.id = t.id
    )
    


    select * from student natural full outer join takes


    (select *
    from student 
        natural inner join takes)
    union
    select id, name, dept_name, tot_cred, null, null, null, null, null
    from student as s
    where not exists(
        select * 
        from takes as t
        where s.id = t.id
    )
    union 
    select id, null, null, null, course_id, sec_id, semester, year, grade
    from takes as t
    where not exists(
        select * 
        from student as s
        where s.id = t.id
    )
    

4번 
    a) relation r과 t의 B의 value가 같은 경우
    b) 당연히 있지


6번
    create view students_grades(id, gpa) as 


        (select id,
            sum( case when grade is null then 0
                    else points*credits end) / 
            sum( case when grade is null then 0
                    else credits end) as gpa
        from student 
            natural left outer join takes
            natural left outer join course
            natural left outer join grade_points
        group by id )    

        union
        (select id, null
            from student as s
            where not exists (select * from takes as t where s.id = t.id)
        )



    select id, sum(course_points)/sum(credits) as gpaf
    from (select id, credits, 
            case when grade is null then 0 
            else points * credits end as course_points
        from takes natural join course
            natural left outer join grade_points) as tmp
    group by id
        

7번
    create table employee(
        id  varchar(5),
        person_name  varchar(20),
        street varchar(20),
        city varchar(20),
        primary key (id)
    )

    create table works(
        id  varchar(5),
        company_name  varchar(20),
        salary numeric(10, 2),
        primary key (id), 
        foreign key (id) references employee,
        unique(company_name, salary),
        check(id like '_____')
    )

    create table works(
        company_name  varchar(20),
        city    varchar(20),
        primary key(company_name)
    )

    create table manages(
        id varchar(5),
        manager_id varchar(5),
        primary key(employee_id),
        foreign key(id) references employee,
        foreign key(manager_id) references employee(id)
    )

8번 

create assertion a1 check (not exists(
    select id, course_id, sec_id, semester, year, time_slot_id
    from teaches natural inner join section
    group by (id, course_id, sec_id, semester, year, time_slot_id)
    having count((building, room_number)) > 1
    ))

9번 
tuple이 delete 되면, 그 tuple의 employee_id를 manager_id로 가지는 모든 tuple들이 삭제된다. 또 삭제된 tuple들을 manager로 
갖는 또다른 tuple들도 연쇄적으로 계속 삭제된다.

10번

a natural full outer join b 

select coalesce(a.name, b.name) as name, coalesce(a.address, b.address) as address, title, salary 
from a full outer join b on (a.name = b.name and a.address = b.address)

11번 

    db는 좀 더 데이터에 민감하기 떄문에

12번 
    내가 권한을 가지고 있어야 그 권한을 줄 수 있기 때문에,

13번 
    1, 2) view에 대한 권한을 가지고 있어도, relation에 대한 권한은 없음. (select x, update o)
    3) view가 특정 조건이 걸려있어서, view에 대해 업데이트를 해 relation에도 insert가 되었는데 특정 조건과 맞지 않는 경우
        ex) geo_instructor





1. 

select id, count(course_id)
from instructor natural left outer join teaches
group by 


select * 
from student
where id not in (select id from takes)


create assertion under2020 
    check (not exists(select year from section where year > 2020))


grant/revoke select on takes to/from sangyeob with grant option
grant/revoke select on takes to/from sangyeob cascade/

create table tmp(
    id varchar(5),
    pw varchar(5),
    primary key(id),
    unique(pw)
)

create table tmp_ref(
    id varchar(5),
    pw varchar(5),
    primary key(id),
    foreign key(id) references tmp,
    foreign key(pw) references tmp(pw)
)