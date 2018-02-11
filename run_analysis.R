
library(tidyr)
library(dplyr)
## initial local directory
##setwd("C://Users//J?rg//Documents//coursera//datascience//Kurs3_Woche4")

filename <- "getdata_projectfiles_UCI HAR Dataset.zip" 

## Download and unzip the dataset: 
if (!file.exists(filename)){ 
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
   download.file(fileURL, filename, method="curl") 
}   
if (!file.exists("UCI HAR Dataset")) {  
   unzip(filename)  
} 

# Read activity labels + features 
activityLabels <- read.table("UCI HAR Dataset//activity_labels.txt") 
activityLabels[,2] <- as.character(activityLabels[,2]) 

features <- read.table("UCI HAR Dataset//features.txt") 
features[,2] <- as.character(features[,2]) 
 
# Extract data on mean and standard deviation only

targetFeatures<- grep(".*mean.*|.*std.*", features[,2]) 
targetFeatures.names <- features[targetFeatures,2] 

### Rename / clean colNames 
targetFeatures.names = gsub('-mean', 'Mean', targetFeatures.names) 
targetFeatures.names = gsub('-std', 'Std', targetFeatures.names) 
targetFeatures.names <- gsub('[-()]', '', targetFeatures.names) 

# Load train  datasets - target features ( mean, std ) only
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")[targetFeatures] 
ncol(trainSet) ## 79 features selected

## select activities
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt") 
##select subjects
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 

## merge subject column, activities columns and feature columns into the train set
trainSet <- cbind(trainSubjects, trainActivities, trainSet) 
## number of rows:
nrow(trainSet) ## 7352

### repeat for test set
testSet <- read.table("UCI HAR Dataset/test//X_test.txt")[targetFeatures]
testActivities <- read.table("UCI HAR Dataset//test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset//test/subject_test.txt") 
testSet <- cbind(testSubjects, testActivities, testSet) 
## number of rows:
nrow(testSet) ## 2947


# merge datasets and add labels 
mergedDataSet <- rbind(trainSet, testSet) 
## number of rows : 7352 + 2947
nrow(mergedDataSet) == 7352 + 2947 ## TRUE (10299)

colnames(mergedDataSet) <- c("subject", "activity", targetFeatures.names) 


## test
colnames(mergedDataSet)[1] == "subject" ## --> TRUE 

# turn activities & subjects into factors --> make descriptive / readable 
mergedDataSet$activity <- factor(mergedDataSet$activity, levels = activityLabels[,1], labels = activityLabels[,2]) 
mergedDataSet$subject <- as.factor(mergedDataSet$subject) 
 
### summarise for all features : groups: subject, acticity : mean for every variable
meansPerSubjectActivity <- data.frame(mergedDataSet %>%
  group_by(subject, activity) %>%
  summarise_all(mean) )

## write out
write.table(meansPerSubjectActivity, "tidy.txt", row.names = FALSE, quote = FALSE)
