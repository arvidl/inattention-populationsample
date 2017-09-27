# Predicting academic achievement from inattention (SNAP)
A.J. Lundervold, T. Bøe, A. Lundervold. <i>Inattention in primary school is not good for your future school achievement - a pattern classification study.</i> In rev.


<small>
Last updated: Arvid Lundervold, 27-Sep-2017
</small>

## Abstract

### Objective
Objective. Inattention in childhood is associated with academic problems later in life. The contribution of specific aspects of inattentive behaviour is, however, less known. We investigated feature importance of primary school teachers’ reports on nine aspects of inattentive behaviour, gender and age in predicting future academic achievement. 

### Methods
Primary school teachers of n = 2491 children (7 - 9 years) rated nine items reflecting different aspects of inattentive behaviour in 2002. A mean academic achievement score at high-school (2012) was available for each youth from an official school register. All scores were at a categorical level. Feature importance was assessed by including a classification and regression trees, a multinominal logistic regression, and a random forest algorithm. A comprehensive pattern classification procedure using k-fold cross-validation was implemented to vote for accuracy, precision and recall. 

### Results 
Overall, inattention was rated as more severe in boys, who also obtained lower achievement scores at high school than girls. Problems related to sustained attention and distractibility were together with age and gender defined as the most important features to predict future achievement scores. A cross-validation model including these four features gave accuracy, precision and recall that were better than chance levels. 

### Conclusion 
Primary school teachers’ reports of problems related to sustained attention and distractibility were the most important features of inattentive behaviour predicting academic achievement in high school. Identification and follow-up procedures of primary school children showing these features should be prioritised to prevent future academic failure.



<small>Organization of the data and the analysis:</small>

Libraries being used:

* numpy: 1.12.1
* pandas: 0.20.3
* scipy: 0.19.1
* matplotlib: 2.0.2
* sklearn: 0.19.0
* seaborn: 0.8.1
* xgboost: 0.6
* graphviz: 0.7.1
* statsmodels: 0.8.0
* rpy2: 2.8.5

<img src="./images/Data_to_classes_notebook_pptx.png" width="500px" height="500px" />

### Data preparation

Code:
 * 01_preparation.ipynb
 
Input file:

 * inattention_Astri_94_96_new_grades_updated.sav (28 Oct 2015, 34 MB) 

 
Output files (data):

 * inattention_nomiss_2491x12.csv
 * heatmap_gender.pdf
 * heatmap_grade.pdf
 * heatmap_SNAP1_SNAP9.pdf
 * heatmap_ave.pdf
 * heatmap_aveBinned.pdf
 
 
 ### Prediction using $k$fold cross-validation
 
 Code:
 * 02_prediction.ipynb
 
Input file:

 * inattention_nomiss_2491x12.csv (from 01_preparation.ipynb)
 
 
 Output files:
 
 * inattention_CART.pdf
 * random_forest_feature_importance.pdf
 
