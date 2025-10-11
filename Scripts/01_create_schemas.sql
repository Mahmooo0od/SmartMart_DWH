/* ============================================================
   Script: 01_create_schemas.sql
   Purpose: Create the logical schemas for the SmartMart DWH project
   Schemas include:
     - stg: staging area for raw data
     - dwh: data warehouse (dimensions & facts)
     - audit: for logging and error tracking
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

CREATE DATABASE SmartMart_DWH;
GO
USE SmartMart_DWH;
GO

-- Schemas 
CREATE SCHEMA stg;   -- Staging
CREATE SCHEMA dwh;   -- Dimensions/Facts
CREATE SCHEMA audit; -- Logs 

