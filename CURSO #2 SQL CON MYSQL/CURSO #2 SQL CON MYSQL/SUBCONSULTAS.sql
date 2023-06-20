SELECT DISTINCT BARRIO FROM tabla_de_vendedores;

SELECT * FROM TABLA_DE_CLIENTES
WHERE BARRIO IN ('CONDESA', 'DEL VALLE', 'CONTADERO', 'OBLATOS');

SELECT * FROM TABLA_DE_CLIENTES
WHERE BARRIO IN (SELECT DISTINCT BARRIO FROM tabla_de_vendedores);

SELECT ENVASE, MAX(PRECIO_DE_LISTA) AS PRECIO_MAXIMO FROM tabla_de_productos GROUP BY ENVASE;

SELECT X.ENVASE, X.PRECIO_MAXIMO 
FROM (SELECT ENVASE, MAX(PRECIO_DE_LISTA) AS PRECIO_MAXIMO FROM tabla_de_productos GROUP BY ENVASE) 
X WHERE X.PRECIO_MAXIMO >= 10;

SELECT DNI, COUNT(*) AS CONTADOR FROM facturas
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY DNI;

SELECT X.DNI, X.CONTADOR FROM 
(SELECT DNI, COUNT(*) AS CONTADOR FROM facturas
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY DNI) X WHERE X.CONTADOR > 2000;

