# Parte 1: Cargar los datos

#Funcion que retorna lista de peliculas para un genero dado
def lfun_listapeliculasgen(sgn,lst_pelxgen):
    i=0
    n=len(lst_pelxgen)
    while i<n:
        if lst_pelxgen[i][0]==sgn:   #Tupla encontrada:
            return lst_pelxgen[i][1] #Retorna la lista asociada
        i+=1
    return [] #Retorna vacio si no encuentra nada

#Funcion que asigna una lista de peliculas a un genero dado
def lfun_asignapeliculasgen(sgn,lpel,lst_pelxgen):
    i=0
    n=len(lst_pelxgen)
    while i<n:
        if lst_pelxgen[i][0]==sgn: #Tupla encontrada:
            lst_pelxgen.pop(i)     #Se elimina la tupla indicada
            t=(sgn,lpel)           #Generamos la tupla a asignar
            lst_pelxgen.append(t)  #Se agrega la tupla al final
            return lst_pelxgen     #Retornamos la lista actualizada
        i+=1
    #No se encontro la tupla:
    t=(sgn,lpel)           #Generamos la tupla a asignar
    lst_pelxgen.append(t)  #Se agrega la tupla al final
    return lst_pelxgen     #Retornamos la lista actualizada

def cargar_datos(lineas_archivo):
    # Completar:
    lst_generos_peliculas = [] #Lista de generos de peliculas
    
    for slinea in lineas_archivo: #Por cada linea del archivo:
        sgeneros = slinea.split(",")[4:][0] #Se obtienen los generos desde la columna 4
        lst_generos = sgeneros.split(";") #Se obtienen los generos como lista
        for sgen in lst_generos: #Por cada genero en la lista de generos:
            if not sgen in lst_generos_peliculas: #Si no está en la lista de generos de peliculas:
                lst_generos_peliculas.append(sgen) #Le agregamos el genero a la lista de generos de peliculas
    
    lst_peliculas_por_genero = [] #Lista de generos con sus peliculas asociadas
    
    for slinea in lineas_archivo: #Por cada linea del archivo:
        spelicula = slinea.split(",")[0] #La primera columna es el nombre de la pelicula
        sgeneros = slinea.split(",")[4:][0] #Se obtienen los generos desde la columna 4
        lst_generos = sgeneros.split(";") #Se obtienen los generos como lista
        for sgen in lst_generos: #Por cada genero en la lista de generos:
            l_peliculas=lfun_listapeliculasgen(sgen,lst_peliculas_por_genero) #lista de peliculas para el genero
            if not spelicula in l_peliculas:  #Pelicula no esta en la lista retornada
                l_peliculas.append(spelicula) #Agregamos la pelicula al final de la lista
                l=lfun_asignapeliculasgen(sgen,l_peliculas,lst_peliculas_por_genero) #asigna la lista de peliculas al genero
    
    lst_info_peliculas = [] #Lista de informacion de las peliculas
    
    for slinea in lineas_archivo: #Por cada linea del archivo:
        l_linea=slinea.split(",") #Linea del archivo como lista
        spelicula = l_linea[0] #La columna 0 es el nombre de la pelicula
        spopularidad = l_linea[1] #La columna 1 es la popularidad de la pelicula
        svotopromedio = l_linea[2] #La columna 2 es el voto promnedio de la pelicula
        scantidadvotos = l_linea[3] #La columna 3 es la cantidad de votos de la pelicula
        sgeneros = l_linea[4:][0] #Se obtienen los generos desde la columna 4
        lst_generos = sgeneros.split(";") #Se obtienen los generos como lista
        tpl=(spelicula,spopularidad,svotopromedio,scantidadvotos,lst_generos) #Generamos la tupla a asignar
        lst_info_peliculas.append(tpl)  #Se agrega la tupla al final
    
    return lst_generos_peliculas, lst_peliculas_por_genero, lst_info_peliculas
    #pass


# Parte 2: Completar las consultas

#Funcion que retorna el valor minimo de una lista de datos numericos
def nfun_minlist(lst_ndt):
    l=lst_ndt
    l.sort()

    if len(l)!=0:
        return l[0] #el mas bajo es el primer elemento
    else:
        return 0

#Funcion que retorna el valor maximo de una lista de datos numericos
def nfun_maxlist(lst_ndt):
    l=lst_ndt
    l.sort(reverse=True)

    if len(l)!=0:
        return l[0] #el mas alto es el primer elemento
    else:
        return 0

#Funcion que retorna el valor promedio de una lista de datos numericos
def nfun_avglist(lst_ndt):
    n=len(lst_ndt)
    i=0
    nsum=0 #acumulador de sumas
    while i<n:
        nsum += lst_ndt[i]
        i+=1

    if n!=0:
        return float(nsum/n) #promedio
    else:
        return 0

