
library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
#data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008
#for each year, table contains tons of PM2.5 emitted from a specific type of source for entire year
#cols: fips (county), SCC (name of source), Pollutant, Emissions (in tons), type of source

SCC <- readRDS("Source_Classification_Code.rds")
#provides mapping from SCC digit strings to the actual name of the PM2.5 source

#Q 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources / year 

agg_PM <- aggregate(NEI$Emissions, by=list(Category = NEI$year), FUN=sum)

png('plot1.png')
barplot(with(agg_PM,setNames(x, Category)), xlab="Years", ylab = "Emission (Tons)", main = 
          "Total Emissions of PM 2.5: 1999 - 2008")
dev.off()

#Q 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.

Maryland <- subset(NEI, fips == '24510')
agg_MD <- aggregate(Maryland$Emissions, by=list(Category = Maryland$year), FUN=sum)

png('plot2.png')
barplot(with(agg_MD, setNames(x, Category)), xlab="Years", ylab = "Emission (Tons)", main = 
          "Emissions in Baltimore City: 1999 - 2008")
dev.off()

#Q 3: Of the four types of sources indicated by the type variable, which have seen decreases in 
#emissions from 1999–2008 for Baltimore City? increases? #Use ggplot2 to answer.

agg_MD_type <- aggregate(Maryland$Emissions, by = list(Maryland$type, Maryland$year), FUN=sum)

png('plot3.png')
qplot(Group.2, x, data = agg_MD_type, facets = .~Group.1) + geom_line() + 
  ggtitle("Sources in Baltimore City: 1999 - 2008") + 
  labs(x = "Year", y = "Emission (Tons)")
dev.off()

#Q 4: Across the United States, how have emissions from coal combustion-related sources changed 
#from 1999–2008?

coal_sources <- grepl("coal", SCC$Short.Name, ignore.case=TRUE)
SCC_coal <- SCC[coal_sources, ]
NEISCC <- merge(NEI, SCC_coal, by="SCC")

coal_emissions_changed <- tapply(NEISCC$Emissions, NEISCC$year, sum)

png('plot4.png')
barplot(coal_emissions_changed, xlab = "Years", ylab = "Emission (Tons)", main = 
          "Change in Coal Emissions: 1999 - 2008")
dev.off()

#Q 5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

motor_sources <- grepl("vehicle", SCC$Short.Name, ignore.case=TRUE)
SCC_motor <- SCC[motor_sources, ]
NEISCC2 <- merge(Maryland, SCC_motor, by="SCC")

motor_emissions_changed <- tapply(NEISCC2$Emissions, NEISCC2$year, sum)

png('plot5.png')
barplot(motor_emissions_changed, xlab = "Years", ylab = "Emission (tons)", main = 
          "Change in Motor Vehicle Emissions in Baltimore City: 1999 - 2008")
dev.off()

#Q 6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
#vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater 
#changes over time in motor vehicle emissions?

NEISCC3 <- merge(NEI, SCC_motor, by = "SCC")
motor_MD <- subset(NEISCC3, fips == "24510")
motor_LA <- subset(NEISCC3, fips == "06037")

merged_motor_cities <- rbind(motor_MD, motor_LA)
merged_motor_cities[merged_motor_cities == '24510'] <- 'Baltimore'
merged_motor_cities[merged_motor_cities == '06037'] <- 'Los Angeles'

agg_motor_cities <- aggregate(Emissions ~ fips + year, data = merged_motor_cities, FUN = sum)
agg_motor_cities

png('plot6.png')
qplot(year, Emissions, data = agg_motor_cities, color = fips) + geom_line() + 
  ggtitle("Motor Emissions in Baltimore vs. LA: 1999 - 2008")
dev.off()
