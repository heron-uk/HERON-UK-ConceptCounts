# HERON UK: Concept Counts

## Overview

This repository contains code for generating concept-level counts from the clinical tables of a database mapped to the OMOP Common Data Model (CDM).
It is part of the onboarding process for [HERON UK](https://heron-uk.github.io/heron-uk/)

## Getting Started

### Prerequisites

-   **R** and **RStudio** are required to run the code.
-   Ensure that you have access to the database and necessary credentials to connect.

### Setup Instructions

1.  **Download the Repository**\
    Download this repository:

    -   Either download as a ZIP file using `Code -> Download ZIP`, then unzip.
    -   Or, use GitHub Desktop to clone the repository.

2.  **Open the R Project**

    -   Navigate to the `ConceptCounts` folder and open the project file `ConceptCounts.Rproj` in RStudio.
    -   You should see the project name in the top-right corner of your RStudio session.

3.  **Run the Analysis Code**

    -   Open the `CodeToRun.R` file. This is the main script you’ll use.
    -   Follow the instructions within the file to add your database-specific information.
    -   Run the code as directed. This will generate a `Results` folder containing the outputs, including a ZIP file with the results for sharing.

4.  **OPTIONAL: Visualize Results in Shiny**

    -   Navigate to the `shiny` folder and open the project file `shiny.Rproj` in RStudio.
    -   You should see the project name in the top-right corner of your RStudio session.
    -   Copy the generated result files (in .csv format) into the `Data` folder located within the `Shiny` folder.
    -   Open the `global.R` script in the `shiny` folder.
    -   Click the *Run App* button in RStudio to launch the local Shiny app for interactive exploration of the results.
## Notes

Please ensure any database credentials are stored securely and never committed to the repository.

For more information about the HERON UK project and data standards, visit the [HERON UK](https://heron-uk.github.io/heron-uk/) website
