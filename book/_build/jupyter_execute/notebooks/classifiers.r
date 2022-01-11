# Install the ISLR package (if you haven't yet) 
install.packages("ISLR")

# Load the library
library(ISLR)
library(ggplot2)

# Uncomment the line below if you want to learn more about the dataset
#help(Smarket)

# Let's take a look at the distribution of our variables
summary(Smarket)

# Next let's quantify all pairwise correlations as a first glimpse at the relationships among the variables 
cxy = cor(Smarket)

# Look at the column for Direction
head(Smarket$Direction)

# In order to see the correlation let's remove the Direction variable
cxy = cor(Smarket[,-which(colnames(Smarket)=="Direction")]) 
cxy

# Run the GLM
glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Smarket, family=binomial) # logistic regression 

# Summarize
summary(glm.fit)

# Plot the model fit evaluation images
par(mfrow=c(2,2))
plot(glm.fit)

# See how well the model captured the training set
glm_prob_df = data.frame(predict(glm.fit, type = "response"))
colnames(glm_prob_df) = c('predicted_prob')

num_observations = nrow(glm_prob_df)
glm_prob_df$index = seq(1, num_observations) #get the observation number for plotting; ggplot does not infer this

# Setting type="response" tells R to output prob. from P(Y=1,X) for all values of X
# "If no data set is supplied to the predict() function, then the probabilities 
# are computed for the training data that was used to fit the logistic regression model."

ggplot(glm_prob_df, aes(index, predicted_prob)) + geom_point() + xlab('observation number') + ylab('predicted response probability') 

contrasts(Smarket$Direction)

threshold = 0.50 #binarizing threshold 

# First make a list of "Downs"
glm_prob_df$predicted_binary=rep("Down",num_observations)

# Then use the probability output to label the up days. Let's use a threshold of 50% probability. 
glm_prob_df$predicted_binary[glm_prob_df$predicted_prob>threshold]="Up" #find the rows that have prob > threshold and cast as 'up'

# Now let's look at the prediction accuracy
confusion_df = data.frame(glm_prob_df$predicted_binary, Smarket$Direction)
colnames(confusion_df) = c('predicted', 'actual')

table(confusion_df)

# We can calculate the prediction accuracy by counting the number of times our
# prediction vector matched the real data and taking the average
print(paste("Accuracy:",mean(confusion_df$predicted == confusion_df$actual)))

# Let's isolate the years before 2005 to use as a training set to predict market change in 2005

# First create an index vector to find the entries corresponding to years < 2005
train_idx=(Smarket$Year<2005)


# Can now make a whole new Smarket dataset just for 2005 (it's the last year, so anything not train is 2005)
Smarket.2005_test = Smarket[!train_idx,] #find rows that do not (! = not) occupy the training data indices

dim(Smarket.2005_test) #get dimensions of the test data 

# Now let's extract the Direction for just 2005
Direction.2005_test=Smarket.2005_test$Direction

# Train the logistic model, but use only the subset of the data from pre-2005 (i.e., training data)
glm.fit=glm(Direction~Lag1+Lag2, data=Smarket, family=binomial, subset=train_idx) #give the training indices to the glm function 

# Predict the 2005 performance from the model trained on the pre-2005 data
glm.probs=predict(glm.fit, Smarket.2005_test, type="response")
glm.pred=rep("Down",nrow(Smarket.2005_test)) # There are only 252 observations in the test set.
glm.pred[glm.probs>0.5]="Up" #binarize the result


confusion_df = data.frame(glm.pred, Direction.2005_test) #create confusion df
colnames(confusion_df) = c('predicted', 'actual')

# Show the confusion matrix
table(confusion_df)

# Now let's look at the overall test accuracy
print(paste("Accuracy:",mean(confusion_df$predicted == confusion_df$actual)))

library(MASS)

# LDA syntax is just like for linear regression fitting 
# Let's conduct LDA on the training subset now
lda.fit = lda(Direction~Lag1+Lag2, data=Smarket, subset=train_idx)
lda.fit # The summary() function gives you something different
plot(lda.fit)

# Predict from your LDA coefficients
lda.pred = predict(lda.fit, Smarket.2005_test)

# We next extract the output of the prediction 
lda.class = lda.pred$class
table(lda.class, Direction.2005_test)
print(paste("Accuracy:",mean(lda.class==Direction.2005_test)))

head(lda.pred$posterior)

# Show the relationship between the Lag 1 variable 
# and the posterior probability from LDA

lag1_posterior_df = data.frame(Smarket.2005_test$Lag1, lda.pred$posterior[,1])
colnames(lag1_posterior_df) = c('lag1_return', 'down_posterior_prob')

ggplot(data=lag1_posterior_df, aes(lag1_return, down_posterior_prob)) + geom_point() + xlab('Return from one day ago') + ylab('Posterior probability of the stock going down')
#getting the lag 1 percentage return & the posterior prob. of the stock going down

ggplot(Smarket[train_idx,],aes(x=Lag1,y=Lag2)) + geom_point() + facet_grid(.~Direction)

print(paste("Covariance of Lag1, Lag2 for Up observations:",
  cov(Smarket$Lag1[train_idx][which(Smarket$Direction[train_idx]=="Up")],Smarket$Lag2[train_idx][which(Smarket$Direction[train_idx]=="Up")])))
print(paste("Covariance of Lag1, Lag2 for Down observations:",
  cov(Smarket$Lag1[train_idx][which(Smarket$Direction[train_idx]=="Down")],Smarket$Lag2[train_idx][which(Smarket$Direction[train_idx]=="Down")])))


# QDA is also part of the MASS library
qda.fit = qda(Direction~Lag1+Lag2, data=Smarket, subset=train_idx)
qda.fit

# Same basic predictions as LDA, just assuming that each distribution has its own variance. 
# But we work with coefficients the same way.
qda.class=predict(qda.fit, Smarket.2005_test)$class
table(qda.class, Direction.2005_test)
print(paste("Accuracy:",mean(qda.class==Direction.2005_test)))
