setwd("~/UCI HAR Dataset/")
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"FQuiz.zip")
unzip("FQuiz.zip")
setwd("~/UCI HAR Dataset/")
P<-"~/UCI HAR Dataset/"
library(dplyr)
activity_label<-read.table("activity_labels.txt")
act_label<-activity_label[,2]


# Extracts only the measurements on the mean and standard deviation for each measurement.
features<-read.table("features.txt")
features<-as.character(features[,2])
feature_extract<- grep("mean|std",features)
feature_extract2<-features[feature_extract]

testP<-paste0(P,"/test/")
setwd(testP)
subject_test<-read.table("subject_test.txt")
x_test<-read.table("X_test.txt",sep="")[,feature_extract]
y_test<-read.table("y_test.txt")
label_test<-as.character(y_test[,1])
test_all<-cbind(subject_test,label_test,x_test)
test_all<-setNames(test_all,c("subject","activity",feature_extract2))
test_all$status<-"test"

trainP<-paste0(P,"/train/")
setwd(trainP)
subject_train<-read.table("subject_train.txt")
x_train<-read.table("X_train.txt",sep="")[,feature_extract]
y_train<-read.table("y_train.txt")
label_train<-as.character(y_train[,1])
train_all<-cbind(subject_train,label_train,x_train)

# Appropriately labels the data set with descriptive variable names.
train_all<-setNames(train_all,c("subject","activity",feature_extract2))
train_all$status<-"train"

# Merges the training and the test sets to create one data set.
combined_results<-rbind(train_all,test_all)

# Uses descriptive activity names to name the activities in the data set
combined_results$activity<-factor(combined_results$activity,labels=act_label)
combined_results2<-select(combined_results,-status)

library(reshape2)
#  creates a second, independent tidy data set with the average of each variable for each activity and each subject.
cmb<-melt(combined_results2,id=c("subject","activity"))
tidy_results<-dcast(cmb, subject + activity ~ variable , mean)

write.table(tidy_results,"tidy_results.txt",row.names=F)

