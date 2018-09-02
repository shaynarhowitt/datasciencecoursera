
#Assignment: write a function that takes an outcome name and ranking, and returns a dataframe
#with the hospital with that ranking in each state

library(data.table)
library(dplyr)

outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
columns <- c(11, 17, 23)
outcome[, columns] <- lapply(columns, function(x) as.numeric(outcome[[x]]))

setnames(outcome, old = c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"), new =
           c("Heart.Attack.Rates", "Heart.Failure.Rates", "Pneumonia.Rates"))

rankall <- function(input, num = "best") {
  
#check if outcome and number are valid  
  if (!input %in% names(outcome)) {
    stop("invalid outcome")
  }
  
  if (num > nrow(outcome)) {
    stop("invalid number")
  }

#transform "Not Available" values to NA
  outcome[outcome=="Not Available"] <- NA

#select only neededc columns,then drop NA values
  outcome <- select(outcome, "State", "Hospital.Name", input)
  outcome <- outcome[complete.cases(outcome),]

#split the dataframe by state, splitUp becomes list of dataframes
  splitUp <- split(outcome, outcome$State)

#use lapply to order each dataframe by Hospital Name, then by condition    
  orderedSplitUp <- lapply(splitUp, function(df) {
    df <- df[order(df[,"Hospital.Name"]), ]
    df <- df[order(df[,input]), ]
  })
  
#identify which row to pull out from each dataframe, and pull it out with lapply  
  rankedHospital <- lapply(orderedSplitUp, function(df) {
    if (num == "best") {
      df <- df[1, "Hospital.Name"]
    } else if (num == "worst") {
      n <- nrow(df)
      df <- df[n, "Hospital.Name"]
    } else {
      df <- df[num,"Hospital.Name"]
    }
    
  })
  
}


print(rankall("Heart.Failure.Rates", 10))

