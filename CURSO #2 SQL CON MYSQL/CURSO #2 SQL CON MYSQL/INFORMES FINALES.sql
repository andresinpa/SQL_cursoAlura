# GENERACION DE INFORMES

SELECT * FROM FACTURAS;

SELECT * FROM items_facturas;

SELECT F.DNI, F.FECHA_VENTA, IFa.CANTIDAD FROM facturas F 
INNER JOIN 
items_facturas IFa
ON F.NUMERO = IFa.NUMERO;

#MOSTRANDO SOLO MES Y AÑO
SELECT F.DNI, DATE_FORMAT(F.FECHA_VENTA, "%M-%Y") AS MES_AÑO, IFa.CANTIDAD FROM facturas F 
INNER JOIN 
items_facturas IFa
ON F.NUMERO = IFa.NUMERO;

#CANTIDAD DE VENTAS AL CLIENTE POR MES
SELECT F.DNI, DATE_FORMAT(F.FECHA_VENTA, "%M-%Y") AS MES_AÑO, SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA FROM facturas F 
INNER JOIN 
items_facturas IFa
ON F.NUMERO = IFa.NUMERO 
GROUP BY F.DNI, DATE_FORMAT(F.FECHA_VENTA, "%M - %Y");

#VENTAS INVÁLIDAS Y VENTAS VÁLIDAS - CANTIDAD VENDIDA EN PORCENTUALES
SELECT A.DNI, A.NOMBRE, A.MES_AÑO, 
A.CANTIDAD_VENDIDA - A.CANTIDAD_MAXIMA AS DIFERENCIA,
CASE
   WHEN  (A.CANTIDAD_VENDIDA - A.CANTIDAD_MAXIMA) <= 0 THEN 'Venta Válida'
   ELSE 'Venta Inválida'
