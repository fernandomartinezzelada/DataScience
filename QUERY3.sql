/*C.- Obtener el id, fecha, dirección, id_cliente, detalle y cantidad total de
productos comprados del pedido con mayor cantidad de productos
comprados.*/

SELECT pedidos.id
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
 ORDER BY cantidad_total DESC LIMIT 0,1;

SELECT pedidos.id
     , pedidos.fecha
     , pedidos.direccion
     , pedidos.id_cliente
     , pedidos.detalle
     , SUM(productos_pedidos.cantidad) AS cantidad_total
  FROM pedidos JOIN productos_pedidos ON (pedidos.id = productos_pedidos.id_pedido)
  GROUP BY pedidos.id
     , pedidos.fecha
     , pedidos.direccion
     , pedidos.id_cliente
     , pedidos.detalle
  ORDER BY cantidad_total DESC LIMIT 0,1;