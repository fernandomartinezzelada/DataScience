################################################################################
# DiplomadoUC en Big Data y Ciencia de Datos                                   #
# Curso Ciencia de Datos y sus Aplicaciones                                    #
# Evaluacion 2: Métodos de Clasificación                                       #
# Alumno: Fernando Martinez Z.                                                 #
# Fecha: 23-12-2025.                                                           #
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
setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso5/R")

# Cargamos la base de datos
datos_cargados <- read.csv("./datasets/courier_dataset.csv", sep = ",",header=TRUE)
head(datos_cargados, n=30)

# Summary para generar un resumen estadistico de la base de datos
summary(datos_cargados)

datos <- datos_cargados # Hacemos una copia de la base
names(datos)[1] <- "ID_Cliente"
datos$ID_Cliente <- NULL # Se elimina dato irrelevante

# Se escoge la siguiente oportunidad / problema de negocio:
# El Gerente de Finanzas está preocupado por el creciente número de clientes que acumulan deudas.
# En particular, busca identificar las características comunes entre los clientes
#, especialmente las empresas, que no cumplen con sus pagos a tiempo.

#Se hace una revision rapida de datos de las columnas:
sort(unique(datos$TipoDeCliente))          # Categorica: "Empresa" ; "Persona"
sort(unique(datos[datos$TipoDeCliente=="Empresa",]$RubroEmpresa))  # Categorica: "Educación" ; "Manufactura" ; "Retail" ; "Servicios Financieros" ; "Tecnología"
sort(unique(datos$Antiguedad))             # Numerica: 2 - 50
sort(unique(datos$Edad))                   # Numerica: 18 - 79
sort(unique(datos[datos$TipoDeCliente=="Persona",]$Genero))        # Categorica: "Femenino" ; "Masculino"
sort(unique(datos$MesesTransaccionados))   # Numerica: 1 - 60
sort(unique(datos$Encomiendas))            # Numerica: 0 - 67020
sort(unique(datos$Documentos))             # Numerica: 0 - 14042
sort(unique(datos$EncomiendasValor))       # Numerica: 0 - 631835425
sort(unique(datos$DocumentosValor))        # Numerica: 0 - 55083000
sort(unique(datos$MontoTotal))             # Numerica: 0 - 631835425
sort(unique(datos$MesesUltimaTransaccion)) # Numerica: 1 - 12
sort(unique(datos$ValorAdeudado))          # Numerica: 0 - 144227365
sort(unique(datos$NivelDeServicio))        # Numerica: 79.8940 81.5695 83.2450 84.9205 86.5960 88.2715 89.9470 91.6225 93.2980 94.9735 96.6490 98.3245

# Binarizacion de variables categóricas:
datos$Es_Empresa <- ifelse(datos$TipoDeCliente=="Empresa",1,0)
datos$Es_Educacion <- ifelse(datos$RubroEmpresa=="Educación",1,0)
datos$Es_Manufactura <- ifelse(datos$RubroEmpresa=="Manufactura",1,0)
datos$Es_Retail <- ifelse(datos$RubroEmpresa=="Retail",1,0)
datos$Es_ServiciosFinancieros <- ifelse(datos$RubroEmpresa=="Servicios Financieros",1,0)
datos$Es_Tecnología <- ifelse(datos$RubroEmpresa=="Tecnología",1,0)
datos$Es_Hombre <- ifelse(datos$Genero=="Masculino",1,0)
datos$Es_Mujer <- ifelse(datos$Genero=="Femenino",1,0)

# Se crea variable objetivo: Deuda
datos$Deuda <- ifelse(datos$ValorAdeudado>0,1,0) # Si tiene valor adeudado, entonces 1, sino 0

# Se eliminan variables redundantes:
datos$TipoDeCliente <- NULL
datos$RubroEmpresa <- NULL
datos$Genero <- NULL
datos$ValorAdeudado <- NULL

# Se hace un analisis de correlacion para ver que variables seleccionar para clasificacion:

