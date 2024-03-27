/****** Object:  Database UNKNOWN    Script Date: 8/14/2023 12:36:10 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE UNKNOWN
GO
CREATE DATABASE UNKNOWN
GO
ALTER DATABASE UNKNOWN
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_ca4_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
--CREATE SCHEMA fudgeInc
GO






/* Drop table fudgeInc.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeInc.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeInc.FactSales 
;

/* Create table fudgeInc.FactSales */
CREATE TABLE fudgeInc.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int    NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  int   NOT NULL
,  [PurchaseAmount]  money   NOT NULL
,  [UnitPrice]  money   NOT NULL
,  [SourceType]  nvarchar(30)   NOT NULL
, CONSTRAINT [PK_fudgeInc.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [CustomerKey], [OrderID] )
) ON [PRIMARY]
;



-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeInc].[Sales]'))
DROP VIEW [fudgeInc].[Sales]
GO
CREATE VIEW [fudgeInc].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [OrderDateKey] AS [OrderDateKey]
, [OrderID] AS [OrderID]
, [Quantity] AS [Quantity]
, [PurchaseAmount] AS [PurchaseAmount]
, [UnitPrice] AS [UnitPrice]
, [SourceType] AS [SourceType]
FROM fudgeInc.FactSales
GO







/* Drop table fudgeInc.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeInc.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeInc.DimCustomer 
;

/* Create table fudgeInc.DimCustomer */
CREATE TABLE fudgeInc.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  nvarchar(101)   NOT NULL
,  [CustomerCity]  nvarchar(50) NOT NULL
,  [CustomerState]  nvarchar(2)   NOT NULL
,  [CustomerZip]  nvarchar(5)   NOT NULL
,  [CustomerEmail]  nvarchar(200)   NULL
,  [SourceType]  nvarchar(30)  DEFAULT 'None' NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgeInc.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgeInc.DimCustomer ON
;
INSERT INTO fudgeInc.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerCity, CustomerState, CustomerZip, CustomerEmail, SourceType, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'No Customer', 'None', 'NA', 'None', 'None', '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgeInc.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeInc].[Customer]'))
DROP VIEW [fudgeInc].[Customer]
GO
CREATE VIEW [fudgeInc].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [CustomerCity] AS [CustomerCity]
, [CustomerState] AS [CustomerState]
, [CustomerZip] AS [CustomerZip]
, [CustomerEmail] AS [CustomerEmail]
, [SourceType] AS [SourceType]
, [RowIsCurrent] AS [Row Is Cureent]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgeInc.DimCustomer
GO







/* Drop table fudgeInc.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeInc.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeInc.DimProduct 
;

/* Create table fudgeInc.DimProduct */
CREATE TABLE fudgeInc.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(50)   NOT NULL
,  [IsActive]  nchar(1)  DEFAULT 'N' NOT NULL
,  [SupplierName]  nvarchar(40)  DEFAULT 'NoSupplier' NOT NULL
,  [CategoryName]  nvarchar(20)  DEFAULT 'NoCategory' NOT NULL
,  [SourceType]  nvarchar(30)  DEFAULT 'None' NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgeInc.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgeInc.DimProduct ON
;
INSERT INTO fudgeInc.DimProduct (ProductKey, ProductID, ProductName, IsActive, SupplierName, CategoryName, SourceType, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', '?', 'None', 'None', '', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgeInc.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeInc].[Product]'))
DROP VIEW [fudgeInc].[Product]
GO
CREATE VIEW [fudgeInc].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [IsActive] AS [IsActive]
, [SupplierName] AS [SupplierName]
, [CategoryName] AS [CategoryName]
, [SourceType] AS [SourceType]
, [RowIsCurrent] AS [Row Is Cureent]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgeInc.DimProduct
GO







/* Drop table fudgeInc.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeInc.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeInc.DimDate 
;

/* Create table fudgeInc.DimDate */
CREATE TABLE fudgeInc.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsAWeekday]  varchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_fudgeInc.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;



INSERT INTO fudgeInc.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk day', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeInc].[Date]'))
DROP VIEW [fudgeInc].[Date]
GO
CREATE VIEW [fudgeInc].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsAWeekday] AS [IsAWeekday]
FROM fudgeInc.DimDate
GO


ALTER TABLE fudgeInc.FactSales ADD CONSTRAINT
   FK_fudgeInc_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgeInc.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeInc.FactSales ADD CONSTRAINT
   FK_fudgeInc_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgeInc.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeInc.FactSales ADD CONSTRAINT
   FK_fudgeInc_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES fudgeInc.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
