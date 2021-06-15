/*
In the following concepts you will be learning in detail about each of the aggregate functions,
as well as some additional aggregate functions that are used in SQL all the time.
*/


/*
Find the total amount of poster_qty paper ordered in the orders table.
*/

SELECT SUM(poster_qty) FROM orders


/*
Find the total amount of standard_qty paper ordered in the orders table.
*/

SELECT SUM(standard_qty) FROM orders

/*
Find the total dollar amount of sales using the total_amt_usd in the orders table.
*/

SELECT SUM(total_amt_usd) FROM orders


/*
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.
*/
 
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders


/*
Find the standard_amt_usd per unit of standard_qty paper. 
*/

SELECT (SUM(standard_amt_usd) / SUM(standard_qty)) AS Standard_Amt_Used_Per_Unit
FROM orders 

/*
When was the earliest order ever placed? You only need to return the date.
*/

SELECT MIN(occurred_at) FROM orders


/*
Try performing the same query as in question 1 without using an aggregation function.
*/

SELECT occurred_at FROM orders
ORDER BY occurred_at
LIMIT 1


/*
When did the most recent (latest) web_event occur?
*/
SELECT MAX(occurred_at) FROM web_events



/*
Try to perform the result of the previous query without using an aggregation function.
*/

SELECT occurred_at FROM web_events
ORDER BY occurred_at DESC
LIMIT 1


/*
Find the mean (AVERAGE) amount spent per order on each paper type, 
as well as the mean amount of each paper type purchased per order.
*/

SELECT	AVG(standard_amt_usd) AS Avg_Std_Amt,
		AVG(gloss_amt_usd) AS Avg_Gloss_Amt,
		AVG(poster_amt_usd) AS Avg_Poster_Amt,
		AVG(standard_qty) AS Avg_Std_Qty,
		AVG(gloss_qty) AS Avg_Gloss_Qty,
		AVG(poster_qty) AS Avg_Poster_Qty
	FROM orders



/*
Via the video, you might be interested in how to calculate the MEDIAN. 
Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


SELECT AVG(total_amt_usd) AS Median_Total_Amt_Used
FROM (
		SELECT *
		FROM (SELECT total_amt_usd
			  FROM orders
			  ORDER BY total_amt_usd
			  LIMIT 3457) AS Table1
		ORDER BY total_amt_usd DESC
		LIMIT 2
	) AS Table2

	


/*
Which account (by name) placed the earliest order? 
Your solution should have the account name and the date of the order.
*/

SELECT ac.name, od.occurred_at
FROM accounts AS account
JOIN orders AS od
ON ac.id = od.account_id
ORDER BY occurred_at
LIMIT 1


SELECT ac.name, od.occurred_at
FROM orders AS od
JOIN accounts AS ac
ON ac.id = od.account_id
GROUP BY ac.name, od.occurred_at
ORDER BY occurred_at






/*
Find the total sales in usd for each account. 
You should include two columns - the total sales for each company's orders in usd and the company name.
*/

SELECT ac.name, SUM(od.total_amt_usd) AS Total_Sales_for_each_company
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name



/*
Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.
*/

SELECT wb.channel, wb.occurred_at, ac.name
FROM web_events AS wb
JOIN accounts AS ac
ON ac.id = wb.account_id
ORDER BY occurred_at DESC
LIMIT 1


/*
Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.
*/

SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel


/*
Who was the primary contact associated with the earliest web_event?
*/

SELECT wb.channel, wb.occurred_at, ac.name, ac.primary_poc
FROM web_events AS wb
JOIN accounts AS ac
ON ac.id = wb.account_id
ORDER BY occurred_at DESC
LIMIT 1


/*
What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
*/

SELECT ac.name, MIN(od.total_amt_usd) AS Smallest_order
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
ORDER BY Smallest_order


/*
Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
*/

SELECT rg.name, COUNT(*) AS No_Of_reps
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
GROUP BY rg.name
ORDER BY No_Of_reps


/*
For each account, determine the average amount of each type of paper they purchased across their orders. 
Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
*/

