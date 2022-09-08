select *
from ['Covid deaths$']
where continent is not null
order by 3,4 

--select *
--from ['Covid Vaccinations$']
--order by 3,4 

--select data we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from ['Covid deaths$']
where continent is not null
order by 1,2

--Looking at Total Cases VS Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from ['Covid deaths$']
order by 1,2

--looking at Total Cases VS Population
select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from ['Covid deaths$']
where continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount , MAX((total_cases/population))*100 as PercentPopulationInfected
from ['Covid deaths$']
where continent is not null
group by location, population
order by PercentPopulationInfected desc

--showing countries with the highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from ['Covid deaths$']
where continent is not null
group by location
order by TotalDeathCount desc

--By continent
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from ['Covid deaths$']
where continent is not null
group by continent
order by TotalDeathCount desc

--continents with the highest death count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from ['Covid deaths$']
where continent is not null
group by continent
order by TotalDeathCount desc

--global numbers
select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from ['Covid deaths$']
Where continent is not null
order by 1,2 

--looking at Total Population vs Vaccination

select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from ['Covid deaths$'] as dea
join ['Covid Vaccinations$'] as vac
 on dea.location = vac.location
 and dea.date = vac.date 
 where dea.continent is null
 order by 2,3

--Create View PercentPopulationVaccinated as
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast (vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from ['Covid deaths$'] as dea
join ['Covid Vaccinations$'] as vac
 on dea.location = vac.location
 and dea.date = vac.date 
 where dea.continent is null
 --order by 2,3

 select * 
 from PercentPopulationVaccinated