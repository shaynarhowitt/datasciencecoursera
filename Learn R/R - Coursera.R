#to read files, they must be saved in the same working directory 
#as the one you're currently working in

#lean because functionality is divided into modular packages
#graphics capabilities are very sophisticated

#drawbacks: based on old tech, little built in support for dynamic or 3d graphics
#functionality based on consumer demand user conributions
#objects must generally be stored in physical memory

#divided into "base R" system and all other packages

# <- assignment operator

x <- 5
x

#x is regarded as numeric vector, prints [1] 5 to show first element of vector
 
#just calling variable name will auto-print, or you can explicitly print with print(var)

#everything in R is an object - has five basic classes: 
#character, numeric, integer, complex, logical (T/F)

#most basic object is a vector, which can only contain objects of the same class
#except to above rule is a list

#vector() function creates empty vectors - specify class and length

#numbers in R are generally treated as numeric objects
#have to specify the L suffix if you explictly want an integer (1L)
#Inf represents infinity

#R objects can have attributes: names, dimensions, class, length, metadata

#creating vectors:

x <- c(0.5, 0.6)
x <- c(T, F)
x <- c("a","b","c")
x <- 9:29

x <- vector("numeric", length = 10) #default value is 0

#when different objects are mixed, R will coerce it to be the same

#can explicitly coerce from one class to another using the as.* functions

x <- 0:6
class(x) #integer
as.numeric(x) # 0 1 2 3 4 5 6
as.logical(x) # FALSE TRUE TRUE TRUE ...
as.character(x) # "0" "1" "2" ...

#nonsensical coercion will result in NA, sometimes its just impossible

#lists are special type of vector that can contain elements of diff classes

x <- list(1, "a", TRUE, 1 + 4i)
x #prints out in individual vectors for each value

#matrices: vectors with a dimension attribute
#constrcuted column-wise

m <- matrix(nrow = 2, ncol = 3)
m #initialized with NA values
dim(m) #returns 2 3 

#matrices can also be created directly from vectors by adding a dimension attr

m <- 1:10
dim(m <- c(2,5)) #splits up m into 2 rows, 5 columns

#or by binding columns or rows

x <- 1:3
y <- 10:12
cbind(x, y)
rbind(x, y)

#factors: used to represent categorical data; can be ordered or unordered
#can think of them as an integer vector where each integer has a label (?)
#treated specially by modelling functions like lm() and glm()

x <- factor(c("yes", "yes", "yes", "no"))
x #will print out the vector, and then the levels
table(x) #gives frequency count of how many values there are
unclass(x) #brings it down to an integer level 

#order of the levels can be set using the levels argument to factor()
#order of levels will automatically be set to alphabetical order

x <- factor(c("yes", "yes", "yes", "no"),
            levels = c("yes", "no"))
x

#missing values: NAN - specifically undefined math operations, NA

is.na(x) #tests if object is NA
is.nan(x) #tests if object is NAN
#NA values can also have classes
#NAN is NA, NA is not always NAN

x <- c(1, 2, NA)
is.na(x) #returns FALSE FALSE TRUE

#dataframes are used to store tabular data, represented as a special type of list where every
#element of the list has the same length (each element is a column)

#unlike matrices, dfs can store diff classes of objects in each column

#have a special attr of row.names

#usually created by calling read.table() or read.csv(), can convert to matrix w data.matrix()

x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
x #two columns - first is foo, second is bar

#R objects can also have names

x <- 1:3
names(x) #NULL
names(x) <- c("foo", "bar", "norf") #assigns these to be the names of your elements

x <- list(a = 1, b = 2, c = 3)
x #will print out name of each element, along with element

m <- matrix(1:4, nrow = 2, ncol = 2)
dimnames(m) <- list(c("a", "b"), c("c", "d"))
#assigns a and b as row nams, and c and d as col names

#reading data into R

read.table & read.csv #reading tabular data, and text files in rows and columns
readLines #reading lines of a textfile
source & dget #reading in R code files
load #reading in saved worksaces
unserialize #reading single R objects in binary form

