# 1. Instalar y cargar las librerías necesarias
# install.packages(c("ggplot2", "maps"))
library(ggplot2)
library(maps)

# 2. Crear el DataFrame de ejemplo (reemplázalo con tus propios datos)
#mis_puntos <- data.frame(
#  latitud = c(34.05, -33.45, 40.71, 51.51, -15.78), # Latitudes de algunas ciudades
#  longitud = c(-118.24, -70.67, -74.01, -0.13, -47.93), # Longitudes de algunas ciudades
#  nombre = c("Los Ángeles", "Santiago", "Nueva York", "Londres", "Brasilia")
#)

datos_cargados <- read.csv("C:/Users/fmart/Documents/DiplomadoUC2/Curso2/Google Colab/R/datasets/V5_ubicación_fallecidos.csv", sep = ",",header=TRUE)
head(datos_cargados, n=6)
mis_puntos<-datos_cargados
names(datos_cargados)
names(mis_puntos) <- c("latitud","longitud")

ndelta <- abs(mean(mis_puntos$longitud))+25
mis_puntos$longitud <- mis_puntos$longitud + ndelta

summary(mis_puntos)
head(mis_puntos, n=30)

# 3. Obtener los datos del mapa mundial (del paquete maps)
datos_mapa_mundial <- map_data("world")

# 4. Generar el Gráfico
mapa_de_puntos <- ggplot() +
  
  # A. Trazar el mapa mundial como polígonos
  geom_polygon(
    data = datos_mapa_mundial,
    aes(x = long, y = lat, group = group),
    fill = "lightgray", # Color de los continentes
    color = "white"     # Color de los bordes
  ) +
  
  # B. Superponer tus puntos (latitud/longitud)
  geom_point(
    data = mis_puntos,
    aes(x = longitud, y = latitud),
    color = "red",       # Color de los puntos
    size = 3,            # Tamaño de los puntos
    alpha = 0.8          # Transparencia
  ) +
  
  # C. Configurar el sistema de coordenadas (proyección)
  # Coord_quickmap() es una buena opción para mapas mundiales simples
  coord_quickmap() +
  
  # D. Personalizar títulos y tema
  labs(
    title = "Localización de Puntos en el Mapa Mundial",
    x = "Longitud",
    y = "Latitud"
  ) +
  
  # Usar un tema limpio para el mapa
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(), # Eliminar líneas de la grilla
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "lightblue") # Color de fondo del océano
  )

# 5. Mostrar el gráfico
print(mapa_de_puntos)

