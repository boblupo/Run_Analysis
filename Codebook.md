---
title: "Codebook"
author: "Robert A Lupo"
date: "Saturday, September 20, 2014"
output: html_document
---
# Code Book
Creates one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets from the UCI HAR Dataset to create one data set.
  
  Files read in from the current working directory:
  
		Training set:   test/subject_test.txt , test/X_test.txt , test/y_test.txt
    
		Subject set: subject_train.txt, train/X_train.txt, train/y_train.txt
    
2. Extracts the attribute columns calculated using mean() and standard deviation std() functions.
	Uses grep1():    selectMeanSTDColumns       <- grep("mean|std)",names(allData))
  
3. Uses descriptive activity names to name the activities in the data set 
   
   represented by (factors 1:6)

	1 = WALKING  	  2 = WALKING_UPSTAIRS  	3 = WALKING_DOWNSTAIRS

  4 = SITTING  		5 = STANDING          	 6 = LAYING

4. Appropriately label the data set with descriptive variable names using gsub(). 
             For example: names(allDataMeanSTD) <- gsub("Mag",   "Magnitude", names(allDataMeanSTD))
             
5. From the data set in step 4, creates a second, independent tidy data set named tidyMeltedDataSet.

   uses the reshape2 library functions:
   
        melt()  – puts - data into long form 

        dcast() – melted data frame output applying mean() to all measured variables

6. Saves independent tidy data set named tidyMeltedDataSet as a text file:
	 
   Saved as as tidydata.txt with string variables without quotes

   write.table(tidyMeltedDataSet, "tidydataset.txt",row.name=FALSE,quote=FALSE)	


