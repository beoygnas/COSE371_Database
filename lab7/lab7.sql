1번.

select rental_rate, rating, rental_duration, count(film_id)
from film
group by grouping sets((rental_rate, rating), (rating, rental_duration));

select rental_rate, rating, rental_duration, count(film_id)
from film
group by rollup(rental_rate), rollup(rating, rental_duration);

2번.

select 
    case 
        when actor_id is null then '999' 
        else actor_id 
    end as actor_id,
    case 
        when name is null then 'all' 
        else name end 
    as name, 
    count(film_id) 
from film_actor as fa
    join film_category as fc using (film_id)
    join category as c using(category_id)
where fa.actor_id = 1 or fa.actor_id = 2
group by 
    cube(actor_id, name)
order by actor_id ;



3번.

select Y, M, D, count(*)
from 
    (select 
        extract(year from rental_date) Y, 
        extract(month from rental_date) M, 
        extract(day from rental_date) D, 
        extract(hour from rental_date) h, 
        extract(minute from rental_date) min, 
        extract(second from rental_date) s
    from rental) as date
group by rollup(Y, M, D)

4번

select * 
from         
    (select fc.category_id, r.customer_id, count(*), 
    rank() over (partition by category_id order by count(*) desc) 
    from rental as r
        join inventory as i using(inventory_id)
        join film_category as fc using(film_id)
    group by fc.category_id, r.customer_id) as data
where rank <= 2;


5번

with total_amount as 
(select customer_id, country, sum(amount) as one_sum
from customer 
    join payment using(customer_id)
    join address using(address_id)
    join city using(city_id)
    join country using(country_id)
group by customer_id, country
),
country_total as (
select *, sum(one_sum) over(partition by country) as country_sum
from total_amount
)
select *, dense_rank() over(order by country_sum desc) as country_rank
from country_total;


1번 

select rental_rate, rating, count(distinct film_id)
from film
group by grouping sets(rental_rate, rating)

2번
select actor_id, category, count(distinct film_id)
from film_actor 
    inner join film_category using(film_id)
    inner join category using(category_id)
-- where actor_id = 1 or actor_id = 2 
group by cube(actor_id, category)


3번
select 
    (extract(year from rental_date)) as Y,
    (extract(month from rental_date)) as M,
    (extract(day from rental_date)) as D,
    sum(amount)
from rental full outer join payment using(rental_id)
group by rollup(Y, M, D)


4번 
select 
film category, customer_id 

number of DVDs rented 

select *
from (select name, customer_id, count(rental_id), rank() over (partition by name order by count(rental_id) desc)
from rental
    inner join customer using(customer_id)
    inner join inventory using(inventory_id)
    inner join film_category using(film_id)
    inner join category using(category_id)
group by name, customer_id   
    ) as a
where rank <= 2

5번

with c_total as (
    select customer_id, address_id, sum(amount) 
    from customer 
        inner join payment using(customer_id)
    group by customer_id, address_id), 
country_total as (
    select customer_id, sum, country, sum(sum) over (partition by country_id) as total_sum
    from c_total
        inner join address using(address_id)
        inner join city using(city_id)
        inner join country using(country_id)
)
select *, dense_rank() over (order by total_sum desc)
from country_total



while(true){
    wait(rw_mutex);
    wait(mutex);
        //write
    signal(rw_mutex);
    signal(mutex);
}

read
while(true){
    wait(mutex);
        // READ 
    signal(mutex);
}

for image, label in flower_train.take(1):
    image = image.numpy()
    plt.figure()
    plt.imshow(image, cmap=plt.cm.binary)
    plt.title('Label {}'.format(label))
    plt.colorbar()
    plt.grid(False)
    plt.show()
    break

