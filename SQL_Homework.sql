USE SAKILA;

#1a
SELECT	first_name, last_name
FROM	ACTOR;

#1b
SELECT	concat(first_name," ",last_name) as 'Actor Name'
FROM	ACTOR;

#2a
SELECT 	actor_id, first_name, last_name
FROM	ACTOR
WHERE 	first_name = 'Joe';

#2b
SELECT 	actor_id, first_name, last_name
FROM	ACTOR
WHERE 	last_name like '%Gen%';

#2c
SELECT 	last_name, first_name
FROM	ACTOR
WHERE 	last_name like '%li%';

#2d
SELECT 	country_id, country
FROM	COUNTRY
WHERE 	country in ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE ACTOR
ADD COLUMN description BLOB;

#3b
ALTER TABLE ACTOR
DROP COLUMN description;

#4a
SELECT	last_name, count(*)
FROM	ACTOR
GROUP BY last_name;

#4b
SELECT	last_name, count(*)
FROM	ACTOR
GROUP BY last_name
HAVING count(*) > 2;

#4c
UPDATE	ACTOR
SET 	First_name = 'HARPO'
WHERE 	First_name = 'GROUCHO' and Last_name = 'WILLIAMS';

#4d
SET SQL_SAFE_UPDATES = 0;
UPDATE	ACTOR
SET 	First_name = 'GROUCHO'
WHERE 	First_name = 'HARPO';

#5a
SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
);

#6a
SELECT	s.first_name, s.last_name, a.address
FROM 	STAFF S
		JOIN ADDRESS A ON S.Address_id = A.Address_id;
        
#6b
SELECT	s.first_name, s.last_name, SUM(p.amount) as Amount
FROM	PAYMENT P
		JOIN STAFF S ON S.staff_id = P.staff_ID
WHERE 	P.payment_date between '2005-08-01' AND '2005-08-31'
GROUP BY  s.first_name, s.last_name;

#6c
SELECT	f.title, count(*) as 'Number of actors'
FROM	film f
		INNER JOIN film_actor a ON f.film_id = a.actor_id
GROUP BY f.title;

#6d
SELECT	f.title, count(*) as 'Number of copies'
FROM 	Inventory i
		JOIN film f ON i.film_id = f.film_id
WHERE	f.title = 'Hunchback Impossible'
GROUP BY f.title;

#6e
SELECT	c.first_name, c.last_name, SUM(p.amount) as Amount
FROM	Customer c
		JOIN Payment p ON c.customer_id = p.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY c.last_name ASC;

#7a
SELECT  title
FROM	film
WHERE 	title like ('k%')
		OR title like ('q%')
		AND language_id = 
					(SELECT	language_id
					FROM	language
					WHERE	name = 'English');

#7b
SELECT 	first_name, last_name
FROM	actor
WHERE 	actor_id IN
		(SELECT  actor_id
		FROM	film_actor
		WHERE	film_id =
					(SELECT	film_id
					FROM	film 
					WHERE 	Title = 'Alone Trip'));
                    
#7c
SELECT  *#first_name, last_name, email
FROM	customer
WHERE	address_id IN
	(SELECT *
	FROM	address
	WHERE 	city_id IN
		(SELECT city_id
		FROM	city
		WHERE	country_id = 
					(SELECT country_id
					FROM 	Country
					WHERE	Country = 'Canada')));

#7d
SELECT	f.title, c.name as cateogry
FROM	film f
		JOIN film_category fc ON f.film_id = fc.film_id
		JOIN category c ON c.category_id = fc.category_id
WHERE	c.name = 'family';

#7e
SELECT	f.title, count(*) as frquencies
FROM 	film f
		JOIN inventory i ON f.film_id = i.film_id
		JOIN Rental	r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY count(*) DESC;

#7f
SELECT 	c.store_id, SUM(p.amount) as Amount
FROM 	payment p
		JOIN Customer c on P.customer_id = c.customer_id
GROUP BY c.store_id;

#7g
SELECT	s.store_id, c.city, co.country
FROM	Store s
		JOIN Address a ON s.address_id = a.address_id
        JOIN city c ON c.city_id = a.city_id
        JOIN Country co ON co.country_id = c.country_id;
        
#7h
SELECT	c.name as Category, SUM(p.amount) as Amount
FROM	category c
		JOIN film_category fc ON c.category_id = fc.category_id
        JOIN Inventory i ON i.film_id = fc.film_id
        JOIN Rental r ON r.inventory_id = i.inventory_id
        JOIN Payment p ON p.rental_id = r.rental_id
GROUP BY c.name 
ORDER BY SUM(p.amount) desc LIMIT 5;

#8a
CREATE VIEW V_top5_genres AS
SELECT	c.name as Category, SUM(p.amount) as Amount
FROM	category c
		JOIN film_category fc ON c.category_id = fc.category_id
        JOIN Inventory i ON i.film_id = fc.film_id
        JOIN Rental r ON r.inventory_id = i.inventory_id
        JOIN Payment p ON p.rental_id = r.rental_id
GROUP BY c.name 
ORDER BY SUM(p.amount) desc LIMIT 5;

#8b
SELECT  *
FROM 	V_top5_genres;
        
#8c
DROP VIEW V_top5_genres;
	