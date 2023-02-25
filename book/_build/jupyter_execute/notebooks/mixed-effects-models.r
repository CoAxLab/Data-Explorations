# Load LME4
# install.packages("lme4") # Uncomment if not installed.
library(lme4)
library(ggplot2)

#help(sleepstudy) # Uncomment to see documentation
head(sleepstudy)

ggplot(sleepstudy, aes(Days, Reaction, color = Subject)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE)

fe.fit = lm(Reaction~Days, data=sleepstudy)
summary(fe.fit)

# Random intercepts and slopes across subjects
me.fit1 = lmer(Reaction ~ Days + (Days | Subject), data=sleepstudy)
# ^^ the same as me.fit1 = lmer(Reaction ~ Days +  (1+Days | Subject), data=sleepstudy) 

# Random intercepts only
me.fit2 = lmer(Reaction ~ Days + (1 | Subject), data=sleepstudy)

print("*******me.fit1********")
summary(me.fit1)

print("*******me.fit2********")
summary(me.fit2)

# We will compare the two models using the Akaike information criterion (AIC)
ic = AIC(fe.fit, me.fit1, me.fit2)
ic
diff(ic$AIC)
