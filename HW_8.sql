use sakila;

SET SQL_SAFE_UPDATES = 0;

select * from actor;

#1a
select first_name,last_name from actor;

#1b
UPDATE actor 
SET first_name = Upper(first_name), last_name = Upper(last_name);
select concat(first_name,' ',last_name) as "Actor Name" from actor;

#2a
select actor_id, first_name, last_name from actor where first_name="Joe";

#2b
select first_name, last_name from actor where last_name like "%GEN%";

#2c
select last_name,first_name from actor where last_name like "%LI%";

#2d
select country_id,country from country where country in ('Afghanistan','Bangladesh','China');

#3a
alter table actor
add column description blob;

#3b
alter table actor
drop column description;

#4a
select last_name, count(last_name) as count_of_actors from actor
group by last_name;

#4b
select last_name, count(last_name) as count_of_actors from actor
group by last_name
having count_of_actors>=2;

#4c
update actor
set first_name="Harpo"
where first_name="Groucho" and last_name="williams";

#4d
update actor
set first_name="Groucho"
where first_name="Harpo";

#5a
SHOW CREATE TABLE address;

#6a
select a.first_name,a.last_name,b.address from staff a 
join address b
on a.address_id=b.address_id;

#6b
select a.first_name,a.last_name,sum(b.amount) as Total from staff a
join payment b
on a.staff_id=b.staff_id
where b.payment_date like "2005-08%"
group by 1,2;

#6c
select a.title,count(b.actor_id) as actor_count from film a
inner join film_actor b
on a.film_id=b.film_id
group by a.title;

#6d
select a.title,count(b.inventory_id) as 'number of availabe copies' from film a
join inventory b
on a.film_id=b.film_id
where a.title='Hunchback Impossible'
group by title;

#6e
select a.last_name,a.first_name,sum(b.amount) as 'Total paid' from customer a
join payment b
on a.customer_id=b.payment_id
group by 1,2
order by a.last_name;

#

