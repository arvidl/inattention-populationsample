# inattention-populationsample
Prediction of academic achievement in adolescents from teacher reports of inattention in childhood - a methodological pattern classification study (AJL, TB, AL)

<small>
This is an [R Markdown](http://rmarkdown.rstudio.com) [Notebook](http://rmarkdown.rstudio.com/r_notebooks.html). 
When you execute code within the notebook, the results appear beneath the code. 
Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Cmd+Shift+Enter*. 
Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*.
When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to preview the HTML file).
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

* memisc - spss.system.file()
* psych  - headTail(), describe()
* Hmisc - describe()
* pander - pander(), panderOptions()

<img src="./images/Data_to_classes_notebook_pptx.jpg" width="500px" height="500px" />

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
 
