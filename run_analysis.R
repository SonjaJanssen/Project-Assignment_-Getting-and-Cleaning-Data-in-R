
##  Week 4_Getting and Cleaning Data Science Course Project

#   Lectures: By Professors PhD Jeffrey Leek, Jeff Leek, PhD Roger D. Peng, PhD Brian Caffo
#   University: John Hopkins University Bloomberg School of Public Health _ at coursera
#   Codes: @SonjaJS
#   Date:  4 April 2023

##  Grade: 
##  Graded peers assignment: by 4 peers review
##  Script: All Codes are tested, assignment completed: codes all ok!
##  This script was created:
#               - in RStudio Version 0.97.124 for windows
#               - with R version 4.2.2 for windows
#               - dplyr version 1.1.1
#               - data.table version 1.14.8
#               - plyr version 1.8.8
#               - knitr version 1.42
#               - data was downloaded at date: 'Tue April 4 20:09:05 2023'


#*******************************************************************************
# Instructions:
#    The purpose of this project is to demonstrate your ability to collect, 
#    work with, and clean a data set.
#*******************************************************************************
# . A full description is available at the site where the data was obtained:

#    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# . Here are the data for the project:

#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#*******************************************************************************
# . You should create one R script called run_analysis.R that does the following:

#   The run_analysis.R script performs the data preparation and then followed by 5 steps 
#   required as described in the course project's definition:

##  1. - Merges the training and the test sets to create one data set.
##  2. - Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3. - Uses descriptive activity names to name the activities in the data set.
##  4. - Appropriately labels the data set with descriptive variable names. 
##  5. - From the data set in step 4, creates a second, independent tidy data set 
#        with the average of each variable for each activity and each subject.

                               ### Good luck! ###
#*******************************************************************************
#  Plan 1: # First step to do before executing this script, 'get_project_data.R'
#******************************************************************************* 
#  0.   - Download packages 
#  0.1. - Download the zipfile & put in the data folder

#  DOWNLOAD URL: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#  1. check if the data files are available. 
#     If the data doesn't exist: - download zipped file
#                                - create a log file
#                                - unzip the file
#                                - put unzipped files in path_file
#                                - get the list of the files

#********************************** Start **************************************

## It clears all objects from the workspace
   rm(list=ls()) 

#*******************************************************************************
#                                  Step 0 
#                       0. Download required packages
#
#*******************************************************************************

  library(dplyr)                                                                ## dplyr version 1.1.1 (a grammar of data manipulation)
  library(data.table)                                                           ## data.table version 1.14.8 (Extension of dataframe)
                                                                                ## Codes tested = ok!
#*******************************************************************************
#                                Step 0.1    
#                           0.1. Get the data
#  
#*******************************************************************************

# 0.1.1 Download the file and put the file in the data folder                   ## dir.exists checks that paths exist (same as file.exists) 
  if(!file.exists("./data")){dir.create("./data")}                              ## and are directories : chr [1:28]
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 
# 0.1.2. Dataset downloaded and extracted under the folder called UCI HAR Dataset.zip file
  download.file(fileUrl,destfile="./data/Dataset.zip", method="curl")           ## Codes tested = ok!
                                                                               
# 0.1.3. Unzip the file
  unzip(zipfile="./data/Dataset.zip",exdir="./data")                            ## Codes tested = ok!                          
  ##  Unzipped file dataSet to data exdirectory
                                                                                
# 0.1.4. unzipped files are in the folder UCI HAR Dataset                       ## > path_file [1] "./data/UCI HAR Dataset"
  path_file <- file.path("./data" , "UCI HAR Dataset")                          ## testing: changed path_rf to path_file             
                                                                                ## Codes tested = ok! 
# 0.1.5.  Get the list of the files                                             
  files <- list.files(path_file, recursive=TRUE)                                ## files  chr [1:28] "activity_labels.txt, ....
  files                                                                         ## dir is an alias for list.files

                                                                                ## Codes tested = ok!
## outcome: # files
# [1]  "activity_labels.txt"                           "features.txt"                                
# [3]  "features_info.txt"                             "README.txt"                                  
# [5]  "test/Inertial Signals/body_acc_x_test.txt"     "test/Inertial Signals/body_acc_y_test.txt"   
# [7]  "test/Inertial Signals/body_acc_z_test.txt"     "test/Inertial Signals/body_gyro_x_test.txt"  
# [9]  "test/Inertial Signals/body_gyro_y_test.txt"    "test/Inertial Signals/body_gyro_z_test.txt"  
# [11] "test/Inertial Signals/total_acc_x_test.txt"    "test/Inertial Signals/total_acc_y_test.txt"  
# [13] "test/Inertial Signals/total_acc_z_test.txt"    "test/subject_test.txt"                       
# [15] "test/X_test.txt"                               "test/y_test.txt"                             
# [17] "train/Inertial Signals/body_acc_x_train.txt"   "train/Inertial Signals/body_acc_y_train.txt" 
# [19] "train/Inertial Signals/body_acc_z_train.txt"   "train/Inertial Signals/body_gyro_x_train.txt"
# [21] "train/Inertial Signals/body_gyro_y_train.txt"  "train/Inertial Signals/body_gyro_z_train.txt"
# [23] "train/Inertial Signals/total_acc_x_train.txt"  "train/Inertial Signals/total_acc_y_train.txt"
# [25] "train/Inertial Signals/total_acc_z_train.txt"  "train/subject_train.txt"                     
# [27] "train/X_train.txt"                             "train/y_train.txt" 

          #********************************************************#
          #   All Codes tested for the steps 0 and 0.1 = all ok!   #  
          #********************************************************#
                
#*******************************************************************************
#                                  Step 1
#         1. Merges the training and the test sets to create one data set
# 
#*******************************************************************************

