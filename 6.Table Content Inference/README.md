<p align="center">
<img src="https://github.com/andrewankenobi/DataGenAIHackaton/blob/main/6.Table%20Content%20Inference/uc6.png" width="350" height="350" alt="Cool Logo" style="border-radius: 10px;">
</p>

# BigQuery Table Descriptions Generation with BQML and Gemini

This project is an example use case for the GenAI hackathon. It demonstrates how to generate descriptions for BigQuery tables using BigQuery's `INFORMATION_SCHEMA` table and BigQuery Machine Learning (BQML) with Gemini.

## Code Overview

The SQL script `describe_table_via_llm.sql` performs the following steps:

1. **Create BQML model endpoint:** This step creates or replaces a BQML model endpoint using the `CREATE OR REPLACE MODEL` statement. The model is created with a remote connection to VertexAI-External and is named `llm_model`.

2. **Query Cymbal investments table:** This step queries the `trade_capture_report` table from the `bigquery-public-data.cymbal_investments` dataset. It retrieves all columns from the table but limits the result to 10 rows.

3. **Get data types of the public table:** This step retrieves the column names and data types of the `trade_capture_report` table from the `INFORMATION_SCHEMA.COLUMNS` table.

4. **Prepare data for LLM input:** This step aggregates the column names and data types into a JSON string. This JSON string will be used as input for the BQML model.

5. **Trigger the BQML LLM model:** This step triggers the BQML model created in step 1. It passes the JSON string created in step 4 as a prompt to the `ML.GENERATE_TEXT` function. The function generates a text description of the `trade_capture_report` table based on the column names and data types.

## Usage

To use this script, simply run it in your BigQuery environment. Make sure to replace the `text-unicorn@001` endpoint in the `CREATE OR REPLACE MODEL` statement with your own BQML model endpoint.

## Dependencies

This script requires access to the `bigquery-public-data.cymbal_investments` dataset and the `INFORMATION_SCHEMA.COLUMNS` table. It also requires a BQML model endpoint.

## License

This project is licensed under the terms of the MIT license.
