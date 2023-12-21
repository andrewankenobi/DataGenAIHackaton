-- 1. Create BQML model endpoint 
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-create-remote-model

CREATE OR REPLACE MODEL bqml_llm.llm_model
REMOTE WITH CONNECTION `us.VertexAI-External`
OPTIONS (endpoint = 'text-unicorn@001');


-- 2. Let's query Cymbal investements table
-- bigquery-public-data.cymbal_investments.trade_capture_report
SELECT * FROM bigquery-public-data.cymbal_investments.trade_capture_report
LIMIT 10;

-- 3. Let's get the data types of the public table.
SELECT column_name, data_type
FROM bigquery-public-data.cymbal_investments.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'trade_capture_report';

-- 4. Let's just check how it looks as an aggregation for our LLM input
SELECT TO_JSON_STRING(ARRAY_AGG(t)) as result
FROM (
  SELECT column_name, data_type
  FROM bigquery-public-data.cymbal_investments.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'trade_capture_report'
) t;


-- 5. Let's trigger the BQML LLM model we have created in step 1 to check what it can help us with:

SELECT 

* EXCEPT(ml_generate_text_rai_result,ml_generate_text_status, prompt)

FROM
ML.GENERATE_TEXT (
  MODEL`bqml_llm.llm_model`,
  (SELECT CONCAT('This is the table structure, explain to me what is this table an what is it used for? Give me a paragrapgh of details please.', TO_JSON_STRING(ARRAY_AGG(t))) as prompt, FROM (
  SELECT column_name, data_type
  FROM `bigquery-public-data.cymbal_investments.INFORMATION_SCHEMA.COLUMNS`
  WHERE table_name = 'trade_capture_report'
) t
),
   STRUCT (0 AS temperature,
    0.5 AS top_p,
    20 AS top_k,
    1024 AS max_output_tokens,
    TRUE AS flatten_json_output));
