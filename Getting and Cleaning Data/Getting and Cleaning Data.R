
#components of data: raw data, tidy data set, code book, explicit recipe of 1 - 2 - 3

#tidy data: 
#1. each variable is in one column
#2. each observation is in one row
#3. one table for each "kind" of variable
#4. if there are multiple tables, they should include a column that allows them to link

#code book:
#1. info about the variables not included in tiny data
#2. info about summary choices you made and the experimental study design used

#instruction list:
#1. ideally computer script; if you can't script, write explicitly 

getwd() #tells you what working directory you're in

setwd() #sets working diretory 

setwd("./data").setwd("../") #relative - one directory up
setwd("/Users/shayna/data/") #absolute

file.exists("directoryName") #checks if directory exists
dir.create("directoryName")

if(!file.exists("data")) {
  dir.create("data")
}

download.file() #downloads a file from the internet
#parameters: url, destfile, method

#in example, found the link to the download option of the CSV file

fileurl <- "https://data.baltimorecity.gov/api/views/abcdef"
download.file(fileURL, destfile="./data/cameras.csv", method = "curl")
list.files("./data")

#want to keep track of when your file was downloaded in case they change
dateDownloaded <-date()

#curl method is needed when using mac and pulling from "https"

#reading local flat files: csv, excel files, tab-delimited

read.table() #most common function for reading data into R
#flexible and robust but requires more parameters
#reads the data into RAM (memory) so big data can cause problems
#default is tab-delimited file

#important parameters: file, header, sep, row.names, nrows
#optional: quote (quoted values?), na.strings (what char represents missing value),
#skip (number of lines to skip before starting to read)

cameraData <- read.table("./data/cameras.csv", sep=",", header=TRUE)

read.csv() #automatically sets sep = "," and header=TRUE

#reading an excel file - 
if(!file.exists("data")) {dir.create("data")}
fileUrl <- "https://data.baltimorecity.gov/api/abcdefgh"
download.file(fileUrl, destfile="./data/cameras.xlsx", method = "curl")
dateDownloaded <- date()

xlsx() #package very useful to reading excel files

library(xlsx)
cameraData <- read.xlsx("./data/cameras.xlsx", sheetIndex=1, header=TRUE)
#can read specific rows and columns
colIndex <- 2:3
rowIndex <- 1:4
cameraData <- read.xlsx("./data/cameras.xlsx", sheetIndex=1, header=TRUE,
                        colIndex=colIndex, rowIndex=rowIndex)

write.xlsx() #will write out an Excel file

#in general, you should store your data in a database, csv, or .tab/.txt

#scraping XML

#HTML: developed to display data; focuses on how data looks 

#XML - extensible markup language, frequently used to store structured data
#extracting XML is the basis for most web scraping
#components: markup - labels that give the text structure ; content 

#XML: developed to describe data; focuses on what data represents
#can define your own structures and tags
#can store data separately from HTML, inside HTML docs or in files/databases
#XML stores data in plain text format, making it much easier to share and transport
#thousands of XML formats exist across industries
#all XML documents are formed as element trees; start at root & branch to child

#tags: correspond to general labels <section> </section>
#empty tags: <line-break />

#elements: specific examples of tags <Greeting> Hello, world </Greeting>

#attributes: components of the label <img src="jeff.jpg" alt = "instructor"/>

#can read data into R with the XML package

library(XML)
fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal = TRUE) #parses it so you can store it in R
rootNote <- xmlRoot(doc) #wrapper element for the entire document 
xmlName(rootNode)
names(rootNode) #what all of the nested elements within the rootnode are

#directly access parts of the XML document
rootNode[[1]] #first element

#can also subset
rootNode[[1]][[1]] #first element of first element 

xmlSApply(rootNode, xmlValue) #will loop through all of the elements of rootNode
#and return the value of every element 

#if you want to be more specific, you have to learn XPath
#/node - top levelnode
#//node - node at any level

xpathSApply(rootNode,"//name",xmlValue)
#will go through rootNode and get all of the nodes that correspond to an elemetn with
#the title name, and will return the content of all those elements

xpathSApply(rootNode,"//price",xmlValue)

#example:
#go to a website, view page source, identify elements that you want to extract 

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileURL, useInternal = True)
#useInternal - gives access to all the different nodes inside that file

scores <- xpathSApply(doc,"//li[@class='score']",xmlValue) #look for items 
#that are list items, and have the class 'score'

teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)

