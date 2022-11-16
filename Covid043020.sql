Select * 
From PortfolioProject01. .CovidDeaths
where continent is not null
order by 3,4

--Select * 
--From PortfolioProject01. .CovidVaccinations
--order by 3,4

--Select Date that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject01. .CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject01. .CovidDeaths
Where location like '%Philippines%'
where continent is not null
order by 1,2

--Looking at the Total Cases vs Population
--Shows what percentage of population got covid
Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject01. .CovidDeaths
Where location like '%Philippines%'
where continent is not null
order by 1,2

--Looking at Countries with Highest infection Rate compared to Population
Select Location, Population, Max(total_cases)as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject01. .CovidDeaths
--Where location like '%Philippines%'
Group by Location, population
where continent is not null
order by PercentPopulationInfected desc

--Showing Countries with highest Death Count per Population
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject01. .CovidDeaths
--Where location like '%Philippines%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--Let's BREAK THINGS DOWN BY CONTINENT
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject01. .CovidDeaths
--Where location like '%Philippines%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
Select Sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject01. .CovidDeaths
--Where location like '%Philippines%'
where continent is not null
--group by date
order by 1,2


---Looking at the Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 ---(RollingPeopleVaccinated/population)*100
From PortfolioProject01. .CovidDeaths dea
Join PortfolioProject01. .CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 1,2

--use CTE
With PopvsVac (continent, location, Date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 ---(RollingPeopleVaccinated/population)*100
From PortfolioProject01. .CovidDeaths dea
Join PortfolioProject01. .CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 1,2
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac





--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 ---(RollingPeopleVaccinated/population)*100
From PortfolioProject01. .CovidDeaths dea
Join PortfolioProject01. .CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
order by 1,2

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


---creating View to store data for later visualization
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 ---(RollingPeopleVaccinated/population)*100
From PortfolioProject01. .CovidDeaths dea
Join PortfolioProject01. .CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 1,2

Select 
from PercentPopulationVaccinated