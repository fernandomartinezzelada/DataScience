# Instalación de paquetes necesarios
#install.packages(c("forecast", "tseries", "ggplot2", "dplyr","readxl","lubridate"))
#install.packages("nloptr") install.packages("ISOweek")
library(forecast)
library(tseries)
library(ggplot2)
library(dplyr)
library(readxl)
library(lubridate)
library(nloptr)  #Para la optimizacion
library(ISOweek)

# LEEMOS EL ARCHIVO
ruta_archivo <- "VentaProductoX.xlsx"
datos <- read_excel(ruta_archivo)

################ TRANSFORMAR DATOS INICIAL ############################# 

datos$Fecha <- as.Date(datos$Fecha, format="%d-%m-%Y")

datos

summary(datos)


#Vamos a transformar el DataSet a Semana:
# Extraer el año y la semana
datos$Año <- year(datos$Fecha)
datos$Semana <- week(datos$Fecha)

datos$Semana <- ifelse(datos$Semana==53,52,datos$Semana)

datos$AñoSemana <- paste0(datos$Año,datos$Semana)

resumen_semanal <- datos %>%
  group_by(AñoSemana) %>%
  summarise(
    Ventas_U = sum(`Ventas (U)`, na.rm = TRUE),
    Ventas_Dinero = sum(`Ventas ($)`, na.rm = TRUE),
    Conteo_Registros = n()  # Contas dias de venta efectivos dentro de esa semana (dias habiles)
  )

#Agrego a la tabla el numero de semana 
resumen_semanal$Semana <- substr(resumen_semanal$AñoSemana, nchar(resumen_semanal$AñoSemana) - 1, nchar(resumen_semanal$AñoSemana))


#Hago una variable temporal solo con la Fecha y las Ventas en Unidades para graficar mas facilmente. 
serieTemp <- datos %>% select(AñoSemana, 'Ventas (U)')


################ ESTUDIAR LA SERIE ############################# 

# Graficar la serie temporal
ggplot(serieTemp, aes(x = AñoSemana, y = `Ventas (U)`)) +
  geom_line(color = "blue") +  # Dibuja una línea azul
  labs(title = "Serie Temporal de Ventas en Unidades",
       x = "AñoSemana",
       y = "Ventas (U)") +
  theme_minimal()

serie_semana <- serieTemp %>%
  group_by(AñoSemana) %>%
  summarise(ventas_semana = sum(`Ventas (U)`)) %>%
  arrange(AñoSemana)

serie_semana <- serie_semana %>%
  mutate(semana_index = row_number())

serieTS <- ts(serie_semana$ventas_semana, frequency = 52)

# Descomposición de la serie de tiempo para revisar como se comporta. 
decomp <- decompose(serieTS)
plot(decomp)



################ ESTO FUE PARA ESTUDIAR LA SERIE ############################# 

############# REGRESION ########################### 

# GENERAR DATOS PARA EL MODELO

invierno <- c("16","17","18","19","20","21","22","23","24","25","26","27","28")
Primavera <- c("29","30","31","32","33","34","35","36","37","38","39","40","41")
Verano <- c("42","43","44","45","46","47","48","49","50","51","52","01","02")
Otono <- c("03","04","05","06","07","08","09","10","11","12","13","14","15")

datos2 <- resumen_semanal %>%
  # Generar variable de precio diario (Monto / Ventas (U))
  mutate(Precio = `Ventas_Dinero` / `Ventas_U`,
         # Agregar tendencia (índice del tiempo)
         Tendencia = 1:n(),
         Inv = if_else(Semana %in% invierno, 1, 0),
         pri = if_else(Semana %in% Primavera, 1, 0),
         ver = if_else(Semana %in% Verano, 1, 0),
         oto = if_else(Semana %in% Otono, 1, 0),
         # Precio anterior (precio de la semana anterior)
         Precio_Anterior = lag(Precio, 1),
         VarPrecio = Precio/Precio_Anterior-1,
         # Precio anterior (precio de las dos semanas anteriores)
         Precio_Anterior2 = lag(Precio, 2),
  )

#Revisar como quedaron los datos generados. 
head(datos2)

# Grafico de la demanda vs el precio para ver una relacion a priori.  
ggplot(datos2, aes(x = Tendencia, y = Precio/100, color = "Precio")) +
  geom_line() +
  geom_line(aes(y = Ventas_U, color = "Ventas (U)")) +
  labs(title = "Evolución de Precio y Ventas",
       x = "Tendencia (Tiempo)",
       y = "Valores") +
  scale_color_manual(values = c("blue", "red")) +  # Definir colores para las series
  theme_minimal()


# Modelo de regresión con variables categóricas (se transforman automaticamente en binarias)
modelo <- lm(Ventas_U ~ Tendencia + Conteo_Registros + Inv+ pri + ver + Precio  + VarPrecio, data = datos2)

summary(modelo)

