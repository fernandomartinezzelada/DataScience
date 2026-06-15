#install.packages("dplyr")  #para manejo de datos
#install.packages("caret")  #para manejo de datos
install.packages("factoextra")  #para funciones de clustering y PCA
install.packages("dbscan")     #Para DBScan
install.packages("kernlab")   #Para spectral Clustering
install.packages("cluster")   #Para evaluar clusters
install.packages("fmsb")     #Para graficos de araña
install.packages("readxl")

#Aplicar librerias necesarias
library(dplyr)
library(caret)
library(factoextra)
library(dbscan)
library(kernlab)
library(cluster)
library(fmsb)
library(readxl)

# Cargar el dataset
df <- read.csv("telecom_customer_dataset.csv")

#------------------EXPLORACION----------------------
#Veo las columnas
colnames(df)

#Veo la cabecera
head(df)

#Estadisticos basicos exploratorios
summary(df)

# Mostrar la cantidad de valores nulos por atributo
null_counts <- colSums(is.na(df))
print(null_counts)

#---------------------------------------------------


#------------------TRABAJO SOBRE LOS DATOS----------------------

# ---- VALIDAMOS PRIMERO LAS COLUMNAS DE GASTOS ----------

# TV Spending tiene valores a pesar de ser 0, corrijamos: 
df <- df %>% 
  mutate(TV_Spending=TV_Spending*TV)

# Crear una nueva columna que sume las columnas de gasto
df <- df %>%
  mutate(Suma_Gastos = Mobile_Spending + Internet_Spending + TV_Spending + Adicional_service_spending)

# Revisar consistencia entre la suma de gastos y el gasto total
df <- df %>%
  mutate(Consistente = ifelse(Suma_Gastos == TotalSpend, TRUE, FALSE))

# Mostrar las filas inconsistentes
inconsistentes <- df %>% filter(!Consistente)
nrow(df)
nrow(inconsistentes)

#Nos fijamos aca que la variable TotalSpend es totalmente inconsistente, por lo que usaremos la variable "SUMA_Gastos" creada, para tener la valorizacion. 
#Realisaremos lo mismo para la cantidad de servicios. Ya que en el dataset inicial, nos fijamos que era igual de inconsistente. 

#Sumamos la cantidad de servicios reales
df <- df %>%
  mutate(Num_Servicios = Mobile  + interne  + TV + Aditional_service )

# Hacemos drop de las variables malas
df <- df %>% select(-NumServices,-TotalSpend,-Consistente )

#~--- TRABAJAMOS CON LOS NULOS -----#

#Como vimos que eran poco los Nulos. Vamos a simplemente omitir estos registros. 
df_sin_na <- na.omit(df)
nrow(df)
nrow(df_sin_na)


#-------- CUANTO ES LO QUE GASTA DE SU SALARIO ----------------- 


df_sin_na$SpendingIncomeRatio <- df_sin_na$Suma_Gastos / df_sin_na$Income 

hist(df_sin_na$SpendingIncomeRatio, main = 'Ratio Distribution', xlab = 'Age', col = 'lightblue', border = 'white')


# Convertir Gender a binaria
df_sin_na$Gender <- ifelse(df_sin_na$Gender == "Male", 0, 1)

#Sacamos el Customer id (ya que no nos va a servir para hacer clustering)
df_sin_na <- df_sin_na %>% select(-CustomerID)

# Normalizar variables numéricas
df_normalizado <- scale(df_sin_na)

# Ver el resumen de los datos normalizados
summary(df_normalizado)

#--CLUSTERING--------


