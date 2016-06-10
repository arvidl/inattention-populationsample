# ANN_20160211.R
# Arvid Lundervoild (c) 2016
# in ~/Dropbox/Arvid_Inattention/code2

# From data_prep_20160203.R:
# The original SPSS file as provided to AJL is
# 'inattention_Astri_94_96_new_grades_updated.sav'
# and being edited and reduced by AJL to 'inattention_Arvid_new.sav'
# Import data stored in the SPSS format
# library(memisc)
# fn <- "../data2/inattention_Arvid_new.sav"
# data <- as.data.set(spss.system.file(fn))

# Save the nomis D to an .csv file without row names for further analysis
# write.csv(D, file = "../data2/inattention_nomiss_2397x12_20160205.csv",row.names=FALSE)
D0 <- read.csv("../data2/inattention_nomiss_2397x12_20160205.csv")

# Save D (at early stage) to .csv file for analysis in e.g. MATLAB 
# write.csv(D, file = "../data2/inattention_nomiss_snap_is_012_20160203.csv",row.names=FALSE)
D1 <- read.csv("../data2/inattention_nomiss_snap_is_012_20160203.csv")

# Save the new D to an .csv file without row names for further analysis
# write.csv(D, file = "../data2/inattention_nomiss_snap_is_01_20160203.csv",row.names=FALSE)
D2 <- read.csv("../data2/inattention_nomiss_snap_is_01_20160203.csv")

# Save the dataset C with binary SNAP predictors and trinary outcome to an .csv file for further analysis
# write.csv(C, file = "../data2/inattention_nomiss_snap_is_01_outcome_is_low_medium_high_20160203.csv",row.names=FALSE)
D3 <- read.csv("../data2/inattention_nomiss_snap_is_01_outcome_is_low_medium_high_20160203.csv")

# Save the dataset C with binary SNAP predictors and trinary outcome to an .csv file for further analysis
# write.csv(C, file = "../data2/inattention_nomiss_snap_is_01_outcome_is_123_20160203.csv",row.names=FALSE)
D4 <- read.csv("../data2/inattention_nomiss_snap_is_01_outcome_is_123_20160203.csv")

# Encoding of catagory variables:
# " ... Use 1-of-N encoding. For example if you once again have the 'small', 'medium' and 'large' 
# categories you could say 'small' = [1 0 0], 'medium' = [0 1 0], 'large' = [0 0 1]. 
# The 1-of-N encoding 'red' = [1 0 0], 'green' = [0 1 0], 'blue'= [0 0 1], should not have this problem.

# http://stats.stackexchange.com/questions/21770/encoding-categorical-features-to-numbers-for-machine-learning
# Many machine learning algorithms, for example neural networks, expect to deal with numbers. 
# So, when you have a categorical data, you need to convert it. By categorical I mean, for example:
# 
#  Car brands: Audi, BMW, Chevrolet... User IDs: 1, 25, 26, 28...
#
# Even though user ids are numbers, they are just labels, and do not mean anyting in terms of 
# continuity, like age or sum of money.
#
# So, the basic approach seems to use binary vectors to encode categories:
#  
#  Audi: 1, 0, 0... BMW: 0, 1, 0... Chevrolet: 0, 0, 1...
#
# It's OK when there are few categories, but beyond that it looks a bit inefficient. 
# For example, when you have 10 000 user ids to encode, it's 10 000 features.
#
# You can always treat your user ids as bag of words: most text classifiers can deal with 
# hundreds of thousands of dimensions when the data is sparse (many zeros that you do not 
# need to store explicitly in memory, for instance if you use Compressed Sparse Rows 
# representation for your data matrix).
#
# You could also perform clustering of your raw user vectors and use the top N closest centers 
# ids as activated features for instead of the user ids.

# Encoding:
#   ===========
#   
# Output: The output encoding is a 1-of-3 encoding as follows:
#   low: 1 0 0  medium: 0 1 0  high: 0 0 1
# Input:  Each n-valued nominal input is represented by a 1-of-n encoding
# using n input values. The relevant input is 1, others are 0.
# We thus have 32 input values to the network:
#   
# 2  1. gender -   girl: 1 0   boy: 0 1 
# 
# 3  2. grade - 2: 1 0 0   3: 0 1 0   4: 0 0 1
# 
# 3  3. snap1 - 0:  1 0 0  1: 0 1 0   2: 0 0 1
# 3  4. snap2
# 3  5. snap3
# 3  6. snap4
# 3  7. snap5
# 3  8. snap6
# 3  9. snap7
# 3 10. snap8
# 3 11. snap9 - 0:  1 0 0  1: 0 1 0   2: 0 0 1
# ---
# 32



# --------
# Ideas from http://www.r-bloggers.com/fitting-a-neural-network-in-r-neuralnet-package
# https://gist.github.com/mick001/49fad7f4c6112d954aff
# neuralnetR.R

data <- D4

