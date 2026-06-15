import pymongo
import requests
import json

#Se conecta a conexion local (Localhost):
client=pymongo.MongoClient("mongodb://localhost:27017/")

#Se crea (o conecta a) la base de feriados:
mydb=client["feriados"]

#Se conecta a la API del gobierno, de feriados (caida):
#response=requests.get("https://apis.digital.gob.cl/fl/feriados/2024", headers={
#    "User-Agent":"Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0"
#})

#Se conecta a la API clon de feriados:
response=requests.get("https://api-various.vercel.app/api/feriados/2024")
print(response)
#print(response.text)
responseJSON=json.loads(response.text) #datos en formato JSON
#print(responseJSON)
#for t in responseJSON:
#    print(t["nombre"])

#Se crea (o conecta a) la coleccion feriados2024:
colec=mydb["feriados2024"]

###FUNCIONES:

#Procesamiento en la BD Mongo:
def fun_procDBMongo(coleccionMONGO,xJson):
    #Se eliminan los datos de la coleccion antes de insertar los nuevos:
    coleccionMONGO.delete_many({})
    #Se insertan los datos de la API en la coleccion:
    coleccionMONGO.insert_many(xJson)

#Impresion feriado:
def fun_printferiado(resultado):
    for r in resultado:
        if str(r["irrenunciable"])!="1":
            print(str(r["fecha"])+": "+str(r["nombre"])+" ("+str(r["tipo"])+"), Comentario: " + str(r["comentarios"]))
        else:
            print(str(r["fecha"])+": "+str(r["nombre"])+" ("+str(r["tipo"])+": irrenunciable), Comentario: " + str(r["comentarios"]))
    print()

###CONSULTAS A LA BD:

fun_procDBMongo(colec,responseJSON) #Se insertan los datos leidos

print("\nCONSULTAS:\n") #Consultas a MongoDB:

print("Todos los feriados:")
fun_printferiado(colec.find({})) #Trae todos los feriados

print("Feriados del tipo Religioso:")
fun_printferiado(colec.find({"tipo":"Religioso"})) #Todos los feriados del tipo Religioso

print("Feriados irrenunciables:")
fun_printferiado(colec.find({"irrenunciable":"1"})) #Todos los feriados irrenunciables

print("Feriados que incluyen el texto 'Santo' en su nombre:")
#fun_printferiado(colec.find({"nombre":{"$regex":"\w*Santo\w*"}})) #*Santos*
fun_printferiado(colec.find({"nombre":{"$regex":"Santo"}})) #Todos los feriados 'Santos'

#Feriados entre el 11 de marzo de 2024 y el 31 agosto de 2024:
colec.delete_many(
    {
        "fecha":{
            "$lt":"2024-03-11" #Primero borramos los que sean < 2024-03-11
            }
    }
)

print("Feriados entre el 11 de marzo de 2024 y el 31 agosto de 2024:")
fun_printferiado(colec.find(
    {
        #"fecha":{
        #    "$gte":"2024-03-11" #(>=) Por el borrado anterior, todos cumplen esta condicion
        #    }
        #,
        "fecha":{
            "$lte":"2024-08-31" #<= 2024-08-2024
            }
    }
))

fun_procDBMongo(colec,responseJSON) #Se reinsertan los datos borrados

#Insertamos un nuevo feriado con las siguientes características:
colec.insert_one(
    {
        "nombre":"Día de las luces", #nombre: Día de las luces
        "comentarios":None,          #comentarios: null
        "fecha":"2024-03-11",        #fecha: 2024-03-11
        "irrenunciable":"0",         #irrenunciable: 0
        "tipo":"Religioso"           #tipo: Religioso
    }
)

print("Feriado insertado:")
fun_printferiado(colec.find({"nombre":"Día de las luces"})) #Feriado insertado
