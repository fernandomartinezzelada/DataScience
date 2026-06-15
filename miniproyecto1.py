import random   #Libreria para generar un numero randomico

numero = random.randint(1,100)  #numero aletario entre 1 y 100

usr_name = input("Favor ingrese su nombre: ")   #Nombre usuario

print("\nPrograma para adivinar un número\n")

nintentos = 0   #Numero de intentos

while True: #Ciclo infinito
    str_usr = input("Ingrese un numero natural entre 0 y 100, '0' para terminar: ")
    if str_usr == "0":  # Termina si el texto ingresado por el usuario es '0'
        s = "\nNo lo lograste a pesar de tratar {} veces. Mas suerte para otra vez".format(nintentos)
        print(s)
        break
    nintentos = nintentos + 1  # Nuevo intento del usuario
    nusr = int(str_usr) #Numero del usuario
    diferencia = abs(nusr - numero) #Distancia entre los numeros
    if diferencia > 20: #diferencia: (20,inf+)
        s = "Sorry {}, ese no es pero estas a una distancia mayor que 20".format(usr_name)
    elif diferencia == 20: #diferencia: [20,20]
        s = "Sorry {}, ese no es pero estas a una distancia igual a 20".format(usr_name)
    elif diferencia > 10: #diferencia: (10,20)
        s = "Sorry {}, ese no es pero estas a una distancia mayor que 10 y menor que 20".format(usr_name)
    elif diferencia == 10: #diferencia: [10,10]
        s = "Sorry {}, ese no es pero estas a una distancia igual a 10".format(usr_name)
    elif diferencia > 5: #diferencia: (5,10)
        s = "Sorry {}, ese no es pero estas a una distancia mayor que 5 y menor que 10".format(usr_name)
    elif diferencia == 5: #diferencia: [5,5]
        s = "Sorry {}, ese no es pero estas a una distancia igual a 5".format(usr_name)
    elif diferencia > 0: #diferencia: (0,5)
        s = "Sorry {}, ese no es pero estas a una distancia menor a 5".format(usr_name)
    else: #numero encontrado
        s = "Felicitaciones {}, lo lograste en {} intentos".format(usr_name,nintentos)

    print(s)    #Emite el mensaje al usuario
    if diferencia==0:
        break   #Termina si se encontro el numero
