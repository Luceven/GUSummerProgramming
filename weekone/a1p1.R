## week one asignment
## Part one

## set working directory
setwd("D:\\Adv.program\\weekone")

## load data set
#library(datasets)
#data("iris")
#summary(iris)
mydata = read.csv("DATASET1.csv", header = T)

## add a new column based on petal length
mydata$sl.group <- findInterval(mydata$Sepal.Length, c(0, 5, 6, 7, 8), rightmost.closed = T)

## write to new file
write.table(head(mydata), file = "MYOUTFILE.txt", sep = "\t", row.names = F)

## add a new column based on survival status
mydata$sw.group <- as.numeric(mydata$Sepal.Width > 3)

## ANOVA function
functionanova <- function(x, y, datasource){
  results = aov(y ~ x, data = datasource)
  capture.output(summary(results), append = T, file = "MYOUTFILE.txt")
  #return(summary(results))
}

## T-test function
functionttest <- function(x, y){
  results = t.test(y ~ x)
  capture.output(results, append = T, file = "MYOUTFILE.txt")
  #return(results)
}

## Z-test function
functionztest <- function(data, mu){
  one.tail.p <- NULL
  #popvar <- (var(data) * ((length(data) - 1) / length(n)))
  popvar <- sum((data - mean(data))^2) / length(data)
  zeta <- round((mean(data) - mu) / (popvar / sqrt(length(data))), 3)
  one.tail.p <- round(pnorm(abs(zeta), lower.tail = F), 3)
  cat(" z =", zeta, "\n",
      "one-tailed propability =", one.tail.p, "\n",
      "two-tailed probability =", 2*one.tail.p, "\n",
      file = "MYOUTFILE.txt", append = T)
  #capture.output(results, append = T, file = "MYOUTFILE.txt")
}

## summary satistics function
functionsummary <- function(data){
  results <- summary(data)
  capture.output(results, append = T, file = "MYOUTFILE.txt")
}

## ANOVA
a_response <- mydata$Sepal.Length
a_factors <- mydata$Petal.Length

aov_result <- functionanova(a_factors, a_response, mydata)

## T-test
t_response <- mydata$Sepal.Width
t_factors <- mydata$sw.group

t_result <- functionttest(t_factors, t_response)

## Z-test
pldata <- mydata$Petal.Length

# plot histogram of petal length
png(filename = "histogram.png")
h <- hist(pldata, breaks = 20, density = 20,
          xlab = "Petal Length", main = "normal curve over histogram of petal length",
          col = rainbow(20), ylim=c(0,40)) 
xfit <- seq(min(pldata), max(pldata), length = 40) 
yfit <- dnorm(xfit, mean = mean(pldata), sd = sd(pldata)) 
yfit <- yfit * diff(h$mids[1:2]) * length(pldata) 

lines(xfit, yfit, col = "darkblue", lwd = 2)
dev.off()

# set mu = 3
mu <- 3
z_result <- functionztest(pldata, mu)

## statistical summary
s_summary <- functionsummary(pldata)

## Boxplot
png(filename = "boxplot.png")
mylabels <- c("S.L", "S.W", "P.L", "P.W")
boxplot(mydata$Sepal.Length, mydata$Sepal.Width, mydata$Petal.Length, mydata$Petal.Width,
        names = mylabels, col = rainbow(20), ylab = "length (cm)", xlab = "Iris Info",
        main = "boxplot of Iris data")
dev.off()

## Scatterplot
png(filename = "scatterplot.png")
plot(mydata$Sepal.Length, mydata$Petal.Length, main = "Scatterplot of Iris data",
     xlab = "sepal length", ylab = "petal length")
abline(lm(mydata$Petal.Length ~ mydata$Sepal.Length), col = "red")
lines(lowess(mydata$Sepal.Length, mydata$Petal.Length), col = "blue")
dev.off()

## multiple barplot
png(filename = "barplot.png")
labels = c("setosa", "versicolor", "virginica")
counts <- table(mydata$sl.group, mydata$sw.group)
barplot(counts, main = "Iris distribution by Sepal Length and Sepal Width",
        xlab = "group of Sepal Length", col = rainbow(20),
        legend = row.names(counts), beside = T)
dev.off()