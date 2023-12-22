-- Using IMDb dataset from BigQuery public data
-- Dataset: bigquery-public-data.imdb

-- Step 1: Assess the Data
-- Previewing a sample of movie titles and reviews
SELECT
  a.original_title,
  b.review
FROM
  `bigquery-public-data.imdb.reviews` b 
JOIN
  `bigquery-public-data.imdb.title_basics` a ON a.tconst = b.movie_id AND a.title_type = "movie"
LIMIT 100;

-- Step 2: Persist the Data
-- Creating a new table with a subset of movie reviews
CREATE OR REPLACE TABLE `hackaton.reviews` AS
SELECT
  a.original_title,
  b.review
FROM
  `bigquery-public-data.imdb.reviews` b 
JOIN
  `bigquery-public-data.imdb.title_basics` a ON a.tconst = b.movie_id AND a.title_type = "movie"
LIMIT 10;

-- Step 3: Create a Connection
-- Follow the instructions provided in the BigQuery documentation:
-- https://cloud.google.com/bigquery/docs/remote-functions#create_a_connection

-- Step 4: Create BigQuery ML Model Endpoint
-- Details: https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-create-remote-model
CREATE OR REPLACE MODEL hackaton.llm_model
REMOTE WITH CONNECTION `us.gcs-transactions`
OPTIONS (endpoint = 'text-bison');

-- Step 5: Translate Reviews to Italian
-- Note: Service account might need "Vertex AI User" role.
-- Refer: https://cloud.google.com/bigquery/docs/generate-text-tutorial#grant-permissions
SELECT
  original_title AS Titolo,
  review AS Review,
  a.ml_generate_text_llm_result AS Traduzione
FROM
  ML.GENERATE_TEXT(
    MODEL `hackaton.llm_model`,
    (
      SELECT
        p.*,
        CONCAT('Traduci questo testo in italiano: ', review) AS prompt
      FROM
        hackaton.reviews p
    ),
    STRUCT(
      0.2 AS temperature,
      0.2 AS top_p,
      15 AS top_k,
      TRUE AS flatten_json_output
    )
  ) a;

-- Step 6: Sentiment Analysis on Reviews
-- Evaluating if reviews are positive or negative
SELECT
  original_title AS Titolo,
  review AS Review,
  a.ml_generate_text_llm_result AS Sentiment
FROM
  ML.GENERATE_TEXT(
    MODEL `hackaton.llm_model`,
    (
      SELECT
        p.*,
        CONCAT('Run a sentiment analysis on this text, and evaluate if it is either positive or negative; respond by simply saying "positive" or "negative". Here is the text: ', review) AS prompt
      FROM
        hackaton.reviews p
    ),
    STRUCT(
      0.2 AS temperature,
      0.2 AS top_p,
      15 AS top_k,
      TRUE AS flatten_json_output
    )
  ) a;
