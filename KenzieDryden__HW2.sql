/*
Instructions:

	* Write a single query to answer each question (join tables if needed, do not write separate queries). 
    * You do not have to additionally write an answer or comment.
    * Alias all column names appropriately (no "code" in headers).
    * Dollar values should be appropriately formatted as currency (dollar signs, commas).
    * All other numbers should be formatted and rounded appropriately.

SUBMISSIONS:
	* Rename this file with your name (e.g. DougLehmann_HW2.sql)
	* Submit this SQL file to Blackboard
		* Please refer to syllabus for grading policy
        * YOU GET ONE SUBMISSION (So stay organized, and know what you have where / what you're submitting the first time)
     
        
Please use the airbnb_broward schema for question 1
Please use the films schema for questions 2-10

*/



-- 1 Airbnb by District
/*
	Suppose we want to aggregate the Broward Airbnb data by district rather than neighbourhood
	Unfortunately: District isn't in the data
	Fortunately: We can create district ourselves through the neighbourhood column
	Group the neighbourhoods into the following districts
    
    District          	Neighbourhoods
    --------          	--------------------------------------------------
    District 1 			Weston, Southwest Ranches
    District 2			Deerfield Beach, Coconut Creek, Margate, County Regional Facility
    District 3			Parkland, Coral Springs, Tamarac
    District 4			Lighthouse Point, Hillsboro Beach, Pompano Beach, Wilton Manors, Sea Ranch Lakes, Lauderdale By The Sea, Fort Lauderdale
    District 5			Plantation, Davie, Cooper City
    District 6			Dania Beach, Hollywood, West Park, Pembroke Park, Hallandale Beach
    District 7			Tribal Land, Pembroke Pines, Miramar
    District 8			Oakland Park, Lazy Lake, North Lauderdale, Unincorporated
    District 9			Sunrise, Lauderhill, Lauderdale Lakes
    
    Return a table with the following: District (as defined above), Number of Properties, Average Price ($)
    Include only entire home/apts
    Order district high to low by Average Price
*/

SELECT 
  CASE
    WHEN neighbourhood IN ('Weston', 'Southwest Ranches') THEN 'District 1'
    WHEN neighbourhood IN ('Deerfield Beach', 'Coconut Creek', 'Margate', 'County Regional Facility') THEN 'District 2'
    WHEN neighbourhood IN ('Parkland', 'Coral Springs', 'Tamarac') THEN 'District 3'
    WHEN neighbourhood IN ('Lighthouse Point', 'Hillsboro Beach', 'Pompano Beach', 'Wilton Manors', 'Sea Ranch Lakes', 'Lauderdale By The Sea', 'Fort Lauderdale') THEN 'District 4'
    WHEN neighbourhood IN ('Plantation', 'Davie', 'Cooper City') THEN 'District 5'  
    WHEN neighbourhood IN ('Dania Beach', 'Hollywood', 'West Park', 'Pembroke Park', 'Hallandale Beach') THEN 'District 6'
    WHEN neighbourhood IN ('Tribal Land', 'Pembroke Pines', 'Miramar') THEN 'District 7'
    WHEN neighbourhood IN ('Oakland Park', 'Lazy Lake', 'North Lauderdale', 'Unincorporated') THEN 'District 8'
    WHEN neighbourhood IN ('Sunrise', 'Lauderhill', 'Lauderdale Lakes') THEN 'District 9'
   ELSE NULL
   END AS District,
   AVG(price),
   COUNT(host_listings_count)
  FROM listings
  WHERE room_type = 'Entire home/apt'
  GROUP BY 1
  ORDER BY 2 DESC; 

/*
The films schema contains 4 tables: films, people, reviews, and roles
Please spend a few minutes looking at each to understand what each contains and how they connect to each other
*/

USE films;
SELECT * FROM films LIMIT 5; -- film_id, tite, release_year, country, duration, language, rating, gross, budget
SELECT * FROM people LIMIT 5; -- person_id, name, birthdate, deathdate
SELECT * FROM reviews LIMIT 5; -- review_id, film_id, num_user, num_critic, imdb_score, num_votes, facebook_likes
SELECT * FROM roles LIMIT 5; -- role_id, film_id, person_id, role

-- 2. Which 5 films had the highest net profit (defined as gross - budget)?

SELECT 
	title, 
	film_id,
	(gross - budget) AS "net profit"
FROM films
ORDER BY 3 DESC 
LIMIT 5;


-- 1) Star Wars: Episode VII: The Force Awakens ($691,627,416)
-- 2 ) Avatar ($523,505,847)
-- 3) Jurassic World ($502,177,271)
-- 4) Titanic ($458,672,302)
-- 5) Star Wars: Episode IV: A New Hope ($449,935,665)

-- 3. Return the year and number of films per year, and sort from most recent to oldest release year. Only return years that had more than 200 films released.

SELECT 
	release_year,
	SUM(film_id)
FROM films 
GROUP BY 1
HAVING SUM(film_id) >= 200
ORDER BY 1 DESC;

-- 4. Return the title and imdb score for the 3 films with the highest IMDB score. Round IMDB Score to 1 decimals. 

SELECT
	f.title,
	r.imdb_score
FROM reviews r
JOIN films f ON r.film_id = f.film_id
ORDER BY 2 DESC
LIMIT 3;
	
-- 1) Towering Inferno: 9.5
-- 2) The Shawshank Redemption: 9.30000019
-- 3) The Godfather: 9.19999981

-- 5. Obtain the total number of facebook likes by release year, order from most to least recent

SELECT
	f.release_year,
	r.facebook_likes
FROM reviews r 
JOIN films f ON r.film_id = f.film_id
ORDER BY 1 DESC;

-- 6. What is the only film with more than one million facebook likes? SOLVE THIS WITH A JOIN
SELECT
	f.title,
	r.facebook_likes
FROM reviews r
JOIN films f ON r.film_id = f.film_id
WHERE facebook_likes >= 1000000;

-- Star Wars: Episode VII - The Force Awakens

-- 7. Return a table that provides the language and average number of facebook likes per film for Spanish, French, and Portuguese films. Round the number of likes to an integer, and order the table high to low

SELECT
	f.language, 
	ROUND(AVG(r.facebook_likes)) as average
FROM reviews r
JOIN films f ON r.film_id = f.film_id
WHERE f.language = "Spanish"
OR f.language = "French" 
OR f.language = "Portuguese"
GROUP BY f.language
ORDER BY average DESC;

-- French: 2596
-- Portuguese: 4971
-- Spanish: 3936

-- 8. Which rating receives the most Facebook likes, on average, and what is that average number of likes? Round your answer to an integer.

SELECT
	f.rating, 
	ROUND(AVG(r.facebook_likes))
FROM reviews r
JOIN films f ON f.film_id = r.film_id
GROUP BY f.rating
ORDER BY ROUND(AVG(r.facebook_likes)) DESC;

-- R

-- 9. Return a table that provides the language and average IMDB score. Only include languages with an average IMDB score between 7 and 8. Order the results high to low based on average IMDB score.

SELECT 
	f.language, 
	AVG(r.imdb_score) as average
FROM reviews r
JOIN films f ON f.film_id = r.film_id
GROUP BY f.language
HAVING average > 7 AND average < 8
ORDER BY AVG(r.imdb_score) DESC;

-- 10. Which actor has appeared in the most films? Return their name and the number of films they've appeared in

SELECT 
	p.name, 
	COUNT(r.role) as number_of_movies
FROM roles r
JOIN people p ON p.person_id = r.person_id
GROUP BY p.name
ORDER BY COUNT(r.role) DESC;

-- Robert De Niro: 54 films 




