# Administración de MySQL: Seguridad y optimización de la base de datos - 2

### Preparando el ambiente

Para que puedas continuar con este entrenamiento, debes de haber concluído la Parte 1 del curso Administración de MySQL: Seguridad y optimización de la base de datos. Si aún no lo has hecho, te invito a que lo hagas antes de continuar con la siguiente actividad.

[Descargue los archivos en Github](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2 "Descargue los archivos en Github") o haga clic [aquí](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/archive/refs/heads/main.zip "aquí") para descargarlos directamente.

### Haga lo que hicimos en aula

Llegó la hora de que sigas todos los pasos realizados por mí durante esta clase. Si ya lo has hecho ¡Excelente! Si todavía no lo has hecho, es importante que ejecutes lo que fue visto en los vídeos para que puedas continuar con la próxima aula.

1. Selecciona la base jugos_ventas, y crea un nuevo script MySQL.

2. Digita las siguientes consultas:

```SQL
SELECT A.CODIGO_DEL_PRODUCTO FROM tabla_de_productos A;

SELECT A.CODIGO_DEL_PRODUCTO, C.CANTIDAD FROM tabla_de_productos A 
INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO;

SELECT A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) AS ANO,C.CANTIDAD FROM tabla_de_productos A 
INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO 
INNER JOIN facturas B ON C.NUMERO = B.NUMERO;

SELECT A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) AS ANO, SUM(C.CANTIDAD) AS CANTIDAD FROM tabla_de_productos A 
INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO 
INNER JOIN facturas B ON C.NUMERO = B.NUMERO 
GROUP BY A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) 
ORDER BY A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA);
```

3) Luego de que ejecutes estas consultas, una a una, notarás que durante cada ejecución , el tiempo de la consulta se demora un poco más ya que las mismas van exigiendo más procesamiento de la base de datos:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/1.png)

4. A través del símbolo del sistema de Windows, accede al directorio de MySQL:

```SQL
cd\
cd "Program Files"
cd "MySQL"
cd "MySQL Server 8.0"
cd Bin
```

5. En seguida, accede a la interfaz de línea de comando de MySQL (la contraseña del usuario root será necesaria):

```SQL
mysql -uroot -p
```

6. Al estar dentro de la interfaz de línea de comando de MySQL, digita:

```SQL
EXPLAIN SELECT A.CODIGO_DEL_PRODUCTO FROM tabla_de_productos A;
```

7. Observarás algunos indicadores que reflejan el costo de ejecución de esta consulta:
![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/2.png)

```SQL
C:\Users\celio>cd\

C:\>cd "Progarm Files"
El sistema no puede encontrar la ruta especificada.

C:\>cd "Program Files"

C:\Program Files>cd MySQL

C:\Program Files\MySQL>cd "MySQL Server 8.0"

C:\Program Files\MySQL\MySQL Server 8.0>cd bin

C:\Program Files\MySQL\MySQL Server 8.0\bin>mysql -uroot -p
Enter password: **********
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 68
Server version: 8.0.31 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> USE jugos_ventas;
Database changed
mysql> EXPLAIN SELECT CODIGO_DEL_PRODUCTO FROM tabla_de_productos A;
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | A     | NULL       | index | NULL          | PRIMARY | 42      | NULL |   38 |   100.00 | Using index |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
```

8) Para visualizar el plan de ejecución en otro formato, digita:

```SQL
EXPLAIN FORMAT=JSON SELECT A.CODIGO_DEL_PRODUCTO FROM tabla_de_productos A \G;
```

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/3.png)

```SQL
mysql> EXPLAIN SELECT CODIGO_DEL_PRODUCTO FROM tabla_de_productos A \G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: A
   partitions: NULL
         type: index
possible_keys: NULL
          key: PRIMARY
      key_len: 42
          ref: NULL
         rows: 38
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.00 sec)
```
```SQL
mysql> EXPLAIN FORMAT = JSON SELECT CODIGO_DEL_PRODUCTO FROM tabla_de_productos A \G;
*************************** 1. row ***************************
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "4.05"
    },
    "table": {
      "table_name": "A",
      "access_type": "index",
      "key": "PRIMARY",
      "used_key_parts": [
        "CODIGO_DEL_PRODUCTO"
      ],
      "key_length": "42",
      "rows_examined_per_scan": 38,
      "rows_produced_per_join": 38,
      "filtered": "100.00",
      "using_index": true,
      "cost_info": {
        "read_cost": "0.25",
        "eval_cost": "3.80",
        "prefix_cost": "4.05",
        "data_read_per_join": "16K"
      },
      "used_columns": [
        "CODIGO_DEL_PRODUCTO"
      ]
    }
  }
}
1 row in set, 1 warning (0.00 sec)

ERROR:
No query specified
```

