-- In order to clean the data I need to see witch states are listed so they can be properly separated

select location, count (title)
from JobsUSA
where location like '%United States%'
group by location


with CTEname as
(select location, count (title) as num, PARSENAME(replace(location,',','.'),1) as name
from JobsUSA
group by location)

select *
from CTEname
where name not like '%Area%'


select location, count (title) as num
from JobsUSA
where location like '%Area%'
group by location

-- Now when I have explored my location column I can arrange the states and cities into their respected columns

select location, count (title), PARSENAME(replace(location,',','.'),1),
case
when (location = 'Arizona, United States') then ('AZ')
when (location = 'District of Columbia, United States') then ('DC')
when (location = 'Illinois, United States') then('IL')
when (location = 'Indiana, United States') then ('IN')
when (location = 'Maryland, United States') then ('MD')
when (location = 'Michigan, United States') then ('MI')
when (location = 'New Jersey, United States') then ('NJ')
when (location = 'New York, United States') then ('NY')
when (location = 'North Carolina, United States') then ('NC')
when (location = 'Pennsylvania, United States') then ('PA')
when (location = 'Tennessee, United States') then ('TN')
when (location = 'Texas, United States') then ('TX')
when (location = 'Virginia, United States') then ('VA')
when (location = 'Wisconsin, United States') then ('WI')
else location
end as Statealtered
from JobsUSA
group by location

select location , count (title), PARSENAME(replace(location,',','.'),1),
case
when (location = 'Atlanta Metropolitan Area') then ('Atlanta, GA')
when (location = 'Buffalo-Niagara Falls Area') then ('Buffalo, NY')
when (location = 'Charlotte Metro') then ('Charlotte, NC')
when (location = 'Cincinnati Metropolitan Area') then ('Cincinnati, OH')
when (location = 'Dallas-Fort Worth Metroplex') then ('Dallas, TX')
when (location = 'Denver Metropolitan Area') then ('Denver, CO')
when (location = 'Greater Sacramento') then ('Sacramento, CA')
when (location = 'Greater Scranton Area') then ('Scranton, PA')
when (location = 'Greater Tampa Bay Area') then ('Tampa Bay, FL')
when (location = 'Greensboro--Winston-Salem--High Point Area') then ('Greensboro, NC')
when (location = 'Kansas City Metropolitan Area') then ('Kansas City, KS')
when (location = 'Los Angeles Metropolitan Area') then ('Los Angeles, CA')
when (location = 'Nashville Metropolitan Area') then ('Nashville, TN')
when (location = 'New York City Metropolitan Area') then ('New York, NY')
when (location = 'San Francisco Bay Area') then ('San Francisco, CA')
when (location = 'Columbia, South Carolina Metropolitan Area') then ('Columbia, SC')
else location
end
from JobsUSA
group by location

update JobsUSA
set location =
case
when (location = 'Arizona, United States') then ('AZ')
when (location = 'District of Columbia, United States') then ('DC')
when (location = 'Illinois, United States') then('IL')
when (location = 'Indiana, United States') then ('IN')
when (location = 'Maryland, United States') then ('MD')
when (location = 'Michigan, United States') then ('MI')
when (location = 'New Jersey, United States') then ('NJ')
when (location = 'New York, United States') then ('NY')
when (location = 'North Carolina, United States') then ('NC')
when (location = 'Pennsylvania, United States') then ('PA')
when (location = 'Tennessee, United States') then ('TN')
when (location = 'Texas, United States') then ('TX')
when (location = 'Virginia, United States') then ('VA')
when (location = 'Wisconsin, United States') then ('WI')
else location
end

update JobsUSA
set location =
case
when (location = 'Atlanta Metropolitan Area') then ('Atlanta, GA')
when (location = 'Buffalo-Niagara Falls Area') then ('Buffalo, NY')
when (location = 'Charlotte Metro') then ('Charlotte, NC')
when (location = 'Cincinnati Metropolitan Area') then ('Cincinnati, OH')
when (location = 'Dallas-Fort Worth Metroplex') then ('Dallas, TX')
when (location = 'Denver Metropolitan Area') then ('Denver, CO')
when (location = 'Greater Sacramento') then ('Sacramento, CA')
when (location = 'Greater Scranton Area') then ('Scranton, PA')
when (location = 'Greater Tampa Bay Area') then ('Tampa Bay, FL')
when (location = 'Greensboro--Winston-Salem--High Point Area') then ('Greensboro, NC')
when (location = 'Kansas City Metropolitan Area') then ('Kansas City, KS')
when (location = 'Los Angeles Metropolitan Area') then ('Los Angeles, CA')
when (location = 'Nashville Metropolitan Area') then ('Nashville, TN')
when (location = 'New York City Metropolitan Area') then ('New York, NY')
when (location = 'San Francisco Bay Area') then ('San Francisco, CA')
when (location = 'Columbia, South Carolina Metropolitan Area') then ('Columbia, SC')
else location
end


