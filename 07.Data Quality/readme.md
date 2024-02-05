
# Usecase 1. Using LLM to generate missing information

This  usecase is an example of how we can use BigQuery Machine Learning (BQML) with Gemini to generate missing data on borough by using the location information. The example also shows how to generate a BQ SQL statement to create a table with the generated information.

## Code Overview

The SQL script `usecase1_GenerateMissingInformation.sql` performs the following steps:

1. **Create BQML model endpoint:** This step creates or replaces a BQML model endpoint using the `CREATE OR REPLACE MODEL` statement. The model is created with a remote connection to us.vertex-ai and is named `llm_model`.

2. **Build the prompt:** This table is building the prompt by specifying the ask: we want the model to use the langitude and longitude from the taxi_trips table to generate the Borough. The script only selects the rows for which the information is unknown.


3. **Trigger the BQML LLM model:** This step triggers the BQML model created in step 1. It passes the prompt created in setp 2 to the `ML.GENERATE_TEXT` function. The function generates the borough information.

4. **Prepare data for LLM input to generate the SQL Statement to create the table:** This step aggregates the longitude and latitude for all the entries with missing borough as a json. This JSON string will be used as input for the BQML model. This step triggers the BQML model created in step 1. It passes the JSON string created in step 4 as a prompt to the `ML.GENERATE_TEXT` function. The function generates the create table statement and the insert of the values for the location_id, generated borough, longitude and latitude

## Usage

To use this script, simply run it in your BigQuery environment. Make sure to replace the `vertex_ai_llm_endpoint` endpoint in the `CREATE OR REPLACE MODEL` statement with your own BQML model endpoint.

## Dependencies

This script is using data from the New York Taxi trips.

## License

This project is licensed under the terms of the GNU General Public License version 3 (GPLv3).
