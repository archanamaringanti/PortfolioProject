SELECT * FROM CovidDeaths
ORDER BY 3, 4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location like '%india%'
ORDER BY 1, 2

SELECT location, date, total_cases, population, (total_cases/population)*100 AS CasesPercentage
FROM CovidDeaths
WHERE location like '%india%'
ORDER BY 1, 2

SELECT location, population, MAX(total_cases) AS HighInfectionCount, max((total_cases/population))*100 AS CasesPercentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY CasesPercentage desc

SELECT continent, location, MAX(CAST(total_deaths AS int)) AS HighDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY continent, location

SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT  SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths as int)) AS Total_Deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases) *100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is NOT NULL
--GROUP BY date
ORDER BY 1, 2

SELECT * FROM CovidVaccinations


WITH PopvsVac (Continent, Location, Date, Popuplation, New_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
)

SELECT * FROM PopvsVac

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * FROM PercentPopulationVaccinated


