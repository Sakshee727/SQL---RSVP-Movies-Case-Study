USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- To find the total number of rows in each table within the ‘imdb’ schema, we execute the following SQL query:

SELECT 'director_mapping' AS TableName,
       Count(*)           AS ROWCOUNT
FROM   director_mapping
UNION ALL
SELECT 'genre'  AS TableName,
       Count(*) AS ROWCOUNT
FROM   genre
UNION ALL
SELECT 'movie'  AS TableName,
       Count(*) AS ROWCOUNT
FROM   movie
UNION ALL
SELECT 'names'  AS TableName,
       Count(*) AS ROWCOUNT
FROM   names
UNION ALL
SELECT 'ratings' AS TableName,
       Count(*)  AS ROWCOUNT
FROM   ratings
UNION ALL
SELECT 'role_mapping' AS TableName,
       Count(*)       AS ROWCOUNT
FROM   role_mapping; 


-- Above Query 1 provides the number of rows for each table in the schema, helping us understand the dataset’s size.





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- We inspect the ‘movie’ table to identify which columns contain null values using the following query.

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS id_null_count,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS title_null_count,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS year_null_count,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS date_published_null_count,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS duration_null_count,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS country_null_count,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS worlwide_gross_income_null_count,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS languages_null_count,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS production_company_null_count
FROM   movie; 



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To determine the number of movies released each year, we utilize the following queries:

-- For yearly count 
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year;

-- For monthly count
SELECT Month(date_published) AS month_num,
       Count(id)             AS num_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY num_of_movies DESC; 

-- Above Query 3 gives the highest number of movies is produced in the month of March.



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
 
 
 
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- To find the number of movies produced in the USA or India in 2019, we execute the following query:

SELECT Count(id) AS movie_count
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- Above Query 4 provides the count of movies produced in either the USA or India during 2019.



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/



-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- To find the unique list of the genres present in the data set

SELECT DISTINCT genre
FROM   genre;

-- Above Query 5 shows that there are total of 13 unique genres present in the data set.



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */



-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- To find which genre had the highest number of movies produced overall

SELECT genre,
       Count(id) AS total_movies
FROM   movie mv
       INNER JOIN genre gn
               ON mv.id = gn.movie_id
GROUP  BY genre
ORDER  BY total_movies DESC
LIMIT  3; 

-- Above Query 6 shows Drama genre had the highest number of movies procuded overall.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/



-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- To find how many movies belong to only one genre

