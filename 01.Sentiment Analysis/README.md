<p align="center">
<img src="https://github.com/andrewankenobi/DataGenAIHackaton/blob/main/1.Sentiment%20Analysis/uc1.png" width="350" height="350" alt="Cool Logo" style="border-radius: 10px;">
</p>


# BigQuery ML Sentiment Analysis with LLM

## Overview
This repository contains a SQL script demonstrating the use of BigQuery ML to leverage Large Language Models (LLMs) for sentiment analysis. The script integrates Google Cloud's BigQuery with external LLMs to perform sentiment analysis on movie reviews from the IMDb dataset available in BigQuery public data.

## Prerequisites
- Access to Google Cloud Platform (GCP) with BigQuery enabled.
- Necessary permissions to create and run BigQuery jobs, create models, and establish connections.
- Basic understanding of SQL and BigQuery ML.

## Features
- **Data Assessment**: Extracts a sample of movie titles and their reviews.
- **Data Persistence**: Creates a new table to store a subset of the reviews.
- **Connection Setup**: Involves setting up a connection for BigQuery ML to interact with external LLMs.
- **Model Creation**: Demonstrates how to create a BigQuery ML model endpoint.
- **Sentiment Analysis**: Utilizes the LLM model to conduct sentiment analysis on the movie reviews.

## How to Use
1. **Clone the Repository**: Clone this repository to your local machine or directly into Google Cloud Shell.
2. **Set up BigQuery**: Ensure your GCP project is set up with BigQuery.
3. **Create a Connection**: Follow the instructions in the script to create a connection to the external LLM service.
4. **Execute the Script**: Run the SQL script in the BigQuery console or using the `bq` command-line tool.
5. **View Results**: After execution, view the results for insights into the sentiment of the movie reviews.

## Additional Information
- The script comments provide guidance and links to relevant Google Cloud documentation for specific steps like creating connections and managing permissions.
- Modify the script as needed to suit your specific requirements or to analyze a different dataset.


## License

This project is licensed under the terms of the GNU General Public License version 3 (GPLv3).
