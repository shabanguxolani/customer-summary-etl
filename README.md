# Customer Summary ETL Pipeline 🚀

## Hey, I'm Xolani 👋

I'm on a journey to become a data professional and I commit to learning SQL for at least 2 hours every day. This project is one of the results of that journey.

I wanted to build something that felt real — not just a SELECT statement, but an actual pipeline that takes messy raw data, cleans it up, applies business rules, and delivers something a stakeholder could actually use.

---

## What Inspired This Project

I kept hearing that data in the real world is never clean. So I decided to prove that to myself. I created a database with intentionally dirty data — wrong casing, null values, negative ages, duplicate records, misspelled statuses — and then I built a pipeline to deal with all of it.

By the end I had a clean, structured summary report that answers a real business question:

> *"How are our customers spending, and what happened to the cancelled and returned orders?"*

---

## What The Pipeline Does

It starts with three raw tables — Customers, Orders and Shipping — and works through the following stages:

**Extract & Transform**  
I joined all three tables together using CTEs and aggregated each customer's total orders and spending. Then I used CASE WHEN logic to categorize every customer as a Low, Mid or High Spender based on how much they spent.

**Load**  
The transformed data gets loaded into a clean target table called Customer_Summary.

**Data Quality Checks**  
This was the most important part. I ran the following checks against the loaded data:

- Null and empty value detection
- Duplicate detection using ROW_NUMBER() and PARTITION BY
- Whitespace detection by comparing LEN() against LEN(TRIM())
- Categorical value validation to catch misspelled statuses
- Redundant row detection for records with no business value
- Name casing correction using UPPER() and LOWER()

**Business Rules**  
The stakeholders needed to keep cancelled and returned orders in the report — not delete them. So instead of removing those records I flagged them, set their Total Orders and Total Spending to zero, and gave them their own Spending Category label. That way the data is honest and the report is complete.

---

## The Final Output

| Spending Category | Total Customers | Total Revenue |
|---|---|---|
| High Spender | 2 | 27700 |
| Mid Spender | 4 | 6580 |
| Low Spender | 2 | 880 |
| Cancelled Order | 2 | 0 |
| Returned Order | 1 | 0 |

---

## What I Learned

- Writing CTEs makes complex queries so much easier to read and maintain
- Data quality is not something you do at the end — it has to be part of the pipeline
- Business rules matter as much as the technical logic
- Asking "why" before deleting anything is always the right move

---

## Tools Used

- SQL Server 2022 Express Edition
- T-SQL
- CTEs and Window Functions
- DDL and DML

---

## Files

| File | What It Contains |
|---|---|
| `ddl_ecommerce_table_creation.sql` | All CREATE TABLE and INSERT scripts |
| `etl_customer_summary_ecommerce.sql` | The full ETL pipeline and DQ checks |

---

## Connect With Me

I post about my SQL learning journey on LinkedIn. If you are on a similar path feel free to connect — I would love to hear what you are building too.

📍 South Africa  
🔗 [LinkedIn](www.linkedin.com/in/xolani-shabangu)

---

> *"Data quality is not a final step — it is built into every layer of a reliable pipeline."*