#JSON: Javascript Object Notation
#lightweight data storage, common format from APIs, which is how you can access
#data through URLs
#similar to XML but different syntax and format
#data stored as numbers, strings, booleans, arrays, objects
#text, written with JavaScript object notation

#if you have data stored in a JavaScript object, you can convert it to JSON and 
#send to a server, because data exchanged between a browser and a server can only
#be text

#both JSON and XML can be used to receive data from a web server

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek")
names(jsonData) #gives top-level variable names

names(jsonData$owner) #looks at names of particular 'owner' variable 

#can also take datasets that are dataframes in R and turn it into JSON dataset

myjson <- toJSON(iris, pretty=TRUE) #pretty gives nice indentation
cat(myjson) #cat command prints out text variable

iris2 <- fromJSON(myjson) #turns JSON object back 
head(iris2)

#data.table 

#data.table inherits from data.frame; written in C so can be much faster

library(data.table)
DT = data.table(x=rnorm(9), y = rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)

tables() #gives info about the table

#subset rows
DT[2,]
DT[DT$y=="a",] #only look at values where y = a

DT[c(2,3)] #gives just the second and third rows - diff from data.frame

#subset columns differently

#can calculate values for variables with expressions
DT[,list(mean(x), sum(z))] #will return just mean of x and sum of z values in tabl

DT[,table(y)] #table of just y values

DT[,w:=z^2] #easy to add new columns
#new memory isn't created, so it's more efficient
#but if you change the first table, copies made earlier won't be changed
#if you want to copy, you have to use the explicit copy function

DT[,m={tmp <- (x+z); log2(tmp+5)}]
#easy to do multi-step operations using temporary variables

DT[,a:=x>0]
#new column with binary values 

DT[,b:=mean(x+w), by=a]
#takes mean of x + w when a = true, and will place that mean in all the rows where a=TRUE
#then it will take the mean of x + w when a = false, and place that mean where b=FALSE

.N #count the number of times

DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x] #data table of counts of each letter

#can set keys with data tables that allow you to sort them very rapidly
#can also use keys to facilitate joins between tables

#mySQL: free and widely used open source database software
#data are structured in databases - tables - fields
#each row is called a record
#designed for managing data held in a relational database management system
#useful in handling structured data where there are relations between entities of data


install.packages("RMySQL")
library("RMySQL")

ucscDB <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")

result <- dbGetQuery(ucscDB, "show databases;"); dbDisconnect(ucscDB)
result #will show all the databases that are available within the specified host address 

hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
#passed specific database within given server

allTables <- dbListTables(hg19) #lists tables that exist within hg19 database
length(allTables) #shows over 11,000 tables in that one database
#each data type gets its own table
allTables[1:5] #example of first five tables

dbListFields(hg19, "affyU133Plus2") #what are the fields in a table in the database
#fields are like column names in R dfs 

dbGetQuery(hg19, "select count(*) from affyU133Plus2") #how many rows does this table have
#command in quotes is actually a SQL command, not an R command

affyData <- dbReadTable(hg19, "affyU133Plus2") #saves table itself
head(affyData)

#remember some of these tables are huge, so you'll have trouble reading them into R

#can read subset with dbSendQuery

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
#will select all observations from affy table where mismatches variable is >1 and <3 
affyMis <- fetch(query); quantile(affyMis$misMatches)
#fetch will return the query that we've selected

affyMisSmall <- fetch(query, n=10); dbClearResult(query);
#returns small subset of query; then have to clear the query from the remote server

dim(affyMisSmall) #shows that we have 10 rows and 22 columns

dbDisconnect(hg19)
#don't forget to close the connection once you're done!
#should do immediatley after extracting the data 

#HDF5 - used for storing large data sets, supports storing a range of data types
#hierarchical data format
#groups: contain 0+ data sets & metadata; have group header & group symbol table
#datsets: multidimensionsal array of data elements with metadata

source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created = h5createFile("example.h5")
created

#can then group 
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5") #lists out components of that one file

#can also write into groups
A = matrix(1:10, nr=5, nc=2) #create matrix
h5write(A, "example.h5", "foo/A") #write matrix to specific group
B = array(seq(0.1,2.0, by=0.1), dim=c(5,2,2)) #create multi-d array
attr(B, "scale") <- "liter" #gave B metadata (attribute)
h5write(B, "example.h5", "foo/foobaa/B") #write array to particular subgroup
h5ls("example.h5")

#can also write dataset directly
h5write(df, "example.h5", "df")
# (df is name of dataframe)

#or read data
readA = h5read("example.h5", "foo/foobaa/B")
readA

