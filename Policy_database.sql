CREATE DATABASE policy_db;
USE policy_db;
SHOW TABLES;
SELECT * FROM payment_history;
SELECT * FROM customer_information;
SELECT * FROM claims;
SELECT * FROM additional_fields;
SELECT * FROM policy_details;

-- TOTAL POLICY --
SELECT COUNT(DISTINCT `Policy ID`) AS total_policy FROM policy_details;

-- TOTAL CUSTOMERS --
SELECT COUNT(DISTINCT `Customer ID`) AS total_customers FROM customer_information;

-- AGE BUCKET WISE POLICY COUNT --
SELECT * FROM customer_information;

ALTER TABLE customer_information
ADD age_bucket VARCHAR(10);

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_information
SET age_bucket =
    CASE
        WHEN age BETWEEN 18 AND 19 THEN '18-19'
        WHEN age BETWEEN 20 AND 30 THEN '20-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        WHEN age BETWEEN 71 AND 85 THEN '71-85'
    END;
    
SELECT c.age_bucket,COUNT(p.`Policy ID`) AS policy_count
FROM policy_details p
JOIN customer_information c
ON p.`Customer ID` = c.`Customer ID`
GROUP BY c.age_bucket
ORDER BY c.age_bucket;

-- GENDER WISE POLICY COUNT --
SELECT c.gender,COUNT(p.`Policy ID`) AS policy_count
FROM policy_details p
JOIN customer_information c
ON p.`Customer ID` = c.`Customer ID`
GROUP BY c.gender
ORDER BY policy_count DESC;

-- POLICY TYPE WISE POLICY COUNT --
SELECT `policy type`,COUNT(*) AS policy_count
FROM policy_details
GROUP BY `policy type`
ORDER BY policy_count DESC;

-- POLICY EXPIRE THIS YEAR --
SELECT COUNT(*) AS policy_count FROM policy_details
WHERE YEAR(`Policy End Date`) = YEAR(CURDATE());

-- CLAIM STATUS WISE POLICY COUNT --
SELECT `Claim Status`,COUNT(*) AS policy_count FROM claims
GROUP BY `Claim Status`
ORDER BY policy_count DESC;

-- PAYMENT STATUS WISE POLICY COUNT --
SELECT `Payment Status`,COUNT(*) AS policy_count FROM payment_history
GROUP BY `Payment STATUS`
ORDER BY policy_count DESC;

-- TOTAL CLAIM AMOUNT -- 
SELECT SUM(`Claim Amount`) AS total_claim_amount FROM claims;

-- PREMIUM GROWTH PERCENTAGE --
CREATE TABLE premium_growth (
    policy_year INT PRIMARY KEY,
    current_year_premium DECIMAL(18,2),
    previous_year_premium DECIMAL(18,2),
    premium_growth_rate DECIMAL(10,2)
);

INSERT INTO premium_growth (
    policy_year,
    current_year_premium,
    previous_year_premium,
    premium_growth_rate
)
SELECT curr.policy_year,curr.total_premium AS current_year_premium,prev.total_premium AS previous_year_premium,
    ROUND(((curr.total_premium - prev.total_premium)/ prev.total_premium) * 100,2) AS premium_growth_rate
FROM
(SELECT YEAR(`Policy Start Date`) AS policy_year,SUM(`Premium Amount`) AS total_premium
FROM policy_details
GROUP BY policy_year
) AS curr
LEFT JOIN
(SELECT YEAR(`Policy Start Date`) + 1 AS policy_year,SUM(`Premium Amount`) AS total_premium
FROM policy_details
GROUP BY policy_year
) AS prev
ON curr.policy_year = prev.policy_year;

SELECT * FROM premium_growth;