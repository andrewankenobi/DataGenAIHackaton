-- this usecase is an example on how to use LLM to generate missing information based on other fields in the table (e.g use the location to generate the Borough)
-- it has to parts: generate the missing information
-- generate the SQL statement to create a table to store the generated information

-- use the NY taxi rides table to generate the prompt table for locations with longitude and latitude and without a borough

-- 1. create a model:

CREATE OR REPLACE MODEL dataplex_data_quality.llm_model
REMOTE WITH CONNECTION `us.vertex-ai`
OPTIONS (endpoint = 'text-unicorn@001');

-- 2. Build the prompt with information from the table will be used as input to ML_GENERATE_TEXT function
select location_id,
concat ('use latitude: ', latitude, ' and longitude: ', longitude, 'to generate the barrow. Return the barrow') as prompt
from 
 `taxi_dataset.location` a
where borough = 'Unknown';

-- 3. Use ML.GENERATE_TEXT function to generate the missing information for borough where missing for each location_id. Latitude and Longitude will be given in the prompt.
SELECT 
a.location_id,
a.latitude,
a.longitude,
t.ml_generate_text_llm_result as borough
from
    ML.GENERATE_TEXT(      
      MODEL `dataplex_data_quality.llm_model`,  
      (select location_id,
        concat ('use latitude: ', latitude, ' and longitude: ', longitude, 'to generate borough. Return just the borough') as prompt
        from 
        `taxi_dataset.location` a
        where borough = 'Unknown'),
      STRUCT (0 AS temperature,
        0.5 AS top_p,
        20 AS top_k,
        1024 AS max_output_tokens,
        TRUE AS flatten_json_output)
) t inner join `taxi_dataset.location` a 
  on t.location_id = a.location_id ; 

-- 4. Use ML_GENERATE_TEXT generate a sql to create a table with the missing information, this table can than be used for validation before merging the information into the main table
-- the prompt can be enhanced by specifying the dataset and the table name

SELECT ml_generate_text_llm_result as sql_command FROM 
ML.GENERATE_TEXT (
  MODEL`dataplex_data_quality.llm_model`,
  (SELECT CONCAT('use latitude and longitude to determine the borrow, the area. Give me the response as location_id, borrow, zone and generate just the BQ SQL to create a table with these records. Display just the statement.', TO_JSON_STRING(ARRAY_AGG(t))) as prompt, FROM (
  SELECT *
  FROM `taxi_dataset.location`
  WHERE borough ='Unknown'
) t
),
   STRUCT (0 AS temperature,
    0.5 AS top_p,
    20 AS top_k,
    1024 AS max_output_tokens,
    TRUE AS flatten_json_output));



