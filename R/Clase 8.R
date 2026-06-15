# Instalación de paquetes necesarios
#install.packages(c("forecast", "tseries", "ggplot2", "dplyr","readxl","lubridate"))
library(forecast)
library(tseries)
library(ggplot2)
library(dplyr)
library(readxl)
library(lubridate)

# LEEMOS EL ARCHIVO
ruta_archivo <- "VentaProductoX.xlsx"
datos <- read_excel(ruta_archivo)

################ TRANSFORMAR DATOS INICIAL ############################# 

datos$Fecha <- as.Date(datos$Fecha, format="%d-%m-%Y")

summary(datos)

#Hago una variable temporal solo con la Fecha y las Ventas en Unidades para graficar mas facilmente. 
serieTemp <- datos %>% select(Fecha, 'Ventas (U)')


################ ESTUDIAR LA SERIE ############################# 

# Graficar la serie temporal
ggplot(serieTemp, aes(x = Fecha, y = `Ventas (U)`)) +
  geom_line(color = "blue") +  # Dibuja una línea azul
  labs(title = "Serie Temporal de Ventas en Unidades",
       x = "Fecha",
       y = "Ventas (U)") +
  theme_minimal()


# Crear la serie temporal con datos diarios
serieTempTS <- ts(serieTemp$`Ventas (U)`, start = c(2022, 9, 3), frequency = 360)  # Datos diarios desde el 3 de septiembre de 2022

# Descomposición de la serie de tiempo para revisar como se comporta. 
decomp <- decompose(serieTempTS)
plot(decomp)


################ ESTO FUE PARA ESTUDIAR LA SERIE ############################# 

############# REGRESION ########################### 

# GENERAR DATOS PARA EL MODELO

datos2 <- datos %>%
  # Generar variable de precio diario (Monto / Ventas (U))
  mutate(
          Precio = `Ventas ($)` / `Ventas (U)`,
         # Agregar tendencia (índice del tiempo)
         Tendencia = 1:n(),
         # Estacionalidad - día de la semana
         DiaSemana = wday(Fecha, label = TRUE),
         # Estacionalidad - mes del año
         Mes = month(Fecha, label = TRUE),
         # Precio anterior (precio del día anterior)
         Precio_Anterior = lag(Precio, 1),
         # Precio anterior (precio del día anterior)
         Precio_Anterior2 = lag(Precio, 2),
         # Precio anterior (precio del día anterior)
         Precio_Anterior3 = lag(Precio, 3),
         Precio_Anterior4 = lag(Precio, 4),
         Precio_Anterior5 = lag(Precio, 5),
         Precio_Anterior6 = lag(Precio, 6),
         Precio_Anterior7 = lag(Precio, 7),
         Precio_Anterior8 = lag(Precio, 8),
         Precio_Anterior9 = lag(Precio, 9),
         Precio_Anterior10 = lag(Precio, 10)
  )

#Revisar como quedaron los datos generados. 
head(datos2)

# Grafico de la demanda vs el precio para ver una relacion a priori.  
ggplot(datos2, aes(x = Fecha)) +
  geom_line(aes(y = `Ventas (U)`, color = "Demanda (Unidades)"), size = 1) +  # Línea de demanda
  geom_line(aes(y = Precio /100, color = "Precio"), size = 1) +  # Línea del precio (ajustamos la escala)
  scale_y_continuous(
    name = "Demanda (Unidades)",  # Eje izquierdo para la demanda
    sec.axis = sec_axis(~ . / 100, name = "Precio")  # Eje derecho para el precio con ajuste de escala
  ) +
  labs(title = "Demanda y Precio a lo largo del tiempo",
       x = "Fecha",
       color = "Leyenda") +
  theme_minimal() +
  theme(legend.position = "top")



#Transformo las variables a factores no Ordenados
datos2$DiaSemana <- factor(datos2$DiaSemana, ordered = FALSE)
datos2$Mes <- factor(datos2$Mes, ordered = FALSE)

