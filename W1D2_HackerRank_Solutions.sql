-- W1D2 Practice SQL for Windows Function and CTE with some Hackerrank Challanges
-- 1. Query for challange "The Report"
SELECT
    CASE
        WHEN g.Grade < 8 THEN 'NULL'
        ELSE s.Name
    END,
    g.Grade,
    s.Marks
FROM
    Students s
JOIN
    Grades g ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY
    g.Grade DESC,
    s.Name ASC;


-- 2. Query for challange "Top Competitors"
SELECT 
    h.hacker_id, 
    h.name
FROM 
    Hackers h
JOIN 
    Submissions s ON h.hacker_id = s.hacker_id
JOIN
    Challenges c ON s.challenge_id = c.challenge_id
JOIN
    Difficulty d ON c.difficulty_level = d.difficulty_level
WHERE 
    s.score = d.score 
GROUP BY 
    h.hacker_id, h.name
HAVING 
    COUNT(c.challenge_id) > 1
ORDER BY 
    COUNT(c.challenge_id) DESC, h.hacker_id ASC; 


-- 3. Query for challange "Occupations"
WITH Occupations_With_Order AS (
    SELECT
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name ASC) AS occupation_order
    FROM 
        Occupations
)

SELECT 
    MIN(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor_Coloumn,
    MIN(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor_Coloumn,
    MIN(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer_Coloumn,
    MIN(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor_Coloumn
FROM 
    Occupations_With_Order
GROUP BY 
    occupation_order
ORDER BY
    occupation_order ASC;


-- 4. Query for challange "Weather Observation Station 20"
WITH Station_With_Order AS (
    SELECT
        LAT_N,
        ROW_NUMBER() OVER(ORDER BY LAT_N ASC) AS latn_order,
        COUNT(*) OVER() AS total_row
    FROM 
        STATION
)

SELECT 
    ROUND(LAT_N, 4)
FROM 
    Station_With_Order 
WHERE
    latn_order = (total_row+1)/2