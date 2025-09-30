/*
LESSON 1 - "THE BIG 6"
You should be VERY VERY comfortable with each of these statements:
	1. SELECT - what do you want?
    2. FROM - from where?
    3. WHERE - subset or filter data for rows that meet one or more conditions
    4. GROUP BY - define groups (similar to pivot tables in Excel)
    5. HAVING - subset groups (if used, must appear after the GROUP BY statement), similar to WHERE but for groups instead of individuals observations, WHERE filters rows, HAVING filters groups
    6. ORDER BY - sort the data

- Your only job is to understand these 6 statements by the end of this script. 
-   We will introduce a few functions as needed, but do not get hung up trying to memorize functions (those are easily found via Google)
-   Stay organized, keep your code clean, space/tab neatly

*/

-- Comments:
# sample
-- sample
/* makes mulitple lines
 * 
 */

/* 
When you run the USE statement, the databse you "USE" will change in the top menu, that means you are in that database and ready to query it 
	- If you get an error that a table does not exist, you either 1) spelled the table name wrong or 2) are not in the appropriate database, so be sure to run USE ... before working
	- Note: DBeaver appears to have a glitch here, let's discuss in class.
*/

USE airbnb_broward;

SELECT *
FROM listings;

/*
Data source: http://insideairbnb.com/get-the-data.html
*/

SELECT listing_id, name, room_type, price 
FROM listings;

-- 1 & 2. SELECT / FROM
	-- a. Grab the price column from the listings dataset

SELECT price
FROM listings;

    -- b. Grab room type, name, and price

SELECT room_type, name, price
FROM listings;

	-- c. Grab all columns from the data


/*
 SELECTs can get long and complicated (this is GENERALLY where all the "complicated" work is done), for now, let's look at 3 additional features
		1) creating new columns, or "calculated fields",
 		2) renaming, or "aliasing" a column,  
 		3) aggregate functions (such as AVG(), MIN(), MAX(), COUNT(), etc)
 			There's a function for everything - https://dev.mysql.com/doc/refman/9.0/en/functions.html
 			I introduce a few big ones here, but plan on looking them up until you memorize the few you'll use most
*/

    -- d. Grab property id, name, room type and price, and add a "discount price" column, offering guests 30% off

SELECT 
	listing_id,
	name,
	room_type,
	price,
	price*.7 AS 'Discount Price'
FROM listings;

	-- e. Give your discount price column an appropriate name (THIS IS CALLED ALIASING, any alias is temporary, only in the output, not in the source data)

    -- f. What is the average, minimum, and maximum price per night? Alias each of those.

SELECT AVG(price) AS "Average Price", MIN(price) AS "Min Price", MAX(price) AS "Max Price"
FROM listings;

# COUNT(), DISTINCT(), COUNT(DISTINCT);
 
    -- g. How many properties are in the data?   

SELECT COUNT(*)
FROM listings;
# number of rows 
# counts rows that have a value

SELECT COUNT(*), COUNT(listing_id), COUNT(neighbourhood), COUNT(price)
FROM listings;

    -- h. Return a list of neighbourhoods in Broward. Remove any duplicates.  

SELECT DISTINCT neighbourhood
FROM listings;

    -- i. How many neighbourhoods is that?

SELECT COUNT(DISTINCT neighbourhood)
FROM listings;


/* 3. WHERE - Used to filter ROWS
 		=
 		!=
 		>, >=
 		<, <=
 		IN
 		BETWEEN ... AND..., NOT BETWEEN... AND...
 		LIKE, NOT LIKE
 		IS NULL, IS NOT NULL
 			- Many more, I'm listing common ones
 			- AND or OR to put multiple conditions together, use parenthesis to enforce order if you have multiple AND and OR in one query
*/
SELECT * 
FROM listings 
WHERE neighbourhood = "Fort Lauderdale"
	AND price < 100
	AND room_type = 'Entire home/apt';

SELECT *
FROM listings
WHERE neighbourhood = 'Fort Lauderdale'
	OR neighbourhood = 'Hollywood'
	OR neighbourhood = 'Miramar';

