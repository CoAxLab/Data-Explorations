# Load the namespace for these packages and attach them to the search list 
library(MASS)
library(ggplot2)

# fix(Cars93)

names(Cars93)

help(Cars93)
?Cars93

# To get more information on the lm function execute this cell
help(lm)

options(repr.plot.width=5, repr.plot.height=5) # plot size 
ggplot(Cars93, aes(sample=Weight)) + geom_point(stat = "qq") + ggtitle("Normal dist. vs. normal sample")

# install.packages("repr") # uncomment to install repr library
library(repr)
options(repr.plot.width=10, repr.plot.height=10) # plot size reset
pairs(Cars93)

# Plot the joint distribution
options(repr.plot.width=8, repr.plot.height=8)
ggplot(aes(Width, Weight), data=Cars93) + 
geom_point() + 
xlab('Width') + 
ylab('Weight')

# Let's try a simple linear model
lm.fit = lm(Weight~Length, data=Cars93)

# In order to see the results, use the summary function
summary(lm.fit)

# you can also add the fit model in your ggplot to show both the line fitted and uncertainty around the fitted line
ggplot(aes(Length, Weight), data=Cars93) + 
  geom_point() + 
  geom_smooth(method = 'lm',se=FALSE) # fits line without standard error shading - try deleting "se=FALSE"

# Just grab the regression coefficients themselves
coef(lm.fit)[1]

coef(lm.fit)[2]

# In order to estimate the confidence interval on the regression coefficients we will use confit
# help("confint") # uncomment to see information on this function
print(confint(lm.fit))

# We want to predict car weight at specific lstat levels
# help("predict") # Uncomment to see how the function works

# Here we will predict what the weight would be if the width for the car is 165, 180, or 195 inches.

length_input_values = data.frame(Length=c(165,180,195)) #specific SES values that you want a prediction for 
prediction_table = data.frame(predict(lm.fit, length_input_values, interval = 'confidence'))  #calling the predict function 

pred_input_table = cbind(length_input_values, prediction_table) #bind the input and prediction dataframes by column 

colnames(pred_input_table) = c('length_input','predicted fit','lower_CI_bound', 'upper_CI_bound') #use informative column names 
round(pred_input_table,2) #display rounded values

# help("abline") # Uncomment to see how the function works
# abline(lm.fit)

ggplot(aes(`Length`, `Weight`), data=Cars93) + 
  geom_point() + 
  geom_abline(intercept = coef(lm.fit)[1], slope = coef(lm.fit)[2]) + # adds a line that shows the model's fit
  xlab('Car Length') + ylab('Car Weight') 

install.packages("ggfortify")
library(ggfortify) #load a ggplot library that can plot model diagnostics  

suppressWarnings(
  autoplot(lm.fit, label.size = 3)
  )
# ( ^ note: I just suppressed a warning about an old version of a command that ggfortify uses - you don't need to worry about it)

# Let's plot some relationships first.
#install.packages("plot3D") # Uncomment if this is not installed

library(plot3D) # note - this is outside of the ggplot2 package
# Let's look at the relationship between Length AND Width on car weight

scatter3D(Cars93$Width, Cars93$Length, Cars93$Weight, phi=20, theta=20, xlab="Width", ylab="Length",zlab="Weight")
#phi controls tilt and theta controls angle

lm.fit = lm(Weight~Width+Length, data=Cars93)
summary(lm.fit)

num_cols <- unlist(lapply(Cars93, is.numeric)) # Find just the numeric columns
lm.fit=lm(Weight~., data=Cars93[,num_cols])
summary(lm.fit)

# Excluding a variable from the model: age, indus
lm.fit_new = lm(Weight~.-EngineSize -Passengers, data=Cars93[,num_cols]) #you can exclude a variable by placing a '-' sign in front of it
summary(lm.fit_new)

# Or just update the existing model
lm.fit_new=update(lm.fit, ~.-EngineSize -Passengers)
summary(lm.fit_new)

# First we will want to clear the workspace
rm(list=ls())

# Next load the car package for this
install.packages("car") #Uncomment if you haven't already installed the package
library(ISLR)

# Look at the Carseats dataset
# help(Carseats) # Uncomment to view documentation
names(Carseats)

# Now let us fit Sales with some interaction terms
lm.fit = lm(Sales~.+Income:Advertising+Price:Age, data=Carseats) #here we are using all individual predictors + interactions between income & advertising and price & age.
summary(lm.fit)

# attach(Carseats)
contrasts(Carseats$ShelveLoc)
#here, bad is when good and medium are 0 
#good is when good = 1 and medium = 0 
#medium is when good = 0 and medium = 1
