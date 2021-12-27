# install.packages("ISLR")
library(ISLR) # Loading ISLR because this is where the Carseats dataset is.

# install.packages('tree') #uncomment to install 
library(tree) #this is the library needed for tree regression and classification

# ?Carseats # Uncomment for more info on the "carseats "
head(Carseats)

#if sales are <= $8000, then sales are not high 
# otherwise, they are. 
Carseats$High <- as.factor(ifelse(Carseats$Sales<=8, "No", "Yes") ) # Binarize and add to data.frame

tree.carseats <- tree(High~.-Sales, Carseats)

summary(tree.carseats)

plot(tree.carseats) #this will create the basic tree structure
text(tree.carseats, pretty=0) #this will annotate the tree with predictors and outcomes
#pretty=0 means that the tree will display the full names of the qualitative predictors instead of 
#single-letter abbreviations 

tree.carseats

set.seed (2)
idx = 1:nrow(Carseats)
test=sample(idx, 100) #sample 50 for the test set
tune = sample(idx[-test], 150) #150 for the tuning set
train = idx[!(idx %in% c(tune, test))] ##select indices that are not in tune or test
Carseats.tune=Carseats[tune,] #indices for test set
Carseats.test=Carseats[test,]
Carseats.train=Carseats[train,] 

High.test=Carseats$High[test] #get test data
#tree.carseats=tree(High~.-Sales, Carseats, subset=c(tune,train)) #hacked model
print(length(c(tune,train)))
tree.carseats=tree(High~.-Sales, Carseats, subset=tune) #tuned model
tree.pred=predict(tree.carseats, Carseats.test, type="class") #make a prediction using the test set
#class instructs R to return the class prediction
table(tree.pred, High.test) #compare predictions with test data

#total_accuracy = (51 + 25) / length(test) #test accuracy for the hacked model
total_accuracy = (50 + 27) / length(test) #test accuracy for the tuned model
total_accuracy

set.seed(3)
cv.carseats = cv.tree(tree.carseats, FUN=prune.misclass) 
#FUN=prune.misclass indicates that we want classification error rate to guide the 
#cross-validated pruning process 
names(cv.carseats) #this function reports the terminal number of nodes 
#for each tree considered (size), the corresponding error rate (dev),
#and the value of the cost complexity parameter (k, corresponding to alpha)

cv.carseats

plot(cv.carseats$size ,cv.carseats$dev ,type="b")

#prune.carseats=prune.misclass(tree.carseats,best=14) #hacked model
tree.carseats=tree(High~.-Sales, Carseats, subset=train) #tuned model
prune.carseats=prune.misclass(tree.carseats,best=10) #tuned model
plot(prune.carseats) #plotting the newly pruned tree
text(prune.carseats, pretty=0)

tree.pred=predict(prune.carseats, Carseats.test, type="class")
table(tree.pred, High.test)

#total_pruned_accuracy = (52+27)/length(test) #hacked model accuracy
total_pruned_accuracy = (42+30)/length(test) #tuned model test
total_pruned_accuracy

Carseats$High <- NULL
set.seed(1)
tree.sales=tree(Sales~.,Carseats, subset=train) #fit the regression tree, using same training set as in previous section. 
summary(tree.sales) #summarize

plot(tree.sales)
text(tree.sales, pretty=0)

#first, let's look at the CV error as a function tree size
cv.sales=cv.tree(tree.sales) 
plot(cv.sales$size, cv.sales$dev,type='b')

prune.sales=prune.tree(tree.sales,best=2) #manually selecting a 2-node tree
plot(prune.sales)
text(prune.sales,pretty=0)

yhat=predict(prune.sales,newdata=Carseats[-train ,]) # Use the tree sales
sales.test=Carseats[-train, "Sales"] # extract the correct predictions for the test trials
require(ggplot2)
ggplot(data.frame(yhat=yhat,sales.test=sales.test),aes(x=yhat,y=sales.test)) + 
    geom_point() + 
    geom_abline(slope=1,intercept=0)
mean((yhat-sales.test)^2)
