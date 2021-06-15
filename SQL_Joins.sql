/*
INNER JOIN
	Joining the Orders Table and Account Table on the Customer ID
*/

SELECT orders.*, accounts.*
	FROM orders
	JOIN accounts
	ON orders.account_id = accounts.id;


/*
if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns,
*/

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
and the website and the primary_poc from the accounts table.
*/

SELECT accounts.website, accounts.primary_poc, orders.standard_qty, orders.gloss_qty, orders.poster_qty
	FROM orders
	JOIN accounts
	ON orders.account_id = accounts.id


/*
If we wanted to join three tables, 
we could use the same logic. The code below pulls all of the data from all of the joined tables.
*/

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id


/*
Creating a Aliases of the Tables
*/

SELECT ac.primary_poc, od.standard_qty, we.channel
FROM web_events AS we
JOIN accounts AS ac
ON we.account_id = ac.id
JOIN orders AS od
ON ac.id = od.account_id



/*
Provide a table for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/

SELECT ac.name, ac.primary_poc, we.occurred_at, we.channel 
FROM web_events AS we
JOIN accounts AS ac
ON ac.id = we.account_id
WHERE ac.name = 'Walmart'


/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT rg.name AS Region_name,  sr.name AS Sales_rep_name, ac.name AS Account_name
FROM sales_reps AS sr
JOIN region AS rg
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
ORDER BY ac.name



/*
Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

SELECT rg.name AS Region_name, ac.name AS Account_name, (total_amt_usd/(total + 0.01)) AS Unit_Price
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders as od
ON ac.id = od.account_id



/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for the Midwest region. Your final table should include three columns: the region name, 
the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT rg.name AS Region_name,  sr.name AS Sales_rep_name, ac.name AS Account_name
	FROM sales_reps AS sr
	JOIN region AS rg
	ON rg.id = sr.region_id
	JOIN accounts AS ac
	ON sr.id = ac.sales_rep_id
		AND rg.name = 'Midwest'
	ORDER BY ac.name



/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT rg.name AS Region_name,  sr.name AS Sales_rep_name, ac.name AS Account_name
	FROM sales_reps AS sr
	JOIN region AS rg
	ON rg.id = sr.region_id
	JOIN accounts AS ac
	ON sr.id = ac.sales_rep_id
	AND (rg.name = 'Midwest' AND sr.name LIKE 'S%')
	ORDER BY ac.name
	

/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

	
SELECT rg.name AS Region_name,  sr.name AS Sales_rep_name, ac.name AS Account_name
	FROM sales_reps AS sr
	JOIN region AS rg
	ON rg.id = sr.region_id
	JOIN accounts AS ac
	ON sr.id = ac.sales_rep_id
	AND (rg.name = 'Midwest' AND sr.name LIKE '%_K%')
	ORDER BY ac.name
	

/*
Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100. 
Your final table should have 3 columns: region name, account name, and unit price. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/

SELECT rg.name AS Region_name, ac.name AS Account_name, (total_amt_usd/(total + 0.01)) AS Unit_Price
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders as od
ON ac.id = od.account_id
AND od.standard_qty > 100


/*
Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the smallest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/

SELECT rg.name AS Region_name, ac.name AS Account_name, (total_amt_usd/(total + 0.01)) AS Unit_Price
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders as od
ON ac.id = od.account_id
AND (od.standard_qty > 100 AND od.poster_qty > 50)
ORDER BY Unit_Price




/*
Provide the name for each region for every order, 
as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the largest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/

SELECT rg.name AS Region_name, ac.name AS Account_name, (total_amt_usd/(total + 0.01)) AS Unit_Price
FROM region AS rg
JOIN sales_reps AS sr
ON rg.id = sr.region_id
JOIN accounts AS ac
ON sr.id = ac.sales_rep_id
JOIN orders as od
ON ac.id = od.account_id
AND (od.standard_qty > 100 AND od.poster_qty > 50)
ORDER BY Unit_Price DESC


/*
What are the different channels used by account id 1001? 
Your final table should have only 2 columns: account name and the different channels. 
You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/

SELECT DISTINCT ac.name AS Account_name, we.channel AS Different_Channels
FROM accounts AS ac
JOIN web_events AS we
ON ac.id = we.account_id
AND ac.id = 1001


/*
Find all the orders that occurred in 2015. 
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/

SELECT ac.name, od.occurred_at, od.total AS Total_Order, od.total_amt_usd  AS Total_Order_Amount
FROM orders AS od
JOIN accounts AS ac
ON ac.id =  od.account_id
AND (od.occurred_at BETWEEN '2015-01-01' AND '2016-01-01')
ORDER BY od.occurred_at




