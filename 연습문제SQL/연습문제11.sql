11.3 

select 
    year,
    case when course_id is null then 'all' else course_id 
    end as course_id, 
    case when sec_id is null then 'all' else sec_id 
    end as sec_id,
    case when semester is null then 'all' else semester
    end as semester,
    count(distinct id)
from takes
group by rollup(year, (course_id, sec_id, semester)) 


select year, course_id, count(distinct id)
from takes
group by cube(year, course_id)


11.4 

select store_id, city, state, country,
    date, month, quarter, year,
    sum(price), sum(number)
from sales 
    inner join store using(store_id)
    inner join date_info using(date)
group by rollup(store_id, city, state, country), 
    rollup(date, month, quarter, year)


11.5 

select * from student
    natural join takes natural join course
select * 
from student
    inner join takes using(id)
    inner join course using(course_id)


select * from course
    natural left outer join prereq;

select * from course
    natural right outer join prereq;

select * from course
    natural full outer join prereq;

select * from prereq;


select inventory_id, customer_id, count(*)
from rental
group by inventory_id, customer_id
order by (count(*)) desc

where inventory_id = 1828 and inventory_id = 1828 and inventory_id = 1828 and 
    c   ustomer_id <= 3  
group by cube(inventory_id, customer_id)


1. 기본
select rental_duration, rental_rate, rating, count(*)
from film
where rental_duration >= 5 and rental_duration <= 6
group by rollup(rental_duration, rental_rate, rating)


select rental_duration, rental_rate, rating, count(*)
from film
where rental_duration >= 5 and rental_duration <= 6
group by grouping sets(rental_duration, 
    (rental_duration, rental_rate),
    (rental_duration, rental_rate, rating), 
    ())
order by(rental_duration, rental_rate, rating)


select rental_duration, rental_rate, rating, count(*)
from film
where rental_duration >= 5 and rental_duration <= 6
group by cube(rental_duration, rental_rate, rating)


select rental_duration, rental_rate, rating, count(*)
from film
where rental_duration >= 5 and rental_duration <= 6
group by grouping sets(
    rental_duration, rental_rate, rating,
    (rental_duration, rental_rate), (rental_rate, rating), (rental_duration, rating),
    (rental_duration, rental_rate, rating),
    ())
order by(rental_duration, rental_rate, rating)


select 
    extract(year from rental_date) as Y,
    extract(month from rental_date) as M,
    extract(day from rental_date) as D,
    count(*), 
    
from rental
group by rollup(Y, M, D)


select *, sum(tot_cred) over(partition by dept_name order by tot_cred)
from student

with avg_salary as (
    select dept_name, avg(salary) as avg
    from instructor
    group by dept_name
)   
select *, (select avg from avg_salary
                where dept_name = i.dept_name) as avg
from instructor as i 
order by dept_name


with inst_salary2 as (
    select *, avg(salary) over(partition by dept_name) as dept_avg
    from instructor
)
select *, dense_rank() over(partition by dept_name order by salary desc)
from inst_salary2





실습 
1. 
select rental_rate, rating, count(*)
from film
-- group by grouping sets(rental_rate, rating)
group by rental_rate, rating


2. 
select actor_id, name, count(distinct film_id)
from film_actor
    inner join film_category using(film_id)
    inner join category using (category_id)
where actor_id = 1 or actor_id = 2
group by cube(actor_id, name)

3. 

select 
    extract(year from rental_date) as y, 
    extract(month from rental_date) as m, 
    extract(day from rental_date) as d, 
    sum(amount)
from rental 
    natural inner join payment 
group by rollup(y, m, d)

4.

select * 
from
    (select name, customer_id, count(rental_id) as cnt, rank() over (partition by name order by count(rental_id) desc) as rank
    from category 
        natural inner join film_category 
        natural inner join inventory 
        natural inner join rental 
    group by name, customer_id) as tmp
where rank <= 2



with a as(
    select name, customer_id, count(rental_id) as cnt
    from category natural join film_category 
        natural join inventory
        natural join rental
    group by name, customer_id
),
b as (
    select *, rank() over (partition by name order by cnt desc) as rank
    from a
)
select * 
from b
where rank<=2

5. 

with a_total as (
    select customer_id, sum(amount) as tot
    from customer natural inner join payment
    group by customer_id
),
b_total as (
    select customer_id, tot, country, sum(tot) over (partition by country_id ) as sum
    from a_total 
        natural join customer
        inner join address using (address_id)
        inner join city using(city_id)
        inner join country using (country_id)
)
select *, dense_rank() over (order by sum desc)
from b_total



with a as (
    select customer_id, sum(amount) as sum1, address_id
    from customer
        natural inner join payment
    group by customer_id, address_id
), 
b as (
    select customer_id, sum1, country, sum(sum1) over (partition by country_id) as sum2
    from a 
        natural inner join address
        natural inner join city 
        inner join country using(country_id)
)
select *, dense_rank() over (order by sum2 desc)
from b 

with a as (
    select customer_id, address_id, sum(amount) as sum1
    from customer
        natural inner join payment
    group by customer_id, address_id
) 
select * from a 
natural inner join address
natural inner join city
inner join country using(country_id)

select * from city natural inner join country


with a as(
    select category_id, name, customer_id, count(rental_id) as cnt
    from category natural join film_category
        natural join inventory
        natural join rental
    group by category_id, name, customer_id
),
b as (
    select *, rank() over (partition by category_id order by cnt desc) as rank
    from a
)
select *
from b 
where rank<=2


with a as(
    select customer_id, country, sum(amount) as sum1
    from customer natural join payment
        natural join address
        natural join city
        natural join country
    group by customer_id, country
),
b as (
    select *, sum(sum1) over (partition by country)as sum2
    from a
)
select *, dense_rank() over (order by sum2 desc)
from b 