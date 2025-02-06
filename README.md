# Spotify-Data-Analysis-MySQL


## Overview
This project performs Exploratory Data Analysis (EDA) and in-depth Data Analysis on a Spotify dataset using MySQL. The objective is to analyze artist trends, album insights, track performance, and streaming metrics while ensuring optimized query execution for efficient data retrieval.

## Features
- **Data Exploration**: Extracts record counts, unique values, and statistical summaries.
- **Data Cleaning**: Identifies and removes anomalies (e.g., tracks with zero duration).
- **Analytical Queries**: Investigates top artists, most streamed tracks, album distribution, licensing impact, and platform preferences.
- **SQL Optimization**: Uses indexing, grouping, and window functions for performance enhancement.

## Technologies Used
- **Database**: MySQL
- **Query Language**: SQL
- **Dataset**: Spotify track information, including artists, albums, streams, durations, comments, and platform distribution.

## Project Structure
- `project_1.sql` → Contains all SQL queries used in the analysis.

## Data Exploration (EDA)
The initial step is to explore the dataset by checking the number of records, unique values, and anomalies.

### Queries:
1. **Retrieve all records from the dataset**
   ```sql
   SELECT * FROM spotify;
   ```
   This fetches all track details.

2. **Count the total number of records**
   ```sql
   SELECT COUNT(*) FROM spotify;
   ```
   Returns the total number of tracks in the dataset.

3. **Count unique artists and albums**
   ```sql
   SELECT COUNT(DISTINCT artist) FROM spotify;
   SELECT COUNT(DISTINCT album) FROM spotify;
   ```
   Provides the number of distinct artists and albums.

4. **List all album types**
   ```sql
   SELECT DISTINCT album_type FROM spotify;
   ```
   Retrieves all album categories in the dataset.

5. **Find the longest and shortest track durations**
   ```sql
   SELECT MAX(duration_min) FROM spotify;
   SELECT MIN(duration_min) FROM spotify;
   ```
   Identifies the tracks with the longest and shortest durations.

6. **Identify and remove tracks with a duration of zero minutes**
   ```sql
   SELECT * FROM spotify WHERE duration_min = 0;
   DELETE FROM spotify WHERE duration_min = 0;
   ```
   This ensures data accuracy by removing incomplete records.

7. **Analyze distinct platforms and distribution channels**
   ```sql
   SELECT COUNT(DISTINCT channel) FROM spotify;
   SELECT DISTINCT channel FROM spotify;
   SELECT DISTINCT most_played_on FROM spotify;
   ```
   Provides insights into streaming distribution and preferred platforms.

## Data Analysis
### Beginner Level
1. **Retrieve tracks with over 1 billion streams**
   ```sql
   SELECT * FROM spotify WHERE stream >= 1000000000;
   ```
   Identifies high-performing tracks based on streams.

2. **List all albums and their artists**
   ```sql
   SELECT DISTINCT album, artist FROM spotify ORDER BY album;
   ```
   Displays album-artist associations.

3. **Total number of comments for licensed tracks**
   ```sql
   SELECT SUM(comments) AS total_comments FROM spotify WHERE licensed = 1;
   ```
   Measures listener engagement with licensed tracks.

4. **Retrieve all tracks classified as singles**
   ```sql
   SELECT * FROM spotify WHERE album_type = 'single';
   ```
   Filters tracks based on album type.

5. **Count the number of tracks per artist**
   ```sql
   SELECT artist, COUNT(*) AS total_tracks FROM spotify GROUP BY artist ORDER BY total_tracks DESC;
   ```
   Identifies the most prolific artists.

### Medium Level
6. **Calculate the average danceability of tracks per album**
   ```sql
   SELECT album, AVG(danceability) AS avg_danceability FROM spotify GROUP BY album ORDER BY avg_danceability DESC;
   ```
   Determines which albums have the most danceable tracks.

7. **Find the top 5 tracks with the highest energy levels**
   ```sql
   SELECT track, AVG(energy) FROM spotify GROUP BY track ORDER BY AVG(energy) DESC LIMIT 5;
   ```
   Highlights high-energy songs.

8. **Retrieve views and likes for tracks with official music videos**
   ```sql
   SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM spotify WHERE official_video = 1 GROUP BY track ORDER BY total_views DESC;
   ```
   Evaluates video engagement for official releases.

9. **Calculate total views of tracks per album**
   ```sql
   SELECT album, track, SUM(views) AS total_views FROM spotify GROUP BY album, track ORDER BY total_views DESC;
   ```
   Measures the reach of each album's tracks.

10. **Find tracks streamed more on Spotify than on YouTube**
   ```sql
   SELECT track FROM (SELECT track, COALESCE(SUM(CASE WHEN most_played_on = 'YouTube' THEN stream END), 0) AS streamed_on_youtube, COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify FROM spotify GROUP BY track) AS t1 WHERE streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> 0;
   ```
   Compares streaming performance across platforms.

### Advanced Level
11. **Find the top 3 most-viewed tracks per artist using window functions**
   ```sql
   WITH ranking_artist AS (SELECT artist, track, SUM(views) AS total_views, DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank FROM spotify GROUP BY artist, track) SELECT * FROM ranking_artist WHERE rank <= 3;
   ```
   Identifies an artist’s most successful tracks.

12. **Retrieve tracks where the liveness score is above average**
   ```sql
   SELECT track, artist, liveness FROM spotify WHERE liveness > (SELECT AVG(liveness) FROM spotify);
   ```
   Finds tracks that have high audience interaction.

13. **Calculate the energy variation within each album using CTEs**
   ```sql
   WITH cte AS (SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy FROM spotify GROUP BY album) SELECT album, highest_energy - lowest_energy AS energy_difference FROM cte ORDER BY energy_difference DESC;
   ```
   Measures energy consistency within albums.

## How to Use
1. Install and set up MySQL.
2. Import the dataset if necessary.
3. Execute `project_1.sql` in MySQL Workbench or any MySQL environment.
4. Modify queries to explore additional insights.

## Why This Project Stands Out
- **Comprehensive Analysis**: Covers multiple dimensions, from basic statistics to advanced insights.
- **Optimized Queries**: Uses aggregation, window functions, and CTEs for efficiency.
- **Platform Comparison**: Evaluates streaming performance across platforms.
- **Data Cleaning**: Ensures meaningful results by eliminating anomalies.

## Contributing
Contributions are welcome! Feel free to fork this repository, improve the queries, and submit pull requests.

---
**Author:** Saher Younas
For collaborations and inquiries, reach out!

