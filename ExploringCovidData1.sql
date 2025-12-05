select *
from PortfolioProject..CovidDeaths
where continent is not NULL 
order by 3,4

--select * 
--from CovidVaccinations
--order by 3,4

--select location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths
--order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country 
select location, date, total_cases, total_deaths, (total_deaths * 1.0 / total_cases) * 100 AS DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states' and continent is not NULL 
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
select location, date, population, total_cases, (total_cases * 1.0 / population) * 100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%states'
order by 1,2

-- Looking at Counties with highest infection rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases * 1.0 / population)) * 100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states'
group by location, population
order by PercentPopulationInfected DESC

-- Showing countries with the highest death count per population
select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not NULL 
group by location
order by TotalDeathCount desc

-- Break things down by continent 
-- 

-- Shows total death count of each continent and sorting by highest 
--select location, MAX(total_deaths) as TotalDeathCount
--from PortfolioProject..CovidDeaths
----where location like '%states'
--where continent is  NULL 
--group by location
--order by TotalDeathCount desc

-- Showing continents with the highest death count per population
select continent, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not NULL 
group by continent 
order by TotalDeathCount desc


-- Global daily totals for cases & deaths (daily global trend of COVID spread and fatality)
-- CAST to avoid integer division to ensure decimal accuracy
-- NULLIF prevents divide by 0 and returns null instead of failure
select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(cast(new_deaths as float))/NULLIF(SUM(new_cases), 0)*100 AS DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL 
group by date
order by date

-- Overall global totals for the entire dataset (overall global fatality percentage for the full dataset)
select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(cast(new_deaths as float))/NULLIF(SUM(new_cases), 0)*100 AS DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL 


-- Looking at Total Population vs New Vaccinations per day
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not NULL 
order by 2,3


-- Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not NULL 
--order by 2,3
)

SELECT *,
       (CAST(RollingPeopleVaccinated AS float) / population) * 100 AS PercentVaccinated
FROM PopvsVac;

-- Temp table

DROP Table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not NULL 
order by 2,3

SELECT *,
       (CAST(RollingPeopleVaccinated AS float) / population) * 100 AS PercentVaccinated
FROM #PercentPopulationVaccinated 


-- Creating View to store data for later visualizations in Tableu
USE PortfolioProject
GO
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not NULL 
--order by 2,3


select * 
from PercentPopulationVaccinated

