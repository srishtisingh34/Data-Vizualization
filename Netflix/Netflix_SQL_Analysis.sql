
### Top 10 Movies According to IMDB Score

SELECT title, 
       type, 
       imdb_score
FROM shows_movies.titles
WHERE imdb_score >= 8.0
  AND type = 'MOVIE'
ORDER BY imdb_score DESC
LIMIT 10;


### Top 10 Shows According to IMDB Score

SELECT title, 
       type, 
       imdb_score
FROM shows_movies.titles
WHERE imdb_score >= 8.0
  AND type = 'SHOW'
ORDER BY imdb_score DESC
LIMIT 10;


### Bottom 10 Movies According to IMDB Score

SELECT title, 
       type, 
       imdb_score
FROM shows_movies.titles
WHERE type = 'MOVIE'
ORDER BY imdb_score ASC
LIMIT 10;


### Bottom 10 Shows According to IMDB Score

SELECT title, 
       type, 
       imdb_score
FROM shows_movies.titles
WHERE type = 'SHOW'
ORDER BY imdb_score ASC
LIMIT 10;


### Average IMDB and TMDB Scores for Shows and Movies

SELECT DISTINCT type, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY type;


### Count of Movies and Shows in Each Decade

SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
       COUNT(*) AS movies_shows_count
FROM shows_movies.titles
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year / 10) * 10, 's')
ORDER BY decade;


### Average IMDB and TMDB Scores for Each Production Country

SELECT DISTINCT production_countries, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;


### Average IMDB and TMDB Scores for Each Age Certification for Shows and Movies

SELECT DISTINCT age_certification, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;


### Top 5 Most Common Age Certifications for Movies

SELECT age_certification, 
       COUNT(*) AS certification_count
FROM shows_movies.titles
WHERE type = 'Movie' 
  AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;


### Top 20 Actors by Number of Appearances in Movies/Shows

SELECT DISTINCT name AS actor, 
       COUNT(*) AS number_of_appearances
FROM shows_movies.credits
WHERE role = 'actor'
GROUP BY name
ORDER BY number_of_appearances DESC
LIMIT 20;

### Top 20 Directors by Number of Movies/Shows Directed

SELECT DISTINCT name AS director, 
       COUNT(*) AS number_of_appearances
FROM shows_movies.credits
WHERE role = 'director'
GROUP BY name
ORDER BY number_of_appearances DESC
LIMIT 20;


### Average Runtime of Movies and Shows

SELECT 'Movies' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM shows_movies.titles
WHERE type = 'Movie'
UNION ALL
SELECT 'Show' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM shows_movies.titles
WHERE type = 'Show';


### Movies and Directors Released on or After 2010

SELECT DISTINCT t.title, 
                c.name AS director, 
                release_year
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
  AND t.release_year >= 2010 
  AND c.role = 'director'
ORDER BY release_year DESC;


### Shows on Netflix with the Most Seasons

SELECT title, 
       SUM(seasons) AS total_seasons
FROM shows_movies.titles 
WHERE type = 'Show'
GROUP BY title
ORDER BY total_seasons DESC
LIMIT 10;


### Genres with the Most Movies

SELECT genres, 
       COUNT(*) AS title_count
FROM shows_movies.titles 
WHERE type = 'Movie'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;


### Genres with the Most Shows

SELECT genres, 
       COUNT(*) AS title_count
FROM shows_movies.titles 
WHERE type = 'Show'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;


### Titles and Directors of Movies with High IMDB Scores (>7.5) and High TMDB Popularity Scores (>80)

SELECT t.title, 
       c.name AS director
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
  AND t.imdb_score > 7.5 
  AND t.tmdb_popularity > 80 
  AND c.role = 'director';


### Total Number of Titles for Each Year

SELECT release_year, 
       COUNT(*) AS title_count
FROM shows_movies.titles 
GROUP BY release_year
ORDER BY release_year DESC;


### Actors with Most Appearances in Highly Rated Movies or Shows

SELECT c.name AS actor, 
       COUNT(*) AS num_highly_rated_titles
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor'
  AND (t.type = 'Movie' OR t.type = 'Show')
  AND t.imdb_score > 8.0
  AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;


### Actors/Actresses Playing the Same Character in Multiple Movies or TV Shows

SELECT c.name AS actor_actress, 
       c.character, 
       COUNT(DISTINCT t.title) AS num_titles
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
GROUP BY c.name, c.character
HAVING COUNT(DISTINCT t.title) > 1;


### Top 3 Most Common Genres

SELECT t.genres, 
       COUNT(*) AS genre_count
FROM shows_movies.titles AS t
WHERE t.type = 'Movie'
GROUP BY t.genres
ORDER BY genre_count DESC
LIMIT 3;


### Average IMDB Score for Leading Actors/Actresses in Movies or Shows

SELECT c.name AS actor_actress, 
       ROUND(AVG(t.imdb_score), 2) AS average_imdb_score
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE (c.role = 'actor' OR c.role = 'actress')
  AND c.character = 'leading role'
GROUP BY c.name
ORDER BY average_imdb_score DESC;
