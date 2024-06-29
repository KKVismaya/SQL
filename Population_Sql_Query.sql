SELECT * FROM Population.dbo.data1
SELECT * FROM Population.dbo.data2

--Total rows in data1
SELECT COUNT(*) FROM Population..data1

--Total rows in data2
SELECT COUNT(*) FROM Population..data2

--Dataset for TamilNadu and Kerala
SELECT * FROM Population..data1 WHERE State = 'Tamil Nadu' OR State = 'Kerala'
SELECT * FROM Population..data1 WHERE State IN ('Tamil Nadu','Kerala')

--Total population of India
SELECT SUM(Population) AS Total_Population FROM Population..data2

--Average growth rate 
SELECT AVG(Growth)*100 AS Avg_Growth FROM Population..data1

--Average growth rate of each state
SELECT State,AVG(Growth)*100 AS Avg_Growth_State FROM Population..data1 GROUP BY Population..data1.State

--Average sex ratio of each state
SELECT State,ROUND(AVG(Sex_Ratio),0) AS Avg_SexRatio_State FROM Population..data1 GROUP BY State ORDER BY Avg_SexRatio_State DESC

--Average literacy rate of each state
SELECT State,ROUND(AVG(Literacy),0) AS Avg_Literacy_State FROM Population..data1 GROUP BY State ORDER BY Avg_Literacy_State DESC

--Average literacy rate of states having average literacy rate greater than 90
SELECT State,ROUND(AVG(Literacy),0) AS Avg_Literacy_State FROM Population..data1 GROUP BY State having round(AVG(Literacy),0) > 90 ORDER BY Avg_Literacy_State DESC

--Top 3 states with highest average sex ratio
SELECT TOP 3 State,ROUND(AVG(Sex_Ratio),0) AS Avg_SexRatio_State FROM Population..data1 GROUP BY State ORDER BY Avg_SexRatio_State DESC

--Top 3 states with lowest sex ratio
SELECT TOP 3 State,round(AVG(Sex_Ratio),0) AS Avg_SexRatio_State FROM Population..data1 GROUP BY State ORDER BY Avg_SexRatio_State ASC

CREATE TABLE #topstates
	(State nvarchar(255),
	 topstate float)
Insert into #topstates
SELECT ROUND(AVG(Literacy),0) AS Avg_Literacy_State FROM Population..data1 GROUP BY State ORDER BY Avg_Literacy_State DESC
	SELECT TOP 3 * FROM #topstates ORDER BY #topstates.topstate DESC

--States starting with letter 'a'
SELECT DISTINCT State FROM Population..data1 WHERE State LIKE 'A%' OR State LIKE 'B%';

--States ending with letter 'a' or 'b'
SELECT DISTINCT State FROM Population..data1 WHERE State LIKE '%A' OR State LIKE '%B';

--Joining both tables
SELECT a.District, a.State, a.Sex_Ratio, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District

--Finding out District wise Male and Female Population
SELECT c.State, c.District, c.Population, ROUND(c.population/(c.Sex_Ratio + 1),0) Males, ROUND((c.Population*c.Sex_Ratio)/(c.Sex_Ratio + 1),0) Females FROM 
(SELECT a.District, a.State, a.Sex_Ratio/1000 Sex_Ratio, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District)c

--Finding out District wise Male and Female Population
SELECT d.State, SUM(d.Population) Population, SUM(d.males) Total_Males, SUM(d.females) Total_Females FROM
(SELECT c.State, c.District, c.Population, ROUND(c.population/(c.Sex_Ratio + 1),0) Males, ROUND((c.Population*c.Sex_Ratio)/(c.Sex_Ratio + 1),0) Females FROM 
(SELECT a.District, a.State, a.Sex_Ratio/1000 Sex_Ratio, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District)c) d
GROUP BY d.State

--Finding out total number of literate and illiterate people
SELECT c.District, c.State, c.population, ROUND(c.Literacy_Ratio*c.Population,0) Literate_People,ROUND((1-c.Literacy_Ratio)*c.Population,0) Illiterate_People FROM
(SELECT a.District, a.State, a.Literacy/100 Literacy_Ratio, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District)c;

--Population in Previous Census VS Current Census State wise
SELECT d.State, SUM(d.Current_Census_Population) Current_Census_Population, SUM(d.Previous_Census_Population) Previous_Census_Population FROM
(SELECT c.District, c.State, c.Population Current_Census_Population, ROUND(c.Population/(1 + c.Growth),0) Previous_Census_Population FROM 
(SELECT a.District, a.State, a.Growth, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District)c)d 
GROUP BY d.State

--Population in Previous Census VS Current Census
SELECT SUM(e.Current_Census_Population) Current_Census_Population, SUM(Previous_Census_Population) Previous_Census_Population FROM 
(SELECT d.State, SUM(d.Current_Census_Population) Current_Census_Population, SUM(d.Previous_Census_Population) Previous_Census_Population FROM
(SELECT c.District, c.State, c.Population Current_Census_Population, ROUND(c.Population/(1 + c.Growth),0) Previous_Census_Population FROM 
(SELECT a.District, a.State, a.Growth, b.Population from Population..data1 a JOIN Population..data2 b ON a.District = b.District)c)d 
GROUP BY d.State)e