SELECT *
FROM listings WHERE neighbourhood IN('Fort Lauderdale', 'Maramar', 'Hollywood');
-- shorter version of OR multiple times 

	--  =   Return a list of rentals available in Fort Lauderdale
    -- !=  Return a list of all properties in Fort Lauderdale, but exclude shared rooms
    -- <  Return a list of rentals available in Fort Lauderdale, excluding shared rooms, for under $100 per night
    -- BETWEEN ... AND ...  Return a list of rentals available in Fort Lauderdale, excluding shared, for between $100 and $125 a night 
    -- IN()  Return a list of rentals available in Fort Lauderdale, Weston, or Davie, excluding shared rooms, for under $100 per night
	-- LIKE  Return a list of rentals that have a pool (LIKE for simple patterns, if you need something more complicated, check out the regular expression stuff - https://dev.mysql.com/doc/refman/9.0/en/regexp.html, simpler tutorial here - https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/)
	-- LIKE lets us search for patterns
		-- mix actual characters with:
			-- _ <- any character, once
            -- % <- any character, any number of times


/* 4. GROUP BY
 		GROUP BY creates "groups", think pivot tables in Excel
 		WORTH KNOWING: You can use column numbers in GROUP BY (and ORDER BY) rather than column names shorten code (can also use alias's)
*/
	-- a. What is the average price per night for rentals on Airbnb in Broward? (note that aggregate functions without GROUP BY always return a single row)
    SELECT neighbourhood, AVG(price)
    FROM listings
    group by 1;
   
-- be careful mixing aggregate functions with non-aggregated columns!


    -- b. Report the average price per night for each neighbourhood. (NOTE: This is an incredibly common query - "return X by Y", if you were in Excel this would just be a pivot table)
SELECT neighbourhood, room_type, AVG(price) 
FROM listings
group by 1,2;

    -- c. Return a table that provides the number of rentals and average price by neighbourhood. Format average price appropriately.
SELECT
	neighbourhood,
	AVG(price),
	count(*),
	sum(number_of_reviews)
from listings group by 1;


-- 5 HAVING
	-- Return the number of properties and average price per night by neighborhood, for neighborhoods with at least 250 properties

SELECT
	neighbourhood,
	COUNT(*),
	AVG(price)
FROM listings 
group by 1
having count(*) >250;

	-- Return a list of hosts that have more than 50 properties listed
SELECT host_id, host_name, count(*)
FROM listings
group by 1, 2
HAVING COUNT(*) > 50;

    -- How many total reviews do these hosts have across their properties?

SELECT host_id,
host_name,
count(*),
sum(number_of_reviews)
FROM listings
group by 1, 2
HAVING COUNT(*) > 50;


-- NEED TO UNDERSTAND THE DIFFERENCE B/W WHERE AND HAVING!


-- 6 ORDER BY
	-- Return the average price per night by neighborhood for entire home/apt, in descending order by price

select neighbourhood, avg(price)
from listings l 
where room_type = 'Entire home/apt'
group by 1

    -- Repeat, this time with price formatted as currency (check out this blog post - https://www.sisense.com/blog/how-to-format-numbers-as-currency-in-postgres-mysql-and-redshift/)

select neighbourhood, avg(price)
from listings l where room_type = 'Entire home/apt'
group by 1
order by avg(price) DESC;

select neighbourhood, room_type, avg(price)
from listings l where room_type = "Entire home/apt"
group by 1, 2
order by 1, 2;


-- LIMIT
	-- Return the 5 most expensive rentals
SELECT *
from listings 
order by price DESC 
limit 5;

    -- Return the 5 most expensive neighborhoods

SELECT neighbourhood
from listings 
limit 5;



/*
Challenge Question
	Can you calculate estimated annual revenue for each host?
     - Return a table of hosts; include host id, host name, number of properties and expected annual revenue
     - Only include properties that have at least 1 review
     - Only include hosts with at least 50 properties
     - Format total revenue and order results appropriately
     - AND SORT THE DATA HIGH TO LOW BY EXPECTED REVENUE!
     - HINT: Use all 6 of the Big 6 SQL statements
*/





/*
 * CAN YOU EXPLAIN THE DIFFERENCE B/W COUNT(), DISTINCT, COUNT(DISTINCT ), AND SUM()??
 * CAN YOU EXPLAIN THE DIFFERENCE B/W WHERE AND HAVING?
 * 
 * 
 * 
 * USE airbnb_broward;


/*
 * WHERE
 * 	 LIKE, NOT LIKE
 *   mix actual characters with:
 * 		_ : any character, once per underscore
 * 		% : any character, any number of times
 */
SELECT
	DISTINCT host_name
from listings
where host_name LIKE "Dan%";
	-- includes any host name starting with Dan
SELECT
	DISTINCT host_name
from listings
where host_name LIKE "D%";
	-- return any host name starting with D
SELECT
	DISTINCT host_name
from listings
where host_name LIKE "_";
	-- return any host name one character long
SELECT
	DISTINCT host_name
from listings
where host_name LIKE "_a__";
	-- locks down a as second character
--Regular Expressions 
SELECT
	DISTINCT host_name
from listings
where host_name LIKE '_a%';
	-- 
SELECT name
from listings
WHERE name LIKE 'Oceanview%';

SELECT 
name LIKE "%OCean%front%" AS 'Oceanfront',
AVG (price)
from listings
group by 1;

SELECT name
from listings
WHERE name LIKE '%Oceanview%'
	OR name LIKE '%Oceanfront%';

/* 
 * Formatting numbers / currency
 * 
 */
SELECT
	name,
	price,
	CONCAT('$', price)
	FORMAT(price, 2)
	CONCAT('4', FORMAT(price,0))
FROM listings
ORDER BY 2 DESC;

SELECT 
	name,
	CONCAT ('$', FORMAT (price,0))
FROM listings 
ORDER BY price DESC;

	-- want to add $ sign and thousand separator 

-- avg price by neighbourhood using AS
SELECT
	neighbourhood,
	CONCAT('$', FORMAT(AVG(price), 0)) AS 'Avg Price'
FROM listings
GROUP BY 1
ORDER BY 2 DESC;

-- in Excel, "IF (price > 200, 'exprensive, 'cheap')"
SELECT 
	name,
	price,
		CASE
			WHEN price >200 THEN 'Expensive'
			WHEN price = 200 THEN 'Cheap'
			ELSE 'Price Missing'
		END
	END AS 'Price Group'
FROM listings;

SELECT
	number_of_reviews,
	CASE
		WHEN number_of_reviews = 0 THEN 'Incredibly Unpopular'
		WHEN number_of_reviews < 33 THEN 'Below Average'
		WHEN number_of_reviews < 93 THEN 'Average'
		WHEN number_of_reviews < 153 THEN 'Above Average'
		WHEN number_of_reviews <= 153 THEN 'Incredibly Popular'
	END AS 'Popularity',
	COUNT(*) AS '# of Properties',
	AVG(price) AS 'Avg Price'
FROM listings;
Group by 1;
	
/*
Challenge Question
	Can you calculate estimated annual revenue for each host?
     - Return a table of hosts; include host id, host name, number of properties and expected annual revenue
     - Only include properties that have at least 1 review
     - Only include hosts with at least 50 properties
     - Format total revenue and order results appropriately
     - AND SORT THE DATA HIGH TO LOW BY EXPECTED REVENUE!
     - HINT: Use all 6 of the Big 6 SQL statements
*/







/*
CASE / WHEN
	Used for "IF-THEN-ELSE" type logic
    Think "WHEN this THEN that"
*/

-- Are more popular homes more expensive?
--    WANT:    Popularity   # of Properties    Average Price
--    popularity = 1-5 from unpopular to popular







USE iowa;
/* 
 * Iowa Liquor Sales 
 *   1) Return a table that displays the total sales by store CHAIN for the month of July 2024
 *   2) Report the volume sold by category, but group category (i.e. all the whiskies into "Whiskey", all the vodkas into "Vodka", etc
 *       - As many as you can get, doesn't have to be all of them...
 *   3) Does 2) change by winter vs summer months?
 *   4) What is the distribution of order size?
 *        - Return the number of orders and average sale total for the following Order Size groups:

			Order Size			Sale Quantity
	        ---------			-------------
	        Individual			sale_quantity = 1
	        Small Order			sale_quantity < 20
	        Medium Order		sale_quantity < 100
	        Large Order			sale_quantity < 500
	        Very Large / Bulk	sale_quantity >= 500
 * 
 */


-- Totals by chain in July 2024

-- Totals by category

-- same, winter vs summer

-- Distribution of order size



/* ***** */
USE misc;

/* 
 * nbapow table 
 *   What is the average height of the player of the week by season?
 */




USE airbnb_broward;

/*
CASE / WHEN
	Used for "IF-THEN-ELSE" type logic
    Think "WHEN this THEN that"
*/

-- Are more popular homes more expensive?
--    WANT:    Popularity   # of Properties    Average Price
--    popularity = 1-5 from unpopular to popular

-- This query is just to find reasonable cutoffs for my bins in the next query
SELECT 
	AVG(number_of_reviews) AS 'Average',
	AVG(number_of_reviews) + STDDEV(number_of_reviews) AS '+1 St Dev',
	AVG(number_of_reviews) + 2*STDDEV(number_of_reviews) AS '+2 St Dev'
FROM listings;

SELECT
	CASE 
		WHEN number_of_reviews = 0 THEN 'No Reviews'
		WHEN number_of_reviews < 33 THEN 'Below Average'
		WHEN number_of_reviews < 95 THEN 'Average'
		WHEN number_of_reviews < 155 THEN 'Above Average'
		ELSE 'Very Popular'
	END AS 'Popularity',
	CONCAT('$', FORMAT(AVG(price), 0)) AS 'Average Price' 
FROM listings
GROUP BY 1
ORDER BY AVG(number_of_reviews) DESC;



USE iowa;
/* 
 * Iowa Liquor Sales 
 *   1) Return a table that displays the total sales by store CHAIN for the month of July 2024
 *   2) Report the volume sold by category, but group category (i.e. all the whiskies into "Whiskey", all the vodkas into "Vodka", etc
 *       - As many as you can get, doesn't have to be all of them...
 *   3) Does 2) change by winter vs summer months?
 *   4) What is the distribution of order size?
 *        - Return the number of orders and average sale total for the following Order Size groups:

			Order Size			Sale Quantity
	        ---------			-------------
	        Individual			sale_quantity = 1
	        Small Order			sale_quantity < 20
	        Medium Order		sale_quantity < 100
	        Large Order			sale_quantity < 500
	        Very Large / Bulk	sale_quantity >= 500
 * 
 */


-- Totals by chain in July 2024 -- change data selection to "localhost" and "iowa"
SELECT 
	CASE 
		WHEN store LIKE 'AJ%' THEN "AJ's"
		WHEN store LIKE 'CASEY%' THEN "Casey's"
		WHEN store LIKE 'FAREW%' THEN 'Fareway'
		WHEN store LIKE 'HAWK%' THEN 'Hawkeye'
		WHEN store LIKE 'HY-Vee%' THEN 'Hy-Vee'
		WHEN store LIKE 'KUM%' THEN 'Kum & Go'
		WHEN store LIKE 'KWIK%' THEN 'Kwik'
		WHEN store LIKE 'TARGET%' THEN 'Target'
		WHEN store LIKE 'WAL-MAR%' THEN 'Wal-Mart'
		WHEN store LIKE 'Walgre%' THEN 'Walgrens'
		ELSE 'Other'
	END AS 'Chain',
	FORMAT(SUM(sale_qty), 0) AS 'Bottles',
	FORMAT(SUM(sale_gallons), 0) AS 'Volume (Gallons)',
	CONCAT('$', FORMAT(SUM(sale_total), 0)) AS 'Sales ($)'
FROM x_full_table
GROUP BY 1
ORDER BY SUM(sale_total) DESC;
	

-- Totals by category

SELECT DISTINCT category
FROM x_full_table;


SELECT 
category,
CASE
	WHEN category LIKE '%Whisk%' THEN "Whiskey"
	WHEN category LIKE '%Bourb%' THEN "Whiskey"
	WHEN category LIKE '%Scotch%' THEN "Whiskey"
	WHEN category LIKE '%Teq%' THEN "Tequilay"
	WHEN category LIKE '%Vod%' THEN "Vodka"
	WHEN category LIKE '%Rum%' THEN "Rum"
	WHEN category LIKE '%Gin%' THEN "Gin"
	WHEN category LIKE '%Brand%' THEN "Brandy"
	WHEN category LIKE '%Special%' THEN "Specialty"
	WHEN category LIKE '%Lique%' THEN "Liquer"
	WHEN category LIKE "%Schna%" THEN "Schnapps"
	ELSE "Other"
END AS "Category",
sale_total,
sale_qty,
sale_gallons
FROM x_full_table xft;

SELECT
	category
	SUM(sale_total)
FROM x_full_table xft
ORDER BY 1;

-- cleaning up data to just want four categories: 
	-- category, sale total, total bottles, total volume
	-- delete first category to clean
	-- use CONCAT for currency and FORMAT for decimal places 
	-- use AS to assign name to column
	-- GROUP BY 1 to sort under category as first column

SELECT 
CASE
	WHEN category LIKE '%Whisk%' THEN "Whiskey"
	WHEN category LIKE '%Bourb%' THEN "Whiskey"
	WHEN category LIKE '%Scotch%' THEN "Whiskey"
	WHEN category LIKE '%Teq%' THEN "Tequila"
	WHEN category LIKE '%Vod%' THEN "Vodka"
	WHEN category LIKE '%Rum%' THEN "Rum"
	WHEN category LIKE '%Gin%' THEN "Gin"
	WHEN category LIKE '%Brand%' THEN "Brandy"
	WHEN category LIKE '%Special%' THEN "Specialty"
	WHEN category LIKE '%Lique%' THEN "Liquer"
	WHEN category LIKE "%Schna%" THEN "Schnapps"
	ELSE "Other"
END AS "Category",
CONCAT('$', FORMAT(SUM(sale_total), 0)) AS 'Total Sales',
FORMAT(SUM(sale_qty), 0) AS "Total Bottles",
FORMAT(SUM(sale_gallons), 0) AS 'Total Volume (Gal)'
FROM x_full_table xft
Group by 1;

-- 0 means how many decimals for the number in Formatting


-- same, winter vs summer [COME BACK AND INTRODUCE PIVOT IN THIS EXAMPLE!]
-- need to make season category with dates:

SELECT 
	date,
	CASE
		WHEN MONTH(date) IN(1,2,3) THEN "Winter"
		WHEN MONTH(date) IN(5,6,7) THEN "Summer"
		ELSE 'April' 
	END AS 'Season'
FROM x_full_table xft ;

-- copy paste into other query 

SELECT 
	CASE
		WHEN MONTH(date) IN(1,2,3) THEN "Winter"
		WHEN MONTH(date) IN(5,6,7) THEN "Summer"
		ELSE 'April' 
	END AS 'Season',
	CASE
		WHEN category LIKE '%Whisk%' THEN "Whiskey"
		WHEN category LIKE '%Bourb%' THEN "Whiskey"
		WHEN category LIKE '%Scotch%' THEN "Whiskey"
		WHEN category LIKE '%Teq%' THEN "Tequila"
		WHEN category LIKE '%Vod%' THEN "Vodka"
		WHEN category LIKE '%Rum%' THEN "Rum"
		WHEN category LIKE '%Gin%' THEN "Gin"
		WHEN category LIKE '%Brand%' THEN "Brandy"
		WHEN category LIKE '%Special%' THEN "Specialty"
		WHEN category LIKE '%Lique%' THEN "Liquer"
		WHEN category LIKE "%Schna%" THEN "Schnapps"
		ELSE "Other"
	END AS "Category",
CONCAT('$', FORMAT(SUM(sale_total), 0)) AS 'Total Sales'
FROM x_full_table 
WHERE MONTH(date) != 4
GROUP BY 1, 2;

-- NEW TRY: THIS ONE PIVOTED
-- sorting whiskies and making columns of specific whiskey
	-- asking data to return if it is in the column (If Canadian Whiskey, return data in Canadian Whiskey column)
-- Used SUM of each category to show total sales of all categories we just made

SELECT  
	SUM(sale_total) AS 'Total Sales',
	SUM(CASE
		WHEN category = 'CANADIAN WHISKIES' THEN sale_total ELSE NULL 
	END) AS "Canadian Whiskey",
	SUM(CASE
		WHEN category = 'SCOTCH WHISKIES' THEN sale_total ELSE NULL 
	END) AS "Scotch Whiskey",
	SUM(CASE
		WHEN category = 'IRISH WHISKIES' THEN sale_total ELSE NULL 
	END) AS "Irish Whiskey"
FROM x_full_table;

-- Now use the SUM and CASE WHEN to create columns of each season for each type of liquor 
-- Used != 4 because April is not in Winter or Summer 

SELECT 
	CASE
		WHEN category LIKE '%Whisk%' THEN "Whiskey"
		WHEN category LIKE '%Bourb%' THEN "Whiskey"
		WHEN category LIKE '%Scotch%' THEN "Whiskey"
		WHEN category LIKE '%Teq%' THEN "Tequila"
		WHEN category LIKE '%Vod%' THEN "Vodka"
		WHEN category LIKE '%Rum%' THEN "Rum"
		WHEN category LIKE '%Gin%' THEN "Gin"
		WHEN category LIKE '%Brand%' THEN "Brandy"
		WHEN category LIKE '%Special%' THEN "Specialty"
		WHEN category LIKE '%Lique%' THEN "Liquer"
		WHEN category LIKE "%Schna%" THEN "Schnapps"
		ELSE "Other"
	END AS "Category",
	SUM(sale_total) AS 'Total Sales',
	CONCAT("$", FORMAT(SUM(
		CASE
			WHEN MONTH(date) IN(1,2,3) THEN sale_total ELSE NULL
		END), 0)) AS 'Winter Sales',
	CONCAT("$", FORMAT(SUM(
		CASE
			WHEN MONTH(date) IN(5,6,7) THEN sale_total ELSE NULL
		END), 0)) AS 'Summer Sales'		
FROM x_full_table 
WHERE MONTH(date) != 4
GROUP BY 1;

-- ERROR MESSAGE: left a comma at the end of CONCAT line
-- Distribution of order size [SKIP THIS ONE]
		-- Order Size			Sale Quantity
	       --  ---------			-------------
	        -- Individual			sale_quantity = 1
	       --  Small Order			sale_quantity < 20
	       --  Medium Order		    sale_quantity < 100
	       --  Large Order			sale_quantity < 500
	       --  Very Large / Bulk	sale_quantity >= 500
 * 
-- Tryin to highlight 3 CASE/WHEN scenarios
 -- 1) CASE/WHEN to create the column we are using in GROUP BY
 -- 2) CASE/WHEN to manipulate the numeric variable we are aggregating
 -- 3) CASE/WHEN to transpose results