#writing data into R  - analogous functions
write.table
writeLines
dump
dput
save
serialize

read.table #most commonly used function
#arguments: 
#file name
#header indicates if file has a header line
#sep indicates how columns are separated
#colClasses indicates class of each column in the datasheet
#nrows
#comment.char indicates the comment character
#skip number of lines to skip from the beginning (header, unecessary info, etc.)
#stringAsFActors - should character vars be coded as factors? defaults to T

#above arguements are not mandatory;but more efficient to give args
data <- read.table("ex.txt")

#with larger datasets - read help page for read.table! make sure you have memory!
#set comment.char = "" if there are no commented lines in your file

#use the colClasses arg so R doesn't have to figure it out on its own!
colClasses = "numeric" #implies every column is numeric

#or pull out sample and store values of column classes to use
initial <- read.table("example.txt", nrows = 100)
classes <- sapply(initial, class)
tabAll <- read.table("example.txt", colClasses = classes)

#set nrows - helps with memory usage

#know: your memory, applications, users, operating system, OS bit

#calculating memory requirements
#df with 1.5 million rows and 120 cols, all of which are numeric
#1.5 million x 120 x 8 bytes/numeric  gives bytes
#divide bytes / 2^20 bytes/MB gives MB needed

#rule of thumb is you'll need almost twice as much memory as the table itself requires

#textual formats: dumping, dputing - edit-able but potentially recoverable post corruption
#preserve the metadata, work better with version control programs
#can be longer-lived, but is not very space-efficient

#can pass data around by deparsing the R object with dput & reading back w dget

y <- data.frame(a = 1, b = "a")
dput(y) #returns structure with several attributes and descriptions
dput(y, file = "y.R") #saves to new file
new.y <- dget("y.R") #retrives and saves in new.y object
new.y

#multiple objects can be deparsed using the dump function
x <- "foo"
y <- data.frame(a = 1, b = "a")r
dump(c("x", "y"), file = "data.R")
rm(x, y) #removes x and y
source("data.R") #reads back in y, saves the original vectors as well

#use functions to interface between R and the outside world
#most common connection is to a file

file #opens connection to standard, uncompressed file
gzfile & bzfile #opens connection to file compressed with gzip, bzip2
url #opens a connection to a webpage

file #parameters: name of file; "r" read only, "w" write & initialize new, "a" append
#"rb", "wb", "ab": reading, writing, or appending in binary mode

con <- file("ex.txt", "r") #opens file
data <- read.csv(con) #then read it
close(con)

#note: same as calling data <- read.csv("ex.txt)" in this case, so not necessary
#but connection can be useful if you just want to read parts of a file

con <- gzfile("words.gz")
x <- readLines(con, 10) #reads first 10 lines of con file

#writeLines takes a character vector and writes each element one line at a time to a text file

#can also use readLines to read webpages

con <- url("www.facebook.com", "r")
head(con) #will print out html

#subsetting: 

# [ ] returns object of the same class as the original; can select more than one element
# [ [] ] extracts elements of a list or a dataframe; can only be used to extract a single element
  #and class of returned object might be different
# $ extracts elements of a list or df by name

x <- c("a", "b", "c", "d", "e")

#can subset using a numeric index
x[1] # "a"
x[1:4] # "a" "b" "c" "d"

x[x > "a"] #returns everything after "a" in the alphabet
u <- x > "a" #returns u logical vector that says whether elements in x > "a"
x[u] #now x only has elements > "a"

#subsetting lists
x <- list(foo = 1:4, bar = 0.6, baz = "hello")
x
x[1] #returns list of 1 2 3 4 

x[[1]] #returns just the sequence, not the list

x$bar #returs 0.6
x["bar"] #returns list and is the same as x$bar

x[c(1, 3)]  
#returns list with element foo and element baz 

#can use [[ ]] with computed indeces, $ can only be used w literal names
name <- "foo"
x[[name]] #computed index for foo, returns foo
x$name #returns NULL, element 'name' doesn't exist

