#DEFINICIONES:
separador_csv="," #Separador de CSV

#DICCIONARIOS:
dic_disponibilidad = {} #Diccionario vacio
dic_pacientes = {} #Diccionario vacio

#FUNCIONES:
#Elimina espacios de lista:
def fun_striplinea(lst):
    n=len(lst)
    i=0
    while i<n: #para todos los elementos de la lista:
        lst[i] = str(lst[i]).strip() #elimine caracteres extraños
        i+=1

#Lectura del archivo de disponibilidad:
def fun_llenadicdisponibilidad(sruta_archivo, diccionario):
    nombrearch=sruta_archivo
    arch = open(nombrearch,'r',encoding="UTF-8")
    arch_en_lineas = arch.readlines()
    arch.close()

    num_lineas=len(arch_en_lineas) #numero lineas del archivo

    num_linea=0
    while num_linea < num_lineas:
        slinea = arch_en_lineas[num_linea].strip().upper() #linea del archivo
        linea_lst = slinea.split(" ") #Lista nombre examen-disponibilidad
        n = len(linea_lst) #numero de elementos lista
        if n<2:
            continue #solo se permiten 2 elementos por lista
        sllave = linea_lst[0]
        scontenido = linea_lst[1]
        ncontenido = 0
        if scontenido.isnumeric():
            ncontenido=int(scontenido)
        diccionario[sllave] = ncontenido
        num_linea+=1

#Lectura del archivo de pacientes:
def fun_llenadicpacientes(sruta_archivo, diccionario):
    nombrearch=sruta_archivo
    arch = open(nombrearch,'r',encoding="UTF-8")
    arch_en_lineas = arch.readlines()
    arch.close()

    num_lineas=len(arch_en_lineas) #numero lineas del archivo

    num_linea=0
    while num_linea < num_lineas:
        slinea = arch_en_lineas[num_linea].strip().upper() #linea del archivo
        linea_lst = slinea.split(separador_csv) #linea del archivo como lista
        fun_striplinea(linea_lst) #elimina caracteres extraños
        n = len(linea_lst) #numero de elementos lista
        if n<2:
            continue #deben ser al menos 2 elementos por lista
        sllave = linea_lst.pop(0) #Llave y linea sin llave
        diccionario[sllave] = linea_lst #agregamos llave y linea al diccionario
        num_linea+=1 #siguiente linea del archivo

#imprime diccionario de disponibilidad:
def fun_printdisponibilidad(diccionario):
    for (sllave, ncontenido) in diccionario.items():
        print(sllave + ": " + str(ncontenido))

#imprime diccionario de pacientes:
def fun_printpacientes(diccionario):
    for (sllave, lcontenido) in diccionario.items():
        print(sllave + ": " + str(lcontenido))

#retorna lista de examenes para paciente:
def fun_lstexamenes(snompaciente, diccionario):
    for (sllave, lcontenido) in diccionario.items():
        if sllave==snompaciente:
            return lcontenido
    return [] #Lista vacia si no encontró al paciente

#retorna la disponibilidad de un examen:
def bfun_disponibilidad(snomexamen,diccionario):
    snomexamen = snomexamen.upper().strip()
    for (sllave, ncontenido) in diccionario.items():
        if sllave==snomexamen and ncontenido > 0:
            return True
    return False

#aumenta la disponibilidad de un examen:
def fun_setdisponibilidad(snomexamen,diccionario):
    snomexamen = snomexamen.upper().strip()
    if snomexamen in diccionario:
        diccionario[snomexamen]+=1 #Aumenta en 1 disponibilidad del examen
    else:
        diccionario[snomexamen]=1 #Se agrega el examen al diccionario

#disminuye la disponibilidad de un examen:
def fun_unsetdisponibilidad(snomexamen,diccionario):
    snomexamen = snomexamen.upper().strip()
    if diccionario[snomexamen] > 0:
        diccionario[snomexamen]-=1 #Descuenta en 1 disponibilidad del examen

#retorna disponibilidad de una lista de examenes:
def bfun_disponibilidad_lst(lnomexamenes,diccionario):
    n=len(lnomexamenes)
    i=0 #contador de elementos de la lista
    while i<n: #para cada elemento de la lista
        if not bfun_disponibilidad(lnomexamenes[i],diccionario):
            return False
        i+=1 #siguiente elemento de la lista
    return True

