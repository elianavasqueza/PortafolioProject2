SELECT *
FROM PortafolioProject..CovidDeaths
WHERE Continent is not null
Order By 3,4

SELECT *
FROM PortafolioProject..CovidVaccinations
Order By 3,4

--Select 
--From PortafolioPorject..CovidVaccionations
--Order by 3,4

--Select Data that we are going to be using 

SELECT Location, Date, Total_cases, new_cases, total_Deaths, population
FROM PortafolioProject..CovidDeaths
ORDER BY 1,2


-- Look at TOTAL CASES VS TOTAL DEATHS
-- Show likelihood of dying if you contract covid in the states
SELECT Location, Date, Total_cases, total_Deaths, (Total_Deaths/total_cases)*100 as DeathPercentage
FROM PortafolioProject..CovidDeaths
Where Location like '%states%'
Order by 1,2

--Looking at Total Cases vs Population
SELECT Location, Date, Total_cases, population, (Total_cases/population)*100 as PercentPopulationInfected
FROM PortafolioProject..CovidDeaths
Where Location like '%states%'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(Total_Cases) AS HighestInfecctionCount, MAX((Total_cases/population)*100) as PercentPopulationInfected
FROM PortafolioProject..CovidDeaths
--Where Location like '%states%'
GROUP BY population, location
Order by PercentPopulationInfected desc

-- Showing Countries with the Highest DeathCount per Population 

SELECT location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM PortafolioProject..CovidDeaths
--Where Location like '%states%'
WHERE Continent is not null
GROUP BY location
Order by TotalDeathCount desc

-- Lest's Break things down by continent

--Showing Continents with the highest death count per population

SELECT continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM PortafolioProject..CovidDeaths
--Where Location like '%states%'
WHERE continent is not null
GROUP BY continent
Order by TotalDeathCount desc

-- TOTAL Global Numbers

SELECT SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
FROM PortafolioProject..CovidDeaths
--Where Location like '%states%'
WHERE continent is not null
--GROUP BY date
Order by 1,2

--Looking at total population vc vaccinations
--USE CTE
with PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortafolioProject..CovidDeaths dea
JOIN PortafolioProjecT..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
--Order By 1,2,3
)

Select* ,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortafolioProject..CovidDeaths dea
JOIN PortafolioProjecT..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
--WHERE dea.continent is not null
--Order By 1,2,3

Select* ,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualizations
use PortafolioProject
Create View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortafolioProject..CovidDeaths dea
JOIN PortafolioProjecT..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
--Order By 1,2,3

DROP VIEW IF EXISTS PercentPopulationVaccinated;


Select*
From PercentPopulationVaccinated

