# Instalación de paquetes necesarios
#install.packages(c("forecast", "tseries", "ggplot2", "dplyr"))
library(forecast)
library(tseries)
library(ggplot2)
library(dplyr)

# Cargar el dataset de pasajeros aéreos
data("AirPassengers")
ts_data <- AirPassengers

# Visualización básica
plot(ts_data, main="Número de Pasajeros Aéreos (1949-1960)", ylab="Miles de pasajeros", xlab="Año")

# Descomposición de la serie de tiempo
decomp <- decompose(ts_data)
plot(decomp)

# -------- PROMEDIO MOVIL --------------------
# Calcular el Promedio Móvil Simple (SMA) con una ventana de 12 meses
sma_12 <- stats::filter(ts_data, filter = rep(1/12, 12), sides = 2)

# Visualización de la serie de tiempo original y el Promedio Móvil Simple
plot(ts_data, main="Número de Pasajeros Aéreos con SMA (12 meses)", ylab="Miles de pasajeros", xlab="Año")
lines(sma_12, col='red', lwd=2)

# -------- SUAVIZACION EXPONENCIAL --------------
# Suavización exponencial simple
ses_model <- HoltWinters(ts_data, beta=FALSE, gamma=FALSE)  #<- Sin ajuste de tendencia (beta) ni estacionalidad (gamma), el alpha se calcula automatico. 
plot(ses_model)

# Suavización exponencial de Holt-Winters
hw_model <- HoltWinters(ts_data) #<- Se deja en nulo los parametros, el modelo escoge los optimos para alpha, beta y gama. 
plot(hw_model)

# Predicción con el modelo Holt-Winters
forecast_hw <- forecast(hw_model, h=12)
plot(forecast_hw)


# ----------- REGRESIONES LINEALES -----------------

# Convertir la serie de tiempo a un dataframe para realizar regresión
ts_df <- data.frame(
  time = time(ts_data),
  passengers = as.numeric(ts_data),
  month = factor(cycle(ts_data)) # Extrae el ciclo mensual como un factor
)

# Ajustar un modelo de regresión lineal simple
lm_model <- lm(passengers ~ time, data = ts_df)
summary(lm_model)

# Visualización de la regresión lineal
ggplot(ts_df, aes(x = time, y = passengers)) +
  geom_line(color = 'blue') +
  geom_abline(intercept = coef(lm_model)[1], slope = coef(lm_model)[2], color = 'red') +
  labs(title = "Regresión Lineal sobre la Serie de Tiempo de Pasajeros Aéreos", 
       x = "Tiempo", y = "Pasajeros")

# Regresión Lineal Múltiple con una variable exógena simulada
ts_df$temperature <- rnorm(nrow(ts_df), mean = 20, sd = 5)
lm_model_multiple <- lm(passengers ~ time + temperature, data = ts_df)
summary(lm_model_multiple)

# Ajustar un modelo de regresión lineal con la estacionalidad (meses) incluida
lm_model_seasonal <- lm(passengers ~ time + month, data = ts_df)
summary(lm_model_seasonal)

# Predicciones del modelo ajustado
ts_df$predicted <- predict(lm_model_seasonal, newdata = ts_df)

ggplot(ts_df, aes(x = time, y = passengers)) +
  geom_line(color = 'blue', size = 1) +  # Serie de tiempo original
  geom_line(aes(y = predicted), color = 'red', size = 1, linetype = "dashed") +  # Predicción del modelo
  labs(title = "Modelo de Regresión Lineal con Estacionalidad (Meses)",
       x = "Tiempo", y = "Pasajeros") +
  theme_minimal()


# ----------------- ARIMA --------------------

# Comprobar la estacionariedad con la prueba de Dickey-Fuller aumentada
adf.test(ts_data)

# Ajuste del modelo ARIMA
arima_model <- auto.arima(ts_data)
summary(arima_model)

# Predicción con el modelo ARIMA
forecast_arima <- forecast(arima_model, h=12)
plot(forecast_arima)



#-------- SARIMA ---------- 

# Ajuste de un modelo SARIMA
sarima_model <- auto.arima(ts_data, seasonal=TRUE)
forecast_sarima <- forecast(sarima_model, h=12)
plot(forecast_sarima)



#---------- ARIMAX --------------------

# Crear una variable exógena simulada
set.seed(123)
exogenous_variable <- rnorm(length(ts_data), mean = 0, sd = 1)

# Ajustar un modelo ARIMAX
arimax_model <- auto.arima(ts_data, xreg = exogenous_variable)
summary(arimax_model)

# Predicción con el modelo ARIMAX
future_exogenous <- rnorm(12, mean = 0, sd = 1)
forecast_arimax <- forecast(arimax_model, xreg = future_exogenous, h=12)
plot(forecast_arimax)


#--------------- EVALUACION -------------
# Evaluación de los modelos utilizando métricas como MAE, RMSE, MAPE
accuracy(forecast_hw)
accuracy(forecast_arima)
accuracy(forecast_sarima)
accuracy(forecast_arimax)

