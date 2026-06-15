/*A.- Obtener el número de pedidos que ha realizado el cliente con email
jessicaflores@example.com*/

SELECT COUNT(pedidos.id)
  FROM clientes JOIN pedidos ON (clientes.id = pedidos.id_cliente)
 WHERE clientes.email = 'jessicaflores@example.com';

SELECT COUNT(pedidos.id)
  FROM clientes, pedidos
 WHERE clientes.id = pedidos.id_cliente
   AND clientes.email = 'jessicaflores@example.com';