/* Selection of dataset to be used */

Select location, str_to_date(date, '%d-%m-%Y'), total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2

/* Total Cases vs Tptal Deaths */
/* Shows the likelihood of dying in a specific country*/
Select location, max(total_cases), max(total_deaths), round(max(total_deaths)/max(total_cases)*100,2) As deathpercentage
from coviddeaths
group by location
order by deathpercentage

/* Total Cases vs Population */
Select location, str_to_date(date, '%d-%m-%Y'), population, total_cases, (total_cases/population)*100 AS casepercentage
from coviddeaths
where continent is not null
order by 1,2

/* Countries with Highest Infection Rate wrt Population */
Select location, population, max(total_cases) AS Highest_Infection_Count, round((max(total_cases)/population)*100,2) AS Infection_Percentage
FROM coviddeaths
where continent is not null
GROUP BY location, population
ORDER BY Infection_Percentage desc

/* Countries with Highest Death Count per Population */
Select location, population, max(total_deaths) AS Highest_Deaths_Count, round((max(total_deaths)/population)*100,2) AS Death_Percentage
FROM coviddeaths
where continent is not null
GROUP BY location, population
ORDER BY Death_Percentage desc

/* Shoowing Continent level breakup */
Select continent, population, max(cast(total_deaths AS SIGNED)) AS Highest_Deaths_Count
FROM coviddeaths
Where continent is not null
GROUP BY continent 
ORDER BY Highest_Deaths_Count desc

/* Looking at Total Population vs Vaccinations */
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM coviddeaths cd
JOIN covidvaccinations cv 
	ON cd.location = cv.location AND cd.date = cv.date
where cd.continent is not null
ORDER BY 1,2,3

/* Using CTE */
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
As
(
SELECT cd.continent, cd.location, str_to_date(cd.date, '%d-%m-%Y'), cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) OVER (Partition BY cd.location Order By cd.location, str_to_date(cd.date, '%d-%m-%Y')) As RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv 
	ON cd.location = cv.location AND cd.date = cv.date
where COALESCE(NULLIF(TRIM(cd.continent), ''), '') <> ''
ORDER BY 2,3
)
SELECT *
FROM PopvsVac

DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
/* Creating Temp Table */
CREATE TEMPORARY TABLE PercentPopulationVaccinated AS 
SELECT cd.continent, cd.location, str_to_date(cd.date, '%d-%m-%Y') AS Datedata, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) OVER (Partition BY cd.location Order By cd.location, str_to_date(cd.date, '%d-%m-%Y')) As RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv 
	ON cd.location = cv.location AND cd.date = cv.date
where COALESCE(NULLIF(TRIM(cd.continent), ''), '') <> ''
ORDER BY 2,3;

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated

Create View Percent_Population_Vaccinated AS
SELECT cd.continent, cd.location, str_to_date(cd.date, '%d-%m-%Y'), cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) OVER (Partition BY cd.location Order By cd.location, str_to_date(cd.date, '%d-%m-%Y')) As RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv 
	ON cd.location = cv.location AND cd.date = cv.date
where COALESCE(NULLIF(TRIM(cd.continent), ''), '') <> ''
ORDER BY 2,3
percent_population_vaccinated