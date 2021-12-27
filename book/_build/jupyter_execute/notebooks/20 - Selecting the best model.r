# install.packages("ISLR") # uncomment if you don't have ISLR package installed
# Load the Baseball dataset
library(ISLR)
library(tidyverse) # for some data frame manipulation
names(Hitters)# 
dim(Hitters)

# Uncomment the line below to see the help function for the data set.
#help(Hitters)

print(sum(is.na(Hitters)))
# R lets you filter out the empty values using na.omit

# Using na.omit to make a new data set that only includes
# those observations where all variables are observed
Hitters=na.omit(Hitters)

dim(Hitters) # Notice that the dimensions reduced by 59 rows
sum(is.na(Hitters)) # And there are no longer any "na" values

# Uncomment the line below if you haven't installed the leaps package yet
# install.packages("leaps")
library(leaps)
?regsubsets # uncomment to learn more about regsubsets function

# regsubsets uses the same model configuration as lm()
# so, configure the model in regsubsets as regsubsets(model, data)
regfit.full = regsubsets(Salary~., select(Hitters,c(AtBat,Hits,HmRun,Salary,Assists))) #use every variable EXCEPT salary as a predictor
summary(regfit.full) # Asterisks indicate that a field is included in the model

regfit.full = regsubsets(Salary~., Hitters, nvmax=19) #< "nvmax" allows the model selection to include up to 19 variables (limited to 8 by default)
reg.summary = summary(regfit.full)
reg.summary

# See what is included in the summary object
attributes(reg.summary)

# You can directly query which terms are included at each level of complexity
reg.summary$which

# Uncomment whichever ones you want to look at. 

numvar = 1:length(reg.summary$rss)# Make a vector that lists the number of variables in sequence, from 1 to 19. 
allfalse = rep(FALSE,length(reg.summary$rss))# Starting point for an indicator that marks the best model choice for each metric.

# #rss
# rss.df <- data.frame(numvar = numvar, rss = reg.summary$rss, minrss = allfalse)
# rss.df$minrss[which.min(reg.summary$rss)] <- TRUE
# ggplot(rss.df,aes(x=numvar,y=rss,shape=minrss,col=minrss)) + 
#     geom_point(size=3) + theme_light() + 
#     labs(x = "Number of Variables", y = "RSS", color="Minimum RSS", shape="Minimum RSS")

#adjr2
adjr2.df <- data.frame(numvar = numvar, adjr2 <- reg.summary$adjr2, maxadjr2 <- allfalse)
adjr2.df$maxadjr2[which.max(reg.summary$adjr2)] <- TRUE
ggplot(adjr2.df,aes(x=numvar,y=adjr2,shape=maxadjr2,col=maxadjr2)) + 
    geom_point(size=3) + theme_light() + 
    labs(x = "Number of Variables", y = 'Adj'~R^2, color='Maximum Adj'~R^2, shape='Maximum Adj'~R^2)

# #mallow's cp
# cp.df <- data.frame(numvar = numvar, cp <- reg.summary$cp, mincp <- allfalse)
# cp.df$mincp[which.min(reg.summary$cp)] <- TRUE
# ggplot(cp.df,aes(x=numvar,y=cp,shape=mincp,col=mincp)) + 
#     geom_point(size=3) + theme_light() + 
#     labs(x = "Number of Variables", y = "Mallow's CP", color="Maximum CP", shape="Maximum CP")

# #bic
# bic.df <- data.frame(numvar = numvar,bic <- reg.summary$bic, minbic <- allfalse)
# bic.df$minbic[which.min(reg.summary$bic)] <- TRUE
# ggplot(bic.df,aes(x=numvar,y=bic,shape=minbic,col=minbic)) + 
#     geom_point(size=3) + theme_light() + 
#     labs(x = "Number of Variables", y = "BIC", color="Minimum BIC", shape="Minimum BIC")

plot(regfit.full, scale="bic") #BIC
# plot(regfit.full, scale="adjr2") #adjusted R^2
# plot(regfit.full, scale="Cp") #Mallow's Cp

# identify which model has the best bias-adjusted fit
which.min(reg.summary$bic) 
which.max(reg.summary$adjr2)
which.min(reg.summary$cp)
