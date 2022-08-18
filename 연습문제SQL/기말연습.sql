1. join 

inner join vs outer join : 정보를 삭제하냐 마느냐 

    inner join 
        select * 
        from course natural inner join prereq;

    outer join - 
        left vs right vs full : 왼쪽을 기준으로 남길 거냐, 오른쪽을 기준으로 남길 거냐, 둘다 남길거냐.

        1.  select * 
            from course natural left outer join prereq;

        2.  select * 
            from course natural right outer join prereq;

        3.  select * 
            from course natural full outer join prereq;

natural / on / using - 조인을 할건데, 어떤 column을 기준으로 condition을 정할 거냐
    natural : 그냥 알아서, 겹치는 것만 
    on : 특정 조건에서 맞는 것만 하겠다.

        select * 
        from course inner join prereq on course.course_id = prereq.course_id

    using : on과 똑같지만 겹치는 column은 삭제한다.

        select * 
        from course inner join prereq using (course_id) 
    
        select * 
        from course left outer join prereq using (course_id);



2. view : virtual relation을 만드는 것으로, 실제로 relation은 만드는 것이 아니기 떄문에 update/insert 여러 제약 조건이 붙음.
    - view는 원래 참조하는 table의 값이 바뀌면 자동으로 update
    - 그러나 materialized view는 생성시의 값이 저장되고 update 되지 않음(out of date)
    - view의 update : view에서 update 하면, 원래 relation에는 안되는 경우도 있고, null이 들어가는 경우도 있음.
    - view에 insert를 했는데, view에는 그 tuple이 들어갈 수 없어 원래 table에만 들어가는 경우도 있음.

    - simple view 에서만 update를 허용
        - from 절은 하나의 relation만
        - select 그 relation에 attribute만을 가지고 있으며, expression, aggregate, distinct 등등이 있으면 안됨.
        - view의 select 절에는 없지만, 원래 relation에는 있는 attribute에는 null로 세팅
        - group by, having 있으면 안됨!

    create view dept_salary2 as 
        select distinct dept_name, sum(salary)
        from instructor 
        group by dept_name

    create view salary_instructor as
        select distinct id, salary
        from instructor
    insert into salary_instructor values('11555', 120000)
    select * from dept_salary

    create materialized view dept_salary as 
        select dept_name, sum(salary)
        from instructor 
        group by dept_name


    create view history_instructor as
        select * 
        from instructor
        where dept_name = 'History'

    insert into history_instructor values('25566','Brown', 'Biology', 100000)


3. transaction 

    begin transaction; 
    이 사이에 여러 sql이 들어갈 수 있고, 이 sql 여러개는 atomic transaction으로 처리됨. 
    commit; rollback;
    
4. integrity constraints

    1) constraint on single relation -> DDL에서, 테이블을 만들 때 작성
        - not null, primary key, unique, check(predicate)
        - unique(a1, a2, a3 ... )
            - 다음 attribute 집합에는 unique한 값을 가져야한다. -> 즉 candidate key다
            - candidate key는 primary key와 다르게 null 값을 가질 수 있다. -> 즉 attribute 중 몇 개를 null로 채워도 unique하다면 무방.
            - unique(course_id, sec_id, semester, year, time_slot_id)
        - check(semester in ('Fall', 'Winter', 'Spring', 'Summer'))
    
    2) referential integrity -> DDL에서, 테이블을 만들 때 작성
        - foreign key는 다른 tagble의 primary key를 참조해야 한다.
        - foreign key(dept_name) references department
        - foreign key(dept_name) references department(dept_name) : 명시 할 수 있으며, 꼭 unique한 놈이어야 함.
        - foreign key는 null이 될 수 있다. 하지만 primary key는 null이 절대 될 수 없다.
    
        - cascading action : 종속/ 위에서 아래로 흐르는 action 
            create table course(
                ..
                foreign key(dept_name) referneces department
                    on delete cascade
                    on update cascade 
                ..
            ); -> 이렇게 선언하면 department에서 dept_name이 사라지면, course에서도 그 dept_name갖고 있는놈이 사라지고, update 됨.


            create table course(
                ..
                foreign key(dept_name) referneces department
                    on delete cascade
                    on update cascade 
                ..
            ); 

            create table dpt(
                dept_name varchar(10),
                primary key(dept_name)
            );
            insert into dpt values('data')

            create table cs(
                course varchar(10),
                dept_name varchar(10),
                primary key(dept_name),
                foreign key(dept_name) references dpt
                    on delete cascade
                    on update cascade
            );

            create table cs2(
                course varchar(10),
                dept_name varchar(10),
                foreign key(dept_name) references dpt
                    on delete set null
                    on update set default
            );
            insert into dpt values('data');
            insert into cs values('1', 'data');
            insert into cs2 values('2', 'data');
    
    3) transaction에서 integrity
        create table person(
            id char(10),
            spouse char(10),
            primary key(id), 
            foreign key(spouse) references person initially deferred
        );

        create table person2(
            id char(10),
            spouse char(10),
            primary key(id), 
            foreign key(spouse) references person
        );

        initially deferred 
        transaction 일 경우 : set constraints [constraint-list] deferred : 이걸로, 

        begin transaction 
            insert into person values('1111111111', '2222222222');
            insert into person values('2222222222', '1111111111');
        commit;

    4) check 
        check(time_slot_id in (select time_slot_id) from time_slot))
        -> check 안에 predicate에는 subquery 같이 복잡한 게 들어갈 수 있지만, 그 relation이 바뀔 때마다 
            해야하므로 성능이 좋진 않다.

    5) assertion : one relation 뿐만 아니라 모든 relation schema에 대한 constraint를 걸 수 있다.
        
        ex) an instructor cannot teach in two differenct classrooms in a semester 
            in the same time_slot

            create assertion i_2_classromms check (not exists( 
            select * from (
                select course_id, sec_id, semester, year, id time_slot_id, count(room_number) as cnt
                from teaches inner join section using(course_id, sec_id, semester, year)
                group by course_id, sec_id, semester, year, id, time_slot_id) as num_room
            where cnt > 1)); 

            not exist (with num_room as (
            select course_id, sec_id, semester, year, id time_slot_id, count(room_number) as cnt
            from teaches 
                inner join section using(course_id, sec_id, semester, year)
            group by course_id, sec_id, semester, year, id, time_slot_id)
            select * from num_room 
            where cnt >= 2 ) 


5. user-defined types / domain

    create type dollars as numeric(12, 2) final;
    domain은 constraint를 붙일 수 있다.
    create domain person_name char(20) null

    create domain degree_level varchar(20) 
        constraint degree_level_test
            check(value in('Barchelors', 'Master', 'Doctorate'));


6. Index -> 특정한 값을 찾기 위해, 모든 attribute를 보는 건 의미가 없다. index를 통해 쉽게 찾을 수 있다.
    
    create index  

7. Authorization 

    문법 : grant/revoke [privilege : select, insert, update, delete, all privileges]  
            on [relation or view : department, student, ... ]
            to [user list : postgres, sangyeob, admin..]

    revoke는 낱개로 밖에 못가져간다.


create view geo_instructor as (
    select * from instructor
    where dept_name = 'Geology');
)