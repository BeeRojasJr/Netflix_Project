# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/BeeRojasJr/Netflix_Project/blob/main/logo.png)

## Project Overview
This project focuses on an in-depth analysis of Netflix's movie and TV show data using SQL. The aim is to derive key insights and address a range of business-related questions from the dataset. This README outlines the project's goals, the business challenges it tackles, the solutions implemented, as well as key findings and conclusions.


## Objectives

- Compare Content Types: Analyze the distribution of movies versus TV shows on Netflix.
- Identify Common Ratings: Determine the most frequent ratings for both movies and TV shows.
- Analyze Global Content: Find the top 5 countries producing the most Netflix content.
- Explore Genres and Directors: Count content by genre and analyze contributions from directors like Steven Spielberg.
- Classify Content by Themes: Categorize content based on the presence of keywords like 'kill' and 'violence' and label them as 'Good' or 'Bad.'


## Dataset 

The data for this project is obtained from a Kaggle dataset.

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)



  ## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```


## Business Problems and Solutions



### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type,
	COUNT(*) as total_movies_tv_show
FROM netflix
GROUP BY type ;
```
**Objectives:** 
Support Business Decisions: Help stakeholders understand which type of content, movies or TV shows, dominates the platform for potential content acquisition or production strategies.



### 2. Find the most common rating for movies and TV shows

```sql
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
```
**Objectives:** 
Gain insights into the distribution of content ratings, helping to understand audience preferences and Netflix's content strategy.


### 3. List all movies released in 2018 

```sql
SELECT * 
FROM netflix
WHERE release_year = 2018 AND type = 'Movie' 
;
```
**Objective:** 
Identify 2018 Movie Releases: Retrieve a list of all movies released on Netflix in 2018.


### 4. Find the top 5 countries with the most content on Netflix

```sql
SELECT country,
	  COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5
;
```
**Objective:** 
Identify Top Content-Producing Countries: Determine the top 5 countries with the most content available on Netflix.


### 5. Identify the longest movie

```sql
SELECT type, title, MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)) AS longest_movie_duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY type, title
ORDER BY longest_movie_duration DESC
LIMIT 1
; 
```
**Objective:** 
Find the Longest Movie: Identify the movie with the longest duration available on Netflix.



### 6. Find content release in the last 5 years

```sql
SELECT *
FROM netflix
WHERE release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5
ORDER BY release_year
;
```

**Objective:** 
Identify Recent Content: Retrieve all movies and TV shows released on Netflix within the last 5 years.


### 7. Find all the movies or TV shows by directed by 'Cathy Garcia-Molina'.

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Cathy Garcia-Molina%'
;
```
**Objective:** 
- Identify Content by Cathy Garcia-Molina: Retrieve all movies and TV shows directed by Cathy Garcia-Molina available on Netflix.

- Analyze Director-Specific Content: Gain insights into Cathy Garcia-Molina’s contributions to Netflix’s content library.

- Support Targeted Marketing: Assist in promoting content directed by Cathy Garcia-Molina to her fanbase or audiences interested in her work.

- Enhance User Recommendations: Provide data for recommending movies and TV shows directed by Cathy Garcia-Molina to viewers who prefer content from specific 
   directors.

- Contribute to Director-Based Analysis: Help track and analyze content trends and the popularity of specific directors on the platform.


### 8. List all TV shows with more than 5 seasons

```sql
SELECT title
FROM netflix
WHERE type = 'TV Show' 
			AND SPLIT_PART(duration, ' ', 1) ::numeric > 5;
```
**Objective:**

- Identify Long-Running TV Shows: Retrieve a list of all TV shows on Netflix that have more than 5 seasons.

- Analyze Popular TV Series: Gain insights into TV shows with extended season counts, potentially indicating viewer popularity and long-term success.

- Support Content Promotion: Assist in promoting long-running TV shows as part of curated lists for binge-watchers.

- Enhance Viewer Engagement: Provide data for recommending TV shows with more than 5 seasons to viewers who prefer series with extensive content.

- Inform Content Strategy: Help Netflix assess the success of long-running series for future content acquisition and production decisions.


### 9. Count the number of content items in each genre

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
 	COUNT(show_id)
