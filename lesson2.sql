CREATE TABLE lesson2.customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE lesson2.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES lesson2.customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE
);

INSERT INTO lesson2.customer(full_name, email, phone)
SELECT
    'Customer ' || i,
    'customer' || i || '@gmail.com',
    '090' || LPAD(i::text, 7, '0')
FROM generate_series(1,100) AS i;

INSERT INTO lesson2.orders(customer_id, total_amount, order_date)
SELECT
    (RANDOM() * 99 + 1)::INT,
    (RANDOM() * 2000000 + 100000)::NUMERIC(10,2),
    CURRENT_DATE - (RANDOM() * 365)::INT
FROM generate_series(1,300);

CREATE VIEW v_order_summary AS
SELECT c.full_name, o.total_amount,o.order_date
FROM lesson2.customer c
JOIN lesson2.orders o
ON c.customer_id = o.customer_id;

SELECT * FROM v_order_summary;

CREATE VIEW v_high_value_orders AS
SELECT
    o.order_id,
    c.full_name,
    o.total_amount,
    o.order_date
FROM lesson2.customer c
JOIN lesson2.orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount >= 1000000;

UPDATE lesson2.orders
SET total_amount = 1500000
WHERE order_id = 1;
SELECT * FROM v_high_value_orders
WHERE order_id = 1;

-- một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
CREATE VIEW v_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    SUM(total_amount) AS total_revenue
FROM lesson2.orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY sales_month;

SELECT * FROM v_monthly_sales;
--drop view
DROP VIEW v_order_summary;