#or read/write in chunks
h5write(c(12,13,14), "example.h5", "foo/A", index=list(1:3,1))
#above command writes to first three rows and first column those values (12, 13, 14)
h5read("example.h5", "foo/A")


con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

#can tel R how many lines to read with readLines()
#could also use XML to parse

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)

#or can use GET from the httr package

install.packages("httr")
library(httr)
html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(html, "//title", xmlValue)

#to access websites with passwords, use the httr package

pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user", "passwd"))
pg2 #response - authenticated: true
names(pg2) #gives cookies for this file

#can save handles so the cookies will stay authenticated
google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")

#APIs - Application Programming Interface - allows you to transfer info from website
#first have to make an account with their dev team

# dev.twitter.com/apps - will be given auth codes here

#first load httr package

myapp = oauth_app("twitter", key="consumerKey", secret="consumerSecret")
sig = sign_oauth1.0(myapp, token="myToken", token_secret-"tokenSecret")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
#^this url corresponds to the twitter api - tells it you wants the statuses on your home
#timeline as a JSON file; and will pass it the authentication 
#can find URL under dev.twitter.com, and look at documentation for resource URL 

json1 = content(homeTL) #content function will recognize JSON data
json2 = jsonlite::fromJSON(toJSON(json1)) #use jsonlite package to reformate as dataframe
json2[1,1:4] #subsets for example

typeof(json2)
#httr allows GET, POST, PUT, DELETE requests if you are authorized
#can authenticate with a user name or password
#works well with Facebook, Google, etc.

file() #opens connection to a text file that's alredy localized on your computer
?connections

#foreign package loads data from Minitab, S, SAS, etc. 

#notes on OAuth -- 
#1. user shows intent
#2. consumer asks permission from service provider, receives token and a secret
  #secret is used to prevent request forgery
#3. user is redirected to the service provider
#4. authorize the request token, goes back to consumer
#5. consumer exchanges request token for access token and secret
#6. consumer accesses protecteed resource

#Subsetting and Sorting

#can subset using logical statements

X[(X$var1 <= 3 & X$var3 > 11), ]

X[which(X$var2 >8), ]
 #which will return the indices where var2 > 8, ignores NAs

sort(X$var1) #sort values numerically in increasing order
  #can add parameter decreasing=TRUE
  #can put na.last = TRUE as a parameter to put all NAs at the end

X[order(X$var1),] #orders entire dataframe according to order of variable 1

X[order(X$var1, X$var3), ] #can sort according to multiple variables

#use the plyr library
library(plyr)
arrange(X, var1) #sorts X by var 1
arrange(X, desc(var1)) #decreasing order

#Summarizing data

summary(dataframe) #gives information about every single variable
str(dataframe) #classes and info of each column 
quantile(dataframe$column, na.rm=TRUE) 

#can also make a table for a specific variable
table(dataframe$column, useNA="ifany")
#useNA will add column with NAs, and tell you how many there are

sum(is.na(dataframe$column)) #number of times the column has an NA value
any(is.na(dataframe$column)) #checks if any of the values are NA
all(dataframe$column > 0) #checks if all values satisfy a condition

colSums(is.na(restData)) #counts number of NAs across data set
all(colSums(is.na(restData))==0) #any missing values in data set?

table(dataframe$column %in% c("21212")) #are there any values that are 21212?
  #could also use == in the above example

table(dataframe$column %in% c("21212", "21213")) #check for multiple values
  #can then subset the dataset based on above logical variable
table[table$column %in% c("example")]

#cross tabs - break down frequency of admissions per gender / UCB admissions

data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

#can find size of dataset
object.size(dataframe)
print(object.size(dataframe), units="Mb") #transform object size into another unit

#creating new variables -
#sometimes you'll have to transform the data to get the values you actually want, and then
#add it back in - missingness indicators, "cutting up" quant variables, applying transforms

#creating sequences - when you need an index for the dataset 

s1 <- seq(1,10,by=2)
s2 <- seq(1,10,length=3)
x <- c(1,3,5)
seq(along = x) #creates index so you can loop through x w consecutive indices

#can subset list of restaurants according to those near you
restaurants$nearMe = restaurants$neighborhood %in% c("Roland Park", "Highland")
#add this column to a dataframe and you can sort by it
table(restaurants$nearMe)

#might create binary variable
restaurants$zipWrong = ifelse(restuarants$zipCode < 0, TRUE, FALSE)
#if/else command - if condition is true, then return true, otherwise return false

