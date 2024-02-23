# Import and View Dataset / Remove Scientific Notations
MeteoriteLandings_Cleaned <- read_excel("MeteoriteLandings_Cleaned.xlsx")
View(MeteoriteLandings_Cleaned)
options(scipen=999)

# Top 5 Largest meteorites recorded by their mass (& create variable)
top_mass_5 <- MeteoriteLandings_Cleaned[order(MeteoriteLandings_Cleaned$mass_g, decreasing=TRUE),]

head(top_mass_5, 5)

# What is the average mass of meteorite? (dropping NA values)
mean(MeteoriteLandings_Cleaned$mass_g, na.rm=TRUE)

# What is the Smallest mass of meteorite? (ignoring values of 0.000)
smallest <- MeteoriteLandings_Cleaned

# filter dataframe to sort, excluding 0, smallest to largest result
filtered_smallest <- filter(smallest, smallest$mass_g > 0)
filtered_smallest_Sort <- filtered_smallest[order(filtered_smallest$mass_g),]

head(filtered_smallest_Sort, 10)

# What year had the most recorded meteorite landings?
MeteoriteLandings_Cleaned %>%
  count(year, sort=TRUE)

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

# What are the few most common classifications of meteorites?

common_class <- MeteoriteLandings_Cleaned %>%
  count(classification, sort=TRUE)

head(common_class)

# making a separate table to create a line graph using head(common_class) results

cc_df <-
  tibble::tribble(
    ~class, ~count,
    "L6", 8339,
    "H5", 7164,
    "L5", 4817,
    "H6", 4529,
    "H4", 4222,
    "LL5", 2766
  )

# line graph with the created table = cc_df

ggplot(cc_df, aes(x=fct_inorder(class), y=count, group=1)) +
  geom_line(size=1.5, color="deepskyblue3") +
  scale_y_continuous(n.breaks=8) +
  geom_text(aes(label=count), vjust=-0.5, hjust=-.2, size=3) +
  labs(title="Most Common Meteorite Classifications",
       subtitle="Based on the count data for Classifications",
       x="Meteorite Classifications", y="") +
  theme(text = element_text(family="Bahnschrift")) +
  theme(legend.position = "none") +
  theme_minimal()

# Map View of the meteorite locations, using latitude and longitude.
# Remove any missing values in latitude and longitude first

Removed_Coords <- MeteoriteLandings_Cleaned %>%
  drop_na(latitude, longitude)

Locations <- sf::st_as_sf(
  Removed_Coords,
  coords = c("longitude", "latitude"),
  crs = 4326 # lat/long coordinate reference system
)

mapview::mapview(Locations)

# Is there any significant spike in findings during any point?

year_count <- summary(factor(MeteoriteLandings_Cleaned$year))
print(year_count)
