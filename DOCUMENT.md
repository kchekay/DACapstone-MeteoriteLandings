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
# Questions

### Characteristics

**What are the top 5 largest recorded meteorites? (mass in grams)**
```
# Top 5 Largest meteorites recorded by their mass (& create variable)
top_mass_5 <- MeteoriteLandings_Cleaned[order(MeteoriteLandings_Cleaned$mass_g, decreasing=TRUE),]

head(top_mass_5, 5)

# A tibble: 5 × 10
  name               id nametype classification   mass_g fell_or_found  year latitude longitude geolocation           
  <chr>           <dbl> <chr>    <chr>             <dbl> <chr>         <dbl>    <dbl>     <dbl> <chr>                 
1 Hoba            11890 Valid    Iron, IVB      60000000 Found          1920    -19.6      17.9 (-19.58333, 17.91667) 
2 Cape York        5262 Valid    Iron, IIIAB    58200000 Found          1818     76.1     -64.9 (76.13333, -64.93333) 
3 Campo del Cielo  5247 Valid    Iron, IAB-MG   50000000 Found          1575    -27.5     -60.6 (-27.46667, -60.58333)
4 Canyon Diablo    5257 Valid    Iron, IAB-MG   30000000 Found          1891     35.0    -111.  (35.05, -111.03333)   
5 Armanty          2335 Valid    Iron, IIIE     28000000 Found          1898     47        88   (47.0, 88.0)
```
Results:
1. Hoba: 60,000,000g
2. Cape York: 58,000,000g
3. Camp del Ceilo: 50,000,000g
4. Canyon Diablo: 30,000,000g
5. Armanty: 28,000,000g

**What is the average mass of meteorite?**
```
# What is the average mass of meteorite? (dropping NA values)
mean(MeteoriteLandings_Cleaned$mass_g, na.rm=TRUE)
[1] 13240.03
```
The average mass in the dataset is 13,240,03g.

**What is the smallest meteorite ever recorded?**
*Note: due to certain meteorites being labeled 0.000 due to the weight being unrecorded, the best method is filtering the dataset in from smallest to largest.*
```
# What is the Smallest mass of meteorite? (ignoring values of 0.000)
smallest <- MeteoriteLandings_Cleaned

# filter dataframe to sort, excluding 0, smallest to largest result
filtered_smallest <- filter(smallest, smallest$mass_g > 0)
filtered_smallest_Sort <- filtered_smallest[order(filtered_smallest$mass_g),]
head(filtered_smallest_Sort, 10)

# A tibble: 10 × 10
   name                      id nametype classification         mass_g fell_or_found  year latitude longitude geolocation     
   <chr>                  <dbl> <chr>    <chr>                   <dbl> <chr>         <dbl>    <dbl>     <dbl> <chr>           
 1 Yamato 8333            29438 Valid    H5                      0.01  Found          1983    -71.5      35.7 (-71.5, 35.6666…
 2 LaPaz Icefield 04531   34986 Relict   Chondrite-fusion crust  0.01  Found          2004      0         0   (0.0, 0.0)      
 3 Meteorite Hills 001139 45809 Relict   Fusion crust            0.013 Found          2000    -79.7     160.  (-79.68333, 159…
 4 Yamato 8408            29455 Valid    E5                      0.02  Found          1984    -71.5      35.7 (-71.5, 35.6666…
 5 Grove Mountains 050023 48150 Valid    L6                      0.03  Found          2006    -73.1      75.2 (-73.1075, 75.1…
 6 MacAlpine Hills 02823  15111 Valid    H5                      0.04  Found          2002      0         0   (0.0, 0.0)      
 7 MacAlpine Hills 02762  15055 Valid    H6                      0.05  Found          2002      0         0   (0.0, 0.0)      
 8 MacAlpine Hills 02804  15094 Valid    H5                      0.06  Found          2002      0         0   (0.0, 0.0)      
 9 MacAlpine Hills 02628  14926 Valid    H5                      0.07  Found          2002      0         0   (0.0, 0.0)      
10 MacAlpine Hills 02883  15167 Valid    H5                      0.07  Found          2002      0         0   (0.0, 0.0)
```
The result that shows up is Meteorite Yamato 8333 and LaPaz Icefield 04531 have the smallest recorded mass of 0.010 grams.

**What year had the most recorded meteorite landings?**

Created a separate table of the years and the count, for easier visualization.

```
# What year had the most recorded meteorite landings?
MeteoriteLandings_Cleaned %>%
  count(year, sort=TRUE)

# A tibble: 265 × 2
    year     n
   <dbl> <int>
 1  2003  3323
 2  1979  3046
 3  1998  2697
 4  2006  2456
 5  1988  2296
 6  2002  2078
 7  2004  1940
 8  2000  1792
 9  1997  1696
10  1999  1691
# ℹ 255 more rows
# ℹ Use `print(n = ...)` to see more rows

# Visual bar graph for the (10) years of most recorded meteorite landings
Top_10_Years <- data.frame(
  Year = c(2003, 1979, 1998, 2006, 1988, 2002, 2004, 2000, 1997, 1999),
  Count = c(3323, 3046, 2697, 2456, 2296, 2078, 1940, 1792, 1696, 1691)
)

ggplot(Top_10_Years, aes(x=fct_inorder(as.character(Year)), y=Count, fill=Count)) +
  geom_col(width=.7) +
  geom_text(aes(label=Count), vjust=-0.4, hjust=0.5, size=3.5) +
  scale_fill_gradient(low="brown3", high="deepskyblue3") +
  labs(title="Years With Most Meteorite Landings",
       x="", y="") +
  theme(text = element_text(family="Bahnschrift")) +
  theme(legend.position = "none")
```


