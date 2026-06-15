################################################################################
# Evaluación 3b – Reglas de Asociación                                         #
# Alumno1: Fernando Martinez Z.                                                #
# Alomno2: Fabian Valdez                                                       #
# Fecha: 26-10-2025.                                                           #
################################################################################

# Instalamos los paquetes necesarios, en caso que no los tengamos instaladas
#install.packages("arules")
#install.packages("arulesViz")

# Cargamos las librerias que utilizaremos
library(arules)
library(arulesViz)

# Indicamos el directorio de trabajo
setwd("C:/Users/fmart/Documents/DiplomadoUC2/Curso3/R")

# Cargamos la base de datos
datos_cargados <- read.csv("./datasets/lastfm.csv", sep = ";",header=TRUE)
head(datos_cargados, n=30)

#Observacion preliminar:
#La base de datos contiene registros de 15.000 listas de reproducción musical (i.e. “transacciones”) de personas de distintos países.
#En cada lista de reproducción pueden estar más de 1.000 artistas de distintos géneros musicales.

# Summary para generar un resumen estadistico de la base de datos
summary(datos_cargados)

# 1. ANALISIS PRELIMINAR:
datos <- datos_cargados # Hacemos una copia de la base
nrow(datos) # 289955 filas

#Se hace una revision rapida de datos de las columnas:
unique(datos$user)           # 1 - 15000
unique(datos$size)           # 1 - 76
unique(datos$artist_id)      # 1 - 76
sort(unique(datos$artist))
length(unique(datos$artist)) # 1004

v_user <- unique(datos$user) # Vector de numeros de user unicos

for (nuser in v_user){
   datos_user <- datos[datos$user==nuser,] # Datos filtrados por numero de user
   v_size_usr <- unique(datos_user$size)   # Vector de sizes unicos por user
   if (length(v_size_usr)>1){ # Se verifica que todos los sizes son unicos por user
     print(nuser)
     next
   }
   n_size_usr <- unique(datos_user$size)         # Valor unico de size por user
   v_artistid_usr <- sort(datos_user$artist_id)  # Vector ordenado de artistid por user
   max_artistid_usr <- max(v_artistid_usr)       # Maximo artistid por user
   len_artistid_usr <- length(v_artistid_usr)    # Largo Vector de artistid por user
   if (n_size_usr!=max_artistid_usr   # Se verifica que el maximo artistid es identico al valor unico de size por user
     | n_size_usr!=len_artistid_usr){ # Se verifica que el largo del Vector de artistid por user es identico al valor unico de size por user
     print(nuser)
     next
   }
   for (i in 1:len_artistid_usr) {
     if (i != v_artistid_usr[i]) { # Se verifica que artist_id es solo un contador incremental para todos los user
       print(
         paste0(nuser," : ",v_artistid_usr[i])
       )
     }
   }
}

#Observacion: El analisis preliminar indica que user es el numero de usuario,
# size corresponde al numero total de artistas por lista de usuario,
# y artist_id es un contador incremental que indica la posicion de un artista dentro de la lista de un usuario.
# Por lo tanto, los datos que parecen ser de utilidad son el nombre del artista
# y el numero de usuario (que agrupa las preferencias de un mismo usuario, es decir, como un itemset),
# de modo que el numero de usuario sera el numero de la transaccion.
# Se consideran irrelevantes las otras 2 columnas por aportar datos redundates.

#Creamos entonces el objeto Transaction con los campos relevantes:
trans <- transactions(datos, format = "long", cols = c("user"   #Transaction_ID
                                                     , "artist" #Item
))
class(trans)
trans                   # 15000 transactions
length(trans)
inspect(head(trans, 6))
summary(trans)

# Calculamos el support para items frecuentes (support >= 0.1%):
frequentItems <- eclat(trans,
                       parameter = list(supp = 0.001) # 0.1%
)
class(frequentItems)
frequentItems # 273005 itemsets (demasiados itemsets)
inspect(head(frequentItems,30))