/* ***** */
USE misc;

/* 
 * nbapow table 
 *   What is the average height of the player of the week by season?
 */
SELECT *
FROM nbapow;
 
-- SUBSTRING(where, start position, how many characters to return)
--- For how many characters to return, you can put 9999999 if the amount that u need to return is unknown.
-- Not like Python; first position is 1 not 0

SELECT 
Season,
Height,
FLOOR((SUBSTRING(Height, 1, 1)*12 + SUBSTRING(Height, 3, 2))/12) AS "Feet",
SUBSTRING((SUBSTRING(Height, 1, 1)*12 + SUBSTRING(Height, 3, 2))/12, 2, 999) * 12 AS "Inches"
FROM nbapow;

-- FLOOR: returns first value 
-- MOD: returns remainder

SELECT 
Season,
Height,
CASE
	WHEN SUBSTRING(Height, 2, 1) = '-' THEN SUBSTRING(Height, 1, 1)*12 + SUBSTRING(Height, 3, 2)
	ELSE SUBSTRING(Height, 1, 3)* .393701
END
FROM nbapow
GROUP BY Season, Height;

-- There are centimeters and inch values in the Height category, so we need to sort it thru CASE/WHEN with SUBSTRING

SELECT
	Season,
	CONCAT(FORMAT(AVG(CASE
	WHEN SUBSTRING(Height, 2, 1) = '-' THEN SUBSTRING(Height, 1, 1)*12 + SUBSTRING(Height, 3, 2)
	ELSE SUBSTRING(Height, 1, 3)* .393701
END), 1), '"') AS "Height (in)"
FROM nbapow 
GROUP BY 1;

