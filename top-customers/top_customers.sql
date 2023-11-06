/* Calculate the total order value for each customer for each year-month */
WITH order_monthly_values AS (
  SELECT
    EXTRACT(YEAR FROM orders.ordered_at) AS year,
    EXTRACT(MONTH FROM orders.ordered_at) AS month,
    customers.customer_id As customer_id,
    SUM(order_line_items.unit_price * order_line_items.quantity) AS total_monthly_order_value
  FROM order_line_items
  JOIN orders ON order_line_items.order_id = orders.order_id
  JOIN customers ON orders.customer_id = customers.customer_id
  GROUP BY EXTRACT(YEAR FROM orders.ordered_at), EXTRACT(MONTH FROM orders.ordered_at), customers.customer_id
), 
/* Find the highest monthly order values for each year-month */
highest_monthly_order_values AS (
  SELECT
    year,
    month,
    MAX(total_monthly_order_value) AS highest_monthly_order_value
  FROM order_monthly_values
  GROUP BY year, month
)
/* Find the customer with the highest order value for each year-month */
SELECT
  highest_monthly_order_values.year,
  highest_monthly_order_values.month,
  order_monthly_values.customer_id,
  order_monthly_values.total_monthly_order_value
FROM order_monthly_values
JOIN highest_monthly_order_values
ON order_monthly_values.year = highest_monthly_order_values.year
AND order_monthly_values.month = highest_monthly_order_values.month
AND order_monthly_values.total_monthly_order_value = highest_monthly_order_values.highest_monthly_order_value
/* In case of multiple customers matching highest order value, pick the customer with lowest ID*/
AND order_monthly_values.customer_id = (
  	SELECT MIN(customer_id) 
  	FROM order_monthly_values
  	WHERE order_monthly_values.total_monthly_order_value = highest_monthly_order_values.highest_monthly_order_value
  )
ORDER BY year, month ASC;