--Task 13. Identify Members with Overdue Books
--> Query to Identify members who have overdue books
--> Display the member's_id, member's name, book_title, issue_date, and days overdue

--issued_status == members == books == return_status
--filter books which is return
--overdue > 30

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

select current_date

select i.issued_member_id, m.member_name, bk.book_title, i.issued_date,
current_date - i.issued_date as over_dues_days
from issued_status as i
join members as m on m.member_id = i.issued_member_id
join books as bk on bk.isbn = i.issued_book_isbn
left join return_status as rs on rs.issued_id = i.issued_id
where rs.return_date is null and (current_date - i.issued_date) > 30
order by 1

--Task 14. Branch Performance Report
--Create a query that generates a performance report for each brancg, showing 
--The Number of Books issued, the number of books returned, and the total revenue generated from book rentals.

create table branch_reports
as
select b.branch_id, b.manager_id, count(ist.issued_id) as number_book_issued,
count(rs.return_id) as number_of_book_return, sum(bk.rental_price) as total_revenue
from issued_status as ist
join employees as e on e.emp_id = ist.issued_emp_id
join branch as b on e.branch_id = b.branch_id
left join return_status as rs on rs.issued_id = ist.issued_id
join books as bk on ist.issued_book_isbn = bk.isbn
group by 1,2;

select * from branch_reports;

--Task 15. Create a Table of Active Members
--Use the create table as statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

create table active_members
as
select * from members
where member_id in (select distinct issued_member_id
                    from issued_status
					where issued_date >= current_date - interval '2 Month');

--Task 16. Find Employees with the Most Book Issues Processed
--Write Query to find the top 3 employees who have processed the most book issues.
--Display the employee name, number of books processed, and thier branch

select e.emp_name, b.*, count(ist.issued_id) as no_book_issued
from issued_status as ist
join employees as e on e.emp_id = ist.issued_emp_id
join branch as b on e.branch_id = b.branch_id
group by 1,2

--> Task 17. Update Book Status on Return
--> Write query to update the status of books table to "Yes" when they are returned
--> (based on entries in the return_status table).

select * from issued_status
where issued_book_isbn = '978-0-330-25864-8';

select * from books
where isbn = '978-0-451-52994-2';

update books
set status = 'no'
where isbn = '978-0-451-52994-2'

SELECT * FROM return_status
WHERE issued_id = 'IS130';

--> Inserting data
insert into return_status(return_id, issued_id, return_date, book_quality)
values
('RS125', 'IS130', CURRENT_DATE, 'Good');

select * from return_status
where issued_id = 'IS130';

--> Stored Procedures
create or replace procedure add_return_records(p_return_id varchar(10), p_issued_id varchar(10), p_book_quality varchar(10))
language plpgsql
as $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

--Testing Function add_return_records

select * from books
where isbn = '978-0-307-58837-1'

select * from issued_status
where issued_book_isbn = '078-0-307-58837-1';

select * from return_status
where issued_id = 'IS135';

--> Calling Function
call add_return_records('RS138', 'IS135', 'Good');

--Calling Function
call add_return_records('RS148','IS140','Good');