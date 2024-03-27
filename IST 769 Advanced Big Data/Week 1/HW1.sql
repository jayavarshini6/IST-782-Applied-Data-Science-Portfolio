SELECT * from northwind.dbo.Products
SELECT * from Categories
-- 1.	List the Product ID, Category ID, product name and product unit price for products that are not discontinued.
Select ProductID, CategoryID, ProductName, UnitPrice from northwind.dbo.Products
where Discontinued = 0
-- 2.	Join the categories table so that you display the category name in the first query.

Select ProductID, northwind.dbo.Products.CategoryID, CategoryName ,ProductName, UnitPrice from northwind.dbo.Products join northwind.dbo.Categories
 on northwind.dbo.Products.CategoryID = northwind.dbo.Categories.CategoryID
where Discontinued = 0

-- 3.	Produce a query displaying the category ID, category name, and average product unit price.

SELECT p.ProductName,c.CategoryID, c.CategoryName, AVG(p.UnitPrice) as Average_Unit_Price from Categories c join Products p on c.CategoryID = p.CategoryID
group by c.CategoryID,c.CategoryName

-- 4 Next, combine queries 2 and 3 with a join. 
--Join on category ID so you can display product id, category id, product name, product unit price, and average product unit price, then subtract the unit price from the average.
--       HINT: Use a common table expression WITH clause to create two named queries then use them as tables to join for the last query.
--


With table1 as(
    Select ProductID, p.CategoryID as CategoryID, CategoryName ,ProductName, UnitPrice from Products as p join Categories as c on p.CategoryID = c.CategoryID
where Discontinued = 0
),
table2 as(
   SELECT c.CategoryID, c.CategoryName, AVG(p.UnitPrice) as Average_Unit_Price from Categories c join Products p on c.CategoryID = p.CategoryID
group by c.CategoryID,c.CategoryName
)
SELECT t1.ProductID,t1.CategoryID,t1.ProductName,t1.UnitPrice, t2.Average_Unit_Price,( t2.Average_Unit_Price- t1.UnitPrice) as diff from table1 as t1  join table2 as t2 on t1.CategoryID = t2.CategoryID


-- 5.	Re-write the query in 4 to use a window function instead of 3 queries.

select ProductID, CategoryID,ProductName, UnitPrice, 
avg(UnitPrice) over (partition by CategoryID), avg(UnitPrice) over (partition by CategoryID) - UnitPrice from Products

--Indexing CategoryID
drop index if EXISTS ix_CategoryID on Products
go
create NONCLUSTERED index ix_CategoryID
on Products (CategoryID)
INCLUDE (ProductID,ProductName, UnitPrice)
GO