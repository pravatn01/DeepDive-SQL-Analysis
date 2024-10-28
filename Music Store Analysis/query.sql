select * from album
select * from artist
select * from customer
select * from genre
select * from invoice
select * from invoice_line
select * from playlist
select * from playlist_track
select * from track


/* Q1: Who is the senior most employee based on job title? */


select concat(trim(first_name), ' ', trim(last_name)) as name,title, levels
from employee
order by levels desc
limit 1


/* Q2: Which countries have the most Invoices? */


select billing_country, count(*) as no_of_invoice
from invoice
group by billing_country
order by no_of_invoice desc
limit 5


/* Q3: What are top 3 values of total invoice? */


select total
from invoice
order by total desc
limit 3


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice totals */


select billing_city as city, sum(total) as invoice_total
from invoice
group by billing_city
order by invoice_total desc
limit 1

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money.*/


select concat(trim(c.first_name), ' ', trim(c.last_name)) as name, sum(total) as money_spent
from customer as c
join invoice as i
on c.customer_id = i.customer_id
group by name
order by money_spent desc
limit 1


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A. */


select distinct email, first_name, last_name, g.name
from customer as c
join invoice as i on i.customer_id = c.customer_id
join invoice_line as i_line on i_line.invoice_id = i.invoice_id
join track as t on t.track_id = i_line.track_id
join genre as g on g.genre_id = t.genre_id
where g.name like 'Rock'
order by email asc


/* Q7: Let's invite the artists who have written the most rock music in our dataset.
Write a query that returns the Artist name and total track count of the top 10 rock bands. */


select a.artist_id, a.name, count(a.artist_id) as track_count
from artist as a
join album as ab on ab.artist_id = a.artist_id
join track as t on t.album_id = ab.album_id
join genre as g on g.genre_id = t.genre_id
where g.name like 'Rock'
group by a.artist_id
order by track_count desc
limit 10


/* Q8: Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */


select name as track_name, milliseconds as track_length
from track
where milliseconds > (select avg(milliseconds) from track)
order by track_length desc
limit 10















































