SET SCHEMA 'chinook';
-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
 SELECT * FROM employee
 WHERE employee.lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
 SELECT * FROM employee
 WHERE firstname = 'Andrew' AND reportsto IS NULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
 SELECT * FROM album 
 ORDER BY albumid, title, artistid DESC
-- Task – Select first name from Customer and sort result set in ascending order by city
 SELECT firstname FROM customer
 ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
 INSERT INTO genre 
 VALUES (1000, 'Rock'), (1001, 'Classical');
-- Task – Insert two new records into Employee table
 INSERT INTO Employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
 VALUES (25,'dula', 'james', 'programmer', 6, '2017-07-23', '2017-07-23', '123 Fun Lane', 'TX', 'US', 77777, 8888888, 'fax', 'a@gmail.com', ''), 
 	   (26,'vo', 'calvin', 'programmer', 6, '2017-07-23', '2017-07-23', '123 Fun Lane', 'TX', 'US', 77777, 8888888, 'fax', 'a@gmail.com', '');
-- Task – Insert two new records into Customer table
 INSERT INTO customer(customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
 VALUES (100,'dula', 'james', 'Revature', '123 Fun Lane', 'TX', 'US', 77777, 8888888, 'fax', 'a@gmail.com','', 1), 
        (101,'vo', 'calvin', 'Revature', '123 Fun Lane', 'TX', 'US', 77777, 8888888, 'fax', 'a@gmail.com','', 1);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
 UPDATE customer
 SET firstname = 'Robert', lastname = 'Walter'
 WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
 UPDATE artist
 SET name = 'CCR'
 WHERE name = 'Creedence Clearwater Revival'
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
 SELECT * FROM invoice
 WHERE billingaddress LIKE 'T%'
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
 SELECT * FROM invoice
 WHERE total >= 15 AND total <= 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
 SELECT * FROM employee
 WHERE hiredate BETWEEN '01/06/2003' AND '01/03/2004';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
 	ALTER TABLE invoiceline
 	DROP CONSTRAINT fk_invoicelineinvoiceid;
 	ALTER TABLE invoice
 	DROP constraint fk_invoicecustomerid;
 	ALTER TABLE invoice
 	ADD CONSTRAINT fk_invoicecustomerid
 	FOREIGN KEY (customerid)
 	REFERENCES customer(customerid)
 	ON DELETE CASCADE;
	
 	DELETE FROM customer
 	WHERE firstname = 'Robert' AND lastname = 'Walter'
-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
 CREATE OR REPLACE FUNCTION curr_time () 
 RETURNS TIMESTAMP AS $$
 BEGIN
 	RETURN CURRENT_TIMESTAMP;
 END;
 $$ LANGUAGE plpgsql;

 SELECT curr_time();
-- Task – create a function that returns the length of a mediatype from the mediatype table
 CREATE OR REPLACE FUNCTION media_length(media_name VARCHAR(120))
 RETURNS INTEGER AS $$
 	BEGIN
 		RETURN length(media_name) FROM mediatype WHERE mediatype.name = media_name;
 	END;
 $$ LANGUAGE plpgsql;
 SELECT media_length('MPEG audio file');
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
 CREATE OR REPLACE FUNCTION avg_invoice()
 RETURNS DECIMAL AS $$
 	BEGIN
 		RETURN avg(total) FROM invoice;
 	END;
 $$ LANGUAGE plpgsql;

 SELECT avg_invoice();
-- Task – Create a function that returns the most expensive track
 CREATE OR REPLACE FUNCTION max_track()
 RETURNS NUMERIC AS $$
 	BEGIN
 		RETURN MAX(unitprice) FROM track;
 	END;
 $$ LANGUAGE plpgsql;

 SELECT max_track();
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
 CREATE OR REPLACE FUNCTION avg_price()
 RETURNS NUMERIC AS $$
 	BEGIN
 		RETURN AVG(unitprice) FROM invoiceline;
 	END;
 $$ LANGUAGE plpgsql;

 SELECT avg_price();
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
 CREATE OR REPLACE FUNCTION employeesafter1968()
 RETURNS TABLE (
 	employeeid INTEGER,
 	lastname VARCHAR(20),
 	firstname VARCHAR(20),
 	title VARCHAR(30),
 	reportsto INTEGER,
 	birthdate TIMESTAMP,
 	hiredate TIMESTAMP,
 	address VARCHAR(70),
 	city VARCHAR(40),
 	state VARCHAR(40),
 	country VARCHAR(40),
 	postalcode VARCHAR(10),
 	phone VARCHAR(24),
 	fax VARCHAR(24),
 	email VARCHAR
 )

 AS $$
 	BEGIN
 	RETURN QUERY SELECT * FROM employee WHERE employee.birthdate > '01/01/1968';
 	END;
 $$ LANGUAGE plpgsql;
 SELECT employeesafter1968();

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
 	CREATE OR REPLACE FUNCTION selectallemployees()
 	RETURNS TABLE(
 		lastname VARCHAR(20),
 		firstname VARCHAR(20)
 	)
 	AS $$
 	BEGIN
 		RETURN QUERY SELECT employee.firstname, employee.lastname FROM EMPLOYEE;
 	END;
 	$$ LANGUAGE plpgsql;
	
 	SELECT selectallemployees();
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
 CREATE OR REPLACE FUNCTION updateemployee(id INTEGER, first TEXT, last TEXT)
 RETURNS VOID AS $$
 BEGIN
 	UPDATE employee
 	SET firstname = first, lastname = last
 	WHERE employeeid = id;
 END;
 $$ LANGUAGE plpgsql;
 SELECT updateemployee(25, 'jose', 'vargas');
 SELECT * FROM employee;
-- Task – Create a stored procedure that returns the managers of an employee.
 	CREATE OR REPLACE FUNCTION getmanager(first TEXT)
 	RETURNS TABLE(
 		lastname varchar,
 		firstname varchar
 	) 
 	AS $$
 	DECLARE
 	employ INTEGER;
 	manager INTEGER;
 	BEGIN
 		SELECT employeeid FROM employee INTO employ
 		WHERE first = employee.firstname;
 		SELECT reportsto FROM employee INTO manager
 		WHERE employee.employeeid = employ;
 		RETURN QUERY SELECT employee.firstname, employee.lastname FROM employee 
 		WHERE manager = employee.employeeid;
 	END;
 	$$ LANGUAGE plpgsql;
 SELECT getmanager('jose');
 SELECT * FROM employee;
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION customervals(c_id INTEGER)
RETURNS TABLE(
	firstname VARCHAR,
	lastname VARCHAR,
	company VARCHAR
) 
AS $$
BEGIN
	RETURN QUERY SELECT customer.firstname, customer.lastname, customer.company FROM customer
	WHERE customerid = c_id;
END;
$$ LANGUAGE plpgsql;
SELECT customervals(1);
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
 	CREATE OR REPLACE FUNCTION del_invoice(in_id INTEGER)
 	RETURNS VOID AS $$
 	BEGIN
 		DELETE FROM invoice WHERE in_id = invoiceid;
 	END;
 	$$ LANGUAGE plpgsql;
 	SELECT del_invoice(1);
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
 CREATE OR REPLACE FUNCTION new_cust (customerid INTEGER, firstname VARCHAR, lastname VARCHAR, company VARCHAR, address VARCHAR, city VARCHAR, state VARCHAR, country VARCHAR, postalcode VARCHAR, phone VARCHAR, fax VARCHAR, email VARCHAR, supportrepid INTEGER)
 RETURNS VOID AS $$
 	BEGIN
 		INSERT INTO customer (customerid , firstname , lastname , company , address , city , state , country , postalcode , phone , fax , email , supportrepid)
 		VALUES(customerid , firstname , lastname , company , address , city , state , country , postalcode , phone , fax , email , supportrepid);
 	END;
 $$ LANGUAGE plpgsql;
 SELECT new_cust(100, 'j', 'j','j','j','j','j','j','j','j','j','j', 1);

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
 CREATE OR REPLACE FUNCTION emp_trigger()
 RETURNS TRIGGER AS $$
 	BEGIN
 		RETURN NEW;
 	END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER trigger_on_new_employee
 AFTER INSERT ON employee
 FOR EACH ROW
 EXECUTE PROCEDURE emp_trigger();
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
 CREATE OR REPLACE FUNCTION alb_trigger()
 RETURNS TRIGGER AS $$
 BEGIN
 	RETURN NEW;
 END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER trigger_on_new_album
 AFTER INSERT ON album
 FOR EACH ROW
 EXECUTE PROCEDURE alb_trigger();
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
 CREATE OR REPLACE FUNCTION cust_trigger()
 RETURNS TRIGGER AS $$
 BEGIN
 	RETURN NEW;
 END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER trigger_on_delete_cust
 AFTER DELETE ON customer
 FOR EACH ROW
 EXECUTE PROCEDURE cust_trigger();
-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
 CREATE OR REPLACE FUNCTION inv_trigger()
 RETURNS TRIGGER AS $$
 BEGIN
 	IF NEW.total > 50 THEN
 		RAISE EXCEPTION 'no deletion above 50 dollars!';
 	END IF;
 	RETURN NEW;
 END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER trigger_on_delete_inv
 AFTER DELETE ON invoice
 FOR EACH ROW
 EXECUTE PROCEDURE inv_trigger();
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
 SELECT customer.firstname, customer.lastname, invoice.invoiceid
 FROM customer
 INNER JOIN invoice ON customer.customerid = invoice.customerid
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
 SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, total
 FROM customer
 FULL OUTER JOIN invoice ON customer.customerid = invoice.customerid
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
 SELECT title, artist.name
 FROM album
 RIGHT JOIN artist ON album.artistid = artist.artistid
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
 SELECT *
 FROM album
 CROSS JOIN artist ORDER BY artist.name ASC
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
 SELECT * 
 FROM employee AS e1
 INNER JOIN employee AS e2 
 ON e1.reportsto = e2.reportsto
