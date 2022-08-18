14번.
    natural join section을 해도, takes와 (course_id, sec_id, semester, year)에 대해서 
    natural inner join을 하기 때문에 결과에는 지장이 없다. + takes 와는 이미 foreign key constraint가 걸려있기 때문에 다 겹침.


15번.
    select * 
    from section 
        inner join classroom using(building, room_number)

    select * from section natural join classroom   

16번

    select distinct id
    from student
        natural left outer join takes 
    -- where course_id is null
    group by id
    having count(course_id) = 0


17번
    select id
    from student 
        left outer join advisor on (student.id = advisor.s_id) 
    where i_id is not null

18번 
    1) outer join
    select id 
    from employee as e
        left outer join manages as m on (e.id = m.id)
    where m_id is null 

    2) outer join 안쓰고
    (select id from employee)
    except
    (select id from manages where mangaer_id is not null)


19번 
    학생들이 들은 수업 list dept_name이 같다면 이름 알려줌. 
    1) student와 course의 dept_name이 겹치지 않으면 title에 null이 나올 수 있음.
    2) 수업을 듣지 않은 학생은 title에 null이 나옴

20번
    create view t0t_credits(year, num_credits) as 
        select year, sum(credits)
        from takes natural inner join course
        group by year 

21번
    4.20로 봤을 때) group by로 만들어진 view에 삽입을 할 경우, 원래 relation에 어떻게 삽입되야할지가 모호하기 때문이다.
    4.18로 봤을 때) 두 개의 테이블을 보고 있으므로, 어떻게 삽입을 할지가 진짜 애매해짐

22번. 
    coalesce(a, b) 
    =
    case 
        when a is null then b 
        else a
    end    

23번. 
    satoshi에게 권한이 있는게 아니라, satoshi의 role인 manager에게 권한이 있기 때문이다.

24번.
    psql로 돌려보니까 되긴하는데, authorization graph가 뭐야 시벌;;

25번.


26번.
    integrity constraints는, relation schema가 data에 대해 가져야 하는 조건에 대한 제약이고,
        : data consistency를 초래하는 authroized database change를 막아주는 역할을 함.
        : 
    authorization constraint는 user 입장에서 relation schema에 접근 시에 가지는 제약이다.
 

 create table student2(

 )

select id
from student 
    natural left outer join takes
group by id
having count(course_id) = 0


select id 
from student
where id not in (select id from takes)