USE iowa;
/*
 * CASE/WHEN to transpose table
 * 		Example 1: Liquor by Category, Winter vs Summer sales
 * 		Example 2: Sales by month in each city
 */


SELECT 
	MONTHNAME(date),
	CONCAT("$",FORMAT(SUM(sale_total), 0)) AS 'Total ($)', 
	CONCAT("$", FORMAT(SUM(CASE
		WHEN City = "AMES" THEN sale_total ELSE NULL
	END), 0)) AS "Ames ($)",
	CONCAT("$", FORMAT(SUM( CASE 
		WHEN City = "IOWA CITY" THEN sale_total ELSE NULL
	END), 0)) AS "Iowa City ($)"
FROM x_full_table
GROUP BY 1;


-- Try to do this with columns being each month to practice transposing

/*
 * JOINS and UNIONS
 */

/*
 * Here I create two simple tables to introduce the idea of joining tables together
 * 
 */

USE misc;


/*

CREATE TABLE `studentcareer` (
  `id` char(5) DEFAULT NULL,
  `resume` char(1) DEFAULT NULL,
  `mock_interview` char(1) DEFAULT NULL,
  `internships` smallint DEFAULT NULL
);


INSERT INTO `studentcareer` VALUES ('C1234','Y','Y',1),('C1456','Y','N',2),('C1423','Y','Y',0),('C1444','N','N',1),('C4133','Y','N',3);

CREATE TABLE `studentgrades` (
  `id` char(5) DEFAULT NULL,
  `credits` smallint DEFAULT NULL,
  `gpa` decimal(3,2) DEFAULT NULL
);


INSERT INTO `studentgrades` VALUES ('C1234',86,3.24),('C2145',72,3.35),('C1423',112,3.87),('C4133',101,3.55),('C1268',20,3.98);

*/

