#install.packages("ISLR")
library(ISLR)
library(tidyverse)
set.seed(1) #set the seed for the random number generator. resetting the seed will give different results.

train = sample(x = 392, size = 196)  # sample 196 indices from the vector 1:392

ggplot(Auto,aes(mpg,horsepower)) + geom_point()

# Generate a linear model using the training subset
lm.fit = lm(mpg~horsepower, data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit,Auto))[-train]^2) # Mean Squared Error (MSE) for test set

# Use the poly() function to estimate test error
# for polynomial and cubic regressions
# 2nd degree polynomial
lm.fit2 = lm(Auto$mpg~poly(horsepower,4), data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit2,Auto))[-train]^2) # Mean Squared Error (MSE) for test set

# 3rd degree polynomial
lm.fit3 = lm(Auto$mpg~poly(horsepower,6), data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit3,Auto))[-train]^2)

# Notice that if we use a different subsample we'd get different results
set.seed(2) #using a different seed 
train = sample(392, 196)

# Linear model
lm.fit = lm(mpg~horsepower, data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit,Auto))[-train]^2)

# Polynomial
lm.fit2 = lm(mpg~poly(horsepower,4), data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit2,Auto))[-train]^2)

# Cubic
lm.fit3 = lm(mpg~poly(horsepower,6), data=Auto, subset=train)
mean((Auto$mpg-predict(lm.fit3,Auto))[-train]^2)

# Continue with the Auto example
glm.fit = glm(mpg~horsepower, data=Auto)
coef(glm.fit)

library(boot) # Load the bootstrap library
#?cv.glm() #uncomment to get more information about this function

#run LOOCV by setting k to the number of observations
cv.err  = cv.glm(Auto, glm.fit, K=nrow(Auto))

cv.err$delta 

#if you don't define k in the cv.glm() function, the default is LOOCV
cv.err  = cv.glm(Auto, glm.fit))

# Repeat for polynomial models up to a factor of 10

# specify your output object - where you'll save the MSE estimates for each poly value
cv.error = rep(0,10) 
start.time <- Sys.time()
for (i in 1:10) {
    glm.fit=glm(mpg~poly(horsepower,i), data=Auto)
    # do LOO crossval for polynomial fits from 1 to 10
    cv.error[i] = cv.glm(Auto, glm.fit)$delta[1] 
}
end.time <- Sys.time()
# how long did this for-loop take to run?
LOOtime <- end.time-start.time 
LOOtime

plot(1:10,cv.error) # plot the error

ggplot(aes(weight, mpg),data=Auto) + 
    geom_point() + 
    stat_smooth(method = "lm", formula = y ~ poly(x,2), se = FALSE)

# Reset the seed
set.seed(17)

# Always have to specify your output object
cv.error.10 = rep(0,10)
start.time <- Sys.time()
for (i in 1:10){
  #get the glm fit for all 10 polynomials
  glm.fit=glm(mpg~poly(horsepower,i), data=Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit,K=10)$delta[1]
}
end.time <- Sys.time()
Kfoldtime <- end.time-start.time # how long did this for-loop take to run?

plot(cv.error, cv.error.10, xlab="LOOCV error", ylab="10-fold CV error")
lines(c(19,25),c(19,25))

print(paste("Leave-one-out runtime:",LOOtime))
print(paste("10-fold runtime:",Kfoldtime))
