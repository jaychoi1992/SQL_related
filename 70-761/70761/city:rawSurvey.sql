/*SIMULATION
You have a table named Cities that has the following two columns: CityID and CityName. The CityID column
uses the int data type, and CityName uses nvarchar(max).
You have a table named RawSurvey. Each row includes an identifier for a question and the number of persons
that responded to that question from each of four cities. The table contains the following representative data:



A reporting table named SurveyReport has the following columns: CityID, QuestionID, and RawCount, where
RawCount is the value from the RawSurvey table.
You need to write a Transact-SQL query to meet the following requirements:
Retrieve data from the RawSurvey table in the format of the SurveyReport table.
The CityID must contain the CityID of the city that was surveyed.
The order of cities in all SELECT queries must match the order in the RawSurvey table.
The order of cities in all IN statements must match the order in the RawSurvey table.
Construct the query using the following guidelines:
Use one-part names to reference tables and columns, except where not possible.
ALL SELECT statements must specify columns.
Do not use column or table aliases, except those provided.
Do not surround object names with square brackets.*/

Declare @temp_cities TABLE(
    cityid INT, cityname NVARCHAR(max));

DECLARE @temp_rawSurvey TABLE (
    Qid nvarchar(2), Tokyo int, Boston int, London int, new_york int);

INSERT INTO @temp_cities VALUES
    (1, 'Tokyo'),(2, 'Boston'),(3, 'London'),(4, 'New York'),(5, 'Seoul')

INSERT INTO @temp_rawSurvey VALUES 
('Q1', 1, 42,48,51), ('Q2', 22, 39, 58, 42), ('Q3', 29, 41,61,33),('Q4', 62, 70, 60, 50),('Q5', 63, 31, 41, 21), ('Q6', 32, 1, 16, 34)


SELECT cityid AS CityID, Qid AS QuestionID, RawCount FROM (
    SELECT Qid, Tokyo, Boston, London, new_york FROM @temp_rawSurvey)t1 
    UNPIVOT (rawcount FOR cityName IN (Tokyo,Boston, London, new_york))t2
    INNER JOIN @temp_cities r ON t2.cityName = r.cityname

