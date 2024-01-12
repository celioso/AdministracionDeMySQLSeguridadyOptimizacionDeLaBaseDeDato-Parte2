-- cost 4.05
SELECT CODIGO_DEL_PRODUCTO FROM tabla_de_productos A;

-- cost 45534.88
SELECT A.CODIGO_DEL_PRODUCTO, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C  ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO;

-- cost 149808.99
SELECT A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) AS AÑO, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C  ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas B ON C.NUMERO = B.NUMERO;

-- cost 149808.99
SELECT A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) AS AÑO, SUM(C.CANTIDAD) AS CANTIDAD, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C  ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas B ON C.NUMERO = B.NUMERO GROUP BY A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) ORDER BY A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA);