# Modelo de regresión con variables categóricas (se transforman automaticamente en binarias)
modelo <- lm(`Ventas (U)` ~ Tendencia + DiaSemana + Mes + Precio + Precio_Anterior + Precio_Anterior2 + Precio_Anterior3 + Precio_Anterior4 + Precio_Anterior5 + Precio_Anterior6 + Precio_Anterior7 + Precio_Anterior8 + Precio_Anterior9 + Precio_Anterior10 , data = datos2)

summary(modelo)

#Otro modelo sacando algunas variables no relevantes. 
modelo2 <- lm(`Ventas (U)` ~ Tendencia + DiaSemana + Mes + Precio , data = datos2)

summary(modelo2)


# ANALIZAR RESIDUOS DE LA REGRESION 

# Extraer los residuos del modelo
#residuos <- residuals(modelo2)
# Gráfico de residuos vs. valores ajustados
#plot(fitted(modelo), residuos,
#     xlab = "Valores ajustados",
#     ylab = "Residuos",
#     main = "Residuos vs. Valores ajustados")
#abline(h = 0, col = "red")  # Línea horizontal en 0 para referencia
# Histograma de los residuos
#hist(residuos, breaks = 20, main = "Histograma de los residuos", xlab = "Residuos")

# Gráfico Q-Q de los residuos
#qqnorm(residuos)
#qqline(residuos, col = "red")  # Línea de referencia de la normalidad


# Gráficos diagnósticos automáticos del modelo
#par(mfrow = c(2, 2))  # Mostrar 4 gráficos en una misma ventana
#plot(modelo)
#par(mfrow = c(1, 1))  # Restaurar la ventana gráfica

################## FIN ESTUDIO RESIDUOS ################### 

# Extraer los resultadoS de la regresion para una mejor presentacion. 
coeficientes <- summary(modelo2)$coefficients

# Crear un dataframe con los resultados y aplicar formato
resultado_df <- as.data.frame(coeficientes)

# Agregar nombres de columnas para que quede claro qué representa cada una
colnames(resultado_df) <- c("Estimación", "Error Estándar", "Valor t", "Valor P")

# Aplicar formato a los números, por ejemplo, redondear a 3 decimales
resultado_df$Estimación <- format(round(resultado_df$Estimación, 3), nsmall = 3)
resultado_df$`Error Estándar` <- format(round(resultado_df$`Error Estándar`, 3), nsmall = 3)
resultado_df$`Valor t` <- format(round(resultado_df$`Valor t`, 3), nsmall = 3)
resultado_df$`Valor P` <- format.pval(resultado_df$`Valor P`, digits = 3)

# Mostrar el resultado formateado
print(resultado_df)



################ OPTIMIZACION ############################ 

# Extraer solo los coeficientes del modelo
betas <- coef(modelo2)


demanda <- function(precio, tendencia, dia_semana, mes, demanda_anterior1, demanda_anterior2, demanda_anterior3) {
  
  # Definir valores por defecto para días y meses no presentes en los regresores
  DS <- ifelse(dia_semana == "DiaSemanadom\\.", 0, betas[dia_semana])
  MES <- ifelse(mes == "Mesene", 0, betas[mes])
  
  # Calcular la demanda
  demanda = betas["(Intercept)"] +
    betas["Tendencia"] * tendencia +
    DS + MES +
    betas["Precio"] * precio +
    betas["Demanda_Anterior"] * demanda_anterior1 +
    betas["Demanda_Anterior2"] * demanda_anterior2 +
    betas["Demanda_Anterior3"] * demanda_anterior3
  
  return(as.numeric(demanda))
}


# Definir la función de ingresos
ingresos <- function(precio, tendencia, dia_semana, mes, demanda_anterior1, demanda_anterior2, demanda_anterior3) {
  demanda_estimada = demanda(precio, tendencia, dia_semana, mes, demanda_anterior1, demanda_anterior2, demanda_anterior3)
  ingresos = precio * demanda_estimada
  
  return(as.numeric(ingresos))
}