def obtener_puntaje_y_votos(nombre_pelicula):
    # Cargar las lineas con la data del archivo
    lineas_archivo = leer_archivo()
    #se copia texto proporcionado...
    datos_cargados = True
    generos_peliculas, peliculas_por_genero, info_peliculas = cargar_datos(lineas_archivo)
    # Completar con lo que falta aquí
    if datos_cargados:
        #Generamos la tupla a retornar:
        spelicula          = nombre_pelicula #string nombre de pelicula
        lst_info_peliculas = info_peliculas  #lista de informacion de peliculas
        
        i=0                       #contador de iteraciones
        n=len(lst_info_peliculas) #largo de la lista
        while i<n:                #ejecute para todos los items de la lista:
            if lst_info_peliculas[i][0]==spelicula: #Pelicula encontrada:
                st1=lst_info_peliculas[i][2]        #svotopromedio (float)
                st2=lst_info_peliculas[i][3]        #scantidadvotos (int)
                return st1,st2                      #Tupla a retornar
            i+=1                  #siguiente item
        #No se encontro la pelicula:
        return '-1.0','-1'        #Tupla a retornar
    else: #datos no cargados:
        return '0.0','0'          #Tupla a retornar
    #pass


def filtrar_y_ordenar(genero_pelicula):
    # Cargar las lineas con la data del archivo
    lineas_archivo = leer_archivo()
    #se copia texto proporcionado...
    datos_cargados = True
    generos_peliculas, peliculas_por_genero, info_peliculas = cargar_datos(lineas_archivo)
    # Completar con lo que falta aquí
    if datos_cargados:
        #Generamos la lista a retornar:
        sgen               = genero_pelicula #string genero pelicula
        lst_info_peliculas = info_peliculas  #lista de informacion de peliculas
        l_peliculas        = []              #Lista de peliculas a retornar

        i=0                       #contador de iteraciones
        n=len(lst_info_peliculas) #largo de la lista
        while i<n:                #ejecute para todos los items de la lista:
            spelicula   = lst_info_peliculas[i][0] #La primera columna es el nombre de la pelicula
            lst_generos = lst_info_peliculas[i][4] #Se obtienen los generos como lista desde la columna 4
            if sgen in lst_generos:                #Si el genero está en la lista de generos:
                l_peliculas.append(spelicula)      #Se agrega el nombre de la pelicula al final de la lista
            i+=1                                   #siguiente item
        
        l_peliculas.sort(reverse=True) #Ordenamos la lista en orden alfabetico inverso
        return l_peliculas             #Retornamos la lista generada
    else: #datos no cargados:
        return []                      #Lista a retornar
    #pass


def obtener_estadisticas(genero_pelicula, criterio):
    # Cargar las lineas con la data del archivo
    lineas_archivo = leer_archivo()
    #se copia texto proporcionado...
    datos_cargados = True
    generos_peliculas, peliculas_por_genero, info_peliculas = cargar_datos(lineas_archivo)
    # Completar con lo que falta aquí
    if datos_cargados:
        #Generamos la lista a analizar:
        sgen               = genero_pelicula #string genero pelicula
        lst_info_peliculas = info_peliculas  #lista de informacion de peliculas
        l_infopeliculas    = []              #Lista de peliculas a analizar

        i=0                       #contador de iteraciones
        n=len(lst_info_peliculas) #largo de la lista
        while i<n:                #ejecute para todos los items de la lista:
            spopularidad   = lst_info_peliculas[i][1]        #La columna 1 es la popularidad: spopularidad (float)
            svotopromedio  = lst_info_peliculas[i][2]        #La columna 2 es el voto promnedio: svotopromedio (float)
            scantidadvotos = lst_info_peliculas[i][3]        #La columna 3 es la cantidad de votos: scantidadvotos (int)
            lst_generos    = lst_info_peliculas[i][4]        #Se obtienen los generos como lista desde la columna 4
            if sgen in lst_generos:        #Si el genero está en la lista de generos:
                tpl = (spopularidad,svotopromedio,scantidadvotos) #Se genera la tupla con los datos obtenidos
                l_infopeliculas.append(tpl)                       #Se agrega la tupla al final de la lista
            i+=1                           #siguiente item

        #Analizando critero:
        if criterio=="popularidad":
            ncrit=0     #spopularidad (float)
        elif criterio=="voto promedio":
            ncrit=1     #svotopromedio (float)
        elif criterio=="cantidad votos":
            ncrit=2     #scantidadvotos (int)
        else:
            ncrit=3     #criterio invalido

        lst_ndatos = [] #lista de datos numericos
        if ncrit<3:
            i=0                    #contador de iteraciones
            n=len(l_infopeliculas) #largo de la lista
            while i<n:             #ejecute para todos los items de la lista:
                num = float(l_infopeliculas[i][ncrit]) #numero a considerar
                lst_ndatos.append(num) #Se agrega a la lista de datos
                i+=1               #siguiente item
        
        nmax = nfun_maxlist(lst_ndatos) #valor maximo
        nmin = nfun_minlist(lst_ndatos) #valor minimo
        navg = nfun_avglist(lst_ndatos) #promedio
        
        return [nmax,nmin,navg]        #Lista a retornar
    else: #datos no cargados:
        return [0.0 ,0.0, 0.0]         #Lista a retornar
    #pass


