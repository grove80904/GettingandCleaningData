olddir <- getwd()
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (file.exists("coursera.zip") == FALSE) {download.file(file, "coursera.zip")}
unzip("coursera.zip", list = FALSE) #unzip the file
setwd("./UCI HAR Dataset")
xnames <- read.table("features.txt", stringsAsFactors = FALSE) #Read in the x columns names
xnames <- xnames[,2] #remove the first column of column index numbers
activitylabels <- read.table("activity_labels.txt", sep = "", stringsAsFactors = FALSE) #Read in the activity names

#Read in all train files
setwd("./train")
xtrain <- read.table("x_train.txt")
names(xtrain) <- xnames
ytrain <- read.table("y_train.txt")
ytrain <- merge(ytrain, activitylabels) #Add descriptive activity names
ytrain <- ytrain[,2] #remove the numeric representation of activities and only leave the descriptive names
subjecttrain <- read.table("subject_train.txt") #Read in subject data

#Read in all test files
setwd("../test")
xtest <- read.table("x_test.txt")
names(xtest) <- xnames
ytest <- read.table("y_test.txt")
ytest <- merge(ytest, activitylabels) #Add descriptive activity names
ytest <- ytest[,2] #remove the numeric representation of activities and only leave the descriptive names
subjecttest <- read.table("subject_test.txt") #Read in subject data

#Combine and manipulate data
setwd(olddir)
alltraindata <- cbind(subjecttrain, ytrain, xtrain) #Combine subject, activity and raw data
alltestdata <- cbind(subjecttest, ytest, xtest) #Combine subject, activity and raw data
names(alltraindata)[1] <- "subject" #Add descriptive variable name to the first column
names(alltraindata)[2] <- "activity" #Add descriptive variable name to the second column
names(alltestdata)[1] <- "subject" #Add descriptive variable name to the first column
names(alltestdata)[2] <- "activity" #Add descriptive variable name to the second column
alldata <- rbind(alltraindata, alltestdata) #Combine train and test data into one data table
meancolumns <- grep("mean", names(alldata), ignore.case = TRUE) #extract column numbers related to means
stdcolumns <- grep("std", names(alldata), ignore.case = TRUE) #extract column numbers related to std
columnstouse <- c(1, 2, meancolumns,stdcolumns) #Create variable for all necessary columns including "subject" and "activity"
meanandstddata <- alldata[, columnstouse] #Subset data to only the desired columns

library(dplyr)
meanandstddata1 <- tbl_df(meanandstddata) #Convert the data frame to a local data frame
summarydata <- meanandstddata1 %>% #Calculate the mean for each column and save to a data frame
                        group_by(activity, subject) %>%
                        summarise_each(funs(mean))

write.table(summarydata, "tidydata.txt", row.names = FALSE) #Write the final answer to a text file
