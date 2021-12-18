-- Intermediate Challanges

--20 Categories, and the total products in each category

--For this problem, we’d like to see the total number of products in each
--category. Sort the results by the total number of products, in descending
--order

select * from dbo.Products

select p.CategoryID as [Catogory ID], c.CategoryName as [Name of Category], count(ProductID) as [Total number of products] 
from dbo.Products p inner join dbo.Categories c
On p.CategoryID = c.CategoryID
group by p.CategoryID, c.CategoryName
order by [total number of products]  desc;


--21. Total customers per country/city#

--In the Customers table, show the total number of customers per Country
--and City.

Select country , city , count(CustomerId) as [Total Number of Customer] from dbo.Customers
group by Country,City
Order by [Total Number of Customer] desc;

-- 22. Products that need reordering

--What products do we have in our inventory that should be reordered?
--For now, just use the fields UnitsInStock and ReorderLevel, where
--UnitsInStock is less than the ReorderLevel, ignoring the fields
--UnitsOnOrder and Discontinued.
--Order the results by ProductID

select ProductID,ProductName, unitsinstock, reorderlevel from dbo.Products
where unitsinstock < reorderlevel
order by ProductID;

--23. Products that need reordering, continued

--Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder,
--ReorderLevel, Discontinued—into our calculation. We’ll define
--“products that need reordering” with the following:
--UnitsInStock plus UnitsOnOrder are less than or equal to
--ReorderLevel
--The Discontinued flag is false (0).

select * from dbo.Products


select ProductID,ProductName, Unitsinstock,UnitsOnOrder, Reorderlevel,Discontinued from dbo.Products
where unitsinstock + UnitsOnOrder <= reorderlevel and Discontinued=0
order by ProductID;


--24. Customer list by region

--A salesperson for Northwind is going on a business trip to visit
--customers, and would like to see a list of all customers, sorted by
--region, alphabetically.
--However, he wants the customers with no region (null in the Region
--field) to be at the end, instead of at the top, where you’d normally find
--the null values. Within the same region, companies should be sorted by
--CustomerID

select CustomerID,CompanyName,Region from dbo.customers 
order by 
  case 
  when Region is null then 1 
  else 0 
  end, Region, CustomerID

--25. High freight charges

--Some of the countries we ship to have very high freight charges. We'd
--like to investigate some more shipping options for our customers, to be
--able to offer them lower freight charges. Return the three ship countries
--with the highest average freight overall, in descending order by average
--freight

select top 3 ShipCountry, avg(Freight) as [Average freight] from dbo.orders
group by ShipCountry
order by [Average freight] desc;


--another way
Select
ShipCountry,AverageFreight = AVG(freight)
From Orders
Group By ShipCountry
Order by AverageFreight DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;


--26. High freight charges - 1997
--We're continuing on the question above on high freight charges. Now,
--instead of using all the orders we have, we only want to see orders from
--the year 1997

select top 3 ShipCountry, avg(Freight) as [Average freight] from dbo.orders
where year(OrderDate) = 1997
group by ShipCountry
order by [Average freight] desc;


-- 27 High freight charges using beetween

Select Top 3
ShipCountry
,AverageFreight = avg(freight)
From Orders
Where
OrderDate between '1/1/1997' and '12/31/1997'
Group By ShipCountry
Order By AverageFreight desc;


--28. High freight charges - last year

--We now want to get
--the three ship countries with the highest average freight charges. But
--instead of filtering for a particular year, we want to use the last 12
--months of order data, using as the end date the last OrderDate in Orders

select * from dbo.orders

select max(orderdate) as [Last Order Date] from dbo.Orders
select dateadd(year, -1, max(orderdate)) as [Date last year] from dbo.Orders

--using above queries in where clause

Select Top 3
ShipCountry
,AverageFreight = avg(freight)
From Orders
Where OrderDate >= Dateadd(yy, -1, (Select max(OrderDate) from Orders))
Group By ShipCountry
Order By AverageFreight desc;

--29. Inventory list

--We're doing inventory, and need to show information for various fields.
--show employeeid, employee lastname,orderid, productname and quantity for
--all orders. Sort by OrderID and Product ID.


select e.EmployeeID, e.LastName as [Employee Last Name],
       o.Orderid, p.Productname as [Product Name],
	   o2.Quantity as [Quantity Ordered]
from dbo.Employees e inner join dbo.orders o 
on  e.EmployeeID = o.EmployeeID inner join dbo.[Order Details] o2
on  o.OrderID = o2.OrderID inner join dbo.Products p
on  p.ProductID = o2.ProductID
order by o.OrderID,p.ProductID

--30. Customers with no orders

--There are some customers who have never actually placed an order.
--Show these customers

--using subquery
select CustomerID,ContactName from dbo.Customers where CustomerID not in (select CustomerID from dbo.Orders)

--another way using left join.

Select
Customers_CustomerID = Customers.CustomerID
,Orders_CustomerID = Orders.CustomerID
From Customers
left join Orders
on Orders.CustomerID = Customers.CustomerID
Where
Orders.CustomerID is null

--31. Customers with no orders for EmployeeID 4

--One employee (Margaret Peacock, EmployeeID 4) has placed the most
--orders. However, there are some customers who've never placed an order
--with her. Show only those customers who have never placed an order
--with her.


--subquery approach
select CustomerID,CompanyName, ContactName from dbo.Customers where CustomerID not in (select CustomerID from dbo.Orders where EmployeeID=4)


--left join appoach - run the query without where clause first to get better understanding of answer.

Select
Customers.CustomerID
,Orders.CustomerID
,Orders.EmployeeID
From Customers
left join Orders
on Orders.CustomerID = Customers.CustomerID
and Orders.EmployeeID = 4
where orders.CustomerID is null