setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso3/R")

datos <- read.csv("./datasets/DatosRegresion.csv", sep = ";", header = TRUE)

head(datos)

# Analisis de correlaciones
cor(datos)

# Analisis visual de dispersion
pairs(datos)

## Regresion Lineal ##

# Modelo lineal con ambas variables
modelo1 <- lm(Y1 ~ X1 + X2,
              data = datos)
summary(modelo1)

# Modelo lineal solo con X1
modelo2 <- lm(Y1 ~ X1,
              data = datos)
summary(modelo2)

# Modelo lineal solo con X2
modelo3 <- lm(Y1 ~ X2,
              data = datos)
summary(modelo3)

# Prediccion
predict(modelo2)

head(predict(modelo2))
plot(predict(modelo2),datos$Y1)

cor(predict(modelo2),datos$Y1)

# Errores de prediccion
head(residuals(modelo2))


## Regresion Logistica ##

# Modelo logistico con ambas variables
modelo4 <- glm(formula = Y2 ~ X1 + X2,
              data = datos,
              family = binomial())
summary(modelo4)


# Prediccion
head(predict(modelo4))
head(predict(modelo4, type = "response"))

# Matriz de confusion, usando 50% como umbral de clasificacion
pred <- as.numeric(predict(modelo4, type = "response") > 0.5)

table(as.factor(pred), as.factor(datos$Y2))

# Accuracy
sum(as.factor(pred)==as.factor(datos$Y2))/nrow(datos)

# Modelo logistico con ambas variables
modelo5 <- glm(formula = Y2 ~ X1,
               data = datos,
               family = binomial())
summary(modelo5)

# Prediccion
head(predict(modelo5))
head(predict(modelo5, type = "response")) #Probabilidad

Ri <- predict(modelo5)[1]
Ri
exp(Ri)/(exp(Ri)+1)

# Prediccion
head(predict(modelo4))
head(predict(modelo4, type = "response"))

# Matriz de confusion, usando 50% como umbral de clasificacion
pred <- as.numeric(predict(modelo4, type = "response") > 0.5)

table(as.factor(pred), as.factor(datos$Y2))

# Accuracy
sum(as.factor(pred)==as.factor(datos$Y2))/nrow(datos)


# Accuracy modificando un poco el umbral de clasificacion
for (umbral in seq(0.3, 0.7, by = 0.05)) {
  pred <- as.numeric(predict(modelo4, type = "response") > umbral)
  acc <- sum(as.factor(pred)==as.factor(datos$Y2))/nrow(datos)
  cat('Umbral =',umbral,', Accuracy =',acc,'\n')
}
# Matriz de confusion, usando 50% como umbral de clasificacion
pred <- as.numeric(predict(modelo4, type = "response") > 0.45)

table(as.factor(pred), as.factor(datos$Y2))

# Accuracy
sum(as.factor(pred)==as.factor(datos$Y2))/nrow(datos)


## Presentacion de la evaluacion ##
getwd()
datosP <- read.csv("./datasets/DatosPaises.csv", sep = ";", header = TRUE)

head(datosP)
summary(datosP)

# Analisis de correlaciones
cor(datosP) # No funciona, porque tenemos una columna con nombres
cor(datosP[c(2:30)]) # Matriz de 29x29
cor(datosP$PIB,datosP[c(3:30)]) # Vector con 28 correlaciones

?log()

# Analicemos algunas variables
# Los datos vienen ordenados por PIB per capita
plot(datosP$PIB)
plot(log(datosP$PIB))

plot(datosP$RENOVABLE)
plot(datosP$RENOVABLE,datosP$PIB)
plot(datosP$RENOVABLE,log(datosP$PIB))

cor(datosP$RENOVABLE,datosP$PIB)
cor(datosP$RENOVABLE,log(datosP$PIB))

plot(datosP$ESCOLARIDAD)
plot(datosP$ESCOLARIDAD,datosP$PIB)
plot(datosP$ESCOLARIDAD,log(datosP$PIB))

cor(datosP$ESCOLARIDAD,datosP$PIB)
cor(datosP$ESCOLARIDAD,log(datosP$PIB))

plot(datosP$POB)
plot(datosP$POB,datosP$PIB)
plot(datosP$POB,log(datosP$PIB))

cor(datosP$POB,datosP$PIB)
cor(datosP$POB,log(datosP$PIB))

# Probamos un modelo con algunas pocas variables
# Elegi 8 variables explicativas al azar
modeloP1 <- lm(PIB ~ POB + IDH + GENERO + SUICIDIOMAS + HOMICIDIO
              + TURISMO + PRISION + PARLAMENTO,
             data = datosP)
summary(modeloP1)

plot(datosP$PIB , predict(modeloP1))
cor(datosP$PIB , predict(modeloP1))

plot(log(datosP$PIB) , predict(modeloP1))
cor(log(datosP$PIB) , predict(modeloP1))

# Mismo modelo, pero con log de PIB
modeloP2 <- lm(log(PIB) ~ POB + IDH + GENERO + SUICIDIOMAS + HOMICIDIO
               + TURISMO + log(PRISION) + PARLAMENTO,
               data = datosP)
summary(modeloP2)

plot(datosP$PIB , exp(predict(modeloP2)))
cor(datosP$PIB , exp(predict(modeloP2)))

plot(datosP$PRISION)
plot(datosP$PRISION,datosP$PIB)
plot(datosP$PRISION,log(datosP$PIB))


# Solo a modo de ejemplo, usemos regresiones logisticas

# Regresion binomial
summary(datosP$PIB)

datosP$PIB_binomial <- as.numeric(datosP$PIB > 11)

modeloP3 <- glm(PIB_binomial ~ POB + IDH + GENERO + SUICIDIOMAS
                + HOMICIDIO + TURISMO + PRISION + PARLAMENTO,
               data = datosP,
               family = binomial())
summary(modeloP3)

pred3 <- as.numeric(predict(modeloP3, type = "response") > 0.5)

library(caret)

confusionMatrix(as.factor(pred3), as.factor(datosP$PIB_binomial))


# Regresion multinomial
library(nnet)

summary(datosP$PIB)

datosP$PIB_multinomial <- 4 * ( datosP$PIB > 23 ) + 
                          3 * ( datosP$PIB > 11 ) * ( datosP$PIB <= 23 ) +
                          2 * ( datosP$PIB > 3.5 ) * ( datosP$PIB <= 11 ) +
                          1 * ( datosP$PIB <= 3.5 )

modeloP4 <- multinom(PIB_multinomial ~ POB + IDH + GENERO
                     + SUICIDIOMAS + HOMICIDIO
                     + TURISMO + PRISION + PARLAMENTO,
                     data = datosP)
summary(modeloP4)

summary(modeloP4)$coefficients / summary(modeloP4)$standard.errors

predict(modeloP4)

confusionMatrix(predict(modeloP4), as.factor(datosP$PIB_multinomial))
