-- << 1 >>
SELECT
    name AS category_name,
    COUNT(*) AS film_count
FROM film_category
INNER JOIN category USING (category_id)
GROUP BY category_name
ORDER BY film_count DESC;


-- << 2 >>
SELECT 
    first_name, 
    last_name
FROM rental
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 10;


-- << 3 >>
SELECT 
    category.name AS category_name
FROM payment
INNER JOIN rental USING (rental_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY category_name
ORDER BY SUM(amount) DESC
LIMIT 1;


-- << 4 >>
SELECT title FROM film
LEFT JOIN inventory USING (film_id)
WHERE inventory.film_id IS NULL;


-- << 5 >>
SELECT 
    first_name, 
    last_name 
FROM (
    SELECT 
        first_name, 
        last_name,
        RANK() OVER(PARTITION BY category.name ORDER BY COUNT(*) DESC) AS num
    FROM actor
    INNER JOIN film_actor USING (actor_id)
    INNER JOIN film USING (film_id)
    INNER JOIN film_category USING (film_id)
    INNER JOIN category USING (category_id)
    GROUP BY first_name, 
             last_name,
             category.name
    HAVING category.name = 'Children'
) AS res
WHERE num <= 3;


-- << 6 >>
SELECT 
    city, 
    COUNT(CASE WHEN active = 1 THEN active ELSE NULL END) AS active_count,
    COUNT(CASE WHEN active = 0 THEN active ELSE NULL END) AS inactive_count
FROM city
INNER JOIN address USING (city_id)
INNER JOIN customer USING (address_id)
GROUP BY city
ORDER BY inactive_count DESC;


-- << 7 >>
SELECT
    city,
    category_name
FROM (
    SELECT 
        city,
        category.name AS category_name,
        ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY SUM(rental_duration) DESC) AS num
    FROM customer
    INNER JOIN address USING (address_id)
    INNER JOIN city USING (city_id)
    INNER JOIN inventory USING (store_id)
    INNER JOIN film USING (film_id)
    INNER JOIN film_category USING (film_id)
    INNER JOIN category USING (category_id)
    WHERE 
        LOWER(city) LIKE 'a%'
        OR city LIKE '%-%'
    GROUP BY city_id, category_name
) AS res
WHERE num = 1;
