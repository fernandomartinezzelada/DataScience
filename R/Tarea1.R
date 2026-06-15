getwd() # Directorio de trabajo actual

library(ggplot2)

# Indicar el directorio de trabajo
setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso3/R")

# Cargar la base de datos
datos <- read.csv("./datasets/DatosPaises.csv", sep=";",header=TRUE)

# Head para visualizar las primeras 6 filas de la base de datos
head(datos)

# Summary para generar un resumen estadistico de la base de datos
summary(datos)

# Relacion Candidata: POB/PIB
plot(datos$POB, datos$PIB)
cor(datos$POB, datos$PIB)               #-0.04464436

# Relacion Candidata: IDH/PIB
plot(datos$IDH, datos$PIB)
cor(datos$IDH, datos$PIB)               # 0.7318694 (4)

# Relacion Candidata: GINI/PIB
plot(datos$GINI, datos$PIB)
cor(datos$GINI, datos$PIB)              #-0.4141661

# Relacion Candidata: IPC/PIB
plot(datos$IPC, datos$PIB)
cor(datos$IPC, datos$PIB)               #-0.2466873

# Relacion Candidata: FAO/PIB
plot(datos$FAO, datos$PIB)
cor(datos$FAO, datos$PIB)               #-0.6842044

# Relacion Candidata: GENERO/PIB
plot(datos$GENERO, datos$PIB)
cor(datos$GENERO, datos$PIB)            #-0.6390433

# Relacion Candidata: ELECTRICIDAD/PIB
plot(datos$ELECTRICIDAD, datos$PIB)
cor(datos$ELECTRICIDAD, datos$PIB)      # 0.5034136

# Relacion Candidata: ESCOLARIDAD/PIB
plot(datos$ESCOLARIDAD, datos$PIB)
cor(datos$ESCOLARIDAD, datos$PIB)       # 0.6058639

# Relacion Candidata: SUICIDIOFEM/PIB
plot(datos$SUICIDIOFEM, datos$PIB)
cor(datos$SUICIDIOFEM, datos$PIB)       #-0.1381191

# Relacion Candidata: SUICIDIOMAS/PIB
plot(datos$SUICIDIOMAS, datos$PIB)
cor(datos$SUICIDIOMAS, datos$PIB)       #-0.02489296

# Relacion Candidata: BOSQUE/PIB
plot(datos$BOSQUE, datos$PIB)
cor(datos$BOSQUE, datos$PIB)            #-0.06219661

# Relacion Candidata: FOSIL/PIB
plot(datos$FOSIL, datos$PIB)
cor(datos$FOSIL, datos$PIB)             # 0.3756789

# Relacion Candidata: DIOXIDO/PIB
plot(datos$DIOXIDO, datos$PIB)
cor(datos$DIOXIDO, datos$PIB)           # 0.8022587 (1)

# Relacion Candidata: DESASTRE/PIB
plot(datos$DESASTRE, datos$PIB)
cor(datos$DESASTRE, datos$PIB)          #-0.0492902

# Relacion Candidata: AFECTADOS/PIB
plot(datos$AFECTADOS, datos$PIB)
cor(datos$AFECTADOS, datos$PIB)         #-0.08699804

# Relacion Candidata: HOMICIDIO/PIB
plot(datos$HOMICIDIO, datos$PIB)
cor(datos$HOMICIDIO, datos$PIB)         #-0.2777882

# Relacion Candidata: MORTINF/PIB
plot(datos$MORTINF, datos$PIB)
cor(datos$MORTINF, datos$PIB)           #-0.5251502

# Relacion Candidata: MORTMAT/PIB
plot(datos$MORTMAT, datos$PIB)
cor(datos$MORTMAT, datos$PIB)           #-0.4916133

# Relacion Candidata: TURISMO/PIB
plot(datos$TURISMO, datos$PIB)
cor(datos$TURISMO, datos$PIB)           # 0.3021901

# Relacion Candidata: INTERNET/PIB
plot(datos$INTERNET, datos$PIB)
cor(datos$INTERNET, datos$PIB)          # 0.766723 (2)

# Relacion Candidata: VIOLENCIA/PIB
plot(datos$VIOLENCIA, datos$PIB)
cor(datos$VIOLENCIA, datos$PIB)         #-0.1791864

# Relacion Candidata: VIDA/PIB
plot(datos$VIDA, datos$PIB)
cor(datos$VIDA, datos$PIB)              # 0.6210986

# Relacion Candidata: CELULAR/PIB
plot(datos$CELULAR, datos$PIB)
cor(datos$CELULAR, datos$PIB)           # 0.51337

