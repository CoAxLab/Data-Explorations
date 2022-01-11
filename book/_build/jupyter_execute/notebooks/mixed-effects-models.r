# Install LME4
#install.packages("lme4") # Uncomment if not installed.
library(lme4)
library(ggplot2)

#help(sleepstudy) # Uncomment to see documentation
head(sleepstudy)

# Let's take a look at the fixed effects
# we can plot the data by days and then grouped by subjects
ggplot(sleepstudy, aes(Days, Reaction, color = Subject)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE)
# What assumption in a regression model are we violating? 

# First let's try the simple linear fit anyways and see what we get
fe.fit = lm(Reaction~Days, data=sleepstudy)
summary(fe.fit)

# Now let's account for the random impact of subject variance on the model
me.fit1 = lmer(Reaction ~ Days + (Days | Subject), data=sleepstudy) # subject intercepts and slopes
# ^^ the same as me.fit1 = lmer(Reaction ~ Days +  (1+Days | Subject), data=sleepstudy) 
me.fit2 = lmer(Reaction ~ Days + (1 | Subject), data=sleepstudy) # only subject intercepts
print("*******me.fit1********")
summary(me.fit1)
print("*******me.fit2********")
summary(me.fit2)

# We will compare the two models using the Akaike information criterion (AIC)
ic = AIC(fe.fit, me.fit1, me.fit2)
ic
diff(ic$AIC)
