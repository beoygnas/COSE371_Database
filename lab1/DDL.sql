create table classroom
	(building varchar(15),
	 room_number varchar(7),
	 capacity numeric(4,0),
	 primary key (building, room_number)
	);

create table department
	(dept_name varchar(20), 
	 building varchar(15), 
	 budget numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

create table course
	(course_id varchar(8), 
	 title varchar(50), 
	 dept_name varchar(20),
	 credits numeric(2,0) check (credits > 0),
	 primary key (course_id),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table instructor
	(ID varchar(5), 
	 name varchar(20) not null, 
	 dept_name varchar(20), 
	 salary numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table section
	(course_id varchar(8), 
         sec_id varchar(8),
	 semester varchar(6)
		check (semester in ('Fall', 'Winter', 'Spring', 'Summer')), 
	 year numeric(4,0) check (year > 1701 and year < 2100), 
	 building varchar(15),
	 room_number varchar(7),
	 time_slot_id varchar(4),
	 primary key (course_id, sec_id, semester, year),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (building, room_number) references classroom (building, room_number)
		on delete set null
	);

create table teaches
	(ID varchar(5), 
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references instructor (ID)
		on delete cascade
	);

create table student
	(ID varchar(5), 
	 name varchar(20) not null, 
	 dept_name varchar(20), 
	 tot_cred numeric(3,0) check (tot_cred >= 0),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table takes
	(ID varchar(5), 
	 course_id varchar(8),
	 sec_id varchar(8), 
	 semester varchar(6),
	 year numeric(4,0),
	 grade varchar(2),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references student (ID)
		on delete cascade
	);

create table advisor
	(s_ID varchar(5),
	 i_ID varchar(5),
	 primary key (s_ID),
	 foreign key (i_ID) references instructor (ID)
		on delete set null,
	 foreign key (s_ID) references student (ID)
		on delete cascade
	);

create table time_slot
	(time_slot_id varchar(4),
	 day varchar(1),
	 start_hr numeric(2) check (start_hr >= 0 and start_hr < 24),
	 start_min numeric(2) check (start_min >= 0 and start_min < 60),
	 end_hr numeric(2) check (end_hr >= 0 and end_hr < 24),
	 end_min numeric(2) check (end_min >= 0 and end_min < 60),
	 primary key (time_slot_id, day, start_hr, start_min)
	);

create table prereq
	(course_id varchar(8), 
	 prereq_id varchar(8),
	 primary key (course_id, prereq_id),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (prereq_id) references course (course_id)
	);


#3.22
(select count(b.name)
from course b
where a.title=b.title)=1

#3.23
select distinct(dept_name),salary
from instructor
where salary>=(
    select avg(salary)
    from instructor
);
#3.24
select s.name,s.id
from student s
join advisor a
on s.id=a.s_id
join instructor i
on i.id=a.i_id
where i.dept_name='Physics'

#3.25

select d.dept_name
from department d
where d.budget>
(select budget from department where dept_name='Philosophy')
order by dept_name;

#3.26
select distinct(t.id),t.course_id
from takes t
where (select count(*) from takes t1 where t1.course_id=t.course_id and t.id=t1.id)>=2;

#3.27

select distinct(t.id),t.course_id
from takes t
where (select count(*) from takes t1 where t1.course_id=t.course_id and t.id=t1.id)>=3;

#3.28

gg

#3.29
select s.name,s.id
from student s 
where s.name like 'D%' and 
(select count(*) from takes t 
join course c 
on t.course_id=c.course_id
where t.id=s.id and c.dept_name='Music' 
)<5;

at least : 다중조인 -> distinct 필수 , exist
every : not exist , having / inner outer query


select t.student_id
from takes t 
join course c
on t.course_id = c.course_id 
where c.dept_name = 'Biology'
group by t.student_id
having count(distinct t.course_id) = (select count(*) from course c2 where c2.dept_name = 'Biology');

select s.id, s.name
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