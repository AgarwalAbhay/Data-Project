/* Queries used for Tableaue Visualization */

/* Query 1 */
Select sum(new_cases) AS Total_Cases, sum(new_deaths) AS Total_Deaths, round(sum(new_deaths)/sum(new_cases)*100,2) AS Death_Percentage
FROM coviddeaths
WHERE COALESCE(NULLIF(TRIM(continent), ''), '') <> ''
ORDER BY 1,2

/* Query 2 */
SELECT continent, sum(new_deaths) AS Total_Death_Count
FROM coviddeaths
WHERE COALESCE(NULLIF(TRIM(continent), ''), '') <> ''
GROUP BY continent
ORDER BY Total_Death_Count desc

/* Query 3 */
SELECT location, population, max(total_cases) AS Highest_Infection_Count, (max(total_cases/population))*100 AS Percent_Population_Infected
FROM coviddeaths
GROUP BY location, population
ORDER BY Percent_Population_Infected desc 

/* Query 4 */
SELECT location, population, str_to_date(date, '%d-%m-%Y'), max(total_cases) AS Highest_Infection_Count, max(total_cases/population)*100 AS Percent_Population_Infected
FROM coviddeaths
GROUP BY location, population, str_to_date(date, '%d-%m-%Y')
ORDER BY Percent_Population_Infected desc