# Calculamos el support para items frecuentes (support >= 1%):
frequentItems <- eclat(trans,
                       parameter = list(supp = 0.01) # 1%
)
class(frequentItems)
frequentItems # 1689 itemsets (que parece un numero mas razonable)
inspect(head(frequentItems,30))

# Calculamos el support para items frecuentes (support >= 5%):
frequentItems <- eclat(trans,
                       parameter = list(supp = 0.05) # 5%
)
class(frequentItems)
frequentItems # 65 itemsets (que parece un numero tambien interesante)
inspect(head(frequentItems,30))

# Calculamos el support para items frecuentes (support >= 10%):
frequentItems <- eclat(trans,
                       parameter = list(supp = 0.1) # 10%
)
class(frequentItems)
frequentItems # 7 itemsets (que parece un numero muy pequeño)
inspect(head(frequentItems,30))

# 2. ALGORITMO APRIORI:

# Aplicamos el algoritmo Apriori ahora con un suporte minimo de un 1% y una confiaza minima de un 10%
# (Se consideran también razonables reglas de un maximo de 10 itemsets, y 30 segundos maximo de ejecucion):
resultados <- apriori(trans,
                      parameter = list(supp = 0.01,   # soporte minimo: 1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    #  2 itemsets minimo
                                       maxlen = 10,   # 10 itemsets maximos
                                       maxtime = 30)) # tiempo limite: 30 segundos

# Analizamos los resultados:
class(resultados)
length(resultados) # 1903 Reglas
summary(resultados)
inspect(head(sort(resultados,by="confidence",decreasing=T),300))

# Aplicamos el algoritmo Apriori entonces con un suporte minimo de un 5% y una confiaza minima de un 10%
# (Se consideran también razonables reglas de un maximo de 10 itemsets, y 30 segundos maximo de ejecucion):
resultados <- apriori(trans,
                       parameter = list(supp = 0.05,   # soporte minimo: 5%
                                        conf = 0.1,    # confianza minima: 10%
                                        minlen = 2,    #  2 itemsets minimo
                                        maxlen = 10,   # 10 itemsets maximos
                                        maxtime = 30)) # tiempo limite: 30 segundos

# Analizamos los resultados:
class(resultados)
length(resultados) # 4 Reglas
summary(resultados)
inspect(head(sort(resultados,by="confidence",decreasing=T),300))

# Algunas representaciones graficas
plot(resultados, method = "paracoord") # Se aprecia una mayor confianza (sobre 30%) para {radiohead}=>{coldplay} y {coldplay}=>{radiohead}
plot(resultados, method = "graph") # Las reglas {radiohead}=>{coldplay} y {coldplay}=>{radiohead} muestran tambien un mayor Lift (>1.9)

# Aplicamos el algoritmo Apriori entonces con un suporte minimo de un 2.5% y una confiaza minima de un 10%
# (Se consideran también razonables reglas de un maximo de 10 itemsets, y 30 segundos maximo de ejecucion):
resultados <- apriori(trans,
                      parameter = list(supp = 0.025,   # soporte minimo: 2.5%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    #  2 itemsets minimo
                                       maxlen = 10,   # 10 itemsets maximos
                                       maxtime = 30)) # tiempo limite: 30 segundos

# Analizamos los resultados:
class(resultados)
length(resultados) # 102 Reglas
summary(resultados)
inspect(head(sort(resultados,by="confidence",decreasing=T),300))

# Algunas representaciones graficas
plot(resultados, method = "paracoord")
plot(resultados, method = "graph")

# Aplicamos el algoritmo Apriori entonces con un suporte minimo de un 2.5% y una confiaza minima de un 25%
# (Se consideran también razonables reglas de un maximo de 10 itemsets, y 30 segundos maximo de ejecucion):
resultados <- apriori(trans,
                      parameter = list(supp = 0.025,   # soporte minimo: 2.5%
                                       conf = 0.25,    # confianza minima: 25%
                                       minlen = 2,    #  2 itemsets minimo
                                       maxlen = 10,   # 10 itemsets maximos
                                       maxtime = 30)) # tiempo limite: 30 segundos

