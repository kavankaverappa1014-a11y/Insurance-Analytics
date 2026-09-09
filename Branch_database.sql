CREATE DATABASE branch_db;
USE branch_db;
SELECT * FROM brokerage;
SELECT * FROM fees;
SELECT * FROM individual_budget;
SELECT * FROM invoice;
SELECT * FROM meeting;
SELECT * FROM opportunity;

-- NO. OF INVOICE BY ACCOUNT EXECUTIVE --
SELECT `Account Executive`,COUNT(invoice_number) AS no_of_invoice FROM invoice
GROUP BY `Account Executive`
ORDER BY no_of_invoice DESC;

-- YEARLY MEETING COUNT --
SELECT YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y'))AS year,COUNT(*) AS meeting_count FROM meeting
GROUP BY year
ORDER BY meeting_count DESC;

-- total achivement table --
CREATE TABLE Achievement AS
SELECT income_class,SUM(Amount) AS total_amount FROM
(SELECT income_class,Amount FROM brokerage
UNION ALL
SELECT income_class,Amount FROM fees)
AS brokerage_fees
WHERE income_class IN ('Cross sell','New','Renewal') 
GROUP BY income_class 
ORDER BY income_class;

SELECT * FROM achievement;

-- CROSS SELL PLACED ACHIEVED % --
SELECT
CONCAT(ROUND((
(SELECT SUM(total_amount) FROM achievement WHERE income_class="Cross Sell")/
(SELECT SUM(`Cross sell bugdet`) FROM individual_budget)
)*100,2),'%'
) AS cross_sell_achievement;

-- CROSS SELL INVOICE % --
SELECT
CONCAT(ROUND((
(SELECT SUM(Amount) FROM invoice WHERE income_class="Cross sell")/
(SELECT SUM(`Cross sell bugdet`) FROM individual_budget)
)*100,2),'%'
) AS cross_sell_invoice;


-- CROSS SELL --
SELECT
(SELECT SUM(`Cross sell bugdet`) FROM individual_budget) AS Target,
(SELECT SUM(total_amount) FROM achievement WHERE income_class="Cross sell") AS Achievement,
(SELECT SUM(Amount) FROM invoice WHERE income_class="Cross sell") AS Invoice;


-- NEW PLACED ACHIEVED % --
SELECT
CONCAT(ROUND((
(SELECT SUM(total_amount) FROM achievement WHERE income_class="New")/
(SELECT SUM(`New Budget`) FROM individual_budget)
)*100,2),'%'
) AS new_achievement;

-- NEW INVOICE % --
SELECT
CONCAT(ROUND((
(SELECT SUM(Amount) FROM invoice WHERE income_class="New")/
(SELECT SUM(`New Budget`) FROM individual_budget)
)*100,2),'%'
) AS new_invoice;

-- NEW --
SELECT
(SELECT SUM(`New Budget`) FROM individual_budget) AS Target,
(SELECT SUM(total_amount) FROM achievement WHERE income_class="New") AS Achievement,
(SELECT SUM(Amount) FROM invoice WHERE income_class="New") AS Invoice;

-- RENEWAL PLACED ACHIEVED % --
SELECT
CONCAT(ROUND((
(SELECT SUM(total_amount) FROM achievement WHERE income_class="Renewal")/
(SELECT SUM(`Renewal Budget`) FROM individual_budget)
)*100,2),'%'
) AS renewal_achivement;

-- RENEWAL INVOICE % --
SELECT
CONCAT(ROUND((
(SELECT SUM(Amount) FROM invoice WHERE income_class="Renewal")/
(SELECT SUM(`Renewal Budget`) FROM individual_budget)
)*100,2),'%'
) AS renewal_invoice;

-- RENEWAL--
SELECT
(SELECT SUM(`Renewal Budget`) FROM individual_budget) AS Target,
(SELECT SUM(total_amount) FROM achievement WHERE income_class="Renewal") AS Achievement,
(SELECT SUM(Amount) FROM invoice WHERE income_class="Renewal") AS Invoice;

-- STAGE BY REVENUE --
SELECT stage,SUM(revenue_amount) AS revenue_amount FROM opportunity
GROUP BY stage;

-- NO. OF MEETING BY ACCOUNT EXECUTIVE --
SELECT `Account Executive`,COUNT(meeting_date) AS meeting_count FROM meeting
GROUP BY `Account Executive`;

-- TOTAL OPPORTUNITY --
SELECT COUNT(stage) AS total_opportunity FROM opportunity;

-- TOTAL OPEN OPPORTUNITY --
SELECT COUNT(stage) AS open_opportunity_total FROM opportunity
WHERE stage IN ('Propose Solution','Qualify Opportunity');

-- TOTAL NEGOTIATION/WON OPPORUNITY --
SELECT COUNT(stage) AS won_opportunity_total FROM opportunity
WHERE stage IN ('Negotiate');

-- TOP 10 OPEN OPPORTUNITY --
SELECT opportunity_name,revenue_amount FROM opportunity
WHERE stage IN ('Propose Solution','Qualify Opportunity')
ORDER BY revenue_amount DESC
LIMIT 10;

-- TOP 5 OPPORTUNITY --
SELECT opportunity_name,revenue_amount FROM opportunity 
ORDER BY revenue_amount 
DESC LIMIT 5;





