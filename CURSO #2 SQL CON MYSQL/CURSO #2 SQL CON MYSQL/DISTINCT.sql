USE jugos_ventas;
SELECT ENVASE, TAMANO FROM tabla_de_productos;

SELECT DISTINCT ENVASE, TAMANO FROM tabla_de_productos;

SELECT DISTINCT ENVASE, TAMANO, SABOR FROM tabla_de_productos WHERE SABOR = 'Naranja';

SELECT DISTINCT BARRIO FROM tabla_de_clientes WHERE CIUDAD = 'Ciudad de México';