# Relacion Candidata: Es_Empresa/Deuda
plot(datos$Es_Empresa, datos$Deuda)
cor(datos$Es_Empresa, datos$Deuda)          #0.3826378 (*)

unique(datos[datos$Es_Empresa==0,]$Deuda)  #0
nemp_sd <- length(datos[datos$Es_Empresa==1 & datos$Deuda==0,]$Deuda)
nemp_cd <- length(datos[datos$Es_Empresa==1 & datos$Deuda==1,]$Deuda)
nemp_cd / (nemp_cd + nemp_sd)  #0.1763484

# Relacion Candidata: Es_Educacion/Deuda
plot(datos$Es_Educacion, datos$Deuda)
cor(datos$Es_Educacion, datos$Deuda)          #0.09180718

# Relacion Candidata: Es_Manufactura/Deuda
plot(datos$Es_Manufactura, datos$Deuda)
cor(datos$Es_Manufactura, datos$Deuda)          #0.1694057 (*)

# Relacion Candidata: Es_Retail/Deuda
plot(datos$Es_Retail, datos$Deuda)
cor(datos$Es_Retail, datos$Deuda)          #0.2862789 (*)

# Relacion Candidata: Es_ServiciosFinancieros/Deuda
plot(datos$Es_ServiciosFinancieros, datos$Deuda)
cor(datos$Es_ServiciosFinancieros, datos$Deuda)          #0.071636

# Relacion Candidata: Es_Tecnología/Deuda
plot(datos$Es_Tecnología, datos$Deuda)
cor(datos$Es_Tecnología, datos$Deuda)          #0.06995579

# Relacion Candidata: Es_Hombre/Deuda
plot(datos$Es_Hombre, datos$Deuda)
cor(datos$Es_Hombre, datos$Deuda)          #-0.1572478

unique(datos[datos$Es_Hombre==1,]$Deuda)  #0

# Relacion Candidata: Es_Mujer/Deuda
plot(datos$Es_Mujer, datos$Deuda)
cor(datos$Es_Mujer, datos$Deuda)          #-0.1544495

unique(datos[datos$Es_Mujer==1,]$Deuda)  #0

# 0. Limpieza de Datos:

# Antiguedad:
unique(datos[datos$Es_Empresa==0,]$Antiguedad)   #NA
sort(unique(datos[datos$Es_Empresa==1,]$Antiguedad))   # 2 - 50
datos[datos$Es_Empresa==0,]$Antiguedad <- 0

# Edad:
unique(datos[datos$Es_Empresa==1,]$Edad)   #NA
sort(unique(datos[datos$Es_Empresa==0,]$Edad))   # 18 - 79
datos[datos$Es_Empresa==1,]$Edad <- 0

datos[is.na(datos$MesesTransaccionados),]    # 0 rows
datos[is.na(datos$Encomiendas),]             # 0 rows
datos[is.na(datos$Documentos),]              # 0 rows
datos[is.na(datos$EncomiendasValor),]        # 0 rows
datos[is.na(datos$DocumentosValor),]         # 0 rows
datos[is.na(datos$MontoTotal),]              # 0 rows
datos[is.na(datos$MesesUltimaTransaccion),]  # 0 rows
datos[is.na(datos$NivelDeServicio),]         # 0 rows

###### Fin-Limpieza ######

# Relacion Candidata: Antiguedad/Deuda
plot(datos$Antiguedad, datos$Deuda)
cor(datos$Antiguedad, datos$Deuda)          # 0.01245226

# Relacion Candidata: Edad/Deuda
plot(datos$Edad, datos$Deuda)
cor(datos$Edad, datos$Deuda)          #-0.2947535 (*)

# Relacion Candidata: MesesTransaccionados/Deuda
plot(datos$MesesTransaccionados, datos$Deuda)
cor(datos$MesesTransaccionados, datos$Deuda)          # 0.2714041 (*)

# Relacion Candidata: Encomiendas/Deuda
plot(datos$Encomiendas, datos$Deuda)
cor(datos$Encomiendas, datos$Deuda)          # 0.3322093 (*)