END AS STATUS_VENTA, ROUND((1 - (A.CANTIDAD_MAXIMA/A.CANTIDAD_VENDIDA)) * 100,2) AS PORCENTAJE
 FROM(
SELECT F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%m - %Y") AS MES_AÑO, 
SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA, 
MAX(VOLUMEN_DE_COMPRA)/10 AS CANTIDAD_MAXIMA  
FROM facturas F 
INNER JOIN 
items_facturas IFa
ON F.NUMERO = IFa.NUMERO
INNER JOIN 
tabla_de_clientes TC
ON TC.DNI = F.DNI
GROUP BY
F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%m - %Y"))A
WHERE (A.CANTIDAD_MAXIMA - A.CANTIDAD_VENDIDA) < 0;

#LIMITE DE VENTAS PARA CADA CLIENTE (VOLUMEN EN DECILITROS)
SELECT * FROM tabla_de_clientes TC;

SELECT DNI, NOMBRE, VOLUMEN_DE_COMPRA FROM tabla_de_clientes TC;

SELECT F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M-%Y") AS MES_AÑO, SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA, MAX(VOLUMEN_DE_COMPRA)/10 AS CANTIDAD_MAX 
FROM facturas F 
INNER JOIN 
items_facturas IFa 
ON F.NUMERO = IFa.NUMERO 
INNER JOIN
TABLA_DE_CLIENTES TC
ON TC.DNI = F.DNI
GROUP BY F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M - %Y");

#DIFERENCIA ENTRE CANTIDAD VENDIDA Y MAXIMA
SELECT A.DNI, A.NOMBRE, A.MES_AÑO, A.CANTIDAD_VENDIDA - A.CANTIDAD_MAX
AS DIFERENCIA FROM (
	SELECT F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M-%Y") AS MES_AÑO, SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA, MAX(VOLUMEN_DE_COMPRA)/10 AS CANTIDAD_MAX 
FROM facturas F 
INNER JOIN 
items_facturas IFa 
ON F.NUMERO = IFa.NUMERO 
INNER JOIN
TABLA_DE_CLIENTES TC
ON TC.DNI = F.DNI
GROUP BY F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M - %Y")) A;

#USANDO CASE PARA DIFERENCIAR
SELECT A.DNI, A.NOMBRE, A.MES_AÑO, A.CANTIDAD_VENDIDA - A.CANTIDAD_MAX
AS DIFERENCIA,
CASE WHEN (A.CANTIDAD_VENDIDA - A.CANTIDAD_MAX) < 0 THEN 'VENTA VALIDA' ELSE 'VENTA INVALIDA' END AS STATUS_VENTA
 FROM (
	SELECT F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M-%Y") AS MES_AÑO, SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA, MAX(VOLUMEN_DE_COMPRA)/10 AS CANTIDAD_MAX 
FROM facturas F 
INNER JOIN 
items_facturas IFa 
ON F.NUMERO = IFa.NUMERO 
INNER JOIN
TABLA_DE_CLIENTES TC
ON TC.DNI = F.DNI
GROUP BY F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%M - %Y")) A;

#lista solamente a los que tuvieron ventas inválidas en el año 2018 excediendo más del 50% de su límite permitido por mes. 
SELECT A.DNI, A.NOMBRE, A.MES_AÑO, 
A.CANTIDAD_VENDIDA - A.CANTIDAD_MAXIMA AS DIFERENCIA,
CASE
   WHEN  (A.CANTIDAD_VENDIDA - A.CANTIDAD_MAXIMA) <= 0 THEN 'Venta Válida'
   ELSE 'Venta Inválida'
END AS STATUS_VENTA, ROUND((1 - (A.CANTIDAD_MAXIMA/A.CANTIDAD_VENDIDA)) * 100,2) AS PORCENTAJE
 FROM(
SELECT F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%m - %Y") AS MES_AÑO, 
SUM(IFa.CANTIDAD) AS CANTIDAD_VENDIDA, 
MAX(VOLUMEN_DE_COMPRA)/10 AS CANTIDAD_MAXIMA  
FROM facturas F 
INNER JOIN 
items_facturas IFa
ON F.NUMERO = IFa.NUMERO
INNER JOIN 
tabla_de_clientes TC
ON TC.DNI = F.DNI
GROUP BY
F.DNI, TC.NOMBRE, DATE_FORMAT(F.FECHA_VENTA, "%m - %Y"))A
WHERE (A.CANTIDAD_MAXIMA - A.CANTIDAD_VENDIDA) < 0 AND ROUND((1 - (A.CANTIDAD_MAXIMA/A.CANTIDAD_VENDIDA)) * 100,2) > 50
AND A.MES_AÑO LIKE "%2018";

#INFORME VENTAS POR SABOR CANTIDAD EN LT Y PORCENTAJE 
SELECT P.SABOR, IFa.CANTIDAD, F.FECHA_VENTA FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO;

#INFORME VENTAS POR SABOR CANTIDAD EN LT Y PORCENTAJE 
SELECT P.SABOR, SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, YEAR(F.FECHA_VENTA) FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY P.SABOR, YEAR(F.FECHA_VENTA);

#CANTIDAD VENDID PORSABOR AÑO 2016
SELECT P.SABOR, SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, YEAR(F.FECHA_VENTA) FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY P.SABOR, YEAR(F.FECHA_VENTA)
ORDER BY SUM(IFa.CANTIDAD);

# CANTIDAD TOTAL POR AÑO
SELECT SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, YEAR(F.FECHA_VENTA) FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY YEAR(F.FECHA_VENTA);



SELECT VENTAS_SABOR.SABOR,VENTAS_SABOR.AÑO, VENTAS_SABOR.CANTIDAD_TOTAL,
ROUND((VENTAS_SABOR.CANTIDAD_TOTAL/ VENTA_TOTAL.CANTIDAD_TOTAL) *100,2) AS PORCENTAJE
FROM(
SELECT P.SABOR, SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, YEAR(F.FECHA_VENTA) AS AÑO FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY P.SABOR, YEAR(F.FECHA_VENTA)
ORDER BY SUM(IFa.CANTIDAD) DESC) VENTAS_SABOR
INNER JOIN (
SELECT SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, YEAR(F.FECHA_VENTA) AS AÑO FROM 
tabla_de_productos P 
INNER JOIN
items_facturas IFa 
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F 
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(FECHA_VENTA) = 2016
GROUP BY YEAR(F.FECHA_VENTA)) VENTA_TOTAL
ON VENTA_TOTAL.AÑO = VENTAS_SABOR.AÑO
ORDER BY VENTAS_SABOR.CANTIDAD_TOTAL DESC;

#VENTAS PORCENTULES POR AÑO
SELECT VENTAS_TAMANO.TAMANO, VENTAS_TAMANO.AÑO, VENTAS_TAMANO.CANTIDAD_TOTAL,
ROUND((VENTAS_TAMANO.CANTIDAD_TOTAL/VENTA_TOTAL.CANTIDAD_TOTAL)*100,2) 
AS PORCENTAJE FROM (
SELECT P.TAMANO, SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, 
YEAR(F.FECHA_VENTA) AS AÑO FROM
tabla_de_productos P
INNER JOIN
items_facturas IFa
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(F.FECHA_VENTA) = 2016
GROUP BY P.TAMANO, YEAR(F.FECHA_VENTA)
ORDER BY SUM(IFa.CANTIDAD) DESC) VENTAS_TAMANO
INNER JOIN (
SELECT SUM(IFa.CANTIDAD) AS CANTIDAD_TOTAL, 
YEAR(F.FECHA_VENTA) AS AÑO FROM
tabla_de_productos P
INNER JOIN
items_facturas IFa
ON P.CODIGO_DEL_PRODUCTO = IFa.CODIGO_DEL_PRODUCTO
INNER JOIN
facturas F
ON F.NUMERO = IFa.NUMERO
WHERE YEAR(F.FECHA_VENTA) = 2016
GROUP BY YEAR(F.FECHA_VENTA)) VENTA_TOTAL
ON VENTA_TOTAL.AÑO = VENTAS_TAMANO.AÑO
ORDER BY VENTAS_TAMANO.CANTIDAD_TOTAL DESC;
