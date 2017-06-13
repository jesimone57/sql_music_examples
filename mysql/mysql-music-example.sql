
-- 1. List all artists for each record label sorted by artist name. 
select
	ar.name "Artist Name",
	r.name "Record Label Name"  
from
	record_label r join artist ar on r.id = ar.record_label_id
order by
	ar.name asc
;	
	
	  
-- 2. select all record labels with no artists
select
   r.name "Record Label Name"  
from
    record_label r left join artist a on r.id = a.record_label_id 
where
    a.record_label_id is null
;	

	
-- 3. number of songs per artist in descending order 
select
   ar.name "Artist Name",
   count(*) "Number of Songs"
from
	song s join album  al on s.album_id = al.id
		   join artist ar on al.artist_id = ar.id
group by
   ar.name
order by
   count(*) desc
;   
   
   
-- 4. which artist recorded the most songs?
select
   ar.name "Artist Name",
   count(*) "Number of Songs"
from
    song s join album al on s.album_id = al.id
		   join artist ar on al.artist_id = ar.id 
group by
   ar.name
order by
   count(*) desc
limit 1
;


-- 5. which artist or artists have recorded the least number of songs?
select
	ar.name "Artist Name",
	count(*) "Number of Songs Recorded"
from
	song s join album al on s.album_id = al.id 
		   join artist ar on al.artist_id = ar.id
group by
	ar.name
having 
	count(*) = (  
		select
			min(n) 
		from (
			select
				ar.name a,
               	count(*) n
            	from
                	song s join album al on s.album_id = al.id
                       	  join artist ar on al.artist_id = ar.id 
            	group by
               	ar.name
               ) temp1
           ) 
;


-- 6. How many artists have recorded the least number of songs?
-- Hint: we can wrap the results of query 4. with another select to give us total artist count.
select 
	count(*) "number of artists having recorded the least number of songs" 
from (
	select
		ar.name Artist,
		count(*)
	from
		song s join album al on s.album_id = al.id 
			  join artist ar on al.artist_id = ar.id
	group by
		ar.name
	having 
		count(*) = (  
			select
				min(n) 
			from (
            		select
               		ar.name a,
               		count(*) n
            		from
                		song s join album al on s.album_id = al.id
                       		  join artist ar on al.artist_id = ar.id 
            		group by
               		ar.name
               	) temp1
           	) 
 	) temp2
;


-- 7. which artists have recorded songs longer than 5 minutes, and how many songs was that?
select  
	temp.artist "Artist Name",
	count(*) "Number of Songs greater than 5 minutes"
from (
       select
           ar.name artist,
           s.duration "duration"
        from
            song s join album al on s.album_id = al.id 
            	    join artist ar on  al.artist_id = ar.id
        where duration > 5
        ) as temp
group by
	temp.artist
;


-- 8. for each artist and album how many songs were less than 5 minutes long?
select
   ar.name "Artist Name",
   al.name "Album Name",
   --s.name "Song",
   --s.duration "duration",
   count(*) "Number of Songs less than 5 minutes"
from
    song s join album al on s.album_id = al.id
           join artist ar on al.artist_id = ar.id
where 
	duration < 5
group by
   ar.name,
   al.name
;


-- 9. in which year or years were the most songs recorded?
select
  al.year  "Year",
  count(*) "Number of Songs Recorded"
from
    song s join album al on s.album_id = al.id 
		 join artist ar  on al.artist_id = ar.id
group by
   al.year
having count(*) = (
        select 
        	max(count) from (
        		select           
           		al.year,
           		count(*) count
       		 from
            		song s join album al on s.album_id = al.id
                   		  join artist ar on al.artist_id = ar.id
        		group by
          		al.year
        ) as temp
    )
;	
	

 -- 10. list the artist, song and year of the top 5 longest recorded songs
select
	ar.name "Artist Name",
	al.name "Album Name",
	s.name "Song",
	al.year  "Year Recorded",
	s.duration "Duration"
from
    song s join album al on s.album_id = al.id
           join artist ar on al.artist_id = ar.id
order by
   s.duration desc
limit 5
;


-- 11. Number of albums recorded for each year
select
	al.year  "Year Recorded",
	count(*) c
from
	album al
group by
	al.year 
;


	
-- 12. What is the max number of recorded albums across all the years?
-- Hint:  using the above sql as a temp table
select
	max(c)
from (
		select
			al.year  "Year Recorded",
			count(*) c
		from
			album al
		group by
			al.year
      ) as temp
;


-- 13. In which year (or years) were the most (max) number of albums recorded, and how many were recorded?
-- using the above sql
select
   al.year  "Year Recorded",
   count(*) "Number of albums recorded"
from
	album al
group by
	al.year
having count(*) = (  
    	select
      		max(c)
    	from (
        		select
           	 		al.year  "Year Recorded",
           		 	count(*) c
        		from
            		album al
        		group by
          	  		al.year
      		) as temp
		)
;


-- 14. total duration of all songs recorded by each artist in descending order
select
	ar.name "Artist Name",
 	sum(s.duration) "Total Duration of All Songs"
from
	song s join album  al on s.album_id = al.id
		   join artist ar on al.artist_id = ar.id
group by
	ar.name
order by
	sum(s.duration) desc
;
 

-- 15. for which artist and album are there no songs less than 5 minutes long?
select
   ar.name "Artist Name",
   al.name "Album Name" 
   --s.name "Song",
   --s.duration "duration"
from
   artist ar left join album al on ar.id = al.artist_id
             left join song s on s.album_id = al.id and s.duration < 5
where
   s.name is null
;


-- 16. A table of all artists, albums, songs and song duration 
--     all ordered in ascending order by artist, album and song  
select 
   ar.name as "Artist Name",
   al.name as "Album Name",
   s.name as "Song",
   s.duration as "Duration"
from 
   artist ar join album al on al.artist_id = ar.id 
   	         join song s on s.album_id = al.id
order by
   ar.name asc,
   al.name asc,
   s.name asc
;

-- 17. List the top 3 artists with the longest average song duration, in descending with longest average first.
select
	ar.name "Artist Name",
	avg(s.duration) "Average Song Duration (min)"
from
	song s join album al on s.album_id = al.id 
		   join artist ar on  al.artist_id = ar.id
group by
	ar.name
order by 
    avg(s.duration) desc
limit 3
;

-- 18. Total album length for all songs on the Beatles Sgt. Pepper's album - in minutes and seconds.
select 
   al.name,
   floor(sum(s.duration)) "Minutes",
   round(mod(sum(s.duration), 1)*60) "Seconds"
from
   album al join song s on s.album_id = al.id
where
   al.name like 'Sgt. Pepper%'
group by
   al.name
   
   
   
