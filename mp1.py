from mysql import connector as db

#Se conecta a la base de datos mp1:
mydb = db.connect(
    host="localhost",
    user="root",
    password="mysql123",
    database = "mp1"
    )

print("Conectado a la base de datos mp1")

#Se crea cursor:
cursor = mydb.cursor()

def fun_displayquery_soc(squery):
    cursor.execute(squery) #se ejecuta la query
    #muestre la informacion por pantalla:
    filas_consulta=cursor.fetchall()
    n=len(filas_consulta) #numero de filas consulta
    i=0 #contador numero de fila de la consulta
    while i<n: #para cada fila i de la consulta:
        print("id = {}".format(filas_consulta[i][0]))
        print("rut = {}".format(filas_consulta[i][1]))
        print("nombre: {}".format(filas_consulta[i][2]))
        print("registro: {}".format(filas_consulta[i][3]))
        print("comuna: {}".format(filas_consulta[i][4]))
        print("capital: {}".format(filas_consulta[i][5]))
        print() #salto de linea
        i+=1

print("\ntraigame todas las sociedades con rut 77886308-1:")
fun_displayquery_soc("SELECT * FROM mp1.sociedades WHERE rut='77886308-1'")

print("\ntraigame todas las sociedades con capital mayor o igual a 400 000 000:")
fun_displayquery_soc("SELECT * FROM mp1.sociedades WHERE capital>=400000000")

# cargamos en una variable la sentencia SQL para agregar una fila
sqlSentence = 'INSERT INTO mp1.sociedades(id,rut,nombre,registro,comuna,capital) VALUES(%s,%s,%s,%s,%s,%s)'
# cargamos en una variable la tupla
fila = (5156305,'77721389-K','Estrellas SpA','2024-03-11','PROVIDENCIA',1000000)
#ejecutamos la sentencia que agrega la fila
cursor .execute(sqlSentence, fila)
mydb.commit()

print("\ntraigame todas las sociedades con rut 77721389-K':")
fun_displayquery_soc("SELECT * FROM mp1.sociedades WHERE rut='77721389-K'")
