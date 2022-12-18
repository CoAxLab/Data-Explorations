install.packages("ISLR")
library(ISLR)
library(boot)

# The function needs two inputs: Data, Index
boot.fn <- function(data, index){  
    # return: throw this as output
    # coef: extract coefficients from model object 
    return(coef(lm(mpg~horsepower, data=data, subset=index)))}


print(boot.fn(Auto, 1:392)) # note: "1:392" means all the rows

print(coef(lm(mpg~horsepower, data=Auto)))

#?boot # uncomment to learn more about the boot() function

boot_obj = boot(Auto ,boot.fn ,R=1000) #R=repetitions 
print(boot_obj) #t1 is the intercept and t2 is the horsepower coeff.

attributes(boot_obj) #get all attributes of the boot object 

hist(boot(Auto ,boot.fn ,R=1000)$t[,2], xlab="Horsepower coefficient") #we get a distribution of all of the estimates
#                               ^^ indexing the second "t" value

# Parametric model
summary(lm(mpg~horsepower ,data=Auto))$coef

# First let's make a copy of the data set that we'll keep permuting
permAuto = Auto #want to preserve the non-permuted, true form of data!

# Set the number of iterations
R=1000

# Next smake an output object to store the results
perm.coefs=matrix(NA,nrow=R, ncol=2) #filling with nas at first

# Now just write a for loop where we scramble the observations
# in X using the sample() function. We'll scramble the observations in R different ways
for (i in 1:R){
  permAuto$horsepower=Auto$horsepower[sample(392)] # This is a shuffled version of the Auto$horsepower vector
  perm.coefs[i,]=coef(lm(mpg~horsepower, data=permAuto)) # then we get coefficients for linear model of shuffled horsepower to auto
}

# Take a look at the null distributions
hist(perm.coefs[,2])


# Now re-estimate the real (unpermuted) effect 
perm.real = coef(lm(mpg~horsepower, data=Auto))
perm.real

#sum the coefficients less than the real coefficient estimate 
#and divide by the number of repetitions to get an empirical probability 
perm.p = sum(perm.coefs[,2]<perm.real[2])/R 
perm.p
