library(utils)
library(httr)
library(tidyverse)
library(plotly)

#download the dataset from the ECDC website to a local temporary file
GET("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".csv")))

#read the Dataset sheet into “R”. The dataset will be called "data".
corona <- read.csv(tf)
head(corona)
view(corona)

scorona <- select(corona, dateRep, geoId, cases, deaths, popData2018)
view(scorona)
scorona <- na.omit(scorona)

scorona <- arrange(scorona, dateRep, geoId)
scorona <- filter(scorona, dateRep != "31/12/2019" & dateRep != "31/12/2020")

scorona$dateRep <- as.Date(scorona$dateRep, format = "%d/%m/%y")

scorona

head(scorona)
tail(scorona)

scorona <- group_by(scorona, geoId)

ggplot(data = scorona, aes(x = dateRep, color = geoId)) +
    geom_line(aes(y = cases)) +
    scale_x_date(date_labels = "%b %Y")

#ggplot(data = scorona, aes(x = dateRep, y = cases)) +
#    geom_bar(stat = "identity")

#ggplot(data = scorona, aes(x = dateRep)) +
#    geom_smooth(aes(y = deaths)) +
#        geom_smooth(aes(y = cases))

corona <- plot_ly(corona, x = ~cases, y = ~deaths, text = corona$geoId, color = ~geoId)
corona



