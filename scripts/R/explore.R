#
# Exploring UNOSAT's product metadata
# to prepare interactive visualizations.
#
# Author: Luis Capelo | luiscape@gmail.com
#

library(scales)
library(ggplot2)

source('scripts/R/process.R')


data <- ProcessData()

plot.proucts_per_year <- ggplot(data) + 
  geom_bar(aes(dataset_date), stat='bin') +
  labs(x = 'Number of Products', y = 'Year', title = 'UNOSAT Products per Year and Continent')

ggsave('images/plot_products_per_year_without_color.png', plot.proucts_per_year)



plot.proucts_per_year <- 
  ggplot(filter(data, dataset_date > as.Date('2014-01-01'))) + 
  geom_bar(aes(dataset_date, fill=region), stat='bin', binwidth=7) +
  scale_x_date(labels = date_format("%Y-%m"), breaks = date_breaks("month")) +
  labs(x = 'Number of Products', y = 'Year', title = 'UNOSAT Products per Year and Continent')

ggsave('images/plot_products_per_year.png', plot.proucts_per_year)
