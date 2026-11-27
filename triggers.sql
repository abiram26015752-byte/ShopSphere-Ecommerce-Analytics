USE shopsphere;
DROP TRIGGER IF EXISTS trg_reduce_stock;
DELIMITER //
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock_qty = GREATEST(stock_qty - NEW.quantity, 0)
  WHERE product_id = NEW.product_id;
END//
DELIMITER ;
