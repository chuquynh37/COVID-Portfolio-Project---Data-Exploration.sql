/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
SELECT * FROM covid_deaths
WHERE NOT continent = ''
ORDER BY 3,4;


-- Select Data that we are going to be starting with

SELECT location, date, total_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percent 
FROM covid_deaths
WHERE location LIKE '%Vietnam%' AND NOT continent = ''
ORDER BY 6 DESC;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases, population,
(total_cases/ population)*100 as cases_percent 
FROM covid_deaths
WHERE location LIKE '%Vietnam%' AND NOT continent = ''
ORDER BY 2 ;


-- Countries with Highest Infection Rate compared to Population

SELECT location,population , MAX(total_cases) as infection_count,
Max((total_cases/population))*100 as percent_population_Infected
FROM covid_deaths
GROUP BY location,population 
ORDER BY 2 DESC;


-- Countries with Highest Death Count per Population

SELECT location ,MAX(total_deaths) as deaths_count,
Max((total_deaths/population))*100 as percent_population_deaths
FROM covid_deaths
GROUP BY location
ORDER BY 2 DESC;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(total_deaths)as death_count,MAX(total_deaths/population) as percent_population_deaths
FROM covid_deaths
WHERE NOT  continent = ''
GROUP BY continent
ORDER BY 3;

-- GLOBAL NUMBERS

SELECT DATE, SUM(new_cases) as total_cases, 
SUM(new_deaths) as total_deaths, SUM(new_deaths )/SUM(New_Cases)*100 as DeathPercentage
FROM covid_deaths
-- Where location like '%vietnam%'
where not continent =''
Group By date
order by 1,2 ;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

 SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
AS RollingPeopleVaccinated  -- (RollingPeopleVaccinated/population)*100
FROM covid_deaths dea
JOIN covid_vaccination vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY  2,3;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS popvsvac;
CREATE TABLE popvsvac 
AS 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccination vac ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null );
-- Creating View to store data for later visualizations

DROP TABLE IF EXISTS popvsvac;
CREATE VIEW popvsvac 
AS 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccination vac ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null )






       