FROM netflix
GROUP BY 1 
ORDER BY count DESC
;
```
**Objective:** 
- Count Content by Genre: Determine the number of content items available on Netflix for each genre.


### 10. 
- Find each year and the average numbers of content from Philippines that release on netflix. return top 5 year with highest avg content release.

```sql
SELECT 
	release_year, COUNT(*) AS total_content_per_year,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM 	netflix WHERE country = 'Philippines' ):: numeric * 100
	,2) AS 	avg_content_per_year
FROM netflix
WHERE country = 'Philippines' 
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5
;
```
**Objective:** 
- Identify Top Years for Filipino Content: Identify the top 5 years with the highest average content releases from the Philippines, highlighting periods of 
   increased production.

- Analyze Trends in Filipino Content: Gain insights into trends in content production from the Philippines over time, helping to understand the growth or decline 
   in local offerings.

- Support Content Strategy: Assist Netflix in developing strategies for acquiring or promoting Filipino content based on historical performance data.

- Inform Regional Marketing Efforts: Provide data that can inform marketing campaigns targeting Filipino content, focusing on the most fruitful years for 
   audience engagement.


### 11. List all movies that are documentaries

```sql
SELECT show_id, type, title, listed_in
FROM netflix
WHERE listed_in ILIKE  '%Documentaries%' AND type = 'Movie'
;
```
**Objective:** 
- Identify Documentary Films: Retrieve a list of all movies categorized as documentaries available on Netflix.

- Analyze Documentary Offerings: Gain insights into the variety and volume of documentary films in Netflix's movie catalog.

- Support Content Promotion: Assist in promoting documentary films to viewers interested in this genre.

- Enhance User Recommendations: Provide data for recommending documentary movies to audiences who prefer educational or non-fiction content.

- Inform Content Development: Help Netflix assess the demand and trends in the documentary genre for future content acquisition or production decisions.


### 12. Find all content without a director

```sql
SELECT *
FROM netflix
WHERE director IS NULL 
;
```
**Objective:** 
Enhance Data Accuracy: Provide data to help improve the accuracy and completeness of Netflix's content database by addressing entries missing key information.


### 13. Find how many movies actor 'Henry Cavill' appeared in last 5 years.

```sql
SELECT  show_id, type, title, casts  
FROM netflix
WHERE casts ILIKE '%Henry Cavill%' AND type = 'Movie'  
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY show_id, type, title, casts
;
```
**Objective:**
- Identify Recent Appearances: Determine the number of movies featuring actor Henry Cavill released in the last 5 years on Netflix.

- Analyze Actor's Recent Contributions: Gain insights into Henry Cavill's recent contributions to Netflix's movie catalog and his ongoing relevance in the film 
   industry.

- Support Marketing and Promotion: Assist in promoting Henry Cavill's recent movies to his fanbase and audiences interested in his work.

- Enhance User Recommendations: Provide data to recommend movies featuring Henry Cavill to viewers looking for his performances.

- Inform Casting and Acquisition Strategies: Help Netflix assess the impact of actor presence, such as Henry Cavill, on viewership and content strategy decisions.


### 14. Find the top 10 actors who have appeared in the highest number of movies produced in Philippines.

```sql
SELECT 
LTRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) as actors_and_actress,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%Philippines%' AND type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;
```
**Objective:**
- Determine the top 10 actors who have appeared in the highest number of movies produced in the Philippines on Netflix.

- Gain insights into which actors are most prominent in Filipino cinema, helping to understand their influence and popularity.

- Assist in promoting movies featuring these top actors, appealing to their fanbase and enhancing visibility.

- Enhance User Recommendations: Provide data for recommending movies based on popular actors within the Filipino film industry.

- Help Netflix assess the performance and popularity of actors in the Philippines for future casting and content 
   development decisions.


### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
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
;
```
**Objective:**
- Categorize Content by Themes: Classify Netflix content into two categories—'Bad' for items containing the keywords 'kill' or 'violence,' and 'Good' for all 
   other content.
  
- Count Content Items: Count the total number of items that fall into each category to understand the distribution of content themes on the platform.
  
- Analyze Content Themes: Gain insights into how prevalent violent or harmful themes are in Netflix's catalog, informing content moderation strategies.
  
- Support Content Filtering and Recommendations: Provide data that can assist in content filtering for viewers seeking less violent options or help in creating 
   curated lists based on content themes.

- Inform Marketing and Audience Engagement Strategies: Use the categorized data to shape marketing campaigns, targeting specific audience preferences regarding      content themes.
       
