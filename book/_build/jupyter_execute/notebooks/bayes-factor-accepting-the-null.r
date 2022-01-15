install.packages("BayesFactor") #install 

library(BayesFactor)
library(tidyverse) # also import tidyverse for data manipulation
# there are functions to calculate BF for many different tests, including correlations, linear regresssion, and t-tests - uncomment below to see them all
# lsf.str("package:BayesFactor") # outputs a list of all of the functions in the package

sleep
?sleep

## Compute difference scores
# ?spread
sleep$group <- as.factor(c(rep("group1",10),rep("group2",10))) # resetting the group values to avoid having integers as column names
sleep_wd <- sleep %>%
  spread(key=group,value=extra) %>% # wide format - all measurements for one participant are in same row
  mutate(diffScores= group1 - group2) # in case you want to look at the differences. 
head(sleep_wd)

## Traditional paired t-test
t.test(sleep_wd$group1,sleep_wd$group2,paired=TRUE) 

# ?ttestBF
bf = ttestBF(x = sleep_wd$group1,y=sleep_wd$group2, paired=TRUE) # this is the BF object
bf # the relative evidence for the alternative hypothesis (nonzero difference between conditions)

1/bf #the relative evidence for the null hypothesis (no difference between conditions)

#we can also test a directional hypothesis  
bfInterval = ttestBF(x = sleep_wd$diffScores, nullInterval=c(-Inf,0)) #here we test the hypothesis that the difference is less than 0
bfInterval

bfNegative = bfInterval[1] / bfInterval[2] #here we compare the evidence for a negative difference against the evidence for a positive one

bfNegative
#note the denominator specification

bfPositive = 1 / bfNegative #as you might expect, the evidence for a positive difference is miniscule 
bfPositive

allbf = c(bf, bfInterval)

allbf

plot(allbf)

data(ToothGrowth)
head(ToothGrowth)
# ?ToothGrowth

# model log10 of dose instead of dose directly
ToothGrowth$dose = log10(ToothGrowth$dose)

# Classic analysis for comparison
lmToothGrowth <- lm(len ~ supp + dose + supp:dose, data=ToothGrowth)
summary(lmToothGrowth)

full <- lmBF(len ~ supp + dose + supp:dose, data=ToothGrowth) #all predictors + interaction
noInteraction <- lmBF(len ~ supp + dose, data=ToothGrowth) #no interaction
onlyDose <- lmBF(len ~ dose, data=ToothGrowth) #only dose
onlySupp <- lmBF(len ~ supp, data=ToothGrowth) #only supplementation

allBFs <- c(full, noInteraction, onlyDose, onlySupp)
allBFs

plot(allBFs)

full / noInteraction
