## reading the downloaded files
training_x <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/train/X_train.txt", col.names = features$functions)
training_y <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/train/Y_train.txt",  col.names = "code")
taining_subject <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/train/subject_train.txt", col.names = "subject")
test_x <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/test/X_test.txt", col.names = features$functions)
test_y <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/test/Y_test.txt",  col.names = "code")
test_subject <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/test/subject_test.txt", col.names = "subject")
activities <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project//activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("/Users/b.w.h/Documents/R/Coursera/Getting and Cleaning data/Project/features.txt", col.names = c("n","functions"))

## merging the data
x <- rbind(training_x, test_x)
y <- rbind(training_y, test_y)
subjects <- rbind(taining_subject, test_subject)
merged <- cbind(x, y, subjects)

## extracting the mean and standard deviation
TidyData <- merged %>% select(subject, code, contains("mean"), contains("std"))

## useing descriptive activity names to name the activities in the data set
TidyData$code <- activities[TidyData$code, 2]

## labeling the data set with descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## creating another tidy data set with the average of each variable for each activity and each subject
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