#create categorical variables out of quantitative
restaurants$zipGroups = cut(restaurants$zipCode, breaks=quantile(restaurants$zipCode))
#will break variable zip codes up into quantiles 

#easier way to cut with library Hmisc
library(Hmisc)
restaurants$zipGroups = cut2(restaurants$zipCode, g=4)
#will automatically find the quantiles if you don't want to set breaks in advance

#creating factor variables
restaurants$zcf <- factor(restaurants$zipCode)
#takes input of an integer variable and turns it into a factor variable

yesno <- sample(c("yes", "no"), size=10, replace=TRUE)
yesnofac = factor(yesno, levels = c("yes", "no"))
relevel(yesnofac,ref="yes")
#would automatically treat lowest alphabetical value as first, can relevel it so yes = true
as.numeric(yesnofac)
#lowest value = 1, next = 2, etc. 

#cutting produces factor variables

library(Hmisc)
library(plyr)

restData2 = mutate(restData, zipGroups = cut2(zipCode, g=4))
#new dataframe will be the old dataframe with the new variables added

#common transforms
#abs(x) sqrt(x) ceiling(x)  round(x,digits=n) exp(x) etc

#reshaping

library(reshape2)
head(mtcars)

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg", "hp"))
#reshapes data so that it's tall and skinny - mpg and hp (variables) both have a unique row
#for a given car, they're not combined

#can re-cast the dataframe into a bunch of different shapes
cylData <- dcast(carMelt, cyl ~ variable)
#break down cylinders by different variables
#cyl will be rows; variables will be columns

cylData <- dcast(carMelt, cyl ~ variable, mean) #passes mean for each

#averaging values
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)
#(apply to count, along index of spray) - tapply applies along indices
#returns sum of counts for each sprary

#another option
spIns = split(InsectSprays$count, InsectSprays$spray)
#splits up counts for each spray
sprCount = lapply(spIns, sum)
#for each element in spIns, sums 
unlist(sprCount) #returns as a vector, just use sapply in the future!

#or use plyr package

library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count))

#can also calculate values and apply them to each variable
#subtract total count from actual count for each variable
#spraySums will be the same length as actual dataframe
spraySums <- ddply(InsectSprays,.(spray), summarize, sum=ave(count, FUN=sum))
#summarize the spray value of counts, and sum them up
#sum=ave() function makes it the same dimension as OG dataset
#you'll see the sum for A in every row that A would appear

#can also use acast (Cast as multi-dimensional arrays), arrange, and mutate

#dplyr package is about working with dataframes
#one obs/row, each column represents a var, primarily using default R implementation 

#select: returns subset of columns
#filter: returns subset of rows
#arrange: reorder rows
#rename: rename variables
#mutate: add new variables/cols, or transform existing vars
#summarise: generate summary stats of diff variables in the dataframe 

#first argument is always a dataframe, subsequent describe what to do with it
#don't need to use $ operator; must properly format and annotate in advance to be useful
#result is always a new dataframe 

library(dplyr)

chicago <- readRDS("chicago.rds")

dim(chicago)
str(chicago)
names(chicago) #variable/column names
  #can refer to columns with names, don't have to use column indices 

head(select(chicago, -(city:dptp)))
  #returns all columns except for those between city and dptp

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
  #returns new dataframe that passes logical sequence

chicago <- arrange(chicago, date)
  #order entire dataframe by date value

chicago <- arrange(chicago, desc(date))
  #sorts in descending order

chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
  #rename old variable names to first one listed

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
  #adds another variable (pm25detrend) which is variations from the mean

chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
hotcold <- group_by(chicago, tempcat)

summarize(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
  #adds additional variable that groups data by year
years <- group_by(chicago, year) #and can then summarize this as well

#dplyr has a special operator that allows you chain different operations:  %>%

chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25,
            na.rm=TRUE), o3 = max(o3tmean2), no2=median(no2tmean2))
              #useful because you don't have to keep creating temporary variables

#with dplyr, you can work with other dataframe 'backends', use data.table for large fast tables
#and have a SQL interface for relational databases

#merging data

#default merges by all columns that have a column name unless specified
#parameters: x, y, by.x, by.y, all

mergedData = merge(reviews, solutions, by.x="solution_id", by.y="id", all=TRUE)
#merges review and solutions dataframes; for x df - on soltuion_id, on id for y df
#all=TRUE means that values that appear in one but not the other should still be passed
#on, but NAs will be added where data is empty

intersect(names(solutions), names(reviews)) #common names between both dataframes

