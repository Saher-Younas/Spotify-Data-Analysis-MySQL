-- --EDA
select * from spotify;
SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;
SELECT DISTINCT album_type FROM spotify;
SELECT max(duration_min) FROM spotify;
SELECT * FROM spotify
where duration_min=0;

SELECT min(duration_min) FROM spotify;
SET SQL_SAFE_UPDATES = 0;
DELETE from spotify
where duration_min=0;

SELECT COUNT(DISTINCT channel) FROM spotify;
SELECT DISTINCT channel FROM spotify;
SELECT DISTINCT most_played_on FROM spotify;

-- ----------------------
-- Data Analysis Easy Category--
-- -------------------------
-- 1.Retrieve the names of all tracks that have more than 1 billion streams.
-- 2. List all albums along with their respective artists.
-- 3. Get the total number of comments for tracks where licensed = TRUE.
-- 4. Find all tracks that belong to the album type single.
-- 5. Count the total number of tracks by each artist.

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
where stream>=1000000000;

-- 2. List all albums along with their respective artists.
SELECT 
DISTINCT album, artist
FROM spotify
ORDER BY 1;

-- 3. Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(comments) as total_Comments
FROM spotify
WHERE licensed = 1;

-- 4. Find all tracks that belong to the album type single.

Select * from spotify
where album_type= 'single';

-- 5. Count the total number of tracks by each artist.

SELECT 
		artist, -- 1
        count(*) as total_no_of_songs -- 2
FROM spotify
GROUP BY artist
ORDER BY 2 DESC; 

--
/* -- --------------------------------------------
-- Medium Level
-- --------------------------------------------	
-- Calculate the average danceability of tracks in each album.
-- Find the top 5 tracks with the highest energy values.
-- List all tracks along with their views and likes where official_video = TRUE.
-- For each album, calculate the total views of all associated tracks.
-- Retrieve the track names that have been streamed on Spotify more than YouTube.*/


-- 6. Calculate the average danceability of tracks in each album.
SELECT 
	album,
    AVG(danceability) as avg_danceability
FROM spotify
group by 1
order by 2 desc;

-- 7. Find the top 5 tracks with the highest energy values.
select 
	track,
    avg(energy)
from spotify
group by 1
order by 2 desc
limit 5;

-- 8. List all tracks along with their views and likes where official_video = 1.
select 
	track,
    sum(views) as total_views,
    sum(likes) as total_likes
from spotify
where official_video= 1
group by 1
order by 2 desc;

-- 9. For each album, calculate the total views of all associated tracks.

select 
	album,
    track, 
    sum(views) as total_views
from spotify
group by 1, 2
order by 3 desc;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from
(select
	track,
    -- most_played_on,
    coalesce(SUM(CASE WHEN most_played_on = 'Youtube' then stream END), 0) as streamed_on_youtube,
    coalesce(SUM(CASE WHEN most_played_on = 'Spotify' then stream END), 0)  as streamed_on_spotify
    
from spotify
group by 1) AS t1
where 
	streamed_on_spotify>streamed_on_youtube
    AND 
    streamed_on_youtube <> 0
;

--
-- ------------------------------------------
-- Advanced Level
-- ------------------------------------------
-- Find the top 3 most-viewed tracks for each artist using window functions.
-- Write a query to find tracks where the liveness score is above the average.
-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album


-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist
AS
(SELECT
	artist,
    track, 
    sum(views) as total_views,
    dense_rank() over(partition by artist order by sum(views) desc) as ranks
from spotify
group by 1,2
order by 1, 3 desc
)
SELECT * FROM ranking_artist
WHERE ranks<=3;

-- 12. Write a query to find tracks where the liveness score is above the average.

select 
	track,
    artist,
    liveness
from spotify
where liveness> (select avg(liveness) from spotify)
;

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
with cte
as
(select
	album,
    max(energy) as highest_energy,
    min(energy) as lowest_energy
from spotify
group by 1)
select 	
	album,
    highest_energy-lowest_energy as energy_difference
from cte
order by 2 desc;

