# 📊 Oracle SQL Data Cleaning Project — Customer Orders Dataset

## 🔥 Overview  
This project focuses on cleaning and preparing a messy **Customer Orders** dataset using **Oracle SQL Developer**.  

The raw dataset intentionally included:  
- Duplicate rows  
- Null values  
- Invalid email formats  
- Wrong and inconsistent date formats  
- Mixed uppercase/lowercase names  
- Phone numbers with symbols/spaces  
- Numeric values stored as text  
- Outliers  
- Extra whitespace  

The goal was to transform this messy data into a clean, analysis-ready dataset.

---

## 🛠️ Objective  
Perform **end-to-end SQL data cleaning** using Oracle SQL, and deliver a final clean table suitable for analytics or reporting.

---

## 📌 Key Data Cleaning Steps

### ✔ 1. Remove duplicate rows  
Used `ROW_NUMBER()` analytic function with `PARTITION BY order_id`.

### ✔ 2. Standardize customer names  
- Trim spaces  
- Remove extra spaces between words  
- Convert to Proper Case (`INITCAP`)

### ✔ 3. Clean email formatting  
- Convert to lowercase  
- Remove spaces  
- Identify invalid emails

### ✔ 4. Clean phone numbers  
- Remove all non-numeric characters using `REGEXP_REPLACE('[^0-9]','')`

### ✔ 5. Standardize dates  
Converted multiple messy date formats into valid Oracle `DATE` type using conditional `TO_DATE()`.

### ✔ 6. Clean numeric values  
- Convert text numbers to NUMBER  
- Invalid strings → NULL

### ✔ 7. Standardize country names  
- Trim  
- Proper Case  
- Remove spacing inconsistencies

### ✔ 8. Create final clean table  
`customer_orders_final` is fully optimized for reporting and analysis.

---

## 🗄 Final Clean Table: `customer_orders_final`
Includes:
- `order_id`  
- `customer_name`  
- `email`  
- `phone`  
- `order_date`  
- `order_amount`  
- `country`  

All fields are cleaned, validated, and standardized.

---

## 📂 Files Included
- **customer_orders_cleaned.csv** — final cleaned dataset  
- **data_cleaning_script.sql** — complete SQL script for all cleaning steps  
- **README.md** — project documentation  

---

## 📊 Analysis Queries Included  
- Total revenue  
- Total number of orders  
- Average order value  
- Orders by country  
- Monthly revenue trend  
- Top customers by spending  
- Missing or problematic data summary  

---

## 🧰 Tools Used  
- Oracle SQL Developer  
- Oracle Database 19c  
- SQL (DDL, DML, Analytic Functions, Date Functions, Regex)

---

## 📘 Learning Outcomes  
Through this project, I strengthened my skills in:
- Data cleaning  
- Regex for data validation  
- Date handling in Oracle  
- Analytic functions  
- Building reproducible SQL workflows  
- Preparing datasets for analytics  

---

## 👤 Author  
**Htoo Eain Linn**  
Aspiring Data Analyst  
- Oracle SQL  
- MySQL  
- Power BI  
- Excel  

---

