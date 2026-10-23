# UK Retail Customer and Sales Analysis with PostgreSQL

## Project Overview

This portfolio project demonstrates how PostgreSQL can be used to
analyse retail customer and sales data stored in a relational database.

The database contains three related tables: **customers**, **products**,
and **orders**. SQL queries are used to combine these tables and answer
business questions about revenue, profitability, customers, products,
discounts, sales channels, regional performance, and monthly sales
trends.

> **Note:** This project uses a small synthetic/sample dataset created
> for SQL practice and portfolio demonstration. The findings illustrate
> the analytical workflow rather than representing a real company's
> performance.

## Tools & Skills

-   PostgreSQL
-   pgAdmin 4
-   Relational database design
-   Primary and foreign keys
-   `JOIN`
-   `GROUP BY`
-   Aggregate functions
-   CTEs (`WITH`)
-   `CASE`
-   Window functions
-   `RANK()`
-   `LAG()`
-   Running totals
-   ABC / Pareto-style analysis

## Database Structure

### customers

Stores customer information including customer name, city, region, and
signup date.

### products

Stores product information including product name, category, selling
price, and unit cost.

### orders

Stores transaction information including customer, product, order date,
quantity, sales channel, and discount.

The `orders` table connects to `customers` and `products` through
foreign keys.

## Business Questions

The analysis answers questions such as:

1.  What are total revenue, total profit, total orders, units sold,
    profit margin, and average order value?
2.  Which product categories generate the most revenue and profit?
3.  How does revenue change by month?
4.  Which sales channel generates the most revenue?
5.  Which regions generate the most revenue?
6.  Which products sell the most units?
7.  Who are the highest-value customers?
8.  How much revenue is reduced through discounts?
9.  Which products generate the most profit?
10. Which products have the highest profit margins?
11. How concentrated is revenue across products?
12. Which products fall into A, B, and C revenue classes?
13. How does monthly revenue change compared with the previous month?

## Key Results

Using the sample dataset:

-   **Total Orders:** 10
-   **Units Sold:** 25
-   **Total Revenue:** £2,553.76
-   **Total Profit:** £817.76
-   **Profit Margin:** 32.02%
-   **Average Order Value:** £255.38
-   **Revenue Before Discounts:** £2,679.75
-   **Discount Value:** £125.99
-   **Effective Discount Rate:** 4.70%

## Query results

The screenshots below show the core KPI and category queries executed in pgAdmin with PostgreSQL 18. The displayed results agree with the sample totals above. These screenshots verify those two outputs; they do not establish that every analysis query has been tested.

### Core KPIs

![Core KPI query and results](screenshots/core-kpis.png)

### Revenue and profit by category

![Category revenue and profit query results](screenshots/category-results.png)

## Key Insights

### Revenue concentration

Laptop sales generated **£1,709.98**, representing **66.96% of total
revenue**. Laptop and Headphones together contributed **79.49%**,
showing that revenue in this sample is highly concentrated in the top
two products.

### Sales volume vs profitability

T-Shirt was the highest-selling product by quantity with **8 units**,
but Laptop generated the highest absolute profit at **£409.98**. This
demonstrates why product performance should be assessed using multiple
metrics rather than units sold alone.

### Profit vs profit margin

Face Cream produced the highest product profit margin at **57.87%**,
while Laptop generated the highest absolute profit despite a lower
margin of **23.98%**.

### Customer value

Emma Jones was the highest-value customer in the sample, generating
**£1,014.97** in spending. Customer spending varied substantially even
though each customer placed the same number of orders.

### Channel performance

Online sales generated substantially more revenue than Store sales in
the sample dataset.

### ABC analysis

Products were classified according to cumulative revenue contribution:

-   **A:** Laptop, Headphones
-   **B:** Desk Lamp, T-Shirt
-   **C:** Football, Face Cream

This highlights which products contribute most strongly to overall
revenue.

## Advanced SQL Techniques

The project goes beyond basic queries by using window functions and
CTEs.

### Product Ranking

`RANK() OVER()` is used to rank products according to revenue.

### Running Revenue

`SUM() OVER()` calculates cumulative product revenue without collapsing
individual product rows.

### Revenue Contribution

Window functions calculate each product's percentage contribution to
overall revenue.

### ABC Classification

A CTE, cumulative revenue percentage, and `CASE` statement classify
products into A, B, and C groups.

### Month-over-Month Growth

`LAG()` retrieves the previous month's revenue so month-over-month
growth can be calculated.

The query compares consecutive months present in the data. For a dataset with missing months, add a calendar of months before interpreting the result as calendar month-over-month growth.

Because the dataset contains only a small number of orders, large
monthly percentage changes should be interpreted as demonstrations of
the SQL technique rather than robust evidence of a recurring business
trend.

## Repository Structure

``` text
retail-sales-sql-analysis/
│
├── README.md
├── retail_sales_analysis_complete.sql
└── screenshots/
    ├── core-kpis.png
    └── category-results.png
```

## SQL File

`retail_sales_analysis_complete.sql` contains:

-   Table creation
-   Sample data insertion
-   Transaction-level joins
-   Business KPI calculations
-   Category, channel, region, customer, and product analysis
-   Discount analysis
-   Product profitability analysis
-   Revenue ranking
-   Cumulative revenue
-   Revenue contribution percentages
-   Pareto-style analysis
-   ABC classification
-   Month-over-month growth

## How to Run

1.  Install PostgreSQL and pgAdmin 4.
2.  Create a database called `retail_sales_analysis`.
3.  Open the Query Tool.
4.  Open `retail_sales_analysis_complete.sql`.
5.  On a fresh database, run the table setup and sample-data sections
    first.
6.  Run the analysis queries individually to explore the results.

If the tables and data already exist, skip the setup and insert sections
to avoid duplicate-table or duplicate-key errors.

## Portfolio Summary

This project demonstrates practical SQL skills for a junior data analyst
role, including relational data modelling, multi-table joins, business
KPI calculations, customer and product analysis, CTEs, conditional
logic, and window functions.
