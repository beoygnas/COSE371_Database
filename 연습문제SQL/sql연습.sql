3.1
a)
select title
from course
where dept_name = 'Comp. Sci.'
    and credits = 3

b) 
select distinct tk.id
from takes as tk, teaches as t, instructor as i
where (tk.course_id, tk.sec_id, tk.semester, tk.year)
 =(t.course_id, t.sec_id, t.semester, t.year)
    and t.id = i.id
    and i.name = 'Einstein';
 
c)
select max(salary)
from instructor

d) 
select name
from instructor
where salary >= (
    select max(salary)
    from instructor
) 

e)
select (s.course_id, s.sec_id, s.semester, s.year), count(distinct t.id) as enrollment
from section as s, takes as t
where (s.course_id, s.sec_id, s.semester, s.year) 
    = (t.course_id, t.sec_id, t.semester, t.year) 
    and t.year = 2017
    and t.semester = 'Fall'
group by (s.course_id, s.sec_id, s.semester, s.year)

f)
select max(enrollment)
from (select (s.course_id, s.sec_id, s.semester, s.year), count(distinct t.id) as enrollment
    from section as s, takes as t
    where (s.course_id, s.sec_id, s.semester, s.year) 
        = (t.course_id, t.sec_id, t.semester, t.year) 
    group by (s.course_id, s.sec_id, s.semester, s.year)
    ) as enrollment_section


with enrollment_section(course_id, sec_id, semester, year, enrollment) as 
(select s.course_id, s.sec_id, s.semester, s.year, count(distinct t.id) as enrollment
from section as s, takes as t
where (s.course_id, s.sec_id, s.semester, s.year) 
    = (t.course_id, t.sec_id, t.semester, t.year) 
group by (s.course_id, s.sec_id, s.semester, s.year))
select max(enrollment)
from enrollment_section

g)
with enrollment_section(course_id, sec_id, semester, year, enrollment) as 
    (select s.course_id, s.sec_id, s.semester, s.year, count(distinct t.id) as enrollment
    from section as s, takes as t
    where (s.course_id, s.sec_id, s.semester, s.year) 
        = (t.course_id, t.sec_id, t.semester, t.year) 
    group by (s.course_id, s.sec_id, s.semester, s.year))
select course_id, sec_id, semester, year
from enrollment_section
where enrollment = (
    select max(enrollment)
    from enrollment_section
)

3.2 
create table grade_points(
    grade   varchar(2),
    points  numeric(2,1)
)

insert into grade_points values('A+', 4.3);
insert into grade_points values('A', 4.0);
insert into grade_points values('A-', 3.7);
insert into grade_points values('B+', 3.3);
insert into grade_points values('B', 3.0);
insert into grade_points values('B-', 2.7);
insert into grade_points values('C+', 2.3);
insert into grade_points values('C', 2.0);
insert into grade_points values('C-', 1.7);
insert into grade_points values('D+', 1.3);
insert into grade_points values('D', 1.0);
insert into grade_points values('D-', 0.7);
insert into grade_points values('F', 0.0);

a)
select sum(gp.points * c.credits)
from grade_points as gp, takes as t, course as c
where gp.grade = t.grade
    and t.course_id = c.course_id
group by t.id
having t.id = '12345'

b) 
select t.id, sum(gp.points * c.credits) / sum(c.credits) as gpa
from grade_points as gp, takes as t, course as c
where gp.grade = t.grade
    and t.course_id = c.course_id
group by t.id
having t.id = '12345'

c) 
select t.id, sum(gp.points * c.credits) / sum(c.credits) as gpa
from grade_points as gp, takes as t, course as c
where gp.grade = t.grade
    and t.course_id = c.course_id
group by t.id

d) null은 어떻게? 성적이 없으면, 조인 시에 학점 계산에서 제거가 잘 될 것이니 상관없이 동작한다.

3.3
a)
update instructor 
set salary = 1.1*salary
where dept_name = 'Comp. Sci.'

b) 
delete from course
where course_id not in (
    select distinct course_id
    from section
)

c)
insert into instructor 
select id, name, dept_name, 10000
from student
where tot_cred > 100


3.4
a) 
select distinct person.name
from participated as p, person, accident as a
where p.license_plate = person.license_plate
    and p.report_number = a.report_number
    and a.year = 2017

b)
delete from car
where year = 2010 and license_plate in (
    select license_plate 
    from owns
    where driver_id = '12345'
)

3.5 
a) 
create table marks(
    id char(5),
    score int,
    primary key(id, score)
)

alter table marks add grade char(1); 
update marks set grade = 'A' where score >= 80;
update marks set grade = 'B' where score >= 60 and score < 80;
update marks set grade = 'C' where score >= 40 and score < 60;
update marks set grade = 'F' where score < 40;

답지) 
select id, 
    case 
        when score < 40 then 'F'
        when score < 60 then 'C'
        when score < 80 then 'B'
        else 'A'
    end
from marks

