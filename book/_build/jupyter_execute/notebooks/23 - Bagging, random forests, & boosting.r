# install.packages('randomForest') # uncomment to install package
library(randomForest)
# install.packages('ISLR')
library(ISLR) # Loading ISLR because this is where the Carseats dataset is.

set.seed (2)
idx = 1:nrow(Carseats)
test=sample(idx, 50) #sample 50 for the test set
tune = sample(idx[-test], 150) #150 for the tuning set
train = idx[-c(test,tune)] ##select indices that are not in tune or test

bag.sales=randomForest(Sales~.,data=Carseats, subset=train, mtry=10,
                       importance=TRUE) # runs the bagging.
#the arg. mtry=11 indicates that all 11 predictors should be considered
#for each split of the tree (i.e., bagging should be done, m=p)
bag.sales

#test set performance of this bagged regression
sales.test = Carseats$Sales[-train]
yhat.bag = predict(bag.sales, newdata=Carseats[-train ,])
require(ggplot2)
ggplot(data.frame(yhat=yhat.bag,y=sales.test),aes(x=y,y=yhat)) + 
    geom_point() + geom_abline(slope=1,intercept=0)
mean((yhat.bag - sales.test)^2)

set.seed(4)
bag.sales=randomForest(Sales~.,data=Carseats, subset=train, mtry=10,
                       importance=TRUE, ntree=25) #grow 25 trees
yhat.bag = predict (bag.sales,newdata=Carseats[-train ,])
mean((yhat.bag-sales.test)^2)

set.seed(1)
rf.sales=randomForest(Sales~.,data=Carseats, subset=train ,
mtry=6, importance=TRUE)
yhat.rf = predict(rf.sales, newdata=Carseats[-train ,])
mean((yhat.rf-sales.test)^2)

importance(rf.sales)

varImpPlot(rf.sales)

# install.packages('gbm')
library(gbm)

set.seed (1)
boost.sales =gbm(Sales~.,data=Carseats[train ,], distribution=
                  "gaussian", n.trees=5000, interaction.depth=4)

summary(boost.sales)

yhat.boost=predict(boost.sales,newdata=Carseats[-train ,],
n.trees=5000)
mean((yhat.boost - sales.test)^2)
