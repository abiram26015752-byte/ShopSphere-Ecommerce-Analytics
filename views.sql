USE shopsphere;
CREATE OR REPLACE VIEW v_monthly_revenue AS
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m');