## Instructions:
# See the README.txt file for the detailed information on the dataset.
# For the purposes of this project, the files in the Inertial Signals folders are not used.
# The files that will be used to load data are listed as follows:
  
  #  train / y_train.txt 
  #  train / subject_train.txt
  #  train / X_train.txt
    
  #   test / subject_test.txt
  #   test / X_test.txt
  #   test / y_test.txt

## Read data from the targeted files
# _________________________________________________________________
# Variables Names |  Activity   |      Subject      | features.txt          
# _________________________________________________________________
# Data            | y_train.txt | subject_train.txt | X_train.txt   \  
# _________________________________________________________________  \ activity_labels.txt
# Data            | y_test.txt  | subject_test.txt  | X_test.txt     /
#__________________________________________________________________ /
  
# - Values of Variable  "Activity" consist of data from “y_train.txt” and “y_test.txt”
# - values of Variable  "Subject"  consist of data from “subject_train.txt” and subject_test.txt"
# - Values of Variables "Features" consist of data from “X_train.txt” and “X_test.txt”
# - Names  of Variables "Features" come            from “features.txt”
# - Levels of Variable  "Activity" come            from “activity_labels.txt”
# - So we will use "Activity", "Subject" and "Features" as part of descriptive variable names 
#   for data in data frame.

  
#******************************************************************************* 
#                                 Step 1.1
#          1.1. Read data from the targeted files into the variables
# 
#*******************************************************************************
 
# 1.1.1. Read the Activity files
  DataActivityTrain <- read.table(file.path(path_file, "train", "Y_train.txt"), header = FALSE)
  DataActivityTest  <- read.table(file.path(path_file, "test" , "Y_test.txt" ), header = FALSE)
                                                                                
 ## Outcome DataActivityTrain  | 7352 obs. of 1 variable |$ v1: int 5 5 5 5 5 5 5 5 5 5 5 ...
 ## Outcome DataActivityTest   | 2947 obs. of 1 variable |$ v1: int 5 5 5 5 5 5 5 5 5 5 5 ... 
                                                                                ## Codes tested = ok! 

## 1.1.2. Read the Subject files
  DataSubjectTrain <- read.table(file.path(path_file, "train", "subject_train.txt"), header = FALSE)
  DataSubjectTest  <- read.table(file.path(path_file, "test" , "subject_test.txt"), header = FALSE)
                                                                                
  ## Outcome DataSubjectTrain  | 7352 obs. of 1 variable | $ v1: int 2 2 2 2 2 2 2 2 2 2 ...
  ## Outcome DataSubjectTest   | 2947 obs. of 1 variable | $ v1: int 1 1 1 1 1 1 1 1 1 1 ...
                                                                                ## Codes tested = ok! 
  
# 1.1.3. Read Features files
  DataFeaturesTrain <- read.table(file.path(path_file, "train", "X_train.txt"), header = FALSE)
  DataFeaturesTest  <- read.table(file.path(path_file, "test" , "X_test.txt"), header = FALSE)
 
 ## Outcome DataFeaturesTrain  | 7352 obs. of 561 variable | $ v1: int 2 2 2 2 2 2 2 2 2 2 ...
 ## Outcome DataFeaturesTest   | 2947 obs. of 561 variable | $ v1: int 1 1 1 1 1 1 1 1 1 1 ...
                                                                                ## Codes tested = ok! 

    
#*******************************************************************************
#                                  Step 1.2
#               1.2. Look at the properties of the above variables 
#
#*******************************************************************************

  ## look at the structure of the variables
  
  str(DataActivityTrain)
  str(DataActivityTest)
  
  str(DataSubjectTrain)
  str(DataSubjectTest)
  
  str(DataFeaturesTrain)
  str(DataFeaturesTest)
 
 ## str(DataActivityTrain)'data.frame':	7352 obs. of  1 variable   | $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
 ## str(DataActivityTest) 'data.frame':	2947 obs. of  1 variable   | $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
 ## str(DataSubjectTrain) 'data.frame': 7352 obs. of  1 variable   | $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
 ## str(DataSubjectTest) 'data.frame':  2947 obs. of  1 variable   | $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
 ## str(DataFeaturesTrain)'data.frame: 7352 obs. of  561 variables |  
 ## str(DataFeaturesTest)'data.frame': 2947 obs. of  561 variables:| 
  
  ## str(DataFeaturesTrain) only the first 10 rows below
# 'data.frame':	2947 obs. of  561 variables:
#  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
#  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
#  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
#  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
#  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
#  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
#  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
#  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
#  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
  
  ## str(DataFeaturesTest)  only the first 10 rows below
# 'data.frame':	2947 obs. of  561 variables:
#  $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
#  $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#  $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
#  $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
#  $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
#  $ V6  : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
#  $ V7  : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
#  $ V8  : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
#  $ V9  : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
#  $ V10 : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
                                                                                ## Codes tested = ok! 

                                     
#*******************************************************************************
#                                  Step 1.3
#      1.3. Merges the training and the test sets to create one data set
#
#*******************************************************************************

# 1.3.1. Concatenate the data tables by rows
 
  ActivityData <- rbind(DataActivityTrain, DataActivityTest)        
  SubjectData <- rbind(DataSubjectTrain, DataSubjectTest)
  FeaturesData <- rbind(DataFeaturesTrain, DataFeaturesTest)
 
# print(ActivityData) | omitted 9299 rows ]    | 10299 obs.of 1 variable | $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
# print(SubjectData)  | omitted 9299 rows ]    | 10299 obs.of 1 variable | $ V1: int  1 1 1 1 1 1 1 1 1 1 1 ...
# print(FeaturesData) | omitted 10298 rows ]   | 10299 obs. of  561 variables

