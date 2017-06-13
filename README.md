# Examples for using MySQL with a music database
This example SQL project was created to practice writing SQL queries for a job interview.  I hope others 
will find it useful.   The data is simple and the listing of record labels, albums, artists and songs is just
for example purposes.  You can try altering the tables to make them more complete and more interesting.

jesimone57 - 12 June 2017

### Prerequisites
* install mysql
* A SQL editing environment such as:  SQuirreL SQL Client or IntelliJ IDE or the MySQL Workbench

### Usage Notes
* fire-up your mysql server if it is not already running:  mysqld
* fire-up your editing environment
* create the empty database:  create database music;
* connect your editing environment to the music database

### Tables and Data for these examples
<pre>
	
drop database music;
CREATE DATABASE IF NOT EXISTS music DEFAULT CHARACTER SET utf8;
use music;

-- Record Label table
CREATE TABLE record_label (
  id int unsigned  not null,
  name varchar(50) not null,
  PRIMARY KEY (id)
);

-- Record Label data
INSERT INTO record_label VALUES(1,'Blackened');
INSERT INTO record_label VALUES(2,'Warner Bros');
INSERT INTO record_label VALUES(3,'Universal');
INSERT INTO record_label VALUES(4,'MCA');
INSERT INTO record_label VALUES(5,'Elektra');
INSERT INTO record_label VALUES(6,'Capitol');

-- Artist table
CREATE TABLE artist (
  id  		int unsigned not null,
  record_label_id 	int unsigned  not null,
  name 		varchar(50) not null,
  PRIMARY KEY (id),
  KEY fk_record_label_in_artist (record_label_id),
  CONSTRAINT fk_record_label_in_artist FOREIGN KEY (record_label_id) REFERENCES record_label (id)
);

-- Artist data
INSERT INTO Artist VALUES(1, 1,'Metallica');
INSERT INTO Artist VALUES(2, 1,'Megadeth');
INSERT INTO Artist VALUES(3, 1,'Anthrax');
INSERT INTO Artist VALUES(4, 2,'Eric Clapton');
INSERT INTO Artist VALUES(5, 2,'ZZ Top');
INSERT INTO Artist VALUES(6, 2,'Van Halen');
INSERT INTO Artist VALUES(7, 3,'Lynyrd Skynyrd');
INSERT INTO Artist VALUES(8, 3,'AC/DC');
INSERT INTO Artist VALUES(9, 6,'The Beatles');


-- Album Table
CREATE TABLE album (
  id 	int unsigned not null,
  artist_id  int unsigned not null,
  name     varchar(50)  not null,
  year     int unsigned not null,
  PRIMARY KEY (id),
  KEY fk_artist_in_album (artist_id),
  CONSTRAINT fk_artist_in_album FOREIGN KEY (artist_id) REFERENCES artist (id)
);

-- Album data
INSERT INTO album VALUES(1, 1, '...And Justice For All',1988);
INSERT INTO album VALUES(2, 1, 'Black Album',1991);
INSERT INTO album VALUES(3, 1, 'Master of Puppets',1986);
INSERT INTO album VALUES(4, 2, 'Endgame',2009);
INSERT INTO album VALUES(5, 2, 'Peace Sells',1986);
INSERT INTO album VALUES(6, 3, 'The Greater of 2 Evils',2004);
INSERT INTO album VALUES(7, 4, 'Reptile',2001);
INSERT INTO album VALUES(8, 4, 'Riding with the King',2000);
INSERT INTO album VALUES(9, 5, 'Greatest Hits',1992);
INSERT INTO album VALUES(10, 6, 'Greatest Hits',2004);
INSERT INTO album VALUES(11, 7, 'All-Time Greatest Hits',1975);
INSERT INTO album VALUES(12, 8, 'Greatest Hits',2003);
INSERT INTO album VALUES(13, 9, 'Sgt. Pepper''s Lonely Hearts Club Band', 1967);


-- Song table
CREATE TABLE song (
  id int unsigned not null,
  album_id int unsigned not null,
  name varchar(50) not null,
  duration real not null,
  PRIMARY KEY (id),
  KEY fk_album_in_song (album_id),
  CONSTRAINT fk_album_in_song FOREIGN KEY (album_id) REFERENCES album (id)
);


-- Song data
INSERT INTO song VALUES(1,1,'One',7.25);
INSERT INTO song VALUES(2,1,'Blackened',6.42);

INSERT INTO song VALUES(3,2,'Enter Sandman',5.3);
INSERT INTO song VALUES(4,2,'Sad But True',5.29);

INSERT INTO song VALUES(5,3,'Master of Puppets',8.35);
INSERT INTO song VALUES(6,3,'Battery',5.13);

INSERT INTO song VALUES(7,4,'Dialectic Chaos',2.26);
INSERT INTO song VALUES(8,4,'Endgame',5.57);

