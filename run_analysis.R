## Download and unzip datefiles. 

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
Des<-"./dataset.zip"
download.file(fileURL,destfile = Des)
if(!file.exists("./data")) {dir.create("./data")}

unzip(zipfile=Des,exdir = "./data")

setwd("./data/UCI HAR Dataset")

## Read data files to R
Des<-"./train/subject_train.txt"
subject_train<-read.table(Des)

Des<-"./train/y_train.txt"
y_train<-read.table(Des)

Des<-"./train/X_train.txt"
x_train<-read.table(Des)

Des<-"./test/subject_test.txt"
subject_test<-read.table(Des)

Des<-"./test/y_test.txt"
y_test<-read.table(Des)

Des<-"./test/X_test.txt"
x_test<-read.table(Des)


## Merge the training and the test sets to create one data set
test_data<-cbind(subject_test,y_test,x_test)

train_data<-cbind(subject_train,y_train,x_train)

final_data<-rbind(test_data,train_data)

## Extract only the measurements on the mean and standard deviation for each measurement
Des<-"./features.txt"
features<-read.table(Des)S

## Get mean and std columns order from features.txt file.
tmp<-grep("mean\\(\\)|std\\(\\)",features$V2)

final_data_sub<-final_data[,c(1,2,tmp+2)]

## Use descriptive activity names to name the activities in the data set
Des<-"./activity_labels.txt"
label<-read.table(Des)

final_data_sub<-merge(final_data_sub,label,by.x="V1.1",by.y = "V1",all.x=T,all.y = T)

## Appropriately label the data set with descriptive variable names
features$V2<-as.character(features$V2)
colNtobe<-features$V2[tmp]
colnames(final_data_sub)[3:68]<-colNtobe

colnames(final_data_sub)[2]<-"Subject_num"
colnames(final_data_sub)[1]<-"Activity_Code"
colnames(final_data_sub)[69]<-"Activities"

final_data_sub<-final_data_sub[,c(1,2,69,3:68)]

##Creat tidy data set with average of each variable.
final_tidy_data<-aggregate(x=final_data_sub[,4:68], by=list(final_data_sub$Subject_num,final_data_sub$Activities), FUN="mean")
colnames(final_tidy_data)[1]<-"Subject_num"
colnames(final_tidy_data)[2]<-"Activities"

##save data
Des<-"./final_tidy_data.txt"
write.table(final_tidy_data,Des,row.names=FALSE)


####Read data table
data_view<-read.table(Des,header=T)