# print(FeaturesData) only the first 14 rows below 
#  V1          V2         V3         V4         V5         V6         V7         V8        V9        V10
#  1 0.2885845 -0.02029417 -0.1329051 -0.9952786 -0.9831106 -0.9135264 -0.9951121 -0.9831846 -0.923527 -0.9347238
#  V11        V12       V13       V14       V15        V16        V17       V18        V19        V20
#  1 -0.5673781 -0.7444125 0.8529474 0.6858446 0.8142628 -0.9655228 -0.9999446 -0.999863 -0.9946122 -0.9942308
#  V21      V22        V23        V24        V25       V26        V27       V28         V29       V30
#  1 -0.9876139 -0.94322 -0.4077471 -0.6793375 -0.6021219 0.9292935 -0.8530111 0.3599098 -0.05852638 0.2568915
#  V31       V32         V33       V34        V35      V36        V37       V38       V39       V40
#  1 -0.2248476 0.2641057 -0.09524563 0.2788514 -0.4650846 0.491936 -0.1908836 0.3763139 0.4351292 0.6607903
#  V41        V42       V43        V44        V45       V46        V47        V48        V49       V50
#  1 0.9633961 -0.1408397 0.1153749 -0.9852497 -0.9817084 -0.877625 -0.9850014 -0.9844162 -0.8946774 0.8920545
#  V51       V52       V53        V54        V55       V56       V57        V58        V59        V60
#  1 -0.1612655 0.1246598 0.9774363 -0.1232134 0.05648273 -0.375426 0.8994686 -0.9709052 -0.9755104 -0.9843254
#  V61        V62 V63 V64       V65       V66       V67        V68       V69        V70       V71        V72
#  1 -0.9888491 -0.9177426  -1  -1 0.1138061 -0.590425 0.5911463 -0.5917735 0.5924693 -0.7454488 0.7208617 -0.7123724
#  V73        V74       V75        V76       V77       V78       V79       V80        V81         V82
#  1 0.7113 -0.9951116 0.9956749 -0.9956676 0.9916527 0.5702216 0.4390273 0.9869131 0.07799634 0.005000803
  

                                                                                  ## Codes tested = ok! 
# 1.3.2. Set names to variables
  
  names(ActivityData) <- c("activity")
  names(SubjectData) <- c("subject")
  FeaturesDataNames <- read.table(file.path(path_file, "features.txt"), head=FALSE)
  names(FeaturesData) <- FeaturesDataNames$V2                                    
  FeaturesDataNames
  
  ## FeaturesDataNames |  omitted 61 rows ]  561 obs. of 2 variables 
  ## $ V1: int 1 2 3 4 5 6 7 8 9 10...
  ## $ V2: chr "tBodyAcc-mean()-X"  "tBodyAcc-mean()-y"  "tBodyAcc-mean()-Z"  "tBodyAcc-std()-X"....
                                                                                ## Codes tested = ok! 
  
# 1.3.3. Merge columns to get dataframe Data for all data creating 1 dataset
 
  CombineData <- cbind(ActivityData, SubjectData)
  CombineAllData <- cbind(FeaturesData, CombineData)  
  CombineAllData
  
  ## CombineData omitted 9799 rows ]    | $ activity: int 5 5 5 5 5 5 5 5 5 5 ...
  ##                                    | $ activity: int 1 1 1 1 1 1 1 1 1 1 ...
  
  ## CombineAllData omitted 10298 rows ]| printed only the head
#  tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z
#  1         0.2885845       -0.02029417        -0.1329051       -0.9952786       -0.9831106       -0.9135264
#  tBodyAcc-mad()-X tBodyAcc-mad()-Y tBodyAcc-mad()-Z tBodyAcc-max()-X tBodyAcc-max()-Y tBodyAcc-max()-Z
#  1       -0.9951121       -0.9831846        -0.923527       -0.9347238       -0.5673781       -0.7444125
#  tBodyAcc-min()-X tBodyAcc-min()-Y tBodyAcc-min()-Z tBodyAcc-sma() tBodyAcc-energy()-X tBodyAcc-energy()-Y
#  1        0.8529474        0.6858446        0.8142628     -0.9655228          -0.9999446           -0.999863
#  tBodyAcc-energy()-Z tBodyAcc-iqr()-X tBodyAcc-iqr()-Y tBodyAcc-iqr()-Z tBodyAcc-entropy()-X
#  1          -0.9946122       -0.9942308       -0.9876139         -0.94322           -0.4077471
#  tBodyAcc-entropy()-Y tBodyAcc-entropy()-Z tBodyAcc-arCoeff()-X,1 tBodyAcc-arCoeff()-X,2
#  1           -0.6793375           -0.6021219              0.9292935             -0.8530111

                                                                                ## Codes tested = ok! 
          #**********************************************************#
          #   All Codes tested for step 1: 1.1, 1.2, 1.3 = all ok!   #  
          #**********************************************************#

#*******************************************************************************  
#                                  Step 2
#            2.1. Extracts only the measurements on the mean and 
#                   standard deviation for each measurement
#
#*******************************************************************************
  
# 2.1.1. Subset Name of Features by measurements on the mean and standard deviation
#        i.e taken Names of Features with “mean()” or “std()” 
  
  SubsetFeaturesDataNames <- FeaturesDataNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesDataNames$V2)]
  SubsetFeaturesDataNames
  
  
#  SubsetFeaturesDataNames
#  [1]  "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"          
#  [4]  "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
#  [7]  "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"       
#  [10] "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
#  [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
#  [16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
#  [19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"         
#  [22] "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
#  [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"     
#  [28] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
#  [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"      
#  [34] "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
#  [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"    
#  [40] "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
#  [43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
#  [46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
#  [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"       
#  [52] "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
#  [55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
#  [58] "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
#  [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"    
#  [64] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
                                                                                ## Codes tested = ok!    
