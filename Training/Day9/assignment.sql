CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    country_id INT REFERENCES countries(id)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city_id INT REFERENCES cities(id)
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category_id INT REFERENCES categories(id),
    supplier_id INT REFERENCES suppliers(id)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    order_date DATE,
    total_amount NUMERIC
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT,
    price NUMERIC
);

INSERT INTO countries (name) VALUES
('India'),
('USA');

INSERT INTO cities (name, country_id) VALUES
('Mumbai', 1),
('Delhi', 1),
('New York', 2),
('Chicago', 2);

INSERT INTO customers (name, city_id) VALUES
('Alice', 1),
('Bob', 2),
('Charlie', 3),
('David', 4),
('Eve', 1),
('Frank', 3);

INSERT INTO suppliers (name) VALUES
('Supplier A'),
('Supplier B');

INSERT INTO categories (name) VALUES
('Electronics'),
('Clothing');

INSERT INTO products (name, category_id, supplier_id) VALUES
('Laptop', 1, 1),
('Phone', 1, 2),
('Shirt', 2, 1),
('Jeans', 2, 2);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 1000),
(1, '2025-02-01', 500),
(2, '2025-01-10', 700),
(3, '2025-01-15', 1200),
(4, '2025-01-20', 400),
(5, '2025-02-10', 900),
(6, '2025-02-15', 1100);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1000),
(2, 2, 1, 500),
(3, 3, 2, 350),
(4, 1, 1, 1200),
(5, 4, 1, 400),
(6, 2, 1, 900),
(7, 1, 1, 1100);

SELECT country_name, customer_name, total_spent
FROM (
    SELECT 
        co.name AS country_name,
        c.name AS customer_name,
        SUM(o.total_amount) AS total_spent,
        DENSE_RANK() OVER (
            PARTITION BY co.name 
            ORDER BY SUM(o.total_amount) DESC
        ) AS rnk
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    JOIN cities ci ON c.city_id = ci.id
    JOIN countries co ON ci.country_id = co.id
    GROUP BY co.name, c.name
) sub
WHERE rnk <= 3;