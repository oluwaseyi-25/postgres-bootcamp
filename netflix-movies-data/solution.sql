-- 📌 Netflix Content Analytics SQL Challenge
-- You are working as a Data Analyst / Analytics Engineer at Netflix.
-- Your team analyzes content performance, availability, and viewer engagement across movies and TV shows.

-- Problem 1: Latest Performance Snapshot per Movie
-- Netflix wants only the most recent performance record for each movie.
-- 👉 Retrieve one row per movie, showing:
-- movie title
-- latest end_date
-- Views
-- hours_viewed
-- Requirement:
-- Use DISTINCT ON to ensure only the most recent summary per movie is returned.
SELECT DISTINCT ON (m.title)
	m.title,
	v.end_date,
	v.views,
	v.hours_viewed
FROM view_summary v
	JOIN movie m on m.id = v.movie_id
ORDER BY m.title, v.end_date DESC;


-- Problem 2: Most Recent Season Performance per TV Show
-- For each TV show, retrieve only the latest season performance based on end_date.
-- Include:
-- TV show title
-- season number
-- end_date
-- Views

SELECT DISTINCT ON (t.title)
	t.title as tv_show_title,
	s.season_number,
	v.end_date,
	v.views
FROM view_summary v
	JOIN season s ON v.season_id = s.id
	JOIN tv_show t ON s.tv_show_id = t.id
ORDER BY tv_show_title, v.end_date DESC;


-- Problem 3: Movies That Have Viewing Data
-- The content team wants to analyze only movies that actually have viewer activity.
-- 👉 List:
-- movie title
-- release date
-- total views
-- total hours viewed
-- Only include movies that exist in view_summary.

SELECT
	m.title,
	m.release_date,
	SUM(v.views) as total_views,
	SUM(v.hours_viewed) as total_hours_viewed
FROM 
	view_summary v 
	INNER JOIN movie m ON v.movie_id = m.id
WHERE v.movie_id IS NOT NULL 
GROUP BY m.id;

-- Problem 4: Seasons with Recorded Viewership
-- Retrieve all TV show seasons that have at least one viewing record.
-- Include:
-- TV show title
-- season number
-- views
-- hours viewed

SELECT
	t.title,
	s.season_number,
	SUM(v.views) as views,
	SUM(v.hours_viewed) as hours_viewed
FROM 
	view_summary v 
	INNER JOIN season s ON v.season_id = s.id
	INNER JOIN tv_show t ON s.tv_show_id = t.id
GROUP BY t.title, s.season_number;


-- Problem 5: Movies Without Any Viewership
-- Netflix wants to identify underperforming or newly released movies.
-- 👉 Retrieve all movies, including those with zero viewing records.
-- Show:
-- movie title
-- release date
-- views (NULL if none)

SELECT
	m.title,
	m.release_date,
	SUM(v.views) as views
FROM
	movie m
	LEFT JOIN view_summary v ON m.id = v.movie_id
GROUP BY m.id;

-- Problem 6: TV Shows and Their Seasons (Even If Unwatched)
-- List all TV shows and their seasons, including seasons that have never been viewed.

SELECT DISTINCT
	t.title,
	s.season_number
FROM 
	season s 
	INNER JOIN tv_show t ON s.tv_show_id = t.id;


-- Problem 7: Viewing Records Without Movie Metadata
-- The data quality team suspects some orphaned view records.
-- 👉 Find viewing summaries that exist without a matching movie record.
-- Return:
-- view_summary.id
-- movie_id
-- views

SELECT
	v.id as view_summary_id,
	m.id as movie_id,
	v.views
FROM 
	view_summary v 
	LEFT JOIN movie m ON v.movie_id = m.id
WHERE m.id IS NULL AND v.season_id IS NULL;


-- Problem 8: Content Coverage Audit
-- Netflix wants to audit content data completeness.
-- 👉 Produce a report that includes:
-- All movies
-- All view summaries
-- Even when one side is missing.
-- Show:
-- movie title
-- views
-- start_date
-- end_date

