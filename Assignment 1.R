
#Assignment: write a function that takes the state abbr and outcome, and returns 
#the name of the hospital with the lowest 30 day mortality rates in the state

library(data.table)
library(dplyr)

outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

#transform needed columns to numeric
columns <- c(11, 17, 23)
outcome[, columns] <- lapply(columns, function(x) as.numeric(outcome[[x]]))

#quick overview of data
hist(outcome[,11])
hist(outcome[,17])
hist(outcome[,23])

#rename columns so user can call on them directly
setnames(outcome, old = c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"), new =
           c("Heart.Attack.Rates", "Heart.Failure.Rates", "Pneumonia.Rates"))


best <- function(state, input) {

#check if state and outcome are valid
  if(!any(state == outcome$State)) {
    stop("invalid state")
  }
  
  if(!input %in% names(outcome)) {
    stop("invalid outcome")
  }

#filter by the given state, select only the Hospital Name and outcome to work with  
  outcome1 <- filter(outcome, outcome$State == state )
  outcome1 <- select(outcome1, "Hospital.Name", input)
  
#remove NA values  
  outcome1 <- outcome1[complete.cases(outcome1),]

#order first by Hospital Name, then by outcome
  outcome1 <- outcome1[order(outcome1[,1]), ]
  outcome1 <- outcome1[order(outcome1[,input]), ]

#return name of the first row
  outcome1[1,1]
  
}

best("AK", "Pneumonia.Rates")
