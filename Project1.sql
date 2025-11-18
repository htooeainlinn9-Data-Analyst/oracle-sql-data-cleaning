-- Drop table if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customer_orders_raw';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Create raw messy table
CREATE TABLE customer_orders_raw (
    order_id        VARCHAR2(10),
    customer_name   VARCHAR2(100),
    email           VARCHAR2(100),
    phone           VARCHAR2(50),
    order_date      VARCHAR2(50),
    order_amount    VARCHAR2(50),
    country         VARCHAR2(50)
);

-- Insert dirty data
INSERT ALL
INTO customer_orders_raw VALUES ('001', ' John Doe ', 'john.doe@gmail', ' 091234567', '12-5-2024', '120', 'usa')
INTO customer_orders_raw VALUES ('002', 'john doe', 'JOHN.DOE@gmail.com ', '91234567 ', '2024/05/12', '120.00', 'USA')
INTO customer_orders_raw VALUES ('003', 'Mary  Smith', 'mary.smith at yahoo.com', ' +1-555-8888', '05-13-24', '250', 'United states')
INTO customer_orders_raw VALUES ('004', '  James Lee', NULL, '12345678', '20240513', 'invalid', 'singapore ')
INTO customer_orders_raw VALUES ('005', 'Anna     Kim', 'anna.kim@gmail.com', '+65 9876 5432', '13/05/2024', '300', 'SINGAPORE')
INTO customer_orders_raw VALUES ('006', 'anna kim', '   ANNA.KIM@gmail.com', '98765432', '2024.05.13', '300.0', 'Singapore')
INTO customer_orders_raw VALUES ('003', 'Mary  Smith', 'mary.smith at yahoo.com', ' +1-555-8888', '05-13-24', '250', 'United states') -- duplicate
INTO customer_orders_raw VALUES ('007', '   Tom   Brown', 'tom.brown@@gmail.com', NULL, '13/5/24', '1000', 'UK')
INTO customer_orders_raw VALUES ('008', 'Lisa Wong', 'lisawonggmail.com', ' 090 345 5432', NULL, '450', 'malaysia')
INTO customer_orders_raw VALUES ('009', 'Bob  Chan', 'bob.chan@hotmail.com', '     ', '2024-05-14', '999999', 'Singapore')
SELECT * FROM dual;


SELECT * FROM customer_orders_raw;

SELECT order_id, COUNT(*) 
FROM customer_orders_raw
GROUP BY order_id
HAVING COUNT(*) > 1;

CREATE TABLE customer_orders_dedup AS
SELECT *
FROM (
    SELECT 
        cr.*,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS rn
    FROM customer_orders_raw cr
)
WHERE rn = 1;

SELECT * FROM customer_orders_dedup;

CREATE TABLE customer_orders_clean1 AS
SELECT
    order_id,
    INITCAP(TRIM(REGEXP_REPLACE(customer_name, '\s+', ' '))) AS customer_name,
    email,
    phone,
    order_date,
    order_amount,
    country
FROM customer_orders_dedup;

SELECT * FROM customer_orders_clean1;

CREATE TABLE customer_orders_clean2 AS
SELECT
    order_id,
    customer_name,
    LOWER(TRIM(email)) AS email,
    phone,
    order_date,
    order_amount,
    country
FROM customer_orders_clean1;

SELECT * FROM customer_orders_clean2;


CREATE TABLE customer_orders_clean3 AS
SELECT
    order_id,
    customer_name,
    email,
    REGEXP_REPLACE(phone, '[^0-9]', '') AS phone,
    order_date,
    order_amount,
    country
FROM customer_orders_clean2;

SELECT * FROM customer_orders_clean3;

CREATE TABLE customer_orders_clean4 AS
SELECT
    order_id,
    customer_name,
    email,
    phone,
    CASE
        WHEN REGEXP_LIKE(order_date, '^\d{4}-\d{2}-\d{2}$') 
            THEN TO_DATE(order_date, 'YYYY-MM-DD')
        WHEN REGEXP_LIKE(order_date, '^\d{4}/\d{2}/\d{2}$') 
            THEN TO_DATE(order_date, 'YYYY/MM/DD')
        WHEN REGEXP_LIKE(order_date, '^\d{2}-\d{2}-\d{4}$') 
            THEN TO_DATE(order_date, 'DD-MM-YYYY')
        WHEN REGEXP_LIKE(order_date, '^\d{2}/\d{2}/\d{4}$') 
            THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN REGEXP_LIKE(order_date, '^\d{2}-\d{2}-\d{2}$') 
            THEN TO_DATE(order_date, 'MM-DD-YY')
        ELSE NULL
    END AS order_date,
    order_amount,
    country
FROM customer_orders_clean3;

SELECT * FROM customer_orders_clean4;

CREATE TABLE customer_orders_clean5 AS
SELECT
    order_id,
    customer_name,
    email,
    phone,
    order_date,
    order_amount,
    INITCAP(TRIM(country)) AS country
FROM customer_orders_clean4;


SELECT * FROM customer_orders_clean5;

CREATE TABLE customer_orders_clean AS
SELECT
    order_id,
    customer_name,
    email,
    phone,
    order_date,
    CASE
        WHEN REGEXP_LIKE(order_amount, '^[0-9]+(\.[0-9]+)?$') 
            THEN TO_NUMBER(order_amount)
        ELSE NULL
    END AS order_amount,
    country
FROM customer_orders_clean5;

SELECT * FROM customer_orders_clean;


SELECT COUNT(*) AS total_orders 
FROM customer_orders_clean;


SELECT SUM(order_amount) AS total_revenue 
FROM customer_orders_clean;

SELECT ROUND(AVG(order_amount),2) AS avg_order_value
FROM customer_orders_clean;

SELECT country, COUNT(*) AS total_orders
FROM customer_orders_clean
GROUP BY country
ORDER BY total_orders DESC;

SELECT 
    customer_name,
    NVL(TO_CHAR(SUM(order_amount)),'Cannot defined') AS total_spent
FROM customer_orders_clean
GROUP BY customer_name
ORDER BY total_spent DESC;

SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(order_amount) AS total_revenue
FROM customer_orders_clean
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

SELECT *
FROM customer_orders_clean
WHERE email IS NULL 
   OR phone IS NULL
   OR order_date IS NULL
   OR order_amount IS NULL;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customer_orders_final';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE customer_orders_final AS
SELECT
    order_id,
    customer_name,
    email,
    phone,
    order_date,
    order_amount,
    country
FROM customer_orders_clean
ORDER BY order_date;

SELECT * FROM customer_orders_final;

