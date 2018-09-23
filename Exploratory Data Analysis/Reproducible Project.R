

#download, read, and subset data
storm <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(storm, destfile="./storm.csv")
storm1 <- read.csv("./storm.csv")
substorm_health <- subset(storm1, select=c("EVTYPE", "FATALITIES", "INJURIES"))
substorm_econ <- subset(storm1, select=c("EVTYPE", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP" ))

storm1$BGN_DATE <- as.Date(storm1$BGN_DATE, format="%m/%d/%Y")
summary(storm1$BGN_DATE)
length(unique(storm1$EVTYPE))

#which events (EVTYPE) are most harmful WRT population health?

#which event caused the most fatalities in one occurence?
substorm_health[which.max(substorm_health$FATALITIES), 'EVTYPE'] #HEAT

#which event caused the most fatalities in aggregate?
agg_fatalities <- aggregate(substorm_health$FATALITIES, by = list(Category = substorm_health$EVTYPE), FUN=sum)
agg_fatalities$x <- as.integer(as.character(agg_fatalities$x))

top_agg_fatalities <- agg_fatalities[order(agg_fatalities$x, decreasing=TRUE), ][1:11, ]

par(las=2)
par(mar=c(6,5,4,2))
barplot(with(top_agg_fatalities, setNames(x, Category)), xlab="", ylab="Deaths", 
        cex.names=0.6, main="Fatalities per Event")

#which event caused the most injuries in one occurence?
substorm_health[which.max(substorm_health$INJURIES), 'EVTYPE'] #TORNADO

#which event caused the most injuries in aggregate?
agg_injuries <- aggregate(substorm_health$INJURIES, by = list(Category = substorm_health$EVTYPE), FUN=sum)
agg_injuries$x <- as.integer(as.character(agg_injuries$x))

top_agg_injuries <- agg_injuries[order(agg_injuries$x, decreasing=TRUE), ][1:11, ]

par(las=2)
par(mar=c(6,5,4,2))
barplot(with(top_agg_injuries, setNames(x, Category)), xlab="", ylab="Injuries", 
        cex.names=0.6, cex.axis = 0.7, main="Injuries per Event")

#which events have the greatest economic consequences?

substorm_econ$PROPDMG <- as.integer(substorm_econ$PROPDMG)

propexp <- substorm_econ$PROPDMGEXP

substorm_econ$PROPDMGEXP1 <- 
  ifelse(propexp=='K', 1000,
               ifelse(propexp=='k', 1000,
                      ifelse(propexp=='B', 1000000000,
                             ifelse(propexp=='m', 1000000,
                                    ifelse(propexp=='M', 1000000,
                                    1  )))))

substorm_econ$PROPDMG_combined <- substorm_econ$PROPDMG * substorm_econ$PROPDMGEXP1

cropexp <- substorm_econ$CROPDMGEXP
unique(substorm_econ$PROPDMG)

substorm_econ$CROPDMGEXP1 <- 
  ifelse(cropexp=='K', 1000,
         ifelse(cropexp=='k', 1000,
                ifelse(cropexp=='B', 1000000000,
                       ifelse(cropexp=='m', 1000000,
                              ifelse(cropexp=='M', 1000000,
                                     1  )))))

substorm_econ$CROPDMG_combined <- substorm_econ$CROPDMG * substorm_econ$CROPDMGEXP1

substorm_econ$total_damage <- substorm_econ$PROPDMG_combined + substorm_econ$CROPDMG_combined


#which event caused the greatest damage in one occurence?
substorm_econ[which.max(substorm_econ$total_damage), 'EVTYPE'] #FLOOD

#which event caused the economic damage in aggregate?
agg_econ_damage <- aggregate(substorm_econ$total_damage, by = list(Category = substorm_econ$EVTYPE), FUN=sum)
agg_econ_damage$x <- as.integer(as.character(agg_econ_damage$x))

top_agg_econ <- agg_econ_damage[order(agg_econ_damage$x, decreasing=TRUE), ][1:11, ]

par(las=2)
par(mar=c(6,5,4,2))
barplot(with(top_agg_econ, setNames(x, Category)), xlab="", ylab="Economic Damage", 
        cex.names=0.6, cex.axis = 0.7, main = 'Total Economic Damage Per Event')

agg_econ_damage[order(agg_econ_damage$x, decreasing=TRUE), ][1:10, ]

