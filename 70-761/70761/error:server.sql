DECLARE @servers TABLE (

serverid int,
dns nvarchar(100)    
)
DECLARE @errors TABLE (

    errorid int,
    serverid int, 
    occurrences int,
    logmessage nvarchar(max)
)
INSERT INTO @servers 
VALUES (1, 'a'),(2, 'b'),(3, 'c'), (4, 'd')

INSERT INTO @errors 
VALUES (1, 1, 66, 'error1'),(2, 1, 3, 'error2'),(3, 3, 11, 'error3'),(4, 2, 1, 'error4'),(5, 3, 5, 'error5'),(6, 2, 99, 'error6'),(7, 1, 99, 'error7'), (1, 2, 67, 'error1'), (8,4,4,'error8')

--My solution
SELECT DISTINCT logmessage, t1.serverid FROM @errors e1 CROSS APPLY (SELECT TOP 1 serverid FROM @errors e2 WHERE e1.errorid = e2.errorid ORDER BY occurrences DESC)t1

--A) : ANSWER
Print('A')
SELECT DISTINCT serverid, logmessage FROM @errors as e1 WHERE occurrences > 
ALL(SELECT e2.occurrences FROM @errors as e2 where e2.logmessage = e1.logmessage AND e2.serverid <> e1.serverid)
-- > all (subquery) means The values in column c must greater than the biggest value in the set to evaluate to true.
-- A correlated subquery, however, executes once for each candidate row considered by the outer query. In other words, the inner query is driven by the outer query.

--B) 
Print('B')
SELECT DISTINCT serverid, logmessage FROM @errors e1 GROUP BY serverid, logmessage HAVING MAX(occurrences) =1

--C)
Print('C')
SELECT DISTINCT serverid, logmessage FROM @errors e1
WHERE logmessage IN (SELECT TOP 1 e2.logmessage FROM @errors e2 WHERE e2.logmessage = e1.logmessage AND e2.serverid <> e1.serverid ORDER BY e2.occurrences)

--D)
Print('D')
SELECT serverid, logmessage FROM @errors e1 GROUP BY serverid, logmessage, occurrences HAVING COUNT(*) = 1 ORDER BY occurrences
-- only one logmessage should printed