# Crear el diccionario para los días de la semana a utilizar mas adelante
mapa_dias_semana <- c(
  "dom\\." = "DiaSemanadom\\.",
  "lun\\." = "DiaSemanalun\\.",
  "mar\\." = "DiaSemanamar\\.",
  "mié\\." = "DiaSemanamié\\.",
  "jue\\." = "DiaSemanajue\\.",
  "vie\\." = "DiaSemanavie\\.",
  "sáb\\." = "DiaSemanasáb\\."
)


# Crear el diccionario para los meses
mapa_meses <- c(
  "ene" = "Mesene",
  "feb" = "Mesfeb",
  "mar" = "Mesmar",
  "abr" = "Mesabr",
  "may" = "Mesmay",
  "jun" = "Mesjun",
  "jul" = "Mesjul",
  "ago" = "Mesago",
  "sept" = "Messept",
  "oct" = "Mesoct",
  "nov" = "Mesnov",
  "dic" = "Mesdic"
)

# Definimos unas variables de prueba, basado en dia de mañana. (Se podria utilizar cualquier dia para esto) 
dia_semana <- wday(max(datos2$Fecha + 1), label = TRUE)
dia_semana_regresor <- mapa_dias_semana[as.character(dia_semana)]
mes <- month(max(datos2$Fecha + 1), label = TRUE)
mes_regresor <- mapa_meses[as.character(mes)]

tendencia_actual <- max(datos2$Tendencia) + 1 # Valor de ejemplo para tendencia
dia_semana_actual <- dia_semana_regresor  # Día de la semana, por ejemplo, jueves
mes_actual <- mes_regresor # Mes actual, por ejemplo, septiembre
demanda_anterior1 <- datos2$`Ventas (U)`[max(datos2$Tendencia)]    # Ejemplo de demanda del día anterior
demanda_anterior2 <- datos2$`Ventas (U)`[max(datos2$Tendencia)-1]  # Ejemplo de demanda de hace 2 días
demanda_anterior3 <- datos2$`Ventas (U)`[max(datos2$Tendencia)-2]  # Ejemplo de demanda de hace 3 días


# Crear Histograma de precio para ver el rango de precios (para ver que valores utilizar en el modelo)
hist(datos2$Precio, 
     main = "Histograma de Precios", 
     xlab = "Precio", 
     ylab = "Frecuencia", 
     col = "lightblue", 
     border = "black")

#Vemos que las funciones anteriores sirvan estimando el ingreso con un precio cualquiera. 
PrecioOptimo=59990
ingresosEstimado = ingresos(PrecioOptimo, tendencia_actual, dia_semana_actual, mes_actual, demanda_anterior1, demanda_anterior2, demanda_anterior3)
ingresosEstimado


optimo <- optimize(
  f = function(precio) {
    ingresos_est <- ingresos(precio, tendencia_actual, dia_semana_actual, mes_actual, demanda_anterior1, demanda_anterior2, demanda_anterior3)
    
    # Si ingresos_est es NA o infinito, devuelve un valor alto
    if (is.na(ingresos_est) || is.infinite(ingresos_est)) {
      return(Inf)
    } else {
      return(-ingresos_est)  # Minimizar para optimizar
    }
  },
  interval = c(45000, 70000)  # Intervalo de precios posible
)

# Ver el precio óptimo
optimo$maximum

# Ver el precio óptimo
optimo$maximum

summary(optimo)



optimo <- optimize(
  f = function(precio) {
    ingresos_est <- ingresos(precio, tendencia_actual, dia_semana_actual, mes_actual, demanda_anterior1, demanda_anterior2, demanda_anterior3)
    
    print(paste("Precio:", precio, "Ingresos:", ingresos_est))  # Depuración
    
    if (is.na(ingresos_est) || is.infinite(ingresos_est)) {
      return(Inf)
    } else {
      return(-ingresos_est)
    }
  },
  interval = c(45000, 70000)
)

