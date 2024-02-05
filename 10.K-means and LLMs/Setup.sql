
/* BEFORE RUNNING THIS DEMO: 

- Create a BigQuery dataset > variable <YourDataset>
- Upload the content of the provided CSV file in a table of choice > variable <YourBaseTable>
- Create an external connection to invoke a remote AI model (text-bison) > see https://cloud.google.com/bigquery/docs/generate-text#create_a_connection 
- Assign to the service account associated with the external connection the Vertex AI User role > https://cloud.google.com/bigquery/docs/generate-text#give_the_service_account_access 

- Change <YourDataset> with the name of your dataset (find/replace)
- Change <YourBaseTable> with the name of the table in which you uploded the demo data (find/replace)
- Change <YourConnection> with the name of the External Connection you configured for BigQuery (find/replace)

*/


  BEGIN
  
  #Instantiate LLM leveraging bison#
CREATE OR REPLACE MODEL
  `<YourDataset>.llm` REMOTE
WITH CONNECTION `<YourConnection>` OPTIONS (endpoint ='text-bison');


  ## Create a Model k-Meams##
CREATE OR REPLACE MODEL
  `<YourDataset>.account_groups` OPTIONS(model_type='kmeans') AS
SELECT
  *
FROM
  `<YourDataset>.<YourBaseTable>`;


  ##Create a view with groupid predictions##
CREATE OR REPLACE VIEW
  `<YourDataset>.account_predicted_groups` AS
SELECT
  * EXCEPT (NEAREST_CENTROIDS_DISTANCE)
FROM
  ML.PREDICT(MODEL `<YourDataset>.account_groups`,
    (
    SELECT
      a.*
    FROM
      `<YourDataset>.<YourBaseTable>` a));


  ##Create a flatted version of `<YourDataset>.account_predicted_groups` for LLM inference
CREATE OR REPLACE VIEW
  `<YourDataset>.account_predicted_groups_flattened` AS
SELECT
  CONCAT('[', STRING_AGG(TO_JSON_STRING(t), ', '), ']') AS json_output
FROM (
  WITH
  Randomized AS (
  SELECT
    *,
    RAND() AS random_number
  FROM
    `<YourDataset>.account_predicted_groups`
  WINDOW
    w AS (
    PARTITION BY
      CENTROID_ID
    ORDER BY
      RAND()) )
SELECT
  *
FROM
  Randomized
WHERE
  random_number < 0.01) t;


  ##Create a flatted version of `<YourDataset>.<YourBaseTable>` for LLM inference
CREATE OR REPLACE VIEW
  `<YourDataset>.crm_account_flattened` AS
SELECT
  CONCAT('[', STRING_AGG(TO_JSON_STRING(t), ', '), ']') AS json_output
FROM (
  SELECT
    *
  FROM
    `<YourDataset>.<YourBaseTable>`
   where rand() < 0.015) t;


  ##Create a LLM-driven column descriptions
CREATE OR REPLACE TABLE
  `<YourDataset>.llm_columns_description` AS
SELECT
  ml_generate_text_llm_result AS columns_descriptions
FROM
  ML.GENERATE_TEXT(MODEL `<YourDataset>.llm`,
    (
    SELECT
      CONCAT("Describe every column in this table, use a simple structure key-value, like <column name>:<description>. Here's the data:  ", json_output) AS prompt
    FROM
      `<YourDataset>.crm_account_flattened` ),
    STRUCT(0.01 AS temperature,
      1024 AS max_output_tokens,
      TRUE AS flatten_json_output));

##Create a LLM-single inference
CREATE OR REPLACE VIEW `<YourDataset>.llm_groups_description`  as
(
SELECT
  ml_generate_text_llm_result AS group_descriptions
FROM
  ML.GENERATE_TEXT(MODEL `<YourDataset>.llm`,
    (
    SELECT
      CONCAT("You are a key data analyst. Your task is to interpret how customers were segmented using an unsupervised model.You will received a JSON file containing the following columns:", c.columns_descriptions, "- **CENTROID_ID**: A numeric ID for the  customer group estimated by the unsupervised model. Interpret the data, and come up with a description for each customer group; use a simple structure key: value, and per each group report a description of the group, annual revenue, number of employees, industry. The data is: ", d.json_output ) prompt
    FROM
      `argon-zoo-413112.<YourDataset>.llm_columns_description` c,
      `<YourDataset>.account_predicted_groups_flattened` d ),
    STRUCT(0.1 AS temperature,
      1024 AS max_output_tokens,
      TRUE AS flatten_json_output)));

##Table for the intermediate results
CREATE OR REPLACE TABLE `<YourDataset>.analysis_results` (
  Epochs INT64,
  group_descriptions STRING
);


-- Stored procedure to insert data from `<YourDataset>.groups_description_llm` into `<YourDataset>.analysis_results` N times after truncating the latter to avoid duplicates and ensure fresh data and variable temperature
CREATE OR REPLACE PROCEDURE `<YourDataset>.insert_descriptions_n_times`(n INT64)
BEGIN
  DECLARE counter INT64 DEFAULT 0;
  DECLARE unique_id STRING;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE <YourDataset>.analysis_results';

  WHILE counter < n DO
    INSERT INTO `<YourDataset>.analysis_results` (Epochs, group_descriptions)
    SELECT counter, group_descriptions
    FROM `<YourDataset>.llm_groups_description`;

    SET counter = counter + 1;
  END WHILE;
END;



create or replace view `<YourDataset>.llm_group_description_multi` as 
WITH
  flattened_results AS (
  SELECT
    CONCAT('[', STRING_AGG(TO_JSON_STRING(t), ', '), ']') AS json_output
  FROM (
    SELECT
      group_descriptions
    FROM
      `<YourDataset>.analysis_results`) t)
SELECT
  ml_generate_text_llm_result AS group_descriptions
FROM
  ML.GENERATE_TEXT(MODEL `<YourDataset>.llm`,
    (
    SELECT
      CONCAT("You are a key data analyst. You'll be provided of many intepretations of the contents of Customer Groups 1,2 and 3. Review the data, and respond with a reasonable summary of the most relevant and recurrent inputs - exclude any outliers. Come up with a description for each customer group; use a simple structure key: value, and per each group report a description of the group, annual revenue, number of employees, industry. The data is: ", d.json_output) AS prompt
    FROM
      flattened_results d ),
    STRUCT(0.1 AS temperature,
      1024 AS max_output_tokens,
      TRUE AS flatten_json_output) );

END