# Relacion Candidata: DESERCION/PIB
plot(datos$DESERCION, datos$PIB)
cor(datos$DESERCION, datos$PIB)         #-0.5084971

# Relacion Candidata: PRISION/PIB
plot(datos$PRISION, datos$PIB)
cor(datos$PRISION, datos$PIB)           # 0.07118962

# Relacion Candidata: RENOVABLE/PIB
plot(datos$RENOVABLE, datos$PIB)
cor(datos$RENOVABLE, datos$PIB)         #-0.4711881

# Relacion Candidata: PARLAMENTO/PIB
plot(datos$PARLAMENTO, datos$PIB)
cor(datos$PARLAMENTO, datos$PIB)        # 0.1482323

# Relacion Candidata: INMIGRANTES/PIB
plot(datos$INMIGRANTES, datos$PIB)
cor(datos$INMIGRANTES, datos$PIB)       # 0.7563722 (3)


#Relaciones seleccionadas:

# Relacion Candidata: DIOXIDO/PIB
plot(datos$DIOXIDO, datos$PIB)
cor(datos$DIOXIDO, datos$PIB)           # 0.8022587 (1)

# Relacion Candidata: INTERNET/PIB
plot(datos$INTERNET, datos$PIB)
cor(datos$INTERNET, datos$PIB)          # 0.766723 (2)

# Relacion Candidata: INMIGRANTES/PIB
plot(datos$INMIGRANTES, datos$PIB)
cor(datos$INMIGRANTES, datos$PIB)       # 0.7563722 (3)

# Relacion Candidata: IDH/PIB
plot(datos$IDH, datos$PIB)
cor(datos$IDH, datos$PIB)               # 0.7318694 (4)

# Relacion Candidata: IDH/LOG(PIB)
plot(datos$IDH, log(datos$PIB))
cor(datos$IDH, log(datos$PIB))          # 0.9394354 (4)

# Hipótesis preliminares: 
# DIOXIDO, INTERNET, INMIGRANTES, IDH tienen una correlación positiva (de signo +) alta (sobre el 70%) en relación al PIB.
# Se aprecia también que IDH tiene una correlación muy alta (sobre el 93%) en relación al PIB en escala logarítmica.


#Detección de outliers:

#Método 1: Percentiles

#Normalizacion:
datos$N_PIB         <- (datos$PIB - min(datos$PIB)) / (max(datos$PIB) - min(datos$PIB))
datos$N_DIOXIDO     <- (datos$DIOXIDO - min(datos$DIOXIDO)) / (max(datos$DIOXIDO) - min(datos$DIOXIDO))
datos$N_INTERNET    <- (datos$INTERNET - min(datos$INTERNET)) / (max(datos$INTERNET) - min(datos$INTERNET))
datos$N_INMIGRANTES <- (datos$INMIGRANTES - min(datos$INMIGRANTES)) / (max(datos$INMIGRANTES) - min(datos$INMIGRANTES))
datos$N_IDH         <- (datos$IDH - min(datos$IDH)) / (max(datos$IDH) - min(datos$IDH))

#Outliers candidatos (>99% & <1%):
x0 <- datos[datos$N_PIB > quantile(datos$N_PIB, probs = .99)[[1]]
          | datos$N_PIB < quantile(datos$N_PIB, probs = .01)[[1]],]
x0$PIB # 127.5426464  87.7716390   0.7468267   0.5849220

x1 <- datos[datos$N_DIOXIDO > quantile(datos$N_DIOXIDO, probs = .99)[[1]]
          | datos$N_DIOXIDO < quantile(datos$N_DIOXIDO, probs = .01)[[1]],]
x1$DIOXIDO # 43.893 37.188  0.045  0.022

x2 <- datos[datos$N_INTERNET > quantile(datos$N_INTERNET, probs = .99)[[1]]
          | datos$N_INTERNET < quantile(datos$N_INTERNET, probs = .01)[[1]],]
x2$INTERNET # 96.30 98.16  1.14  0.99

x3 <- datos[datos$N_INMIGRANTES > quantile(datos$N_INMIGRANTES, probs = .99)[[1]]
          | datos$N_INMIGRANTES < quantile(datos$N_INMIGRANTES, probs = .01)[[1]],]
x3$INMIGRANTES # 73.82 83.75  0.06  0.07

x4 <- datos[datos$N_IDH > quantile(datos$N_IDH, probs = .99)[[1]]
          | datos$N_IDH < quantile(datos$N_IDH, probs = .01)[[1]],]
x4$IDH # 0.9439 0.9350 0.3483 0.3501