SELECT 
	m.title,
	v.views,
	v.start_date,
	v.end_date
FROM view_summary v
	FULL OUTER JOIN movie m ON v.movie_id = m.id;


-- Problem 9: Movies That Have NEVER Been Viewed
-- Marketing wants to run promotions for content that has zero engagement.
-- 👉 Return all movies that do not appear in view_summary.

SELECT
	m.title,
	m.release_date
FROM 
	movie m
	LEFT JOIN view_summary v ON m.id = v.movie_id
WHERE v.movie_id IS NULL;


-- Problem 10: Seasons Without Any View Records
-- Identify TV show seasons that were released but never watched.

SELECT 
	t.title as tv_show_title,
	s.season_number,
	v.views
FROM 
	tv_show t
	INNER JOIN season s ON t.id = s.tv_show_id
	LEFT JOIN view_summary v ON s.id = v.season_id
WHERE v.season_id IS NULL;

-- Problem 11: View Records Without Valid Seasons
-- Find view records that reference a season_id that does not exist in the season table.
-- This helps detect broken foreign key references.

SELECT
	v.id,
	v.season_id,
	v.start_date,
	v.end_date
FROM view_summary v
	LEFT JOIN season s ON v.season_id = s.id
WHERE v.season_id IS NOT NULL AND s.id IS NULL;

-- Problem 12: Data Integrity Check
-- Identify:
-- Movies with no view data
-- View summaries that do not map to any movie
-- Return a unified report showing mismatches from both sides.

SELECT 
	m.id,
	m.title,
	v.id as summary_id,
	v.start_date,
	v.end_date
FROM
	movie m
	FULL OUTER JOIN view_summary v ON m.id = v.movie_id
WHERE 
	v.movie_id IS NULL AND m.id IS NOT NULL
	OR 
	m.id IS NULL AND v.movie_id IS NOT NULL;

-- Problem 13: Weekly Performance Report for TV Shows
-- Netflix executives want a weekly performance dashboard.
-- 👉 For each viewing record, show:
-- TV show title
-- season number
-- start_date
-- end_date
-- views
-- hours_viewed
-- view_rank
-- (Tables involved: tv_show → season → view_summary)

SELECT
	t.title as tv_show_title,
	s.season_number,
	v.start_date,
	v.end_date,
	v.views,
	v.hours_viewed,
	v.view_rank
FROM 
	tv_show t 
	JOIN season s ON s.tv_show_id = t.id
	JOIN view_summary v ON v.season_id = s.id;


-- Problem 14: Global Availability vs Performance
-- Analyze how global availability affects performance.
-- 👉 Retrieve:
-- movie title
-- available_globally
-- total views
-- total hours viewed

SELECT
	m.title,
	m.available_globally,
	SUM(v.views) as total_views,
	SUM(v.hours_viewed) as total_hours_viewed
FROM 
	movie m
	JOIN view_summary v ON m.id = v.movie_id
GROUP BY m.id;


-- Problem 15: Top-Performing Content by Locale
-- Product wants to understand regional performance.
-- 👉 For each locale:
-- list the top-ranked movie or season
-- based on lowest view_rank

WITH tv_summary as (
	SELECT 
		t.title, 'TV-show' as content_type, t.locale, v.view_rank
	FROM 
		tv_show t
		JOIN season s on t.id = s.tv_show_id
		JOIN view_summary v on s.id = v.season_id
),
	
	movie_summary as (
	SELECT 
		m.title, 'Movie' as content_type, m.locale, v.view_rank
	FROM
		movie m
		JOIN view_summary v on m.id = v.movie_id	
),
	
	combined as (
		SELECT 
			*
		FROM tv_summary
		UNION ALL
		SELECT 
			*
		FROM movie_summary 
	)
	
SELECT DISTINCT ON (locale)
	title,
	content_type,
	locale,
	view_rank
FROM combined
ORDER BY locale, view_rank;