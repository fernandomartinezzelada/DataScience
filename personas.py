##############################################################
from random import randint
from platos import Comestible, Bebestible
## Si necesita agregar imports, debe agregarlos aquí arriba ##


### INICIO PARTE 2.1 ###
class Persona:
    def __init__(self,snombrepersona):
        self.nombre=snombrepersona
    #pass
### FIN PARTE 2.1 ###
        
### INICIO PARTE 2.2 ###
class Repartidor(Persona):
    def __init__(self,snombrerepartidor,nsegundosdemora):
        super().__init__(snombrerepartidor)
        self.tiempo_entrega=nsegundosdemora #int[20,30]
        self.energia=randint(75,100)
    def repartir(self,pedido):
        lplatos=pedido
        num_platos=len(lplatos) #Numero de platos
        if num_platos<=2:
            factor_tamano=5       #1/Fact_red=energia_reducida/energia_original [13° Simposio Internacional de Ingeniería de Sistemas de Procesos (PSE 2018)
#Boris Brigljević , ... Jae Hyung Choi , en Ingeniería química asistida por computadora, 2018]
            factor_velocidad=1.25
        elif num_platos>=3:
            factor_tamano=15      #1/Fact_red=energia_reducida/energia_original [13° Simposio Internacional de Ingeniería de Sistemas de Procesos (PSE 2018)
#Boris Brigljević , ... Jae Hyung Choi , en Ingeniería química asistida por computadora, 2018]
            factor_velocidad=.85
        self.energia=self.energia/factor_tamano #energia_reducida=energia_original/Fact_red [ver cita anterior]
        return self.tiempo_entrega*factor_velocidad #tiempo de demora del pedido
    #pass
### FIN PARTE 2.2 ###
        
### INICIO PARTE 2.3 ###
class Cocinero(Persona):
    def __init__(self,snombrecocinero,nhabilidad):
        super().__init__(snombrecocinero)
        self.habilidad=nhabilidad #int[1,10]
        self.energia=randint(50,80) #int[50,80]
    def cocinar(self,informacion_plato):
        snombreplato=informacion_plato[0]
        tipo_plato=informacion_plato[1]
        if tipo_plato=="Bebestible":
            plato=Bebestible(snombreplato)
            if plato.tamano=="Pequeño":
                self.energia-=5
            elif plato.tamano=="Mediano":
                self.energia-=8
            elif plato.tamano=="Grande":
                self.energia-=10
        elif tipo_plato=="Comestible":
            plato=Comestible(snombreplato)
            self.energia-=15
        else:
            return None
        if plato.dificultad>self.habilidad:
            factor_calidad=.7
        else:
            factor_calidad=1.5
        plato.calidad*=factor_calidad
        return plato
    #pass 
### FIN PARTE 2.3 ###
        
### INICIO PARTE 2.4 ###
class Cliente(Persona):
    def __init__(self,snombrecliente,lplatospreferidos):
        super().__init__(snombrecliente)
        self.platos_preferidos=lplatospreferidos #1 a 5 platos
    def recibir_pedido(self,pedido,demora):
        lplatos=pedido
        ntiempo=demora
        ncalificacion=10.0
        if len(lplatos)<len(self.platos_preferidos) or ntiempo>=20:
            ncalificacion/=2
        i=0
        n=len(lplatos)
        while i<n:
            if lplatos[i].calidad>=11:
                ncalificacion+=1.5
            elif lplatos[i].calidad<=8:
                ncalificacion-=3
                if ncalificacion<0:
                    ncalificacion=0
            i+=1
        return ncalificacion
### FIN PARTE 2.4 ###


if __name__ == "__main__":

    ### Código para probar que tu clase haya sido creada correctamente  ###
    ### Corre directamente este archivo para que este código se ejecute ###
    try:
        PLATOS_PRUEBA = [
        "Jugo Natural",
        "Empanadas",
        ]
        un_cocinero = Cocinero("Cristian", randint(1, 10))
        un_repartidor = Repartidor("Tomás", randint(20, 30))
        un_cliente = Cliente("Alberto", PLATOS_PRUEBA)
        print(f"El cocinero {un_cocinero.nombre} tiene una habilidad: {un_cocinero.habilidad}")
        print(f"El repatidor {un_repartidor.nombre} tiene una tiempo de entrega: {un_repartidor.tiempo_entrega} seg")
        print(f"El cliente {un_cliente.nombre} tiene los siguientes platos favoritos:")
        for plato in un_cliente.platos_preferidos:
            print(f" - {plato}")
    except TypeError:
        print("Hay una cantidad incorrecta de argumentos en algún inicializador y/o todavía no defines una clase")
    except AttributeError:
        print("Algún atributo esta mal definido y/o todavia no defines una clase")

    #Test Fernando:
    lplatos=[]
    lplatos.append(un_cocinero.cocinar(["Jugo Natural","Bebestible"]))
    lplatos.append(un_cocinero.cocinar(["Empanadas","Comestible"]))
    ndemora=un_repartidor.repartir(lplatos)
    nota=un_cliente.recibir_pedido(lplatos,ndemora)
    print("La nota del cliente es de {} ya que el pedido tardó {} seg".format(nota,ndemora))