b) 
select grade, count(*) from marks
group by grade
order by grade

3.6 
select * from department
where upper(dept_name) like '%SCI%'

lower() function 이 뭐여 안배운거같음.
-> 얘는 대소문자 안가려줌.

3.7
어떠한 조건에서 쿼리가 p.a1이 r1과 r2 중 하나를 고를까?
둘중하나가 비었다면, 안 빈 하나를 고를 것이고
둘다 비었다면, 못고르고
둘다 같다면, 먼저 나온 r1?이 더 맞을 것이다. 
근데 어차피 같은 값만 가져오는건데 무슨 의미가 있는지?

// 땡
// 둘다 안비어있다면, 같은 값이므로 그냥 아무거나 고름
// 하지만 하나라도 비어있다면, cartesian 곱을 하면 그 행은 사라짐 -> 따라서 null 
// 결과는 empty

create table p(
    a1 int
);
create table r1(
    a1 int
);
create table r2(
    a1 int
);
insert into p values(5);
insert into r1 values(5);
insert into r2 values(5);

3.8 
a.
(select id from customer)
except 
(select id from borrower)

b. // 굳이 서브쿼리로 안하고, 그냥 cartesian곱으로 해도 될듯.
select id from customer 
where customer_street = (
    select c.customer_street 
    from customer as c
    where c.id = '12345'
)

c. 
이거 진짜 좆같다.// 굳이 branch_name 안해도 됐음.

select distinct_name a.branch_name
from customer as c, account as a, depositor as d
where c.id = d.id 
    and a.account_number = d.account_number  
    and c.customer_city = 'Harrison'

?

select branch_name
from branch as b
where exists(
    select distinct id 
    from account, depositor, customer
    where account.account_number = depositor.account_number
        and customer_id = depositor.id
        and cusotomer 
        andn customer_city = 'Harrsion'
)


3.9 
a.
select e.id, e.person_name, e.city
from employee as e, works as w
where e.id = w.id and
    w.company_name = 'First Bank Corporation'

b. 
select e.id, e.person_name, e.city
from employee as e, works as w
where e.id = w.id 
    and w.company_name = 'First Bank Corporation'
    and w.salary > 10000

c. 
select *
from works as w
where w.company_name <> 'First Bank Corporation'

(select w.id from works as w)
except
(select w.id from works as w
where w.company_name = 'First Bank Corporation')

d. 
select id, salary from works 
where salary > all(
    select w.salary
    from works as w
    where w.company_name = 'Small Bank Corporation'
)

select company_name
from company
where city = (
    select city 
    from company
    where company_name = 'Small Bank Corportation'
)





e. 
select company_name from company
where city = (
    select c.city
    from company as C
    where c.company_name = 'Small Bank Corporation'
)

f. 
select company_name
from works
group by company_name
having count(distinct id) >= all(
    select count(distinct id)
    from works
    group by company_name
)

g. 
select company_name 
from works
group by company_name
having avg(salary) > (
    select avg(salary)
    from works
    where company_name = 'First Bank Corporation'
    )  

언제쓰면 될까 -> aggregate을 무조건써야할떄
join말고 having 하는게 편할 때가 많다.
in 과 not in

select dept_name, sum(salary)
from instructor
group by dept_name
having sum(salary) > (
    select avg(sum_salary)
    from (select sum(salary)
        from instructor
        group by dept_name) as tmp(sum_salary))

3.10 
update employee
set city = 'Newton' 
where id = '12345'

3.11 
a.
select distinct s.id, s.name
from takes as t , course as c, student as s
where t.course_id = c.course_id 
    and s.id = t.id
    and c.dept_name = 'Comp. Sci.'

b. 
select distinct s.id, s.name
from takes as t1, student as s
where t1.id = s.id 
    and not exists(
        select * 
        from takes as t2
        where t1.id = t2.id and year < 2018
    )

c. 
select dept_name, max(salary) 
from instructor
group by dept_name

d. 
select min(salary) as min_salary
from (
    select dept_name, max(salary) as salary
    from instructor
    group by dept_name
) as m_salary

특정한 값 가지는 놈 찾기 -> 
with 보다
서브 쿼리에 aggregate function
select name, salary
from instructor
where salary = (
    select min(salary)
    from instructor
)

3.12
a. 
insert into course values ('CS-001', 'Weekly Seminar','Comp. Sci.', 2)

b. 
insert into section values 
('CS-001', '1', 'Fall', '2017', null, null, null)

c. 
insert into takes
    select id, 'CS-001', '1', 'Fall', '2017'
    from student 
    where dept_name = 'Comp. Sci.'

d. 
delete from takes
    where id = '12345';

e. 
delete from course
    where course_name = 'CS-001'

-> cs-001를 참조하고 있던 takes의 모든 tuple들이 제거되었다.

f. 
delete from takes
    where course_id in (
        select course_id 
        from course
        where title like '%advanced%' 
            and title <> 'advanced'
    ) 
