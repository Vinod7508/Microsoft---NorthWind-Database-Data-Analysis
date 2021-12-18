--1. Which shippers do we have
--We have a table called Shippers. Return all the fields from all the shippers

select * from dbo.Shippers

--2. Certain fields from Categories

select * from dbo.Categories
select categoryName, [description] from dbo.Categories

--3. Sales Representatives

--We’d like to see just the FirstName, LastName, and HireDate of all the
--employees with the Title of Sales Representative. Write a SQL statement
--that returns only those employees.


select firstname, LastName, HireDate from dbo.Employees where Title='Sales Representative'

--4. Sales Representatives in the United States

--Now we’d like to see the same columns as above, but only for those
--employees that both have the title of Sales Representative, and also are
--in the United States

select firstname, LastName, HireDate from dbo.Employees where Title='Sales Representative' and Country='USA';


--5. Orders placed by specific EmployeeID
--Show all the orders placed by a specific employee. The EmployeeID for
--this Employee (Steven Buchanan) is 5.

select Orderid,OrderDate from [dbo].[Orders] where EmployeeID=5;

--6. Suppliers and ContactTitles
--In the Suppliers table, show the SupplierID, ContactName, and
--ContactTitle for those Suppliers whose ContactTitle is not Marketing
--Manager

select supplierid, contactname, contacttitle from dbo.Suppliers
    where ContactTitle !='Marketing Manager'

--7. Products with “queso” in ProductName

--In the products table, we’d like to see the ProductID and ProductName
--for those products where the ProductName includes the string “queso”.

select productid, productName from dbo.Products where productname  like '%queso%'

--8. Orders shipping to France or Belgium

--Looking at the Orders table, there’s a field called ShipCountry. Write a
--query that shows the OrderID, CustomerID, and ShipCountry for the
--orders where the ShipCountry is either France or Belgium.

select OrderID,CustomerID,ShipCountry from dbo.Orders 
    where ShipCountry in ('france', 'Belgium');


--9. Orders shipping to any country in Latin America

--Now, instead of just wanting to return all the orders from France of
--Belgium, we want to show all the orders from any Latin American
--country. But we don’t have a list of Latin American countries in a table
--in the Northwind database. So, we’re going to just use this list of Latin
--American countries that happen to be in the Orders table:
--Brazil
--Mexico
--Argentina
--Venezuela

select OrderID,CustomerID,ShipCountry from dbo.Orders 
    where ShipCountry in ('Brazil', 'Mexico','Argentina','Venezuela');


--10. Employees, in order of age

--For all the employees in the Employees table, show the FirstName,
--LastName, Title, and BirthDate. Order the results by BirthDate, so we
--have the oldest employees first

select firstName,Lastname, title,birthdate from dbo.Employees
order by BirthDate asc;

--11. Showing only the Date with a DateTime field

--In the output of the query above, showing the Employees in order of
--BirthDate, we see the time of the BirthDate field, which we don’t want.
--Show only the date portion of the BirthDate field.


select firstName,Lastname, title,  CONVERT(VARCHAR(10), BirthDate,102) As Birthdate from dbo.Employees
order by BirthDate asc;

--12. Employees full name

--Show the FirstName and LastName columns from the Employees table,
--and then create a new column called FullName, showing FirstName and
--LastName joined together in one column, with a space in-between

select FirstName,lastname,ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') as fullName from dbo.Employees

--13. OrderDetails amount per line item 

--In the OrderDetails table, we have the fields UnitPrice and Quantity.
--Create a new field, TotalPrice, that multiplies these two together. We’ll
--ignore the Discount field for now.
--In addition, show the OrderID, ProductID, UnitPrice, and Quantity.
--Order by OrderID and ProductID.

select orderid,ProductID,UnitPrice,Quantity, UnitPrice*Quantity as TotalPrice from dbo.[Order Details]
order by OrderID,ProductID

--14. How many customers?

--How many customers do we have in the Customers table? Show one
--value only, and don’t rely on getting the recordcount at the end of a
--resultset.

select count(CustomerID) as [Customer Count] from dbo.Customers


--15. When was the first order?
--Show the date of the first order ever made in the Orders table.

select min(orderDate) as [First Order Date] from dbo.Orders

--16. Countries where there are customers
--Show a list of countries where the Northwind company has customers.

--two ansers
select distinct Country from dbo.Customers
Select Country From dbo.Customers Group by Country

--17. Contact titles for customers

--Show a list of all the different values in the Customers table for
--ContactTitles. Also include a count for each ContactTitle.
--This is similar in concept to the previous question “Countries where
--there are customers”, except we now want a count for each ContactTitle

select * from dbo.Customers

select ContactTitle, count(ContactTitle) as TotalCount from dbo.Customers
group by ContactTitle order by ContactTitle asc;

--18. Products with associated supplier names

--for each product,Show the associated Supplier. Show the
--ProductID, ProductName, and the CompanyName of the Supplier. Sort
--by ProductID.

select productid, productName, CompanyName as [Supplier] 
   from dbo.Products p inner join dbo.Suppliers s
   on p.SupplierID = s.SupplierID
   Order by ProductID

--Orders and the Shipper that was used

--Show a list of the Orders that were made, including the
--Shipper that was used. Show the OrderID, OrderDate (date only), and
--CompanyName of the Shipper, and sort by OrderID.
--In order to not show all the orders (there’s more than 800), show only
--those rows with an OrderID of less than 10300

select * from dbo.Orders
select * from dbo.Shippers

select orderid as [Order ID], CONVERT(VARCHAR(10), Orderdate,102) As [Order Date], CompanyName as [Company of shipper] 
from dbo.Orders o inner join dbo.Shippers s
ON o.ShipVia = s.ShipperID 
Where OrderID < 10300
order by orderid