x[[c(1, 3)]] #returns third element of first element of OG list
x[[1]][[3]] #same as above

#subsetting matrices - 
x <- matrix(1: 6, 2, 3)
x
x[1, 2] #return first row, second column
x[1, ] #don't have to specify both indices, this returns just first row

#when a single element of a matrix is retrieved, it is returned as a vector of length 1
#can be turned off by setting drop = FALSE
x[1, 2] #returns number 3
x[1, 2, drop = False] #returns 1x1 matrix

#subsetting a single row or column will return a vector unless drop = FALSE is specified

#partial matching of names is allowed with [[]] and $
x <- list(aardvark = 1:5)
x$a #returns aardvark
x[["a"]] #NULL because [[]] doesn't do partial matching by default
x[["a", exact = FALSE]] #returns aardvark

#removing NA values from an object
x <- c(1, 2, NA, 4, NA)
y <- c("a", "b", NA, "c", NA)

bad <- is.na(x) #create logical vector that tells you where NAs are
x[!bad] #remove NAs with subsetting

good <- complete.cases(x, y) #complete cases function will tell you which positions in both
#items have non NA values
x[good] #returns vector with only values that are filled out for both x and y
y[good]

#can also use complte cases to remove missing values from dataframe
good <- complete.cases(dataframe)
dataframe[good, ][1:6, ] #logical vector called good says which rows are complete in 1:6

#many operations in R are vectorized, making code more efficient and concise
x <- 1:4
y <- 6:9
x + y #7 9 11 13 ; don't have to loop!
x >= 2 #compares all numbers to 2, returns logical vector

#if you have an x matrix and a y matrix, x * y returns matrix with each individual element 
#multiplied by the corresponding element in the other matrix

#for true matrix multiplication, have to use x %*% y

#control structures: allow you to control the flow of execution of the program

#1: if / else

#this syntax works
if(x > 3) {
  y <- 10
} else if(x > 1) {
  y <- 1
} else {
  y <- 0
}

#this syntax also works - assignment of y to entire if / else construct
y <- if(x > 3) {
  10
} else {
  0
}

#remember you can just use if, else isn't mandatory 

#for loop: take interator variable, assign it successive values from sequence or vector

for(i in 1:10) {
  print(i)
}

#R is flexible in how you can index R objects

x <- c("a", "b", "c", "d")

for(i in 1:4) {
  print(x[i])
}

for(i in seq_along(x)) { #generate sequence based on length of variable x
  print(x[i])
}

for(letter in x) { #index variable doesn't have to be integer
  print(letter)
}

for(i in 1:4) print(x[i]) #if for loop just has single expression, it can live on 1 line

#for loops can be nested

x <- matrix(1:6, 2, 3)

for(i in seq_len(nrow(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i, j])
  }
}

#note: try not to nest beyond 2 - 3 levels, or it gets too confusing

#while loops begin by testing a condition - if true, loop is executed 

count <- 0
while(count < 10) {
  print(count)
  count <- count + 1
}

#careful not to result in infinite loops

#count toss example with while loop

z <- 5
while(z >= 3 && z <=10) {
  print(z)
  coin <- rbinom(1, 1, 0.5)
  
  if(coin == 1) {
    z <- z + 1
  } else {
    z <- z - 1
  }
}

#repeat: initiates an infinite loop; only way to exit is to call break

x0 <- 1
to0 <- 1e-8

repeat {
  x1 <- computeEstimate()
  
  if(abs(x1 - x0) < to1) {
    break
  } else{
    x0 <- x1
  }
}

#common in optimization situations - keep iterating until your estimates are close together
#bit dangerous because there's no guarantee it will stop - better to use a for loop

#next: used to skip an iteration of a loop

for(i in 1:100) {
  if(i <= 20) {
    next
  }
  print("Greater than 20, less than 100")
}

#return: signals a function should exit and return a given value

#function examples:

#finding values in vector above specified value
b <- c(3, 15, 14, 1)

