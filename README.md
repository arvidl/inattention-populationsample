# Predicting academic achievement from inattention (SNAP)
A.J. Lundervold, T. Bøe, A. Lundervold. <i>Inattention in primary school is not good for your future school achievement - a pattern classification study.</i> To appear in PLoS ONE.


<small>
Last updated: Arvid Lundervold, 14-Nov-2017
</small>

## Abstract

Inattention in childhood is associated with academic problems later in life. The contribution of specific aspects of inattentive behaviour is, however, less known. We investigated feature importance of primary school teachers' reports on nine aspects of inattentive behaviour, gender and age in predicting future academic achievement. Primary school teachers of $n=2491$ children (7 - 9 years) rated nine items reflecting different aspects of inattentive behaviour in 2002. A mean academic achievement score from the previous semester in high school (2012) was available for each youth from an official school register. All scores were at a categorical level. Feature importances were assessed by using multinominal logistic regression, classification and regression trees analysis, and a random forest algorithm. Finally, a comprehensive pattern classification procedure using $k$-fold cross-validation was implemented.
Overall, inattention was rated as more severe in boys, who also obtained lower academic achievement scores in high school than girls. Problems related to sustained attention and distractibility were together with age and gender defined as the most important features to predict future achievement scores. 
Using these four features as input to a collection of  classifiers
employing $k$-fold cross-validation for prediction of academic achievement level, we obtained classification accuracy, precision and recall that were clearly better than chance levels. 
Primary school teachers' reports of problems related to sustained attention and distractibility were identified as the two most important features of inattentive behaviour predicting academic achievement in high school.  Identification and follow-up procedures of primary school children showing these characteristics should be prioritised to prevent future academic failure.


<small>Organization of the data and the analysis:</small>

Libraries being used:

* numpy: 1.13.3
* pandas: 0.21.0
* scipy: 0.19.1
* matplotlib: 2.1.0
* sklearn: 0.19.1
* seaborn: 0.8.1
* xgboost: 0.6
* graphviz: 0.8
* statsmodels: 0.8.0
* rpy2: 2.8.5

<img src="./images/Data_to_classes_notebook_pptx.png" width="600px" height="500px" />

### Data preparation

Code:
 * 01_preparation.ipynb
 
Input file:

 * <not provided>.sav (34 MB) 

 
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
 
