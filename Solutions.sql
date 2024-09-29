-- Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	 VARCHAR(6),
	type 	 VARCHAR(10),
	title    VARCHAR(150),
	director VARCHAR(250),
	casts     VARCHAR(1000),
	country	 VARCHAR(150),
	date_added  VARCHAR(50),
	release_year INT,
	rating 	VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
	
);



--  Business Problem  

-- 1. Count the number of Movies vs TV Shows

SELECT type,
	COUNT(*) as total_movies_tv_show
FROM netflix
GROUP BY type ;

-- 2. Find the most common rating for movies and TV shows

SELECT 
	type,
	rating
FROM 
( 
	SELECT 
			type, 
			rating,	
			COUNT(*),
			RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1, 2 
) as t1

WHERE ranking = 1
;

-- 3. List all movies released in 2018 

-- filter year 2018
-- list all Movies

SELECT * 
FROM netflix
WHERE release_year = 2018 AND type = 'Movie' 
;

 
-- 4. Find the top 5 countries with the most content on Netflix

-- find most country that have most content  
-- filter top 5

SELECT country,
	  COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5

;


-- 5. Identify the longest movie

-- I split duration column and extract the numeric part then convert the result into integer 
-- now that I have numeric value I can just run MAX() function to get the longest duration movie
-- filter and return longest movie 

SELECT type, title, MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS longest_movie_duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY type, title
ORDER BY longest_movie_duration DESC
LIMIT 1
; 


-- 6. Find content release in the last 5 years

SELECT *
FROM netflix
WHERE release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5
ORDER BY release_year;





-- 7. Find all the movies/TV shows by director 'Steven Spielberg'!

-- I use ILIKE over '=' because there are some movies and TV shows that has more than 1 director

SELECT *
FROM netflix
WHERE director ILIKE '%Steven Spielberg%'


 
-- 8. List all TV shows with more than 5 seasons

-- filter  TV shows  that have more than 5 season  
-- filter duration and extracted the numeric value to run aggregation 

SELECT title
FROM netflix
WHERE type = 'TV Show' 
			AND SPLIT_PART(duration, ' ', 1) ::numeric > 5;


-- 9. Count the number of content items in each genre

-- In some rows in listed  coulumn has there are more than one genre
-- I needed to UNNEST that so I can count 

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
 	COUNT(show_id)
FROM netflix
GROUP BY 1 
ORDER BY count DESC
;


-- 10.Find each year and the average numbers of content from Philippines that release on netflix. 
-- return top 5 year with highest avg content release!

-- filter release content from Philippines only  
-- find the total number of content that added in netflix per year
-- calculate the average content that adden in netflix per year
-- then return the top 5 with the highest average

SELECT 
	release_year, COUNT(*) AS total_content_per_year,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM 	netflix WHERE country = 'Philippines' ):: numeric * 100
	,2) AS 	avg_content_per_year
FROM netflix
WHERE country = 'Philippines' 
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;



-- 11. List all movies that are documentaries

-- filter genre in listed in column where genre are documentaries
-- filter movie
-- note there is some row that has multiple genre 


SELECT show_id, type, title, listed_in
FROM netflix
WHERE listed_in ILIKE  '%Documentaries%' AND type = 'Movie';



-- 12. Find all content without a director

-- filter director with null values 

SELECT *
FROM netflix
WHERE director IS NULL 
;


--13. Find how many movies actor 'Henry Cavill' appeared in last 5 years!


-- filter movie
-- filter how many times Henry Cavill listed as cast in the movies 
-- in last 5 years

SELECT  show_id, type, title, casts  
FROM netflix
WHERE casts ILIKE '%Henry Cavill%' AND type = 'Movie'  
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY show_id, type, title, casts;




-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Philippines.

-- filter Movie cast from Philippines 
-- calculate appearance by counting how many times actors appeared in casts 
-- return the top 10

SELECT 
LTRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) as actors_and_actress,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%Philippines%' AND type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

-- filter keywords 'kill' and 'violence' base on content description 
-- calculate how many times it appeared 
-- label the result as Bad Content  

WITH new_table
AS
(
SELECT *,
	CASE
	WHEN
		description ILIKE '%Kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT (*) AS total_content	
FROM new_table
GROUP BY 1


-- End of reports