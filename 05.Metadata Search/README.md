<p align="center">
<img src="uc5.png" width="350" height="350" alt="Cool Logo" style="border-radius: 10px;">
</p>

# Creating basic Semantic Search app for BigQuery tables using Vertex Embeddings 

This project is an example use case for the GenAI hackathon. It is a demonstration of a simple app used to semantic searching based on query2description similarity.
All data and metadata comes from BigQuery public datasets. 
As an extra some of the descriptions are missing and we use Text Bison to generate it based on fields description.

Application is using Gradio to visualise search results and ChromaDB as vector store to find results. 


## Code Overview

The Colab Notebook `semantic_search` performs the following steps:

1. **Installs Vertex AI SDK and other missing packages like ChromaDB, Gradio. langchain and BigQuery client**.

2. **Create coollection of medadata** This step creates the `generate` function to call the model. Adjust the prompt as you see fit.

4. **Stick together all descriptions into one big chunk and optionally generate metadata:** Function that sticks together dataset, table and field descriptions into table record can also generate missing table description

5. **Loading descriptions into Vectorstore:** In this step we load chunks into vector store. THere are implicit calls to Vertex AI Embeddings done during loading by ChromaDB and langchain client. 

## Usage

Use the embedded Gradio application to search in the vector store using any search phrase. The search function calls vertex embeddings to turn search phrase into embedding representation. It is done implicitly

## Dependencies

This notebook requires access to the VertexAI Generative models to generate embeddings.

## License

This project is licensed under the terms of the GNU General Public License version 3 (GPLv3).