-- run the code about ONLY ONCE, then hit misc and refresh, tables should show on the left
-- for some reason it's not showing up in the Database on the left, but the tables should show up as studentgrades and studentcareer

SELECT * FROM studentgrades;
SELECT * FROM studentcareer;

-- grades: C 1234, 2145, 1423, 4133, 1268
-- career: C 1234, 1456, 1423, 1444, 4133

/*
 * Try each of the following joins
 *     - INNER JOIN (or simply JOIN)
 *     - LEFT JOIN
 *     - RIGHT JOIN
 *     - FULL OUTER JOIN (doesn't exist in MySQL, need to blend LEFT and RIGHT joins)
 */

-- INNER JOIN

SELECT *
FROM studentgrades
INNER JOIN studentcareer on studentgrades.id = studentcareer.id;

-- INNER JOIN = same as JOIN
-- SHORTCUT:
	-- use names to shorten the query (g names studentgrades as g)
	-- use for JOIN, can't use the studentgrades name for the rest of the query, have to use g

SELECT *
FROM studentgrades g
JOIN studentcareer c ON g.id = c.id;

-- SHORTCUT:
	-- if column is exact same, can use the USING(x) function

SELECT *
FROM studentgrades g
JOIN studentcareer c USING(id);


-- LEFT JOIN
	-- saying keep everything in the left table (studentgrades) and add anything in the right table (studentcareers) that is repeated
	-- repeats the id column and says NULL if no matching values