#retorna lista de exámenes no disponibles de una lista de exámenes:
def lfun_nodisponibilidad_lst(lnomexamenes,diccionario):
    n=len(lnomexamenes)
    i=0 #contador de elementos de la lista
    lst=[] #lista vacia
    while i<n: #para cada elemento de la lista
        if not bfun_disponibilidad(lnomexamenes[i],diccionario):
            lst.append(lnomexamenes[i])
        i+=1 #siguiente elemento de la lista
    return lst

#aumenta disponibilidad de una lista de exámenes:
def fun_setdisponibilidad_lst(lnomexamenes,diccionario):
    n=len(lnomexamenes)
    i=0 #contador de elementos de la lista
    while i<n: #para cada elemento de la lista
        fun_setdisponibilidad(lnomexamenes[i],diccionario)
        i+=1 #siguiente elemento de la lista

#disminuye disponibilidad de una lista de exámenes:
def fun_unsetdisponibilidad_lst(lnomexamenes,diccionario):
    n=len(lnomexamenes)
    i=0 #contador de elementos de la lista
    while i<n: #para cada elemento de la lista
        fun_unsetdisponibilidad(lnomexamenes[i],diccionario)
        i+=1 #siguiente elemento de la lista

#PROGRAMA EN PYTHON:
fun_llenadicdisponibilidad("./disponibilidad.txt", dic_disponibilidad)
fun_llenadicpacientes("./pacientes.csv", dic_pacientes)
#fun_printpacientes(dic_pacientes) #imprime listas de exámenes de pacientes (opcional)

while True: #Ciclo infinito
    fun_printdisponibilidad(dic_disponibilidad) #imprime disponibilidad
    s_instr = input("Bienvenido, ingrese la instrucción a continuación: ").upper().strip() #instruccion del usuario (MAYUSC)
    if s_instr=="STOP":
        break #termina el programa
    s_instr_lst = s_instr.split(" ")
    n = len(s_instr_lst)  # Num. palabras
    if n < 2: #Se requieren al menos 2 palabras
        print("ERROR: Número de argumentos inválido (se esperaban al menos 2 palabras)")
        continue #solicita reingreso de la instruccion
    #Procesamiento de la instrucción:
    spalabra1 = s_instr_lst[0]  #palabra1
    if spalabra1=="ATENDER": #atender paciente_x
        if n != 2:
            print("ERROR: Argumentos inválidos (se esperaba: atender <paciente_x>)")
            continue #solicita reingreso de la instruccion
        spalabra2 = s_instr_lst[1] #palabra2(paciente_x)
        spaciente = spalabra2.strip() #se quitan caracteres extraños
        lst_examenes = fun_lstexamenes(spaciente,dic_pacientes)
        if len(lst_examenes)==0:
            print("Paciente {} no encontrado".format(spaciente))
            continue #solicita reingreso de la instruccion
        if bfun_disponibilidad_lst(lst_examenes,dic_disponibilidad): #Exámenes disponibles?
            #Si, paciente atendible:
            fun_unsetdisponibilidad_lst(lst_examenes,dic_disponibilidad) #Se reduce disponibilidad
            print("Se ha atendido con éxito a {}!".format(spaciente))
        else:
            #No, paciente no atendible:
            lst_exnodisp=lfun_nodisponibilidad_lst(lst_examenes,dic_disponibilidad) #exámenes no disponibles
            if len(lst_exnodisp)==1:
                s="No es posible atender a {} porque no existen horas disponibles para el exámen {}."
                s=s.format(spaciente,lst_exnodisp[0])
            else:
                s="No es posible atender a {} porque no existen horas disponibles para los exámenes {}."
                s=s.format(spaciente,lst_exnodisp)
            print(s) #emite mensaje al usuario
    elif spalabra1=="AGREGAR": #agregar exámenes
        if n < 2:
            print("ERROR: Argumentos inválidos (se esperaba: agregar <lista_de_exámenes>)")
            continue #solicita reingreso de la instruccion
        sinstr1 = s_instr_lst.pop(0) #elimina primera palabra de la lista de instruccion del usuario
        lst_examenes = s_instr_lst #listado de exámenes a agregar al diccionario de disponibilidad
        fun_striplinea(lst_examenes) #elimina caracteres extraños
        fun_setdisponibilidad_lst(lst_examenes,dic_disponibilidad) #agrega al diccionario de disponibilidad
    else:
        print("ERROR: No se reconoce la instrucción")
        continue #solicita reingreso de la instruccion
