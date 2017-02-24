

##The Samsung data should be unzipped and in the working directory

##Reads in the relevant activity, subject and features files
ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

##Merges the test and train files for activity, subject and features
Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

##Sets names for the merged subject and activity datasets
names(Subject)<-c("subject")
names(Activity)<- c("activity")

##Sets names for features dataset
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

##Combine datasets using column bind
Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

##Extract the mean and standard deviation fields
ExtractFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

selNames<-c(as.character(ExtractFeaturesNames), "subject", "activity" )
ExtractData<-subset(Data,select=selNames)

actLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

##Replaces the original names with easier to understand descriptions

names(ExtractData)<-gsub("^t", "time", names(ExtractData))
names(ExtractData)<-gsub("^f", "frequency", names(ExtractData))
names(ExtractData)<-gsub("Acc", "Accelerometer", names(ExtractData))
names(ExtractData)<-gsub("Gyro", "Gyroscope", names(ExtractData))
names(ExtractData)<-gsub("Mag", "Magnitude", names(ExtractData))
names(ExtractData)<-gsub("BodyBody", "Body", names(ExtractData))

##Uses plyr to combine data into single fields and output text file.
library(plyr);
AggED<-aggregate(. ~subject + activity, ExtractData, mean)
AggED<-AggED[order(AggED$subject,AggED$activity),]
write.table(AggED, file = "GACDCP.txt",row.name=FALSE)
