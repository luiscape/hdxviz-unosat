#
# Preparing UNOSAT data for exploration
# and modeling.
#
# Author: Luis Capelo | luiscape@gmail.com
#

library(dplyr)
library(lubridate)
library(countrycode)


ProcessData <- function(write_csv=TRUE) {

  #
  # Loading data.
  #
  data <- read.csv('data/page_list.csv')

  #
  # Creating ISO3 codes.
  #
  data$iso <- countrycode(data$country_name, 'country.name', 'iso3c')
  data$iso <- ifelse(data$country_name == 'Horn Of Africa', 'SOM', as.character(data$iso))
  data$iso <- ifelse(data$country_name == 'Autonomous Province of Kosovo', 'UNK', as.character(data$iso))
  data$iso <- ifelse(data$country_name == 'Salvador', 'SLV', as.character(data$iso))

  #
  # Adding continent.
  #
  data$region <- countrycode(data$iso, 'iso3c', 'region')
  data$continent <- countrycode(data$iso, 'iso3c', 'continent')
  data$region <-  ifelse(
          data$region == 'Western Asia' &
            data$country_name != 'Georgia' &
            data$country_name != 'Armenia',
          'Middle East',
          data$region
        )

  #
  # Eliminating global entries.
  #
  data <- filter(data, country_name != 'Global')

  #
  # Converting date objects.
  #
  data$dataset_date <- as.Date(data$dataset_date)
  data$year <- year(data$dataset_date)
  
  #
  # Adding link to HDX.
  #
  data$link_to_hdx <- paste0('https://data.hdx.rwlabs.org/dataset?organization=un-operational-satellite-appplications-programme-unosat&groups=', tolower(data$iso))
  
  #
  # Writting CSV
  #
  if (write_csv) write.csv(data, 'data/processed_data.csv', row.names=FALSE)

  return(data)
}
