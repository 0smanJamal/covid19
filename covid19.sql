--portfolio project 



-- covid 19 vaccination and death analysis

-- selecting the data that we are working with


 select location,date,total_cases,new_cases,population,total_deaths from CovidDeaths
 where continent is not null
 order by 2,3


  
  --total deaths VS total cases in saudiarabia
   
   
   
      select location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as deathpercentage from CovidDeaths
       where continent is not null and
         location like '%saudi%'
      order by 1,2

	  --total cases VS population

	    select location,date,(total_cases/population)*100 as PercentPopulationInfected from CovidDeaths
       where continent is not null and
         location like '%saudi%'
      order by 1,2


	  -- country with highest infection rate compared to population

 select location,population, max(total_deaths) as highest_infection_count , Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
Group by Location, Population
   
    --country with highestdeath by population

	select location , max(cast(total_deaths as int))  as totaldeathcount  from CovidDeaths --cast for convert into int
	where continent is not null
	group by location
	order by totaldeathcount
	


	--continent with highestdeath by population 

	select continent ,max(cast(total_deaths as int))  as totaldeathcount from CovidDeaths
	where continent is not null
	group by continent
	order by totaldeathcount

	 

	 --global num


	 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
          From CovidDeaths
	where continent is not null
	order by 1,2



	

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

       Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
       , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
    
       From CovidDeaths dea
      Join CovidVaccinations vac
	  On dea.location = vac.location
	  and dea.date = vac.date
      where dea.continent is not null 
      order by 2,3

    


	     -- Using CTE to perform Calculation on Partition By in previous query

        With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
             as
           (
          Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
             , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

               From CovidDeaths dea
              Join CovidVaccinations vac
	             On dea.location = vac.location
	           and dea.date = vac.date
                where dea.continent is not null 

                            )
               Select *, (RollingPeopleVaccinated/Population)*100
              From PopvsVac

			  -------------------------------------------------------------