###--------------------------------------------------------------------------------------------------###  

# 2.1.2. Subset the dataframe Data by selected names of Features
  
  SelectedNames <- c(as.character(SubsetFeaturesDataNames), "subject", "activity")
  CombineAllData <- subset(CombineAllData, select = SelectedNames) 
  View(CombineAllData)                                                                    ## Codes tested = ok! 

# 2.1.3. Check the structures of the dataframe Data
  
  str(CombineAllData)                                                                     ## Code tested = ok! 

  
#  >  str(CombineAllData)   
#  'data.frame':	10299 obs. of  68 variables:
#  $ tBodyAcc-mean()-X          : num   0.289   0.278   0.28      0.279    0.277 ...
#  $ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195   -0.0262  -0.0166 ...
#  $ tBodyAcc-mean()-Z          : num  -0.133  -0.124  -0.113    -0.123   -0.115 ...
#  $ tBodyAcc-std()-X           : num  -0.995  -0.998  -0.995    -0.996   -0.998 ...
#  $ tBodyAcc-std()-Y           : num  -0.983  -0.975  -0.967    -0.983   -0.981 ...
#  $ tBodyAcc-std()-Z           : num  -0.914  -0.96   -0.979    -0.991   -0.99 ...
#  $ tGravityAcc-mean()-X       : num   0.963   0.967   0.967     0.968    0.968 ...
#  $ tGravityAcc-mean()-Y       : num  -0.141  -0.142  -0.142    -0.144   -0.149 ...
#  $ tGravityAcc-mean()-Z       : num   0.1154  0.1094  0.1019    0.0999   0.0945 ...
#  $ tGravityAcc-std()-X        : num  -0.985  -0.997  -1        -0.997   -0.998    ...
#  $ tGravityAcc-std()-Y        : num  -0.982  -0.989  -0.993    -0.981   -0.988 ...
#  $ tGravityAcc-std()-Z        : num  -0.878  -0.932  -0.993    -0.978   -0.979 ...
#  $ tBodyAccJerk-mean()-X      : num   0.078   0.074   0.0736    0.0773   0.0734 ...
#  $ tBodyAccJerk-mean()-Y      : num   0.005   0.00577 0.0031    0.02006  0.01912 ...
#  $ tBodyAccJerk-mean()-Z      : num  -0.06783 0.02938 -0.00905 -0.00986  0.01678 ...
#  $ tBodyAccJerk-std()-X       : num  -0.994  -0.996  -0.991    -0.993   -0.996 ...
#  $ tBodyAccJerk-std()-Y       : num  -0.988  -0.981  -0.981    -0.988   -0.988 ...
#  $ tBodyAccJerk-std()-Z       : num  -0.994  -0.992  -0.99     -0.993   -0.992 ...
#  $ tBodyGyro-mean()-X         : num  -0.0061 -0.0161 -0.0317   -0.0434  -0.034 ...
#  $ tBodyGyro-mean()-Y         : num  -0.0314 -0.0839 -0.1023   -0.0914  -0.0747 ...
#  $ tBodyGyro-mean()-Z         : num   0.1077  0.1006  0.0961    0.0855   0.0774 ...
#  $ tBodyGyro-std()-X          : num  -0.985  -0.983  -0.976    -0.991   -0.985 ...
#  $ tBodyGyro-std()-Y          : num  -0.977  -0.989  -0.994    -0.992   -0.992 ...
#  $ tBodyGyro-std()-Z          : num  -0.992  -0.989  -0.986    -0.988   -0.987 ...
#  $ tBodyGyroJerk-mean()-X     : num  -0.0992 -0.1105 -0.1085   -0.0912  -0.0908 ...
#  $ tBodyGyroJerk-mean()-Y     : num  -0.0555 -0.0448 -0.0424   -0.0363  -0.0376 ...
#  $ tBodyGyroJerk-mean()-Z     : num  -0.062  -0.0592 -0.0558   -0.0605  -0.0583 ...
#  $ tBodyGyroJerk-std()-X      : num  -0.992  -0.99   -0.988    -0.991   -0.991 ...
#  $ tBodyGyroJerk-std()-Y      : num  -0.993  -0.997  -0.996    -0.997   -0.996 ...
#  $ tBodyGyroJerk-std()-Z      : num  -0.992  -0.994  -0.992    -0.993   -0.995 ...
#  $ tBodyAccMag-mean()         : num  -0.959  -0.979  -0.984    -0.987   -0.993 ...
#  $ tBodyAccMag-std()          : num  -0.951  -0.976  -0.988    -0.986   -0.991 ...
#  $ tGravityAccMag-mean()      : num  -0.959  -0.979  -0.984    -0.987   -0.993 ...
#  $ tGravityAccMag-std()       : num  -0.951  -0.976  -0.988    -0.986   -0.991 ...
#  $ tBodyAccJerkMag-mean()     : num  -0.993  -0.991  -0.989    -0.993   -0.993 ...
#  $ tBodyAccJerkMag-std()      : num  -0.994  -0.992  -0.99     -0.993   -0.996 ...
#  $ tBodyGyroMag-mean()        : num  -0.969  -0.981  -0.976    -0.982   -0.985 ...
#  $ tBodyGyroMag-std()         : num  -0.964  -0.984  -0.986    -0.987   -0.989 ...
#  $ tBodyGyroJerkMag-mean()    : num  -0.994  -0.995  -0.993    -0.996   -0.996 ...
#  $ tBodyGyroJerkMag-std()     : num  -0.991  -0.996  -0.995    -0.995   -0.995 ...
#  $ fBodyAcc-mean()-X          : num  -0.995  -0.997  -0.994    -0.995   -0.997 ...
#  $ fBodyAcc-mean()-Y          : num  -0.983  -0.977  -0.973    -0.984   -0.982 ...
#  $ fBodyAcc-mean()-Z          : num  -0.939  -0.974  -0.983    -0.991   -0.988 ...
#  $ fBodyAcc-std()-X           : num  -0.995  -0.999  -0.996    -0.996   -0.999 ...
#  $ fBodyAcc-std()-Y           : num  -0.983  -0.975  -0.966    -0.983   -0.98 ...
#  $ fBodyAcc-std()-Z           : num  -0.906  -0.955  -0.977    -0.99    -0.992 ...
#  $ fBodyAccJerk-mean()-X      : num  -0.992  -0.995  -0.991    -0.994   -0.996 ...
#  $ fBodyAccJerk-mean()-Y      : num  -0.987  -0.981  -0.982    -0.989   -0.989 ...
#  $ fBodyAccJerk-mean()-Z      : num  -0.99   -0.99   -0.988    -0.991   -0.991 ...
#  $ fBodyAccJerk-std()-X       : num  -0.996  -0.997  -0.991    -0.991   -0.997 ...
#  $ fBodyAccJerk-std()-Y       : num  -0.991  -0.982  -0.981    -0.987   -0.989 ...
#  $ fBodyAccJerk-std()-Z       : num  -0.997  -0.993  -0.99     -0.994   -0.993 ...
#  $ fBodyGyro-mean()-X         : num  -0.987  -0.977  -0.975    -0.987   -0.982 ...
#  $ fBodyGyro-mean()-Y         : num  -0.982  -0.993  -0.994    -0.994   -0.993 ...
#  $ fBodyGyro-mean()-Z         : num  -0.99   -0.99   -0.987    -0.987   -0.989 ...
#  $ fBodyGyro-std()-X          : num  -0.985  -0.985  -0.977    -0.993   -0.986 ...
#  $ fBodyGyro-std()-Y          : num  -0.974  -0.987  -0.993    -0.992   -0.992 ...
#  $ fBodyGyro-std()-Z          : num  -0.994  -0.99   -0.987    -0.989   -0.988 ...
#  $ fBodyAccMag-mean()         : num  -0.952  -0.981  -0.988    -0.988   -0.994 ...
#  $ fBodyAccMag-std()          : num  -0.956  -0.976  -0.989    -0.987   -0.99 ...
#  $ fBodyBodyAccJerkMag-mean() : num  -0.994  -0.99   -0.989    -0.993   -0.996 ...
#  $ fBodyBodyAccJerkMag-std()  : num  -0.994  -0.992  -0.991    -0.992   -0.994 ...
#  $ fBodyBodyGyroMag-mean()    : num  -0.98   -0.988  -0.989    -0.989   -0.991 ...
#  $ fBodyBodyGyroMag-std()     : num  -0.961  -0.983  -0.986    -0.988   -0.989 ...
#  $ fBodyBodyGyroJerkMag-mean(): num  -0.992  -0.996  -0.995    -0.995   -0.995 ...
#  $ fBodyBodyGyroJerkMag-std() : num  -0.991  -0.996  -0.995    -0.995   -0.995 ...
#  $ subject                    : int  1 1 1 1 1 1 1 1 1 1 ...
#  $ activity                   : int  5 5 5 5 5 5 5 5 5 5 ...
  
                                                                                 ## Codes tested = ok! 
        #*************************************************************#
        # All Codes tested for step 2: 2.1.1, 2.1.2, 2.1.3 = all ok!  #  
        #*************************************************************#
 
      
