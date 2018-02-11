# Cousera : Data Science : Getting and Cleaning Data - Course Project 

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, runs through the following steps:

1. Downloads train and test datasets  
2. Loads the activity and feature info 
3. Loads both the training and test datasets,
4. Extracts only those columns which
   reflect a mean or standard deviation
5. Loads the activity and subject data for each dataset, and merges those
   columns with the dataset
6. Merges the two train and test sets into one combined set 
7. Converts the `activity` and `subject` columns into factors, activities become interpretable
8. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair by grouping the combined set and summarising for each variable

The end result is shown in the file `tidy.txt`.

In between the processing steps some tests are conducted to verify number of rows or column names