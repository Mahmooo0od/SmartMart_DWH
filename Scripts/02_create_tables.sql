/* ============================================================
   Script: 02_create_tables.sql
   Purpose: Create all DWH tables (Dimensions, Fact, Audit, and Staging)
   Includes:
     - dwh.DimDate
     - dwh.DimProduct
     - dwh.DimCustomer
     - dwh.DimBranch
     - dwh.FactSales
     - audit.ETL_Log
     - stg.RowErrors
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

use SmartMart_DWH

CREATE TABLE dwh.DimDate(
  DateKey      INT PRIMARY KEY,   -- YYYYMMDD
  [Date]       DATE NOT NULL,
  [Day]        TINYINT,
  [Month]      TINYINT,
  MonthName    NVARCHAR(20),
  [Quarter]    TINYINT,
  [Year]       SMALLINT,
  IsWeekend    BIT
);

CREATE TABLE dwh.DimProduct(
  ProductKey   INT IDENTITY(1,1) PRIMARY KEY,
  ProductCode  NVARCHAR(50) NOT NULL,  
  ProductName  NVARCHAR(200),
  Category     NVARCHAR(100),
  Brand        NVARCHAR(100) NULL,    
  WarrantyMon  INT NULL,              
  StartDate    DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
  EndDate      DATE NULL,
  IsCurrent    BIT  NOT NULL DEFAULT 1
);

CREATE TABLE dwh.DimCustomer(
  CustomerKey   INT IDENTITY(1,1) PRIMARY KEY,
  CustomerCode  NVARCHAR(50) NOT NULL,
  FullName      NVARCHAR(200),
  City          NVARCHAR(100),
  Segment       NVARCHAR(50) NULL,     -- (Retail/Online) ≈‰ √Õ»» 
  StartDate     DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
  EndDate       DATE NULL,
  IsCurrent     BIT NOT NULL DEFAULT 1
);

CREATE TABLE dwh.DimBranch(
  BranchKey   INT IDENTITY(1,1) PRIMARY KEY,
  BranchCode  NVARCHAR(50) NOT NULL,
  BranchName  NVARCHAR(200),
  City        NVARCHAR(100),
  Region      NVARCHAR(100) NULL
);

CREATE TABLE dwh.FactSales(
  SalesID       BIGINT IDENTITY(1,1) PRIMARY KEY,
  DateKey       INT NOT NULL,
  ProductKey    INT NOT NULL,
  CustomerKey   INT NOT NULL,
  BranchKey     INT NOT NULL,
  Quantity      INT NOT NULL,
  UnitPrice     DECIMAL(18,2) NOT NULL,
  Discount      DECIMAL(5,4)  NOT NULL DEFAULT 0,
  CostAmount    DECIMAL(18,2) NULL,
  TotalAmount   AS (Quantity*UnitPrice*(1-Discount)) PERSISTED,
  InsertedAt    DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
  SourceName    NVARCHAR(200) NULL
);

CREATE TABLE audit.ETL_Log(
  RunID        INT IDENTITY(1,1) PRIMARY KEY,
  PackageName  NVARCHAR(128),
  StartTime    DATETIME2,
  EndTime      DATETIME2,
  RowsIn       INT,
  RowsOut      INT,
  Errors       INT,
  Status       NVARCHAR(20),
  Notes        NVARCHAR(4000)
);

CREATE TABLE stg.RowErrors(
  ErrorID     INT IDENTITY(1,1) PRIMARY KEY,
  Source      NVARCHAR(128),
  RowData     NVARCHAR(MAX),
  ErrorDesc   NVARCHAR(4000),
  LoggedAt    DATETIME2 DEFAULT SYSDATETIME()
);

ALTER TABLE dwh.DimProduct ADD 
  SourceSystem NVARCHAR(50) NULL,      -- 'Bookstore_OLTP'
  SourceNaturalKey NVARCHAR(100) NULL; -- „À·« 'book:{book_id}'
