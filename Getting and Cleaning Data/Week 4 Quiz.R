
library(dplyr)

#Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value 
#of the 123 element of the resulting list?

idaho <- read.csv("../Johns Hopkins/idaho.csv")
splitNames = strsplit(names(idaho),"wgtp")
splitNames[[123]]

#Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?

gdp <- read.csv("../Johns Hopkins/GDP.csv", na.strings="", skip=4, nrows=190)
gdp <- gdp[,c(1,2,4,5)]
colnames(gdp)  <- c("CountryCode", "Ranking", "Name", "Size")

gdp$Size <- sub(",","", gdp$Size)
mean(as.numeric(gdp$Size), na.rm=TRUE)

#How many countries begin with United?

gdp[grepl("^United", gdp$Name),]

#Of the countries for which the end of the fiscal year is available, how many end in June?

col <- merged$Special.Notes

length(col[grepl("[Ff]iscal.*June", col)])

#Use the following code to download data on Amazon's stock price and get the times the data was sampled.
#How many values were collected in 2012? How many values were collected on Mondays in 2012?

install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

selectTimes <- sampleTimes[grepl("2012", sampleTimes)]
length(selectTimes)

days <- weekdays(as.Date(selectTimes, '%d-%m-%y'))
table(days)





