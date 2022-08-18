3.23
    (select count(distinct title) from course) = 1

3.24
    select s.id, s.name
    from student as s
        inner join advisor on s.id = s_id 
        inner join instructor as i on i.id = i_id
    where i.dept_name = 'Physics'

3.25 
    select dept_name
    from department
    where budget >= (select budget from department 
                    where dept_name = 'History')

3.26 
    select id, course_id, count(*)
    from student
        natural inner join takes
    group by id, course_id
    having count(*) >= 2

3.27 
    with retake as (
        select id, course_id, count(*) as cnt
        from student
            natural inner join takes
        group by id, course_id
        having count(*) >= 2
    )
    select id
    from retake
    group by id
    having count(*) >= 3


3.28 
    select *
    from instructor as i
    where 
        not exists(
        (select course_id from course
        where dept_name = i.dept_name)
        except
        (select course_id from teaches
        where id = i.id) 
        )

3.29
    select *
    from student as s
    where s.name like 'B%' 
        and dept_name = 'History'
        and (select count(*)
            from takes 
                natural inner join course
            where name = s.name
                and dept_name = 'Music') < 5

3.31 

    select name, id from instructor
    except
    select name, teaches.id 
    from teaches
        inner join instructor using(id)
        inner join takes using(course_id, sec_id, semester, year)
    where grade = 'A'
    
3.32 

    select name, id from instructor
    except
    select distinct name, teaches.id
    from teaches
        inner join instructor using(id)
        inner join takes using(course_id, sec_id, semester, year)
    where grade = 'A' or grade is null


3.33 
select distinct course_id, title
from section 
    natural inner join course 
    natural inner join time_slot
where end_hr >= 12 and dept_name = 'Comp. Sci.'

3.34 
select course_id, sec_id, year, semester, count(distinct id) as cnt
    from takes
    group by (course_id, sec_id, year, semester)

3.35 
 
with enrollment as
    (select course_id, sec_id, year, semester, count(distinct id) as cnt
    from takes
    group by (course_id, sec_id, year, semester)),
max_enrollment as 
    (select max(cnt) as max
    from enrollment)
select *
from enrollment, max_enrollment
where cnt = max

3.1 

