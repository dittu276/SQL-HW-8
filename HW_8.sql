use sakila;

SET SQL_SAFE_UPDATES = 0;

#1a - first and last names of all actors from the table `actor`.
select first_name,last_name 
from actor;

#1b - first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
UPDATE actor 
SET first_name = Upper(first_name), last_name = Upper(last_name);
select concat(first_name,' ',last_name) as "Actor Name" 
from actor;

#2a - find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id, first_name, last_name 
from actor 
where first_name="Joe";

#2b - Find all actors whose last name contain the letters `GEN`.
select first_name, last_name 
from actor 
where last_name like "%GEN%";

#2c - Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order.
select last_name,first_name 
from actor 
where last_name like "%LI%";

#2d - Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id,country 
from country 
where country in ('Afghanistan','Bangladesh','China');

#3a - create a column in the table `actor` named `description` and use the data type `BLOB`.
alter table actor
add column description blob;

#3b - Delete the `description` column.
alter table actor
drop column description;

#4a - List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as count_of_actors 
from actor
group by last_name;

#4b - List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(last_name) as count_of_actors 
from actor
group by last_name
having count_of_actors>=2;

#4c - The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name="Harpo"
where first_name="Groucho" and last_name="williams";

#4d - if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name="Groucho"
where first_name="Harpo";

#5a - You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a-  Use `JOIN` to display the first and last names, as well as the address, of each staff member.
select a.first_name,a.last_name,b.address 
from staff a 
join address b
on a.address_id=b.address_id;

#6b - Use `JOIN` to display the total amount rung up by each staff member in August of 2005.
select a.first_name,a.last_name,sum(b.amount) as Total 
from staff a
join payment b
on a.staff_id=b.staff_id
where b.payment_date like "2005-08%"
group by 1,2;

#6c - List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film'.Use inner join.
select a.title,count(b.actor_id) as actor_count 
from film a
inner join film_actor b
on a.film_id=b.film_id
group by a.title;

#6d - How many copies of the film `Hunchback Impossible` exist in the inventory system?
select a.title,count(b.inventory_id) as 'number of availabe copies' 
from film a
join inventory b
on a.film_id=b.film_id
where a.title='Hunchback Impossible'
group by title;

#6e - Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name.
select a.first_name,a.last_name,sum(b.amount) as 'Total amount paid' 
from customer a
join payment b
on a.customer_id=b.customer_id
group by 1,2
order by a.last_name;

#7a - Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title 
from film 
where language_id in (select language_id from language where name="english") and title like "K%" or title like "Q%";

#7b - Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name,last_name from actor where actor_id in (
	select actor_id from film_actor where film_id in (
		select film_id from film where title="Alone Trip"));

#7c - need the names and email addresses of all Canadian customers.
select a.first_name,a.last_name,a.email 
from customer a, address b, city c, country d
where a.address_id=b.address_id
and b.city_id=c.city_id
and c.country_id=d.country_id 
and d.country='Canada';

#7d - Identify all movies categorized as family films.
select title as family_films from film where film_id in (
	select film_id from film_category where category_id in (
		select category_id from category where name="family"));

#7e - Display the most frequently rented movies in descending order.
select a.title,count(c.rental_id) as "number of time rented" 
from film a,inventory b, rental c
where a.film_id=b.film_id
and b.inventory_id=c.inventory_id
group by title
order by count(c.rental_id) desc;

#7f - Write a query to display how much business, in dollars, each store brought in.
select b.store_id,sum(a.amount) as total_business 
from payment a,staff b
where a.staff_id=b.staff_id
group by b.store_id;
 
#7g - Write a query to display for each store its store ID, city, and country.
select a.store_id,c.city,d.country 
from store a,address b, city c, country d
where a.address_id=b.address_id
and b.city_id=c.city_id
and c.country_id=d.country_id;

#7h - List the top five genres in gross revenue in descending order.
select a.name as genre, sum(e.amount) as gross_revenue
from category a, film_category b, inventory c, rental d, payment e
where a.category_id=b.category_id
and b.film_id=c.film_id
and c.inventory_id=d.inventory_id
and d.rental_id=e.rental_id
group by a.name
order by sum(e.amount) desc
limit 5;

#8a - Use the solution from the problem above to create a view.
create view top_5_genres as
select a.name as genre, sum(e.amount) as gross_revenue
from category a, film_category b, inventory c, rental d, payment e
where a.category_id=b.category_id
and b.film_id=c.film_id
and c.inventory_id=d.inventory_id
and d.rental_id=e.rental_id
group by a.name
order by sum(e.amount) desc
limit 5;

#8b. How would you display the view that you created in 8a?
select * from top_5_genres;

#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_5_genres;
