--32. High-value customers

--We want to send all of our high-value customers a special VIP gift.
--We're defining high-value customers as those who've made at least 1
--order with a total value (not including the discount) equal to $10,000 or
--more. We only want to consider orders made in the year 2016.


select o.Orderid,Customerid, 
       sum(od.UnitPrice*od.Quantity) as [Total Order Value] from dbo.Orders o
inner join dbo.OrderDetails od on 
     o.OrderID = od.OrderID 
where year(o.OrderDate) = 2016
group by o.OrderID,o.CustomerID
having sum(od.UnitPrice*od.Quantity) > 10000 
Order by  [Total Order Value] DESC;



select o.Orderid,c.Customerid, c.CompanyName,
       sum(od.UnitPrice*od.Quantity) as [Total Order Value] from dbo.Customers c
inner join dbo.Orders o  on 
     c.CustomerID = o.CustomerID
inner join dbo.OrderDetails od on 
     o.OrderID = od.OrderID 
where year(o.OrderDate) = 2016
group by o.OrderID,c.CustomerID,c.CompanyName
having sum(od.UnitPrice*od.Quantity) >= 10000 
Order by  [Total Order Value] DESC;







--33. High-value customers - total orders

--The manager has changed his mind. Instead of requiring that customers
--have at least one individual orders totaling $10,000 or more, he wants to
--define high-value customers as those who have orders totaling $15,000
--or more in 2016. How would you change the answer to the problem
--above?

--here we just removed a orderid, beacused we dont want sum based on one individual order

select c.Customerid, c.CompanyName,
       sum(od.UnitPrice*od.Quantity) as [Total Order Value] from dbo.Customers c
inner join dbo.Orders o  on 
     c.CustomerID = o.CustomerID
inner join dbo.OrderDetails od on 
     o.OrderID = od.OrderID 
where year(o.OrderDate) = 2016
group by c.CustomerID,c.CompanyName 
having sum(od.UnitPrice*od.Quantity) >= 15000 
Order by  [Total Order Value] DESC;

--34. High-value customers - with discount

--Change the above query to use the discount when calculating high-value
--customers. Order by the total amount which includes the discount.


select c.Customerid, c.CompanyName,
       sum(od.UnitPrice*od.Quantity) as [TotalWithoutDiscount],
	   TotalsWithDiscount = SUM(Quantity * UnitPrice * (1- Discount))
	   from dbo.Customers c
inner join dbo.Orders o  on 
     c.CustomerID = o.CustomerID
inner join dbo.OrderDetails od on 
     o.OrderID = od.OrderID 
where year(o.OrderDate) = 2016 
group by c.CustomerID,c.CompanyName
having sum(Quantity * UnitPrice * (1- Discount)) > 10000
Order by TotalsWithDiscount DESC;


--35.Month-end orders

--At the end of the month, salespeople are likely to try much harder to get
--orders, to meet their month-end quotas. Show all orders made on the last
--day of the month. Order by EmployeeID and OrderID

select * from dbo.Orders

Select EmployeeID,OrderID,OrderDate 
From Orders
Where OrderDate = EOMONTH(OrderDate)
Order by EmployeeID,OrderID


--36.Orders with many line items

--The Northwind mobile app developers are testing an app that customers
--will use to show orders. In order to make sure that even the largest
--orders will show up correctly on the app, they'd like some samples of
--orders that have lots of individual line items. Show the 10 orders with
--the most line items, in order of total line items.


select top 10 orderid, COUNT(orderid) as totalOrders from dbo.OrderDetails 
group by orderid
order by totalOrders desc;

--37. Orders - random assortment

--The Northwind mobile app developers would now like to just get a
--random assortment of orders for beta testing on their app. Show a
--random set of 2% of all orders.

select top 2 percent * from dbo.Orders order by newid()


--38. Orders - accidental double-entry

--Janet Leverling, one of the salespeople, has come to you with a request.
--She thinks that she accidentally double-entered a line item on an order,
--with a different ProductID, but the same quantity. She remembers that
--the quantity was 60 or more. Show all the OrderIDs with line items that
--match this, in order of OrderID.


Select
OrderID,Quantity
From OrderDetails
Where Quantity >= 60
Group By
OrderID,Quantity
having Count(*) > 1

select * from dbo.Orderdetails where orderid=10990


-- 39. Orders - accidental double-entry details
--Based on the previous question, we now want to show details of the
--order, for orders that match the above criteria.

--we can achieve this help of cte.


WITH doublEntryCTE (OrderID, Quantity)
AS
( Select
OrderID,Quantity
From OrderDetails
Where Quantity >= 60
Group By
OrderID,Quantity
having Count(*) > 1)
select orderid,productid, unitprice, quantity,discount
from dbo.OrderDetails where OrderID in (select OrderID from doublEntryCTE)
order by OrderID,Quantity

--40. Late orders
--Some customers are complaining about their orders arriving late. Which
--orders are late?

select OrderID,OrderDate,RequiredDate,ShippedDate from dbo.orders where ShippedDate >= RequiredDate;


--41. Late orders - which employees?
--Some salespeople have more orders arriving late than others. Maybe
--they're not following up on the order process, and need more training.
--Which salespeople have the most orders arriving late?


select e.EmployeeID,e.LastName,
Count(o.OrderID)  as [TotalLateOrders] from dbo.Orders o inner join dbo.Employees e
on e.EmployeeID = o.EmployeeID
where ShippedDate >= RequiredDate
group by e.EmployeeID,LastName
order by [TotalLateOrders] desc