select location, count (title) as NumberOfJobs
from JobsUSA
group by location
order by 1

select count (title), PARSENAME(replace ( location, ',','.' ), 1), location
from JobsUSA
group by location

alter table JobsUSA
add State nvarchar(255)

update JobsUSA
set State =
trim(PARSENAME(replace(location, ',','.'), 1))

select count(title), PARSENAME( replace(location, ',','.'), 2), location
from JobsUSA
group by location

alter table JobsUSA
add City nvarchar(255)

update JobsUSA
set City  =
PARSENAME(replace (location, ',','.'), 2)

select State, City, count(title) as NumberOfJobs
from JobsUSA
where State <> 'United States'
Group by State, City


-- Number of new listing added each day

select count(title) as NumOFJobs,convert(date, posted_date) as Date
from JobsUSA
group by posted_date
order by 2

-- Total number of listing for USA

select count(title) as TotalJobsInUSA
from JobsUSA


-- Number of jobs per location type (onsite/remote/hybrid)

select count (title) as NumberOfJobs, onsite_remote
from JobsUSA
group by onsite_remote

-- Top 15 companies by job posts and count of job location type per company

select top 15 company, count (title) as NumberOfJobs
from JobsUSA
group by company
order by 2 desc

select company, onsite_remote, count (title) as NumberOFJobs
from JobsUSA
group by company, onsite_remote
order by 1

-- Cleaning information in criteria column, and dividing the important info into seperate columns

select count(criteria), criteria
from JobsUSA
where criteria like '%Entry level%'
group by criteria
order by 2 desc


with CTEJob as
(select SUBSTRING(criteria, 3, CHARINDEX('}', criteria)) as JobPosition, title
from JobsUSA
--where criteria like '%Entry Level%'
)

select distinct JobPosition
from CTEJob
group by JobPosition


alter table JobsUSA
add JobPosition nvarchar(255)

update JobsUSA
set JobPosition = SUBSTRING(criteria, 3, CHARINDEX('}', criteria))

select JobPosition
from JobsUSA

select SUBSTRING(criteria, charindex(',', criteria), charindex('}', criteria)), count (title), criteria
from JobsUSA
group by criteria

alter table JobsUSA
add EmploymentType nvarchar(255)

update JobsUSA
set EmploymentType = SUBSTRING(criteria, charindex(',', criteria), charindex('}', criteria))

select distinct EmploymentType
from JobsUSA

select JobPosition, count(title)
from JobsUSA
group by JobPosition

update JobsUSA
set JobPosition =
case
when (JobPosition like '%Volunteer%') then 'Volunteer'
when (JobPosition like '%Mid-Senior level%') then 'Mid-Senior level'
when (JobPosition like '%Not Applicable%') then 'Not Applicable'
when (JobPosition like '%Associate%') then 'Assocate'
when (JobPosition like '%Executive%') then 'Executive'
else JobPosition
end



select criteria, count(title)
from JobsUSA
where criteria like '%Full-time%'
group by criteria

update JobsUSA
set EmploymentType = 
case
when (EmploymentType like '%Full-time%') then 'Full-time'
when (EmploymentType like '%Contract%') then 'Contract'
when (EmploymentType like '%Volunteer%') then 'Volunteer'
when (EmploymentType like'%Temporary%') then 'Temporary'
else EmploymentType
end

-- Vizualization for Tableau

select JobPosition, EmploymentType, State, count(title) as NumberOFJobs
from JobsUSA
Where State <> 'United States'
group by JobPosition, EmploymentType, State
order by 4 desc

select JobPosition, EmploymentType, company, onsite_remote, State, count(title) as NumberOfJobs
from JobsUSA
group by JobPosition, EmploymentType, company, onsite_remote, State
order by 6 desc
