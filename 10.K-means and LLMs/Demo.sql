/* BEFORE RUNNING THIS DEMO: 

- Change <YourDataset> with the name of your dataset (find/replace)
- Change <YourBaseTable> with the name of the table in which you uploded the demo data

*/

 
 
  ## Start with the base data:
SELECT
  *
FROM
  `<YourDataset>.<YourBaseTable>`
where rand() < 0.015;


  ##See the predicted Customer Groups:
SELECT
  *
FROM
  `<YourDataset>.account_predicted_groups` -- View `<YourDataset>.account_predicted_groups`: Shows predictions of account group memberships from the `<YourDataset>.account_groups` k-means clustering model, excluding distances to centroids.
where rand() < 0.015;
  
  
  ##Use GenAI to infere the content of all columns (single shot):
SELECT
  *
FROM
   `<YourDataset>.llm_columns_description`;
-- Single shot analysis on roughly 1% of data. 
-- Tests shown 1% could be a reliable amount to get decent descriptions



  ##With semantic knowledge of what the different columns contain, use GenAI to infere what the Centeroids describe (single shot)
SELECT
  * from `<YourDataset>.llm_groups_description`;
-- Single shot analysis on roughly 1% of data per-centeroid. 


## Multi-shot analysis
CALL `<YourDataset>`.insert_descriptions_n_times(20); 
-- With N Epochs, we'll consider rougly N% of the available data (default 20)
-- Stored Procedure to insert (truncate at start) group descriptions from `<YourDataset>.groups_description_llm` into a <YourDataset> table `<YourDataset>.analysis_results` N times;

##Inspect the table
select * from `<YourDataset>.analysis_results` order by 1;
-- Appreciate different outcomes for different epochs


## Run a LLM inference on the multi-shotted data
select * from `<YourDataset>.llm_group_description_multi`; 
-- View `<YourDataset>.llm_group_description_multi` aggregates `<YourDataset>.analysis_results` into a JSON array and generates a summarized group description using the `<YourDataset>.llm` model.
-- Prompt is: You are a key data analyst. You'll be provided of many intepretations of the contents of Customer Groups 1,2 and 3. Review the data, and respond with a reasonable summary of the most relevant and recurrent inputs - exclude any outliers. 


## Let's check if this makes sense

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
  random_number < 0.01
  order by 1

