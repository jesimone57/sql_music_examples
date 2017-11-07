

-- 1. find all artists for each record label
select
   a.name "artist name",
   r.name "record label name"  
from
    recordlabel as r join artist as a
      on r.labelid = a.labelid
 
 
 
-- 2. number of songs per artist is descending order 
select
   ar.name "Artist Name",
   count(*) "Number of Songs"
from
    song s join album a
      on s.albumid = a.albumid
    join artist ar
      on ar.artistid = a.artistid
group by
   ar.name
order by
   count(*) desc
 
 
-- 3. which artist recorded the most songs?
select
   ar.name "Artist Name",
   count(*) "Number of Songs"
from
    song s join album a
      on s.albumid = a.albumid
    join artist ar
      on ar.artistid = a.artistid
group by
   ar.name
order by
   count(*) desc
fetch first 1 rows only
 
--better yet ...
 
select
   ar.name "Artist Name",
   count(*) "Number of Songs"
from
    song s
      join album a  on s.albumid = a.albumid
      join artist ar on ar.artistid = a.artistid
group by
   ar.name
having
  count(*) =  (
select
     max(n)
from (
            select
               ar.name "Artist Name",
               count(*) n
            from
                song s
                  join album a  on s.albumid = a.albumid
                  join artist ar on ar.artistid = a.artistid
            group by
               ar.name
   )
)
 
 
-- 4. which artist or artists have recorded the least number of songs?
select
  ar.name  "Artist Name",
  count(*) "Number of Songs"
from
    song s
     join album a on s.albumid = a.albumid
     join artist ar on ar.artistid = a.artistid
group by
  ar.name
having count(*) = (  
    select
       min(n) from (
        select
           ar.name a,
           count(*) n
        from
            song s join album a
              on s.albumid = a.albumid
                   join artist ar
              on ar.artistid = a.artistid
        group by
           ar.name
           )
       )
 
-- 5. How many artists have recorded the least number of songs
select count(*) "number of artists having recorded the least number of songs" from (
    select
      ar.name,
      count(*)
    from
        song s join album a
          on s.albumid = a.albumid
               join artist ar
          on ar.artistid = a.artistid
    group by
      ar.name
    having count(*) = (  
        select
           min(n) from (
            select
               ar.name a,
               count(*) n
            from
                song s join album a
                  on s.albumid = a.albumid
                       join artist ar
                  on ar.artistid = a.artistid
            group by
               ar.name
               )
           )
 )
 
 
-- 6. which artists have recorded songs longer than 5 minutes?
 
select distinct artist
   from (
       select
           ar.name artist,
           s.duration "duration"
        from
            song s join album a
              on s.albumid = a.albumid
                   join artist ar
              on ar.artistid = a.artistid
        where duration > 5
        )
        
 
-- 7. for each artist and album how many songs were less than 5 minutes long?
 
select
   ar.name artist,
   a.name album,
   --s.name "Song",
   --s.duration "duration",
   count(*)
from
    song s join album a
      on s.albumid = a.albumid
           join artist ar
      on ar.artistid = a.artistid
where duration < 5
group by
   ar.name,
   a.name
 
 
-- 8. in which year or years were the most songs recorded?
select
  a.year  "Year",
  count(*) "Number of Songs"
from
    song s join album a
      on s.albumid = a.albumid
           join artist ar
      on ar.artistid = a.artistid
group by
   a.year
having count(*) = (
        select max(count) from (
        select           
           a.year,
           count(*) count
        from
            song s join album a
              on s.albumid = a.albumid
                   join artist ar
              on ar.artistid = a.artistid
        group by
          a.year
        )
    )
 
-- 9. list the artist, song and year of the top 5 longest recorded songs
select
   a.name "Album",
   s.name "Song",
   a.year  "Year Recorded",
   s.duration "Duration"
from
    song s join album a
     on s.albumid = a.albumid
          join artist ar
     on ar.artistid = a.artistid
order by
   s.duration desc
fetch first 5 rows only
 
 
 
-- 10. which year (or years) had recorded the most albums? 
select
   a.year  "Year Recorded",
   count(*) "Number of albums recorded"
from
   album a
group by
  a.year
having count(*) = (  
    select
      max(c)
    from (
        select
           a.year  "Year Recorded",
           count(*) c
        from
            album a
        group by
          a.year
      )
)
 
 
-- 11. total duration of all songs recorded by each artist in descending order
        select
           ar.name "artist",
           sum(s.duration) "duration of all songs"
        from
            song s join album a
              on s.albumid = a.albumid
                   join artist ar
              on ar.artistid = a.artistid
        group by
          ar.name
        order by
           sum(s.duration) desc


 
-- 12. for which artist and album are there no songs less than 5 minutes long?
select
   ar.name artist,
   a.name album
   --s.name "Song"
   --s.duration "duration"
from
   artist ar left join album a on ar.artistid = a.artistid
             left join song s on s.albumid = a.albumid and s.duration < 5
where
   s.name is null



