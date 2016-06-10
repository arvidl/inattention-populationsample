# data_prep_20160205.R
# Arvid Lundervoild (c) 2016
# in ~/Dropbox/Arvid_Inattention/code2

# The original SPSS file as provided to AJL is
# 'inattention_Astri_94_96_new_grades_updated.sav'
# and being edited and reduced by AJL to 'inattention_Arvid_new.sav'
# Import data stored in the SPSS format
library(memisc)
fn <- "../data2/inattention_Arvid_new.sav"
data <- as.data.set(spss.system.file(fn))

# Make new data frame from the sample with the variables 
# gender, grade, SNAP1, ..., SNAP9 (vars #1-11) and
# academic_achievement (var #52) 
names(data)
d <- data[, c(1:11, 52)]
dim(d)
names(d)
str(d)
summary(d)

# Get observations of data frame that have missing values and those with complete cases
d.miss <- d[!complete.cases(d),]
d.nomiss <- d[complete.cases(d),]
str(d.nomiss)
summary(d.nomiss)

# In the following, we let *D <- d.nomiss* be the dataset we are working with, i.e.
D <- d.nomiss
D3 <- d.nomiss # dummy copy

# Save the nomis D to an .csv file without row names for further analysis
write.csv(D, file = "../data2/inattention_nomiss_2397x12_20160205.csv",row.names=FALSE)


