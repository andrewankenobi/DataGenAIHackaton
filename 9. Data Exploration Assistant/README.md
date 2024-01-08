<p align="center">
<img src="https://github.com/andrewankenobi/DataGenAIHackaton/blob/main/9.%20Data%20Exploration%20Assistant/uc9.png" width="350" height="350" alt="Cool Logo" style="border-radius: 10px;">
</p>


# Data Exploration Assistant using Looker's Semantic Layer

## Overview
This repository contains Notebooks to generate a context for a natural language query interface. It uses LLM to translate users' query into a structure Looker query and display the results in Looker's Explore.

<img src="https://github.com/andrewankenobi/DataGenAIHackaton/blob/main/9.%20Data%20Exploration%20Assistant/image1.git"  alt="Demo" >

## Prerequisites
- Access to Google Cloud Platform (GCP) with Vertex AI Enabled.
- Access to a Looker Instance.
- Basic understanding of Looker's Explore Interface.

## Features
- **Natural Language Query**: Query data in Looker using Natural Language
- **Visualisation**: Define Visualisation to plot the data

## How to Use
1. **Clone the Repository**: Clone this repository to your local machine or directly into Google Cloud Shell.
2. **Set up Vertex AI**: Ensure your GCP project is set up with Vertex AI and all the API needed enabled.
3. **Access to Looker**: Ensure you have access to a Looker instance and logged in. [Private Embedding](https://cloud.google.com/looker/docs/private-embedding) must be enabled as well.
4. **Third Party Cookiees** : Ensure you enable Third Party Cookies. 
5. **Execute the Script**: Execute the Notebook number 1 and copy the results. Execute the second Notebook, after pasting the results into the relevant variable *context*
6. **View Results**: After execution, view the results for insights into the sentiment of the movie reviews.

## Examples of Questions to test 
- What were my sales last week ?
- Sales for Levi’s by category and department in the last 6 months as **line chart**
- Count of users by traffic source **year over year** as **table**
- Order details for customer **jamessmith@gmail.com**
- Customers who like Calvin Klein and age > 24 

## Additional Information
- The Notebook comments provide guidance
- Modify the script as needed to suit your specific requirements or to analyze a different semnatic model.


## License

This project is licensed under the terms of the GNU General Public License version 3 (GPLv3).