SELECT *
FROM studentgrades g
LEFT JOIN studentcareer c ON g.id = c.id;

-- RIGHT JOIN
	-- saying keep everything in studentcareers and then any left table (studentgrades) values that are repeated
	-- repeats the id column and says NULL if no matching values

SELECT *
FROM studentgrades g
RIGHT JOIN studentcareer c ON g.id = c.id;

-- FULL OUTER JOIN
	-- DBEAVER doesnt have OUTER JOIN for some reason: try to make our own with LEFT and RIGHT join 
	-- Use UNION between two queries with LEFT and RIGHT

SELECT *
FROM studentgrades g
LEFT JOIN studentcareer c USING(id)
UNION
SELECT *
FROM studentgrades g
RIGHT JOIN studentcareer c USING(id);


SELECT 
	g.id,
	g.credits,
	c.resume,
	c.mock_interview,
	c.internships
FROM studentgrades g
LEFT JOIN studentcareer c ON g.id = c.id
UNION
SELECT 
	c.id,
	g.credits,
	g.gpa
	c.resume,
	c.mock_interview,
	c.internships
FROM studentgrades g
RIGHT JOIN studentcareer c ON g.id = c.id;

/*
 * JOIN vs LEFT JOIN
 * Switching to games database to highlight JOIN vs LEFT JOIN
 *    games = list of video games
 *    reviews = reviews for video games, but some games do not have a review
 */

