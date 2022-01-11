# install.packages("ISLR") # uncomment if you haven't installed this library
library(ISLR)
names(Hitters)

# install.packages("glmnet", dependencies = TRUE) # uncomment if you haven't installed this library
library(glmnet)

# Use a non-linear search on lambda
lambda_search_space = 10^seq(10, -2, length=100) #create a search space from (10^10):(10^-2), 100 samples long
plot(lambda_search_space, xlab="sample", ylab="lambda")

#this will span a range of models, from the null model containing only the intercept (lambda = 10^10, extremely sparse)
#to the least squares fit (lambda = 0, lenient)

# Define x without the first column
x = model.matrix(Salary~., Hitters)[,-1] #without first intercept column
#the model.matrix function also automatically transforms qualitative variables
#into dummy variables and gets rid of NAs

y = Hitters$Salary[!(is.na(Hitters$Salary))] #selecting y from the dataframe - get rid of NAs so that rows are matched with those in x

ridge.mod = glmnet(x, y, alpha=0, lambda=lambda_search_space)

dim(coef(ridge.mod)) #this gives 20 rows (one for each predictor, plus a new intercept)
#and 100 columns, one for each value of lambda in the search space

lambda_search_space[50] #getting particular value of lambda
plot(coef(ridge.mod)[,50]) #getting coeff. for that value of lamba, all coeff.

lambda_search_space[3]
plot(coef(ridge.mod)[2:20,3])

plot(predict(ridge.mod, s=50, type="coefficients")[1:20,]) #s=lambda=50

set.seed(1) # Use the same seed so we get the same results

# Create your validation sets
train=sample(1:nrow(x), nrow(x)/2) #50/50 split into training and test sets
test=(-train) #get test indices (not training indices)
y.test = y[test]

# Make a training model using the training set (for all values of lambda)
ridge.mod = glmnet(x[train,], y[train], alpha=0, lambda=lambda_search_space, thresh=1e-12) #threshold specifies the convergence criterion

# With lambda = 1e10 (10^10)
#note that this is like a null, intercept-only model
ridge.pred = predict(ridge.mod, s=1e10, newx=x[test,])
mean((ridge.pred - y.test)^2)

# With lambda = 4 (s=lambda)
ridge.pred = predict(ridge.mod, s=4, newx=x[test,])
mean((ridge.pred - y.test)^2)

# With lambda = 0 (note that this is OLS regression)
ridge.pred = predict(ridge.mod, s=0, newx=x[test,])
mean((ridge.pred - y.test)^2)

set.seed(2) # Use the same seed so we get the same results

# Create your validation sets
train=sample(1:nrow(x), nrow(x)/2) #50/50 split into training and test sets
test=(-train) #get test indices (not training indices)

#split each of the training and test phases into two 
#need to have separate validation sets for lambda and for beta estimates

train_hyperparameter = sample(train, length(train)/2)
train_glm = (-train_hyperparameter)

test_hyperparameter = sample(test, length(test)/2)
test_glm = (-test_hyperparameter)

#make sure that the samples do not overlap
sum(test_hyperparameter == train_hyperparameter) 
sum(test_glm == train_glm) 
sum(train_hyperparameter == train_glm) 

# Using 10-fold CV, cross-validate on the training data
set.seed(1)
cv.out = cv.glmnet(x[train_hyperparameter,], y[train_hyperparameter], alpha=0) #alpha=0=ridge regression
plot(cv.out) #defaults to 10-fold CV
bestlam = cv.out$lambda.min
bestlam

#passing in the trained model object, the best lambda, and the test data
ridge.pred = predict(ridge.mod, s=bestlam, newx=x[test_hyperparameter,]) 
mean((ridge.pred -y[test_hyperparameter])^2) #MSE

# First setup the model
out = glmnet(x[train_glm,],y[train_glm], alpha=0)

# # Then predict.
print(predict(out, type="coefficients", s=bestlam, newx=x[test_glm,])[1:20,]) # "s = bestlam" picks out the winning value and shows those coefs.