#Método 2: Intervalos de variabilidad (x ϵ [Media(X) - Delta*DV(x), Media(x) + Delta*DV(x)])

delta <- 4 # El intervalo contendrá al menos el 93,8% de los datos

#Outliers candidatos:
y0 <- datos[datos$N_PIB > (mean(datos$N_PIB) + delta*sd(datos$N_PIB))
          | datos$N_PIB < (mean(datos$N_PIB) - delta*sd(datos$N_PIB)),]
y0$PIB # 127.5426

y1 <- datos[datos$N_DIOXIDO > (mean(datos$N_DIOXIDO) + delta*sd(datos$N_DIOXIDO))
          | datos$N_DIOXIDO < (mean(datos$N_DIOXIDO) - delta*sd(datos$N_DIOXIDO)),]
y1$DIOXIDO # 43.893   37.188

y2 <- datos[datos$N_INTERNET > (mean(datos$N_INTERNET) + delta*sd(datos$N_INTERNET))
          | datos$N_INTERNET < (mean(datos$N_INTERNET) - delta*sd(datos$N_INTERNET)),]
y2$INTERNET # NA

y3 <- datos[datos$N_INMIGRANTES > (mean(datos$N_INMIGRANTES) + delta*sd(datos$N_INMIGRANTES))
          | datos$N_INMIGRANTES < (mean(datos$N_INMIGRANTES) - delta*sd(datos$N_INMIGRANTES)),]
y3$INMIGRANTES # 73.82  83.75

y4 <- datos[datos$N_IDH > (mean(datos$N_IDH) + delta*sd(datos$N_IDH))
          | datos$N_IDH < (mean(datos$N_IDH) - delta*sd(datos$N_IDH)),]
y4$IDH # NA


#Método 3: Valor z robusto

meda <- function(x_vector) {
  m <- median(x_vector)
  return(median(abs(x_vector - m)))
}
z_robusto <- function(x_vector) {
  m <- median(x_vector)
  n <- meda(x_vector)
  return((abs(x_vector - m) / n) > 4.5)
}

#Outliers candidatos:
z0 <- datos[z_robusto(datos$N_PIB),]
z0$PIB # 127.54265  87.77164  82.36923  76.24004  69.44976  62.45083  57.04215  54.70115  52.06771  51.51245  51.34047

z1 <- datos[z_robusto(datos$N_DIOXIDO),]
z1$DIOXIDO # 43.893 20.898 29.132 23.968 19.998 18.741 17.020 21.441 16.519 18.131 14.136 37.188 14.050 12.647 15.810 12.184

z2 <- datos[z_robusto(datos$N_INTERNET),]
z2$INTERNET # NA

z3 <- datos[z_robusto(datos$N_INMIGRANTES),]
z3$INMIGRANTES # 73.82 43.25 60.21 42.93 49.35 83.75 28.91 31.43 38.93 30.61 27.71 54.75 20.70 33.06 56.91 25.14 26.47 18.17 21.14 31.93 23.63 26.72 40.22 24.41

z4 <- datos[z_robusto(datos$N_IDH),]
z4$IDH # NA


## Regresion Lineal ##

datos2 <- datos[c("DIOXIDO","INTERNET","INMIGRANTES","IDH","PIB")]
names(datos2) <- c("X1","X2","X3","X4","Y1")
head(datos2)

# Analisis de correlaciones
cor(datos2)

# Analisis visual de dispersion
pairs(datos2)

# Modelo lineal con las 4 variables:
modelo1 <- lm(Y1 ~ X1 + X2 + X3 + X4,
              data = datos2)
summary(modelo1)

# Modelo lineal sin X2:
modelo2 <- lm(Y1 ~ X1 + X3 + X4,
              data = datos2)
summary(modelo2)

# Modelo lineal solo con X2:
modelo3 <- lm(Y1 ~ X2,
              data = datos2)
summary(modelo3)

# Prediccion
predict(modelo1)

head(predict(modelo1))
plot(predict(modelo1),datos2$Y1)

cor(predict(modelo1),datos2$Y1)

# Errores de prediccion
head(residuals(modelo1))

# Modelo Final:
# El Modelo final es el de las 4 variables
# Es decir: DIOXIDO, INTERNET, INMIGRANTES, IDH, PIB

# Para llegar a este modelo, se consideraron las 4 variables iniciales de mejor correlación con el PIB (DIOXIDO, INTERNET, INMIGRANTES, IDH)
# Y posteriormente se ejecutaron ajustes de modelos lineales mediante la herramienta automática LM() de R.
# De los 3 modelos revisados, el modelo 1 mostró un mejor ajuste del modelo lineal (Adjusted R-squared:  0.8268).
