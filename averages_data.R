## Getting & Cleaning Data Project
## Paul Gallop (paul.e.gallop@gmail.com)

library(plyr)

## Before running this script download
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## And extract data. Set the working directory to the location of the extracted data

## Step 1 merge the training and test data sets to create a single one

features <- read.table("features.txt") ## the variable names for X tables

x_train <- read.table("train/X_train.txt", col.names = features[,2])
y_train <- read.table("train/y_train.txt")
subject_train <- read.table ("train/subject_train.txt")

x_test <- read.table("test/X_test.txt", col.names = features[,2])
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

## Combine the x values
x_data <- rbind(x_train, x_test)

## Combine the y values
y_data <- rbind(y_train, y_test)

## combine subject values
subject_data <- rbind(subject_train, subject_test)


## Step 2 Extract only the measurements on the mean and standard deviation for each measurement

## Identify which features have mean or std in their column names
## grep identifies the positions in which it matched the search pattern

mean_and_std_features <- grep("(mean|std)", features[, 2])

## The above selects all variables associated with mean (and std) as follows:
## mean(): Mean value
## meanFreq(): Weighted average of the frequency components to obtain a mean frequency
## gravityMean
## tBodyAccMean
## tBodyAccJerkMean
## tBodyGyroMean
## tBodyGyroJerkMean

## Subset X by variables containing the words mean or std
x_data_mean_std <- x_data[, mean_and_std_features]

## Step 3 Use descriptive activity names to name the activities in the data set

## Load in activities and replace the activity code in column 1 of y_data with the appropriate
## activity name from the activity file
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]

## label the column correctly
names(y_data) <- "activity"

## Step 4 Appropriately label the data set with descriptive variable names

## label the subject column correctly
names(subject_data) <- "subject"

## bind all the data in a single data set
transformed_data <- cbind(subject_data, y_data, x_data_mean_std)

## Step 5 Create a second, independent tidy data set with the average of each variable for
## each activity and each subject

averages_subject_act <- ddply(transformed_data,.(subject,activity), function(x) colMeans(x[,3:81]))

## ddply defn: for each subset of a df apply function then combine results in a df
## note . notation allows quotes to be omitted from the vector specifying split of df .(subject,activity)

## Output data to file
write.table(averages_subject_act, "averages_data.txt", row.name=FALSE)
