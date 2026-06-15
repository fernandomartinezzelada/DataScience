nmaxpresupuesto = 100000  # Maximo presupuesto

s1 = input("Ingrese nombre tienda 1: ").strip()
s2 = input("Ingrese nombre tienda 2: ").strip()

snomtienda_lst = []
snomtienda_lst.append(s1[0:3].upper())  #Nombre tienda 1
snomtienda_lst.append(s2[0:3].upper())  #Nombre tienda 2

if snomtienda_lst[0] == snomtienda_lst[1]:
    snomtienda_lst[1] = snomtienda_lst[1] + "2"

# Se inicializan montos acumulados en cero:
n_acumulado_tienda_lst = []
n_acumulado_tienda_lst.append(0)
n_acumulado_tienda_lst.append(0)

print(snomtienda_lst[0] + ": $" + str(n_acumulado_tienda_lst[0]))
print(snomtienda_lst[1] + ": $" + str(n_acumulado_tienda_lst[1]))

nronda = 1  # Num. de ronda
while n_acumulado_tienda_lst[0] <= nmaxpresupuesto and n_acumulado_tienda_lst[1] <= nmaxpresupuesto:  #1 ciclo por ronda
    print("\nRonda {}:".format(nronda))
    
    for ntienda in range(0,2):  #Ejecute para ambas tiendas:
        print("\nIngrese instrucciones tienda {}:".format(ntienda+1))
        
        ninstr=1 #contador de numero de instruccion
        while ninstr <= 3:  #instrucciones tienda Num. tienda:
            s_instr = input().upper().strip()  #instruccion del usuario
            s_instr_lst = s_instr.split(" ")
            n = len(s_instr_lst)  # Num. palabras
            if n != 2:
                print("ERROR: Número de argumentos inválido")
                continue  #solicita reingreso de la instruccion
            #Procesamiento de la instrucción:
            spalabra1 = s_instr_lst[0]  #palabra1
            spalabra2 = s_instr_lst[1]  #palabra2
            if spalabra1=="DESCUENTO":
                if spalabra2.isnumeric():
                    nvalor = int(spalabra2)  #valor a restar
                    n_acumulado_tienda_lst[ntienda] -= nvalor
                else: #argunmento invalido
                    print("ERROR: Argumento inválido (descuento <valor-numerico>)")
                    continue  #solicita reingreso de la instruccion
            elif spalabra1=="DESPACHO":
                if spalabra2=="CERCA":
                    nvalor=1000
                elif spalabra2=="NORMAL":
                    nvalor=5000
                elif spalabra2=="LEJOS":
                    nvalor=10000
                else: #argunmento invalido
                    print("ERROR: Argumento inválido (despacho <cerca|normal|lejos>)")
                    continue  #solicita reingreso de la instruccion
                n_acumulado_tienda_lst[ntienda] += nvalor  #Le suma el valor
            elif spalabra1.isnumeric() and spalabra2.isnumeric(): #nX nZ
                nx = int(spalabra1)  #cantidad
                nz = int(spalabra2)  #valor unitario
                if nx >= 10:  #compra mayorista
                    nx -= 1  #1 producto es gratis
                n_acumulado_tienda_lst[ntienda] += (nx * nz)  #Le suma Cantidad X Valor
            else: #no es descuento ni despacho ni cantidad X valor
                print("ERROR: Argumento(s) inválido(s)")
                continue  #solicita reingreso de la instruccion
            ninstr += 1  #Avanza a la instruccion siguiente
        
        if n_acumulado_tienda_lst[ntienda] < 0:
            n_acumulado_tienda_lst[ntienda] = 0
    
    print("\n")
    print(snomtienda_lst[0] + ": $" + str(n_acumulado_tienda_lst[0]))
    print(snomtienda_lst[1] + ": $" + str(n_acumulado_tienda_lst[1]))
    
    nronda += 1  #Siguiente ronda

# Se determina cual es mejor
if n_acumulado_tienda_lst[0] < n_acumulado_tienda_lst[1]:  #Tienda1 es mejor
    s = "{} es mejor.".format(s1)  #Tienda1
if n_acumulado_tienda_lst[1] < n_acumulado_tienda_lst[0]:  #Tienda2 es mejor
    s = "{} es mejor.".format(s2)  #Tienda2
else:  #Empate
    s = "EMPATE."

print("\n" + s)  #Se emite mensaje final al usuario