# Analizamos los resultados:
class(resultados)
length(resultados) # 56 Reglas
summary(resultados)
inspect(head(sort(resultados,by="confidence",decreasing=T),300))

# Algunas representaciones graficas
plot(resultados, method = "paracoord")
plot(resultados, method = "graph")

# Aplicamos el algoritmo Apriori entonces con un suporte minimo de un 2.5% y una confiaza minima de un 50%
# (Se consideran también razonables reglas de un maximo de 10 itemsets, y 30 segundos maximo de ejecucion):
resultados <- apriori(trans,
                      parameter = list(supp = 0.025,   # soporte minimo: 2.5%
                                       conf = 0.5,    # confianza minima: 50%
                                       minlen = 2,    #  2 itemsets minimo
                                       maxlen = 10,   # 10 itemsets maximos
                                       maxtime = 30)) # tiempo limite: 30 segundos

# Analizamos los resultados:
class(resultados)
length(resultados) # 2 Reglas
summary(resultados)
inspect(head(sort(resultados,by="confidence",decreasing=T),300))

# Algunas representaciones graficas
plot(resultados, method = "paracoord") # Se aprecia una mayor confianza (>52.5%) para {snow patrol} => {coldplay}
plot(resultados, method = "graph") # La regla {snow patrol} => {coldplay} muestra tambien un mayor Lift (>3.31)

# Observacion: Tras ejecutar el Algoritmo Apriori con diferentes parametros se aprecia que estos se tornan mas adecuados,
# en torno a un soporte minimo de 2.5%, y una confianza minima de 25%, obteniéndose 56 Reglas.
# Con un soporte minimo de 5% y una confianza minima de 10%, se obtiene un numero mas ajustado para hacer analisis, de 4 reglas,
# donde las reglas {radiohead}=>{coldplay} y {coldplay}=>{radiohead} mostraron la mayor confianza y Lift.

# 3. RECOMENDACIONES DE ARTISTAS A 10 AMIGOS:

#1. Arctic Monkeys ({arctic monkeys}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="arctic monkeys")
                      )
# Analizamos los resultados:
class(resultados)
length(resultados) # 49 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de un 10% te recomendamos tambien:
reglas$rhs

#2. Beyonce ({beyonce}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="beyonce")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 47 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#3. Coldplay ({coldplay}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="coldplay")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 40 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#4. Jimi Hendrix ({jimi hendrix}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="jimi hendrix")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 44 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#5. Metallica ({metallica}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="metallica")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 39 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#6. Muse ({muse}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="muse")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 43 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#7. Slayer ({slayer}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="slayer")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 50 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#8. The Killers ({the killers}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="the killers")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 42 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#9. The Shins ({the shins}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="the shins")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 60 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

#10. Wilco ({wilco}=>{B})
resultados <- apriori(trans,
                      parameter = list(supp = 0.001,   # soporte minimo: 0.1%
                                       conf = 0.1,    # confianza minima: 10%
                                       minlen = 2,    # 2 itemsets minimo
                                       maxlen = 2,   #  2 itemsets maximos
                                       maxtime = 30), # tiempo limite: 30 segundos
                      appearance = list(lhs ="wilco")
)
# Analizamos los resultados:
class(resultados)
length(resultados) # 64 Reglas
summary(resultados)
reglas<-inspect(head(sort(resultados,by="confidence",decreasing=T),300))
# Respuesta: Con una confianza de al menos un 10% te recomendamos tambien:
reglas$rhs

# Jusificacion de los resultados: Preliminarmente la obtencion de itemsets de un soporte minimo de 0.1% permitio obtener 273005 itemsets,
# que se encuentra en torno al numero de filas de la base de datos. Aplicando filtros de confianza minima de un 10%,
# y filtrando ademas por el antecedente correspondiente al artista favorito de cada amigo, se obtienen entre 39 y 64 reglas,
# cuyo numero parece razonable para ser recomendados a cada amigo.
