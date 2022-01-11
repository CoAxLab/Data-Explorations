# install.packages("mediation") # uncomment to install the mediation package. 
library(mediation)
library(MASS)
library(tidyverse)
names(Cars93)
# ?mediate # uncomment to learn about the mediate function

fitStart <- lm(MPG.highway ~ Passengers, data=Cars93)
summary(fitStart)
ggplot(Cars93,aes(x=Passengers,y=MPG.highway)) + geom_point() + geom_smooth(method="lm",se=FALSE)

fitM <- lm(Weight ~ Passengers,     data=Cars93) #Step 1: IV on M, Number of passengers predicting weight of car
fitY <- lm(MPG.highway ~ Weight + Passengers, data=Cars93) #Step 2: IV and M on DV, Number of passengers and weight predicting highway
summary(fitM)
summary(fitY)
fitMed <- mediate(fitM, fitY, treat="Passengers", mediator="Weight")
summary(fitMed)


fitMod <- lm(MPG.highway ~ Horsepower*Weight,data=Cars93)
summary(fitMod)

medH <- median(Cars93$Horsepower)
Cars93 %>%
  # make a new variable for split half vis: is horsepower above or below median?
  mutate(highHorsepower = factor(ifelse(Horsepower < medH,"Low","High"),levels=c("Low","High"))) %>% # "levels" just makes "low" appear on left
  ggplot(.,aes(x = Weight,y = MPG.highway)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + # add points and a fit line
  facet_grid(.~highHorsepower)
