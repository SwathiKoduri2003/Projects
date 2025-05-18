--1
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths
order by 1,2

--2
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where location = 'India'
order by 1,2

--3
Select location, date, total_cases, population, (total_cases/population)*100 AS PopulationPercentage
From PortfolioProject.dbo.CovidDeaths
where location = 'India'
order by 1,2

--4
SELECT location, SUM(total_cases) as Total
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'India'
GROUP BY location

--5
Select location, max(total_cases) as HighestNoOfCases
From PortfolioProject.dbo.CovidDeaths
where location <> 'world'
Group By location 
Order By HighestNoOfCases DESC

--6
Select continent, date, COUNT(new_cases) as NewCases
From PortfolioProject.dbo.CovidDeaths
Group By continent, date
having Count(new_cases) = 0
Order by NewCases, continent

--7
Select*
From PortfolioProject.dbo.CovidDeaths as cd
Join PortfolioProject.dbo.CovidVaccinations as cv
ON cd.date= cv.date and cd.location= cv.location

--8
Select cd.continent,cd.location,cd.date, cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as TotalOfNewVaccinations
From PortfolioProject.dbo.CovidDeaths as cd
Join PortfolioProject.dbo.CovidVaccinations as cv
  ON cd.date= cv.date and cd.location= cv.location
where cd.continent is not null
order by location, date

--9
With VaccPop (continent,location,date,population, new_vaccinations,TotalOfNewVaccinations) 
as
(
Select cd.continent,cd.location,cd.date, cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as TotalOfNewVaccinations
From PortfolioProject.dbo.CovidDeaths as cd
Join PortfolioProject.dbo.CovidVaccinations as cv
  ON cd.date= cv.date and cd.location= cv.location
where cd.continent is not null
)
Select *, (TotalOfNewVaccinations/population)*100 As PopulationPercentage
From VaccPop

--10
drop table if exists #VaccinatedPopulation
create table #VaccinatedPopulation
(
Continent nvarchar(200),
Location nvarchar(200),
Date datetime,
Population numeric,
New_Vaccinations numeric,
TotalOfNewVaccinations numeric
)

insert into #VaccinatedPopulation
Select cd.continent,cd.location,cd.date, cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as TotalOfNewVaccinations
From PortfolioProject.dbo.CovidDeaths as cd
Join PortfolioProject.dbo.CovidVaccinations as cv
  ON cd.date= cv.date and cd.location= cv.location
where cd.continent is not null

Select *, (TotalOfNewVaccinations/population)*100 As PopulationPercentage
From #VaccinatedPopulation

--11
create View populationthatsvaccinated as
Select cd.continent,cd.location,cd.date, cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as TotalOfNewVaccinations
From PortfolioProject.dbo.CovidDeaths as cd
Join PortfolioProject.dbo.CovidVaccinations as cv
  ON cd.date= cv.date and cd.location= cv.location
where cd.continent is not null

select *
from populationthatsvaccinated