WITH unique_genre_movies
     AS (SELECT movie_id,
                Count(genre) AS total_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(*) AS movie_with_one_genre
FROM   unique_genre_movies
WHERE  total_genre = 1; 


-- Above Query 7 shows that there are more than 3000 movies belonging to only one genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To find the average duration of the movies in each genre

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie mv
       INNER JOIN genre gn
               ON mv.id = gn.movie_id
GROUP  BY genre; 

-- Above Query 8 shows the average duration of the movies in each genre



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- To find the rank of the 'thriller' genre using rank function

WITH thriller_genre_rank
     AS (SELECT genre,
                Count(id)                    AS movie_count,
                Row_number()
                  OVER(
                    ORDER BY Count(id) DESC) AS genre_rank
         FROM   movie mv
                INNER JOIN genre gn
                        ON mv.id = gn.movie_id
         GROUP  BY genre)
SELECT *
FROM   thriller_genre_rank
WHERE  genre = 'Thriller';

-- Above Query 9 reveals that 'Thriller' genre rank is 3



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- To find mix and max values in each column of the ratings table except the movie_id column

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;

-- Above Query 10 shows that the data falls in within expeceted range, indicating the absence of significant outliers.



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT     title,
           avg_rating,
           Row_number() over(ORDER BY avg_rating DESC) AS movie_rank
FROM       movie                                       AS mv
INNER JOIN ratings                                     AS rt
ON         rt.movie_id = mv.id
LIMIT      10;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/



-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/



-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
       Count(id)                    AS movie_count,
       Dense_rank()
         OVER(
           ORDER BY Count(id) DESC) AS prod_company_rank
FROM   movie AS mv
       INNER JOIN ratings AS rt
               ON mv.id = rt.movie_id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company
ORDER  BY movie_count DESC;





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT gn.genre,
       Count(gn.movie_id) AS movie_count
FROM   genre AS gn
       INNER JOIN ratings AS rt
               ON gn.movie_id = rt.movie_id
       INNER JOIN movie AS mv
               ON mv.id = gn.movie_id
WHERE  mv.country LIKE '%USA%'
       AND rt.total_votes > 1000
       AND Month(date_published) = 3
       AND year = 2017
GROUP  BY gn.genre
ORDER  BY movie_count DESC;




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre AS gn
       INNER JOIN ratings AS rt
               ON gn.movie_id = rt.movie_id
       INNER JOIN movie AS mv
               ON mv.id = gn.movie_id
WHERE  title LIKE 'The%'
       AND avg_rating > 8
ORDER  BY avg_rating DESC;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   movie AS mv
       INNER JOIN ratings AS rt
               ON mv.id = rt.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT country,
       Sum(total_votes) AS total_votes_sum
FROM   movie AS mv
       INNER JOIN ratings AS rt
               ON mv.id = rt.movie_id
WHERE  country = 'Germany'
        OR country = 'Italy'
GROUP  BY country
ORDER  BY total_votes_sum DESC
LIMIT  0, 1000;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_nulls
FROM   names; 




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */



WITH top_3_genre
AS
  (
             SELECT     genre,
                        count(mv.id) AS movie_count
             FROM       movie mv
             INNER JOIN genre gn
             ON         mv.id = gn.movie_id
             INNER JOIN ratings rt
             ON         rt.movie_id = mv.id
             WHERE      avg_rating > 8
             GROUP BY   genre
             ORDER BY   movie_count DESC
             LIMIT      3 )
  SELECT     n.name       AS director_name,
             count(mv.id) AS movie_count
  FROM       movie mv
  INNER JOIN director_mapping dm
  ON         mv.id = dm.movie_id
  INNER JOIN names n
  ON         n.id = dm.name_id
  INNER JOIN genre gn
  ON         gn.movie_id = mv.id
  INNER JOIN ratings rt
  ON         mv.id = rt.movie_id
  WHERE      gn.genre IN
             (
                    SELECT genre
                    FROM   top_3_genre)
  AND        avg_rating > 8
  GROUP BY   director_name
  ORDER BY   movie_count DESC
  LIMIT      3;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT name               AS actor_name,
                Count(rt.movie_id) AS movie_count
FROM   ratings AS rt
       INNER JOIN role_mapping AS rm
               ON rm.movie_id = rT.movie_id
       INNER JOIN names AS N
               ON rm.name_id = N.id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY name
ORDER  BY movie_count DESC
LIMIT  2; 






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Sum(total_votes)                                   AS vote_count,
           Row_number() over (ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie mv
INNER JOIN ratings rt
ON         mv.id = rt.movie_id
GROUP BY   production_company
LIMIT      3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/



-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_movie_summary
     AS (SELECT NAME                                                       AS
                actor_name
                ,
                Sum(total_votes)
                AS
                   total_votes,
                Count(rt.movie_id)                                         AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie AS mv
                INNER JOIN ratings AS rt
                        ON mv.id = rt.movie_id
                INNER JOIN role_mapping AS rm
                        ON mv.id = rm.movie_id
                INNER JOIN names AS n
                        ON rm.name_id = n.id
         WHERE  category = 'actor'
                AND country LIKE "%india%"
         GROUP  BY actor_name
         HAVING movie_count >= 5)
SELECT *,
       Row_number()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_movie_summary; 


-- Top actor is Vijay Sethupathi followed by Fahadh Faasil at second rank and Yogi Babu at third one.





-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT NAME                                                       AS
       actress_name,
       Sum(total_votes)                                           AS total_votes
       ,
       Count(mv.id)                                               AS
       movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
       actress_avg_rating,
       Row_number()
         OVER (
           ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
         DESC,
         Sum(total_votes) DESC )                                  AS
       actress_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN ratings rt
               ON rm.movie_id = rt.movie_id
       INNER JOIN movie mv
               ON mv.id = rm.movie_id
WHERE  category = "actress"
       AND country = "india"
       AND languages LIKE "%hindi%"
GROUP  BY actress_name
HAVING movie_count >= 3;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/




/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
-- Lets make use of CASE statements to classify thriller movies as per their avg rating

SELECT title AS movie_name,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
         WHEN avg_rating < 5 THEN 'Flop'
       end   AS movie_category
FROM   movie AS mv
       INNER JOIN genre AS gn
               ON mv.id = gn.movie_id
       INNER JOIN ratings AS rt
               ON rt.movie_id = mv.id
WHERE  genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/



-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over (
           ORDER BY genre)     AS running_total_duration,
       Round(Avg(Round(Avg(duration), 2))
               over (
                 ORDER BY genre ROWS BETWEEN unbounded preceding AND CURRENT ROW
               ), 2)
                               AS moving_avg_duration
FROM   movie AS mv
       inner join genre AS gn
               ON mv.id = gn.movie_id
GROUP  BY genre
ORDER  BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting



-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Lets find out Top 3 Genres based on most number of movies

WITH top_three_genres
AS
  (
             SELECT     genre,
                        count(mv.id) AS movie_count
             FROM       movie mv
             INNER JOIN genre gn
             ON         gn.movie_id = mv.id
             GROUP BY   genre
             ORDER BY   movie_count DESC
             LIMIT      3 ),
  -- Lets find out top 5 highest-grossing movies from each of the top 3 genres for each year based on worldwide gross income.
  top_five_movies
AS
  (
             SELECT     gn.genre,
                        mv.year,
                        mv.title AS movie_name,
                        worlwide_gross_income,
                        row_number() over (partition BY mv.year ORDER BY worlwide_gross_income DESC) AS movie_rank
             FROM       movie mv
             INNER JOIN genre gn
             ON         gn.movie_id = mv.id
             WHERE      gn.genre IN
                        (
                               SELECT genre
                               FROM   top_three_genres) )
  -- Final results for top 5 movies of the top 3 genres.
  SELECT *
  FROM   top_five_movies
  WHERE  movie_rank <= 5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Lets find out Top 2 production houses for high-rated multilingual movies
WITH top_production_companies
AS
  (
             SELECT     production_company,
                        count(*)                                   AS movie_count,
                        row_number() over (ORDER BY count(*) DESC) AS prod_comp_rank
             FROM       movie mv
             INNER JOIN ratings rt
             ON         mv.id = rt.movie_id
             WHERE      median_rating >= 8
             AND        production_company IS NOT NULL
                        -- For movies with more than one languages
             AND        position(',' IN languages) > 0
             GROUP BY   production_company )
  SELECT production_company,
         movie_count,
         prod_comp_rank
  FROM   top_production_companies
  LIMIT  2;

-- Top 2 production companies with highest hit movies in multiple languages are 'Star Cinema'and 'Twentieth Century Fox'. 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language




-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH actress_movies_summary
AS
  (
             SELECT     name                                                  AS actress_name,
                        sum(total_votes)                                      AS total_votes,
                        count(rt.movie_id)                                    AS movie_count,
                        round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating
             FROM       movie                                                 AS mv
             INNER JOIN ratings                                               AS rt
             ON         mv.id=rt.movie_id
             INNER JOIN role_mapping AS rm
             ON         mv.id = rm.movie_id
             INNER JOIN names AS n
             ON         rm.name_id = n.id
             INNER JOIN genre AS gn
             ON         gn.movie_id = mv.id
             WHERE      category = 'actress'
             AND        genre = "Drama"
             AND        avg_rating>8
             GROUP BY   actress_name )
  SELECT   *,
           rank() over(ORDER BY movie_count DESC) AS actress_rank
  FROM     actress_movies_summary
  LIMIT    3;

-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are Top 3 actresses based on number of Super Hit movies



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- First lets calculate the average difference between two movie dates by creating view below.

DROP VIEW IF EXISTS movie_dates_avg_differ;

CREATE VIEW movie_dates_avg_differ
AS
  WITH movie_summary
       AS (SELECT N.id                            AS director_id,
                  N.name                          AS director_name,
                  mv.id                           AS movie_id,
                  mv.date_published               AS movie_date,
                  Lead(mv.date_published, 1)
                    OVER (
                      PARTITION BY N.name
                      ORDER BY mv.date_published) AS next_movie_date
           FROM   names N
                  INNER JOIN director_mapping dm
                          ON N.id = dm.name_id
                  INNER JOIN movie mv
                          ON dm.movie_id = mv.id)
  SELECT director_id,
         director_name,
         Round(Avg(Datediff(next_movie_date, movie_date))) AS
         avg_inter_movie_days
  FROM   movie_summary
  GROUP  BY director_id,
            director_name;
-- Based on the number of movies lets find out Top 9 directors below.
WITH top_movie_directors
     AS (SELECT N.id                                           AS director_id,
                N.name                                         AS director_name,
                COUNT(DISTINCT dm.movie_id)                    AS
                number_of_movies,
                Round(Avg(rt.avg_rating), 2)                   AS avg_rating,
                Sum(rt.total_votes)                            AS total_votes,
                Min(rt.avg_rating)                             AS min_rating,
                Max(rt.avg_rating)                             AS max_rating,
                Sum(mv.duration)                               AS total_duration
                ,
                ROW_NUMBER()
                  OVER (
                    ORDER BY COUNT(DISTINCT dm.movie_id) desc) AS director_rank
         FROM   names N
                INNER JOIN director_mapping dm
                        ON N.id = dm.name_id
                INNER JOIN movie mv
                        ON dm.movie_id = mv.id
                INNER JOIN ratings rt
                        ON mv.id = rt.movie_id
         GROUP  BY director_id,
                   director_name)
-- Combine with the average inter-movie days
SELECT td.director_id,
       td.director_name,
       td.number_of_movies,
       AvgD.avg_inter_movie_days AS avg_inter_movie_days,
       td.avg_rating,
       td.total_votes,
       td.min_rating,
       td.max_rating,
       td.total_duration
FROM   top_movie_directors td
       LEFT JOIN movie_dates_avg_differ AvgD
              ON td.director_id = AvgD.director_id
WHERE  td.director_rank <= 9;



/*Conclusion: 
This analytical journey equips RSVP Movies with valuable insights. 
By utilizing data-driven recommendations, they can strategically plan their global audience-friendly movie project. 
With this data, RSVP Movies is assured to create cinematic magic that resonates with audiences worldwide.
*/



