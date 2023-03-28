require(tidyverse)
dat <- iris
head(dat)

options(repr.plot.width=10, repr.plot.height=10)
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) +
 geom_point(size=2)

# set seed so the notebook will give the same random 30 test items every time
set.seed(1) 

#pull random sample of 30 row indices
test.inds <- sample(1:nrow(dat),30)

# TRUE/FALSE indicator for whether each observation is a test item or not. 
dat$is.test <- 1:nrow(dat) %in% test.inds 
head(dat)



# plot all the data, colored by species
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + 
    geom_point(size=2) + 
    # circle the test items:
    geom_point(data=dat[test.inds,],aes(x=Petal.Length,y=Sepal.Length),size=4,color="black",shape="o") 

library(class)

#training data pulls the "not test" rows
train.preds <- cbind(dat$Petal.Length[-test.inds], dat$Sepal.Length[-test.inds])
train.spec <- dat$Species[-test.inds]
#testing data pulls the test rows
test.preds <- cbind(dat$Petal.Length[test.inds], dat$Sepal.Length[test.inds])

#run knn
test.spec.knn <- knn(train.preds, test.preds, train.spec, k = 5)

#print first 10 test specifications
test.spec.knn[1:10]

# new variable for each observation's predicted species. 
dat$Species_pred <- dat$Species

# add the KNN predictions for test obs to dataset.
dat$Species_pred[test.inds] <- test.spec.knn

# in which cases does the observed Species equal the predicted?
dat$KNN_correct <- dat$Species == dat$Species_pred

# Plot
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + 
    # Base layer to show training points: 
    geom_point(size=2,shape="o") + 
    # Next layer shows test points' KNN classifications:
    geom_point(data=dat[test.inds,],
               aes(x=Petal.Length,y=Sepal.Length,col=Species_pred)) + 
    # draw "x" over wrong ones.     
    geom_point(data=dat[which(!dat$KNN_correct),],
               aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + 
    ggtitle("k=5")

confusion_df <- data.frame(predicted = test.spec.knn,actual = dat$Species[test.inds])
table(confusion_df)
print("---")
print(paste("Accuracy:",mean(confusion_df$predicted == confusion_df$actual)))

dat$Species_predK1 <- dat$Species
dat$Species_predK100 <- dat$Species
dat$Species_predK1[test.inds] <- knn(train.preds,test.preds,train.spec,k=1)
dat$Species_predK100[test.inds] <- knn(train.preds,test.preds,train.spec,k=100)

dat$KNN_correct <- dat$Species == dat$Species_predK1

# Base layer to show training points
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + 
    geom_point(size=2,shape="o") + 
    # Next layer shows test points' KNN classifications
    geom_point(data=dat[test.inds,],
               aes(x=Petal.Length,y=Sepal.Length,col=Species_predK1)) + 
    # draw "x" over wrong ones. 
    geom_point(data=dat[which(!dat$KNN_correct),],
               aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + 
    ggtitle("k=1")

print(paste("Accuracy:",sum(dat$KNN_correct[test.inds])/length(test.inds)))

dat$KNN_correct <- dat$Species == dat$Species_predK100

# Base layer to show training points
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2,shape="o") + 
  # Next layer shows test points' KNN classifications
  geom_point(data=dat[test.inds,],
             aes(x=Petal.Length,y=Sepal.Length,col=Species_predK100)) + 
  # draw "x" over wrong ones. 
  geom_point(data=dat[which(!dat$KNN_correct),],
             aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + 
  ggtitle("k=100")

print(paste("Accuracy:",sum(dat$KNN_correct[test.inds])/length(test.inds)))
print(sum(dat$Species[-test.inds]=="setosa"))
print(sum(dat$Species[-test.inds]=="versicolor"))
print(sum(dat$Species[-test.inds]=="virginica"))

#install.packages("ISLR")
library(ISLR)

head(Caravan[,c(1:5,86)])
# column 86 is whether or not they purchased Caravan insurance

print(unique(Caravan$ABYSTAND))

print(paste("variance of first variable:",var(Caravan[,1])))
print(paste("variance of second variable:",var(Caravan[,2])))

# 86 is the "Purchased" variable we will predict
stand.X <- scale(Caravan[,-86])
# variance is 1:
var(stand.X[,1])

# our test predictor variables
test.preds <- stand.X[1:1000,] 

# train predictor variables
train.preds <- stand.X[1001:nrow(stand.X),] 

# classifications for training observations
train.purch <- Caravan[1001:nrow(Caravan),86]

#run knn
test.purch.knn <- knn(train.preds,test.preds,train.purch,k=100)
print(paste("Accuracy:",mean(test.purch.knn==Caravan[1:1000,86])))
