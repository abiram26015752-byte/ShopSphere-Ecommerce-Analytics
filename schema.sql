CREATE DATABASE IF NOT EXISTS shopsphere;
USE shopsphere;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(150) NOT NULL UNIQUE,
  signup_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS addresses (
  address_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL,
  pincode VARCHAR(10) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS categories (
  category_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  parent_id INT NULL,
  FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS products (
  product_id INT PRIMARY KEY,
  category_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  stock_qty INT NOT NULL CHECK (stock_qty >= 0),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  address_id INT NOT NULL,
  order_date DATETIME NOT NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

CREATE TABLE IF NOT EXISTS order_items (
  item_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS payments (
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  method VARCHAR(30) NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  paid_at DATETIME,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE IF NOT EXISTS returns (
  return_id INT PRIMARY KEY,
  item_id INT NOT NULL,
  reason VARCHAR(200) NOT NULL,
  refund_amount DECIMAL(10,2) NOT NULL CHECK (refund_amount >= 0),
  returned_at DATETIME NOT NULL,
  FOREIGN KEY (item_id) REFERENCES order_items(item_id)
);
