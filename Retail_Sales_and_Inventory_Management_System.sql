-- =====================================================
-- PROJECT: Retail Sales & Inventory Management System
-- Database: retail_db
-- Author: Sahara Rampal
-- =====================================================

-- =====================================================
-- SECTION 1: CREATE DATABASE
-- =====================================================
CREATE DATABASE retail_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
USE retail_db;
-- =====================================================
-- SECTION 2 & 3: CREATE TABLES & INSERT SAMPLE DATA
-- =====================================================
-- Customer Table
CREATE TABLE Customer(customer_id INT AUTO_INCREMENT PRIMARY KEY, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, phone VARCHAR(20), city VARCHAR(80), country VARCHAR(60) DEFAULT 'India', joined_date DATE NOT NULL, is_active TINYINT DEFAULT 1);
INSERT INTO Customer (first_name, last_name, email, phone, city, country, joined_date) VALUES
('Arjun','Sharma','arjun.sharma@email.com','9876543210','Mumbai','India','2022-01-15'),
('Priya','Patel','priya.patel@email.com','9876543211','Ahmedabad','India','2022-03-22'),
('Rahul','Verma','rahul.verma@email.com','9876543212','Delhi','India','2022-06-10'),
('Sneha','Nair','sneha.nair@email.com','9876543213','Kochi','India','2022-08-05'),
('Vikram','Singh','vikram.singh@email.com','9876543214','Jaipur','India','2023-01-20'),
('Anita','Desai','anita.desai@email.com','9876543215','Pune','India','2023-04-12'),
('Karthik','Kumar','karthik.kumar@email.com','9876543216','Chennai','India','2023-07-08'),
('Meera','Iyer','meera.iyer@email.com','9876543217','Bangalore','India','2023-09-30');

-- Categories Table
CREATE TABLE categories (category_id INT AUTO_INCREMENT PRIMARY KEY, category_name VARCHAR(80) NOT NULL, parent_id INT DEFAULT NULL, FOREIGN KEY (parent_id) REFERENCES categories(category_id));
INSERT INTO categories (category_name, parent_id) VALUES
('Electronics', NULL),
('Clothing', NULL),
('Home & Kitchen', NULL),
('Smartphones', 1),
('Laptops', 1),
('Men''s Wear', 2),
('Women''s Wear', 2);

-- Supplier Table
CREATE TABLE supplier (supplier_id INT AUTO_INCREMENT PRIMARY KEY, supplier_name VARCHAR(100) NOT NULL, country VARCHAR(60), email VARCHAR(100), rating DECIMAL(3,1) DEFAULT 3.0 );
INSERT INTO supplier (supplier_name, country, email, rating) VALUES
('TechWorld Pvt Ltd','India','supply@techworld.com', 4.5),
('FashionHub','India','supply@fashionhub.com', 4.2),
('GlobalGoods','China','supply@globalgoods.com',3.8),
('KitchenPro','India','supply@kitchenpro.com',4.7);

-- Product Table
CREATE TABLE product (product_id INT AUTO_INCREMENT PRIMARY KEY, product_name VARCHAR(150) NOT NULL, category_id INT, supplier_id INT, price DECIMAL(10,2) NOT NULL, cost_price DECIMAL(10,2), stock_qty INT DEFAULT 0, reorder_level INT DEFAULT 20, is_active TINYINT DEFAULT 1, FOREIGN KEY (category_id) REFERENCES categories(category_id), FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id));
INSERT INTO product (product_name, category_id, supplier_id, price, cost_price, stock_qty, reorder_level) VALUES 
('Samsung Galaxy S23', 4, 1, 74999.00, 58000.00, 50, 10),
('Apple iPhone 14', 4, 1, 79999.00, 63000.00, 35, 10),
('Dell Inspiron 15 Laptop', 5, 1, 54999.00, 42000.00, 25, 5),
('HP Pavilion Laptop', 5, 3, 49999.00, 38000.00, 30, 5),
('Men''s Casual T-Shirt', 6, 2, 599.00, 200.00, 200, 30),
('Women''s Kurti', 7, 2, 899.00, 350.00, 150, 25),
('Stainless Steel Cookware',3, 4, 3499.00, 1800.00, 80, 15),
('Air Purifier',3, 3, 8999.00, 6200.00, 40, 8);

-- Orders Table
CREATE TABLE orders (order_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, status ENUM('Pending','Processing','Shipped','Delivered','Cancelled'), total_amount DECIMAL(12,2), shipping_city VARCHAR(80), FOREIGN KEY (customer_id) REFERENCES customers(customer_id));
INSERT INTO orders (customer_id, order_date, status, total_amount, shipping_city) VALUES 
(1, '2023-10-01 10:30:00', 'Delivered', 74999.00, 'Mumbai'), 
(2, '2023-10-05 14:00:00', 'Delivered', 130498.00, 'Ahmedabad'), 
(3, '2023-11-12 09:15:00', 'Shipped', 54999.00, 'Delhi'), 
(4, '2023-11-20 16:45:00', 'Delivered', 1498.00, 'Kochi'), 
(5, '2023-12-01 11:00:00', 'Processing', 79999.00, 'Jaipur'), 
(1, '2023-12-10 13:30:00', 'Delivered', 8999.00, 'Mumbai'), 
(6, '2024-01-05 10:00:00', 'Cancelled', 49999.00, 'Pune'), 
(7, '2024-01-15 09:00:00', 'Delivered', 104998.00, 'Chennai');

