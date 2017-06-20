# Author: Kyle B. Schenthal
# Date Created: Mon Jun 19 15:26:15 2017
# Last Updated:
# Coursera Course: Getting and Cleaning Data
# Course Project
# Description: 
# ---------------------------------------------------------

library(tidyverse)

# Download and Extract zip file ---------------------------
kFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
kZipFileName <- "uci_har_dataset.zip"
kDirName <- "UCI HAR Dataset"

if (!dir.exists(kDirName)) { # Check if dataset is in working directory
    download.file(kFileURL, kZipFileName, method = "curl")
    unzip(kZipFileName)
}


# Read in data---------------------------------------------
# Activity and feature indexes
activity <- read.table("UCI HAR Dataset/activity_labels.txt", 
                       col.names = c("activityID", "activityName"))

features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("featureIndex", "featureName"), 
                       colClasses = c("numeric", "character"))

# Training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = 'subjectID')
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      col.names = features$featureName)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = 'activityID')

# Test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names = 'subjectID')
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names = features$featureName)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names = 'activity')


# Merge the training and the test sets --------------------
train <- cbind(subject_train, y_train, x_train)
test  <- cbind(subject_test,  y_test,  x_test)
all_data <- rbind(train, test)

# Select Cols & add descriptive activity identifiers-------
mean_std_data <- all_data %>%
                    # Extract mean and std measurements
                    select(grep("*mean()*|*std()*|activity|subject",
                                colnames(all_data))) %>%
                        # Make descriptive activity identifiers
                        mutate(activityID = activity$activityName[activityID])


# Create tidy data set of subjects activity means ---------
# TODO
