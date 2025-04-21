select * from branch;
select * from books;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;

--Project Task

-- Task 1. Update an Existing Member's Address

update members
set member_address = '125 Main St'
where member_id = 'C101';

select * from members;

--Task 2: Delete a Record fro the Issued Status Table
--Objective: Delete the record with issued_id = 'IS121' from the issued_status table

select * from issued_status
where issued_id = 'IS121';

delete from issued_status
where issued_id = 'IS121';

--Task 3. Retrieve All books issued by a Specific Employee

select * from issude_status
where issued_emp_id = 'E101';

--Task 4. List Members who have issued more than one book
--Objective: Use the GROUP BY to find members who have issued more than one book

select i.issued_emp_id, e.emp_name
from issued_status as i
join employees as e on e.emp_id = i.issued_emp_id
group by 1, 2
having count(i.issued_id) > 1

--Task 5: Create Summary Tables: Used CTAS to generate new tables based on query results
--each book and total book_issued_cnt

create table book_counts
as
select b.isbn,b.book_title,count(i.issued_id) as no_issued
from books as b
join issued_status as i
on i.issued_book_isbn = b.isbn
group by 1, 2;

select * from book_counts;

--Task 8: Retrieve All books in a specific categry

select * from books
where category = 'Classic';

--Task 9: Find total rental income by category

SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

--Task 10: List Members Who registered in the last 100 days

select * from members
where reg_date >= current_date - interval '180 Days'

insert into members(member_id,member_name,member_address,reg_date)
values
('C118', 'sam', '145 Main St', '2024-06-01'),
('C119', 'john', '133 Main St', '2024-05-01');

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

select * from
books_price_greater_than_seven;

--Task 12: Retrieve the list of Books not yet Returned

select distinct i.issued_book_name
from issued_status as i
left join return_status as rs on i.issued_id = rs.issued_id
where rs.return_id is null

select * from return_status;