library(ggplot2)

# 1. Crear el DataFrame de ejemplo
#datos <- data.frame(
#  edad = c(15,75),
#  sintomas = factor(c("base", "extendido")),
#  peso = c(70, 100),
#  altura = c(175, 175)
#)

datos_cargados <- read.csv("C:/Users/fmart/Documents/DiplomadoUC2/Curso2/Google Colab/R/datasets/V7_carac_infectados.csv", sep = ",",header=TRUE)
head(datos_cargados, n=30)
datos<-datos_cargados
unique(datos$Sintomas)

names(datos) <- c("edad","sintomas","peso","altura")

class(datos)
head(datos)

# 2. Generar el Gráfico de Burbujas
grafico_burbujas <- ggplot(datos, aes(x = altura, y = peso)) +
  # Usa geom_point para las burbujas
  geom_point(
    # El tamaño (size) se mapea a la columna 'edad'
    aes(size = edad, color = sintomas),
    alpha = 0.6  # Añade transparencia para mejor visualización
  ) +
  
  # 3. Asignar colores según la columna 'sintomas'
  scale_color_manual(
    values = c("base" = "yellow", "extendido" = "red")
  ) +
  
  # 4. Personalizar las escalas y títulos
  labs(
    title = "Gráfico de Burbujas: Peso vs. Altura por Tipo de Síntomas",
    x = "Altura (cm)",
    y = "Peso (kg)",
    size = "Edad", # Título para la leyenda del tamaño
    color = "Síntomas" # Título para la leyenda del color
  ) +
  
  # Opcional: Ajustar el rango del tamaño para que las burbujas se vean bien
  scale_size(range = c(3, 15)) +
  
  # Opcional: Tema de visualización
  theme_minimal()

# 5. Mostrar el gráfico
print(grafico_burbujas)