# NO ES NECESARIO MODIFICAR DESDE AQUI HACIA ABAJO

def solicitar_accion():
    print("\n¿Qué desea hacer?\n")
    print("[0] Revisar estructuras de datos")
    print("[1] Obtener puntaje y votos de una película")
    print("[2] Filtrar y ordenar películas")
    print("[3] Obtener estadísticas de películas")
    print("[4] Salir")

    eleccion = input("\nIndique su elección (0, 1, 2, 3, 4): ")
    while eleccion not in "01234":
        eleccion = input("\nElección no válida.\nIndique su elección (0, 1, 2, 3, 4): ")
    eleccion = int(eleccion)
    return eleccion


def leer_archivo():
    lineas_peliculas = []
    with open("peliculas.csv", "r", encoding="utf-8") as datos:
        for linea in datos.readlines()[1:]:
            lineas_peliculas.append(linea.strip())
    return lineas_peliculas


def revisar_estructuras(generos_peliculas, peliculas_por_genero, info_peliculas):
    print("\nGéneros de películas:")
    for genero in generos_peliculas:
        print(f"    - {genero}")

    print("\nTítulos de películas por genero:")
    for genero in peliculas_por_genero:
        print(f"    genero: {genero[0]}")
        for titulo in genero[1]:
            print(f"        - {titulo}")

    print("\nInformación de cada película:")
    for pelicula in info_peliculas:
        print(f"    Nombre: {pelicula[0]}")
        print(f"        - Popularidad: {pelicula[1]}")
        print(f"        - Puntaje Promedio: {pelicula[2]}")
        print(f"        - Votos: {pelicula[3]}")
        print(f"        - Géneros: {pelicula[4]}")


def solicitar_nombre():
    nombre = input("\nIngrese el nombre de la película: ")
    return nombre


def solicitar_genero():
    genero = input("\nIndique el género de película: ")
    return genero


def solicitar_genero_y_criterio():
    genero = input("\nIndique el género de película: ")
    criterio = input(
        "\nIndique el criterio (popularidad, voto promedio, cantidad votos): "
    )
    return genero, criterio


def main():
    lineas_archivo = leer_archivo()
    datos_cargados = True
    try:
        generos_peliculas, peliculas_por_genero, info_peliculas = cargar_datos(
            lineas_archivo
        )
    except TypeError as error:
        if "cannot unpack non-iterable NoneType object" in repr(error):
            print(
                "\nTodavía no puedes ejecutar el programa ya que no has cargado los datos\n"
            )
            datos_cargados = False
    if datos_cargados:
        salir = False
        print("\n********** ¡Bienvenid@! **********")
        while not salir:
            accion = solicitar_accion()

            if accion == 0:
                revisar_estructuras(
                    generos_peliculas, peliculas_por_genero, info_peliculas
                )

            elif accion == 1:
                nombre_pelicula = solicitar_nombre()
                ptje, votos = obtener_puntaje_y_votos(nombre_pelicula)
                print(f"\nObteniendo puntaje promedio y votos de {nombre_pelicula}")
                print(f"    - Puntaje promedio: {ptje}")
                print(f"    - Votos: {votos}")

            elif accion == 2:
                genero = solicitar_genero()
                nombres_peliculas = filtrar_y_ordenar(genero)
                print(f"\nNombres de películas del género {genero} ordenados:")
                for nombre in nombres_peliculas:
                    print(f"    - {nombre}")

            elif accion == 3:
                genero, criterio = solicitar_genero_y_criterio()
                estadisticas = obtener_estadisticas(genero, criterio)
                print(f"\nEstadísticas de {criterio} de películas del género {genero}:")
                print(f"    - Máximo: {estadisticas[0]}")
                print(f"    - Mínimo: {estadisticas[1]}")
                print(f"    - Promedio: {estadisticas[2]}")

            else:
                salir = True
        print("\n********** ¡Adiós! **********\n")


if __name__ == "__main__":
    main()
