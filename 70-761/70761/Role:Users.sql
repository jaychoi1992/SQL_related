/* 
Q1)
A value of 1 in the IsActive column indicates that a user is active.
You need to create a count for active users in each role. If a role has no active users. You must display a zero
as the active users count.
Which Transact-SQL statement should you run?
*/

CREATE TABLE tblRoles (

    RoleID INT NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    RoleName Varchar(20) NOT NULL
)

CREATE TABLE tblUsers (

    UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    UserName varchar(20) UNIQUE NOT NULL,
    RoleID int NULL FOREIGN KEY REFERENCES tblRoles(RoleID),
    IsActive bit NOT NULL DEFAULT(1)
)
INSERT INTO tblRoles VALUES('student'),('teacher'),('Acter'),('Blacksmith'),('Police') 
INSERT INTO tblUsers VALUES ('A',1,1),('B',2,1),('C',3,0),
('D',4,1),('E',2,1),('F',3,1),('G',1,0),('H',1,1),('K',2,0),('I',5, 0)

--My solution
SELECT r.RoleID, Count(u.UserID) AS 'number' FROM (SELECT * FROM tblUsers WHERE IsActive = 1) u INNER JOIN tblRoles r ON u.RoleID = r.RoleID 
GROUP BY r.RoleID
-- cannot catch if specific role don't have any active user

--2nd Solution
SELECT r.RoleName, Sum(CAST(u.IsActive As INT)) AS 'Number of Active User' FROM tblUsers u INNER JOIN tblRoles r ON u.RoleID = r.RoleID GROUP BY r.RoleName 

SELECT r.RoleName, Sum(CAST(u.IsActive As INT)) AS 'Number of Active User' FROM tblUsers u INNER JOIN tblRoles r ON u.RoleID = r.RoleID GROUP BY r.RoleName 

--What if I cannot just sum up, for example I need to get number of japanese in role?
SELECT r.RoleName, count(UserID) AS 'Number of Active User' FROM (SELECT * FROM tblUsers WHERE IsActive = 1) u RIGHT JOIN tblRoles r ON u.RoleID = r.RoleID 
GROUP BY r.RoleName HAVING
--A)
SELECT R.RoleName, COUNT(*) AS ActiveUserCount FROM tblRoles R CROSS JOIN (SELECT UserId,
RoleId FROM tblUsers WHERE IsActive = 1) U WHERE U.RoleId = R.RoleId GROUP BY R.RoleId,
R.RoleName
-- cannot catch if specific role don't have any active user

--B)
SELECT R.RoleName, COUNT(*) AS ActiveUserCount FROM tblRoles R LEFT JOIN (SELECT UserId,
RoleId FROM tblUsers WHERE IsActive = 1) U ON U.RoleId = R.RoleId GROUP BY R.RoleId, R.RoleName
-- cannot display 0 evenif role doesn't have active user

--C)
SELECT R.RoleName, U.ActiveUserCount FROM tblRoles R CROSS JOIN(SELECT RoleId, COUNT(*) AS
ActiveUserCount FROM tblUsers WHERE IsActive = 1 GROUP BY RoleId ) U 

--D)
SELECT R.RoleName, ISNULL (U.ActiveUserCount,0) AS ActiveUserCount FROM tblRoles R LEFT JOIN
(SELECT RoleId, COUNT(*) AS ActiveUserCount FROM tblUsers WHERE IsActive = 1 GROUP BY
RoleId) U ON R.RoleID = U.RoleID
--Correct Answer