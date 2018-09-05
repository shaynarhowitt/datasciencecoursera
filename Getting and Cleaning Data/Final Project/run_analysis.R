
#read and download zipped file; unzip 

zipped <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(zipped,temp)

unzip(zipfile="/var/folders/_h/h17pyn6x4675clf3jh9yk72h0000gn/T//RtmpZhG22C/file8365343f14e2")
readme <- readLines("./UCI HAR Dataset/README.txt")

#read and save feature names

features <- read.table("./UCI HAR Dataset/features.txt")

#read and merge train data; label with variable descriptions
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Training label"))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train)[1] <- paste("subject")

train_merged <- cbind(X_train, y_train, subject_train)

#read and merge test data; label with variable descriptions
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Training label"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test)[1] <- paste("subject")

test_merged <- cbind(X_test, y_test, subject_test)
dim(test_merged)

#merge training and test data

big_data <- rbind(train_merged, test_merged)

#extract only mean and standard deviation for each measurement
#from the features.txt doc, we know that 

mean_or_sd_cols <- grepl("mean[^Freq]|std", names(big_data))
big_data1 <- big_data[,mean_or_sd_cols]

#use descriptive activity names to name activities in the dataset

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
big_data$Training.label <- factor(big_data$Training.label)
levels(big_data$Training.label) <- activities[,2]

table(big_data$Training.label)

#create a second, independent tidy data set with the average of each variable for each activity and each subject

big_data$Training.label <- as.numeric(big_data$Training.label)

avg_walking <- colMeans(big_data[big_data$Training.label == 1,])
avg_walking_upstairs <- colMeans(big_data[big_data$Training.label == 2,])
avg_walking_downstairs <- colMeans(big_data[big_data$Training.label == 3,])
avg_sitting <- colMeans(big_data[big_data$Training.label == 4,])
avg_standing <- colMeans(big_data[big_data$Training.label == 5,])
avg_laying <- colMeans(big_data[big_data$Training.label == 6,])

averages <- rbind(avg_walking, avg_walking_upstairs, avg_walking_downstairs, avg_sitting, avg_standing, avg_laying)


