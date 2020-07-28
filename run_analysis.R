library(plyr)

if(!file.exists("./Week4Project")){dir.create("./Week4Project")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./Week4Project/Week4ProjectData.zip")

unzip(zipfile = "./Week4Project/Week4ProjectData.zip", exdir = "./Week4Project")

x_train <- read.table("./Week4Project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Week4Project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Week4Project/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./Week4Project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Week4Project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Week4Project/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./Week4Project/UCI HAR Dataset/features.txt")

activity_labels = read.table("./Week4Project/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")

alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
complete_dataset <- rbind(alltrain, alltest)


colNames <- colnames(complete_dataset)

mean_and_std <- (grepl("activityID", colNames) |
                   grepl("subjectID", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

set_for_mean_and_std <- complete_dataset[ , mean_and_std == TRUE]

set_with_activity_names <- merge(set_for_mean_and_std, activity_labels,
                              by = "activityID",
                              all.x = TRUE)

tidy_data <- aggregate(. ~subjectID + activityID, set_with_activity_names, mean)
tidy_data <- tidy_data[order(tidy_data$subjectID, tidy_data$activityID), ]

write.table(tidy_data, "tidy_data.txt", row.names = FALSE)