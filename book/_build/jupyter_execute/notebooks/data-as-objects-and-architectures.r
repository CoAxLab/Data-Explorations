6 + 2
10 - 3 * 4
5^3

a <- c(1,2,3)
b <- c(4,5,6)
print(paste("mean of vector a:",mean(a)))
print(paste("sum of vector b:",sum(b)))

a*b

c <- c("one", "two", "three")
data <- data.frame(avar = a,bvar = b,cvar = c)
data

a[2]

data[2,1]

data$bvar

print("Column 3")
data[,3]

print("Row 1")
data[1,]

data[,"cvar"]

long_data <- data.frame(subject = rep(1:3, each=4),
                        timepoint = rep(1:4, times=3),
                        observation = round(rnorm(12), 2))
long_data

long_data  %>% 
    mutate(timepoint = paste0('time',timepoint))  %>% 
    spread(timepoint, observation)

library(tidyverse) #We'll learn about this package in the next tutorial!

# generate data where y is a function of two variables, x1 and x2
x1 <- seq(-4,4,0.5) #generate data ranging from -4 to 4 in steps of 0.5
x2 <- seq(-4,4,0.5)

#specify a sigmoidal relationship between x1 and y 
#and a linear relationship between x2 and y
dat <- expand.grid(x1=x1, x2=x2) %>% 
    mutate(y = 1/(1+exp(-x1)) + 0.1*x2)

head(dat)

# setting figure size
options(repr.plot.width=6, repr.plot.height=4)

dat  %>%
    gather(var, value, x1, x2) %>% # make it long format - only x1 or x2 in each row
    ggplot(aes(value, y)) +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean) +
    facet_wrap(~var)


#create new y_obs variable with normally distributed noise
dat <- mutate(dat, y_obs = y + rnorm(length(y), mean=0, sd=0.1)) 

#fit a linear model to find the regression coefficients
model_fit <- lm(y_obs ~ x1 + x2, data=dat) 

str(model_fit) #print the structure of the model object

model_fit$coefficients

#store the coefficients in a variable
coef <- model_fit$coefficients 

#save the name/value of the coefficients in a dataframe
data.frame(name = names(coef), value = coef) 

#extract model estimate of y for each x and store in df as fitted
dat$fitted <- model_fit$fitted.values 

head(dat) #we see "fitted" column added

#plot fitted against the observed data 
ggplot(dat, aes(fitted, y_obs)) + 
    stat_summary(geom='point',fun=mean)

new_data <- data.frame(x1=-5, x2=10) #new x-values to give to the model 
predict(model_fit, newdata = new_data) #predict the y value for a given x 
