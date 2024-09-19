/*
INSTRUCTIONS:
	1 Write a query to answer each question. 
    2 You do not have to additionally write an answer or comment, the query is sufficient.
    3 Alias all column names appropriately (no "code" in headers, underscores, etc).
    4 Dollar values should be appropriately formatted as currency (dollar signs, commas).
    5 All other numbers should be formatted or rounded appropriately.


SUBMISSIONS:
	* Rename this file with your name (e.g. DougLehmann_HW1.sql)
	* Submit this SQL file to Blackboard
		* Please refer to syllabus for grading policy
        * YOU GET ONE SUBMISSION (So stay organized, and know what you have where / what you're submitting the first time)

     
     
Please use the world schema to answer each of the questions below
world has the following three tables:
1 city
2 country
3 languages
    
    
    
For Part 2 / Carmen Sandiego, you can just take the answer from each query and use it in the next. 
You do not need subqueries or joins to solve everything in one query.

*/


-- YOUR NAME HERE: Mackenzie Dryden

USE world;

-- 1 - Select all variables from the languages table

SELECT *
FROM languages;

-- 2 - Select the CountryCode variable from the languages table

SELECT CountryCode
FROM languages;

-- 3 - Select CountryCode and languages

SELECT 
CountryCode,
language
FROM languages;

-- 4 - Select CountryCode, languages, and number of speakers for each language in each country

SELECT
CountryCode,
language,
FORMAT(Population * (Percentage / 100), 0) AS "Number of Speakers"
FROM languages;

-- 5 - How many rows are in the languages table?

SELECT COUNT(language)
FROM languages;

-- 984 rows

-- 6 - How many languages are spoken worldwide (according to this data source...)?

SELECT COUNT(DISTINCT language)
FROM languages; 

-- 457 languages

-- 7 - How many countries are represented in the country table?

SELECT COUNT(DISTINCT Name)
FROM country;

-- 239 countries

-- 8 - Return the CountryCode and the official language of for each country

SELECT 
	CountryCode, language
FROM languages
WHERE IsOfficial = "T"
GROUP BY 1, 2;

-- 9 - Return the CountryCode, Official Language, and number of speakers of that language for each country

SELECT 
	CountryCode, 
	language AS "Official Language",
	FORMAT(Population * (Percentage / 100), 0) AS "Number of Speakers"
FROM languages
WHERE IsOfficial = "T"
ORDER BY 3 DESC;

-- 10 - Return the name, population, and GNP for countries in North America

SELECT Name, Population, GNP
FROM country
WHERE Continent LIKE "North America";

-- 11 - Return the Name, Population, and GNP for countries in North or South America that have a population over 30 million
 
SELECT Name, Population, GNP
FROM country
WHERE (Continent = "North America" OR Continent = "South America")
AND Population > 30000000;

-- 12 - Return Name, Population, and GNP for countries with populations between 50 and 100 million

SELECT Name, Population, GNP
FROM country
WHERE Population > 50000000
AND Population < 100000000;

-- 13 - How many countries is that (in 12)?

SELECT COUNT(*) AS "Number of Countries with Population of 50M-100M"
FROM country
WHERE Population > 50000000
AND Population < 100000000;

-- There are 14 countries

-- 14 - How many countries have a head of state whose first name begins with a J or an S?

SELECT COUNT(*) AS "Number of Countries with Head of State Starting with J or S"
FROM country
WHERE HeadOfState LIKE "J%"
OR HeadOfState LIKE "S%";

-- There are 35 countries

-- 15 - What is the total worlwide population?

SELECT 
SUM(Population)
FROM country;

-- Total: 6,078,749,450

-- 16 - What is the total population by continent? Order results high to low by population.

SELECT 
Continent, SUM(Population) as "Total Population"
FROM country
GROUP BY 1
ORDER BY 2 DESC;

-- 17 - Return a table that lists language and number of speakers, but only include languages that have > 200,000,000 speakers? Order these results high to low based on number of speakers

SELECT  
	language,
	FORMAT(Population * (Percentage / 100), 0) AS "Number of Speakers"
FROM languages
WHERE Population * (Percentage / 100) > 200000000
ORDER BY 2 ASC;


-- 18 - Which Countries speak 10 or more languages?

SELECT 
	CountryCode,
	COUNT(language) AS "Number of Languages"
FROM languages
GROUP BY CountryCode, "Number of Languages"
HAVING COUNT(language) >= 10
ORDER BY 2 DESC;

-- CAN, CHN, IND, RUS, USA, TZA, ZAF, COD, IRN, KEN, MOZ, NGA, PHL, SDN, UGA

-- 19 - What are the 10 most spoken languages worldwide?

SELECT  
language, 
	FORMAT(Population * (Percentage / 100), 0) AS 'Number of Speakers'
FROM languages
ORDER BY Population + (Percentage/100) DESC
LIMIT 10;

