# Creates one R script called run_analysis.R that does the following. 

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement. 

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#---------------------------------------------------------------------------
# 1.............................................................................
# READ in DATASETS folder - UCI HAR Dataset/

# Read in Subject Test Data folder

# Subject ID
subject_ID         <- read.table("subject_test.txt") 
# Training Set X values
subject_Data       <- read.table("X_test.txt")   
# Activity 1:6
subject_Activity   <- read.table("y_test.txt")    

# Read in Subject Training Data (t)

t_subject_ID       <- read.table("subject_train.txt")
t_subject_Data     <- read.table("X_train.txt")
t_subject_Activity <- read.table("y_train.txt")

#Combine datasets
testData   <- cbind(subject_ID, subject_Activity,subject_Data)

traingData <- cbind(t_subject_ID,t_subject_Activity,t_subject_Data)

allData    <- rbind(testData,traingData)
#--------------------------------------------------------------------------
# Read in Activity Types: 1.WALKING  2. WALKING_UPSTAIRS  3.WALKING_DOWNSTAIRS
#                         4.SITTING  5. STANDING          6. LAYING
# Used to replace activity value with descriptive names

activityLabels     <-  read.table("activity_labels.txt")$V2

# Read in Features Data

featureLabels <- read.table("features.txt")$V2

# Prepare readable attribute (column) names for allData table
featureLabels <- as.character(featureLabels)

allLabels <- append(c("subjectID","Activity"),featureLabels)

names(allData) <- allLabels

#2..............................................................................
# Column Subset for features containing attributes mean and std

selectMeanSTDColumns       <- grep("mean|std)",names(allData))
selectMeanSTDColumns       <- append (c(1,2),selectMeanSTDColumns)
allDataMeanSTD             <- allData[selectMeanSTDColumns]

#3............................................................................
# Make Activity more readable 

allDataMeanSTD$Activity <- as.character(allDataMeanSTD$Activity)
allDataMeanSTD$Activity <- sapply(allDataMeanSTD$Activity , switch, 
                                    '1' = "WALKING", 
                                    '2' = "WALKING_UPSTAIRS" , 
                                    '3' = "WALKING_DOWNSTAIRS", 
                                    '4' = "SITTING",
                                    '5' = "STANDING",
                                    '6' =  "LAYING")
#...............................................................................
#4. Appropriately label the data set with descriptive variable names. 

names(allDataMeanSTD) <- gsub("mean", "Mean", names(allDataMeanSTD))
names(allDataMeanSTD) <- gsub("std",  "Std", names(allDataMeanSTD))

names(allDataMeanSTD) <- gsub("Acc",   "Accelerometer", names(allDataMeanSTD))
names(allDataMeanSTD) <- gsub("Gyro",  "Gyrometer", names(allDataMeanSTD))
names(allDataMeanSTD) <- gsub("^f",    "Frequency", names(allDataMeanSTD))
names(allDataMeanSTD) <- gsub("Mag",   "Magnitude", names(allDataMeanSTD))
names(allDataMeanSTD) <- gsub("^t",    "Time", names(allDataMeanSTD))

#5.  From the data set in step 4 - allDataMeanSTD,create a second, 
#    independent tidy data set with the average of each variable 
#    for each activity and each subject.

# Load reshape2 library to use melt(),dcast()
library(reshape2)
# Melt (long form) based on identifier variables (subjectID and activity)
#                  based on measured variables (all data fields)
meltedDataSet<-melt(allDataMeanSTD, measure.vars=names(allDataMeanSTD)[-c(1,2)],
                                      id.vars = c("subjectID","Activity"))
tidyMeltedDataSet <- dcast(meltedDataSet, subjectID + Activity ~ variable, mean)

#Please upload the tidy data set created in step 5 of the instructions. 
#Please upload your data set as a txt file created with 
#write.table() using row.name=FALSE 

# Save completed tidy data as tidydata.txtwith string variables without quotes
write.table(tidyMeltedDataSet, "tidydataset.txt",row.name=FALSE,quote=FALSE)