above <- function(x, n = 10) { #default value is n = 10 if it's not specified
  use <- x > n #use is a logical vector of T/F indicating which elements of x are > 10
  x[use] #returns subset of x that are > n
}

above(b, 2)

#meaning mean of each column in a matrix or df
columnmean <- function(y, removeNA = TRUE) {
  nc <- ncol(y)
  means <- numeric(nc) #empty numeric vector equal to length of number of columns
  #originally initialized to be all zeros
  
  for(i in 1:nc) {
    means[i] <- mean(y[,i], na.rm - removeNA)
  }
  means #will get returned to console
}

#functions are created using the function() directive, stored as R objects of class "function"
#can be passed as args to other functions & be nested

#have named arguments which can have default values. don't have to use all of them
#formal arguments are included in the function definition 
#formals() function returns list of formal arguments of a function
#arguments can be matched positionally or by name (but try not to mess w order)

#can mix positional matching with matching by name; when an argument is matched, 
#it is 'taken out' of arg list and remaining unnamed are matched in order of function def

#named args are useful when you want to use most of the defaults but a few

#function args can also be partially matched - R will always check for: 
#1) exact match 2) partial match 3) positional match

#can set default value to NULL

#arguments to functions are evaluated lazily, only as needed

f <- function(a,b) {
  a^2 
}
f(2) #4; function never uses b so no error


f <- function(a,b) {
  print(a)
  print(b)
}

f(45) #prints 45, then the error because it didn't evaluate it until it needed to


# ... indicates a variable number of args that are usually passed on to other functions
#for example, here you're extending the plot function and changing just the type
myplot <- function(x, y, type = "1", ...) {
  plot(x, y, type = type, ...)
}

#generic functions also use ... so that extra arguments can be passed to methods

#... is also necessary when the # of args passed to function cannot be known in advance

args(paste)
function(..., sep=" ",  collapse = NULL) #pasting together unknown # of args

#note that any arguments after ... on the arg list must be named explicitly! 
  
#symbol binding:
  
lm <- function(x) { x * x }

#how does R know what value to assign to the symbol lm if there are several defined?
#R will search through a series of environments to find the apropriate value
#1) search global 2) search namespaces of each of the packages on search list

search() #shows order of packages - which matters!
#global environment = user's workspace, first element on search list
#base package - last

#cannot assume there will be a set list of packages, or they're in a given order
#when a package is loaded w library, namespace of that package is put into #2 of search list
#note there are separate namespaces for functions and non-functions

#scoping

#scoping rules determine how a value is associated with a free variable in a function 
#R uses lexical scoping (or static scoping)
#useful for simplifying statistical computations

f <- function(x, y) {
  x^2 + y / z
}


#this function has 2 formal args: x and y
#side note: local variables are defined inside the function body
#z is a free variable - values of a free variable are searched for in the environment in which
#the function was defined (environment is a collection of symbol/ value pairs)
#every environment has a parent environment (except for the empty environment)
#function + environment = closure or function closure

#when R encounters a free variable, it searches in the environment, then in its parent environments
#until the top-level (global) environment, and then continues down the search list until empty
#if value is never found, error is thrown

#this matters because you can have functions defined inside other functions

make.power <- function(n) {
  pow <- function(x) {
    x^n
  }
  pow
}

cube <- make.power(3) #defining new functions by defining n
square <- make.power(2)
cube(3)
square(3)

#what's in a function's environment?
ls(environment(cube)) #returns "n" "pow"
get("n", environment(cube)) #returns 3

#lexical vs dynamic scoping

y <- 10

f <- function(x) {
  y <- 2
  y^2 + g(x)
}

g <- function(x) {
  x*y
}

#in lexical scoping, value of y is looked up in environment in which function was defined, so y=10
#with dynamic scoping, value of y is looked up in environemnt from which function is called (so y = 2)
#in R, calling environment is known as the parent frame

#consequences of lexical scoping in R:
#1) all objects must be stored in memory 2) all functions must carry a pointer to their defining environments

