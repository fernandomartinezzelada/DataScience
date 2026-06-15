import parametros as p
import random


# NO MODIFICAR
class Rueda:
    def __init__(self):
        self.resistencia_actual = random.randint(*p.RESISTENCIA)
        self.resistencia_total = self.resistencia_actual
        self.estado = "Perfecto"

    def gastar(self, accion, tipo):
        if accion == "acelerar":
            if tipo == "automovil":
                self.resistencia_actual -= 5
            elif tipo == "moto":
                self.resistencia_actual -= 3
        elif accion == "frenar":
            if tipo == "automovil":
                self.resistencia_actual -= 10
            elif tipo == "moto":
                self.resistencia_actual -= 7
        self.actualizar_estado()

    def actualizar_estado(self):
        if self.resistencia_actual < 0:
            self.estado = "Rota"
        elif self.resistencia_actual < self.resistencia_total / 2:
            self.estado = "Gastada"
        elif self.resistencia_actual < self.resistencia_total:
            self.estado = "Usada"


# NO MODIFICAR
def seleccionar(vehiculos):
    if not len(vehiculos):
        print("No hay vehículos instanciados todavía")
        return

    print("Los vehículos disponibles son:")
    for indice in range(len(vehiculos)):
        print(f"[{indice}] {str(vehiculos[indice])}")

    elegido = int(input())
    while elegido < 0 or elegido >= len(vehiculos):
        print("intentelo de nuevo.")
        elegido = int(input())

    vehiculo = vehiculos[elegido]
    print("Se seleccionó el vehículo", str(vehiculo))
    return vehiculo


# Parte 1: Definición de clases

def avanzar(velocidad, tiempo):
    # Completar
    #velocidad en m/s
    #tiempo en s
    return (float(velocidad)*float(tiempo))/1000 #en km
    #pass


class Automovil:
    # Completar
    def __init__(self, kilometraje, ano):
        self.kilometraje=float(kilometraje) #en km
        self.ano=int(ano)
        self.ruedas=[Rueda(),Rueda(),Rueda(),Rueda()]
        self.aceleracion=float(0) #en km/h2
        self.velocidad=float(0) #en km/h
    def avanzar(self, tiempo):
        #tiempo en s
        self.kilometraje += avanzar(float(self.velocidad/3.6), tiempo)
    def acelerar(self, tiempo):
        #tiempo en s
        tiempo_en_horas=tiempo/3600
        self.aceleracion += tiempo_en_horas*0.5
        self.velocidad += self.aceleracion * tiempo_en_horas
        self.avanzar(tiempo)
        self.ruedas[0].gastar("acelerar", "automovil")
        self.ruedas[1].gastar("acelerar", "automovil")
        self.ruedas[2].gastar("acelerar", "automovil")
        self.ruedas[3].gastar("acelerar", "automovil")
        self.aceleracion=float(0)
    def frenar(self, tiempo):
        #tiempo en s
        tiempo_en_horas=tiempo/3600
        self.aceleracion -= tiempo_en_horas*0.5
        self.velocidad += self.aceleracion * tiempo_en_horas
        if self.velocidad<0:
            self.velocidad=0
        self.avanzar(tiempo)
        self.ruedas[0].gastar("frenar", "automovil")
        self.ruedas[1].gastar("frenar", "automovil")
        self.ruedas[2].gastar("frenar", "automovil")
        self.ruedas[3].gastar("frenar", "automovil")
        self.aceleracion=float(0)
    def obtener_kilometraje(self):
        return self.kilometraje
    def reemplazar_rueda(self):
        n=len(self.ruedas) #numero de ruedas
        i=n-1 #empezamos por la rueda mayor
        while i>=0:
            if self.ruedas[i].resistencia_actual < self.ruedas[i].resistencia_total * 0.5: #Error: Debe ser la rueda con la menor resistencia!
                self.ruedas.pop(i) #Se elimina la rueda i
                self.ruedas.append(Rueda()) #Se agrega 1a rueda al final
            i-=1 #Se sigue a la rueda anterior
    #pass
    def __str__(self):
        return f"Automóvil del año {self.ano}."


