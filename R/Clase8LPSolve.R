# Cargar la librería lpSolve
library(lpSolve)

# Parámetros del problema
Tend <- c(100, 101, 102, 103, 104, 105, 106)
DH <- c(7, 7, 7, 7, 5, 7, 6)
Inv <- c(0, 0, 0, 0, 0, 0, 0)
Pri <- c(1, 1, 0, 0, 0, 0, 0)
Ver <- c(0, 0, 1, 1, 1, 1, 1)

# Coeficientes de la demanda (pendiente y demás)
precios <- c(69990, 59990, 49990)

# Número de semanas
n <- 7

# Definir las variables para el modelo
# Matriz de coeficientes para los precios binarios (a, b, c)
f.obj <- rep(0, n * 3)  # El objetivo será la suma de ingresos por día (es de numero de semanas x dia)

# Definir restricciones para los precios (solo se puede elegir un precio por día)
f.con <- matrix(0, nrow = n + 1, ncol = n * 3)
for (i in 1:n) {
  f.con[i, ((i-1) * 3 + 1):((i-1) * 3 + 3)] <- 1  # Solo un precio permitido por día
}
# Restricción de máximo 3 descuentos (bajas de precio)
f.con[n + 1, ] <- rep(c(0, 1, 1), n)  # Solo puede haber hasta 3 descuentos

# Definir los lados derechos de las restricciones
f.rhs <- c(rep(1, n), 3)  # 1 precio por día, y máximo 3 descuentos
f.dir <- c(rep("=", n), "<=")

# Función de demanda
demanda <- function(precio, Tend, DH, Inv, Pri, Ver) {
  1406 - 0.023 * precio - 1.443 * Tend + 70.9 * DH + 517 * Inv - 14.75 * Pri - 163 * Ver
}

# Calcular la demanda estimada para cada combinación de precio por semana
demandas <- sapply(1:n, function(i) {
  sapply(precios, function(p) demanda(p, Tend[i], DH[i], Inv[i], Pri[i], Ver[i]))
})

# Calcular los ingresos para cada combinación
for (i in 1:n) {
  for (j in 1:3) {
    f.obj[(i-1) * 3 + j] <- demandas[j, i] * precios[j]
  }
}

# Resolver el problema
sol <- lp("max", f.obj, f.con, f.dir, f.rhs, binary.vec = 1:(n * 3))

# Mostrar la solución
precio_optimo <- matrix(sol$solution, nrow = n, byrow = TRUE) %*% precios
precio_optimo  # Precios por semana

# Ingresos máximos
ingresos_maximos <- sum(precio_optimo * apply(demandas, 2, max))
ingresos_maximos

precio_comercial <- c(69990, 69990, 69990, 49990, 49990, 49990, 69990)

# Ingresos máximos
ingresos_maximos <- sum(precio_comercial * apply(demandas, 2, max))
ingresos_maximos