-- Chinese, Zhuang, MantAsu, Hui, Miao, Yi, Uighue, Tujia, Mongolian, Tibetian 

-- 20 - Which language is spoken in 15 different countries?

SELECT 
language, 
COUNT(CountryCode) AS "Country Amount"
FROM languages
GROUP BY language
HAVING COUNT(CountryCode) = 15;

-- Italian !!

/* WHERE IN THE WORLD IS CARMEN SANDIEG
 * O - https://en.wikipedia.org/wiki/Carmen_Sandiego */


-- 21 
/* Clue #1: 
We recently got word that someone fitting Carmen Sandiego's description has been traveling 
through Southern Europe. She's most likely traveling someplace where she won't be noticed, so 
find the least populated country in Southern Europe, and we'll start looking for her there.
*/

SELECT
	Name, Region, Population
FROM country 
WHERE Region = "Southern Europe"
ORDER BY Population ASC;
	
-- She's in: (Holy See) Vatican City State

-- 22 
/* Clue #2: 
Now that we're here, we have insight that Carmen was seen attending language classes in 
this country's officially recognized language. Check our databases and find out what language is
spoken in this country, so we can call in a translator to work with you.
*/

SELECT 
CountryCode, language
FROM languages 
WHERE CountryCode = "VAT";

-- She's studying: Italian

-- 23 
/* Clue #3: 
We have new news on the classes Carmen attended, our gumshoes tell us she's moved on
to a different country, a country where people speak only the language she was learning. Find out which
nearby country speaks nothing but that language.

This one is tricky! Don't give up!
*/

SELECT 
	CountryCode, Language, FORMAT(Percentage, 0) AS "Percent"
FROM languages
WHERE Language = "Italian" AND Percentage = 100;
	
SELECT 
	Code, Name
FROM country
WHERE Code = "SMR";

-- She's in: San Marino

-- 24 
/* Clue #4: 
We're booking the first flight out - maybe we've actually got a chance to catch her this time. There are only two 
cities she could be flying to in the country. One is named the same as the country and that would be too obvious. 
We're following our gut on this one; find out what other city in that country she might be flying to.
*/ 

SELECT
CountryCode, Name
FROM city 
WHERE CountryCode = "SMR" AND Name != "San Marino";
	
-- She's in: Serravalle


-- 25 

/* Clue #5: 
Oh no, she pulled a switch - there are two cities with very similar names, but in totally different parts of the globe! 
She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end 
the same. Find out the city, and do another search for what country it's in. Hurry!
*/
SELECT Code, Continent
FROM country
WHERE Continent = "South America";

-- Returns a list of countries in South America: ARG, BOL, BRA, CHL, COL, ECU, FLK, GUF, GUY, PER, PRY, SUR, URY, & VEN

SELECT
CountryCode, Name
FROM city
WHERE (CountryCode = "ARG" 
OR CountryCode = "BOL" 
OR CountryCode = "BRA" 
OR CountryCode = "CHL" 
OR CountryCode = "COL"
OR CountryCode = "ECU"
OR CountryCode = "FLK"
OR CountryCode = "GUF"
OR CountryCode = "GUY"
OR CountryCode = "PER"
OR CountryCode = "PRY"
OR CountryCode = "SUR"
OR CountryCode = "URY"
OR CountryCode = "VEN")
AND Name LIKE "Serr%";

-- She's in: Serra, Brazil

/* For this one, I had to find the countries that were in South America first to use the "South America" Continent category in the city data. 
 * Hopefully that's ok that I switched the order!
 */ -- ALTERNATE SOLUTION: Just looking up "Serra%" in city data where country is in South America

SELECT Name, CountryCode
FROM city
WHERE Name LIKE "Serr%";

-- 26 
/* Clue #6: 
We're close! Our South American agent says she just got a taxi at the airport, and is headed towards the capital! Look up the country's 
capital, and get there pronto! Send us the name of where you're headed and we'll follow right behind you!

*/

SELECT 
Name, Capital
FROM country
WHERE Name = "Brazil";

-- Returns "211" for ID

SELECT 
ID, Name
FROM city
WHERE ID = 211;

-- She's in: Brasalia, Brazil 

-- 27 
/* Clue #7: 
She knows we're close! Her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to 
catch her, we just have to know where she's heading and beat her to the landing dock. Lucky for us, she's getting cocky. She left us a note, and 
I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs - behind bars.

	Our playdate of late has been unusually fun
	As an agent, I'll say, you've been a joy to outrun.
	And while the food here is great, and the people so nice!
	I need a little more sunshine with my slice of life.
	So I'm off to add one to the population I find
	In a city of ninety-one thousand and now, eighty five.


We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.
*/

SELECT 
Name, CountryCode, Population
FROM city
WHERE Population = 91084;

-- We finally find her in: Santa Monica, USA!




