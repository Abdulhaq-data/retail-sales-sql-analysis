-- UK Retail Customer & Sales Analysis
-- PostgreSQL Portfolio Project
-- Database: retail_sales_analysis

-- ============================================================
-- SECTION 1: TABLE SETUP
-- ============================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    channel VARCHAR(20),
    discount NUMERIC(5,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO customers
(customer_id, customer_name, city, region, signup_date)
VALUES
(1, 'James Smith', 'London', 'London', '2024-01-15'),
(2, 'Emma Jones', 'Manchester', 'North West', '2024-02-10'),
(3, 'Oliver Brown', 'Leeds', 'Yorkshire & Humber', '2024-03-05'),
(4, 'Sophia Wilson', 'Bristol', 'South West', '2024-04-12'),
(5, 'George Taylor', 'Cambridge', 'East of England', '2024-05-20');

INSERT INTO products
(product_id, product_name, category, unit_price, unit_cost)
VALUES
(1, 'Laptop', 'Electronics', 899.99, 650.00),
(2, 'Headphones', 'Electronics', 79.99, 45.00),
(3, 'T-Shirt', 'Clothing', 24.99, 10.00),
(4, 'Face Cream', 'Health & Beauty', 19.99, 8.00),
(5, 'Football', 'Sports', 29.99, 15.00),
(6, 'Desk Lamp', 'Home & Garden', 39.99, 20.00);

INSERT INTO orders
(order_id, customer_id, product_id, order_date, quantity, channel, discount)
VALUES
(1, 1, 1, '2025-01-10', 1, 'Online', 0.05),
(2, 2, 2, '2025-01-18', 2, 'Store', 0.00),
(3, 3, 3, '2025-02-05', 3, 'Online', 0.10),
(4, 4, 4, '2025-02-20', 2, 'Store', 0.05),
(5, 5, 5, '2025-03-08', 4, 'Online', 0.00),
(6, 1, 6, '2025-03-22', 2, 'Store', 0.10),
(7, 2, 1, '2025-04-11', 1, 'Online', 0.05),
(8, 3, 2, '2025-05-03', 2, 'Online', 0.00),
(9, 4, 3, '2025-06-15', 5, 'Store', 0.10),
(10, 5, 6, '2025-07-07', 3, 'Online', 0.05);

-- ============================================================
-- SECTION 3: ANALYSIS QUERIES
-- ============================================================

-- Joined transaction-level sales view
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.region,
    p.product_name,
    p.category,
    o.quantity,
    o.channel,
    p.unit_price,
    o.discount,
    ROUND(o.quantity * p.unit_price * (1 - o.discount), 2) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_date;

-- Core KPIs
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue,
    ROUND(SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost)), 2) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- Revenue and profit by category
SELECT
    p.category,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue,
    ROUND(SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost)), 2) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Monthly revenue trend
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS month,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;

-- Revenue by channel
SELECT
    o.channel,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY o.channel
ORDER BY total_revenue DESC;

-- Revenue by region
SELECT
    c.region,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.region
ORDER BY total_revenue DESC;

-- Profit margin %
SELECT
    ROUND(
        (
            SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost))
            / SUM(o.quantity * p.unit_price * (1 - o.discount))
        ) * 100,
        2
    ) AS profit_margin_percent
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- Average order value
SELECT
    ROUND(
        SUM(o.quantity * p.unit_price * (1 - o.discount))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- Top-selling products
SELECT
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY units_sold DESC;

-- Customer value analysis
SELECT
    c.customer_name,
    c.city,
    c.region,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS units_purchased,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city, c.region
ORDER BY total_spent DESC;

-- Discount impact
SELECT
    ROUND(SUM(o.quantity * p.unit_price), 2) AS revenue_before_discount,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS actual_revenue,
    ROUND(SUM(o.quantity * p.unit_price * o.discount), 2) AS discount_given,
    ROUND(
        SUM(o.quantity * p.unit_price * o.discount)
        / SUM(o.quantity * p.unit_price) * 100,
        2
    ) AS effective_discount_percent
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- Product profitability
SELECT
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS revenue,
    ROUND(SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost)), 2) AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY profit DESC;

-- Profit margin by product
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS revenue,
    ROUND(SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost)), 2) AS profit,
    ROUND(
        (
            SUM((o.quantity * p.unit_price * (1 - o.discount)) - (o.quantity * p.unit_cost))
            / SUM(o.quantity * p.unit_price * (1 - o.discount))
        ) * 100,
        2
    ) AS profit_margin_percent
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY profit_margin_percent DESC;

-- Rank products by revenue
SELECT
    p.product_name,
    ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(o.quantity * p.unit_price * (1 - o.discount)) DESC
    ) AS revenue_rank
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue_rank;

-- Cumulative revenue
WITH product_sales AS (
    SELECT
        p.product_name,
        ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    total_revenue,
    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM product_sales
ORDER BY total_revenue DESC;

-- Revenue contribution %
WITH product_sales AS (
    SELECT
        p.product_name,
        ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    total_revenue,
    ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS revenue_contribution_percent
FROM product_sales
ORDER BY total_revenue DESC;

-- Pareto-style cumulative revenue %
WITH product_sales AS (
    SELECT
        p.product_name,
        ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    total_revenue,
    ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS revenue_percent,
    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        / SUM(total_revenue) OVER () * 100,
        2
    ) AS cumulative_revenue_percent
FROM product_sales
ORDER BY total_revenue DESC;

-- ABC product classification
WITH product_sales AS (
    SELECT
        p.product_name,
        ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS total_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name
),
revenue_analysis AS (
    SELECT
        product_name,
        total_revenue,
        ROUND(
            SUM(total_revenue) OVER (
                ORDER BY total_revenue DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
            / SUM(total_revenue) OVER () * 100,
            2
        ) AS cumulative_revenue_percent
    FROM product_sales
)
SELECT
    product_name,
    total_revenue,
    cumulative_revenue_percent,
    CASE
        WHEN cumulative_revenue_percent <= 80 THEN 'A'
        WHEN cumulative_revenue_percent <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM revenue_analysis
ORDER BY total_revenue DESC;

-- Month-over-month growth using LAG()
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        ROUND(SUM(o.quantity * p.unit_price * (1 - o.discount)), 2) AS monthly_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', o.order_date)
),
revenue_comparison AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue)
        / previous_month_revenue * 100,
        2
    ) AS growth_percent
FROM revenue_comparison
ORDER BY month;
