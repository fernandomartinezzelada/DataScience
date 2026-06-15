porcentaje_Nota <- function(nota) {
  if(nota>=4) {
    puntosNota <- nota - 4                   # Ej: nota==7, puntosNota <- 7 - 4 == 3
                                             # Ej: nota==4, puntosNota <- 4 - 4 == 0
    puntaje <- puntosNota / 3                # puntaje <- 3 / 3 == 1
                                             # puntaje <- 0 / 3 == 0
    porcentajeRelat <- puntaje * 40          # porcentajeRelat <- 1 * 40 == 40
                                             # porcentajeRelat <-  0 * 40 == 0
    porcentajeTotal <- porcentajeRelat + 60  # porcentajeTotal <- 40 + 60 == 100
                                             # porcentajeTotal <-  0 + 60 == 60
  } else {
    puntosNota <- nota - 1                   # Ej: nota==4, puntosNota <- 4 - 1 == 3
                                             # Ej: nota==1, puntosNota <- 1 - 1 == 0
    puntaje <- puntosNota / 3                # puntaje <- 3 / 3 == 1
                                             # puntaje <- 0 / 3 == 0
    porcentajeRelat <- puntaje * 60          # porcentajeRelat <- 1 * 60 == 60
                                             # porcentajeRelat <- 0 * 60 == 0
    porcentajeTotal <- porcentajeRelat       # porcentajeTotal <- 60
                                             # porcentajeTotal <- 0
  }
  return(porcentajeTotal)
}

Nota_Puntos <- function(PuntosObtenidos, PuntosTotales) {
  Puntaje <- PuntosObtenidos / PuntosTotales
  if (Puntaje>=.6){
    PuntajeSobreAprobacion <- (Puntaje - .6) / .4
    Nota <- (PuntajeSobreAprobacion * 3) + 4
  } else {
    PuntajeBajoAprobacion <- Puntaje / .6
    Nota <- (PuntajeBajoAprobacion * 3) + 1
  }
  return(Nota)
}