USE games;

SELECT * FROM reviews;
SELECT * FROM games;

SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM games;
-- note that there are 9,906 games, but only 5,732 reviews. This means my inner join vs left join will give different results, and we need to be careful which one we choose.


-- 5 INNER JOIN
-- NOTE: COUNT(*) will reveal that many games were dropped.


-- 6 LEFT JOIN
--	NOTE: COUNT(*) will reveal that we didn't drop any games.

-- 7 How many games and average user score by Publisher?
-- 	NOTE: Need LEFT JOIN here because we want to know "how many games" a publisher has. Just because a game has not been reviewed, does not mean it's not a game!


USE iowa;
/*
 * CASE/WHEN to transpose table
 * 		Example 1: Liquor by Category, Winter vs Summer sales
 * 		Example 2: Sales by month in each city
 */









/*
 * JOINS and UNIONS
 */

/*
 * Here I create two simple tables to introduce the idea of joining tables together
 * 
 */

USE misc;

/*

CREATE TABLE `studentcareer` (
  `id` char(5) DEFAULT NULL,
  `resume` char(1) DEFAULT NULL,
  `mock_interview` char(1) DEFAULT NULL,
  `internships` smallint DEFAULT NULL
);


INSERT INTO `studentcareer` VALUES ('C1234','Y','Y',1),('C1456','Y','N',2),('C1423','Y','Y',0),('C1444','N','N',1),('C4133','Y','N',3);

CREATE TABLE `studentgrades` (
  `id` char(5) DEFAULT NULL,
  `credits` smallint DEFAULT NULL,
  `gpa` decimal(3,2) DEFAULT NULL
);


INSERT INTO `studentgrades` VALUES ('C1234',86,3.24),('C2145',72,3.35),('C1423',112,3.87),('C4133',101,3.55),('C1268',20,3.98);

*/




SELECT * FROM studentgrades;
SELECT * FROM studentcareer;


/*
 * Try each of the following joins
 *     - INNER JOIN (or simply JOIN)
 *     - LEFT JOIN
 *     - RIGHT JOIN
 *     - FULL OUTER JOIN (doesn't exist in MySQL, need to blend LEFT and RIGHT joins)
 */

-- INNER JOIN

-- LEFT JOIN

-- RIGHT JOIN

-- FULL OUTER JOIN






/*
 * JOIN vs LEFT JOIN
 * Switching to games database to highlight JOIN vs LEFT JOIN
 *    games = list of video games
 *    reviews = reviews for video games, but some games do not have a review
 */

USE games;

SELECT * FROM reviews;
SELECT * FROM games;

SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM games;
-- note that there are 9,906 games, but only 5,732 reviews. This means my inner join vs left join will give different results, and we need to be careful which one we choose.


-- 5 INNER JOIN
-- NOTE: COUNT(*) will reveal that many games were dropped.


-- 6 LEFT JOIN
--	NOTE: COUNT(*) will reveal that we didn't drop any games.

-- 7 How many games and average user score by Publisher?
-- 	NOTE: Need LEFT JOIN here because we want to know "how many games" a publisher has. Just because a game has not been reviewed, does not mean it's not a game!








 */
USE airbnb_broward;


/*
 * WHERE
 * 	 LIKE, NOT LIKE
 *   mix actual characters with:
 * 		_ : any character, once per underscore
 * 		% : any character, any number of times
 */


/* 
 * Formatting numbers / currency
 * 
 */




