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
