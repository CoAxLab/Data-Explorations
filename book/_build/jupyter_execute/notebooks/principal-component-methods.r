head(iris)

cor(iris[,1:4])

require(ggplot2)
ggplot(iris,aes(x=Petal.Length, y = Sepal.Length, col=Species)) + geom_point() + theme_light()
ggplot(iris,aes(x=Petal.Width, y = Sepal.Width, col=Species)) + geom_point() + theme_light()


iris.pca <- prcomp(iris[,1:4],scale. = TRUE) 
# ^^ "scale." just indicates that all variables should be scaled before PCA is applied, so that units don't matter

ggplot(data.frame(pc=1:4,var.exp=iris.pca$sdev/sum(iris.pca$sdev)),
        aes(x=pc,y=var.exp)) + 
    geom_point() + 
    theme_light()

iris.pca$rotation

head(iris.pca$x)

ggplot(data.frame(PC1=iris.pca$x[,1],PC2=iris.pca$x[,2],Species=iris$Species),
        aes(x=PC1,y=PC2,col=Species)) + 
    geom_point() + 
    theme_light()

install.packages("pls") # Uncomment if not installed
library(pls) # load for the pcr function
install.packages("ISLR") # Uncomment if not installed
library(ISLR) # For Hitters dataset
library(tidyverse)
hit.dat <- Hitters %>% drop_na() # get rid of missing values in Hitters dataset.

set.seed(2)
pcr.fit=pcr(Salary~., data=hit.dat ,scale=TRUE, validation ="CV")
summary(pcr.fit)

validationplot(pcr.fit,val.type="MSEP") # MSEP shows cross-validated mean-squared error as error metric. 

set.seed(1)
train=sample(1:nrow(hit.dat), nrow(hit.dat)/2) # Identify train observations
test=(-train) # Identify test observations
y.test=hit.dat$Salary[test] # Identify test dependent variable values
x.test=select(hit.dat,-Salary)[test,] # Identify test independent variable values

pcr.fit=pcr(Salary~., data=hit.dat,subset=train,scale=TRUE, validation ="CV") # Run cross-validated PCR fit on training set
validationplot(pcr.fit,val.type="MSEP") # plot CV MSE for num of PCs

# calculate prediction error on test set 
pcr.pred=predict(pcr.fit,x.test,ncomp=5)
mean((pcr.pred-y.test)^2)

pcr.fit = pcr(Salary~., data=hit.dat, scale=TRUE, ncomp=5) # fit PCR to the full data set using our selected number of PCs, M = 5
summary(pcr.fit)

set.seed(1)
pls.fit <- plsr(Salary~.,data = hit.dat, subset=train, scale=TRUE, validation="CV")
summary(pls.fit)

pls.pred = predict(pls.fit,x.test,ncomp=1)
mean((pls.pred - y.test)^2)

pls.fit = plsr(Salary~.,data=hit.dat,scale=TRUE,ncomp=1)
summary(pls.fit)