-- Order Item Table
CREATE TABLE order_item (item_id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL, quantity INT NOT NULL, unit_price DECIMAL(10,2) NOT NULL, discount_pct DECIMAL(5,2) DEFAULT 0.00, FOREIGN KEY (order_id) REFERENCES orders(order_id), FOREIGN KEY (product_id) REFERENCES product(product_id));
INSERT INTO order_item (order_id, product_id, quantity, unit_price, discount_pct) VALUES 
(1, 1, 1, 74999.00, 0.00), (2, 2, 1, 79999.00, 0.00), (2, 3, 1, 54999.00, 5.00), 
(3, 3, 1, 54999.00, 0.00), (4, 5, 2, 599.00, 0.00),   (4, 6, 1, 899.00, 5.00), 
(5, 2, 1, 79999.00, 0.00), (6, 8, 1, 8999.00, 0.00),  (7, 4, 1, 49999.00, 0.00), 
(8, 1, 1, 74999.00, 0.00), (8, 4, 1, 49999.00, 10.00), (8, 6, 2, 899.00, 0.00);

-- Inventory Logs Table
CREATE TABLE inventory_logs (log_id INT AUTO_INCREMENT PRIMARY KEY, product_id INT NOT NULL, change_qty INT NOT NULL, reason VARCHAR(100), log_date DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (product_id) REFERENCES product(product_id));
INSERT INTO inventory_logs(product_id, change_qty, reason) VALUES
(1, 20, 'New Stock Arrived'),
(2, -2, 'Customer Purchase'),
(3, 10, 'Supplier Restock'),
(4, -1, 'Customer Purchase'),
(5, -5, 'Damaged Items'),
(6, 15, 'Stock Replenishment'),
(7, -3, 'Customer Purchase'),
(8, 8, 'warehouse Transfer');
-- =====================================================
-- VERIFY DATA IN ALL TABLES
-- =====================================================
select*from Customer;
select*from categories;
select*from supplier;
select*from product;
select*from orders;
select*from order_item;
select*from inventory_logs;

-- Display Customers from Mumbai and Delhi

select customer_id, CONCAT(first_name,' ',last_name) as full_name, city from customers where city in ('Mumbai', 'Delhi');

-- Display Products Costing More Than ₹10,000 in Stock

SELECT product_name, price, stock_qty FROM product WHERE price > 10000 AND stock_qty > 0 ORDER BY price DESC;

-- Count Orders by Status

SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status ORDER BY total_orders DESC;

-- Find the Highest Priced Product in Each Category

SELECT c.category_name, p.product_name, MAX(p.price) AS max_price FROM product p JOIN categories c ON p.category_id = c.category_id GROUP BY c.category_name, p.product_name;

-- Display Order Details with Customer, Product and Total Amount

SELECT o.order_id, CONCAT(cu.first_name,' ',cu.last_name) AS customer_name, p.product_name, oi.quantity, oi.unit_price, ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100), 2) AS line_total FROM orders o
JOIN Customer cu ON o.customer_id = cu.customer_id 
JOIN order_item oi ON o.order_id = oi.order_id 
JOIN product p ON oi.product_id = p.product_id 
ORDER BY o.order_id;

-- Find Customers Who Have Not Placed Any Orders

SELECT cu.customer_id, CONCAT(cu.first_name,' ',cu.last_name) AS customer_name, cu.email FROM Customer cu LEFT JOIN orders o ON cu.customer_id = o.customer_id 
WHERE o.order_id IS NULL;

-- Display Top 5 Best-Selling Products by Revenue

SELECT p.product_name, SUM(oi.quantity) AS total_units_sold, ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS total_revenue FROM order_item oi 
JOIN product p ON oi.product_id = p.product_id 
JOIN orders o ON oi.order_id   = o.order_id 
WHERE o.status != 'Cancelled' GROUP BY p.product_name ORDER BY total_revenue DESC LIMIT 5;

-- Display Products Priced Above the Average Product Price

SELECT product_name, price FROM product WHERE price > (SELECT AVG(price) FROM product) ORDER BY price DESC;

-- Display Customers Who Have Spent More Than ₹1,00,000

SELECT cu.customer_id, CONCAT(cu.first_name,' ',cu.last_name) AS customer_name, total.spent FROM Customer cu JOIN (SELECT customer_id, SUM(total_amount) AS spent FROM orders
WHERE status != 'Cancelled' GROUP BY customer_id ) total ON cu.customer_id = total.customer_id 
WHERE total.spent > 100000 ORDER BY total.spent DESC;