De esta manera, obtendrás el plan de ejecución de esta consulta y el parámetro cost_info que expresa el costo para la resolución de esta query (En este caso, 4.50).

9. Veamos el costo de una nueva consulta. Digita:

```SQL
EXPLAIN FORMAT=JSON SELECT A.CODIGO_DEL_PRODUCTO, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO \G;
```

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/4.png)

Aquí, el costo de la consulta aumentó a 77082.36 de acuerdo con el plan de ejecución. O sea, miles de veces en relación con la consulta anterior. Es sorprendente, ¿Verdad?

10. Veamos el costo de una última consulta. Digita:

```SQL
EXPLAIN FORMAT=JSON SELECT A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) AS ANO,C.CANTIDAD FROM tabla_de_productos A  INNER  JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas B ON C.NUMERO = B.NUMERO \G;
```

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/5.png)

```SQL
mysql> EXPLAIN FORMAT = JSON SELECT A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) AS AÑO, SUM(C.CANTIDAD) AS CANTIDAD, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C  ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas B ON C.NUMERO = B.NUMERO GROUP BY A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) ORDER BY A.CODIGO_DEL_PRODUCTO, YEAR(FECHA_VENTA) \G;
*************************** 1. row ***************************
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "149808.99"
    },
    "ordering_operation": {
      "using_filesort": false,
      "grouping_operation": {
        "using_temporary_table": true,
        "using_filesort": true,
        "nested_loop": [
          {
            "table": {
              "table_name": "B",
              "access_type": "ALL",
              "possible_keys": [
                "PRIMARY"
              ],
              "rows_examined_per_scan": 87768,
              "rows_produced_per_join": 87768,
              "filtered": "100.00",
              "cost_info": {
                "read_cost": "72.25",
                "eval_cost": "8776.80",
                "prefix_cost": "8849.05",
                "data_read_per_join": "6M"
              },
              "used_columns": [
                "FECHA_VENTA",
                "NUMERO"
              ]
            }
          },
          {
            "table": {
              "table_name": "C",
              "access_type": "ref",
              "possible_keys": [
                "PRIMARY",
                "CODIGO_DEL_PRODUCTO"
              ],
              "key": "PRIMARY",
              "used_key_parts": [
                "NUMERO"
              ],
              "key_length": "4",
              "ref": [
                "jugos_ventas.B.NUMERO"
              ],
              "rows_examined_per_scan": 2,
              "rows_produced_per_join": 215724,
              "filtered": "100.00",
              "cost_info": {
                "read_cost": "43884.00",
                "eval_cost": "21572.43",
                "prefix_cost": "74305.48",
                "data_read_per_join": "11M"
              },
              "used_columns": [
                "NUMERO",
                "CODIGO_DEL_PRODUCTO",
                "CANTIDAD"
              ]
            }
          },
          {
            "table": {
              "table_name": "A",
              "access_type": "eq_ref",
              "possible_keys": [
                "PRIMARY"
              ],
              "key": "PRIMARY",
              "used_key_parts": [
                "CODIGO_DEL_PRODUCTO"
              ],
              "key_length": "42",
              "ref": [
                "jugos_ventas.C.CODIGO_DEL_PRODUCTO"
              ],
              "rows_examined_per_scan": 1,
              "rows_produced_per_join": 215724,
              "filtered": "100.00",
              "using_index": true,
              "cost_info": {
                "read_cost": "53931.08",
                "eval_cost": "21572.43",
                "prefix_cost": "149809.00",
                "data_read_per_join": "93M"
              },
              "used_columns": [
                "CODIGO_DEL_PRODUCTO"
              ]
            }
          }
        ]
      }
    }
  }
}
1 row in set, 1 warning (0.00 sec)

ERROR:
No query specified
```

El costo aumentó aún más (360123.73). Esto quiere decir que, mientras las consultas a las tablas involucren *Joins*, el costo de procesamiento aumentará sustancialmente. Uno de los principales desafíos del DBA es el de auxiliar al analista de modo que sus consultas sean menos costosas y consecuentemente más rápidas.

### Lo que aprendimos

Lo que aprendimos en esta aula:

- A identificar un plan de ejecución.
- Cómo analizar el plan de ejecución.
- Visualizar el plan de ejecución.

###  Proyecto del aula anterior

¿Comenzando en esta etapa? Aquí puedes descargar los archivos del proyecto que hemos avanzado hasta el aula anterior.

[Descargue los archivos en Github](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/tree/aula-2 "Descargue los archivos en Github") o haga clic [aquí](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/archive/refs/heads/aula-2.zip "aquí") para descargarlos directamente.

