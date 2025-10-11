/* ============================================================
   Script: 03_create_indexes.sql
   Purpose: Add indexes and constraints to improve query performance
   Notes:
     - Nonclustered indexes added for join keys
     - INCLUDE used for covering queries where needed
     - Unique indexes ensure key integrity in dimensions
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

use SmartMart_DWH

CREATE INDEX IX_DimProduct_NK ON dwh.DimProduct(ProductCode) INCLUDE(IsCurrent);

CREATE INDEX IX_DimCustomer_NK ON dwh.DimCustomer(CustomerCode) INCLUDE(IsCurrent);

CREATE UNIQUE INDEX UQ_DimBranch_Code ON dwh.DimBranch(BranchCode);

CREATE NONCLUSTERED INDEX IX_FactSales_Date
ON dwh.FactSales(DateKey)
INCLUDE (Quantity, UnitPrice, Discount, CostAmount, TotalAmount);

CREATE NONCLUSTERED INDEX IX_FactSales_Product
ON dwh.FactSales(ProductKey);

CREATE NONCLUSTERED INDEX IX_FactSales_Customer
ON dwh.FactSales(CustomerKey);

CREATE NONCLUSTERED INDEX IX_FactSales_Branch
ON dwh.FactSales(BranchKey);