INSERT INTO song VALUES(9,5,'Peace Sells',4.09);
INSERT INTO song VALUES(10,5,'The Conjuring',5.09);

INSERT INTO song VALUES(11,6,'Madhouse',4.26);
INSERT INTO song VALUES(12,6,'I am the Law',6.03);

INSERT INTO song VALUES(13,7,'Reptile',3.36);
INSERT INTO song VALUES(14,7,'Modern Girl',4.49);

INSERT INTO song VALUES(15,8,'Riding with the King',4.23);
INSERT INTO song VALUES(16,8,'Key to the Highway',3.39);

INSERT INTO song VALUES(17,9,'Sharp Dressed Man',4.15);
INSERT INTO song VALUES(18,9,'Legs',4.32);

INSERT INTO song VALUES(19,10,'Eruption',1.43);
INSERT INTO song VALUES(20,10,'Hot For Teacher',4.43);

INSERT INTO song VALUES(21,11,'Sweet Home Alabama',4.45);
INSERT INTO song VALUES(22,11,'Free Bird',14.23);

INSERT INTO song VALUES(23,12,'Thunderstruck',4.52);
INSERT INTO song VALUES(24,12,'T.N.T',3.35);

INSERT INTO song VALUES(25,13,'Sgt. Pepper''s Lonely Hearts Club Band', 2.0333);
INSERT INTO song VALUES(26,13,'With a Little Help from My Friends', 2.7333);
INSERT INTO song VALUES(27,13,'Lucy in the Sky with Diamonds', 3.4666);
INSERT INTO song VALUES(28,13,'Getting Better', 2.80);
INSERT INTO song VALUES(29,13,'Fixing a Hole', 2.60);
INSERT INTO song VALUES(30,13,'She''s Leaving Home', 3.5833);
INSERT INTO song VALUES(31,13,'Being for the Benefit of Mr. Kite!',2.6166);
INSERT INTO song VALUES(32,13,'Within You Without You',5.066);
INSERT INTO song VALUES(33,13,'When I''m Sixty-Four',2.6166);
INSERT INTO song VALUES(34,13,'Lovely Rita', 2.7);
INSERT INTO song VALUES(35,13,'Good Morning Good Morning', 2.6833);
INSERT INTO song VALUES(36,13,'Sgt. Pepper''s Lonely Hearts Club Band (Reprise)', 1.3166);
INSERT INTO song VALUES(37,13,'A Day in the Life', 5.65);

show tables;

</pre>

### Queries to write against this database

Notes:  
* There is no particular order to these queries.  
* Some are more difficult than others.
* Some will require knowing how to create sub-selects with temp tables.
* All will require knowledge of how to join the tables using the PK and FK.  
* Knowledge of both inner joins and outer joins is required.
* The solution SQL queries to the database exercises are located inside this repository.

### Database exercises

1. List all artists for each record label sorted by artist name. 
![1 results](../master/images/1.png)
	  
2. Which record labels have no artists?	
![2 results](../master/images/2.png)

3. List the number of songs per artist in descending order
![3 results](../master/images/3.png)
   
4. Which artist or artists have recorded the most number of songs?
![4 results](../master/images/4.png)

5. Which artist or artists have recorded the least number of songs?
![5 results](../master/images/5.png)

6. How many artists have recorded the least number of songs?  Hint: we can wrap the results of query 5. with another select to give us total artist count.
![6 results](../master/images/6.png)
 
7. Which artists have recorded songs longer than 5 minutes, and how many songs was that?
![7 results](../master/images/7.png)

8. For each artist and album how many songs were less than 5 minutes long?
![8 results](../master/images/8.png)

9. In which year or years were the most songs recorded?

![9 results](../master/images/9.png)

10. List the artist, song and year of the top 5 longest recorded songs
![10 results](../master/images/10.png)

11. List a table showing the Number of albums recorded for each year.

![11 results](../master/images/11.png)

12. What is the max number of recorded albums across all the years?  Hint: using the above sql as a temp table
![12 results](../master/images/12.png)

13. In which year (or years) were the most (max) number of albums recorded, and how many were recorded?
![13 results](../master/images/13.png)

14. List the total duration of all songs recorded by each artist in descending order.
![14 results](../master/images/14.png)

15. for which artist and album are there no songs less than 5 minutes long?
![15 results](../master/images/15.png)

16. Display a table of all artists, albums, songs and song duration, all ordered in ascending order by artist, album and song.
![16 results](../master/images/16.png) 

17. List the top 3 artists with the longest average song duration, in descending with longest average first.
![17 results](../master/images/17.png)

18. What is the total album length for all songs on the Beatles Sgt. Pepper's album - in minutes and seconds.
![18 results](../master/images/18.png)

19. Which artists did not release an album during the decades of the 1980's and the 1990's?
![19 results](../master/images/19.png)

20. Which artists did release an album during the decades of the 1980's and the 1990's?
![20 results](../master/images/20.png)


