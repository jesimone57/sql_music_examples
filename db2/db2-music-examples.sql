drop table recordlabel;
drop table artist;
drop table album;
drop table song;
 
 
CREATE TABLE RecordLabel(
  LabelID int not null,
  Name varchar(50) not null
);
 
INSERT INTO RecordLabel VALUES(1,'Blackened');
INSERT INTO RecordLabel VALUES(3,'Universal');
INSERT INTO RecordLabel VALUES(4,'MCA');
INSERT INTO RecordLabel VALUES(5,'Elektra');
INSERT INTO RecordLabel VALUES(2,'Warner Bros');
 
CREATE UNIQUE INDEX reclabel_index
  ON recordLabel (labelId) PCTFREE 10 ALLOW REVERSE SCANS;
 
ALTER TABLE recordLabel
  ADD CONSTRAINT PK_reclabel
  PRIMARY KEY (labelid);
 
 
 
 
CREATE TABLE Artist (
  LabelId int not null,
  ArtistId int not null,
  Name varchar(50) not null);
INSERT INTO Artist VALUES(1,1,'Metallica');
INSERT INTO Artist VALUES(1,2,'Megadeth');
INSERT INTO Artist VALUES(1,3,'Anthrax');
INSERT INTO Artist VALUES(2,4,'Eric Clapton');
INSERT INTO Artist VALUES(2,5,'ZZ Top');
INSERT INTO Artist VALUES(2,6,'Van Halen');
INSERT INTO Artist VALUES(3,7,'Lynyrd Skynyrd');
INSERT INTO Artist VALUES(3,8,'ACDC');
 
CREATE UNIQUE INDEX artist_index
  ON Artist (artistId) PCTFREE 10 ALLOW REVERSE SCANS;
 
ALTER TABLE artist
  ADD CONSTRAINT PK_artist
  PRIMARY KEY (artistid);
 
ALTER TABLE artist
  ADD CONSTRAINT fk_label
  FOREIGN KEY (labelid)
  REFERENCES recordLabel (labelid);
 
 
 
 
CREATE TABLE Album (
  ArtistId int         not null,
  AlbumId  int         not null,
  Name     varchar(50) not null,
  Year     int         not null
  );
INSERT INTO Album VALUES(1,1,'...And Justice For All',1988);
INSERT INTO Album VALUES(1,2,'Black Album',1991);
INSERT INTO Album VALUES(1,3,'Master of Puppets',1986);
INSERT INTO Album VALUES(2,4,'Endgame',2009);
INSERT INTO Album VALUES(2,5,'Peace Sells',1986);
INSERT INTO Album VALUES(3,6,'The Greater of 2 Evils',2004);
INSERT INTO Album VALUES(4,7,'Reptile',2001);
INSERT INTO Album VALUES(4,8,'Riding with the King',2000);
INSERT INTO Album VALUES(5,9,'Greatest Hits',1992);
INSERT INTO Album VALUES(6,10,'Greatest Hits',2004);
INSERT INTO Album VALUES(7,11,'All-Time Greatest Hits',1975);
INSERT INTO Album VALUES(8,12,'Greatest Hits',2003);
 
CREATE UNIQUE INDEX Album_index
  ON Album (albumId) PCTFREE 10 ALLOW REVERSE SCANS;
 
ALTER TABLE album
  ADD CONSTRAINT PK_album
  PRIMARY KEY (albumid);
 
ALTER TABLE album
  ADD CONSTRAINT fk_artist
  FOREIGN KEY (artistid)
  REFERENCES artist (artistid);
 
 
 
 
CREATE TABLE Song (
  AlbumId int not null,
  SongId int not null,
  Name varchar(50) not null,
  Duration real not null
  );
INSERT INTO Song VALUES(1,1,'One',7.25);
INSERT INTO Song VALUES(1,2,'Blackened',6.42);
INSERT INTO Song VALUES(2,3,'Enter Sandman',5.3);
INSERT INTO Song VALUES(2,4,'Sad But True',5.29);
INSERT INTO Song VALUES(3,5,'Master of Puppets',8.35);
INSERT INTO Song VALUES(3,6,'Battery',5.13);
INSERT INTO Song VALUES(4,7,'Dialectic Chaos',2.26);
INSERT INTO Song VALUES(4,8,'Endgame',5.57);
INSERT INTO Song VALUES(5,9,'Peace Sells',4.09);
INSERT INTO Song VALUES(5,10,'The Conjuring',5.09);
INSERT INTO Song VALUES(6,11,'Madhouse',4.26);
INSERT INTO Song VALUES(6,12,'I am the Law',6.03);
INSERT INTO Song VALUES(7,13,'Reptile',3.36);
INSERT INTO Song VALUES(7,14,'Modern Girl',4.49);
INSERT INTO Song VALUES(8,15,'Riding with the King',4.23);
INSERT INTO Song VALUES(8,16,'Key to the Highway',3.39);
INSERT INTO Song VALUES(9,17,'Sharp Dressed Man',4.15);
INSERT INTO Song VALUES(9,18,'Legs',4.32);
INSERT INTO Song VALUES(10,19,'Eruption',1.43);
INSERT INTO Song VALUES(10,20,'Hot For Teacher',4.43);
INSERT INTO Song VALUES(11,21,'Sweet Home Alabama',4.45);
INSERT INTO Song VALUES(11,22,'Free Bird',14.23);
INSERT INTO Song VALUES(12,23,'Thunderstruck',4.52);
INSERT INTO Song VALUES(12,24,'T.N.T',3.35);
 
CREATE UNIQUE INDEX song_index
  ON Song (songId) PCTFREE 10 ALLOW REVERSE SCANS;
 
ALTER TABLE song
  ADD CONSTRAINT PK_song
  PRIMARY KEY (songid);
 
ALTER TABLE song
  ADD CONSTRAINT fk_album
  FOREIGN KEY (albumid)
  REFERENCES album (albumid);
 
 
 

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



