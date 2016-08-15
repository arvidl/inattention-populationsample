# explorative_data_analysis_20160208.R
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

# This package is very old and seems buggy
# library(EnQuireR)

# Plotting Likert Scales
# http://statistical-research.com/plotting-likert-scales/
  
# library(survey)

# Plotting Likert Scales | R-bloggers
# http://www.r-bloggers.com/plotting-likert-scales/

# Plotting Likert-Scales (net stacked distributions) with ggplot #rstats – Strenge Jacke!
# https://strengejacke.wordpress.com/2013/07/17/plotting-likert-scales-net-stacked-distributions-with-ggplot-rstats/

# likert R package
# https://cran.r-project.org/web/packages/likert/likert.pdf

# R: Likert-scale data
# http://www.robjhyndman.com/Rfiles/monash/html/likert.html

# data visualization - Visualizing Likert responses using R or SPSS - Cross Validated
# http://stats.stackexchange.com/questions/25109/visualizing-likert-responses-using-r-or-spss

# Plotting Likert data in R
# http://www.jstatsoft.org/article/view/v057i05/v57i05.pdf

# [R Scripts] Visualising Likert Scale Responses Using likert — Lighton Phiri
# http://lightonphiri.org/blog/r-scripts-visualising-likert-scale-responses-using-likert

D <- D0
D$averBinned <- D3$averBinned
str(D)

# Use only categorical variables
C <- subset(D, select = -c(academic_achievement)) 
str(C)
summary(C)
C_Girl <- C[ which(C$gender=='Girl'),]
str(C_Girl)
summary(C_Girl)
C_Boy <- C[ which(C$gender=='Boy'),]
str(C_Boy)
summary(C_Boy)
SNAP <- subset(C, select = -c(gender, grade, averBinned))
SNAP_Girl <-  subset(C_Girl, select = -c(gender, grade, averBinned))
SNAP_Boy <-  subset(C_Boy, select = -c(gender, grade, averBinned))
GENDER <- subset(C, select = c(gender)) 
ACHIEVE <- subset(C, select =c(averBinned))
ACHIEVE_Girl <- subset(C_Girl, select =c(averBinned))
ACHIEVE_Boy <- subset(C_Boy, select =c(averBinned))

library(likert)
snap1to9 <- likert(SNAP)
print(summary(snap1to9))
likert1 <- plot(snap1to9)
pdf("../manuscript/Figs/likert_snap1to9.pdf")
print(likert1)
dev.off()
print(likert1)

snap1to9_Girl <- likert(SNAP_Girl)
print(summary(snap1to9_Girl))
likert1_Girl <- plot(snap1to9_Girl)
pdf("../manuscript/Figs/likert_snap1to9_Girl.pdf")
print(likert1_Girl)
dev.off()
print(likert1_Girl)

snap1to9_Boy <- likert(SNAP_Boy)
print(summary(snap1to9_Boy))
likert1_Boy <- plot(snap1to9_Boy)
pdf("../manuscript/Figs/likert_snap1to9_Boy.pdf")
print(likert1_Boy)
dev.off()
print(likert1_Boy)

gender_boy_girl <- likert(GENDER)
likert2 <- plot(gender_boy_girl)
pdf("../manuscript/Figs/likert_gender_boy_girl.pdf")
print(likert2)
dev.off()
print(likert2)

achievement <- likert(ACHIEVE)
likert3 <- plot(achievement)
pdf("../manuscript/Figs/likert_achievement.pdf")
print(likert3)
dev.off()
print(likert3)




# Continuous mean grades
# As continuous variable
library(plyr)
library(ggplot2)
mD0 <- ddply(D0, "gender", summarise, ave.mean=mean(academic_achievement))
print(mD0)
gg1 <- ggplot(D0, aes(x=academic_achievement, fill=gender)) + geom_density(alpha=.3) +
    geom_vline(data=mD0, aes(xintercept=ave.mean,  colour=gender),
               linetype="dashed", size=1) +
    labs(
    title = "Distribution of mean academic achievement for boys and girls",
    x = "Mean value of grades during high school",
    y = "Density") +
  theme(
    axis.text = element_text(size = 16),
    plot.title = element_text(size = 14, vjust = 2))
plot(gg1)
pdf("../manuscript/Figs/ave_grade_density_vs_gender_20160208.pdf", width = 6, height = 4)
plot(gg1)
dev.off()

hist(D0$academic_achievement)