# For simplicity, we rename (and translate) the variables names in the dataset D without any missing
library(plyr)
D <- rename(D, c(academic_achievement="ave"))
D$snap1 <- mapvalues(as.factor(D$snap1), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap1 <- as.numeric(D$snap1)-1
D$snap2 <- mapvalues(as.factor(D$snap2), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap2 <- as.numeric(D$snap2)-1
D$snap3 <- mapvalues(as.factor(D$snap3), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap3 <- as.numeric(D$snap3)-1
D$snap4 <- mapvalues(as.factor(D$snap4), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap4 <- as.numeric(D$snap4)-1
D$snap5 <- mapvalues(as.factor(D$snap5), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap5 <- as.numeric(D$snap5)-1
D$snap6 <- mapvalues(as.factor(D$snap6), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap6 <- as.numeric(D$snap6)-1
D$snap7 <- mapvalues(as.factor(D$snap7), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap7 <- as.numeric(D$snap7)-1
D$snap8 <- mapvalues(as.factor(D$snap8), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap8 <- as.numeric(D$snap8)-1
D$snap9 <- mapvalues(as.factor(D$snap9), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","2"))
D$snap9 <- as.numeric(D$snap9)-1
D$gender <- mapvalues(as.factor(D$gender), from = c("Girl", "Boy"), to = c("0", "1"))
D$gender <- as.numeric(D$gender)-1
str(D)

# Save D (at early stage) to .csv file for analysis in e.g. MATLAB 
write.csv(D, file = "../data2/inattention_nomiss_snap_is_012_20160203.csv",row.names=FALSE)


# For simplicity, we rename (and translate) the variables names in the dataset D 
# For even more simplicity, we rename (and translate) the variables names in the dataset without any missing,
# reducing the predictor categories to be binar, i.e. collpsing "1" and "2" to "1":
library(plyr)
D <- D3
D <- rename(D, c(academic_achievement="ave"))
D$snap1 <- mapvalues(as.factor(D$snap1), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap2 <- mapvalues(as.factor(D$snap2), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap3 <- mapvalues(as.factor(D$snap3), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap4 <- mapvalues(as.factor(D$snap4), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap5 <- mapvalues(as.factor(D$snap5), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap6 <- mapvalues(as.factor(D$snap6), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap7 <- mapvalues(as.factor(D$snap7), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap8 <- mapvalues(as.factor(D$snap8), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$snap9 <- mapvalues(as.factor(D$snap9), from = c("Not true","Somewhat true","Certainly true"), to = c("0","1","1"))
D$gender <- mapvalues(as.factor(D$gender), from = c("Girl", "Boy"), to = c("0", "1"))
D$gender <- as.numeric(D$gender)-1
str(D)
summary(D)

# Save the new D to an .csv file without row names for further analysis
write.csv(D, file = "../data2/inattention_nomiss_snap_is_01_20160203.csv",row.names=FALSE)

# str(D3)
# summary(D3)
 
# and *DF* the corresponding data frame, i.e. DF <- data.frame(D); str(DF)


### Struture of the D dataset
# 
# ```{r fig.width=9, fig.height=4}
s <- dim(D)
n <- s[1]
p <- s[2]
txt = sprintf("Structure of the %d x %d DATASET", n, p)
print(txt)

library(DiagrammeR)

n_txt = sprintf("Dataset \n (N = %d)", n);
gviz <- grViz("
              # Circles: predictor variables; Triangle: Outcome variable

              digraph Structure_of_the_dataset_D {

              # node definitions with substituted label text
              node [fontname = Helvetica]
              1 [label = 'Dataset \n (N = 2397)', shape=box]
              2 [label = 'gender \n {Girl | Boy}', shape=circle]
              3 [label = 'grade \n {2 | 3 | 4}', shape=circle]
              4 [label = 'ave \n (average marks) \n [1, 6] or {low | medium | high}', shape=triangle]
              a [label = 'SNAP \n {0 | 1}', shape=oval]
              b [label = 'SNAP1', shape=circle]
              c [label = 'SNAP2', shape=circle]
              d [label = 'SNAP3', shape=circle]
              e [label = 'SNAP4', shape=circle]
              f [label = 'SNAP5', shape=circle]
              g [label = 'SNAP6', shape=circle]
              h [label = 'SNAP7', shape=circle]
              i [label = 'SNAP8', shape=circle]
              j [label = 'SNAP9', shape=circle]

              # edge definitions with the node IDs
              1 -> {2 3 a 4}
              a -> {b c d e f g h i j}
              }",
engine = "dot")

print(gviz)

# This does not worl using DiagrammeR / GraphViz
# png("../manuscript/Figs/graph_design.png")
# print(gviz)
# dev.off()
# Uses Viewer, Zoom and Screen capture to produce .png and then
# data_prep_structure_grviz_20160203.pdf file


# ### The dataset that will be analyzed and reported
n_txt = sprintf("In our analysis we included n = %d individuals (none with missing data) from the dataset '%s'\n", nrow(D), fn);
print(n_txt)


### Grades (continuous and categorized)
# We consider the grades (academic_achievement), as both a continuous (for regression) and 
# discretized variable (for classification), where
# *gjennomsnitt*: - Item 'Karaktergjennomsnitt alle gyldige karakterer 1-6 (ikke kroppsøving)' 

# Discretized at three levels, with data-driven cutpoints (equifrequent levels)
aver <- D$ave
summary(aver)
bins <- 3
cutpoints<-quantile(aver,(0:bins)/bins,names=FALSE)
print(cutpoints)

# Consistent with MATLAB 'histcounts' (D_20151110_analysis.m  ;  T2)
# fn2 = '../data/D_20151110.csv';
# T2 = readtable(fn2);
# bins = 3;
# y = quantile(T2.ave,[0:bins]/bins)
# [N,EDGES,BIN] = histcounts(T2.ave,y);
# cuts = sprintf('1:[%.2f, %.2f) 2:[%.2f,%.2f) 3:[%.2f,%.2f]', EDGES(1), EDGES(2), EDGES(2), EDGES(3), EDGES(3), EDGES(4));
# T2.ave_cat = BIN;   % categorical(BIN,'Ordinal',true);
# descr = sprintf('%s - 1:low, 2:medium; 3:high average mark', cuts);
# T2.Properties.VariableDescriptions{'ave_cat'} = descr;
# => descr = 1:[1.00, 3.75) 2:[3.75,4.43) 3:[4.43,5.90] - 1:low, 2:medium; 3:high average mark

averBinned <- cut(aver, cutpoints, right=FALSE, include.lowest=TRUE)
summary(averBinned)
hist(as.numeric(averBinned))


# Define *grade categories* "low", "medium" and "high" in terms of the calculated cut-point intervals: 
txt_low <- sprintf("low: [%.3f, %.3f)\n", cutpoints[[1]], cutpoints[[2]])
print(txt_low)
txt_medium <- sprintf("medium: [%.3f, %.3f)\n", cutpoints[[2]], cutpoints[[3]])
print(txt_medium)
txt_high <- sprintf("high: [%.3f, %.3f]\n", cutpoints[[3]], cutpoints[[4]])
print(txt_high)


# Dataset for classification lables and textual levels and numerical level 1, 2, 3,
C <- D
C$averBinned <- cut(aver, cutpoints, right=FALSE, include.lowest=TRUE,
                     labels=c("low","medium","high"))
C <- subset(C, select = -c(ave)) 

# Save the dataset C with binary SNAP predictors and trinary outcome to an .csv file for further analysis
write.csv(C, file = "../data2/inattention_nomiss_snap_is_01_outcome_is_low_medium_high_20160203.csv",row.names=FALSE)

C <- D
C$averBinned <- cut(aver, cutpoints, right=FALSE, include.lowest=TRUE,
                    labels=c("1","2","3"))
C <- subset(C, select = -c(ave)) 

# Save the dataset C with binary SNAP predictors and trinary outcome to an .csv file for further analysis
write.csv(C, file = "../data2/inattention_nomiss_snap_is_01_outcome_is_123_20160203.csv",row.names=FALSE)