# Use Likert scale with three levels (not collapsing to two) 
# APROPOS:
# - should actually be five (https://en.wikipedia.org/wiki/Likert_scale)
# When responding to a Likert questionnaire item, respondents specify their level of agreement 
# or disagreement on a symmetric agree-disagree scale for a series of statements. 
# Thus, the range captures the intensity of their feelings for a given item.
# The format of a typical five-level Likert item, for example, could be:
# 1 Strongly disagree
# 2 Disagree
# 3 Neither agree nor disagree
# 4 Agree
# 5 Strongly agree
# Likert scaling is a bipolar scaling method, measuring either positive or negative response to a statement.

for(i in 1:9){
  cmd = sprintf("data$snap%d <- D1$snap%d", i, i)
  # print(cmd)
  eval(parse(text=cmd))
}


# Check that no datapoint is missing
apply(data,2,function(x) sum(is.na(x)))


# Replace the numerical catagory data in the aveBinned field with a string
data$averBinned[data$averBinned==1] <- "low"
data$averBinned[data$averBinned==2] <- "medium"
data$averBinned[data$averBinned==3] <- "high"

# Randomly splitting the data into a train and a test set
index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]



# The caret package (short for classification and regression training) contains functions to 
# streamline the model training process for complex regression and classification problems. 
# The package utilizes a number of R packages but tries not to load them all at package 
# start-up. The package “suggests” field includes 27 packages. caret loads packages as 
# needed and assumes that they are installed.
library(caret)

# The function createDataPartition can be used to create a stratified random sample 
# of the data into training and test sets. Simple bootstrap resampling is used by default.


# Functions and Datasets from J. Fox and S. Weisberg, An R Companion to Applied Regression, 
# Second Edition, Sage, 2011.
library(car)

set.seed(998)
trainIndex <- createDataPartition(data$averBinned, p=.75, list=F)
data.train <- data[trainIndex, ]
data.test <- data[-trainIndex, ]


# Train the ANN model on the training set (caret package)
# check: to http://cran.r-project.org/web/packages/nnet/nnet.pdf, and
# http://topepo.github.io/caret/training.html
# The function train() sets up a grid of tuning parameters for a number of 
# classification and regression routines, fits each model and calculates 
# a resampling based performance measure.
# method - a string specifying which classification or regression model to use
# see http://topepo.github.io/caret/bytag.html

# The function trainControl can be used to specifiy the type of resampling
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

# For these caret models, train can automatically create a grid of tuning parameters. 
# By default, if p is the number of tuning parameters, the grid size is 3^p.
my.grid <- expand.grid(.decay = c(0.7, 0.5, 0.1), .size = c(2, 3, 4, 5))

# Neural Network
# method = 'nnet'
# Type: Classification, Regression
# Tuning Parameters: size (#Hidden Units), decay (Weight Decay)
  
data.nnet.fit <- train(averBinned ~. , data = data.train,
                  method = "nnet", 
                  maxit = 1000,
                  trControl = fitControl,
                  tuneGrid = my.grid, 
                  trace = F, 
                  linout = 1)  

print(data.nnet.fit)

trellis.par.set(caretTheme())
plot(data.nnet.fit)


# Call predict on the fitted object using the test data set 
data.predict <- predict(data.nnet.fit, newdata = data.test)

# Assess confusion matrix
cm.nnet.fit <- confusionMatrix(data.predict, data.test$averBinned)

print(cm.nnet.fit)

