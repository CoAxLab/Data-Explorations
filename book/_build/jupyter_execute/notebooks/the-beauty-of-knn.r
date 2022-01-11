require(tidyverse)
dat <- iris
head(dat)
options(repr.plot.width=10, repr.plot.height=10)
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2)

set.seed(1) # this is so the colab notebook will give the same random 30 test items every time we run it. 
test.inds <- sample(1:nrow(dat),30)
dat$is.test <- 1:nrow(dat) %in% test.inds # TRUE/FALSE indicator for whether each observation is a test item or not. 
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2) + # plot all the data, colored by species
  geom_point(data=dat[test.inds,],aes(x=Petal.Length,y=Sepal.Length),size=4,color="black",shape="o") # circle the test items. 

library(class)
train.preds <- cbind(dat$Petal.Length[-test.inds],dat$Sepal.Length[-test.inds])
test.preds <- cbind(dat$Petal.Length[test.inds],dat$Sepal.Length[test.inds])
train.spec <- dat$Species[-test.inds]
test.spec.knn <- knn(train.preds,test.preds,train.spec,5)
test.spec.knn[1:10]

dat$Species_pred <- dat$Species # new variable for each observation's predicted species. 
dat$Species_pred[test.inds] <- test.spec.knn # add the KNN predictions for test obs to dataset.
dat$KNN_correct <- dat$Species == dat$Species_pred
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2,shape="o") + # Base layer to show training points
  geom_point(data=dat[test.inds,],aes(x=Petal.Length,y=Sepal.Length,col=Species_pred)) + # Next layer shows test points' KNN classifications
  geom_point(data=dat[which(!dat$KNN_correct),],aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + # draw "x" over wrong ones. 
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
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2,shape="o") + # Base layer to show training points
  geom_point(data=dat[test.inds,],aes(x=Petal.Length,y=Sepal.Length,col=Species_predK1)) + # Next layer shows test points' KNN classifications
  geom_point(data=dat[which(!dat$KNN_correct),],aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + # draw "x" over wrong ones. 
  ggtitle("k=1")

dat$KNN_correct <- dat$Species == dat$Species_predK100
ggplot(dat,aes(x=Petal.Length,y=Sepal.Length,col=Species)) + geom_point(size=2,shape="o") + # Base layer to show training points
  geom_point(data=dat[test.inds,],aes(x=Petal.Length,y=Sepal.Length,col=Species_predK100)) + # Next layer shows test points' KNN classifications
  geom_point(data=dat[which(!dat$KNN_correct),],aes(x=Petal.Length,y=Sepal.Length),shape="x",col="black",size=4) + # draw "x" over wrong ones. 
  ggtitle("k=100")

print(paste("Accuracy:",sum(dat$KNN_correct[test.inds])/length(test.inds)))
print(sum(dat$Species[-test.inds]=="setosa"))

install.packages("ISLR")
library(ISLR)
head(Caravan[,c(1:5,86)]) # column 86 is whether or not they purchased Caravan insurance
print(unique(Caravan$ABYSTAND))

print(paste("variance of first variable:",var(Caravan[,1])))
print(paste("variance of second variable:",var(Caravan[,2])))

stand.X <- scale(Caravan[,-86]) # 86 is the "Purchased" variable we will predict
var(stand.X[,1]) # note that variance of all variables is now 1. 
test.preds <- stand.X[1:1000,] # our test predictor variables
train.preds <- stand.X[1001:nrow(stand.X),] # train predictor variables
train.purch <- Caravan[1001:nrow(Caravan),86] # classifications for training observations
test.purch.knn <- knn(train.preds,test.preds,train.purch,k=100)
print(paste("Accuracy:",mean(test.purch.knn==Caravan[1:1000,86])))