#coding standards for R: 
#1) use text editor, save as a text file - can be read by any editing program
#2) indent your code
#3) limit the width of your code
#4) limit length of individual functions

#dates & times in R: 

#dates are represented by the Date class, and times are represented by POSIXct or POSIXlt class
#dates are stored internally as # of days since 1970-01-01
#and times as # of seconds since 1970-01-01

x <- as.Date("1970-01-05") #coerce object date from character string
x #will print as character str, even though it's not

unclass(x) #prints 0 - stored as dates from 1/1/1970

#POSIX is family of computing standards
#POSIXct - times are represented as very large integers - useful for storing times in a df
#POSIXlt - stores a time as a list, and other useful info like day of week/year/month

weekdays() #give day of week
months() #give month name
quarters() #give quarter number ("Q1" etc)
#all work on both date and time

#time can be coerced from char string to POSIX object
x <- Sys.time() #automatically formed as POSIXct - large integer

p <- as.POSIXlt(x)
p$sec #gives second of x

strptime() #to change your dates to different format

datestring <- c("January 10, 2012 10:40", "December 9, 2011 9:10")
x <- strptime(datestring, "%B %d, %Y %H:%M") #x is now a time object printed in specified format
#x will be formed in POSIXlt format

#can use math operations on dates and times
x <- as.Date("2012-01-01")
x
y <- strptime("9 Jan 2011 11:34:21", "%d %b %Y %H:%M:%S")
x <- as.POSIXlt(x) #just make sure to convert them to the same format before!
x - y #can also use ==, <=

#date and time even keep track of leap years, daylight savings, and time zones
y <- as.POSIXct("2012-10-25 07:00:00", tz="GM") #can specify time zone


#loop function - more compact than for loop; make heavy use of anonymous functions

#lapply - loop over a list/df/vector and evaluate a function on each element
#takes three arguments: 1) list 2) function 3) other args via ... argument
#will always return a list, regardless of the class of the input
#will always return list that has same # of elements as object passed to it

x <- list(a = 1:4, b = rnorm(10))
lapply(x, mean)

x <- 1:4
lapply(x, runif) #runif is random variable generator that takes # of vars as arg
#returns four vectors - first has one, second has two, etc. # of random variables

lapply(x, runif, min=0, max=10) #can include additional runif args on lapply

#example of anonymous function; this takes first column of each matrix in list
lapply(x, function(elt) elt[,1]) #x is list of matrices

#sapply - same as lapply but try to simplify the resulting object

#if result is list where every element is length 1, a vector is returned
#if list has vector of same length, matrix is returned
#otherwise, a list will be returned

#apply - apply a function over the margins of an array
#most often using to apply a function to the rows or columns of a matrix
#not generally faster than writing a loop, but works in 1 line

#takes an array, margin (integer vector indicating which margins should be retained),
#and a function

x  <- matrix(rnorm(200), 20, 10) #dimension 1: 20 rows, dimension 2: 10 cols
apply(x, 2, mean) #taking mean of cols in dimension 2, eliminating dimension 1
apply(x, 1, sum) #taking sum of just the rows, collapses the columns

#for simple operations, there are some shortcuts that are much faster:
rowSums = apply(x, 1, sum)
#also have rowMeans, colSums, colMeans

x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs = c(0.25, 0.75))
#creating the 25th and 75th percentile of each row (1st dimenson
#apply will create a matrix where each column has 25th and 75th for corresponding row)
#probs (arg for quantile function) is passed in as a ... argument

a <- array(rnorm(2 * 2 * 10), c(2,2,10)) #a bunch of 2x2 matrices stacked together
#3rd dimension: 10
#want to take average of all the 2x2 matrices
apply(a, c(1,2), mean) #average over the third dimension, just keeps 1st and 2nd

#can also use rowMeans(a, dims=2)

#mapply - multivariate version of lapply which applies function in parallel over set of args
#takes function, ..., moreargs, simplify, use.names
#similar to double for loop, where you take indices of both lists

