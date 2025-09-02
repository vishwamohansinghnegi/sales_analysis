SELECT * FROM walmart;

-- Number of distinct payment methods
SELECT DISTINCT(payment_method) FROM walmart;

-- number of transactions from each payment method
SELECT payment_method ,COUNT(*)
            FROM walmart 
            GROUP BY payment_method;

-- Number of distinct brachs
SELECT COUNT(DISTINCT(branch))
            FROM walmart;

-- Maximumn quantity
SELECT MAX(quantity)
            FROM walmart;

-- Minimum quantity
SELECT MIN(quantity)
            FROM walmart;

-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT payment_method, COUNT(*) AS no_of_payments, SUM(quantity) AS quantity_sol
            FROM walmart
            GROUP BY payment_method;

-- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT * FROM (SELECT branch, category, AVG(rating) AS avg_rating,
            RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
            FROM walmart
            GROUP BY branch,category) T
            WHERE rnk=1;

-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT * FROM 
            (SELECT branch, DAYNAME(date) AS day_name, COUNT(*) AS no_of_transactions,
            RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
            FROM walmart
            GROUP BY branch,day_name) T
            WHERE rnk=1;

-- Q4: Calculate the total quantity of items sold per payment method
SELECT payment_method, SUM(quantity) AS qty_sold
            FROM walmart
            GROUP BY payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT city, category, MAX(rating), MIN(rating), AVG(rating)
            FROM walmart
            GROUP BY city, category;

-- Q6: Calculate the total profit for each category
SELECT category, SUM(total * profit_margin) AS total_profit
            FROM walmart
            GROUP BY category;

-- Q7: Determine the most common payment method for each branch
SELECT * FROM (
            SELECT branch, payment_method, COUNT(*) AS no_of_transactions,
            RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
            FROM walmart
            GROUP BY branch, payment_method) T
            WHERE rnk=1;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
-- Find no of invoices in each shift and branch
SELECT branch,
        CASE 
            WHEN HOUR(time) < 12 THEN 'Morning'
            WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift,
        COUNT(*) AS no_of_invoices
    FROM walmart
    GROUP BY branch, shift
    ORDER BY branch, COUNT(*) DESC;

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from 2022 to 2023
SELECT *, ROUND(((rev_2022-rev_2023)/rev_2022)*100, 2) AS ratio FROM 
            ( SELECT t1.branch, rev_2023, rev_2022 FROM 
            (SELECT branch, SUM(total) AS rev_2023
            FROM walmart
            WHERE YEAR(date)=2023
            GROUP BY branch) t1
            JOIN
            (SELECT branch, SUM(total) AS rev_2022
            FROM walmart
            WHERE YEAR(date)=2022
            GROUP BY branch) t2
            ON t1.branch=t2.branch) t
            ORDER BY ratio DESC
            LIMIT 5;