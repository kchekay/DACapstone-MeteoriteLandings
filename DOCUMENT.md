# Meteorite Landings
## Google Data Analytics Capstone Project

**Author:** kchekay\
**Date:** 02/22/2024\
**Tools Used:** Excel, SQL(BigQuery), R (RStudio), Tableau


[Dataset Source](https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh/about_data)

[Google Document version here](https://docs.google.com/document/d/1kVb9r5TbEqCEM2WUz1StEYAiVT9-Ulqv7vIHcLH6J9o/edit?usp=sharing)

### Task

Perform data analysis on NASA’s recorded meteorite landings, to identify trends and patterns in the data.

### Goals

Uncover information about the landings and offer insight into various aspects of meteorites, their characteristics, geographical information, and the occurrences.

+ What is the most common classification of meteorite?
+ What is the average mass of meteorite? Largest recorded?
+ Which countries have the highest number of recorded meteorite landings?
+ What year had the most recorded landings?
+ Can we identify any region with high or low meteorite landings?
+ Is there any other trends or patterns we can uncover in the classifications?

These are all key questions that can be looked into once the data is clean.

### Methods

Clean and prepare the data. Dive into statistical analysis and see if there are questions that can be answered and discovered. Visualize the data with the findings.

# About the Dataset

The dataset was pulled off of NASA’s Open Data Portal, containing comprehensive data from The Meteoritical Society, containing information on all known meteorite landings. The dataset consists of over 45,000 known meteorite landings between 860 and 2013 with the following columns:

+ Name
+ ID
+ Nametype (Valid or Relict)
+ Classification
+ Mass (Grams)
+ Fell / or was Found
+ Year
+ Recorded Latitude
+ Recorded Longitude
+ GeoLocation

### Additional Notes

1. There has been no recent updates in regards to the dataset of most recent meteorites anytime after 2013, however the information source (not the dataset), the website’s database, continues to update frequently. [Source](https://www.lpi.usra.edu/meteor/about.php)
2. Under Nametype, ‘valid’ is for a properly classified meteorite. ‘Relict’ meteorite is a highly altered object that may have a meteoritic origin and cannot be assigned easily to a class. These are dominantly (>95%) composed of secondary minerals formed on the body on which the object was found. [Source](https://www.lpi.usra.edu/meteor/metbullclass.php?sea=Relict%20meteorite)
3. The Classification list and all the explanations of different types can be found here for any needed reference.
4. Extra research was applied to ensure accuracy, as there were many points of the data being empty or null.

# Cleaning Process

I used SQL (BigQuery) to start cleaning the dataset, to ensure there were no duplicates or potential errors that could cause inaccurate results.

```
SELECT
  name,
  id,
  nametype,
  recclass AS classification,
  mass__g_ AS mass_g,
  fall AS fell_or_found,
  year,
  reclat AS latitude,
  reclong AS longitude,
  geolocation

FROM 'kcpersonals.nasa_meteorites.meteorites'
```

Renamed columns for quick access to columns, and easier reading, creating a cleaned dataset to save any changes.

### SQL: Duplicates / Errors

Checking for duplicates using SELECT DISTINCT for the whole dataset, as well as for the nametype, year, and fell_or_found fields to ensure there were no typos.

```
SELECT DISTINCT
  year
FROM 'kcpersonals.nasa_meteorites.meteorites'
ORDER BY year DESC

| row | year     |
|-----|----------|
| 1   | 2101     |
| 2   | 2013     |
| 3   | 2012     |
| 4   | 2011     |
| 5   | 2010     |
5 of ...
```

A typo in the year field was found during the usage of SELECT DISTINCT.

### Excel: Corrections

All corrections were made in Excel due to BigQuery restrictions.

+ There was a found typo in the year field: *2101* instead of *2010.*
+ There was a large amount of rows in the **mass_g, latitude, longitude,** and **geolocation** that were null. Any empty values were corrected to 0, to match with the data that had no known records and already recorded with 0 before cleaning.
+ The year field had missing data, research was done in to fill in any information that might have been missed. All current data was correct, and the years were left null due to no information on the year of the landings.
+ No typos or duplicates were found in any other field.

Once the data is clean and free of duplicates, I pulled it into R (RStudio) to begin visualization and to dig further into the information of the dataset. 

# Preparing the Data

R: Visualization

Install necessary packages and load them into the library.

```
install.packages("ddplyr")
install.packages("extrafont")
install.packages("janitor")
install.packages("ggplot2")
install.packages("mapview")
install.packages("readr")
install.packages("readxl")
install.packages("rmarkdown")
install.packages("systemfonts")
install.packages("tidyverse")

library(ddplyr)
library(extrafont)
library(janirot)
library(ggplot2)
library(mapview)
library(readr)
library(readxl)
library(rmarkdown)
library(systemfonts)
library(tidyverse)

# Install fonts from pc
font_import() 

# Remove scientific notations
options(scipen=999)

MeteoriteLandings_Cleaned <- read_excel(“MeteoriteLandings_Cleaned.xlsx”)
view(MeteoriteLandings_Cleaned)
```


