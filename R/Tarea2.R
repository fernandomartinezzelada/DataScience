################################################################################
# Evaluacion 2: Métodos de Clasificación                                       #
# Alumno1: Fernando Martinez Z.                                                #
# Alomno2: Fabian Valdez                                                       #
# Fecha: 12-10-2025.                                                           #
################################################################################

# Instalamos los paquetes necesarios, en caso que no los tengamos instaladas
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("class")
#install.packages("caret", dependencies = TRUE)

# Cargamos las librerias que utilizaremos
library(rpart)
library(rpart.plot)
library(class)
library(caret)
library(e1071)

# Indicamos el directorio de trabajo
setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso3/R")

# Cargamos la base de datos
datos_cargados <- read.csv("./datasets/SouthGermanCredit.csv", sep = ";",header=TRUE)
head(datos_cargados, n=30)

# Summary para generar un resumen estadistico de la base de datos
summary(datos_cargados)

datos <- datos_cargados # Hacemos una copia de la base

#Se hace una revision rapida de datos de las columnas:
unique(datos$status)    # 1 2 3 4     (Categorica)
unique(datos$history)   # 0 1 2 3 4   (Categorica)
unique(datos$amount)    # 250 - 18424
unique(datos$savings)   # 1 2 3 4 5
unique(datos$employed)  # 1 2 3 4 5
unique(datos$rate)      # 1 2 3 4
unique(datos$personal)  # 1 2 3 4     (Categorica)
unique(datos$residence) # 1 2 3 4
unique(datos$property)  # 1 2 3 4
unique(datos$age)       # 19 - 75
unique(datos$housing)   # 1 2 3       (Categorica)
unique(datos$credits)   # 1 2 3 4
unique(datos$job)       # 1 2 3 4
unique(datos$persons)   # 0 1
unique(datos$telephone) # 0 1
unique(datos$foreign)   # 0 1
unique(datos$credit)    # 0 1

# Se hace un analisis de correlacion para ver que variables seleccionar para clasificacion:

# Relacion Candidata: status/credit
plot(datos$status, datos$credit)
cor(datos$status, datos$credit)          #0.3508475

# Relacion Candidata: history/credit
plot(datos$history, datos$credit)
cor(datos$history, datos$credit)         #0.2287847

# Relacion Candidata: amount/credit
plot(datos$amount, datos$credit)
cor(datos$amount, datos$credit)          #-0.1547401

# Relacion Candidata: savings/credit
plot(datos$savings, datos$credit)
cor(datos$savings, datos$credit)         #0.1789427

# Relacion Candidata: employed/credit
plot(datos$employed, datos$credit)
cor(datos$employed, datos$credit)        #0.116002

# Relacion Candidata: rate/credit
plot(datos$rate, datos$credit)
cor(datos$rate, datos$credit)            #-0.07240394

# Relacion Candidata: personal/credit
plot(datos$personal, datos$credit)
cor(datos$personal, datos$credit)        #0.0881843

# Relacion Candidata: residence/credit
plot(datos$residence, datos$credit)
cor(datos$residence, datos$credit)       #-0.002967159

# Relacion Candidata: property/credit
plot(datos$property, datos$credit)
cor(datos$property, datos$credit)        #-0.142612

# Relacion Candidata: age/credit
plot(datos$age, datos$credit)
cor(datos$age, datos$credit)             #0.09127195

# Relacion Candidata: housing/credit
plot(datos$housing, datos$credit)
cor(datos$housing, datos$credit)         #0.01811891

# Relacion Candidata: credits/credit
plot(datos$credits, datos$credit)
cor(datos$credits, datos$credit)         #0.04573249

# Relacion Candidata: job/credit
plot(datos$job, datos$credit)
cor(datos$job, datos$credit)             #-0.032735

# Relacion Candidata: persons/credit
plot(datos$persons, datos$credit)
cor(datos$persons, datos$credit)         #0.003014853

# Relacion Candidata: telephone/credit
plot(datos$telephone, datos$credit)
cor(datos$telephone, datos$credit)       #0.03646619

# Relacion Candidata: foreign/credit
plot(datos$foreign, datos$credit)
cor(datos$foreign, datos$credit)         #0.0820795

# Obs: Las correlaciones son relativamente debiles (max=0.35) por lo que se decide considerar todas las variables

# 0. DIVISION BASE EN DATOS DE ENTRENAMIENTO Y VALIDACION

# Dividimos los datos en entrenamiento (75%) y validacion (25%)
set.seed(123)
subset <- sample(1:nrow(datos), size = 0.75*nrow(datos), replace = FALSE)

length(datos) # 17 columnas

# Creamos las bases de datos a utilizar
datos_train <- datos[subset,1:17]
datos_test <- datos[-subset,1:17]

head(datos_train)
head(datos_test)

nrow(datos_train)
nrow(datos_test)

# 1. ARBOLES DE CLASIFICACION:

## 1.1 Ganancia de Informacion

