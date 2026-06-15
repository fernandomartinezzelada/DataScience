DROP TABLE IF EXISTS productos_pedidos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS productos;

CREATE TABLE productos (
  id INT NOT NULL,
  nombre VARCHAR(255) NULL,
  descripcion VARCHAR(255) NULL,
  precio INT NULL,
  PRIMARY KEY (id));

CREATE TABLE clientes (
  id INT NOT NULL,
  nombre VARCHAR(255) NULL,
  email VARCHAR(255) NULL,
  PRIMARY KEY (id));

CREATE TABLE pedidos (
  id INT NOT NULL,
  fecha DATE NULL,
  direccion VARCHAR(255) NULL,
  id_cliente INT NOT NULL,
  detalle VARCHAR(255) NULL,
  PRIMARY KEY (id),
  CONSTRAINT `idcliente`
    FOREIGN KEY (id_cliente)
    REFERENCES clientes (id));

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
    REFERENCES pedidos (id));