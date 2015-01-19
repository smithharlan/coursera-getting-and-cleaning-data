# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)

# Download and unzip files

# Download file to data directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "getdata-projectfiles-UCI HAR Dataset.zip"
download.file(fileUrl, destfile = fileName, method = "curl")

# Unzip file to local directory
unzip(fileName)

# Load column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement
extractFeatures <- (grepl("mean|std", features))

# Load activity labels
activityLabels <- read.table("./UCI Har Dataset/activity_labels.txt")[,2]

# Load training data
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Apply variable names
names(xTrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement
xTrain = xTrain[,extractFeatures]

# Apply activity labels to training data set
yTrain[,2] = activityLabels[yTrain[,1]]
names(yTrain) = c("Activity_ID", "Activity_Label")
names(subjectTrain) = "subject"

# Bind training data
trainData <- cbind(subjectTrain, yTrain, xTrain)

# Load test data
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Apply variable names
names(xTest) = features

# Extract only the measurements on the mean and standard deviation for each measurement
xTest = xTest[,extractFeatures]

# Apply activity labels to Testing data set
yTest[,2] = activityLabels[yTest[,1]]
names(yTest) = c("Activity_ID", "Activity_Label")
names(subjectTest) = "subject"

# Bind Testing data
testData <- cbind(subjectTest, yTest, xTest)

# Merge the training and the test sets to create one data set.
data = as.data.table(rbind(testData, trainData))

# From the data set in step 4, create a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
tidyData = aggregate(data, by=list(activity = data$Activity_Label, subject=data$subject), mean)

write.table(tidyData, file = "./tidy_data.txt")
