
#principles of analytic graphics

#1. show comparisons - evidence for a hypothesis will always be relative
#2. show causality, mechanism, explanation, systematic structure
  #how do you believe the system works?
#3. show multivariate data to tell a richer story 
#4. integration of evidence and presentations; don't let the tool drive the analysis 
#5. describe & document evidence w appropriate labels and complete story 
#6. have high quality, relevant, high integrity content 

#exploratory graphs:
#understand data, find patterns, suggest modeling strategies, "debug" analyses, communicate results

#note: can pass column types in as you read the csv

pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric", "character",
                                                         "factor", "numeric"))
#simple, 1-d summaries

summary(pollution$pm25) #minimum, quartile, max, mean of pm25 column 

boxplot(pollution$pm25, col="blue")
abline(h=12) #overlays line at 12, which is a mean for this example datset

hist(pollution$pm25, col="green", breaks=100) #breaks: number of bars
rug(pollution$pm25) #plots points underneath histogram so you can see where data is 
abline(v=12, lwd=2) #overlays vertical line at 12
abline(v=median(pollution$pm25), col="magenta", lwd=4) #overlays vertical line at median

barplot(table(pollution$region), col="wheat", main="number of counties") #count plot, main = title

#2-d summaries

boxplot(pm25 ~ region, data=pollution, col="red") #split up into west and east region

#split data into two histograms to compare
hist(subset(pollution, region=="east")$pm25, col="green")
hist(subset(pollution, region=="west")$pm25, col="green")

with(pollution, plot(latitude, pm25)) #scatterplot of latitude and pm25
abline(h=12, lwd=2, lty=2) #adds horizontal dashed line at 12
#can subset the pollution argument above as well

#1. base plotting system: start with blank canvas, plot function and build up
  #use annotation function to add/modify (text, lines, points, axis)
  #convenient but can't go back once plot has started, diff to 'translate' to others

library(datasets)
data(cars)
with(cars, plot(speed, dist)) #simple scatter plot with speed on x, and dist on y

#2. lattice system: plots are created with single function call (xyplot, bwplot, etc.)
  #most useful for conditioning types of plots - look how y changes w x across levels of z
  #entire plot is specified at once; good for putting many plots on a screen
  #can be awkard to specify entire plot in single cell, requires lots of prep

library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data=state, layout = c(4,1))

#3. ggplot: automatically deals with spacing, text but also allows you to annotate 
  #default mode makes many chocies for you, but you can still customize


#plotting system: 
#core plotting and graphics engine is encapsulated in graphics and grDevices packages
#lattice package implemented using lattice and grid (indirect) packages

#process of making a plot:
  #where will it be made? how will it be used? how much data is going into it? do you need to resize it?

#base graphics:
  #must initialize a new plot, then annotate an existing plot
  #plot(x, y) or hist(x) will lauanch a graphics device (if not open already) & draw new plot

hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone)) #scatterplot

airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone")
#boxplot of ozone levels split up by month, lab are labels

#many base plotting functions share a set of parameters:
  #pch: plotting symbol, lty: line type, lwd: line width, col: plotting color (# or string or hex code)
  #xlab: character string for x-axis label, ylab: for y-axis label

#par function specifies global graphics parameters that affect all plots in an R session
  #parameters can be overwritten when specified as arguments
  #las: orientation of axis labels, bg: background color, mar: margin size
  #mfrow: # of plots/row, column (plots are filled row-wise), mfcol: plots filled column-wise

#can see default of par arguments by just calling:
par("bg") #background
par("mar") #margin, etc. 

colors() #will give you list of colors you can reference by name

#base plotting functions:
  #plot: scatterplot, or other tpe of plot depending on class of obj
  #lines: add lines to a plot, points: add points, text: add text labels, title: add anotations
  #mtest: add arbitrary text to margins of the plot, axis: add axis ticks/labels

with(airquality, plot(Wind, Ozone, type="n")) #type="n" sets up plot, but doesn't call anything yet
  #without type="n", you'd plot the whole thing and then overplot existing points
with(subset(airquality, Month == 5), points(Wind, Ozone, col="blue"))
  #adds subset of blue points to scatterpoint that correspond to month == 5
legend("topright", pch=1, col=c("blue"), legend=c("May"))

model <- lm(Ozone ~ Wind, airquality) #regression line
abline(model, lwd=2) #adds regression line to plot

#multiple base plots
par(mfrow = c(1,2)) #1 row, 2 columns
with(airquality, {
  plot(Wind, Ozone, main="Ozone and wind")
  plot(Solar.R, Ozone, main="Ozone and Solar")
  mtext("Ozone and Weather in NYC", outer=TRUE) #adds title above both plots
})

