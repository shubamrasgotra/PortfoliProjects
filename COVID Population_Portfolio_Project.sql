Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

--- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2

--looking at total cases vs total deaths
--Shows the likelihood of dyung if you contract covid in India

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where location like '%India%'
order by 1,3

--Total cases vs the population
--Shows What percentage of people contracted covid


select Location,date,population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
--where location like '%India%'
order by 1,3



--Countries with highest amount of cases


select Location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
--where location like '%India%'
group by Location,population
order by PercentagePopulationInfected DESC

--Showing countries with the highest death counts


Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Breakdown of DeathCount by continent

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
Group by location
order by TotalDeathCount desc

--Global Numbers	
Select SUM(new_cases) AS TotalInfectedPeople,SUM(cast(new_deaths as int)) TotalDeaths,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as TotalDeathPercentage
from PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL

--Looking at total vaccinations vs total cases	
Select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int))
over(partition by dea.location) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100 as VaccinatedPercentage
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Using CTE to perform calculation on the previous Partition query



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Create View For storing date for visualations in dashboards like Tableau and PowerBI
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 













 










