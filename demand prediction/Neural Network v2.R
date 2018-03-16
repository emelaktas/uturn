set.seed(1234)
# load library
library(neuralnet)

# read data
data <- read.table(file = "~/Library/Mobile Documents/com~apple~CloudDocs/backup/Research/u-turn/dissemination/INFORMS Business Analytics Conference/Input Data v2.csv", sep = ",", header = T)

# check data
head(data)
dim(data)
str(data)

# divide data into train and test sets
index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]

dim(train)
head(train)

test <- data[-index,]
dim(test)
head(test)

### GENERALISED LINEAR MODEL ###

# Selected on the basis of R2
lm.fit1 <- glm(Orders ~ Males + Females + Store + SchoolChild + Area + AB + C1 + C2 + DE, data=train)

# Model
summary(lm.fit1)

# R2 equivalent
1 - summary(lm.fit1)$deviance/summary(lm.fit1)$null.deviance


# Predict using fitted model
pr.lm1 <- predict(lm.fit1,test)

# mean squared error
MSE.lm1 <- sum((pr.lm1 - test$Orders)^2)/nrow(test)

# mean absolute percentage error
MAPE.lm1 <- mean(abs(test$Orders - pr.lm1)/test$Orders)

# volume weighted mean absolute percentage error
WMAPE.lm1 <- sum(abs(test$Orders - pr.lm1)) / sum(test$Orders)

# see all error figures together
error.lm1 <- c('MSE' = MSE.lm1, 'MAPE' = MAPE.lm1, 'WMAPE' = WMAPE.lm1)
round(error.lm1,3)


### NEURAL NETWORK ###

head(data)

# min-max scaling
data1 <- data[c('Orders', 'PostcodesOrdering', 'AllResidents', 'Store', 'Males', 'Females', 'LivesHousehold', 'LivesCommunal', 'SchoolChild', 'Area', 'Social', 'AB', 'C1', 'C2', 'DE')]
head(data1)
maxs <- apply(data1, 2, max) 
mins <- apply(data1, 2, min)

scaled <- as.data.frame(scale(data1, center = mins, scale = maxs - mins))
head(scaled)

summary(scaled)

# Allocate train and test sets
train_ <- scaled[index,]
dim(train_)
head(train_)
test_ <- scaled[-index,]
head(test_)

# NN formula
f1 <- as.formula(paste('Orders ~ Males + Females + Store + SchoolChild + Area + AB + C1 + C2 + DE'))

# NN
nn1 <- neuralnet(f1,data=train_,hidden=c(3,1),linear.output=F)

# Prediction with NN
pr.nn1 <- compute(nn1,test_[c('Males', 'Females', 'Store', 'SchoolChild', 'Area', 'AB', 'C1', 'C2', 'DE')])

# Scale back to original
pr.nn1_ <- pr.nn1$net.result*(max(data1$Orders)-min(data1$Orders))+min(data1$Orders)

test.r1 <- (test_$Orders)*(max(data1$Orders)-min(data1$Orders))+min(data1$Orders)

MSE.nn1 <- sum((test.r1 - pr.nn1_)^2)/nrow(test_)
MAPE.nn1 <- mean(abs(test.r1-pr.nn1_)/test.r1)
WMAPE.nn1 <- sum(abs(test.r1 - pr.nn1_)) /sum(test.r1)

error.nn1 <- c('MSE' = MSE.nn1, 'MAPE' = MAPE.nn1, 'WMAPE' = WMAPE.nn1)
error.nn1
error.lm1	

# visual representation of NN
plot(nn1)




par(mfrow=c(1,2))


plot(test$Orders,pr.lm1,col='blue',main='Real vs Predicted LM',pch=18, cex=0.7, xlab='Actual', ylab = 'Predicted')
abline(0,1,lwd=2)
legend('bottomright',legend='LM',pch=18,col='blue', bty='n', cex=.95)
plot(test$Orders,pr.nn1_,col='red',main='Real vs Predicted NN',pch=18,cex=0.7,xlab='Actual', ylab = 'Predicted')
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')


### CROSS VALIDATION ###

library(boot)

set.seed(450)
WMAPE.cv.nn <- NULL
WMAPE.cv.lm <- NULL
k <- 50 # 50 samples

library(plyr) 

# Produce progress bar
pbar <- create_progress_bar('text')
pbar$init(k)

for(i in 1:k){
    index <- sample(1:nrow(data),round(0.9*nrow(data)))
    train.cv <- scaled[index,c('Orders', 'Males', 'Females', 'Store', 'SchoolChild', 'Area', 'AB', 'C1', 'C2', 'DE')]
    test.cv <- scaled[-index,c('Orders', 'Males', 'Females', 'Store', 'SchoolChild', 'Area', 'AB', 'C1', 'C2', 'DE')]
    
    nn <- neuralnet(f1,data=train.cv,hidden=c(3,1),linear.output=F)

    pr.nn <- compute(nn,test.cv[c('Males', 'Females', 'Store', 'SchoolChild', 'Area', 'AB', 'C1', 'C2', 'DE')])
    pr.nn <- pr.nn$net.result*(max(data$Orders)-min(data$Orders))+min(data$Orders)
    
    test.cv.r <- (test.cv$Orders)*(max(data$Orders)-min(data$Orders))+min(data$Orders)
    
    WMAPE.cv.nn[i] <- sum(abs(test.cv.r - pr.nn)*test.cv.r)/sum(test.cv.r*test.cv.r)
    
    
    lm.cv.fit1 <- glm(Orders ~ Males + Females + Store + SchoolChild + Area + AB + C1 + C2 + DE, data=train.cv)
    
    pr.cv.lm1 <- predict(lm.cv.fit1,test.cv)
    WMAPE.cv.lm[i] <- sum(abs(test.cv$Orders - pr.cv.lm1)) / sum(test.cv$Orders)
    
    pbar$step()
}


# Boxplots of errors with LM and NN
par(mfrow=c(2,1))
boxplot(WMAPE.cv.lm,xlab='WMAPE',col='cyan', border='blue', main='Cross Validated WMAPE for LM',horizontal=TRUE, ylim = c(0,1))

boxplot(WMAPE.cv.nn,xlab='WMAPE',col='cyan', border='blue', main='Cross Validated WMAPE for NN',horizontal=TRUE, ylim = c(0,1))