###Comparacion 1.1.1:
modelo1a <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                 data = datos_train,
                 method = "class",
                 parms = list(split = "information"),   #Ganancia de Informacion
                 control = rpart.control(minsplit = 1,
                                         minbucket = 1,
                                         maxdepth = 30, #Profundidad=30
                                         cp = 0))       #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo1a)

# Graficamos el arbol
rpart.plot(modelo1a)

# Prediccion en la base de validacion
predict1a_tst <- predict(modelo1a,
                        newdata = datos_test,
                        type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict1a_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict1a_tst)/nrow(datos_test) # 0.668

###Comparacion 1.1.2:
modelo1b <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "class",
                  parms = list(split = "information"),  #Ganancia de Informacion
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 6, #Profundidad=6
                                          cp = 0))      #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo1b)

# Graficamos el arbol
rpart.plot(modelo1b)

# Prediccion en la base de validacion
predict1b_tst <- predict(modelo1b,
                        newdata = datos_test,
                        type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict1b_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict1b_tst)/nrow(datos_test) # 0.676

###Comparacion 1.1.3:
modelo1c <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "class",
                  parms = list(split = "information"),     #Ganancia de Informacion
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 30,   #Profundidad=30
                                          cp = 0.0045455)) #Parametro Complejidad=0.0045455

# Tabla de cp:
printcp(modelo1c)

# Graficamos el arbol
rpart.plot(modelo1c)

# Prediccion en la base de validacion
predict1c_tst <- predict(modelo1c,
                        newdata = datos_test,
                        type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict1c_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict1c_tst)/nrow(datos_test) # 0.72

# Obs: El arbol de ganancia de informacion con cp=0.0045455 demostro mayor Accuracy con 0.72

## 1.2 Gini

###Comparacion 1.2.1:
modelo2a <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                 data = datos_train,
                 method = "class",
                 parms = list(split = "gini"),            #Gini
                 control = rpart.control(minsplit = 1,
                                         minbucket = 1,
                                         maxdepth = 30,   #Profundidad=30
                                         cp = 0))         #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo2a)

# Graficamos el arbol
rpart.plot(modelo2a)

# Prediccion en la base de validacion
predict2a_tst <- predict(modelo2a,
                         newdata = datos_test,
                         type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict2a_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict2a_tst)/nrow(datos_test) # 0.664

###Comparacion 1.2.2:
modelo2b <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "class",
                  parms = list(split = "gini"),           #Gini
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 6,   #Profundidad=6
                                          cp = 0))        #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo2b)

# Graficamos el arbol
rpart.plot(modelo2b)

# Prediccion en la base de validacion
predict2b_tst <- predict(modelo2b,
                         newdata = datos_test,
                         type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict2b_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict2b_tst)/nrow(datos_test) # 0.684

###Comparacion 1.2.3:
modelo2c <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "class",
                  parms = list(split = "gini"),             #Gini
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 30,    #Profundidad=30
                                          cp = 0.0045455))  #Parametro Complejidad=0.0045455

# Tabla de cp:
printcp(modelo2c)

# Graficamos el arbol
rpart.plot(modelo2c)

# Prediccion en la base de validacion
predict2c_tst <- predict(modelo2c,
                         newdata = datos_test,
                         type = "class")

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict2c_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict2c_tst)/nrow(datos_test) # 0.724

# Obs: El arbol de clasificacion Gini con cp=0.0045455 demostro mayor Accuracy con 0.724

## 1.3 Arbol de Regresion

###Comparacion 1.3.1:
modelo3a <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "anova",                       #Arbol Regresion
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 30,  #Profundidad=30
                                          cp = 0))        #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo3a)

# Graficamos el arbol
rpart.plot(modelo3a)

# Prediccion en la base de validacion
predict3a_tst <- predict(modelo3a, datos_test)

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict3a_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict3a_tst)/nrow(datos_test) # 0.64

###Comparacion 1.3.2:
modelo3b <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "anova",                       #Arbol Regresion
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 6,  #Profundidad=6
                                          cp = 0))       #Parametro Complejidad=0

# Tabla de cp:
printcp(modelo3b)

# Graficamos el arbol
rpart.plot(modelo3b)

# Prediccion en la base de validacion
predict3b_tst <- predict(modelo3b, datos_test)

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict3b_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict3b_tst)/nrow(datos_test) # 0.208

###Comparacion 1.3.3:
modelo3c <- rpart(credit ~ status + history + amount + savings + employed + rate + personal + residence + property + age + housing + credits + job + persons + telephone + foreign,
                  data = datos_train,
                  method = "anova",                         #Arbol Regresion
                  control = rpart.control(minsplit = 1,
                                          minbucket = 1,
                                          maxdepth = 30,    #Profundidad=30
                                          cp = 0.0045455))  #Parametro Complejidad=0.0045455

# Tabla de cp:
printcp(modelo3c)

