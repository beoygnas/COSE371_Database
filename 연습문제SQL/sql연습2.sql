3.13 DDL
create table person(
    driver_id   char(5),
    name        varchar(20),
    address     varchar(50),
    primary key(driver_id)
)

create table car(
    license_plate   varchar(20),
    model       varchar(20),
    year        numeric(4),
    primary key(license_plate)
)

create table accident(
    report_number   varchar(20),
    year    numeric(4),
    location    varchar(20),
    primary key(report_number)
)

create table owns(
    driver_id   char(5),
    license_plate   varchar(20),
    primary key(driver_id, license_plate),
    foreign key(driver_id) references person,
    foreign key(license_plate) references car
)

create table participated(
    report_number   varchar(20),
    license_plate   varchar(20),
    driver_id       char(5),
    damage_amount   varchar(20),
    primary key(report_number, license_plate),
    foreign key(report_number) references accident, 
    foreign key(license_plate) references car,
    foreign key(driver_id) references person
)

3.14 
a. 
select count(distinct p.driver_id)
from participated as p, person
where p.driver_id = person.driver_id 
    and person.name = 'John Smith'

b. 
update participated 
set damage_amount = 3000
where license_plate = 'AABB2000' 
    and report_number = 'AR2197'

3.15 
a. not exist 이용 존나오래걸림.
select id
from depositor, account
where depositor.id = account.id 
    and not exists(
        (select branch_name 
        from branch 
        where branch_city = 'Brooklyn')
        except 
        (select branch_name
        from branch as b
        where b.branch_name = a.branch_name)
    )


b. 
select sum(amount)
from loan

c. 
select branch_name
from branch
where assets > some(
    select b.assets
    from branch as b
    where b.branch_name = 'Brooklyn'
    )


3.16
a.
select e.id, e.person_name
from employee as e, works as w, company as c
where e.id = w.id 
    and w.company_name = c.company_name
    and c.city = e.city

b. 
select e.id, e.person_name
from employee as e1, manages as m, employee as e2
where e1.manager_id = m.id
    and m.id = e2.id 
    and e2.city = e1.city 

c. 
select e.id, e.person_name, w.salary, w.company_name
from employee as e, works as w
where e.id = w.id
    and w.salary > (
        select avg(salary)
        from works
        where company_name = w.company_name
    )

3.17
a.
update works
set salary = 1.1 * salary
where company_name = 'First Bank Corporation'

b.
update works
set salary = 1.1 * salary 
where id in (
    select id from manages
)

c. 
delete from works
where company_name = 'Small Bank Corporation'

3.18
create table employee(
    id  char(5),
    person_name varchar(20),
    street  varchar(20),
    city    varchar(20),
    primary key(id)
)

create table company(
    company_name    varchar(20),
    city    varchar(20),
    primary key(company_name)
)

create table works(
    id  char(5),
    company_name varchar(20),
    salary  int,
    primary key(id),
    foreign key(company_name) references company
    foreign key(id) references employee
)

create table manages(
    id char(5),
    manager_id  char(5),
    primary(key id),
    foreign key(id) references employee
    foreign key(manager_id) references employee
)

3.19
1) (의미적) 데이터를 저장할 때, 정해지지 않은 값이 있을 수 있다. 이를 표현하기 위해 null이 필요하다.
2) (기능적) 데이터가 없을 경우, 데이터에 대한 접근이나 연산에 대해 아무것도 정해놓지 않는다면 심각한 
오류가 발생할 수 있다. 이를 방지하기 위해 null값과, 이 값에 대한 여러 연산을 미리 정의를
해 놔야 문제 없이 데이터베이스를 다룰 수 있다.

3.20
x <> all(r) 은 
x가 all 뒤에 오는 relation r의 모든 tuples들과 같지 않음을 의미한다.
이는 x에 해당하는 tuple이 r에 없음을 의미하고, 이것은 sql에서 표현하면 not in이다.

3.21 -> 잘 모르겠다..

a. 
who has ~ed at least one : exists 

select distinct m.memb_no, m.name
from member as m, book as bk, borrowed as b
where m.memb_no = b.memb_no 
    and b.isbn = bk.isbn
    and bk.publisher = 'McGraw-Hill'



