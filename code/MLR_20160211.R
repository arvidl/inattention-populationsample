# MLR_20160211.R
# Arvid Lundervoild (c) 2016
# in ~/Dropbox/Arvid_Inattention/code2
#  continued from from Multinomial_Logistic_Regression_20151210.R
# See e.g. http://www.ats.ucla.edu/stat/r/dae/mlogit.htm
# and ml <- read.dta("http://www.ats.ucla.edu/stat/data/hsbdemo.dta")
# Multinomial logistic regression is used to model nominal outcome variables,
# in which the log odds of the outcomes are modeled as a linear combination 
# of the predictor variables.
# See also: Agresti_Foundations_of_Linear_and_Generalized_Linear_Models_Wiley_2015.pdf (Chap.6)
# To report statistical results using R, e.g. MLR see
# Andy Field et al.  Discovering Statistics Using R. Sage Publishing 2012.
# http://studysites.uk.sagepub.com/dsur/main.htm and R code in
# http://studysites.uk.sagepub.com/dsur/study/scriptfi.htm

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

# SIDESTEP: Randomly splitting the data into a train and a test set
index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]

# Fit a linear regression model and test it on the test set. 
# lm.fit <- glm(averBinned~., data=train)
# summary(lm.fit)


# Before running our model. We then choose the level of our outcome that we wish 
# to use as our baseline and specify this in the relevel function. 
# Then, we run our model using multinom.

library(nnet)
data$AverageMarksLevel3 <- relevel(factor(data$averBinned), ref = "2")   # ref = "high"
test <- multinom(AverageMarksLevel3 ~ 
                   gender+grade +
                   snap1+snap2+snap3+snap4+snap5+snap6+snap7+snap8+snap9,
                   data = data)
summary(test)
z <- summary(test)$coefficients/summary(test)$standard.errors
# 2-tailed z test
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p

## extract the coefficients from the model and exponentiate
c <- exp(coef(test))


# You can also use predicted probabilities to help you understand the model. 
# Calculate predicted probabilities for each of the outcome levels using 
# the fitted function. We can start by generating the predicted probabilities 
# for the observations in our dataset and viewing the first few rows
head(pp <- fitted(test))

# Fore easy input to LaTeX:
library(stargazer)
stargazer(test)
stargazer(p)
stargazer(c)



# Using an alternative implementation of MLR - mlogit
library(mlogit)

# We need to modify the data so that the multinomial logistic regression
# function can process it. To do this, we need to expand the outcome variable
# (y) much like we would for dummy coding a categorical variable for
# inclusion in standard multiple regression.
data1 <- data
data1$averBinned <- as.factor(data1$averBinned)
summary(data1)
data2 <- mlogit.data(data1, varying=NULL, choice="averBinned", shape="wide")
head(data2)

# Now we can proceed with the multinomial logistic regression analysis using
# the ‘mlogit’ function and the ubiquitous ‘summary’ function of the results.
# Note that the reference category is specified as “high” (2, where the levels are 0,1,2).
model.1 <- mlogit(averBinned ~ 1 | gender+grade +
                    snap1+snap2+snap3+snap4+snap5+snap6+snap7+snap8+snap9,
                    data = data2,
                    reflevel="2")    # reflevel = "high")
summary(model.1)

b <- exp(coef(model.1))
summary(b)