#creates list of replicated items
list(rep(1, 4), rep(2, 3), rep(3, 2))
#instead:
mapply(rep, 1:4, 4:1)

noise <- function(n, mean, sd) {
  rnorm(n, mean, sd)
}


#vectorize:
mapply(noise(1:5, 1:5, 2))
#1 random variable with mean 1, 2 with mean 2, 3 with mean 3, etc. 

#tapply - apply function over subsets of vector
#takes vector, factor or list of factors, function, ..., simplify
#computes summaries of variables!
#break up dataset into groups, apply a function within each group

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3, 10) #gl is pre-made function, gives 10 ones, 10 twos, 10 threes
tapply(x, f, mean)

tapply(x, f, mean, simplify = FALSE) #returns list, simplify is true otherwise

tapply(x, f, range) #returns vectors of length two 

#split takes a vector or other objects, and splits it into groups determined by factor(s)
#takes vector, factor, and drop - indicates whether empty factor levels should be dropped
#always returns list back; common to use lapply in conjunction with split

lapply(split(x, f), mean)

#example with specdata, splitting it up based on month

s <- split(airquality, airquality$Month) #convert month variable to be factor variable
#anonymous function takes column means for each monthly dataframe

lapply(s, function(x) colMeans[x, c("Ozone", "Solar.R", "Wind")]) 

sapply(s, function(x) colMeans[x, c("Ozone", "Solar.R", "Wind")])
#will simplify the split list function to be a more readable matrix
x <- rnorm(10)
f1 <- gl(2, 5) #two factors, five times
f2 <- gl(5, 2) #one - five factors, two times

#another example of apply functions, using the PlantGrowth dataframe

head(PlantGrowth)

plant_weights_by_group <- with(PlantGrowth, split(weight, group))
plant_weights_by_group

mean_plant_weights_by_group <- lapply(plant_weights_by_group, mean)
mean_plant_weights_by_group

#tapply does all these steps together
with(PlantGrowth, tapply(weight, group, mean))

#returns just one vector
unlisted <- unlist(mean_plant_weights_by_group)

#sapply does the last two steps together

interaction(f1, f2)
#total of 10 leels

#interactions can also create empty levels
str(split(x, list(f1, f2)))
#returns list iwth 10 different factor levels, and elements from both in each

#debugging tools - 

#something is wrong! generic notification/message (won't stop function), warning : something
#is wrong, but not necessarily fatal, error: fatal problem has occured, condition:
#generic concept for indicating that something unexpected can occur (can create your own)

log(-1) #NaN ; Warning message

#invisible is a function that prevents auto printing

printmessage <- function(x) {
  if(is.na(x)) 
    print('x is a missing value')
  else if (x > 0)
    print('x is greater than zero')
  else                                                                                                                                                                                                                        
    print('less than zero')
  invisible(x)
}

#loads is another function that works invisibly - object returned is not printed
#note: all print functions will return the assignment when it prints

#questions to ask yourself when functions are funky: 
#what was your input, what were you expecting, how is it different, can you reproduce it?
#make sure to set the seed if your'e using random numbers

#tools for debugging functions:
#1) traceback: prints out funtion call stack after an error occurs
#have to call traceback right away, after the error occurs

#2) debug: flags a funtion for 'debug' mode that allows you to step through execution
#debug function prints out the whole function you're given, then gives a browser so you 
#can see exactly what went wrong

#3) browser: suspends execution of a function wherever it is called & puts the function in debug mode

#4) trace: allows you to insert debugging code into a function in specific places

#5) recover: allows you to modify the error behavior so you can brows function call stack
#options(error = recover) allows you to see what was going on when you got the error

#there are also more blunt techniques like print and cat
#don't get into bad habit of relying on debugging

#with() function applies an expression to a dataset
with(data, expression)
#for example, to apply a t-test:with(mydata, t.test(y ~ group))

#by() function applies a function to each level of a factor or factors
by(mydata, mydata$byvar, function(x) mean(x))

str() #compactly displays the internal structure of an R object
#good alternative to summary

