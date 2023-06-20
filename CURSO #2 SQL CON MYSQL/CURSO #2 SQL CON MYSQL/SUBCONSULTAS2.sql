SELECT  ENVASE, MAX(PRECIO_DE_LISTA)
AS PRECIO_MAXIMO FROM tabla_de_productos GROUP BY ENVASE;

USE `jugos_ventas`;
CREATE  OR REPLACE VIEW `VW_ENVASES_GRANDES` AS
SELECT  ENVASE, MAX(PRECIO_DE_LISTA)
AS PRECIO_MAXIMO FROM tabla_de_productos GROUP BY ENVASE;

SELECT X.ENVASE, X.PRECIO_MAXIMO FROM
VW_ENVASES_GRANDES X 
WHERE PRECIO_MAXIMO >= 10;

SELECT A.NOMBRE_DEL_PRODUCTO, A.ENVASE, A.PRECIO_DE_LISTA,
B.PRECIO_MAXIMO FROM tabla_de_productos A
INNER JOIN 
VW_ENVASES_GRANDES B 
ON A.ENVASE = B.ENVASE;

SELECT A.NOMBRE_DEL_PRODUCTO, A.ENVASE, A.PRECIO_DE_LISTA,
((A.PRECIO_DE_LISTA/B.PRECIO_MAXIMO)-1)*100 AS PORCENTAJE_VARIACION FROM tabla_de_productos A
INNER JOIN 
VW_ENVASES_GRANDES B 
ON A.ENVASE = B.ENVASE;