SELECT ac.name, AVG(od.standard_qty) AS Avg_Stand_Qty, AVG(od.gloss_qty) AS Avg_Gloss_Qty, AVG(od.poster_qty) AS Avg_Poster_Qty
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name


/*
For each account, determine the average amount spent per order on each paper type. 
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
*/

SELECT ac.name, AVG(od.standard_amt_usd) AS Avg_Stand_Used, AVG(od.gloss_amt_usd) AS Avg_Gloss_Used, AVG(od.poster_amt_usd) AS Avg_Poster_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name


/*
Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.
*/

SELECT sr.name, wb.channel, COUNT(*) AS Num_events
FROM web_events as wb
JOIN accounts AS ac
ON wb.account_id  = ac.id
JOIN sales_reps AS sr
ON ac.sales_rep_id = sr.id
GROUP BY wb.channel, sr.name
ORDER BY sr.name, Num_events  DESC


/*
Determine the number of times a particular channel was used in the web_events table for each region. 
Your final table should have three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.
*/

SELECT rg.name, wb.channel, COUNT(*) AS Num_events
FROM web_events as wb
JOIN accounts AS ac
ON wb.account_id  = ac.id
JOIN sales_reps AS sr
ON ac.sales_rep_id = sr.id
JOIN region AS rg
ON sr.region_id = rg.id
GROUP BY wb.channel, rg.name
ORDER BY rg.name, Num_events  DESC


/*
Use DISTINCT to test if there are any accounts associated with more than one region.
*/


SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id

SELECT DISTINCT id, name
FROM accounts



/*
How many of the sales reps have more than 5 accounts that they manage?
*/

SELECT sr.name AS Sale_Rep, COUNT(ac.name) AS No_of_ACC
FROM sales_reps AS sr
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
GROUP BY sr.name
HAVING COUNT(ac.name) > 5
ORDER BY No_of_ACC DESC



/*
How many accounts have more than 20 orders?
*/

SELECT ac.name, COUNT(od.id) AS Tot_Orders
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
HAVING COUNT(od.id) > 20
ORDER BY Tot_Orders DESC


/*
Which accounts spent more than 30,000 usd total across all orders?
*/

SELECT ac.name, SUM(total_amt_usd) AS Tot_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY Tot_Amt DESC

/*
Which accounts spent less than 1,000 usd total across all orders?
*/

SELECT ac.name, SUM(total_amt_usd) AS Tot_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
HAVING SUM(total_amt_usd) < 1000
ORDER BY Tot_Amt



/*
Which account has spent the most with us?
*/

SELECT ac.name, SUM(total_amt_usd) AS Tot_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
ORDER BY Tot_Amt DESC
LIMIT 1

/*
Which account has spent the least with us?
*/

SELECT ac.name, SUM(total_amt_usd) AS Tot_Amt
FROM accounts AS ac
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY ac.name
ORDER BY Tot_Amt
LIMIT 1


/*
Which accounts used facebook as a channel to contact customers more than 6 times?
*/

SELECT ac.name, COUNT(wb.channel) AS Channel_Count
FROM accounts AS ac
JOIN web_events AS wb
ON ac.id = wb.account_id
WHERE wb.channel = 'facebook'
GROUP BY ac.name
HAVING COUNT(wb.channel) >  6
ORDER BY Channel_Count DESC
 
					/* OR */


SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel DESC;

/*
Which account used facebook most as a channel?
*/

SELECT ac.name, COUNT(wb.channel) AS Channel_Count
FROM accounts AS ac
JOIN web_events AS wb
ON ac.id = wb.account_id
WHERE wb.channel = 'facebook'
GROUP BY ac.name
ORDER BY Channel_Count DESC
LIMIT 1

/*
Which channel was most frequently used by most accounts?
*/


SELECT ac.name, COUNT(wb.channel) AS Channel_Count, wb.channel
FROM accounts AS ac
JOIN web_events AS wb
ON ac.id = wb.account_id
GROUP BY ac.name, wb.channel
ORDER BY Channel_Count DESC
LIMIT 10



