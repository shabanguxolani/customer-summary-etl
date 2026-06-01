-- ======================================================================================================
-- ETL PIPELINE: Customer Summary
-- Purpose:  Extract customer order data and summarize total orders and spending,   
--           categorize customers by spending behavior, flag cancelled and returned orders as   
--           per stakeholder requirements, and enforce data quality checks including
--           null detection, duplicate detection, whitespace detection, and categorical value validation
-- Database: SQL Server 2025 Express Edition
-- Author:   Xolani Shabangu
-- Date:     2024-01-15
-- =====================================================================================================

-- =======================================================================================
-- CREATE TARGET TABLE
-- =======================================================================================
USE e_commerce
GO

DROP TABLE IF EXISTS Customer_Summary;

CREATE TABLE  Customer_Summary (
      [Customer_Id] 		[INT],
      [Full_Name] 			[VARCHAR] (50) NULL,
      [Total_Orders] 		[INT],
      [Total_Spending] 		[INT],
  	  [Shipping_Status] 	[VARCHAR] (50) NULL,
 	  [Spending_Category]	[VARCHAR](50) NULL

);

-- ======================================================================================
-- EXTRACT, TRANSFORM & LOAD
-- ======================================================================================

WITH Customer_Summary_CTE AS (
	SELECT
        C.customers_id 				AS Customer_Id,
        CONCAT(C.first_name, ' ', C.last_name)	AS Full_Name,
        COUNT(O.order_id) 				AS Total_Orders,   
        SUM(O.amount) 					AS Total_Spending,        
        S.[status]						AS Shipping_status
	FROM Customers	AS C
	LEFT JOIN Orders AS O
		ON C.customers_id = O.customer_id
	LEFT JOIN Shipping AS S
   		ON C.customers_id = S.customers
	GROUP BY C.customers_id, first_name, last_name, S.status
),
Order_Category AS (
 	 SELECT 
		Customer_Id,
        Total_Spending,
        CASE
              WHEN Total_Spending < 1000 THEN 'Low Spender'
              WHEN Total_Spending >= 1000 AND Total_Spending <= 5000 THEN 'Mid Spender'
              WHEN Total_Spending > 5000 THEN 'High Spender'
              ELSE 'Unkown'  
          END AS Spending_Category
	FROM Customer_Summary_CTE
)

INSERT INTO Customer_Summary
SELECT 
	C.Customer_Id,
    C.Full_Name,
    C.Total_Orders,
    C.Total_Spending,
    C.Shipping_Status,
    O.Spending_Category

FROM Customer_Summary_CTE AS C
LEFT JOIN Order_Category AS O
ON C.Customer_Id = O.Customer_Id;

SELECT * FROM Customer_Summary;

-- ======================================================================================
-- Data Quality Checks
-- ======================================================================================

WITH duplicate_check AS (                  -- Checking for Duplicates                  
    SELECT *,
        ROW_NUMBER() OVER 
        (
            PARTITION BY Customer_Id, Full_Name, Total_Orders, Total_Spending, 
                         Shipping_Status,Spending_Category ORDER BY Customer_Id
        ) AS row_num

    FROM Customer_Summary
 )                         
SELECT * 
FROM duplicate_check
WHERE row_num > 1; 

-- ======================================================================================
-- Whitespace & Trailing Space Detection & Detects misspelled or invalid category values
-- ======================================================================================

SELECT LEN(Full_Name), LEN(TRIM(Full_Name)) FROM Customer_Summary                   -- Found Clean 
SELECT LEN(Shipping_Status), LEN(TRIM(Shipping_Status)) FROM Customer_Summary       -- Found Clean
SELECT LEN(Spending_Category), LEN(TRIM(Spending_Category)) FROM Customer_Summary   -- Found Clean

-- Detects misspelled or invalid category values

SELECT Shipping_Status FROM Customer_Summary

UPDATE Customer_Summary
    SET Shipping_Status = 'Delivered'
    WHERE Shipping_Status LIKE '%DELIVERED%'

UPDATE Customer_Summary
    SET Full_Name = 'Robert Luna'
    WHERE Customer_Id = 2;

UPDATE Customer_Summary
    SET Spending_Category = 'Cancelled Order' 
    WHERE Shipping_Status LIKE 'Cancelled%'

UPDATE Customer_Summary
    SET Spending_Category = 'Returned Order' 
    WHERE Shipping_Status LIKE 'Returned%'

UPDATE Customer_Summary 
    SET Total_Orders=0,
        Total_Spending = 0
    WHERE Shipping_Status IN ('Cancelled', 'Returned');
    
SELECT * FROM Customer_Summary		-- Verify

-- ======================================================================================
--  Redundant Row Detection - Identifies rows with no business value
-- ======================================================================================

SELECT Total_Orders, Total_Spending			-- Checking For Nulls and Empty Spaces
FROM Customer_Summary
WHERE (Total_Orders = 0 OR Total_Orders IS NULL)
AND   (Total_Spending = 0 OR Total_Spending IS NULL);

DELETE 
    FROM Customer_Summary
 WHERE	(Total_Orders = 0 OR Total_Orders IS NULL)
	AND (Total_Spending = 0 OR Total_Spending IS NULL);

SELECT * FROM Customer_Summary		-- Verify

-- ======================================================================================
-- Summary Report
-- ======================================================================================

SELECT 
    Spending_Category,
    COUNT(*)            AS Total_Customers,
    SUM(Total_Spending) AS Total_Revenue
FROM Customer_Summary
GROUP BY Spending_Category
ORDER BY Total_Revenue DESC;



