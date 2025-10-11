/* ============================================================
   Script: 00_prechecks.sql
   Purpose: Pre-ETL checks to verify prerequisites before running SSIS
   Run DBs: SmartMart_DWH (main), Bookstore_OLTP (for source views)
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

-- Use the DWH
USE SmartMart_DWH;
GO

/* 1) Required schemas and tables exist */
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name IN ('dwh','stg','audit')
ORDER BY s.name, t.name;
GO

/* 2) DimDate is populated (should be > 0) */
SELECT COUNT(*) AS DimDateRows FROM dwh.DimDate;
GO

/* 3) (Optional) Core tables are empty before first load */
SELECT 'DimProduct'  AS T, COUNT(*) AS C FROM dwh.DimProduct  UNION ALL
SELECT 'DimCustomer',            COUNT(*) FROM dwh.DimCustomer UNION ALL
SELECT 'DimBranch',              COUNT(*) FROM dwh.DimBranch   UNION ALL
SELECT 'FactSales',              COUNT(*) FROM dwh.FactSales;
GO

/* 4) Key indexes exist (example check on Fact table) */
SELECT i.name AS IndexName
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dwh.FactSales') AND i.index_id > 0
ORDER BY i.name;
GO

/* 5) Source views are accessible in OLTP */
USE Bookstore_OLTP;
GO
SELECT TOP 1 * FROM dbo.vw_product;
SELECT TOP 1 * FROM dbo.vw_customer;
SELECT TOP 1 * FROM dbo.vw_branch;
SELECT TOP 1 * FROM dbo.vw_sales;
GO