grafico_radar <- function(df,clusterresults) {

  df <- as.data.frame(df)
  
  # Añadir la asignación de clusters al dataframe normalizado
  df$cluster <- as.factor(clusterresults$cluster)
  
  # Calcular la media de cada variable por cada cluster
  mean_by_cluster <- df %>%
    group_by(cluster) %>%
    summarise(across(everything(), mean))
 
  # Convertir mean_by_cluster a un dataframe
  mean_by_cluster <- as.data.frame(mean_by_cluster)
  
  
  # Transponer el dataframe de medias de clusters
  mean_by_cluster  <- mean_by_cluster[, -1] # Excluir la columna de cluster al transponer
  # Calcular los valores máximos y mínimos para el radar plot
  
  max_min <- data.frame(
    max = apply(mean_by_cluster, 2, max),
    min = apply(mean_by_cluster, 2, min)
  )
  
  # Transponer la tabla max_min para que cada columna sea una variable
  max_min <- t(max_min)
  
  # Convertir max_min a un dataframe y asegurar que las columnas tengan nombres consistentes
  max_min <- as.data.frame(max_min)
  

  
  # Combinar los datos de límite con los datos de cluster
  radar_data <- rbind(max_min, mean_by_cluster)
  
  # Convertir el radar_data a un dataframe
  radar_data <- as.data.frame(radar_data)
  
  # Asegurar que los nombres de columnas sean consistentes
  colnames(radar_data) <- colnames(mean_by_cluster)[-1]
  
  # Crear el gráfico de radar
  colors_border <- c(rgb(0.2, 0.5, 0.5, 0.9), rgb(0.8, 0.2, 0.5, 0.9), rgb(0.7, 0.5, 0.1, 0.9))
  colors_in <- c(rgb(0.2, 0.5, 0.5, 0.4), rgb(0.8, 0.2, 0.5, 0.4), rgb(0.7, 0.5, 0.1, 0.4))
  
  radarchart(radar_data, axistype = 1,
             # Personalizar las propiedades de los polígonos
             pcol = colors_border, pfcol = colors_in, plwd = 4, plty = 1,
             # Personalizar las propiedades de la red
             cglcol = "grey", cglty = 1, axislabcol = "grey", cglwd = 0.8,
             # Personalizar las etiquetas de los ejes
             vlcex = 0.8)
  
  # Añadir una leyenda para identificar los clusters
  legend(x = 1.5, y = 1.2, legend = paste("Cluster", 1:nrow(mean_by_cluster)), bty = "n", pch = 20, 
         col = colors_border, text.col = "black", cex = 1.2, pt.cex = 3)
  
}


grafico_radar2 <- function(df,clusterresults) {
  
  df2 <- as.data.frame(df)
  df <- as.data.frame(df)
  
  # Añadir la asignación de clusters al dataframe normalizado
  df$cluster <- as.factor(clusterresults$cluster)
  
  # Calcular la media de cada variable por cada cluster
  mean_by_cluster <- df %>%
    group_by(cluster) %>%
    summarise(across(everything(), mean))
  
  # Convertir mean_by_cluster a un dataframe
  mean_by_cluster <- as.data.frame(mean_by_cluster)
  
  
  # Transponer el dataframe de medias de clusters
  mean_by_cluster  <- mean_by_cluster[, -1] # Excluir la columna de cluster al transponer
  # Calcular los valores máximos y mínimos para el radar plot
  
  max_min <- data.frame(
    max = apply(df2, 2, max),
    min = apply(df2, 2, min)
  )
  
  # Transponer la tabla max_min para que cada columna sea una variable
  max_min <- t(max_min)
  
  # Convertir max_min a un dataframe y asegurar que las columnas tengan nombres consistentes
  max_min <- as.data.frame(max_min)
  
  
  
  # Combinar los datos de límite con los datos de cluster
  radar_data <- rbind(max_min, mean_by_cluster)
  
  # Convertir el radar_data a un dataframe
  radar_data <- as.data.frame(radar_data)
  
  # Asegurar que los nombres de columnas sean consistentes
  colnames(radar_data) <- colnames(mean_by_cluster)[-1]
  
  # Crear el gráfico de radar
  colors_border <- c(rgb(0.2, 0.5, 0.5, 0.9), rgb(0.8, 0.2, 0.5, 0.9), rgb(0.7, 0.5, 0.1, 0.9))
  colors_in <- c(rgb(0.2, 0.5, 0.5, 0.4), rgb(0.8, 0.2, 0.5, 0.4), rgb(0.7, 0.5, 0.1, 0.4))
  
  radarchart(radar_data, axistype = 1,
             # Personalizar las propiedades de los polígonos
             pcol = colors_border, pfcol = colors_in, plwd = 4, plty = 1,
             # Personalizar las propiedades de la red
             cglcol = "grey", cglty = 1, axislabcol = "grey", cglwd = 0.8,
             # Personalizar las etiquetas de los ejes
             vlcex = 0.8)
  
  # Añadir una leyenda para identificar los clusters
  legend(x = 1.5, y = 1.2, legend = paste("Cluster", 1:nrow(mean_by_cluster)), bty = "n", pch = 20, 
         col = colors_border, text.col = "black", cex = 1.2, pt.cex = 3)
  
}



# 1. Clustering con todas las variables. 
df1<-df_normalizado

