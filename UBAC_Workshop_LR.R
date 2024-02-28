# Load the data
Default <- read.csv("Default.csv", stringsAsFactors = TRUE)
# Recall main properties
str(Default)

# Count occurrences of each class
table(Default$defaulted)

# Verify current levels
levels(Default$defaulted)
# Encode "No" as 0 and "Yes" as 1
# If you don't understand check each step separately
Default$defaulted <- 1*(Default$defaulted=="Yes")

# Estimate linear regression
linear.model <- lm(defaulted ~ balance, data = Default)
# Visualise data
plot(Default$balance, Default$defaulted)
# Visualise fitted linear regresion 
abline(linear.model, col="red")

summary(linear.model)

# Fit logistic regression model
log.model <- glm(defaulted ~ balance, data = Default, family = binomial)
# Summary of estimated logistic regression model
summary(log.model)

# First plot the observations (as points)
plot(Default$balance, Default$defaulted)
# To plot the estimated probability first define a vector x that 
# takes values in the range of the "balance" variable
x <- seq(from = min(Default$balance), to=max(Default$balance))
# obtain estimated coefficients using the coef() function
hat.beta <- coef(log.model)
hat.beta
# Estimate probabilities from Log. Regr. formula
lines(x, (1 + exp(-hat.beta[1] - hat.beta[2]*x))^(-1), col="blue")

# Compute the estimated probability of default for all the data in Default
probs <- predict(log.model, newdata = Default, type="response")

# Predict class 1 (i.e. default=Yes) if estimated probability > 0.5
class.pred <- 1*(probs > 0.5)
# Verify predictions
head(cbind(probs,class.pred), 10)

# Create truth table: Rows represents actual class, Column represents predicted
truth.table <- table(Default$defaulted, class.pred)
truth.table

# Total number of observations in truth.table
N <- sum(truth.table)
# Misclassification error
(truth.table[1,2]+ truth.table[2,1])/N
# Accuracy = Proportion of correct predictions
(truth.table[1,1]+ truth.table[2,2])/N

b0 <- signif(coef(log.model)[1],4)
b1 <- signif(coef(log.model)[2],2)

# First plot the observations (as points)
plot(Default$balance, Default$defaulted)
# Plot estimated probabilities
lines(x, (1 + exp(-hat.beta[1] - hat.beta[2]*x))^(-1), col="blue")
# Plot classification thresholod
# (straight "h"orizontal line) 
abline(h=0.5, col="green")
# Plot partition of input space
# (straight "v"ertical line) 
abline(v=-hat.beta[1]/hat.beta[2], col="red")

# Estimate logistic regression with 2 predictors
log.model2 <- glm(defaulted ~ balance + income, data=Default, family = binomial)
# model summary
summary(log.model2)

# Estimate probabilities of default 
probs2 <- predict(log.model2, data=Default, type="response")

b0 <- signif(coef(log.model2)[1],4)
b1 <- signif(coef(log.model2)[2],2)
b1 <- signif(coef(log.model2)[3],2)

# Scatterplot of income against balance using default to colour data
plot(Default$balance, Default$income, col = as.factor(Default$defaulted))
# Get estimated coefficients
hb <- coef(log.model2)
# Define straight line using intercept and slope
abline(a=-hb[1]/hb[3], b=-hb[2]/hb[3], col="blue")

# Scatterplot of income against balance using default to color data
plot(Default$balance, Default$income, col = as.factor(Default$defaulted))
# Get estimated coefficients
hb <- coef(log.model2)
# Decision boundary for threshold = 0.5 
abline(a=(-hb[1]-log(10/5-1))/hb[3], b=-hb[2]/hb[3], col="blue")
# Decision boundary for threshold = 0.1
abline(a=(-hb[1]-log(10/1-1))/hb[3], b=-hb[2]/hb[3], col="green")
# Decision boundary for threshold = 0.7
abline(a=(-hb[1]-log(10/7-1))/hb[3], b=-hb[2]/hb[3], col="red")
