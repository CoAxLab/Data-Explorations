# Libaries to install
#install.packages("glmnet")
#install.packages("matrixStats")
#install.packages("denoiseR")
#install.packages("gplots")
#install.packages("RColorBrewer")
#install.packages("plot3D") 
# install.packages("car") 
#install.packages("ISLR")

# Load the libraries
library(MASS)
library(glmnet)
library(tidyverse)
library(ggplot2)
library(matrixStats)
library(denoiseR)
library(gplots)
library(RColorBrewer)
library(plot3D) 
library(ISLR)


# Set the random number generator seed
set.seed(2022)


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
#rm(list=ls())



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

make_data <- function(n,p,k,s){
  
  if (n < p){
    # If number of features is greater 
    # than number of observations, increase
    # observations for the PCA to work
    m=p
  } else {
    # Otheriwse use the input n
    m=n
  }
  
  if (p < k) {
    # Make full rank until p=k
    # degree_diff = k-p
    x = LRsim(m,p,p,s)$X
  } else {
    x = LRsim(m,p,k,s)$X
  }

  # Recover low-d components
  z = princomp(x)
  
  # Set the first k components to 1, otherwise 0
  if (p-k < 0){
    u = rep(10,p) #rnorm(p,mean=1,sd=0.5)
  } else {
    u = c(rep(10,k),matrix(0,nrow=1,ncol=p-k))
  }
  
  # Calculate the weights in the data space
  b = t(u %*% t(z$loadings))
  
  # In case we needed to set m=p for the 
  # PCA to work, take the first n observations
  # of x
  x = x[1:n,]
  
  # Generate your output
  y = x %*% b + rnorm(n)
  
  return(list(X=x, Y=y, B=b))
}

n = 500
p = 20
k = 10
s = 20
data = make_data(n,p,k,s)
summary(lm(Y~X, data=data))

heatmap.2(cor(data$X),col=brewer.pal(11,"RdBu"), trace="none", 
          key.title = NA, key.ylab = NA, key.xlab = "Correlation")

k = p 
data = make_data(n,p,k,s)
heatmap.2(cor(data$X),col=brewer.pal(11,"RdBu"), trace="none", 
          key.title = NA, key.ylab = NA, key.xlab = "Correlation")

## ------------------------------
# LM split validation function
## ------------------------------
bv_lm <- function(n, degree, k, s) {
    # Set up the arrays for storing the results
    train_rss = matrix(data=NA,nrow=degree,ncol=1)
    test_rss = matrix(data=NA,nrow=degree,ncol=1)
    p_max = degree[length(degree)]

    # Loop through for each set of p-features
    for (p in degree) {
        # Set up the data, split into training and test
        # sets of size n
        data = make_data(n*2,p_max,k,s)

        train = list(X=data$X[1:n,1:p],Y = data$Y[1:n])
        test = list(X=data$X[(n+1):nrow(data$X),1:p],Y = data$Y[(n+1):nrow(data$X)])

        # Use simple GLM
        lm.fit = lm(Y ~ X, data=train) #, subset=set_id)
    
        # Get your model prediction on both the training
        # and test sets
        yhat_train = predict(lm.fit)
        yhat_test  = predict(lm.fit, newdata=test)

        # Because we get weird outlier predictions plot median sum square error
        train_rss[p-degree[1]+1] = median((train$Y - yhat_train)^2)
        test_rss[p-degree[1]+1] = median((test$Y - yhat_test)^2)
    }
  
    # Store the RSS in a data frame
    out = data.frame(p=degree, train=train_rss, test=test_rss)
}

n = 500
k = 10 
s = 20
degree = seq(2,20)

bv_df = bv_lm(n,degree,k, s)

ggplot(bv_df, aes(x=p)) +
  geom_line(aes(y = test), color = "darkred") +
  ylab("Median sum squared error") + xlab("p")

options(warn=-1)

# Parameters
n_iter = 2000
n = 500
k = 10 
s = 20
degree = seq(2,20)

# Aggregated output
train_rss = matrix(data=NA,nrow=length(degree),ncol=n_iter)
test_rss = matrix(data=NA,nrow=length(degree),ncol=n_iter)

# Loop through n_iter times
for (i in 1:n_iter) {
  bv_df = bv_lm(n,degree,k,s)
  train_rss[,i]=bv_df$train
  test_rss[,i] =bv_df$test
}

# Make a new data frame for plotting
run_df = data.frame(p=degree, train=rowMeans(train_rss), test=rowMeans(test_rss),
                    strain=rowSds(train_rss), stest=rowSds(test_rss))

# Plot
ggplot(run_df, aes(x=p)) +
  geom_line(aes(y = test), color = "darkred") +
  geom_line(aes(y = train), color="steelblue", linetype="twodash") +
   ylab("Median sum squared error") + xlab("p") 

