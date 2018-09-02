library(xml2)
library(httr)
library(httpuv)
library(sqldf)

# register an application with the Github API. access the API to find the date github user
# jtleek created the repository 'datasharing'

oauth_endpoints("github")

myapp <- oauth_app("Shayna_Oauth",
                   key = "36e9591c182a9bca843b",
                   secret = "ec77bf43a06bc6a1428289e0fd5e3e020aeef5ae")


github_token <- oauth1.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

json1 = content(req)
json2 = jsonlite::fromJSON(toJSON(json1))

colnames(json2)

json2$created_at[json2$name=='datasharing']

#download american community survey

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile="../Johns Hopkins/community.csv",
              method = "curl")
list.files("../Johns Hopkins")

acs <- read.csv("../Johns Hopkins/community.csv")

#which of the following commands will select only the ddata for the probability 
#weights pwgtp1 with ages less than 50?

options(sqldf.driver = "SQLite")
sqldf("select pwgtp1 from acs where AGEP < 50")

#How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#http://biostat.jhsph.edu/~jleek/contact.html

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)

nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])

#Read this data set into R and report the sum of the numbers in the fourth of the nine columns.

noaa <- read.fwf(file= url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
                 skip=4,
                 widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))


sum(noaa$V4)
