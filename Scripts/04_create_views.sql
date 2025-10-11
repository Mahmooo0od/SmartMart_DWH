/* ============================================================
   Script: 04_create_views.sql
   Purpose: Define source views on the OLTP Bookstore database
   These views simplify and standardize data extraction for SSIS:
     - vw_product
     - vw_customer
     - vw_branch
     - vw_sales
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

use Bookstore_OLTP

CREATE OR ALTER VIEW dbo.vw_product AS
SELECT
  b.book_id            AS ProductCode,
  b.title              AS ProductName,
  p.publisher_name     AS PublisherName   
FROM dbo.book b
LEFT JOIN dbo.publisher p ON p.publisher_id = b.publisher_id;
GO

CREATE OR ALTER VIEW dbo.vw_customer AS
WITH ca AS (
  SELECT ca.customer_id, ca.address_id,
         ROW_NUMBER() OVER (PARTITION BY ca.customer_id ORDER BY ca.address_id DESC) rn
  FROM dbo.customer_address ca
)
SELECT
  c.customer_id                          AS CustomerCode,
  CONCAT(c.first_name, ' ', c.last_name) AS FullName,
  c.email                                AS Email,      
  a.city                                 AS City
FROM dbo.customer c
LEFT JOIN ca            ON ca.customer_id = c.customer_id AND ca.rn = 1
LEFT JOIN dbo.address a ON a.address_id   = ca.address_id;
GO

CREATE OR ALTER VIEW dbo.vw_branch AS
SELECT DISTINCT
  a.city          AS BranchCode,
  a.city          AS BranchName,
  a.city          AS City,
  co.country_name AS Region
FROM dbo.cust_order o
LEFT JOIN dbo.address a  ON a.address_id = o.dest_address_id
LEFT JOIN dbo.country co ON co.country_id = a.country_id
WHERE a.city IS NOT NULL;
GO

CREATE OR ALTER VIEW dbo.vw_sales AS
SELECT
  ol.line_id        AS SaleID,
  o.order_date      AS OrderDate,   -- והÍזבו DateKey Ýם SSIS
  ol.book_id        AS ProductCode,
  o.customer_id     AS CustomerCode,
  a.city            AS BranchCode,
  ol.price          AS UnitPrice
FROM dbo.order_line  ol
JOIN dbo.cust_order  o  ON o.order_id   = ol.order_id
LEFT JOIN dbo.address a ON a.address_id = o.dest_address_id;
GO
