CREATE TABLE customers (
customer_id SERIAL PRIMARY KEY,
full_name VARCHAR(100),
email VARCHAR(100) UNIQUE,
city VARCHAR(50)
);

CREATE TABLE products (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(100),
category TEXT[],
price NUMERIC(10,2)
);

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
product_id INT REFERENCES products(product_id),
order_date DATE,
quantity INT
);

INSERT INTO customers (full_name, email, city) VALUES
('Nguyen Van A', '[a@gmail.com](mailto:a@gmail.com)', 'Hanoi'),
('Tran Thi B', '[b@gmail.com](mailto:b@gmail.com)', 'HCM'),
('Le Van C', '[c@gmail.com](mailto:c@gmail.com)', 'Danang'),
('Pham Thi D', '[d@gmail.com](mailto:d@gmail.com)', 'Hanoi'),
('Hoang Van E', '[e@gmail.com](mailto:e@gmail.com)', 'HCM');

INSERT INTO products (product_name, category, price) VALUES
('Laptop Dell', ARRAY['Electronics', 'Computer'], 1500),
('iPhone 14', ARRAY['Electronics', 'Phone'], 1200),
('Ao thun', ARRAY['Clothes'], 25),
('Giay Nike', ARRAY['Shoes', 'Sports'], 120),
('Tivi Samsung', ARRAY['Electronics'], 800);

INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
(1, 1, '2024-01-01', 1),
(1, 2, '2024-01-05', 2),
(2, 3, '2024-01-02', 5),
(3, 4, '2024-01-03', 1),
(4, 5, '2024-01-04', 1),
(2, 1, '2024-01-06', 1),
(5, 2, '2024-01-07', 3);

-- Email khách hàng ở Hà Nội
SELECT email FROM customers WHERE city = 'Hanoi';

-- Sản phẩm thuộc Electronics
SELECT * FROM products
WHERE 'Electronics' = ANY(category);

-- Sản phẩm giá từ 100 đến 1000
SELECT * FROM products
WHERE price BETWEEN 100 AND 1000;

EXPLAIN ANALYZE
SELECT * FROM customers WHERE email = '[a@gmail.com](mailto:a@gmail.com)';

EXPLAIN ANALYZE
SELECT * FROM products WHERE 'Electronics' = ANY(category);

EXPLAIN ANALYZE
SELECT * FROM products WHERE price BETWEEN 500 AND 1000;

-- TẠO INDEX
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_category ON products USING GIN(category);

-- EXPLAIN SAU INDEX
EXPLAIN ANALYZE
SELECT * FROM customers WHERE email = '[a@gmail.com](mailto:a@gmail.com)';

EXPLAIN ANALYZE
SELECT * FROM products WHERE 'Electronics' = ANY(category);

EXPLAIN ANALYZE
SELECT * FROM products WHERE price BETWEEN 500 AND 1000;

-- TOP 3 KHÁCH HÀNG MUA NHIỀU NHẤT
SELECT c.full_name, SUM(o.quantity) AS total_quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_quantity DESC
LIMIT 3;

-- VIEW
CREATE VIEW customer_view AS
SELECT customer_id, full_name, city
FROM customers;

-- Update qua VIEW
UPDATE customer_view
SET city = 'HCM'
WHERE customer_id = 1;

-- Xem dữ liệu VIEW
SELECT * FROM customer_view;
