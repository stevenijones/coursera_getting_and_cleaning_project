# Getting ang cleaning Data - Coursera Data Science 
# Project Assingment - Steven Jones
# 2016-05-07

# Set working directory and packages
setwd("C://Users//sjones//Documents//R//DataScienceCourse//GAndCProject")

# Step 1: Merges the training and the test sets to create one data set.

# Read in data
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

# merge train and test - x's, y's and subjects
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind(subjecttrain, subjecttest)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt") # read in data
features <- features[, 2] # only take second column with names

names(xdata) <- features # change names of main data to feature names

meanstdcols <- grep("(mean|std)", features) # get col nums with mean and std

xdata <- xdata[,meanstdcols] # subset to the xdata with the mean and std dev cols

# Step 3: Uses descriptive activity names to name the activities in the data set

# create better names than in the text file
activitynames <- c("walking", "walkingupstairs", "walkingdownstairs", "sitting", "standing", "laying")

# put those names in place of the values in the ydata
ydata[,1] <- activitynames[ydata[,1]]

# Step 4: Appropriately labels the data set with descriptive variable names.

names(subjectdata) <- "subject" # label the subject column
names(ydata) <- "activity" # label the new stringy activity data
names(xdata) <- gsub("\\(\\)", "", names(xdata)) # get rid of brackets - not adding anything and may be troublesome
names(xdata) <- gsub("-", " ", names(xdata)) # change dash to space to make more human readable
names(xdata) <- gsub("meanFreq", "mean frequency", names(xdata)) # change from abbreviation to full word
names(xdata) <- gsub("std", "standard deviation", names(xdata)) # change from abbreviation to full word

# combine all the data now it is nearly tidy
tidydata <- cbind(subjectdata, ydata, xdata)
library(reshape2)
tidydatamelted <- melt(tidydata, id = c("subject", "activity")) # melt this so we don't have a wide frame

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.

tidydatamean <- dcast(tidydatamelted, subject + activity ~ variable,mean) # recast to a wide table but with means

write.csv(tidydatamean, "tidydatamean.csv")