# K-means clustering
set.seed(123)
kmeans_result1 <- kmeans(df1, centers = 3, nstart = 25)
silhouette_score <- silhouette(kmeans_result1$cluster, dist(df1)) # Calcular el Silhouette Score
mean(silhouette_score[, 3]) # Ver el promedio del calculo para evaluar el cluster.



grafico_radar(df1,kmeans_result1)
grafico_radar2(df1,kmeans_result1)

df_sin_na$KmeansCluster <- as.factor(kmeans_result1$cluster)
conteo_por_cluster <- table(df_sin_na$KmeansCluster)
conteo_por_cluster

# CLUSTERING CON SELECCION DE VARIABLES

df_normalizado <-  as.data.frame(df_normalizado)
df2 <- df_normalizado %>% select(-Mobile,-Mobile_Spending,-interne,-Internet_Spending,-TV,-TV_Spending,-Aditional_service,-Adicional_service_spending,-SolicitudesSAC,-reclamosSAC)


# K-means clustering
set.seed(123)
kmeans_result2 <- kmeans(df2, centers = 3, nstart = 25)
silhouette_score <- silhouette(kmeans_result2$cluster, dist(df2)) # Calcular el Silhouette Score
mean(silhouette_score[, 3]) # Ver el promedio del calculo para evaluar el cluster.

grafico_radar(df2,kmeans_result2)
grafico_radar2(df2,kmeans_result2)

df_sin_na$KmeansCluster2 <- as.factor(kmeans_result2$cluster)
conteo_por_cluster2 <- table(df_sin_na$KmeansCluster2)
conteo_por_cluster2


# CLUSTERING APLICANDO PCA 

df3 <-  as.data.frame(df_normalizado) 

# Realizar PCA
pca_result <- prcomp(df3, center = TRUE, scale. = TRUE)
summary(pca_result)

# Mostrar los "loadings" de cada componente principal
pca_result$rotation


dfpca <- data.frame(pca_result$x[, 1:3])  # Seleccionar los scores de los tres componentes principales

plot(dfpca)

# K-means clustering
set.seed(123)
kmeans_result3 <- kmeans(dfpca, centers = 3, nstart = 25)
silhouette_score <- silhouette(kmeans_result3$cluster, dist(dfpca)) # Calcular el Silhouette Score
mean(silhouette_score[, 3]) # Ver el promedio del calculo para evaluar el cluster.


grafico_radar(df1,kmeans_result3)
grafico_radar2(df1,kmeans_result3)



df_sin_na$KmeansCluster3 <- as.factor(kmeans_result3$cluster)
conteo_por_cluster3 <- table(df_sin_na$KmeansCluster3)
conteo_por_cluster3




mean_by_cluster1 <- df_sin_na %>%
  group_by(KmeansCluster) %>%
  summarise(across(everything(), mean))

mean_by_cluster2 <- df_sin_na %>%
  group_by(KmeansCluster2) %>%
  summarise(across(everything(), mean))

mean_by_cluster3 <- df_sin_na %>%
  group_by(KmeansCluster3) %>%
  summarise(across(everything(), mean))

print(t(mean_by_cluster1))

print(t(mean_by_cluster2))

print(t(mean_by_cluster3))

dfmetrics <- df_sin_na %>% select(-Gender,-Income,-Tenure,-KmeansCluster,-KmeansCluster2,-KmeansCluster3)


grafico_radar(dfmetrics,kmeans_result3)



#---------------------------------------------------------------------------
#Experimentos 

dfexp <- read_excel("telecom_customer_datasettratamiento.xlsx")

head(dfexp)
summary(dfexp)

dfexp$TotalSpend <- dfexp$Mobile_Spending  + dfexp$Internet_Spending + dfexp$TV_Spending + dfexp$Adicional_service_spending   

dfexp$Crecimiento <- dfexp$GastoTotalPost/dfexp$TotalSpend  

summary(dfexp)

modelo <- lm(Crecimiento  ~ Seleccionado, data=dfexp )

modelo2 <- lm(GastoTotalPost ~ Seleccionado + Age, data=dfexp )

modelo3 <- lm(Crecimiento  ~ Seleccionado + Age, data=dfexp )


summary(modelo3)

result <- dfexp %>%
  select(Seleccionado, Crecimiento, TotalSpend,GastoTotalPost)  %>%
  group_by(Seleccionado) %>%
  summarise(across(everything(), mean))

result