library(utils)
library(httr)
library(tidyverse)
library(plotly)

#download the dataset from the ECDC website to a local temporary file
GET("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".csv")))

#read the Dataset sheet into “R”. The dataset will be called "data".
corona <- read.csv(tf)

scorona <- select(corona, dateRep, day, month, year, countriesAndTerritories, cases, deaths, popData2018)
scorona <- na.omit(scorona)

scorona$dateRep <- as.Date(scorona$dateRep, format = "%d/%m/%y")
scorona <- filter(scorona, dateRep != "2019/12/31" & dateRep != "2020/12/31")

scorona <- arrange(scorona, countriesAndTerritories, year, month, day)

head(scorona)
#scorona <- filter(scorona, countriesAndTerritories == "China")
#thedata <- sum(scorona$cases)
#thedata

cumdata <- data.frame(matrix(ncol = 3, nrow = 0))
names <- c("date", "country", "cases")
colnames(cumdata) <- names

calcOverall <- function(df, country)
{
    df <- filter(df, df$countriesAndTerritories == country)
    overall <- cumsum(df$cases)
    udf <- data.frame("date" = df$dateRep, "country" = country, "cases" = overall)
    return(udf)
}

for(country in unique(scorona$countriesAndTerritories))
{
    temp <- calcOverall(scorona, country)
    print(temp)
    cumdata <- rbind(cumdata, temp)
}

head(cumdata)

cplot <- ggplot(data = cumdata, aes(x = date, color = country)) +
    geom_line(aes(y = cases)) +
    scale_x_date(date_labels = "%b %Y")

ggplotly(cplot)
