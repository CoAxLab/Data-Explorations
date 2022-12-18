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
