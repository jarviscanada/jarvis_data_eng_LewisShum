-- Q1
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Q2
INSERT INTO cd.facilities
VALUES ((SELECT MAX(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800);

-- Q3
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

-- Q4
UPDATE cd.facilities
SET membercost = (SELECT membercost
                  FROM cd.facilities
                  WHERE name = 'Tennis Court 1') * 1.1,
    guestcost = (SELECT guestcost
                 FROM cd.facilities
                 WHERE name = 'Tennis Court 1') * 1.1
WHERE name = 'Tennis Court 2';

--Q5
DELETE FROM cd.bookings;

--Q6
DELETE FROM cd.members WHERE memid = 37;

--Q7
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND membercost < facilities.monthlymaintenance / 50;

--Q8
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

--Q9
SELECT *
FROM cd.facilities
WHERE facid = 1 OR facid = 5;

--Q10
SELECT memid, surname, firstname, joindate
FROM members
WHERE joindate >= '2012-09-01';

--Q11
SELECT surname FROM cd.members
UNION
SELECT name FROM facilities;

--Q12
SELECT starttime FROM cd.bookings AS B
JOIN cd.members AS M ON B.memid = M.memid
WHERE M.firstname = 'David' AND M.surname = 'Farrell';

--Q13
SELECT B.starttime, F.name FROM cd.bookings AS B
JOIN cd.facilities AS F ON F.facid = B.facid
WHERE F.name LIKE '%Tennis%'
ORDER BY B.starttime;

--Q14
SELECT A.firstname AS memfname, A.surname AS memsname, B.firstname AS recfname, B.surname AS recsname FROM members AS A
LEFT JOIN members AS B ON A.recommendedby = B.memid
ORDER BY A.surname, A.firstname;

--Q15
SELECT DISTINCT B.firstname, B.surname FROM members AS A
JOIN members AS B ON A.recommendedby = B.memid
ORDER BY B.surname, B.firstname;

--Q16
SELECT DISTINCT CONCAT(firstname, ' ', surname) AS member,
(
    SELECT CONCAT(firstname, ' ', surname) AS recommender
    FROM members AS B
    WHERE A.recommendedby = B.memid
)
FROM members AS A
ORDER BY member;

--Q17
SELECT recommendedby, COUNT(*) FROM members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

--Q18
SELECT facid, SUM(slots) AS "Total Slots" FROM bookings
GROUP BY facid
ORDER BY facid;

--Q19
SELECT facid, SUM(slots) AS "Total Slots" FROM bookings
WHERE starttime >= '2012-09-01' AND starttime <'2012-10-01'
GROUP BY facid
ORDER BY SUM(slots);

--Q20
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) FROM bookings
WHERE starttime >= '2012-01-01' AND starttime <'2013-01-01'
GROUP BY facid, month
ORDER BY facid, month;

--Q21
SELECT COUNT(DISTINCT memid) FROM bookings;

--Q22
SELECT M.surname, M.firstname, M.memid, MIN(B.starttime) AS starttime
FROM bookings B
JOIN members M ON M.memid = B.memid
WHERE B.starttime >= '2012-09-01'
GROUP BY M.surname, M.firstname, M.memid
ORDER BY M.memid;

--Q23
SELECT
    (SELECT COUNT(*) FROM members),
    firstname,
    surname
FROM members
ORDER BY joindate;

--Q24
SELECT
    ROW_NUMBER() OVER (ORDER BY joindate),
    firstname,
    surname
FROM cd.members
ORDER BY joindate;

--Q25
SELECT facid, SUM(slots) AS total FROM bookings
GROUP BY facid
ORDER BY SUM(slots) DESC
LIMIT 1;

--Q26
SELECT CONCAT(surname, ', ', firstname) AS name FROM members;

--Q27
SELECT memid, telephone FROM members
WHERE telephone LIKE '%(%)%'
ORDER BY memid;

--Q28
SELECT SUBSTR(surname, 1, 1) AS letter, COUNT(*) FROM members
GROUP BY SUBSTR(surname, 1, 1)
ORDER BY SUBSTR(surname, 1, 1);

SELECT * FROM members