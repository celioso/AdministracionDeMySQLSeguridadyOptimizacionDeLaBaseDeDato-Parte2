-- cost 9065.80
EXPLAIN FORMAT = JSON SELECT * FROM facturas WHERE FECHA_VENTA = "20170101" \G;

----------------------------------------------

ALTER TABLE facturas ADD INDEX(FECHA_VENTA);
EXPLAIN FORMAT = JSON SELECT * FROM facturas WHERE FECHA_VENTA = "20170101" \G;

-- Cost 25.90

-------------------------------------------------
 ALTER TABLE facturas DROP INDEX FECHA_VENTA;
EXPLAIN FORMAT = JSON SELECT * FROM facturas WHERE FECHA_VENTA = "20170101" \G;

-- Cost 8849.05