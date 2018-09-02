
#Assignment: write a function that takes the state, outcome, and ranking of hospital
#in state for that outcome, and returns the name of the hospital  w that ranking

library(data.table)
library(dplyr)

outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
columns <- c(11, 17, 23)
outcome[, columns] <- lapply(columns, function(x) as.numeric(outcome[[x]]))


#rename columns so user can call on them directly
setnames(outcome, old = c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                          "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"), new =
           c("Heart.Attack.Rates", "Heart.Failure.Rates", "Pneumonia.Rates"))

rankhospital <- function(state, input, num = "best") {

#check if state and outcome are valid
  if(!any(state == outcome$State)) {
    stop("invalid state")
  }
  
  if(!input %in% names(outcome)) {
    stop("invalid outcome")
  }

#filter by given state, select only Hospital Name and outcome    
  outcome1 <- filter(outcome, outcome$State == state )
  outcome1 <- select(outcome1, "Hospital.Name", input)
  
#remove NA values
  outcome1 <- outcome1[complete.cases(outcome1),]

#order first by Hospital Name, then by outcome
  outcome1 <- outcome1[order(outcome1[,1]), ]
  outcome1 <- outcome1[order(outcome1[,input]), ]

#identify row to print out based on num value
  if (num == "best") {
    print(outcome1[1,]) 
  } else if (num == "worst") {
    print(tail(outcome1, 1))
  } else if (is.numeric(num) & num < nrow(outcome1)) {
    outcome1[num,]
  }
  else {
    stop("invalid number")
  }
  
}

rankhospital("NY", "Heart.Attack.Rates", 7)
