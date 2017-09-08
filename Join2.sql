--1.List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962
 
--2.Give year of 'Citizen Kane'.

select yr 
from movie 
where title like 'Citizen Kane'

--3.List all of the Star Trek movies, include the id, title and yr 
--(all of these movies include the words Star Trek in the title). Order results by year.

select id,title,yr 
from movie 
where title like '%star trek%'

--4.What id number does the actor 'Glenn Close' have?

select id 
from actor 
where name like'Glenn Close'

--5.What is the id of the film 'Casablanca'

select id 
from movie 
where title like 'Casablanca'

--6.Obtain the cast list for 'Casablanca'.
--what is a cast list?
--Use movieid=11768, (or whatever value you got from the previous question)

select name 
from actor  A 
join
casting C on A.id=C. actorid 
join 
movie M on C.movieid = M.id 
where M.title='Casablanca'

--7.Obtain the cast list for the film 'Alien'

select name 
from actor A 
join 
casting C on A.id = C.actorid 
join
movie M on M.id = C.movieid 
where title like 'Alien'

--8.List the films in which 'Harrison Ford' has appeared

select title 
from movie M 
join
casting C on M.id = C.movieid 
join
actor A on A.id = C.actorid 
where A.name like 'Harrison Ford' 

--9.List the films where 'Harrison Ford' has appeared - but not in the starring role. 
--[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title 
from movie M 
join
casting C on M.id = C.movieid 
join
actor A on A.id = C.actorid 
where A.name like 'Harrison Ford' and ord <> 1 


--10.List the films together with the leading star for all 1962 films.

select M.title, A.name from movie M join casting C on C.movieid = M.id join actor A on A.id=C.actorid where C.ord = 1 and M.yr = 1962


--11.Which were the busiest years for 'John Travolta', show the year and 
--the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)

--12.List the film title and the leading actor for all of the films 'Julie Andrews' played in.
--Did you get "Little Miss Marker twice"?

select title,name 
from movie 
join 
casting on movie.id = movieid and ord=1 join actor on actor.id = actorid 
where movie.id in

(SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews')
)

--13.Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 30;

--14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT title,count(actorid) as cast 
FROM movie 
join 
casting on movie.id=movieid 
join
actor on actor.id=actorid 
WHERE yr='1978' 
GROUP by title 
ORDER by cast desc, title

--15.List all the people who have worked with 'Art Garfunkel'.

select name from actor 
join 
casting on actor.id=actorid and name not like 'Art Garfunkel' 
where movieid in (select movieid from casting 
                  join
                  actor on actorid=id 
                  where name like 'Art Garfunkel')