-- Display Products That Need Reordering

SELECT product_name, stock_qty, reorder_level, (reorder_level - stock_qty) AS units_needed FROM product 
WHERE stock_qty < reorder_level AND is_active = 1 ORDER BY units_needed DESC;

-- Create & Display Monthly Sales Summary

CREATE VIEW vw_monthly_sales AS SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month, COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT o.customer_id) AS unique_customers, ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)), 2) AS revenue 
FROM orders o JOIN order_item oi ON o.order_id = oi.order_id WHERE o.status != 'Cancelled' GROUP BY sales_month ORDER BY sales_month;
SELECT * FROM vw_monthly_sales;

-- Create Stored Procedure & Display Customer Order History

DELIMITER $$ 
CREATE PROCEDURE sp_customer_history(IN p_customer_id INT) BEGIN SELECT o.order_id, o.order_date, o.status, p.product_name, oi.quantity,
ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100),2) AS paid_amount FROM orders o JOIN order_item oi ON o.order_id = oi.order_id 
JOIN product p ON oi.product_id = p.product_id WHERE o.customer_id = p_customer_id ORDER BY o.order_date DESC; 
END $$ 
DELIMITER ;
CALL sp_customer_history(1);

-- Create & Execute Stored Procedure to Update Order Status

DELIMITER $$ 
CREATE PROCEDURE sp_update_order_status(IN p_order_id INT, IN  p_new_status VARCHAR(20), OUT p_result VARCHAR(100)) 
BEGIN DECLARE v_current_status VARCHAR(20);
SELECT status INTO v_current_status FROM orders WHERE order_id = p_order_id; 
IF v_current_status = 'Delivered' OR v_current_status = 'Cancelled' THEN 
SET p_result = 'Error: Cannot change a Delivered or Cancelled order.'; 
ELSE UPDATE orders SET status = p_new_status WHERE order_id = p_order_id;
SET p_result = CONCAT('Order ', p_order_id, ' updated to ', p_new_status);
END IF; 
END $$ 
DELIMITER ;
CALL sp_update_order_status(3, 'Delivered', @msg); 
SELECT @msg;

-- Display Customer Spending Rank

SELECT CONCAT(cu.first_name,' ',cu.last_name) AS customer_name, ROUND(SUM(o.total_amount), 2) AS total_spent, 
RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank FROM Customer cu 
JOIN orders o ON cu.customer_id = o.customer_id 
WHERE o.status != 'Cancelled' 
GROUP BY cu.customer_id, customer_name;

-- Display Cumulative Monthly Revenue

SELECT sales_month, revenue, ROUND(SUM(revenue) OVER (ORDER BY sales_month), 2) AS cumulative_revenue FROM vw_monthly_sales;

-- Display Monthly Revenue Growth Percentage

SELECT sales_month, revenue, LAG(revenue) OVER (ORDER BY sales_month) AS prev_month_revenue, ROUND((revenue - LAG(revenue) OVER (ORDER BY sales_month))
/ LAG(revenue) OVER (ORDER BY sales_month) * 100, 2) AS growth_pct FROM vw_monthly_sales;

-- Start Transaction for a New Customer Order

START TRANSACTION;

-- Insert New Order
INSERT INTO orders (customer_id, order_date, status, total_amount, shipping_city) VALUES (3, NOW(), 'Pending', 74999.00, 'Delhi'); 

-- Store the Newly Generated Order ID
SET @new_order_id = LAST_INSERT_ID(); 

-- Insert Order Items
INSERT INTO order_item (order_id, product_id, quantity, unit_price, discount_pct) VALUES (@new_order_id, 1, 1, 74999.00, 0.00); 

-- Update Product Stock
UPDATE product SET stock_qty = stock_qty - 1 WHERE product_id = 1;

-- Record Inventory Movement
INSERT INTO inventory_logs (product_id, change_qty, reason) VALUES (1, -1, 'Sold via Order'); 
 
-- Commit Transaction
COMMIT;

-- Create Index on Customer ID in Orders Table
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Create Index on Order Date in Orders Table
CREATE INDEX idx_orders_date ON orders(order_date);

-- Create Composite Index on Order ID and Product ID
CREATE INDEX idx_items_order_product ON order_items(order_id, product_id);

-- Create Index on Product Price
CREATE INDEX idx_products_price ON products(price);

-- Display Indexes in Orders Table
SHOW INDEX FROM orders;

-- Display Indexes in Order Item Table
SHOW INDEX FROM order_item;

-- Explain Query Execution Plan
EXPLAIN SELECT * FROM orders WHERE customer_id = 1 AND order_date > '2023-01-01';

-- =====================================================
-- End of Project
-- Retail Sales & Inventory Management System
-- =====================================================