class Moto:
    # Completar
    def __init__(self, kilometraje, ano, cilindrada):
        self.kilometraje=float(kilometraje) #en km
        self.ano=int(ano)
        self.cilindrada=int(cilindrada)
        self.ruedas=[Rueda(),Rueda()]
        self.aceleracion=float(0) #en km/h2
        self.velocidad=float(0) #en km/h
    def avanzar(self, tiempo):
        #tiempo en s
        self.kilometraje += avanzar(float(self.velocidad/3.6), tiempo)
    def acelerar(self, tiempo):
        #tiempo en s
        tiempo_en_horas=tiempo/3600
        self.aceleracion += (tiempo_en_horas*0.8) + (self.cilindrada*0.2)
        self.velocidad += self.aceleracion * tiempo_en_horas*3
        self.avanzar(tiempo)
        self.ruedas[0].gastar("acelerar", "moto")
        self.ruedas[1].gastar("acelerar", "moto")
        self.aceleracion=float(0)
    def frenar(self, tiempo):
        #tiempo en s
        tiempo_en_horas=tiempo/3600
        self.aceleracion -= (tiempo_en_horas*0.8) + (self.cilindrada*0.2)
        self.velocidad += self.aceleracion * tiempo_en_horas*2
        if self.velocidad<0:
            self.velocidad=0
        self.avanzar(tiempo)
        self.ruedas[0].gastar("frenar", "moto")
        self.ruedas[1].gastar("frenar", "moto")
        self.aceleracion=float(0)
    def obtener_kilometraje(self):
        return self.kilometraje
    def reemplazar_rueda(self):
        n=len(self.ruedas) #numero de ruedas
        i=n-1 #empezamos por la rueda mayor
        while i>=0:
            if self.ruedas[i].resistencia_actual < self.ruedas[i].resistencia_total * 0.5:
                self.ruedas.pop(i) #Se elimina la rueda i
                self.ruedas.append(Rueda()) #Se agrega 1a rueda al final
            i-=1 #Se sigue a la rueda anterior
    #pass

    def __str__(self):
        return f"Moto del año {self.ano}."


# Parte 2: Completar acciones

def accion(vehiculo, opcion):
    # Completar
    if opcion == 2:  # Acelerar
        s = input("Ingrese tiempo en segundos para acelerar: ")
        nsegundos=float(s)
        vehiculo.acelerar(nsegundos)
        print("Se ha acelerado por {} segundos, llegando a una velocidad de {} km/h".format(nsegundos, vehiculo.velocidad))
        #pass
    elif opcion == 3:  # Frenar
        s = input("Ingrese tiempo en segundos para frenar: ")
        nsegundos=float(s)
        vehiculo.frenar(nsegundos)
        print("Se ha frenado por {} segundos, llegando a una velocidad de {} km/h".format(nsegundos, vehiculo.velocidad))
        #pass
    elif opcion == 4:  # Avanzar
        s = input("Ingrese tiempo en segundos para avanzar: ")
        nsegundos=float(s)
        vehiculo.avanzar(nsegundos)
        print("Se ha avanzado por {} segundos a una velocidad de {} km/h".format(nsegundos, vehiculo.velocidad))
        #pass
    elif opcion == 5:  # Cambiar rueda
        vehiculo.reemplazar_rueda()
        print("Se han reemplazado las ruedas con éxito")
        #pass
    elif opcion == 6:  # Mostrar Estado
        print("Año: {}".format(vehiculo.ano))
        print("Velocidad: {} km/h".format(vehiculo.velocidad))
        print("Kilometraje: {} km".format(vehiculo.obtener_kilometraje()))
        print("Estado de las ruedas:")
        i=0 #empezamos por la 1era. rueda
        n=len(vehiculo.ruedas) #numero de ruedas
        while i<n:
            print("{}".format(vehiculo.ruedas[i].estado))
            i+=1 #siguiente rueda
        #pass


def main():
    vehiculos = []

    # Parte 3: Completar código principal
    # Completar
    # Aquí debes instanciar los dos objetos pedidos
    a1=Automovil(100,2024) #1 automovil de 100 km del agnio 2024
    m1=Moto(100,2024,200)  #1 moto de 100 km del agnio 2024, cilindrada de 200
    # y agregarlos a la lista de vehículos
    vehiculos.append(a1) # se agrega el automovil a la lista de vehículos
    vehiculos.append(m1) # se agrega la moto a la lista de vehículos

    # NO MODIFICAR
    vehiculo = None

    dict_opciones = {
        1: ("Seleccionar Vehiculo", seleccionar),
        2: ("Acelerar", accion),
        3: ("Frenar", accion),
        4: ("Avanzar", accion),
        5: ("Reemplazar Rueda", accion),
        6: ("Mostrar Estado", accion),
        0: ("Salir", None)
    }

    opcion = -1
    while opcion != 0:

        for llave, valor in dict_opciones.items():
            print(f"{llave}: {valor[0]}")

        try:
            opcion = int(input("Opción: "))
            print()

        except ValueError:
            print("Ingrese opción válida.")
            opcion = -1

        if opcion != 0 and opcion in dict_opciones.keys():
            if opcion == 1:
                vehiculo = dict_opciones[opcion][1](vehiculos)
            else:
                if vehiculo is None and vehiculos:
                    vehiculo = vehiculos[0]
                if vehiculo is None:
                    print("Aún no hay vehículos...")
                else:
                    dict_opciones[opcion][1](vehiculo, opcion)
        elif opcion == 0:
            pass
        else:
            print("Ingrese opción válida.")
            opcion = -1

        print()


if __name__ == "__main__":
    main()