x <- rnorm(100)
y <- rnorm(100)
z <- rpois(100, 2)
plot(x, z, pch=20) #simple scatter plot, pch: point shape/look
par(mar = c(4,4,2,2)) #adjusts margins of plot
title("scatterplot")
text(-2, -2, "Label")
legend("topleft", legend="Data", pch = 20)
fit <- lm(z ~ x) #fit linear line to z, x relationship
abline(fit, lwd=3, col="blue") #add line to plot

plot(x, z, xlab="weight", ylab="height", main="scatterplot")

#have two plots up at the same time
par(mfrow = c(2,1))
plot(x, y, pch=20)
plot(x, z, pch=19)
par(mar=c(2,2,1,1)) #adjusts margins

#layered data:
x <- rnorm(100)
y <- x + rnorm(100)
g <- gl(2, 50, labels=c("Male", "Female"))

plot(x, y, type="n")
#can then add points sequentially in order to separate groups of data on a single scatter plot
points(x[g == "Male"], y[g == "Male"], col = "green")
points(x[g == "Female"], y[g == "Female"], col = "blue")

#graphics device: something where you can make a plot appear
  #when you make a plot in R, it has to be "sent" to a specific graphics device
  #on mac, screen device is launched with the quartz()

#list of devices is found in ?Devices
  #for quick visualizations and exploratory analysis, generally use the screen device
  #functions like plot, xyplot, or qplot will default to screen device
  #for plots that may be printed or incorporated into a document, a file device is more appropriate
  #note: not all graphics device are available on all platforms 

#two approaches to plotting
  #1. calling plotting function, plot appears on device, annotate if necessary
  #2. explicitly launch a graphics device, call plotting function, annotate, explicitly close
      #^ most commonly used for file devices

pdf(file = "myplot.pdf") #open pdf device, create myplot.pdf in wd
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser data")
dev.off() #close PDF file device, and only then can you view the file myplot.pdf on your computer

#two basic types of file devices:
  #vector: pdf (useful for line-type graphics, resize well, portable), svg, win.metafile, postscript
  #bitmap: png (good for line drawings or images with solid colors), jpeg (photos, good for plotting
    #many points, does not resize well), tiff, bmp

#possible to open multiple graphics devices and view multiple plots at once
  #plotting can only occur on one graphics device at a time
  #currently active graphics device can be found by calling dev.cur()
  #every open graphics device is assigned an integer > 1
  #can change activie graphics device with dev.set(<integer>)

#can copy a plot to another device with dev.copy, dev.copy2pdf
  #note: copying a plot is not an exact operation, so result may not be identical 

#lattice plotting
  #implements on top of grid package
  #all plotting and annotation is done at once with a single function call 

xplot #main function for creating scatter plots
bwplot #boxplots
hisogram
stripplot #boxplot but w actual points
dotplot #plot dots on violin strings

xyplot(y ~ x | f * g, data)
#y-axis variable, x-axis variable
#conditining variables, optional. * indicates an interaction between two variables
#looking at the scatterplot of y and x for every level of f and g
#data is the data frame or list from which variables can be looked up
  #if no data passed, it will look in the workspace

library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data = airquality)

airquality <- transform(airquality,  Month = factor(month))
xyplot(Ozone ~ Wind | Month, data=airquality, layout = c(5,1))
  #plots five columns of scatterplot of wind vs ozone (1 for each month)

#while base graphics functions plot data directly to the graphics device, 
  #lattice graphics functions return an object of class trellis
  #then this object has to be printed
  #defaults for aspects like margins and spacing are usually sufficient
  #ideal for creating conditioning plots where you examine same kind of plot under many conditions

p <- xyplot(Ozone ~ Wind, data=airquality)
print(p) #now p appears!

#lattice functions have a panel function, which controls what happens inside each panel
  #can be specified/customized

#creating random data
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group1", "Group2")) 
print(xyplot(y ~ x | f, layout = c(2, 1)))

#custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...) #first call default panel function
  panel.abline(h = median(y), lty=2) #adds horizontal line at the median
  panel.lmline(x, y, col=2) #adds linear regression line to each of the panels
})

#note you can't use annotations from base plotting systems - just lattice

#ggplot2

library(ggplot2)

#statistical graphic is mapping from data to aestheti attributes of geometric objects
  #may also contain statistical transformation of data

qplot() #works like the plot function in base system, looks for data in a dataframe or parent env.
#can be a little difficult to customize

#factors are important for indicating subsets of the data; they should be labeled
#qplot hides what goes on underneath, which is okay for most operations
#ggplot() is the core function and very flexible 

str(mpg) #example dataset of mpg / types of cars

qplot(displ, hwy, data=mpg, color=drv, geom=c("point", "smooth"))
#can separate points by changing color / drv variable
#adds line and area at 95% CI for that line - 'smooth'
#can use a bunch of different geom types, like geom = "density"

