#install.packages("ISLR")
library(ISLR)

# INSERT CODE HERE


cred_lm  <- lm(Balance ~ Limit + Rating + Age + Gender + Student, Credit)
summary(cred_lm)

sigma(cred_lm)

# INSERT CODE HERE
# Calculate SSE


# Extract n


# Extract p


# INSERT CODE HERE


# Test and compare results. 

your_function(cred_lm) #Replace with your own function name
sigma(cred_lm)

cred_lm$coefficients

str(cred_lm)

# INSERT CODE HERE


# INSERT CODE HERE


# INSERT CODE HERE