#Otro modelo sacando algunas variables no relevantes. 
modelo2 <- lm(Ventas_U ~ Tendencia + Conteo_Registros + Inv+ pri + ver + Precio  , data = datos2)

summary(modelo2)


modelo3 <- lm(Ventas_U ~ Precio + Inv + Conteo_Registros, data = datos2)

summary(modelo3)


modelo4 <- lm(Ventas_U ~ Precio, data = datos2)

summary(modelo4)


# ANALIZAR RESIDUOS DE LA REGRESION 

# Extraer los residuos del modelo
residuos <- residuals(modelo2)
# Gráfico de residuos vs. valores ajustados
plot(fitted(modelo2), residuos,
     xlab = "Valores ajustados",
     ylab = "Residuos",
     main = "Residuos vs. Valores ajustados")
abline(h = 0, col = "red")  # Línea horizontal en 0 para referencia

# Histograma de los residuos
hist(residuos, breaks = 20, main = "Histograma de los residuos", xlab = "Residuos")

# Gráfico Q-Q de los residuos
qqnorm(residuos)
qqline(residuos, col = "red")  # Línea de referencia de la normalidad


# Gráficos diagnósticos automáticos del modelo
par(mfrow = c(2, 2))  # Mostrar 4 gráficos en una misma ventana
plot(modelo)
par(mfrow = c(1, 1))  # Restaurar la ventana gráfica

################## FIN ESTUDIO RESIDUOS ################### 

################## FORMATEAR COEFICIENTES Y RESULTADOS ################### 

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

################## FIN FORMATEO ################### 

################ OPTIMIZACION ############################ 

# Extraer solo los coeficientes del modelo
betas <- coef(modelo2)


demanda <- function(precio, dias_habiles, Inv, pri,ver) {

  # Calcular la demanda
  demanda = betas["(Intercept)"] +
    #betas["Tendencia"] * tendencia +
    betas["Precio"] * precio +
    betas["Conteo_Registros"] * dias_habiles +
    betas["Inv"] * Inv +
    betas["pri"] * pri +
    betas["ver"] * ver 
  
  return(as.numeric(demanda))
}

demanda(49990,5,1,0,0)

# Definir la función de ingresos
ingresos <- function(precio, dias_habiles, Inv, pri,ver) {
  demanda_estimada = demanda(precio, dias_habiles, Inv, pri,ver)
  ingresos = precio * demanda_estimada
  return(as.numeric(ingresos))
}

ingresos(49990,5,1,0,0)

# Función objetivo: Maximizar los ingresos totales en las 7 semanas
objective_function <- function(precios, dias_habiles, Inv, pri, ver) {
  ingresos_totales = 0
  for (i in 1:7) {
    ingresos_totales = ingresos_totales + ingresos(precios[i], dias_habiles[i], Inv[i], pri[i], ver[i])
  }
  return(-ingresos_totales)  # Usamos negativo para maximizar
}


# Crear Histograma de precio para ver el rango de precios (para ver que valores utilizar en el modelo)
hist(datos2$Precio, 
     main = "Histograma de Precios", 
     xlab = "Precio", 
     ylab = "Frecuencia", 
     col = "lightblue", 
     border = "black")


# Lista de días hábiles para las próximas 7 semanas
dias_habiles <- c(7, 7, 7, 7, 5, 7, 6)

# Indicador de Invierno
Inv <- c(0, 0, 0, 0, 0, 0, 0)

# Indicador de primavera
pri <- c(1, 1, 0, 0, 0, 0, 0)

# Indicador de verano
ver <- c(0, 0, 1, 1, 1, 1, 1)

# Valores iniciales de los precios (por ejemplo, precios sin descuento inicialmente)
precios_iniciales <- rep(69990, 7)


# Configuración del optimizador local para usar en NLOPT_LN_AUGLAG
local_opts <- list("algorithm" = "NLOPT_LN_COBYLA", "xtol_rel" = 1e-8)

# Ejecutar el optimizador con NLOPT_LN_AUGLAG y el optimizador local NLOPT_LN_COBYLA
resultado <- nloptr(
  x0 = precios_iniciales,                    # Precios iniciales
  eval_f = function(precios) {
    objective_function(precios, dias_habiles, Inv, pri, ver)
  },
  lb = rep(29990, 7),                        # Precio mínimo (Costo)
  ub = rep(69990, 7),                        # Precio máximo
  #eval_g_ineq = inequality_constraints,      # Restricciones no lineales
  opts = list("algorithm" = "NLOPT_LN_AUGLAG", 
              "xtol_rel" = 1e-8,
              "local_opts" = local_opts)     # Optimización local
)

# Resultados
print(resultado$solution)

IngresosOptimizados=-objective_function(resultado$solution,dias_habiles, Inv, pri, ver)  #Recuerden que la funcion objetivo estaba en -

precios_comerciales = c(69990, 69990, 69990, 49990, 49990, 49990, 69990)

IngresosComerciales=-objective_function(precios_comerciales,dias_habiles, Inv, pri, ver)


IngresosOptimizados - IngresosComerciales



