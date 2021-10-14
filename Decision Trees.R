#Classification Problem with Random Forest.
library(tidyverse)
library(dplyr)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(randomForest)
credit= read.csv('credit.csv')
head(credit)
str(credit)
#Converting the character into factor for classification
credit$default = factor(credit$default)
levels(credit$default)
str(credit)
#Seeing the proportions
credit %>% 
count(default) %>% #Here we will automatically have n variable.
  mutate(perc = n/sum(n)*100)

#Splitting the dataset for decision trees----
set.seed(13, sample.kind="Rejection")
train_index = sample(1:nrow(credit), 0.7*nrow(credit))

# Subset the credit data frame to training indexes only and -training index for test
credit_train = credit[train_index, ]  
credit_test = credit[-train_index, ]  

#Classification decision tree
credit_tree = rpart(formula = default ~., 
                    data = credit_train, 
                    method = "class") #Specify class for classification
credit_tree

rpart.plot(x = credit_tree)

rpart.plot(x = credit_tree, type=0, extra=3) 
#Type = 0 is a simplified version.

#Predcition----
credit_treepred = predict(credit_tree,  
                          newdata = credit_test,   
                          type = "class")  
head(credit_treepred)

# Calculate the confusion matrix for the test set
table(credit_treepred,       
      credit_test$default) 

acctree = mean(credit_treepred==credit_test$default)
acctree

#Bagging----
#Bagging works similarly to the classification tree. Only difference is a number of tries mtry

set.seed(1, sample.kind="Rejection")
credit_bag = randomForest(formula = default ~ ., 
                          data = credit_train,
                          mtry = ncol(credit_train)-1, #minus the response
                          importance = T, #to estimate predictors importance
                          ntree = 500) #500 by default
credit_bag


#The output provides the out-of-bag (OOB) estimate of the error rate (an unbiased estimate of the test set error) and the corresponding confusion matrix. The former could be used for discriminating between different random forest classifiers (estimated, for example, with different values of ntree).

#We analyze now graphically the importance of the regressors (this output is obtained by setting importance = T:

varImpPlot(credit_bag) #Here is the importacne of the features.

#Age in GINI shows the significant difference.

credit_bag_pred = predict(credit_bag,
                          newdata=credit_test,
                          type="class")
head(credit_bag_pred) 

accbag = mean((credit_test$default == credit_bag_pred)) 
#Accuracy of the model.
accbag

#Computing Probability.
credit_bag_pred_prob = predict(credit_bag,
                               newdata=credit_test,
                               type = "prob")
#The output provides the out-of-bag (OOB) estimate of the error rate (an unbiased estimate of the test set error) and the corresponding confusion matrix.
#Random Forest----
set.seed(1, sample.kind="Rejection")
credit_rf = randomForest(formula = default ~ ., 
                         data = credit_train,
                         mtry = sqrt(ncol(credit_train)-1), 
                         importance = T,
                         ntree = 500) 
print(credit_rf)

varImpPlot(credit_rf)

#predicting RF
credit_rfpred = predict(object = credit_rf,   
                        newdata = credit_test,  
                        type = "class") 

accrf = mean((credit_test$default == credit_rfpred)) 

comparison = c("RF"=accrf,"Tree"=acctree,"Bag"=accbag)

comparison
