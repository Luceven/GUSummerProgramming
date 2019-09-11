## Week one assignment
## Part 2

## set working directory
setwd("D:\\Adv.program\\weekone")

## Read in training data
mydata <- read.csv("Titanic_Training_Data.csv", header = T, na.strings=c(""," ","NA"))

## print head of data
head(mydata)

## print the structure of data
str(mydata)

## convert all char column to factor
char_vars <- lapply(mydata, class) == "character"
mydata[, char_vars] <- lapply(mydata[, char_vars], as.factor)

## frequency table for all variables
lapply(mydata, table)

## check if NA in columns and sum up NAs
colSums(is.na(mydata))
sum_na <- (sum(is.na(mydata$Age)) + sum(is.na(mydata$Cabin)) + sum(is.na(mydata$Embarked)))
cat("The sum of all NAs: ", sum_na)

## count the number of complete rows
sum_cprow <- sum(complete.cases(mydata))
cat("The sum of complete rows:", sum_cprow)

## remove useless columns which contain too many missing values
# remove Cabin and Embarked
mydata$Cabin <- NULL
mydata$Embarked <- NULL
# replace missing value in Age w/ median
mydata$Age[is.na(mydata$Age)] <- round(mean(mydata$Age, na.rm = TRUE))

## create a column with bin, show counts in table
mydata$BinnedAge <- cut(mydata$Age, breaks = c(0, 15, 29, 45, Inf),
                  labels = c("0-15", "16-29", "30-45", "46-inf"))
table(mydata$BinnedAge)

## Boxplot of Age and Fare
mylabels <- c("Age", "Fare")
boxplot(mydata$Age, mydata$Fare, ylim=c(0,100),
        names = mylabels, col = rainbow(20), ylab = "Counts", xlab = "Titanic Passenger Info",
        main = "boxplot Titanic Passenger Info")

## Summary stats of Age
summary(mydata$Age)

## Histogram of age by sex
library(ggplot2)
ggplot(mydata,aes(x=Age))+geom_histogram()+facet_grid(~Sex)+theme_bw()