select m.memb_no, m.name
from member as m
where exists(
    select *
    from book, borrowed
    where book.isbn = borrowed.isbn
        and borrowed.memb_no = m.memb_no
        and publisher = 'McGraw-Hill'   
    )

b. 
every ~ : not exists 

select memb_no, name
from member as m
where not exists(
    (select isbn
    from book
    where publisher = 'McGraw-Hill')
    except
    (select b.isbn
    from borrowd as b, book
    where m.memb_no = b.memb_no
        and b.isbn = book.isbn)
)

c. 이거 헷갈림
for each ~ : group by having

select b.publisher, count(distinct memb_no), 
from book as bk, borrowed as b, memeber as m
where bk.isbn = b.isbn
    and b.memb_no = m.memb_no
group by b.publisher
having count(distinct memb_no) > 5

d.
select m.member, count(b.isbn)/count(distinct m.memb_no)
from member as m, borrowed as b
where m.memb_no = b.memb_no
group by m.member

3.22
where (select count(distinct b.title)
    from (select title from course) as b
    ) = 1 

3.23
과의 연봉 평균보다 더 높은 연봉을 받는 과를 선택
distinct는 변수 앞에.

select dept_name, sum(salary)
from instructor 
group by dept_name 
having sum(salary) > (
    select sum(salary)/count(distinct dept_name)
    from instructor
) 

3.24    
지도 교수가 물리학과인 학생들 선택.
select s.id, s.name
from student as s, advisor as a, instructor as i
where s.id =  a.s_id 
    and i.id = a.i_id 
    and i.dept_name = 'Physics'

3.25
select dept_name 
from department
where budget > (
    select budget
    from department
    where dept_name = 'Music'
)
order by dept_name

3.26
select course_id, id, count(*) as cnt
from takes
group by course_id, id
having count(*) >= 2

3.27
select id, count(*)
from (select course_id, id, count(*) as cnt
    from takes
    group by course_id, id
    having count(*) >=2) as tmp
group by id
having count(*) >= 3

3.28
select distinct i.id, i.name
from instructor as i
where not exists(
        (select course_id
        from course
        where dept_name = i.dept_name)
        except
        (select course_id
        from teaches
        where teaches.id = i.id
        )
)
order by i.name

select t.id, i.name
from instructor as i, teaches as t, course as c
where i.id = t.id 
    and t.course_id = c.course_id 
    and i.dept_name = c.dept_name
group by t.id, i.name, i.dept_name
having count(distinct t.course_id) = (
    select count(distinct course_id)
    from course
    where dept_name = i.dept_name
    ) 
order by i.name

3.29 
who has not taken -> exist

select distinct s.id, s.name
from takes as t, student as s
where t.id = s.id 
    and s.name like 'B%'
    and not exists(
        select id
        from course as c , takes
        where c.dept_name = 'Music'
            and c.course_id = takes.course_id
        group by id
        having id = s.id and 
            count(*) >= 5
    )

select distinct s.name, s.id
from student as s, takes as t, course as c
where s.id = t.id
    and s.name like 'B%'
    and t.course_id = c.course_id
group by s.name, s.id, c.dept_name
having count(distinct t.course_id) < 5 
    and c.dept_name = 'Music'
 

select s.name, s.id
from student as s
where s.dept_name = 'Comp. Sci.'
    and s.name like '_han%'
    and s.id in (
        select t.id
        from takes as t, course as c
        where t.course_id = c.course_id
            and c.dept_name = 'Comp. Sci.'
        group by t.id
        having count(distinct t.course_id) >= 2
    )

3.30
instructor가 한명이 연봉이 비어있을 경우(null인 경우)
count(*)는 그 인원까지 세지만, avg에서는 그 인원을 제외한 평균을 내게된다.
그렇게 되면 계산결과가 달라져 0이 아니게 됨.

3.31 
이렇게 복잡할리가 없어 ㅅㅂ
select distinct i.name,  i.id
from instructor as i, teaches as t, takes as tk
where (i.id = t.id 
    and (t.course_id, t.sec_id, t.semester, t.year) 
        = (tk.course_id, tk.sec_id, tk.semester, tk.year)
    and not exists(
        select takes.course_id
        from takes, teaches
        where (takes.course_id, takes.sec_id, takes.semester, takes.year) 
            = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
            and teaches.id = t.id
            and takes.grade = 'A'
        )
    )
    or (
        i.id not in (
            select distinct id 
            from teaches
            )
    )

