/*B.- Obtener el id del producto, nombre del producto, precio del producto y
cantidad pedida de cada producto solicitado en el pedido con id 2, ordenar
según el id del producto, de manera ascendiente.*/

SELECT productos.id
     , productos.nombre
     , productos.precio
     , SUM(productos_pedidos.cantidad) AS cantidad_total
  FROM productos, productos_pedidos
 WHERE productos.id = productos_pedidos.id_producto
   AND productos_pedidos.id_pedido = 2
 GROUP BY productos.id
     , productos.nombre
     , productos.precio
 ORDER BY productos.id ASC;

SELECT productos.id
     , productos.nombre
     , productos.precio
     , /*SUM(*/productos_pedidos.cantidad/*)*/ AS cantidad_total
  FROM productos JOIN productos_pedidos ON (productos.id = productos_pedidos.id_producto)
 WHERE productos_pedidos.id_pedido = 2
 /*GROUP BY productos.id
     , productos.nombre
     , productos.precio*/
 ORDER BY productos.id ASC;