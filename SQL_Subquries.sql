/*
find the average number of events for each day for each channel.
*/

SELECT	channel,
		AVG(Event_count) AS Avg_event_count_per_day
FROM
	(
		SELECT	DATE_TRUNC('day', occurred_at) AS day,
				channel,
				COUNT(*) AS Event_count
		FROM web_events
		GROUP BY day, channel
	)
GROUP BY channel
ORDER BY Avg_event_count_per_day DESC


/*
The average amount of standard paper, gloss and poster paper sold on the first month that any order was placed in the orders table (in terms of quantity).
*/

SELECT AVG(poster_qty), AVG(standard_qty), AVG(gloss_qty)
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = 
	(SELECT	DATE_TRUNC('month', MIN(occurred_at)) AS 			min_month
	FROM orders
	)


/*
The total amount spent on all orders on the first month that any order was placed in the orders table (in terms of usd).
*/


SELECT AVG(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = 
	(SELECT	DATE_TRUNC('month', MIN(occurred_at)) AS 			min_month
	FROM orders
	)



/*
Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

	SELECT T3.Sales_Rep_Name, T3.Region_Name, T3.Total_Sales_Amt
	FROM
		(
			SELECT Region_Name, MAX(Total_Sales_Amt) AS MAX_Sales_Amt
			FROM
				(
						
					SELECT sr.name AS Sales_Rep_Name, rg.name AS Region_Name, SUM(od.total_amt_usd) AS Total_Sales_Amt
					FROM region AS rg
					JOIN sales_reps AS sr
					ON rg.id = sr.region_id
					JOIN accounts AS ac
					ON sr.id = ac.sales_rep_id
					JOIN orders AS od
					ON ac.id = od.account_id
					GROUP BY Sales_Rep_Name, Region_Name ) T1
			GROUP BY Region_Name )T2
	JOIN
		(
			SELECT sr.name AS Sales_Rep_Name, rg.name AS Region_Name, SUM(od.total_amt_usd) AS Total_Sales_Amt
			FROM region AS rg
			JOIN sales_reps AS sr
			ON rg.id = sr.region_id
			JOIN accounts AS ac
			ON sr.id = ac.sales_rep_id
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY Sales_Rep_Name, Region_Name
			ORDER BY Total_Sales_Amt DESC )T3
	ON	T3.Region_Name = T2.Region_Name AND T3.Total_Sales_Amt = T2.MAX_Sales_Amt



/*
For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/

SELECT rg.name, COUNT(od.total) AS Total_Orders
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY rg.name
HAVING 	SUM(od.total_amt_usd) = 
	(SELECT MAX(Total_Sales_Amt)
	 FROM (
			SELECT rg.name AS Region_Name, SUM(od.total_amt_usd) AS Total_Sales_Amt
			FROM region AS rg
			JOIN sales_reps AS sr
			ON rg.id = sr.region_id
			JOIN accounts AS ac
			ON sr.id = ac.sales_rep_id
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY Region_Name
		) T1
	)






/*
How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
*/

SELECT ac.name AS acc_name
FROM accounts AS ac
JOIN orders AS od
ON ac.id = ac.account_id
GROUP BY acc_name
HAVING od.total > (SELECT total_paper_Qty
		FROM(
		SELECT ac.name AS acc_name, SUM(od.standard_qty) AS total_stand_qty_paper, SUM(od.total) AS total_paper_Qty
		FROM accounts AS ac
		JOIN orders AS od
		ON ac.id = od.account_id
		GROUP BY acc_name
		ORDER BY total_stand_qty_paper DESC
		LIMIT 1
	) T1)


/*
For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/

SELECT ac.name, wb.channel, COUNT(*) AS Channel_Count
FROM accounts AS ac
JOIN web_events AS wb
ON ac.id = wb.account_id AND ac.id = (SELECT id
								FROM
								(
								SELECT ac.id, ac.name AS acc_name, SUM(total_amt_usd) AS total_lifetime_spent
								FROM accounts AS ac
								JOIN orders AS od
								ON ac.id = od.account_id
								GROUP BY ac.id,acc_name
								ORDER BY total_lifetime_spent DESC
								LIMIT 1
								)T1
							)
GROUP BY ac.name, wb.channel
ORDER BY Channle_Count



/*
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/


SELECT AVG(total_lifetime_spent) AS Avg_Lifetime_Spent
FROM
	(
	SELECT ac.id, ac.name AS acc_name, SUM(total_amt_usd) AS total_lifetime_spent
	FROM accounts AS ac
	JOIN orders AS od
	ON ac.id = od.account_id
	GROUP BY ac.id,acc_name
	ORDER BY total_lifetime_spent DESC
	LIMIT 10
	) T1


/*
What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, than the average of all orders.
*/

SELECT AVG(Avg_Amt)
FROM
	(
	SELECT od.account_id, AVG(total_amt_usd) AS Avg_Amt
	FROM orders AS od
	GROUP BY od.account_id
	HAVING AVG(total_amt_usd) > (SELECT AVG(total_amt_usd) AS Avg_Lifetime_Spent
	FROM orders AS od)
	)T1
	

==========================================================

SELECT AVG(Avg_Amt)
FROM(
SELECT ac.name, AVG(total_amt_usd) AS Avg_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
HAVING AVG(total_amt_usd) > (SELECT AVG(Avg_lifetime_spent)
FROM(
SELECT ac.id, ac.name AS acc_name, AVG(od.total_amt_usd) AS Avg_lifetime_spent
	FROM accounts AS ac
	JOIN orders AS od
	ON ac.id = od.account_id
	GROUP BY ac.id,acc_name
)T1)
)T2




/*
USING WITH Syntax
*/



/*
Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/
	
WITH T1 AS (
			SELECT sr.name AS Sales_Rep_Name, rg.name AS Region_Name, SUM(od.total_amt_usd) AS Total_Sales_Amt
			FROM region AS rg
			JOIN sales_reps AS sr
			ON rg.id = sr.region_id
			JOIN accounts AS ac
			ON sr.id = ac.sales_rep_id
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY Sales_Rep_Name, Region_Name
			ORDER BY Total_Sales_Amt DESC
			),
	 T2 AS (
			SELECT Region_Name, MAX(Total_Sales_Amt) AS MAX_Sales_Amt
			FROM T1
			GROUP BY Region_Name
			)
SELECT T1.Sales_Rep_Name, T1.Region_Name, T1.Total_Sales_Amt
FROM T1
JOIN T2
ON T1.Region_Name = T2.Region_Name AND T1.Total_Sales_Amt = T2.MAX_Sales_Amt



/*
For the region with the largest sales total_amt_usd, how many total orders were placed?
*/

WITH T1 AS (
			SELECT rg.name AS Region_Name, SUM(od.total_amt_usd) AS Total_Sales_Amt
			FROM region AS rg
			JOIN sales_reps AS sr
			ON rg.id = sr.region_id
			JOIN accounts AS ac
			ON sr.id = ac.sales_rep_id
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY Region_Name
			),
	T2 AS (
		   SELECT MAX(Total_Sales_Amt)
		   FROM T1
		  )
SELECT rg.name, COUNT(od.total) AS Total_Orders
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY rg.name
HAVING SUM(od.total_amt_usd) = (SELECT * FROM T2)


/*
How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
*/
WITH T1 AS (
			SELECT ac.name AS acc_name, SUM(od.standard_qty) AS total_stand_qty_paper, SUM(od.total) AS total_paper_Qty
			FROM accounts AS ac
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY acc_name
			ORDER BY total_stand_qty_paper DESC
			LIMIT 1
			),
	T2 AS (
		   SELECT total_paper_Qty
		   FROM T1
		   )
SELECT ac.name AS acc_name
FROM accounts AS ac
JOIN orders AS od
ON ac.id = ac.account_id
GROUP BY acc_name
HAVING od.total > (SELECT * FROM T2)



/*
For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/

WITH T1 AS (
			SELECT ac.id, ac.name AS acc_name, SUM(total_amt_usd) AS total_lifetime_spent
			FROM accounts AS ac
			JOIN orders AS od
			ON ac.id = od.account_id
			GROUP BY ac.id,acc_name
			ORDER BY total_lifetime_spent DESC
			LIMIT 1
			),
	 T2 AS (
			SELECT id
			FROM T1
			)
SELECT ac.name, wb.channel, COUNT(*) AS Channel_Count
FROM accounts AS ac
JOIN web_events AS wb
ON ac.id = wb.account_id AND ac.id = (SELECT * FROM T2)
GROUP BY ac.name, wb.channel
ORDER BY COUNT (*) DESC


/*

*/
































