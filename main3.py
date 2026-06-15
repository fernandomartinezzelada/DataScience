##############################################################
from random import seed
## Si necesita agregar imports, debe agregarlos aquí arriba ##
from personas import Repartidor, Cocinero, Cliente
from restaurante import Restaurante

### INICIO PARTE 4 ###

def crear_repartidores():
    return [Repartidor("R1", 20),Repartidor("R2", 20)]

def crear_cocineros():
    return [Cocinero("K1", 10),Cocinero("K2", 10),Cocinero("K3", 10),Cocinero("K4", 10),Cocinero("K5", 10)]

def crear_clientes():
    PLATOS_PRUEBA = [
        "Jugo Natural",
        "Empanadas",
        ]
    return [Cliente("C1", PLATOS_PRUEBA),Cliente("C2", PLATOS_PRUEBA),Cliente("C3", PLATOS_PRUEBA),Cliente("C4", PLATOS_PRUEBA),Cliente("C5", PLATOS_PRUEBA)]

def crear_restaurante():
    DIC_PRUEBA = {
        "Pepsi": ["Pepsi", "Bebestible"],
        "Coca-Cola": ["Coca-Cola", "Bebestible"],
        "Jugo Natural": ["Jugo Natural", "Bebestible"],
        "Agua": ["Agua", "Bebestible"],
        "Papas Duqueza": ["Papas Duqueza", "Comestible"],
        "Lomo a lo Pobre": ["Lomo a lo Pobre", "Comestible"],
        "Empanadas": ["Empanadas", "Comestible"],
        "Mariscos": ["Mariscos", "Comestible"],
        }
    cocineros = crear_cocineros()
    repartidores = crear_repartidores()
    return Restaurante("Mi Restaurante", DIC_PRUEBA, cocineros, repartidores)

### FIN PARTE 4 ###

################################################################
## No debe modificar nada de abajo en este archivo.
## Este archivo debe ser ejecutado para probar el funcionamiento
## de su programa orientado a objetos.
################################################################

INFO_PLATOS = {
    "Pepsi": ["Pepsi", "Bebestible"],
    "Coca-Cola": ["Coca-Cola", "Bebestible"],
    "Jugo Natural": ["Jugo Natural", "Bebestible"],
    "Agua": ["Agua", "Bebestible"],
    "Papas Duqueza": ["Papas Duqueza", "Comestible"],
    "Lomo a lo Pobre": ["Lomo a lo Pobre", "Comestible"],
    "Empanadas": ["Empanadas", "Comestible"],
    "Mariscos": ["Mariscos", "Comestible"],
}

NOMBRES = ["Cristian", "Antonio", "Francisca", "Juan", "Jorge", "Pablo", "Luis", "Sofia", "Macarena"]

if __name__ == "__main__":

    ### Código para probar que tu miniproyecto esté funcionando correctamente  ###
    ### Corre directamente este archivo para que este código se ejecute ###
    seed("DSP")
    restaurante = crear_restaurante() # Crea el restaurante a partir de la función crear_restaurante()
    clientes = crear_clientes() # Crea los clientes a partir de la función crear_clientes()
    if restaurante != None and clientes != None:
        restaurante.recibir_pedidos(clientes) # Corre el método recibir_pedidos(clientes) para actualizar la calificación del restaurante
        print(
            f"La calificación final del restaurante {restaurante.nombre} "
            f"es {restaurante.calificacion}"
        )
    elif restaurante == None:
        print("la funcion crear_restaurante() no esta retornando la instancia del restaurante")
    elif clientes == None:
        print("la funcion crear_clientes() no esta retornando la instancia de los clientes")
