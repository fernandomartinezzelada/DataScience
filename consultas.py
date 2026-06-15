# Importar librerías necesarias. NO SE DEBE IMPORTAR NINGUNA OTRA LIBRERÍA.
import mysql.connector as db

# Conexión a la base de datos
conn = db.connect(
  host="localhost",
  user="root",
  password="mysql123", # Cambiar por la contraseña de su base de datos
  database="mp2"
)

# Crear cursor
cursor = conn.cursor()

# NO TOCAR. Función que encapsula lógica para ejecutar una consulta y mostrar los resultados.
def run_query(query, header):
  if not query or query == '':
    print("No se definió consulta para ejecutar")
    return
  try:
    cursor.execute(query)
    rows = cursor.fetchall()
    print(header)
    for row in rows:
      print(row)
  except Exception as e:
    print('Consulta resultó en error: ' + str(e))


# ---------- CONSULTA 1 ----------
# Obtener el número de pedidos que ha realizado el cliente con email "jessicaflores@example.com"
# RELLENAR SOLAMENTE LA VARIABLE consulta_1
consulta_1 = """SELECT COUNT(pedidos.id)
  FROM clientes JOIN pedidos ON (clientes.id = pedidos.id_cliente)
 WHERE clientes.email = 'jessicaflores@example.com';"""

print('\n\n' + '-'*10 + ' INICIO CONSULTA 1 ' + '-'*10 + '\n')
run_query(consulta_1, 'Número de pedidos realizados por cliente con email jessicaflores@example.com:')
print('\n' + '-'*10 + ' FIN CONSULTA 1 ' + '-'*10 + '\n')


# ---------- CONSULTA 2 ----------
# b.	Obtener el id del producto, nombre del producto, precio del producto y cantidad pedida de cada producto solicitado en el pedido con id 2, ordenar según el id del producto, de manera ascendiente.
# RELLENAR SOLAMENTE LA VARIABLE consulta_2
consulta_2 = """SELECT productos.id
     , productos.nombre
     , productos.precio
     , /*SUM(*/productos_pedidos.cantidad/*)*/ AS cantidad_total
  FROM productos JOIN productos_pedidos ON (productos.id = productos_pedidos.id_producto)
 WHERE productos_pedidos.id_pedido = 2
 /*GROUP BY productos.id
     , productos.nombre
     , productos.precio*/
 ORDER BY productos.id ASC;"""

print('\n\n' + '-'*10 + ' INICIO CONSULTA 2 ' + '-'*10 + '\n')
run_query(consulta_2, 'id, nombre, precio y cantidad de productos solicitados en pedido con id 2:')
print('\n' + '-'*10 + ' FIN CONSULTA 2 ' + '-'*10 + '\n')


# ---------- CONSULTA 3 ----------
# c.	Obtener el id, fecha, dirección, id_cliente, detalle y cantidad total de productos comprados del pedido con mayor cantidad de productos comprados.
# RELLENAR SOLAMENTE LA VARIABLE consulta_3
consulta_3 = """SELECT pedidos.id
     , pedidos.fecha
     , pedidos.direccion
     , pedidos.id_cliente
     , pedidos.detalle
     , SUM(productos_pedidos.cantidad) AS cantidad_total
  FROM pedidos, productos_pedidos
 WHERE pedidos.id = productos_pedidos.id_pedido
 GROUP BY pedidos.id
     , pedidos.fecha
     , pedidos.direccion
     , pedidos.id_cliente
     , pedidos.detalle
 ORDER BY cantidad_total DESC LIMIT 0,1;"""

print('\n\n' + '-'*10 + ' INICIO CONSULTA 3 ' + '-'*10 + '\n')
run_query(consulta_3, 'id, fecha, dirección, id_cliente, detalle y cantidad total de productos comprados del pedido con mayor cantidad de productos comprados:')
print('\n' + '-'*10 + ' FIN CONSULTA 3 ' + '-'*10 + '\n')


cursor.close()
conn.close()