str(lm)
#returns function args for lm function
x <- rnorm(100, 2, 4)
summary(x) #gives min, max, quartiles
str(x) #will tell you what x is, how many elements are in it, and a sample of 5
f <- gl(40, 10) #create factor object with 40 levels (#look into gl more)
str(f)

str(airquality) #preloaded air quality df
#gives information into each factor - what type is it, sample of each

s <- split(airquality, airquality$Month)
str(s) #will return five dataframes, where each df corresponds to data from one month

#functions are available for simulating numbers from given prob. distributions

rnorm() #generate random normal variates with given mean & sd
dnorm() #evaluate the norm probability density
pnorm() #evaluate cum. dist function for normal distribution
rpois() #generate random poisson variates w a given rate

#probability distribution functions have four functions associated with each function
#prefixed by d: density, p: cumulative, q: quantile, r: random

#all functions require the mean and standard deviation, default is 0 and 1

#anytime you simulate random numbers, make sure you set the seed!

set.seed(1)
rnorm(5)
rnorm(5)

#random numbers called by computer aren't actually random - you can call the same ones again
#by setting the same seed - will allow testing and reproduction

#how do we generate random numbers from a linear model?

set.seed(20)
x <- rnorm(100)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)

#what if x is a binary random variable?

set.seed(10)
x <- rbinom(100, 1, 0.5)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x, y)

#what if you want to count distinct, not continuous, variables from Poisson
#have to use rpois because error won't be normal, but Poisson dist.

set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3 * x
y <- rpois(100, exp(log.mu))
summary(y)
plot(x, y)

#in Poisson plot: 
#y is only at 0, 1, 2, 3, etc. 
#x is continuous 

#sample function draws randomly from specified set of objects
#allows you to sample from arbitrary distributions

set.seed(1)
sample(1:10, 4) #4 random numbers from 1 - 10
sample(letters, 5)
sample(1:10) #just a permutation
sample(1:10, replace = TRUE) #replace means numbers can be repeated in sample

#OPTIMIZE

#profiling is a systematic way to examine how much time is spent in dif parts of program

system.time()
#takes arbitrary R express as input and returns amount of time taken to evaluate expression
#good if you already know where the problem is and can call system.time() on it

#returns an object of class proc_time 
##user time: time charged to the CPU - the computer time
##elapsed time: "wall clock" time for the user
#two are usually pretty close, but depends on CPU wait time & amount of cores/processors 

#elapsed time > user time if you're reading something off the web - takes time to go over the network
#elapsed time < user time:
hilbert <- function(n) {
  i <- 1:n
  1 / outer(i - 1, i, "+")
}
x <- hilbert(1000)
system.time(svd(x)) #user is much longer because computer will use multiple processes at once

Rprof() #starts the profiler in R
summaryRprof() #summarizes the output from Rprof to make readable
#do not use together with system.time!

#keeps track of the function call stack at regularly sampled intervals and tabulates how much time
#is spent in each function (default in is .02 seconds)

#two methods for normalizing the data out of the profiler
by.total #divdes time spent in each function by total run time
by.self #first subtracts out time spent in functions above call stack (lower level functions)

#function will spend a lot time in top level, but that top just calls lower level ones, and 
#finding that more specific breakdown (w by.self) is what we're more interested in

sample.interval #gives interval
sample.time #total elapsed time

set.seed(10)
x <- rep(0:1, each = 5)
e <- rnorm(10, 0, 20)
y <- 0.5 + 2 * x + e
y
plot(x, y)

set.seed(1)
rpois(5,2)


#notes from programming assignment 3

order() #sort by default in decreasing order the values; returns vector of indexes w ordered rows
data[order(), ] #subsets the dataframe using above indexes

sort_by_column <- function(data, column) {
  orderdata <- data[order(data[,column]),]
  
  orderdata <- orderdata[complete.cases(orderdata),]
  #only considers complete rows
  
  return(orderdata)
}

#in case of a tie, can give a second attribute to order() to give second criteria

orderdata <- data[order(data[,col1], data[,col2]),]


