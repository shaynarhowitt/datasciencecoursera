
library(plyr)
library(Hmisc)

#Create a logical vector that identifies the households on greater than 10 acres who sold 
#more than $10,000 worth of agriculture products. Assign that logical vector to the variable 
#agricultureLogical. Apply the which() function to identify the rows of the data frame where 
#the logical vector is TRUE.

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile="../Johns Hopkins/idaho.csv", method = "curl")
list.files("../Johns Hopkins")

idaho <- read.csv("../Johns Hopkins/idaho.csv")
head(idaho)

#ACR - lot size; 3 - house on 10+ acres
#AGS - sales of ag products; 6 - sold $10,000+ 

agricultureLogical <- idaho$ACR %in% c(3) & idaho$AGS %in% c(6)
idaho[which(agricultureLogical),]

#Using the jpeg package read in the following picture of your instructor into R
#https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 

library(jpeg)

img <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(img, destfile = "../Johns Hopkins/image.jpeg", method = "curl")
image <- readJPEG("../Johns Hopkins/image.jpeg", native=TRUE)

quantile(image, c(.3, .8))

#Load GDP data and educational data
#Match the data based on the country shortcode. How many of the IDs match? Sort the data frame 
#in descending order by GDP rank (so United States is last). What is the 13th country in the 
#resulting data frame?

#loading and cleaning GDP data

fileurl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileurl2, destfile="../Johns Hopkins/GDP.csv", method = "curl")
              
gdp <- read.csv("../Johns Hopkins/GDP.csv", na.strings="", skip=4, nrows=190)
gdp <- gdp[,c(1,2,4,5)]
colnames(gdp)  <- c("CountryCode", "Ranking", "Name", "Size")

#loading and cleaning educational data

fileurl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileurl3, destfile="../Johns Hopkins/stats.csv", method = "curl")
stats <- read.csv("../Johns Hopkins/stats.csv")

#merge based on country code

merged <- merge(gdp, stats, by = "CountryCode")
dim(merged)

#arrange by ranking
merged <- arrange(merged, desc(Ranking))
merged[13, 'Long.Name']

#What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

oecd <- merged[merged$Income.Group == "High income: OECD", ]
mean(oecd$Ranking)

nonOecd <- merged[merged$Income.Group == "High income: nonOECD", ]
mean(nonOecd$Ranking)

#Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
#are Lower middle income but among the 38 nations with highest GDP?

merged$rankingGroups = cut2(merged$Ranking, g=5)
unique(merged$rankingGroups)

table(merged$rankingGroups, merged$Income.Group)




