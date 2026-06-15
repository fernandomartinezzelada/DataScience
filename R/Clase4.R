#install.packages("class")

library(class)

setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso3/R")

datos <- read.csv("./datasets/SouthGermanCredit.csv", sep=";", header=T)

unique(datos$age)
unique(datos$housing)
unique(datos$job)
unique(datos$foreign)
unique(datos$credit)

datos_small <- as.data.frame(cbind(age=datos$age,
                                   housing_free=(datos$housing==1),
                                   housing_rent=(datos$housing==2),
                                   job=datos$job,
                                   foreign=datos$foreign,
                                   credit=datos$credit))

normalize <- function(x) { return ((x-min(x)) / (max(x)-min(x))) }
datos_norm <- as.data.frame(lapply(datos_small, normalize))

set.seed(123)
subset <- sample(1:nrow(datos), size=0.75*nrow(datos), replace=F)
class(subset)
length(subset)
head(subset,n=1000)

datos_train <- datos_norm[subset,1:5]
label_train <- datos_norm[subset,6]
datos_test  <- datos_norm[-subset,1:5]
label_test  <- datos_norm[-subset,6]

nrow(datos_train)
nrow(datos_test)
nrow(label_train)
nrow(label_test)

modelo_k3 <- knn(datos_train,
                 datos_test,
                 label_train,
                 k=3)

modelo_k5 <- knn(datos_train,
                 datos_test,
                 label_train,
                 k=5)

table(label_test, modelo_k3)
table(label_test, modelo_k5)

# Accuracy
sum(label_test==modelo_k3)/length(label_test)
sum(label_test==modelo_k5)/length(label_test)

library(caret)
library(e1071)

confusionMatrix(modelo_k3,as.factor(label_test))
confusionMatrix(modelo_k5,as.factor(label_test))

library(rpart)
library(rpart.plot)

datos_tree <- cbind(datos_train,
                    credit=label_train)

modelo_tree <- rpart_(credit )