# Graficamos el arbol
rpart.plot(modelo3c)

# Prediccion en la base de validacion
predict3c_tst <- predict(modelo3c, datos_test)

# Matriz de Confusion con la base de validacion
table(datos_test$credit, predict3c_tst)

# Accuracy en la base de validacion
sum(datos_test$credit == predict3c_tst)/nrow(datos_test) # 0.244

# Obs: El arbol de Regresion con cp=0 demostro mayor Accuracy con 0.64
# Obs2: El arbol de clasificacion Gini con cp=0.0045455 demostro la mayor Accuracy con 0.724

# 2. KNN:

datos <- datos_cargados # Hacemos una copia de la base

# Se binarizan datos categoricos:

datos$status_sc               <- ifelse(datos$status==1,1,0)   # 1 = sin cuenta
datos$status_deuda            <- ifelse(datos$status==2,1,0)   # 2 = cuenta con deuda
datos$status_ahorro200        <- ifelse(datos$status==3,1,0)   # 3 = ahorros hasta 200 DM

datos$history_otban           <- ifelse(datos$history==1,1,0)  # 1 = cuenta critica o creditos en otros bancos
datos$history_sc              <- ifelse(datos$history==2,1,0)  # 2 = sin creditos anteriores
datos$history_cvigad          <- ifelse(datos$history==3,1,0)  # 3 = creditos vigentes al dia
datos$history_cpag            <- ifelse(datos$history==4,1,0)  # 4 = todos los creditos pagados

datos$per_homdivorciado       <- ifelse(datos$personal==1,1,0) # 1 = Hombre divorciado
datos$per_homsoltero_mujnosol <- ifelse(datos$personal==2,1,0) # 2 = Hombre soltero o mujer no soltera
datos$per_homcasadoviudo      <- ifelse(datos$personal==3,1,0) # 3 = Hombre casado o viudo

datos$housing_free            <- ifelse(datos$housing==1,1,0)  # 1 = Gratuita
datos$housing_rent            <- ifelse(datos$housing==2,1,0)  # 2 = Arrendada

#Se eliminan columnas que ya no usaremos
datos$status   <- NULL
datos$history  <- NULL
datos$personal <- NULL
datos$housing  <- NULL

#Se reordenan columnas dejando la variable endogena (credit) al final:
datos <- datos[,c(1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25,13)]
head(datos)

# Normalizacion de datos
normalize <- function(x) { return ((x - min(x)) / (max(x) - min(x))) }
datos_norm <- as.data.frame(lapply(datos, normalize))
head(datos_norm)

length(datos_norm) # 25 columnas

# Dividimos los datos en entrenamiento (75%) y validacion (25%)
set.seed(123)
subset <- sample(1:nrow(datos), size = 0.75*nrow(datos), replace = FALSE)

# Creamos las bases de datos a utilizar
datos_train <- datos_norm[subset,1:24]
label_train <- datos_norm[subset,25]
datos_test <- datos_norm[-subset,1:24]
label_test <- datos_norm[-subset,25]

head(datos_train)
head(label_train)
head(datos_test)
head(label_test)

nrow(datos_train)
length(label_train)
nrow(datos_test)
length(label_test)

#Se ejecuta KNN para distintos K:
i <- 1
v_Accuracy <- 1:499
for (i in 1:499){
  modelo_knn <- knn(datos_train,
                 datos_test,
                 label_train,
                 k = i)
  v_Accuracy[i] <- sum(label_test == modelo_knn)/length(label_test)
  print(paste(i,'=',v_Accuracy[i]) )
}

(max_Accuracy <- max(v_Accuracy)) # 0.748
for (k in 1:499){
  if (v_Accuracy[k] == max_Accuracy) {
    max_k <- k
    print(k)
  }
}
v_Accuracy[max_k]
plot(v_Accuracy)

# Obs: Se aprecia maxima Accuracy con k=16 (Accuracy=0.744)

# Se ejecuta otra vez el modelo con K = 14
modelo_k14 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 14)
# Accuracy
sum(label_test == modelo_k14)/length(label_test)

# Se ejecuta otra vez el modelo con K = 15
modelo_k15 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 15)
# Accuracy
sum(label_test == modelo_k15)/length(label_test)

# Se ejecuta otra vez el modelo con K = 16
modelo_k16 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 16)
# Accuracy
sum(label_test == modelo_k16)/length(label_test)

# Matriz de confusion
confusionMatrix(modelo_k14,as.factor(label_test)) # Kappa : 0.2797
confusionMatrix(modelo_k15,as.factor(label_test)) # Kappa : 0.3114
confusionMatrix(modelo_k16,as.factor(label_test)) # Kappa : 0.2983

# Obs: Se aprecian diferencias tras ejecutar varias veces KNN para diferentes K,
# seguramente por los empates producidos durante la clasificacion.

# Obs Final: KNN demostro una leve mejora respecto a los otros algoritmos con una Accuracy=0.744.