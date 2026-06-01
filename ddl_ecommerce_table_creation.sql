
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

-- ==================================================================
-- Database Provisioning & Schema Design
-- ==================================================================

CREATE DATABASE e_commerce;

USE e_commerce
GO;

-- ==================================================================
-- Table Structure & Data Type Definition
-- ==================================================================

CREATE TABLE Customers (
		[customers_id][INT],
		[first_name][VARCHAR](100) NULL,
		[last_name][VARCHAR](100) NULL,
		[age][INT],
		[country][VARCHAR](100) NULL,
);

CREATE TABLE Orders (
		[order_id][INT],
		[item][VARCHAR](100) NULL,
		[amount][INT],
		[customer_id][INT]
);

CREATE TABLE Shipping (
		[shipping_id][INT],
		[status][INT],
		[customers][INT]
);

-- ==================================================================
--Source Data Ingestion — Customer Master Data
-- ==================================================================

INSERT INTO Customers
VALUES	(1,  'John',    'Doe',        31,  'USA'),
		(2,  'robert',  'Luna',       22,  'USA'),          
		(3,  'David',   'Robinson',   22,  'UK'),
		(4,  'John',    'Reinhardt',  25,  'UK'),
		(5,  'Betty',   'Doe',        28,  'UAE'),
		(6,  'john',    'doe',        31,  'USA'),           
		(7,  'James',   'Carter',     NULL,'Canada'),        
		(8,  'Sophia',  'Nguyen',     26,  'australia'),     
		(9,  'Michael', 'Torres',     41,  'USA'),
		(10, 'Emily',   'Clarke',     -5,  'UK'),            
		(11, 'Daniel',  'Fernandez',  37,  'Spain'),
		(12, NULL,      'Bennett',    30,  'Canada'),        
		(13, 'Liam',    'Patel',      27,  'India'),
		(14, 'Emma',    'Johansson',  33,  'Sweden'),
		(15, 'Noah',    'Kim',        999, 'South Korea'),   
		(16, 'Ava',     'Muller',     38,  'Germany'),
		(17, 'Thabo',   'Nkosi',      31,  'South Africa'),
		(18, 'Lerato',  'Dlamini',    27,  'South Africa'),
		(19, 'Ethan',   'Dubois',     32,  'FRANCE'),        
		(20, 'Mia',     NULL,         26,  NULL);
		
-- ==================================================================
-- Source Data Ingestion — Transactional Order Data
-- ==================================================================

INSERT INTO Orders
VALUES	(1,  'Keyboard',       400,    4),
		(2,  'Mouse',          300,    4),
		(3,  'Monitor',        12000,  3),
		(4,  'Keyboard',       400,    1),
		(5,  'Mousepad',       250,    2),
		(6,  'Laptop',         15000,  9),
		(7,  'Headphones',     850,    13),
		(8,  'Webcam',         1200,   17),
		(9,  'USB Hub',        350,    17),
		(10, 'Desk Lamp',      180,    18),
		(11, 'Monitor',        12000,  11),
		(12, 'Mouse',          300,    3),
		(13, 'Keyboard',       400,    9),
		(14, 'Laptop Stand',   650,    14),
		(15, 'Mousepad',       250,    1),
		(16, 'Webcam',         1200,   2),
		(17, 'External SSD',   2200,   19),
		(18, 'Headphones',     850,    11),
		(19, 'USB Hub',        350,    13),
		(20, 'Desk Lamp',      180,    17);

-- ==================================================================
-- Source Data Ingestion — Shipping & Fulfillment Data
-- ==================================================================

INSERT INTO Shipping
VALUES	(1,  'Pending',    2),
		(2,  'Delivered',  5),
		(3,  'Shipped',    3),
		(4,  'Delivered',  4),
		(5,  'Pending',    7),
		(6,  'Cancelled',  1),
		(7,  'Shipped',    9),
		(8,  'Delivered',  13),
		(9,  'Pending',    NULL),     
		(10, 'Returned',   11),
		(11, 'Delivered',  17),
		(12, 'Shipped',    19),
		(13, 'Cancelled',  14),
		(14, 'pending',    6),        
		(15, 'DELIVERED',  18),      
		(16, 'Shipped',    20),
		(17, 'Returned',   8),
		(18, NULL,         10),       
		(19, 'Delivered',  16),
		(20, 'Cancelled',  NULL);     

-- ==================================================================
-- Schema Alteration & Data Type Correctionion
-- ==================================================================

ALTER TABLE Shipping
ALTER COLUMN status VARCHAR(100) NULL;

-- ==================================================================
-- Verification Queries
-- ==================================================================

USE e_commerce
GO

SELECT * FROM Customers

SELECT * FROM Orders

SELECT * FROM Shipping