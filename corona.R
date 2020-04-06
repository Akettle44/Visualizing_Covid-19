library(utils)
library(httr)
library(tidyverse)
library(plotly)

#download the dataset from the ECDC website to a local temporary file
GET("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".csv")))

#read the Dataset sheet into “R”. The dataset will be called "data".
corona <- read.csv(tf)

view(corona)

scorona <- select(corona, dateRep, day, month, year, countriesAndTerritories, cases, deaths, popData2018)
scorona <- na.omit(scorona)

scorona$dateRep <- as.Date(scorona$dateRep, format = "%d/%m/%y")
scorona <- filter(scorona, dateRep != "2019/12/31" & dateRep != "2020/12/31")

view(scorona)
#head(corona)
tail(scorona)

scorona <- arrange(scorona, year, month, day, countriesAndTerritories)

overalldata <- data.frame("date" = scorona$dateRep, "Country" = scorona$countriesAndTerritories, "Overall_cases" = 0)

calcOverall <- function(df, country, date)
{
    df <- filter(df, (df$countriesAndTerritories == country) & (df$dateRep <= date))
    overall <- cumsum(df$cases)
    return(overall)
}

for(country in scorona$countriesAndTerritories)
{
    cumcases <- calcOverall(scorona, country, (scorona[country,])$dateRep)
    overalldata[country,]$Overall_cases <- cumcases
}

tail(overalldata)

cplot <- ggplot(data = overalldata, aes(x = date, color = country)) +
    geom_line(aes(y = Overall_cases)) +
    scale_x_date(date_labels = "%b %Y")

ggplotly(cplot)

#cplot <- ggplot(data = scorona, aes(x = dateRep, color = countriesAndTerritories)) +
#    geom_line(aes(y = cases)) +
#    scale_x_date(date_labels = "%b %Y")