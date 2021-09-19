--COVID 19 WORLD DATA EXPLORATION IN SQL

Select * FROM CovidDeaths  where continent is not NULL order by 3,4

--Select * FROM CovidVaccinations order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From DEProject..CovidDeaths order by 1,2


-- Total Cases vs Total Deaths (chances of dying by COVID)
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From DEProject..CovidDeaths where continent is NOT NULL order by 1,2


--Total Cases vs population (Percentage got affected by covid)
Select location, date, Population, total_cases,   (total_cases/population)*100 as PercentagePopulationInfected
From DEProject..CovidDeaths order by 1,2


--Countries with highest infection rate compared to Population
Select location, Population, MAX(total_cases) as HighestInfection, MAX((total_cases/population)*100 )as PercentagePopulationInfected
From DEProject..CovidDeaths  Group by location, Population 
order by PercentagePopulationInfected desc

--Countries with highest death count
Select location , continent,  MAX(cast(total_deaths as int)) as TotaldeathCount
From DEProject..CovidDeaths where continent is NOT null  Group by location , continent
order by TotaldeathCount desc

--CONTINENT

--Continents with highest death count
Select continent, SUM(cast(new_deaths as int)) as TotalDeathCount
From DEProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

--Total deaths vs total cases
Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_deaths ,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From DEProject..CovidDeaths where continent is NOT NULL 
--Group by date 
order by 1,2



--VACCINATION
 
 Drop Table if exists PopulationVsVaccination 
 Create Table PopulationVsVaccination 
 (Continent nvarchar(255), 
 Location nvarchar(255), 
 date datetime,
 population numeric,
 New_Vaccination numeric, 
 RollingPeopleVaccinated numeric
 ) 
 Insert into PopulationVsVaccination 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From DEProject..CovidDeaths dea Join
 DEProject..CovidVaccinations vac 
 on dea.location= vac.location
 and dea.date=vac.date
 where dea.continent is NOT NULL
 --order by 2,3
 
 --Percentage people Vaccinated
 Select *, RollingPeopleVaccinated/Population *100 From PopulationVsVaccination

 
--DATA FOR LATER VISUALIZATION


 Create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 From DEProject..CovidDeaths dea Join
 DEProject..CovidVaccinations vac 
 on dea.location= vac.location
 and dea.date=vac.date
 where dea.continent is NOT NULL
 --order by 2,3