#*******************************************************************************  
#                                  Step 3
#   3.1 Uses descriptive activity names to name the activities in the data set
#
#*******************************************************************************
  
# 3.1.1. Read descriptive activity names from “activity_labels.txt”
  
  activityLabels <- read.table(file.path(path_file, "activity_labels.txt"), header = FALSE) 
  activityLabels

#  > activityLabels | $ v1: int 1  2 3 4 5 6
#                   | $ v2: chr "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" "STANDING" "LAYING"
  
#  V1                 V2
#  1  1            WALKING
#  2  2   WALKING_UPSTAIRS
#  3  3 WALKING_DOWNSTAIRS
#  4  4            SITTING
#  5  5           STANDING
#  6  6             LAYING
  
 
    
# 3.1.2. factorize Variable activity in the data frame Data using descriptive activity names
# 3.1.3. check
  
  head(CombineAllData$activity,30)
  
 ##  [1] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4                                                                               ## Codes tested = ok!  

  
                                                                                ## Codes tested = ok! 
        #*************************************************************#
        # All Codes tested for step 3: 3.1.1, 3.1.2, 3.1.3 = all ok!  #  
        #*************************************************************#
        
  
#*******************************************************************************  
#                                   Step 4
#    4.1. Appropriately labels the data set with descriptive variable names
#  
#*******************************************************************************

# 4.1.1. In the former part, variables activity and subject and names of the
#        activities have been labelled using descriptive names.
#        In this part, Names of Features will labelled using descriptive variable names.
  