/*
Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?
*/

SELECT DATEPART('year', occurred_at) AS Order_Year, SUM(total_amt_usd)
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year

/*
Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?
*/
SELECT DATEPART('month', occurred_at) AS Order_Month, SUM(total_amt_usd)
FROM orders
GROUP BY Order_Month
ORDER BY Order_Month


/*
Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?
*/

SELECT DATEPART('year', occurred_at) AS Order_Year, SUM(total)
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year DESC
LIMIT 1


/*
Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset?
*/

SELECT DATEPART('month', occurred_at) AS Order_month, SUM(total)
FROM orders
GROUP BY Order_month
ORDER BY Order_month 
LIMIT 1


/*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/

SELECT DATEPART('month', od.occurred_at) AS Order_month, ac.name, SUM(od.gloss_amt_usd) AS TOT_Spent
FROM orders AS od
JOIN accoounts AS ac
ON ac.id = od.account_id
WHERE ac.name = 'Walmart'
GROUP BY Order_month
ORDER BY Order_Year, Order_month
LIMIT 1


/*
Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - 
depending on if the order is $3000 or more, or smaller than $3000.
*/


SELECT account_id, total_amt_usd, CASE WHEN total_amt_usd > 3000 THEN 'Large' ELSE 'Small' END AS Level_of_the_Order
FROM orders


/*
Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/

SELECT  CASE WHEN total < 1000 THEN 'Less than 1000'
			WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
			ELSE 'At least 2000' END AS No_Of_Orders,
		COUNT(*) AS Category_Count
FROM orders
GROUP BY No_Of_Orders





/*
We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.
*/


SELECT 	ac.name, SUM(od.total_amt_usd) AS Lifetime_Value,
		CASE
			WHEN SUM(od.total_amt_usd) > 200000 THEN 'Top Level'
			WHEN SUM(od.total_amt_usd) <=200000 AND SUM(od.total_amt_usd) >= 100000 THEN 'Second Level'
			ELSE 'Lowest Level' END AS Customer_Category
FROM orders AS od
JOIN accounts AS ac
ON ac.id = od.account_id
GROUP BY ac.name
ORDER By Lifetime_Value DESC


/*
We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. 
Order with the top spending customers listed first.
*/


SELECT 	ac.name, SUM(od.total_amt_usd) AS Lifetime_Value,
		CASE
			WHEN SUM(od.total_amt_usd) > 200000 THEN 'Top Level'
			WHEN SUM(od.total_amt_usd) <=200000 AND SUM(od.total_amt_usd) >= 100000 THEN 'Second Level'
			ELSE 'Lowest Level' END AS Customer_Category
FROM orders AS od
JOIN accounts AS ac
ON ac.id = od.account_id
WHERE DATEPART('year', od.occurred_at) IN ('2016', '2017')
GROUP BY ac.name
ORDER By Lifetime_Value DESC


/*
We would like to identify top performing sales reps, 
which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. 
Place the top sales people first in your final table.
*/


SELECT	sr.name, COUNT(*) AS No_Of_Orders,
		CASE
			WHEN COUNT(*) > 200 THEN 'TOP'
			ELSE 'NOT' END AS Performance_Level,
FROM sales_reps AS sr
JOIN accounts AS ac
ON sr.id = ac sales_rep_id
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY sr.name
ORDER BY No_Of_Orders DESC


/*
The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!
*/


SELECT	sr.name, COUNT(*) AS No_Of_Orders, SUM(od.total_amt_usd) AS Total_Sales_Amt,
		CASE
			WHEN COUNT(*) > 200 OR SUM(od.total_amt_usd) > 750000 THEN 'Top'
			WHEN COUNT(*) > 150 OR SUM(od.total_amt_usd) > 500000 THEN 'Middle'
			ELSE 'Low' END AS Performance_Level
FROM sales_reps AS sr
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders AS od
ON ac.id = od.account_id
GROUP BY sr.name
ORDER BY Total_Sales_Amt DESC

