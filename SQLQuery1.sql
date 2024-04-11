Select * from PortfolioProject..CovidDeaths 


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths 
where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths 
Where location like '%India'
and continent is not null
order by 1,2

-- Looking at total cases vs population
Select Location, date, total_cases, Population, (total_cases / Population) * 100 as CovidPercent
From PortfolioProject..CovidDeaths 
where continent is not null
--Where location like '%India'
order by 1,2

-- Looking at count with highest infection rate compared to population
Select Location, MAX(total_cases) as HighestInfected, Population, MAX((total_cases / Population)) * 100 as HighestPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--Where location like '%India'
Group by Location, Population 
order by HighestPercentage desc


--Looking at count with hihest no. of people died compare to population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCases
From PortfolioProject..CovidDeaths 
where continent is not null
--Where location like '%India'
Group by Location, Population 
order by TotalDeathCases desc


-- Filtering on the basis of continent
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCases
From PortfolioProject..CovidDeaths 
where continent is null
--Where location like '%India'
Group by location 
order by TotalDeathCases desc


-- Global Numbers
Select SUM(new_cases) as NewCases, SUM(cast(new_deaths as int)) as NewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TotalDeathCases
From PortfolioProject..CovidDeaths 
where continent is not null
--and location like '%India'
order by 1,2



Select location,continent, SUM(cast(new_deaths as int)) over (partition by location order by location) as NewDeaths
from PortfolioProject..CovidDeaths 
--where continent is not null
order by 1
--and location like '%India'



-- New Table 
Select * from PortfolioProject..CovidVaccinations


--Join Tables
select dea.continent,dea.location, dea.date,  dea.population,  vac.new_vaccinations 
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
order by 2,3


--Rolling Average for Vaccination
select dea.continent,dea.location, dea.date,  dea.population, 
vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingSUM
from PortfolioProject..CovidDeaths as dea   
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--CTE (common table expression) --> virtual temporary table

With PopvsVac (continent, location, date, population, new_vaccinations,RollingSum)
as
(
select dea.continent,dea.location, dea.date,  dea.population, 
vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingSUM
from PortfolioProject..CovidDeaths as dea   
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
) Select * from PopvsVac