# Relacion Candidata: Documentos/Deuda
plot(datos$Documentos, datos$Deuda)
cor(datos$Documentos, datos$Deuda)          # 0.1286855 (*)

# Relacion Candidata: EncomiendasValor/Deuda
plot(datos$EncomiendasValor, datos$Deuda)
cor(datos$EncomiendasValor, datos$Deuda)          # 0.3101785 (*)

# Relacion Candidata: DocumentosValor/Deuda
plot(datos$DocumentosValor, datos$Deuda)
cor(datos$DocumentosValor, datos$Deuda)          # 0.1254748 (*)

# Relacion Candidata: MontoTotal/Deuda
plot(datos$MontoTotal, datos$Deuda)
cor(datos$MontoTotal, datos$Deuda)          # 0.3144829 (*)

# Relacion Candidata: MesesUltimaTransaccion/Deuda
plot(datos$MesesUltimaTransaccion, datos$Deuda)
cor(datos$MesesUltimaTransaccion, datos$Deuda)          # 0.06961797

# Relacion Candidata: NivelDeServicio/Deuda
plot(datos$NivelDeServicio, datos$Deuda)
cor(datos$NivelDeServicio, datos$Deuda)          #-0.06961797

# Obs: Las correlaciones son relativamente debiles (max=0.38) por lo que se decide considerar todas las variables

# 1. Normalizacion de datos:
normalize <- function(x) { return ((x - min(x)) / (max(x) - min(x))) }
datos_norm <- as.data.frame(lapply(datos, normalize))
head(datos_norm)

length(datos_norm) # 19 columnas

# Dividimos los datos en entrenamiento (80%) y validacion (20%)
set.seed(123)
subset <- sample(1:nrow(datos), size = 0.8*nrow(datos), replace = FALSE)

# Creamos las bases de datos a utilizar
datos_train <- datos_norm[subset,1:18]
label_train <- datos_norm[subset,19]
datos_test <- datos_norm[-subset,1:18]
label_test <- datos_norm[-subset,19]

head(datos_train)
head(label_train)
head(datos_test)
head(label_test)

nrow(datos_train)     # 42587
length(label_train)   # 42587
nrow(datos_test)      # 10647
length(label_test)    # 10647

# 2. KNN:

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

(max_Accuracy <- max(v_Accuracy)) # 0.9952099
for (k in 1:499){
  if (v_Accuracy[k] == max_Accuracy) {
    max_k <- k
    print(k)
  }
}
v_Accuracy[max_k]
plot(v_Accuracy)

# Obs: Se aprecia maxima Accuracy con k=15 (Accuracy=0.9952099)

# Se ejecuta otra vez el modelo con K = 15
modelo_k15 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 15)
# Accuracy
sum(label_test == modelo_k15)/length(label_test)

# Se ejecuta otra vez el modelo con K = 14
modelo_k14 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 14)
# Accuracy
sum(label_test == modelo_k14)/length(label_test)

# Se ejecuta otra vez el modelo con K = 16
modelo_k16 <- knn(datos_train,
                  datos_test,
                  label_train,
                  k = 16)
# Accuracy
sum(label_test == modelo_k16)/length(label_test)

# Matriz de confusion
confusionMatrix(modelo_k14,as.factor(label_test)) # Kappa : 0.9088
confusionMatrix(modelo_k15,as.factor(label_test)) # Kappa : 0.9262
confusionMatrix(modelo_k16,as.factor(label_test)) # Kappa : 0.9059

# Obs: Se aprecian diferencias tras ejecutar varias veces KNN para diferentes K,
# seguramente por los empates producidos durante la clasificacion.

# Obs Final:
# Como se indicó previamente, tras la decisión de considerar todas las variables,
# KNN demostró que con un K=15, se logró un nivel de acuerdo muy robusto y confiable,
# entre los modelos que se compararon, con un Kappa de 0.9262 y un Accuracy de 0.9952099.
