##############################################################
## Si necesita agregar imports, debe agregarlos aquí arriba ##
from personas import Repartidor, Cocinero, Cliente

### INICIO PARTE 3 ###
class Restaurante:
    def __init__(self,snombre,dic_platos,lcocineros,lrepartidores):
        self.nombre=snombre #snombrerestaurante
        self.platos=dic_platos #{snombreplato:[snombreplato,stipoplato]}
        self.cocineros=lcocineros #[Cocinero(),Cocinero(),Cocinero()]
        self.repartidores=lrepartidores #[Repartidor(),Repartidor(),Repartidor()]
        self.calificacion=0 #Int
    def recibir_pedidos(self,clientes):
        lclientes=clientes #[Cliente(),Cliente(),Cliente()]
        lcocineros = self.cocineros
        lrepartidores = self.repartidores
        dic_platos = self.platos
        i=0 #contador de clientes
        nc=len(lclientes) #Num. de clientes
        while i<nc: #Para cada cliente:
            lpedido=[] #Lista de platos del pedido
            lsnomplatospreferidos=lclientes[i].platos_preferidos
            j=0 #contador de platos
            np=len(lsnomplatospreferidos) #Num. de platos del cliente
            while j<np: #Para cada plato del cliente:
                snomplato=lsnomplatospreferidos[j] #nombre del plato
                k=0 #contador de cocineros
                nk=len(lcocineros) #Num. de cocineros
                while k<nk: #Para cada cocinero:
                    if lcocineros[k].energia>0: #Energia suficiente?
                        stipoplato=dic_platos[snomplato][1] #tipo plato es la 2da. columna del valor del dic.
                        plato_cocinado=lcocineros[k].cocinar([snomplato,stipoplato]) #cocinamos!
                        lpedido.append(plato_cocinado) #Agregamos plato cocinado al pedido
                        break #plato cocinado, plato siguiente
                    k+=1 #cocinero siguiente
                j+=1 #plato siguiente
            r=0 #contador de repartidores
            nr=len(lrepartidores) #Num. de repartidores
            ndemorapedido=0 #por defecto el t. de demora es cero
            while r<nr: #Para cada repartidor:
                if lrepartidores[r].energia>0: #Energia suficiente?
                    ndemorapedido=lrepartidores[r].repartir(lpedido) #se reparte el pedido
                    break #pedido entregado, a calificar pedido
                r+=1 #repartidor siguiente
            if ndemorapedido==0:
                lpedido=[] #pedido vacio
            notacliente=lclientes[i].recibir_pedido(lpedido,ndemorapedido) #cliente califica pedido
            self.calificacion+=notacliente #se suma nota a la calificacion general
            i+=1 #cliente siguiente
        self.calificacion/=nc #se divide calificacion total por num. clientes
    #pass
### FIN PARTE 3 #


if __name__ == "__main__":

    ### Código para probar que tu clase haya sido creada correctamente  ###
    ### Corre directamente este archivo para que este código se ejecute ###
    try:
        PLATOS_PRUEBA = {
        "Pepsi": ["Pepsi", "Bebestible"],
        "Mariscos": ["Mariscos", "Comestible"],
        }
        un_restaurante = Restaurante("Bon Appetit", PLATOS_PRUEBA, [Cocinero("C1", 10),Cocinero("C2", 10),Cocinero("C3", 10)], [Repartidor("R1", 20),Repartidor("R2", 20),Repartidor("R3", 20)])
        print(f"El restaurante {un_restaurante.nombre}, tiene los siguientes platos:")
        for plato in un_restaurante.platos.values():
            print(f" - {plato[1]}: {plato[0]}")
    except TypeError:
        print("Hay una cantidad incorrecta de argumentos en algún inicializador y/o todavía no defines una clase")
    except AttributeError:
        print("Algún atributo esta mal definido y/o todavia no defines una clase")
