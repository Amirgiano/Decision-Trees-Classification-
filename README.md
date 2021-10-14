# Decision Trees Classification 
## Here are my notes on the Decision Tree Techniques for Classification Problems. 
The dataset is avialable on request.<br />

![image](https://user-images.githubusercontent.com/90762709/137339248-5a725b7f-cfc2-4879-bfa2-69695ec3e33a.png) <br />

Decision trees are one of the most powerful and simple techniques used for management prediction. In this article, we will see the trees starting from the most simple one to the most complex (gradient boosting). <br />
![image](https://user-images.githubusercontent.com/90762709/137339536-2c61cf37-f1b7-46d6-9a60-c07fca0d8455.png) <br />

Here is the simplest decision tree of the exam result. Where you see whenever you get the exam grade 18+ (I had mistakenly written >18 instead of ≥18). You pass the exam. However, if you had a project during a semester and had a score of ≥16 you can still pass the exam. <b />

<br /><br />
Terminology: Immagine the scheme above as a tree going from bottom to up.<br />
The very top of the tree (Score) is called The Root.<br />
The next boxes whcih have the arrows coming and outgoing (Project) are called Internal Node.<br />
The last point is the leaf which has the arrow is incomming but not pointing out. (Passed/Failed). This is actually is a point of the decision.<br /><br />

The example above is just a simple classification tree. However, in real life, we have many variables. In order to extend our tree, we can use the bagging technique. Bagging (Bootstrap Aggregation). However, the drawback of bagging is the correlation among the predictors. Due to the high correlation, the strong predictor has an impact on other variables too. <br />

Here is the R code for Bagging: Let’s say you want to find a “Default” variable whether the customer will default or not on credit.<br />
```
#Train
set.seed(1, sample.kind=”Rejection”)
credit_bag = randomForest(formula = default ~ .,
data = credit_train,
mtry = ncol(credit_train)-1, #minus the response
importance = T, #to estimate predictors importance
ntree = 500) #500 by default
#Predict:
credit_bag_pred = predict(credit_bag,
newdata=credit_test,
type=”class”)
#Accuracy
accbag = mean((credit_test$default == credit_bag_pred)) #The less the error term is the accurate our code.
```

To improve the performance of the Bagging we can use the Random Forest where the predictors are not correlated with each other. In Random Forest we set the m predictors to the m=sqrt(p) for the classification and m=p/3 for the regression problems. <br />

```
#Train
set.seed(1, sample.kind=”Rejection”)
credit_rf = randomForest(formula = default ~ .,
data = credit_train,
mtry = sqrt(ncol(credit_train)-1),
importance = T,
ntree = 500)
#Predict
credit_rfpred = predict(object = credit_rf,
newdata = credit_test,
type = “class”)
#Accuracy:
accrf = mean((credit_test$default == credit_rfpred))
```