qplot(hwy, data=mpg, fill=drv)
#returns a histogram when just given one factor, color within one
#bin is split up by the drv factor

qplot(displ, hwy, data=mpg, facets= .~drv)
#sets up unique plot for each type of drv variable
#displ is y, hwy is x-axis variable
#facets = columns ~ rows 
  #in the above example, we just specify the row split up by drv,
  #so there's a . on the left side of the ~
qplot(hwy, data = mpg, facets = drv ~., binwidth = 2)
  #this will set up a histogram for hwy in which the column 
  #is split up by drv

#basic components of a ggplot2 plot:
  #dataframe, aesthetic mapping, geoms (geometric objects), facets (for conditional plots)
  #stats (statistical transformations), scales, coordinate system 

#when building plots in ggplot2, rather than using qplot, plots are built up in layers
  #plot the data > overlay a summary > metadata & annotation


g <- ggplot(data, aes(x, y))
p <- g + geom_point() #explicitly save and print ggplot object
  #can literally use + to add layers to your plot
g + geom_point() #auto prints plot object without saving

#might want to add a smoother so you get a general sense of the data
 #adds a little smoother, which is a line & confidence boundary 
g + geom_point() + geom_smooth(method = "lm") + #adds linear regression line, not just CI 
  facet_grid(.~bmicat) #splits up by plot by facet(s) specified
    #can also change geom_smooth's overall look 
    #number of plots will be equal to the number of factors
    #ggplot will take names of factors as label names 

#annotation:
  #xlab(), ylab(), lab() #general label
  #ggtitle()
  #theme(legend.position = "none") #for things that only make sense globally, use theme()
  #two standard appearance themes are included: theme_gray(), theme_bw()
  
g + geom_point(color="steelblue", size = 4, alpha = 1/2) #assigning constant 
g + geom_point(aes(color=bmicat), size = 4, alpha = 1/2) #colors depending on bmicat variable
#can also add + labs(title = "MAACS Cohort) + labs(x = "Nocturnal Systems", y = y)
#or adding + theme_bw(base_family = "Times") #changes font to Times 

#a note about axis limits: 

#ggplot will automatically plot outliers (unlike the base plot function), but you don't always
#want to see outliers

g + geom_line() + coord_cartesian(ylim = c(-3, 3))
  #coord_cartesian sets y-axis limits to be -3 and 3 so the graph shrinks but doesn't change

#note: have to use the cut() function split a continuous variable into factors

str(airquality$Month)

#hierarchical clustering:
  #agglomerative approach - find closest two things, put them together, find next closest, etc.
  #requires a defined distance and a merging approach
  #produces a tree showing how close things are to each other

#how do we define close? - have to pick a distance metric that makes sense for your problem
  #continuous - euclidean distance - straight difference in coordinates (bird eye)
    #can extend easily to multi dimensional problems 
  #continuous - correlation similarity (highly correlated - close together)
  #binary - manhattan distance
    #looking at distance like you're walking across grid city
    #written mathematically as sum of all the different coordinatres 

#to run hierarchical clustering, first have to find distance between all points
#should primarily be used for exploration - may be unstable with outliers, missing values, 
  #and depending on merging strategy / scale of points for variables

x = c(1:10)
y = c(11:20)
dataFrame <- data.frame(x = x, y = y)
distxy <- dist(dataFrame) #dist defaults to euclidean distance metric
  #returns matrix of pairwise distances
hClustering <- hclust(distxy)
plot(hClustering) #plots dendrogam, which shows us clustering visually 
  #points farther down got clustered first, farther up got clustered later
  #have to then cut the tree at a certain point to determine # of clusters 
    #(choosing where to cut isn't always obvious)

#myplclust function (have to download) can make dendrogam prettier
  #if you specify clusters ahead of time, it will auto color them
  #or ccan download even fancier functions 

#when you merge points together, new point can be: average of old coords or distance from far points
  #useful to try multiple and see what works best!

heatmap() #runs hierarchical clustering analysis on rows and columns of table
  #creates an image in which rows and columns are clustered together based on algorithm 
  #useful for visualizing multi-dimensional table data 

#K-means clustering - useful for summarizing high dimensional data
  #finding things that are close together
  #fix a number of clusters - get 'centroids' of each cluster - assign things to closest centroid - 
    #recalculate centroids
  #requires: defined distance metric, # of clusters, inital guess as to centroids
  #produces: final estimate of cluster entroids, assignment of each point to clusters
    #there are also algorithms to try to find amount of clusters
  #not deterministic, useful to run it a couple different times 

