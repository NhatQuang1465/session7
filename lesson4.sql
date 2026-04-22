CREATE TABLE lesson4.customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE lesson4.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES lesson4.customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE lesson4. product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

CREATE TABLE lesson4.order_detail (
    order_id INT REFERENCES lesson4.orders(order_id),
    product_id INT REFERENCES lesson4.product(product_id),
    quantity INT
);

-- Tạo View tổng doanh thu theo khu vực

CREATE VIEW v_revenue_by_region AS
SELECT 
    c.region,
    SUM(o.total_amount) AS total_revenue
FROM lesson4.customer c
JOIN lesson4.orders o 
ON c.customer_id = o.customer_id
GROUP BY c.region;

-- Xem top 3 khu vực có doanh thu cao nhất
SELECT *
FROM v_revenue_by_region
ORDER BY total_revenue DESC
LIMIT 3;

-- Tạo Nested View
-- Hiển thị khu vực có doanh thu lớn hơn trung bình
CREATE VIEW v_revenue_above_avg AS
SELECT *
FROM v_revenue_by_region
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM v_revenue_by_region
);

-- Xem kết quả Nested View
SELECT *
FROM v_revenue_above_avg;