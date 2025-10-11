/* ============================================================
   Script: 05_insert_dimdate.sql
   Purpose: Populate DimDate table with continuous calendar dates
   Covers multiple years to support historical analysis
   Typical fields: DateKey, FullDate, Year, Month, Quarter, WeekDay, etc.
   Author: Mahmoud
   Date: 2025-10-11
============================================================ */

use SmartMart_DWH

WITH d AS (
  SELECT CAST('2024-01-01' AS DATE) dt
  UNION ALL SELECT DATEADD(DAY,1,dt) FROM d WHERE dt <= '2026-12-31'
)
INSERT INTO dwh.DimDate(DateKey,[Date],[Day],[Month],MonthName,[Quarter],[Year],IsWeekend)
SELECT CONVERT(INT,FORMAT(dt,'yyyyMMdd')), dt,
       DATEPART(DAY,dt), DATEPART(MONTH,dt), DATENAME(MONTH,dt),
       DATEPART(QUARTER,dt), DATEPART(YEAR,dt),
       CASE WHEN DATENAME(WEEKDAY,dt) IN (N'Friday',N'Saturday') THEN 1 ELSE 0 END
FROM d OPTION (MAXRECURSION 0);