(select name from instructor)
except 
(select name 
from instructor as i, takes, teaches as t
where  (takes.course_id, takes.sec_id, takes.semester, takes.year)
 = (t.course_id, t.sec_id, t.semester, t.year)
 and i.id = t.id
 and takes.grade = 'A')

3.32
select distinct i.name,  i.id
from instructor as i, teaches as t, takes as tk
where (i.id = t.id 
    and (t.course_id, t.sec_id, t.semester, t.year) 
        = (tk.course_id, tk.sec_id, tk.semester, tk.year)
    and not exists(
        select takes.course_id
        from takes, teaches
        where (takes.course_id, takes.sec_id, takes.semester, takes.year) 
            = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
            and teaches.id = t.id
            and takes.grade = 'A'
        )
    )

(select distinct name 
from instructor as i, takes, teaches as t
where  (takes.course_id, takes.sec_id, takes.semester, takes.year)
= (t.course_id, t.sec_id, t.semester, t.year)
and i.id = t.id
and takes.grade is not null
)
except 
(select name 
from instructor as i, takes, teaches as t
where  (takes.course_id, takes.sec_id, takes.semester, takes.year)
 = (t.course_id, t.sec_id, t.semester, t.year)
 and i.id = t.id
 and takes.grade = 'A')

3.33
select distinct c.course_id, c.title
from time_slot as ts, section as s, course as c
where s.time_slot_id = ts.time_slot_id
    and ts.end_hr >= 12
    and s.course_id = c.course_id
    and c.dept_name = 'Comp. Sci.'

select distinct course_id, title
from course as c 
where dept_name = 'Comp. Sci.'
    and exists(
        select * 
        from section as s, time_slot as t
        where s.time_slot_id = t.time_slot_id
            and t.end_hr >= 12
            and s.course_id = c.course_id
        )

3.34
select s.course_id as courseid, s.sec_id as secid, s.year as year, 
    s.semester as semester, count(distinct t.id) as num
from section as s, takes as t
where (s.course_id, s.sec_id, s.semester, s.year) = 
    (t.course_id, t.sec_id, t.semester, t.year)
group by s.course_id, s.sec_id, s.semester, s.year
having count(distinct t.id) > 0

3.35

with enrollment(courseid, secid, year, semester, num) as 
(
    select s.course_id as courseid, s.sec_id as secid, s.year as year, 
        s.semester as semester, count(distinct t.id) as num
    from section as s, takes as t
    where (s.course_id, s.sec_id, s.semester, s.year) = 
        (t.course_id, t.sec_id, t.semester, t.year)
    group by s.course_id, s.sec_id, s.semester, s.year
    having count(distinct t.id) > 0
)
select max(num)
from enrollment 

with max_budget(value) as 
    (select max(budget)
    from department)
select department.dept_name
from department, max_budget
where department.budget = (select max(budget)
    from department)


with로 최소/최대 relation을 가져오면 오류남.

select s.id, s.name, c.dept_name, count(distinct c.course_id) as cnt
from student as s, takes as t, course as c
where s.id = t.id
    and t.course_id = c.course_id
    and c.dept_name = 'Biology'
group by s.id, s.name, c.dept_name
having count(distinct c.course_id) = (
    select count(distinct course_id)
    from course
    where course.dept_name = c.dept_name
)

select distinct s.id, s.name
from student as s
where not exists(
    (select course_id from course
    where dept_name = 'Biology')
    except 
    (select t.course_id from takes as t
    where s.id = t.id)
);

select distinct s.id,  s.name 
from student as s
where not exists(
        select * 
        from takes
        where takes.id = s.id  
            and takes.year < 2019
    )

with ms(dept_name, max_salary) as (
    select dept_name, max(salary)
    from instructor
    group by dept_name
)
select dept_name
from ms
where max_salary = (
    select min(max_salary)
    from ms 
)

(select course_id
from section
where year = 2017
group by course_id
having count(*) = 1
)
except 
(select course_id
from section
where year <> 2017)
// 다른 해에도 열린 수업은 제외

(select id, name
from student )
except 
(select distinct s.id, s.name
from takes as t, student as s 
where t.id = s.id  and t.year <> 2018
);