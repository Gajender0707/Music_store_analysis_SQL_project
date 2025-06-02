-- question1: Who is the senior most employee based on job title?

select first_name,title,levels from employee
order by levels desc limit 1;
-- sol: mohan is the most senior employee based on the job title



-- question 2: Which countries have the most Invoices?
-- sol: usa,canada and brazil are the most invoices 
select 
billing_country,count(*) invoice_count
from invoice
group by billing_country 
order by invoice_count desc ;


-- question 3 : What are top 3 values of total invoice?
-- sol: 24,20 and 19 
select i.invoice_id,
round(sum(il.unit_price*il.quantity))  total_value
from invoice i 
left join invoice_line il on 
i.invoice_id=il.invoice_id
group by i.invoice_id 
order by total_value desc ;



/* Question 4: Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals  */
-- sol: Praque

select i.billing_city,
round(sum(il.unit_price*il.quantity))  total_value
from invoice i 
left join invoice_line il on 
i.invoice_id=il.invoice_id
group by i.billing_city 
order by total_value desc limit 1 ;



/* Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money */
-- sol:  R is the person with the customer id 5 is the person from prague who spend the most money....


select * from customer;

with cte as (select i.billing_city,
round(sum(il.unit_price*il.quantity))  total_value,
i.customer_id customer_id,
c.first_name first_name
from invoice i 
left join invoice_line il on i.invoice_id=il.invoice_id 
left join customer c on i.customer_id=c.customer_id
group by i.billing_city,i.total,i.customer_id,c.first_name
order by total_value desc)
select billing_city,
customer_id, first_name,
sum(total_value) total_value
from cte
group by billing_city,customer_id,first_name
order by total_value desc limit 1 ;








-- Now: Question Set 2 – Moderate

/* 1. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A  */

select distinct c.first_name,c.last_name,c.email from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join genre g on t.genre_id=g.genre_id
where g.name='Rock'
order by c.email asc;



/* Question 2: Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands */

select a.name,count(*) rock_music_count
from artist a
left join album al on a.artist_id=al.artist_id
left join track t on al.album_id=t.album_id
left join genre g on t.genre_id=g.genre_id
where g.name='Rock'
group by 1
order by 2 desc limit 10;


/* Question 3: Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first */

with cte as (select *,
avg(milliseconds) over( ) avg_song_length
from track)
select name,milliseconds
from cte
where  milliseconds> avg_song_length
order by milliseconds desc;






-- Question Set 3 – Advance 

/* 1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent  */


select distinct c.first_name,a.name artist_name,
sum(il.unit_price*il.quantity) total_spend
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join album al on t.album_id=al.album_id
left join artist a on al.artist_id=a.artist_id
group by 1,2 
order by total_spend desc;


-- cross check query

select distinct *
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join album al on t.album_id=al.album_id
left join artist a on al.artist_id=a.artist_id
where c.first_name='Hugh' and a.name='Queen';




/* Question 2: We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres */

with cte as (select country,genre_name,purchase_amount,
dense_rank() over(partition by  country order by purchase_amount desc ) rnk
from (select distinct c.country, g.name genre_name,
round(count(i.invoice_id)) purchase_amount
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join genre g on t.genre_id=g.genre_id
group by 1,2
order by purchase_amount desc) cd)
select country,genre_name,purchase_amount
from cte
where rnk=1
order by purchase_amount desc;


--cross check table 
select distinct 
count(i.invoice_id)
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join genre g on t.genre_id=g.genre_id
where c.country='USA' and g.name='Rock';



/* Question 3: Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount */

select * from (with cte as (select distinct 
c.customer_id,c.first_name,c.last_name,c.country,
sum(il.quantity*il.unit_price) total_spend
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
group by 1,2,3,4)
select *,
dense_rank() over(partition by country order by total_spend desc ) rnk
from cte) cd
where cd.rnk=1
order by  country;


-- Cross check
--cross check table 
select distinct 
sum(il.quantity*il.unit_price)
from customer c
left join invoice i on c.customer_id=i.customer_id
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
left join genre g on t.genre_id=g.genre_id
where c.country='Czech Republic' and c.first_name='Helena';

select * from employee;


/* Question:
How can we identify the top 30% of customers who contribute to at least 70% of total revenue, 
so we can focus our campaigns more efficiently?
*/
select * from invoice;
WITH CustomerSpending AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS CustomerName,
        round(SUM(i.total)::numeric,2) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
TotalRevenue AS (
    SELECT SUM(TotalSpent) AS TotalRevenue FROM CustomerSpending
),
RankedCustomers AS (
    SELECT 
        cs.customer_id,
        cs.CustomerName,
        cs.TotalSpent,
        SUM(cs.TotalSpent) OVER (ORDER BY cs.TotalSpent DESC) AS RunningTotal,
        ROUND(SUM(cs.TotalSpent) OVER (ORDER BY cs.TotalSpent DESC) * 100.0 / tr.TotalRevenue, 2) AS RunningPercent
    FROM CustomerSpending cs, TotalRevenue tr
)
SELECT 
    customer_id,
    CustomerName,
    TotalSpent,
    RunningPercent
FROM RankedCustomers
WHERE RunningPercent <= 70;














