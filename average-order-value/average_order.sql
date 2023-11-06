SELECT
  customers.name,
  COUNT(DISTINCT orders.order_id) AS number_of_orders, /* One order can have multiple order line items */
  SUM(order_line_items.unit_price * order_line_items.quantity) AS total_order_value,
  SUM(order_line_items.unit_price * order_line_items.quantity) / COUNT(DISTINCT orders.order_id) AS average_value_per_order
  FROM customers
  JOIN orders ON orders.customer_id = customers.customer_id
  JOIN order_line_items ON order_line_items.order_id = orders.order_id
GROUP BY customers.name
ORDER BY average_value_per_order DESC;