/*
Challenge Question
	Can you calculate estimated annual revenue for each host?
     - Return a table of hosts; include host id, host name, number of properties and expected annual revenue
     - Only include properties that have at least 1 review
     - Only include hosts with at least 50 properties
     - Format total revenue and order results appropriately
     - AND SORT THE DATA HIGH TO LOW BY EXPECTED REVENUE!
     - HINT: Use all 6 of the Big 6 SQL statements
*/







/*
CASE / WHEN
	Used for "IF-THEN-ELSE" type logic
    Think "WHEN this THEN that"
*/

-- Are more popular homes more expensive?
--    WANT:    Popularity   # of Properties    Average Price
--    popularity = 1-5 from unpopular to popular







USE iowa;
/* 
 * Iowa Liquor Sales 
 *   1) Return a table that displays the total sales by store CHAIN for the month of July 2024
 *   2) Report the volume sold by category, but group category (i.e. all the whiskies into "Whiskey", all the vodkas into "Vodka", etc
 *       - As many as you can get, doesn't have to be all of them...
 *   3) Does 2) change by winter vs summer months?
 *   4) What is the distribution of order size?
 *        - Return the number of orders and average sale total for the following Order Size groups:

			Order Size			Sale Quantity
	        ---------			-------------
	        Individual			sale_quantity = 1
	        Small Order			sale_quantity < 20
	        Medium Order		sale_quantity < 100
	        Large Order			sale_quantity < 500
	        Very Large / Bulk	sale_quantity >= 500
 * 
 */


-- Totals by chain in July 2024

-- Totals by category

-- same, winter vs summer

-- Distribution of order size



/* ***** */
USE misc;

/* 
 * nbapow table 
 *   What is the average height of the player of the week by season?
 */


/* Common Table Expressions */

/*
CTEs take subqueries out of JOIN/FROM and build those tables first, then move on to query them
This leaves your main "outer query" a bit cleaner and easier to read / follow

WITH 
	table1 AS (
		SUBQUERY HERE
	),
    table2 AS(
		SUBQUERY HERE
	)
	QUERY THOSE TABLES
*/

/* 
Consider previous example
 - Calculate monthly sales in "wide" form
 - Subquery for monthly sales, then JOIN
*/
USE miami;
SELECT 
	CONCAT('$', FORMAT(may + june + july, 0)) AS 'Total ($)',
	CONCAT('$', FORMAT(may, 0)) AS 'May ($)',
	CONCAT('$', FORMAT(june, 0)) AS 'June ($)',
	CONCAT('$', FORMAT(july, 0)) AS 'July ($)'
FROM(
	SELECT SUM(amount) AS 'may'
	FROM po_052024
) a
JOIN(
	SELECT SUM(amount) AS 'june'
	FROM po_062024
) b
JOIN(
	SELECT SUM(amount) AS 'july'
	FROM po_072024
) c
;
    
-- As common table exression (using WITH syntax rather than subquery in FROM / JOIN)


WITH may_total AS(

),
june_total AS(

),
july_total AS(

)
...
;




/*
 * Example - similar to homework
 * 		Find the top customer in each country
 * 		1st: Obtain total spend for each customer in each country [WANT: Country, Customer, Total Spend]
 * 		2nd: Find the max total spend from a customer in each country [WANT: Country, Max Total Spend]
 * 		3rd: Put together and filter
 */

USE northwind;


-- table1:
-- table2:




-- WITHOUT CTE

SELECT 
	Country,
	CustomerID,
	CONCAT(FirstName, ' ', LastName) AS 'Customer',
	CONCAT('$', FORMAT(Spend, 0)) AS 'Total Spend'
FROM (
SELECT 
	Country,
	CustomerID,
	FirstName,
	LastName,
	SUM(TotalAmount) AS 'Spend'
FROM orders o
JOIN customer c ON o.CustomerID = c.ID
GROUP BY 1, 2, 3, 4
) table1
JOIN(
	SELECT Country, MAX(Spend) AS 'MaxSpend'
	FROM (
		SELECT 
			Country,
			CustomerID,
			FirstName,
			LastName,
			SUM(TotalAmount) AS 'Spend'
		FROM orders o
		JOIN customer c ON o.CustomerID = c.ID
		GROUP BY 1, 2, 3, 4
	) inner_table
	GROUP BY 1
) table2 USING(Country)
WHERE Spend = MaxSpend
;







/*
Using the ins database
Calculate each patients total cost for last year
Claims in:
	- medical
    - dental
    - vision
    - rx
*/

USE ins;

SELECT * FROM patients;
SELECT * FROM medical;
SELECT * FROM dental;
SELECT * FROM vision;
SELECT * FROMs rx;

-- 1) using subqueries in JOIN/FROM


-- 2) written using common table expressions

    
    