#can also use join in the plyr package
arrange(join(df1, df2), id) #first joins two datsets by id, then sorts according to id 

#easy to use join for multiple dataframes by putting them in a list
dfList = list(df1, df2, df)
join_all(dfList)

#editing text varaibles

#make all column names lowercase
tolower(names(dataframe))

#can split variable names based on character in name
splitNames = strsplit(names(datframe),"\\.")
#will split all names that have a period - havet o use \\ because . is a reserved character

#might want to keep just the first part of that split name - number is unecessary 
#can apply this to all the variable names

firstElement <- function(x) {
  x[1]
}

sapply(splitNames, firstElement)
#will apply first element function to each element in the splitNames list

#can substitute characters, like an underscore, from variable names
sub("_","", names(reviews))
#replaces underscores with nothing

#gsub will replace all instances of the character, not just the first one
testName <- "this_is_a_test"
gsub("_","",testName)

#searching for values in variable names
grep("Alameda", cameraData$Intersection)
#will return all instances in Intersection vector where Alameda appears (indices)
grep("Alameda", cameraData$Intersection)
#returns value where this is true
length(grep("Alameda", cameraData$Intersection))
#length of instances where this is true

table(grepl("Alameda", cameraData$Intersection))
#returns vector that's true when Alameda appears, and false when it doesn't

#can then subset based on the above vector
cameraData2 <- cameraData[!grepl("Alameda", cameraData$Intersection),]

library(stringr)

nchar("Jeffrey Leek") #number of characters in a string
substr("Jeffrey Leek", 1, 7) #returns 1st through 7th letter
paste("Jeffrey", "Leek") #returns one string separated by a space
paste0("Jeff", "Leek") #pastes with no space
str_trim("Jeff    ") #trims off excess space at end of strings

#notes: keep var names lower case when possible, descriptive, not duplicated, not have underscores/dots/white spaces

#regular expressions 

#simplest pattern of regular expressions consist only of literals
  #match occurs if the sequence of literals occurs anywhere in the text being tested

#metacharacters specify more general search terms

# ^I think - match the start of a line, followed by I think
# $morning - match when line ends with morning

#can also list a set of chars accepted at any given point in the match
# [Bb][Uu][Ss][Hh] - #will match all Bush names, regardless of capitals

#can specify a range of letters or characters
# [0-9][a-zA-Z] - will match, regardless of capitals

# [^?.]$ - will match anything that does NOT end in a ? or a .

# a period is used refer to any character
# 9.11 - will match 9-11, 9/11, 911, 9:11, 9211, etc.

#can use | as an or to give several options for matches
# flood|earthquake|fire

# ^[Gg]ood [Bb]ad - match when (G)good is at the beginning, bad is anywhere

# ^([Gg]ood | [Bb]ush) #good or bush, but both have to be at beginning 

#question mark indicates that the indicated expression is optional 
# [Gg]eorge( [Ww]\.)? [Bb]ush - W in middle is optional 

#have to escape metacharacters like . with a \

# (.*) repeat anything that's between parentheses, any number of times
#will go for longest string, unless turned with a ? - (.*?)

# + will include at least one of the items
# [0-9] + (.*)[0-9]+ #at least one number, any number of chars, then at least another number

# { } interval quantifiers, specify min and max # of matches of an expression 
# [Bb]ush( +[^ ]+ +){1,5} debate - Bush, followed by at least one space, something that's not a space.
# then at least one space between one and five times
    #example: Bush has won all major debates he's done
  
#m, n - at least m, but not more than n matches
#m - exactly m matches; m, - at least m matches

# () can 'remember' text visited
# use \1 to call text identified 

#dates! 

d1 = date() #date as a character
d2 = Sys.Date() #date as a date class object

#formatting dates
format(d2, "%a %b %d") #"Sun Jan 12"
  #can use all sorts of diff chars - %a is abbr weekday, %m is month, etc. 

#create dates
x = c("1jan1960", "2jan1960")
z = as.Date(x, "%d%b%Y")
  #can turn them into dates by specifying how they're written
z[1] - z[2] #and then you can find time difference
as.numeric(z[1] - z[2]) #and make them numeric

weekdays(d2); months(d2)
julian(d2) #number of days since the origin date (1/1/1970)

#lubridate function makes it even easier to work with dates

install.packages("lubridate")
library(lubridate)
ymd("20140108") #will turn into date
dmy("03-04-2013") #etc. will all work - don't have to format before transforming

ymd_hms("2011-08-03 10:15:03", tz="Pacific/Auckland") #can also work with times

?POSIXlt
