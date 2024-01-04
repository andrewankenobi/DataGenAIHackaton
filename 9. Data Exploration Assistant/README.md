<p align="center">
<img src="https://github.com/andrewankenobi/DataGenAIHackaton/blob/main/1.Sentiment%20Analysis/uc9.png" width="350" height="350" alt="Cool Logo" style="border-radius: 10px;">
</p>


# Data Exploration Assistant using Looker's Semantic Layer

## Overview
This repository contains Notebooks to generate a context for a natural language query interface. It uses LLM to translate users' query into a structure Looker query and display the results in Looker's Explore.

## Prerequisites
- Access to Google Cloud Platform (GCP) with Vertex AI Enabled.
- Access to a Looker Instance.
- Basic understanding of Looker's Explore Interface.

## Features
- **Natural Language Query**: Query data in Looker using Natural Language
- **Visualisation**: Define Visualisation to plot the data

## How to Use
1. **Clone the Repository**: Clone this repository to your local machine or directly into Google Cloud Shell.
2. **Set up Vertex AI**: Ensure your GCP project is set up with Vertex AI.
3. **Access to Looker**: Ensure you have access to a Looker instance and logged in. Private Embedding must be enabled as well.
4. **Third Party Cookes** : Ensure you enable Third Party Cookies. 
5. **Execute the Script**: Execute the first Notebook and copy the results. Execute the second Notebook, after pasting the results into the relevant variable *context*
6. **View Results**: After execution, view the results for insights into the sentiment of the movie reviews.

## Additional Information
- The Notebook comments provide guidance
- Modify the script as needed to suit your specific requirements or to analyze a different semnatic model.


## License

This project is licensed under the terms of the GNU General Public License version 3 (GPLv3).
