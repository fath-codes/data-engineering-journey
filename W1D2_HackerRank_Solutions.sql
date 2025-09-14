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

--5. Query for challange "Placements"
SELECT 
    s.Name
FROM
    Students s
JOIN
    Friends f ON s.ID = f.ID
JOIN
    Packages p1 ON s.ID = p1.ID
JOIN 
    Packages p2 ON Friend_ID = p2.ID
WHERE 
    p2.Salary > p1.Salary
ORDER BY
    p2.Salary ASC

--6 Query for challange "SQL Project Planning"
WITH Project_With_ID AS (
    SELECT 
        Start_Date,
        End_Date,
        DATE_SUB(Start_Date, INTERVAL ROW_NUMBER() OVER(ORDER BY Start_Date) DAY) AS Project_ID
    FROM 
        Projects
)

SELECT 
    MIN(Start_Date),
    MAX(End_Date)
FROM 
    Project_With_ID
GROUP BY 
    Project_ID
ORDER BY 
    DATEDIFF(MAX(End_Date), MIN(Start_Date)),
    Project_ID

--7 Query for challange "Print Prime Numbers"
WITH RECURSIVE Angka(n) AS (
    SELECT 1
    
    UNION ALL
    
    SELECT n + 1 FROM Angka WHERE n < 1000
)

SELECT 
    GROUP_CONCAT(kolom_prima SEPARATOR '&')
FROM (
    SELECT 
        a.n AS kolom_prima
    FROM
        Angka a
    JOIN 
        Angka b ON a.n % b.n = 0
    GROUP BY 
        a.n
    HAVING 
        COUNT(a.n) = 2
    ORDER BY 
        a.n ASC
) AS TabelBilanganPrima

--8 Query for challange "Challenges"
WITH 
    main_table AS (
        SELECT 
            h.hacker_id AS thehacker_id,
            h.name AS hacker_name,
            COUNT(h.hacker_id) AS total_challenges
        FROM
            Hackers h
        JOIN
            Challenges c ON h.hacker_id = c.hacker_id 
        GROUP BY 
            h.hacker_id, h.name
    ),

    challenge_counts AS (
        SELECT
            total_challenges,
            COUNT(*) AS freq
        FROM
            main_table
        GROUP BY 
            total_challenges
    )

SELECT 
    thehacker_id,
    hacker_name,
    total_challenges
FROM 
    main_table
WHERE 
    total_challenges = (SELECT MAX(total_challenges) FROM main_table) 
OR
    total_challenges IN (SELECT total_challenges FROM challenge_counts WHERE freq = 1) 
ORDER BY
    total_challenges DESC, thehacker_id ASC