kmeans() #function used to implement the kmeans algorithm 
dataframe <- data.frame(x, y)
kmeansObj <- kmeans(dataframe, centers = 3)
names(kmeansObj) #list of different elements that make up the object
kmeansObj$cluster #returns list that tells you which cluster each of your points is in
  # 3 3 3 1 1 1 2 2 2 etc. 
kmeansObj$centers #returns centroids

plot(x, y, col = kmeansObj$cluster, pch=19, cex=2) #plots points, colors by cluster
points(kmeansObj$centers, col = 1:3, pch = 3, lwd = 3) #plots centroids 

#heatmaps: (also a heatmap function?)
kmeansObj <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1, 2), mar = c(2, 4, 0.1, 0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1], yaxt = "n")
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt = "n")

#if you have a lot of different variables, you want to try to find a new set of 
#multivariate variables that are independent, uncorrelated, and explain as much variance
#as possible (statistical)

#if you put all variables in one matrix, find the best matrix created with fewer variables
#that explains the original data (data compression) - aka lower ranked matrix

#note: orthogonal - independent of each other 

#SVD: if X is a matrix with each variable in a column and each observation in a row, then the
#SVD is a 'matrix decomposition' X = UDV^T
  #where columsn of U are orthogonal, left singular vectors, of V are orthogonal, right singular
  #vectors and D is a diagonal matrix of singular values
    #v might be the columns?

#scale of your data matters! 

#PCA : equal to the right singular values if you first scale (subtract mean, divide by SD) all 
#variables - and then find the SVD of that

#SVD - Variance explained:
  #each singular value represents % of total variation in dataset explained by that component
  #can plot proportion of variation explaiened by using the 'd' column 
  #raw singular value doesn't have meaning on its own, have to divide by total singular values

#example:
svd1 <- svd(scale(dataMatrixOrdered))
plot(svd1$d) #shows raw singular value per component
plot(svd1$d^2/sum(svd1$d^2)) #proportion of singular value per component 

#once you take the svd of a data matrix, then it becomes a new svd object and you can literally
#call svdobj$u, $v, and $d 
  #have to call svdobj$v[,2] to get second right singular vector if there are two patterns

#can't run SVD or PCA on dataset with missing values 
  #one possibility is to use the impute package to just impute the missing data points 
  #impute.knn function imputes missing data by avg of k-nearest neighbors to that row 
  

#can create approximations of matrices based on strongest influencers for original matrix

svd1 <- svd(scale(faceData))
approx1 <- svd1$u[,1] %*% t(svd1$v[,1]) %*% svd1$d[1] #based just on first variable
approx5 <- svd1$u[,1:5] %*% diag(svd1$d[1:5]) %*% t(svd1$v[,1:5]) 
  #based on first five variables 

#plotting & color in R

#have different palettes you can use - like heat.colors, topo.colors()
#grDevices package has two functions
  #these functions take palettes of colors and helps to interpolate between them
  #colorRamp: take palette of colors and return function that takes values b/w 0 and 1, 
    #indicating the extremes of the color palette
  #colorRampPalette: take palette of colors, return a function that takes integer args and
    #returns a vector of colors interpolating the palette

colors() #returns names of all the colors you can use in any plotting function

pal <- colorRamp(c("red", "blue"))
  #going to mix them together in various degrees to create new colors
  #pal can now take values b/w 0 and 1

pal(0)
  #returns matrix of [255, 0, 0] - represents Red, Blue, Green values
    #255 is max allowed for any one color
    #pal(0) will just give red

pal(1)
  #returns [0, 0, 255] - pal(1) returns blue

pal(0.5)
  #will represent something between blue and red
    #returns [127.5, 0, 127.5]


pal <- colorRampPalette(c("red", "yellow"))
  #will take integer args, not just numbers bewteen 0 and 1

pal(2) #will return the two colors on the palette
pal(10) #returns character value of red, blue, and green that are represented in characters
  #wluld give 10 values of colors as you move from red to yellow

#rcolorbrewer package provides set of interesting palettes
  #sequential, diverging, qualitative 

install.packages('RColorBrewer')
library(RColorBrewer)

cols <- brewer.pal(3, "BuGn") #number of colors, palette wanted
cols #list of your colors

pal < colorRampPalette(cols) #finds ramp between all the colors you chose
image(volcano, col = pal(20)) #plot image with 20 of that ramp

x <- rnorm(1000)
y <- rnorm(1000)
smoothScatter(x, y) #creates histogram of x and y values, then plots the histogram
  #means the plot is a lot nicer to look at, not just a million little plots
  #automatically in blue theme, but you can change it

rgb() #takes color via RGB proportions, and returns hex code
  #color transparency can be added via the alpha parameter, 0 - 1

#colorspace package can be used fora  differet control over colors

plot(x, y, col= rg(0, 0, 0, 0.2), pch = 19)
  #plots in black with a lot of transparency
  #allows you to see amount of points in one area easier




