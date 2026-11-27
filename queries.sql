USE shopsphere;

-- 1. Monthly revenue trend
SELECT * FROM v_monthly_revenue ORDER BY revenue_month;

-- 2. Top 10 products by sales value
SELECT p.product_id, p.name,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS sales_value
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.name
ORDER BY sales_value DESC
LIMIT 10;

-- 3. Top 10 customers by lifetime value
SELECT c.customer_id, c.name,
       COUNT(DISTINCT o.order_id) AS order_count,
       SUM(oi.quantity * oi.unit_price) AS lifetime_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
LIMIT 10;

-- 4. Repeat purchase rate: customers with at least two non-cancelled orders
SELECT ROUND(
  100.0 * SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) / COUNT(*), 2
) AS repeat_purchase_rate_pct
FROM (
  SELECT c.customer_id, COUNT(o.order_id) AS order_count
  FROM customers c
  LEFT JOIN orders o
    ON o.customer_id = c.customer_id AND o.status <> 'Cancelled'
  GROUP BY c.customer_id
) customer_orders;

-- 5. Return rate by category (returned order lines / sold order lines)
SELECT c.name AS category,
       COUNT(DISTINCT r.return_id) AS returned_lines,
       COUNT(DISTINCT oi.item_id) AS sold_lines,
       ROUND(100.0 * COUNT(DISTINCT r.return_id) /
             NULLIF(COUNT(DISTINCT oi.item_id), 0), 2) AS return_rate_pct
FROM categories c
JOIN products p ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN returns r ON r.item_id = oi.item_id
GROUP BY c.category_id, c.name
ORDER BY return_rate_pct DESC;