#  Acc        is replaced by  Accelerometer
#  Gyro       is replaced by  Gyroscope
#  Mag        is replaced by  Magnitude
#  BodyBody   is replaced by  Body
#  prefix ^f  is replaced by  Frequency
#  prefix ^t  is replaced by  Time
#  tBody      is replaced by  TimeBody 
#  -mean()    is replaced by  Mean
#  -std()     is replaced by  STD 
#  -freq()    is replaced by  Frequency 
#  angle      is replaced by  Angle
#  gravity    is replaced by  Gravity
  
  names(CombineAllData) <- gsub("Acc", "Accelerometer", names(CombineAllData))
  names(CombineAllData) <- gsub("Gyro", "Gyroscope", names(CombineAllData))
  names(CombineAllData) <- gsub("Mag", "Magnitude", names(CombineAllData))
  names(CombineAllData) <- gsub("BodyBody", "Body", names(CombineAllData))
  names(CombineAllData) <- gsub("^f", "Frequency", names(CombineAllData))
  names(CombineAllData) <- gsub("^t", "Time", names(CombineAllData))
  names(CombineAllData) <- gsub("tBody", "TimeBody", names(CombineAllData))
  names(CombineAllData) <- gsub("-mean()", "Mean", names(CombineAllData), ignore.case = TRUE)
  names(CombineAllData) <- gsub("-std()", "STD", names(CombineAllData), ignore.case = TRUE)
  names(CombineAllData) <- gsub("-freq()", "Frequency", names(CombineAllData), ignore.case = TRUE)
  names(CombineAllData) <- gsub("angle", "Angle", names(CombineAllData))
  names(CombineAllData) <- gsub("gravity", "Gravity", names(CombineAllData))

  # 4.1.2. Check
  names(CombineAllData)
  
  
#  > names(CombineAllData)
#  [1] "TimeBodyAccelerometerMean()-X"                 "TimeBodyAccelerometerMean()-Y"                
#  [3] "TimeBodyAccelerometerMean()-Z"                 "TimeBodyAccelerometerSTD()-X"                 
#  [5] "TimeBodyAccelerometerSTD()-Y"                  "TimeBodyAccelerometerSTD()-Z"                 
#  [7] "TimeGravityAccelerometerMean()-X"              "TimeGravityAccelerometerMean()-Y"             
#  [9] "TimeGravityAccelerometerMean()-Z"              "TimeGravityAccelerometerSTD()-X"              
#  [11] "TimeGravityAccelerometerSTD()-Y"               "TimeGravityAccelerometerSTD()-Z"              
#  [13] "TimeBodyAccelerometerJerkMean()-X"             "TimeBodyAccelerometerJerkMean()-Y"            
#  [15] "TimeBodyAccelerometerJerkMean()-Z"             "TimeBodyAccelerometerJerkSTD()-X"             
#  [17] "TimeBodyAccelerometerJerkSTD()-Y"              "TimeBodyAccelerometerJerkSTD()-Z"             
#  [19] "TimeBodyGyroscopeMean()-X"                     "TimeBodyGyroscopeMean()-Y"                    
#  [21] "TimeBodyGyroscopeMean()-Z"                     "TimeBodyGyroscopeSTD()-X"                     
#  [23] "TimeBodyGyroscopeSTD()-Y"                      "TimeBodyGyroscopeSTD()-Z"                     
#  [25] "TimeBodyGyroscopeJerkMean()-X"                 "TimeBodyGyroscopeJerkMean()-Y"                
#  [27] "TimeBodyGyroscopeJerkMean()-Z"                 "TimeBodyGyroscopeJerkSTD()-X"                 
#  [29] "TimeBodyGyroscopeJerkSTD()-Y"                  "TimeBodyGyroscopeJerkSTD()-Z"                 
#  [31] "TimeBodyAccelerometerMagnitudeMean()"          "TimeBodyAccelerometerMagnitudeSTD()"          
#  [33] "TimeGravityAccelerometerMagnitudeMean()"       "TimeGravityAccelerometerMagnitudeSTD()"       
#  [35] "TimeBodyAccelerometerJerkMagnitudeMean()"      "TimeBodyAccelerometerJerkMagnitudeSTD()"      
#  [37] "TimeBodyGyroscopeMagnitudeMean()"              "TimeBodyGyroscopeMagnitudeSTD()"              
#  [39] "TimeBodyGyroscopeJerkMagnitudeMean()"          "TimeBodyGyroscopeJerkMagnitudeSTD()"          
#  [41] "FrequencyBodyAccelerometerMean()-X"            "FrequencyBodyAccelerometerMean()-Y"           
#  [43] "FrequencyBodyAccelerometerMean()-Z"            "FrequencyBodyAccelerometerSTD()-X"            
#  [45] "FrequencyBodyAccelerometerSTD()-Y"             "FrequencyBodyAccelerometerSTD()-Z"            
#  [47] "FrequencyBodyAccelerometerJerkMean()-X"        "FrequencyBodyAccelerometerJerkMean()-Y"       
#  [49] "FrequencyBodyAccelerometerJerkMean()-Z"        "FrequencyBodyAccelerometerJerkSTD()-X"        
#  [51] "FrequencyBodyAccelerometerJerkSTD()-Y"         "FrequencyBodyAccelerometerJerkSTD()-Z"        
#  [53] "FrequencyBodyGyroscopeMean()-X"                "FrequencyBodyGyroscopeMean()-Y"               
#  [55] "FrequencyBodyGyroscopeMean()-Z"                "FrequencyBodyGyroscopeSTD()-X"                
#  [57] "FrequencyBodyGyroscopeSTD()-Y"                 "FrequencyBodyGyroscopeSTD()-Z"                
#  [59] "FrequencyBodyAccelerometerMagnitudeMean()"     "FrequencyBodyAccelerometerMagnitudeSTD()"     
#  [61] "FrequencyBodyAccelerometerJerkMagnitudeMean()" "FrequencyBodyAccelerometerJerkMagnitudeSTD()" 
#  [63] "FrequencyBodyGyroscopeMagnitudeMean()"         "FrequencyBodyGyroscopeMagnitudeSTD()"         
#  [65] "FrequencyBodyGyroscopeJerkMagnitudeMean()"     "FrequencyBodyGyroscopeJerkMagnitudeSTD()"     
#  [67] "subject"                                       "activity"   
###---------------------------------------------------------------------------------------------------###  
  
                                                                                ## Codes tested = ok! 
        #*******************************************************#
        #  All Codes tested for step 4: 4.1.1, 4.1.2 = all ok!  #  
        #*******************************************************#

                                                                                
 