# ----------------------------------------------------------
# # Fit a linear regression model and test it on the test set. 
# lm.fit <- glm(averBinned~., data=train)
# summary(lm.fit)
# 
# # Predicted data from lm
# pr.lm <- predict(lm.fit,test)
# 
# # Test MSE
# MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)
# 
# 
# 
# #-------------------------------------------------------------------------------
# # Neural net fitting
# # Normalize the data before training the neural network,
# # using the min-max method and scale the data in the interval [0,1]
# 
# maxs <- apply(data, 2, max) 
# mins <- apply(data, 2, min)
# scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
# 
# # Train-test split
# train_ <- scaled[index,]
# test_ <- scaled[-index,]
# 
# # We are going to use 2 hidden layers with this configuration: 11:5:3:1
# library(neuralnet)
# n <- names(train_)
# f <- as.formula(paste("averBinned ~", paste(n[!n %in% "averBinned"], collapse = " + ")))
# nn <- neuralnet(f,data=train_,hidden=c(5,3),linear.output=T)
# 
# # Visual plot of the model
# plot(nn)
# 
# # Predicting averBinned using the neural network
# pr.nn <- compute(nn,test_[,1:11])
# 
# # Results from NN are normalized (scaled)
# # Descaling for comparison
# pr.nn_ <- pr.nn$net.result*(max(data$averBinned)-min(data$averBinned))+min(data$averBinned)
# test.r <- (test_$averBinned)*(max(data$averBinned)-min(data$averBinned))+min(data$averBinned)
# 
# # Calculating MSE
# MSE.nn <- sum((test.r - pr.nn_)^2)/nrow(test_)
# 
# # Compare the two MSEs
# print(paste(MSE.lm,MSE.nn))
# 
# # Plot predictions
# par(mfrow=c(1,2))
# 
# plot(test$averBinned,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
# abline(0,1,lwd=2)
# legend('bottomright',legend='NN',pch=18,col='red', bty='n')
# 
# plot(test$averBinned,pr.lm,col='blue',main='Real vs predicted lm',pch=18, cex=0.7)
# abline(0,1,lwd=2)
# legend('bottomright',legend='LM',pch=18,col='blue', bty='n', cex=.95)
# 
# # Compare predictions on the same plot
# plot(test$averBinned,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
# points(test$averBinned,pr.lm,col='blue',pch=18,cex=0.7)
# abline(0,1,lwd=2)
# legend('bottomright',legend=c('NN','LM'),pch=18,col=c('red','blue'))
# 
# 
# #-------------------------------------------------------------------------------
# # Cross validating
# # train-test split:
# #  - Do the train-test split
# #  - Fit the model to the train set
# #  - Test the model on the test set
# #  - Calculate the prediction error
# #  - Repeat the process K times
# 
# # splitting the data in this way: 9
# # 0% train set and 10% test set in a random way for 10 times.
# 
# library(boot)
# set.seed(200)
# 
# # Linear model cross validation
# lm.fit <- glm(averBinned~.,data=data)
# cv.glm(data,lm.fit,K=10)$delta[1]
# 
# # Neural net cross validation
# set.seed(450)
# cv.error <- NULL
# k <- 10
# 
# # Initialize progress bar
# library(plyr) 
# pbar <- create_progress_bar('text')
# pbar$init(k)
# 
# for(i in 1:k){
#   index <- sample(1:nrow(data),round(0.9*nrow(data)))
#   train.cv <- scaled[index,]
#   test.cv <- scaled[-index,]
#   
#   nn <- neuralnet(f,data=train.cv,hidden=c(5,2),linear.output=T)
#   
#   pr.nn <- compute(nn,test.cv[,1:11])
#   pr.nn <- pr.nn$net.result*(max(data$averBinned)-min(data$averBinned))+min(data$averBinned)
#   
#   test.cv.r <- (test.cv$medv)*(max(data$averBinned)-min(data$averBinned))+min(data$averBinned)
#   
#   cv.error[i] <- sum((test.cv.r - pr.nn)^2)/nrow(test.cv)
#   
#   pbar$step()
# }
# 
# # Average MSE
# mean(cv.error)
# 
# # MSE vector from CV
# cv.error
# 
# 
# # Visual plot of CV results
# boxplot(cv.error,xlab='MSE CV',col='cyan',
#         border='blue',names='CV error (MSE)',
#         main='CV error (MSE) for NN',horizontal=TRUE)
# 
# # -------------------
# 
# # Build your own neural network classifier in R | R-bloggers
# # http://www.r-bloggers.com/build-your-own-neural-network-classifier-in-r/
# 
# # Predicting wine quality using Random Forests | R-bloggers
# # http://www.r-bloggers.com/predicting-wine-quality-using-random-forests/
# 
# # Seeing the Forest and the Trees – a parallel machine learning example | R-bloggers
# # http://www.r-bloggers.com/seeing-the-forest-and-the-trees-a-parallel-machine-learning-example/
# 
# 
# # Adopted from http://www.r-bloggers.com/fitting-a-neural-network-in-r-neuralnet-package
# # neuralnetR.R
# # 
# # 
# # with(XYd, table(Gender, AverageMarksLevel123))
# # 
# # data <- XYd
# # str(data)
# # head(data)
# # 
# # set.seed(500)
# # 
# # # First we need to check that no datapoint is missing, otherwise we need to fix the dataset.
# # apply(data,2,function(x) sum(is.na(x)))
# # 
# # # There is no missing data, good. We proceed by randomly splitting the data into 
# # # a train and a test set, then we fit a linear regression model and test it on 
# # # the test set. Note that I am using the gml() function instead of the lm() this 
# # # will become useful later when cross validating the linear model.
# # 
# # index <- sample(1:nrow(data),round(0.75*nrow(data)))
# # train <- data[index,]
# # test <- data[-index,]
# # lm.fit <- glm(medv~., data=train)
# # summary(lm.fit)
# # pr.lm <- predict(lm.fit,test)
# # MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)
# 
# 
# # # lm is used to fit linear models.
# # D.lm.1 <- lm(AverageMarks ~ Gender+Grade +
# #                  SNAP1+SNAP2+SNAP3+SNAP4+SNAP5+SNAP6+SNAP7+SNAP8+SNAP9,
# #                  data = D)
# # # anova(D.lm.1)
# # summary(D.lm.1)
# # 
# # library(texreg)
# # texreg(D.lm.1)
# # 
# # library(stargazer)
# # stargazer(D.lm.1)
# # 
# # library(xtable)
# # xtable(D.lm.1)
# # stargazer(anova(D.lm.1))
# # 
# # #library(memisc)
# # #toLatex(mtable(D.lm.1))
# # 
# # # D.glm.1 <- glm(AverageMarks ~ Gender+Grade +
# # #             SNAP1+SNAP2+SNAP3+SNAP4+SNAP5+SNAP6+SNAP7+SNAP8+SNAP9,
# # #                family = gaussian, data = D)
# # # anova(D.glm.1)
# # # summary(D.glm.1)
# 
