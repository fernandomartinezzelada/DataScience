# Importar liibrerías necesarias. NO SE DEBE IMPORTAR NINGUNA OTRA LIBRERÍA.
import mysql.connector as db
import csv

# Desde este punto en adelante se debe crear el código pedido.

mydb=db.connect(
    host="localhost",
    user="root",
    passwd="mysql123",
    database="mp2")

cursor=mydb.cursor() #Cursor a BD mp2

#Borramos las tablas si existen:
squery="DROP TABLE IF EXISTS productos_pedidos"
cursor.execute(squery) #Se borra tabla productos_pedidos
squery="DROP TABLE IF EXISTS pedidos"
cursor.execute(squery) #Se borra tabla pedidos
squery="DROP TABLE IF EXISTS clientes"
cursor.execute(squery) #Se borra tabla clientes
squery="DROP TABLE IF EXISTS productos"
cursor.execute(squery) #Se borra tabla productos

#Creamos tabla de productos:
squery='''
CREATE TABLE productos (
  id INT NOT NULL,
  nombre VARCHAR(255) NULL,
  descripcion VARCHAR(255) NULL,
  precio INT NULL,
  PRIMARY KEY (id));'''
cursor.execute(squery)

#Creamos tabla de clientes:
squery='''
CREATE TABLE clientes (
  id INT NOT NULL,
  nombre VARCHAR(255) NULL,
  email VARCHAR(255) NULL,
  PRIMARY KEY (id));'''
cursor.execute(squery)

#Creamos tabla de pedidos:
squery='''
CREATE TABLE pedidos (
  id INT NOT NULL,
  fecha DATE NULL,
  direccion VARCHAR(255) NULL,
  id_cliente INT NOT NULL,
  detalle VARCHAR(255) NULL,
  PRIMARY KEY (id),
  CONSTRAINT `idcliente`
    FOREIGN KEY (id_cliente)
    REFERENCES clientes (id));'''
cursor.execute(squery)

#Creamos tabla de productos_pedidos:
squery='''
CREATE TABLE productos_pedidos (
  id_producto INT NOT NULL,
  id_pedido INT NOT NULL,
  cantidad INT NULL,
  PRIMARY KEY (id_producto, id_pedido),
  CONSTRAINT `idproducto`
    FOREIGN KEY (id_producto)
    REFERENCES productos (id),
  CONSTRAINT `idpedido`
    FOREIGN KEY (id_pedido)
    REFERENCES pedidos (id));'''
cursor.execute(squery)


#Cargamos los datos del archivo a una lista de listas (filas):
with open(".\data\productos.csv","r",encoding="UTF-8") as file:
    csvreader=csv.reader(file,delimiter=",")
    next(csvreader)
    filas=[]
    for fila in csvreader:
        filas.append(fila)

#visualizamos los datos leidos:
#n=len(filas)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas[i])
#    i+=1

#Insertamos los datos cargados en la base:
squery="INSERT INTO productos VALUES (%s,%s,%s,%s)"
cursor.executemany(squery,filas)
mydb.commit() #Si no hay errores, grabe los datos

#Traemos los datos desde la base:
#squery="SELECT * FROM productos" #traigame todos los registros
#cursor.execute(squery)

#Muestre los datos leidos desde la BD:
#filas_consulta=cursor.fetchall()
#n=len(filas_consulta)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas_consulta[i])
#    i+=1


#Cargamos los datos del archivo a una lista de listas (filas):
with open(".\data\clientes.csv","r",encoding="UTF-8") as file:
    csvreader=csv.reader(file,delimiter=",")
    next(csvreader)
    filas=[]
    for fila in csvreader:
        filas.append(fila)

#visualizamos los datos leidos:
#n=len(filas)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas[i])
#    i+=1

#Insertamos los datos cargados en la base:
squery="INSERT INTO clientes VALUES (%s,%s,%s)"
cursor.executemany(squery,filas)
mydb.commit() #Si no hay errores, grabe los datos

#Traemos los datos desde la base:
#squery="SELECT * FROM clientes" #traigame todos los registros
#cursor.execute(squery)

#Muestre los datos leidos desde la BD:
#filas_consulta=cursor.fetchall()
#n=len(filas_consulta)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas_consulta[i])
#    i+=1


#Cargamos los datos del archivo a una lista de listas (filas):
with open(".\data\pedidos.csv","r",encoding="UTF-8") as file:
    csvreader=csv.reader(file,delimiter=",")
    next(csvreader)
    filas=[]
    for fila in csvreader:
        filas.append(fila)

#visualizamos los datos leidos:
#n=len(filas)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas[i])
#    i+=1

#Insertamos los datos cargados en la base:
squery="INSERT INTO pedidos VALUES (%s,%s,%s,%s,%s)"
cursor.executemany(squery,filas)
mydb.commit() #Si no hay errores, grabe los datos

#Traemos los datos desde la base:
#squery="SELECT * FROM pedidos" #traigame todos los registros
#cursor.execute(squery)

#Muestre los datos leidos desde la BD:
#filas_consulta=cursor.fetchall()
#n=len(filas_consulta)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas_consulta[i])
#    i+=1


#Cargamos los datos del archivo a una lista de listas (filas):
with open(".\data\productos_pedidos.csv","r",encoding="UTF-8") as file:
    csvreader=csv.reader(file,delimiter=",")
    next(csvreader)
    filas=[]
    for fila in csvreader:
        filas.append(fila)

#visualizamos los datos leidos:
#n=len(filas)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas[i])
#    i+=1

#Insertamos los datos cargados en la base:
squery="INSERT INTO productos_pedidos VALUES (%s,%s,%s)"
cursor.executemany(squery,filas)
mydb.commit() #Si no hay errores, grabe los datos

#Traemos los datos desde la base:
#squery="SELECT * FROM productos_pedidos" #traigame todos los registros
#cursor.execute(squery)

#Muestre los datos leidos desde la BD:
#filas_consulta=cursor.fetchall()
#n=len(filas_consulta)
#i=0
#while i<10: #imprima los primeros 10
#    print(filas_consulta[i])
#    i+=1