#*******************************************************************************  
#                                Step 5
# 5.1. From the data set in step 4, create a second, independent tidy data set 
#      with the average of each variable for each activity and each subject.
#       
#*******************************************************************************
  
# 5.1.1. Creates a second,independent tidy data set and output it.
  
  # In the former part, variables activity, subject and the activities names
  # have been labelled using descriptive names.
  # In this part, Features names will be labelled using descriptive variable names.
  
  library(plyr);                                                                ## plyr version 1.8.8
  TidyData2 <- aggregate(. ~subject + activity, CombineAllData, mean)
  TidyData2 <- TidyData2[order(TidyData2$subject, TidyData2$activity),]
  str(TidyData2)
  
# 5.1.2.  Writing second tidy data set in txt file
  write.table(TidyData2, file = "tidydata.txt", row.name = FALSE)
  
  
#  > str(TidyData2)
#  'data.frame':	180 obs. of  68 variables:
#    $ subject                                    : int  1 1 1 1 1 1 2 2 2 2 ...
#  $ activity                                     : int  1 2 3 4 5 6 1 2 3 4 ...
#  $ TimeBodyAccelerometerMean()-X                : num   0.277   0.255      0.289     0.261     0.279 ...
#  $ TimeBodyAccelerometerMean()-Y                : num  -0.01738 -0.02395  -0.00992  -0.00131  -0.01614 ...
#  $ TimeBodyAccelerometerMean()-Z                : num  -0.1111  -0.0973   -0.1076   -0.1045   -0.1106 ...
#  $ TimeBodyAccelerometerSTD()-X                 : num  -0.284   -0.355     0.03     -0.977    -0.996 ...
#  $ TimeBodyAccelerometerSTD()-Y                 : num   0.11446 -0.00232  -0.03194  -0.92262  -0.97319 ...
#  $ TimeBodyAccelerometerSTD()-Z                 : num  -0.26    -0.0195   -0.2304   -0.9396   -0.9798 ...
#  $ TimeGravityAccelerometerMean()-X             : num   0.935    0.893     0.932     0.832     0.943 ...
#  $ TimeGravityAccelerometerMean()-Y             : num  -0.282   -0.362    -0.267     0.204    -0.273 ...
#  $ TimeGravityAccelerometerMean()-Z             : num  -0.0681  -0.0754   -0.0621    0.332     0.0135 ...
#  $ TimeGravityAccelerometerSTD()-X              : num  -0.977   -0.956    -0.951    -0.968    -0.994 ...
#  $ TimeGravityAccelerometerSTD()-Y              : num  -0.971   -0.953    -0.937    -0.936    -0.981 ...
#  $ TimeGravityAccelerometerSTD()-Z              : num  -0.948   -0.912    -0.896    -0.949    -0.976 ...
#  $ TimeBodyAccelerometerJerkMean()-X            : num   0.074    0.1014    0.0542    0.0775    0.0754 ...
#  $ TimeBodyAccelerometerJerkMean()-Y            : num   0.028272 0.019486  0.02965  -0.000619  0.007976 ...
#  $ TimeBodyAccelerometerJerkMean()-Z            : num  -0.00417 -0.04556  -0.01097  -0.00337  -0.00369 ...
#  $ TimeBodyAccelerometerJerkSTD()-X             : num  -0.1136  -0.4468   -0.0123   -0.9864   -0.9946 ...
#  $ TimeBodyAccelerometerJerkSTD()-Y             : num   0.067   -0.378    -0.102    -0.981    -0.986 ...
#  $ TimeBodyAccelerometerJerkSTD()-Z             : num  -0.503   -0.707    -0.346    -0.988    -0.992 ...
#  $ TimeBodyGyroscopeMean()-X                    : num  -0.0418   0.0505   -0.0351   -0.0454   -0.024 ...
#  $ TimeBodyGyroscopeMean()-Y                    : num  -0.0695  -0.1662   -0.0909   -0.0919   -0.0594 ...
#  $ TimeBodyGyroscopeMean()-Z                    : num   0.0849   0.0584    0.0901    0.0629    0.0748 ...
#  $ TimeBodyGyroscopeSTD()-X                     : num  -0.474   -0.545    -0.458    -0.977    -0.987 ...
#  $ TimeBodyGyroscopeSTD()-Y                     : num  -0.05461  0.00411  -0.12635  -0.96647  -0.98773 ...
#  $ TimeBodyGyroscopeSTD()-Z                     : num  -0.344   -0.507    -0.125    -0.941    -0.981 ...
#  $ TimeBodyGyroscopeJerkMean()-X                : num  -0.09    -0.1222   -0.074    -0.0937   -0.0996 ...
#  $ TimeBodyGyroscopeJerkMean()-Y                : num  -0.0398  -0.0421   -0.044    -0.0402   -0.0441 ...
#  $ TimeBodyGyroscopeJerkMean()-Z                : num  -0.0461  -0.0407   -0.027    -0.0467   -0.049 ...
#  $ TimeBodyGyroscopeJerkSTD()-X                 : num  -0.207   -0.615    -0.487    -0.992    -0.993 ...
#  $ TimeBodyGyroscopeJerkSTD()-Y                 : num  -0.304   -0.602    -0.239    -0.99     -0.995 ...
#  $ TimeBodyGyroscopeJerkSTD()-Z                 : num  -0.404   -0.606    -0.269    -0.988    -0.992 ...
#  $ TimeBodyAccelerometerMagnitudeMean()         : num  -0.137   -0.1299    0.0272   -0.9485   -0.9843 ...
#  $ TimeBodyAccelerometerMagnitudeSTD()          : num  -0.2197  -0.325     0.0199   -0.9271   -0.9819 ...
#  $ TimeGravityAccelerometerMagnitudeMean()      : num  -0.137   -0.1299    0.0272   -0.9485   -0.9843 ...
#  $ TimeGravityAccelerometerMagnitudeSTD()       : num  -0.2197  -0.325     0.0199   -0.9271   -0.9819 ...
#  $ TimeBodyAccelerometerJerkMagnitudeMean()     : num  -0.1414  -0.4665   -0.0894   -0.9874   -0.9924 ...
#  $ TimeBodyAccelerometerJerkMagnitudeSTD()      : num  -0.0745  -0.479    -0.0258   -0.9841   -0.9931 ...
#  $ TimeBodyGyroscopeMagnitudeMean()             : num  -0.161   -0.1267   -0.0757   -0.9309   -0.9765 ...
#  $ TimeBodyGyroscopeMagnitudeSTD()              : num  -0.187   -0.149    -0.226    -0.935    -0.979 ...
#  $ TimeBodyGyroscopeJerkMagnitudeMean()         : num  -0.299   -0.595    -0.295    -0.992    -0.995 ...
#  $ TimeBodyGyroscopeJerkMagnitudeSTD()          : num  -0.325   -0.649    -0.307    -0.988    -0.995 ...
#  $ FrequencyBodyAccelerometerMean()-X           : num  -0.2028  -0.4043    0.0382   -0.9796   -0.9952 ...
#  $ FrequencyBodyAccelerometerMean()-Y           : num   0.08971 -0.19098   0.00155  -0.94408  -0.97707 ...
#  $ FrequencyBodyAccelerometerMean()-Z           : num  -0.332   -0.433    -0.226    -0.959    -0.985 ...
#  $ FrequencyBodyAccelerometerSTD()-X            : num  -0.3191  -0.3374    0.0243   -0.9764   -0.996 ...
#  $ FrequencyBodyAccelerometerSTD()-Y            : num   0.056    0.0218   -0.113    -0.9173   -0.9723 ...
#  $ FrequencyBodyAccelerometerSTD()-Z            : num  -0.28     0.086    -0.298    -0.934    -0.978 ...
#  $ FrequencyBodyAccelerometerJerkMean()-X       : num  -0.1705  -0.4799   -0.0277   -0.9866   -0.9946 ...
#  $ FrequencyBodyAccelerometerJerkMean()-Y       : num  -0.0352  -0.4134   -0.1287   -0.9816   -0.9854 ...
#  $ FrequencyBodyAccelerometerJerkMean()-Z       : num  -0.469   -0.685    -0.288    -0.986    -0.991 ...
#  $ FrequencyBodyAccelerometerJerkSTD()-X        : num  -0.1336  -0.4619   -0.0863   -0.9875   -0.9951 ...
#  $ FrequencyBodyAccelerometerJerkSTD()-Y        : num   0.107   -0.382    -0.135    -0.983    -0.987 ...
#  $ FrequencyBodyAccelerometerJerkSTD()-Z        : num  -0.535   -0.726    -0.402    -0.988    -0.992 ...
#  $ FrequencyBodyGyroscopeMean()-X               : num  -0.339   -0.493    -0.352    -0.976    -0.986 ...
#  $ FrequencyBodyGyroscopeMean()-Y               : num  -0.1031  -0.3195   -0.0557   -0.9758   -0.989 ...
#  $ FrequencyBodyGyroscopeMean()-Z               : num  -0.2559  -0.4536   -0.0319   -0.9513   -0.9808 ...
#  $ FrequencyBodyGyroscopeSTD()-X                : num  -0.517   -0.566    -0.495    -0.978    -0.987 ...
#  $ FrequencyBodyGyroscopeSTD()-Y                : num  -0.0335   0.1515   -0.1814   -0.9623   -0.9871 ...
#  $ FrequencyBodyGyroscopeSTD()-Z                : num  -0.437   -0.572    -0.238    -0.944    -0.982 ...
#  $ FrequencyBodyAccelerometerMagnitudeMean()    : num  -0.1286  -0.3524    0.0966   -0.9478   -0.9854 ...
#  $ FrequencyBodyAccelerometerMagnitudeSTD()     : num  -0.398   -0.416    -0.187    -0.928    -0.982 ...
#  $ FrequencyBodyAccelerometerJerkMagnitudeMean(): num  -0.0571  -0.4427    0.0262   -0.9853   -0.9925 ...
#  $ FrequencyBodyAccelerometerJerkMagnitudeSTD() : num  -0.103   -0.533    -0.104    -0.982    -0.993 ...
#  $ FrequencyBodyGyroscopeMagnitudeMean()        : num  -0.199   -0.326    -0.186    -0.958    -0.985 ...
#  $ FrequencyBodyGyroscopeMagnitudeSTD()         : num  -0.321   -0.183    -0.398    -0.932    -0.978 ...
#  $ FrequencyBodyGyroscopeJerkMagnitudeMean()    : num  -0.319   -0.635    -0.282    -0.99     -0.995 ...
#  $ FrequencyBodyGyroscopeJerkMagnitudeSTD()     : num  -0.382   -0.694    -0.392    -0.987    -0.995 ...  
 
  

  


  
#********************************* THE END *************************************
  
  
  
## You will be required to submit: 
#    1) a tidy data set, 
#    2) a link to a Github repository with your script for performing the analysis, and 
#    3) a code book that describes the variables, the data, and any transformations 
#       or work that you performed to clean up the data called CodeBook.md.
#       You should also include a README.md in the repo with your scripts. 
#       This repo explains how all of the scripts work and how they are connected.
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
