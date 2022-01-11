# Setup data set
n = 100
p = 40
sigma = 7 # Standard deviation of the noise term

# Generate X and Y
X = matrix(rnorm(n*p), n, p)
betas = runif(p, min = -1, max = 1)
Y = X %*% betas + rnorm(n, sd = sigma)

# Generate up a tuning and training set
tune_id <- sample(nrow(Y), 30)
tune_X <- X[tune_id,]
tune_Y <- Y[tune_id]

train_X <- X[-tune_id,]
train_Y <- Y[-tune_id]


# libraries
library(glmnet)

# First use all the data to find lambda
model.hacked = cv.glmnet(X, Y, family="gaussian", alpha=1)
plot(model.hacked)
lambda_hacked = model.hacked$lambda.min

# Now use only the tuning set
model.tune = cv.glmnet(tune_X, tune_Y, family="gaussian", alpha=1)
plot(model.tune)
lambda_tune = model.tune$lambda.min


print(lambda_hacked)
print(lambda_tune)

hacked.fit = glmnet(train_X, train_Y, family="gaussian", lambda=lambda_hacked, alpha=1)
tune.fit = glmnet(train_X, train_Y, family="gaussian", lambda=lambda_tune, alpha=1)

# The number of non-zero coefficients
n_hacked_params = sum(coef(hacked.fit)!=0)
n_tune_params = sum(coef(tune.fit)!=0)

# Model fits
hacked.rss = sum((train_Y - predict(hacked.fit,newx=train_X))^2)
tune.rss = sum((train_Y - predict(tune.fit,newx=train_X))^2)

hacked.pred = predict(hacked.fit, newx=train_X)
tune.pred = predict(tune.fit, newx=train_X)

plot(train_Y, hacked.pred)
hacked.cor = cor(train_Y, hacked.pred)
hacked.rss = sum((train_Y-hacked.pred)^2)


plot(train_Y, tune.pred)
tune.cor = cor(train_Y, tune.pred)
tune.rss = sum((train_Y-tune.pred)^2)




cat("hacked")
print(hacked.cor)
print(hacked.rss)

cat("\ntuned")
print(tune.cor)
print(tune.rss)

print(n_hacked_params)

# Permutation test
n_iterations = 1000
rss = matrix(NaN,nrow=n_iterations,ncol=1)

for (i in 1:n_iterations){
    p2use = sample(1:p)[1:n_hacked_params]
    new_X = train_X[,p2use]
    glm.fit = glm(train_Y~new_X, family="gaussian")
    rss[i] = sum(glm.fit$residuals^2)
 }

hist(rss)
abline(v=hacked.rss, col="red")
abline(v=tune.rss, col="blue")


print(mean(rss<hacked.rss))
print(mean(rss<tune.rss))

