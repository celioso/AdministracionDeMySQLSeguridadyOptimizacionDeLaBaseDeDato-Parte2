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

### Haga lo que hicimos en aula

Llegó la hora de que sigas todos los pasos realizados por mí durante esta clase. Si ya lo has hecho ¡Excelente! Si todavía no lo has hecho, es importante que ejecutes lo que fue visto en los vídeos para que puedas continuar con la próxima aula.

1. A través del símbolo del sistema de Windows, accede al directorio de MySQL:

```SQL
cd\
cd "Program Files"
cd "MySQL"
cd "MySQL Server 8.0"
cd Bin
```

2. En seguida, accede a la interfaz de línea de comando de MySQL (la contraseña del usuario root será necesaria):

```SQL
mysql -uroot -p
```

3. Al estar dentro de la interfaz de línea de comando de MySQL, digita:

```SQL
SELECT * FROM FACTURAS WHERE FECHA_VENTA='20170101';
```

4. Ahora, vamos a analizar el plan de ejecución de este comando:

```SQL
EXPLAIN FORMAT=JSON SELECT * FROM FACTURAS WHERE FECHA_VENTA='20170101' \G; 
```

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/6.png)

El costo de esta consulta fue de 9065.80.

5. Para mejorar esta consulta, una de las maneras más efectivas es creando un índice para el campo empleado como criterio de filtro. Para nuestro caso, el campo que queremos modificar es `FECHA_VENTA`. Digita y ejecuta:

```SQL
ALTER TABLE FACTURAS ADD INDEX(FECHA_VENTA);
```

6. Analicemos el plan de ejecución de la query anterior después de crear el índice. Digita y ejecuta nuevamente:

```SQL
EXPLAIN FORMAT=JSON SELECT * FROM FACTURAS WHERE FECHA_VENTA='20170101' \G; 
```

¿Cuál es el costo que obtuviste para esta consulta?

7. En efecto, el costo de la consulta se redujo considerablemente debido a que la búsqueda de la información está siendo realizada mediante el índice. No es necesario recorrer toda la tabla, sino que ya el índice está allí facilitando el procesamiento de la información:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/7.png)

8. Ahora, eliminemos el índice del campo usado como criterio de filtro a través del siguiente comando para verificar si realmente el índice hace la diferencia a la hora de realizar nuestras consultas:

```SQL
ALTER TABLE FACTURAS DROP INDEX FECHA_VENTA;
```

9. Analicemos una vez más el plan de ejecución:

```SQL
EXPLAIN FORMAT=JSON SELECT * FROM FACTURAS WHERE FECHA_VENTA='20170101' \G; 
```

¿Cuál fue el costo obtenido después de eliminar el índice?

### Lo que aprendimos

Lo que aprendimos en esta aula:

- A reconocer el concepto de índices.
- El funcionamiento del algoritmo B-Tree.
- El funcionamiento del algoritmo Hash.
- A utilizar índices.

### Proyecto del aula anterior

¿Comenzando en esta etapa? Aquí puedes descargar los archivos del proyecto que hemos avanzado hasta el aula anterior.

[Descargue los archivos en Github](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/tree/aula-3 "Descargue los archivos en Github") o haga clic [aquí](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/archive/refs/heads/aula-3.zip "aquí") para descargarlos directamente.

### Haga lo que hicimos en aula

Llegó la hora de que sigas todos los pasos realizados por mí durante esta clase. Si ya lo has hecho ¡Excelente! Si todavía no lo has hecho, es importante que ejecutes lo que fue visto en los vídeos para que puedas continuar con la próxima aula.

1. En Workbench también podemos consultar el plan de ejecución. Crea un nuevo script SQL, digita y ejecuta:

```SQL
SELECT A.CODIGO_DEL_PRODUCTO FROM tabla_de_productos A;
```

2. En el área donde aparece el resultado, dirígete hacia el final de las opciones, y selecciona Execution Plan:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/8.png)

Observarás el plan de ejecución de manera gráfica.

3. Visualicemos consultas más complejas. Primero, digita y ejecuta en el mismo script:

```SQL
SELECT A.CODIGO_DEL_PRODUCTO, C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO;
```

4. Al visualizar nuevamente el plan de ejecución, aparece así:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/9.png)

5. También, digita y ejecuta:

```SQL
SELECT A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) AS ANO,C.CANTIDAD FROM tabla_de_productos A INNER JOIN items_facturas C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas B ON C.NUMERO = B.NUMERO;
```

6. Una vez más, el plan de ejecución es el siguiente:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/10.png)

7. El color rojo indica que no encontró un índice, entonces tuvo que hacer un scan a toda la tabla; en cambio, el color verde indica que sí encontró un índice, y el mismo, facilitó la búsqueda al interior de la tabla, reduciendo el costo de procesamiento. En este caso, el índice fue creado al momento de establecer claves primarias y foráneas en las respectivas tablas.

8. Ahora, vamos a recrear las tablas sin ningún tipo de índice, ni claves primarias, ni claves externas. También, almacenaremos los registros correspondientes en las nuevas tablas que crearemos. Digita y ejecuta:

```SQL
CREATE TABLE `facturas1` (
  `DNI` varchar(11) NOT NULL,
  `MATRICULA` varchar(5) NOT NULL,
  `FECHA_VENTA` date DEFAULT NULL,
  `NUMERO` int NOT NULL,
  `IMPUESTO` float NOT NULL  
);

CREATE TABLE `items_facturas1` (
  `NUMERO` int NOT NULL,
  `CODIGO_DEL_PRODUCTO` varchar(10) NOT NULL,
  `CANTIDAD` int NOT NULL,
  `PRECIO` float NOT NULL
);

CREATE TABLE `tabla_de_productos1` (
  `CODIGO_DEL_PRODUCTO` varchar(10) NOT NULL,
  `NOMBRE_DEL_PRODUCTO` varchar(50) DEFAULT NULL,
  `TAMANO` varchar(10) DEFAULT NULL,
  `SABOR` varchar(20) DEFAULT NULL,
  `ENVASE` varchar(20) DEFAULT NULL,
  `PRECIO_DE_LISTA` float NOT NULL
) ;

INSERT INTO facturas1
SELECT * FROM facturas;

INSERT INTO items_facturas1
SELECT * FROM items_facturas;

INSERT INTO tabla_de_productos1
SELECT * FROM tabla_de_productos;
```

9. Observemos el plan de ejecución de la query más compleja de las que hemos trabajado hasta el momento aplicado a las tablas que creamos en el paso anterior. Para ello, digita y ejecuta:

```SQL
SELECT A.CODIGO_DEL_PRODUCTO, YEAR(B.FECHA_VENTA) AS ANO,C.CANTIDAD FROM tabla_de_productos1 A INNER JOIN items_facturas1 C ON A.CODIGO_DEL_PRODUCTO = C.CODIGO_DEL_PRODUCTO INNER JOIN facturas1 B ON C.NUMERO = B.NUMERO;
```

10. El plan de ejecución de workbench muestra lo siguiente:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/11.png)

Todos los rectángulos aparecen en rojo, el costo de procesamiento fue el más alto posible debido a que las búsquedas se realizaron sin la ayuda de índices.

11. Vamos ahora a trabajar con la herramienta mysqlslap. Esta, simula accesos concurrentes a una consulta. Desde el símbolo del sistema de Windows, vamos a ejecutar los siguientes comandos para acceder nuevamente a mysql:

```cmd
cd\
cd "Program Files"
cd "MySQL"
cd "MySQL Server 8.0"
cd Bin
```

12. Al estar dentro del directorio `bin/`, digita y ejecuta:

```cmd
mysqlslap -uroot -p --concurrency=100 --iterations=10 --create-schema=jugos_ventas --query="SELECT * FROM facturas WHERE FECHA_VENTA = '20170101'";
```

13. Observarás un output semejante al siguiente:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/12.png)

Este es el promedio de tiempo que van a demorar 100 usuarios diferentes para obtener el resultado de la misma consulta al ejecutarla al mismo tiempo.

14. Si efectuamos la simulación anterior utilizando como referencia la tabla que creamos sin claves primarias ni foráneas, notaremos un cambio en los tiempos de procesamiento. Digita y ejecuta:

```cmd
mysqlslap -uroot -p --concurrency=100 --iterations=10 --create-schema=jugos_ventas --query="SELECT * FROM facturas1 WHERE FECHA_VENTA = '20170101'";
```

Y el output será, respectivamente:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/13.png)

¿Qué puedes concluir con estos resultados?

### Lo que aprendimos

Lo que aprendimos en esta aula:

- Cómo el índice mejora el plan de ejecución.
- Que las claves primarias y foráneas crean índices y ayudan a mejorar el plan de ejecución.
- A usar la herramienta **mysqlslap** para simular conexiones.

### Proyecto del aula anterior

¿Comenzando en esta etapa? Aquí puedes descargar los archivos del proyecto que hemos avanzado hasta el aula anterior.

[Descargue los archivos en Github](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/tree/aula-4 "Descargue los archivos en Github") o haga clic [aquí](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/archive/refs/heads/aula-4.zip "aquí") para descargarlos directamente.

### Haga lo que hicimos en aula

Llegó la hora de que sigas todos los pasos realizados por mí durante esta clase. Si ya lo has hecho ¡Excelente! Si todavía no lo has hecho, es importante que ejecutes lo que fue visto en los vídeos para que puedas continuar con la próxima aula.

1. Cuando instalaste MySQL, fue creado un usuario root, con privilegios de administrador. Sin embargo, normalmente, este usuario se elimina y se sustituye por un administrador real.

2. En Workbench, en el área **Navigator** haz clic en la pestaña **Administration**:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/14.png)

3. Haz clic en Users and Privileges:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/15.png)

4. Encontrarás una nueva ventana, y, en el lado izquierdo de la misma, tendrás la lista de usuarios de ambiente. Allí se encuentra el usuario **root**.

5.  Haz clic sobre el botón **Add Account**:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/16.png)

6. En la caja de diálogo, en la pestaña Login, rellena los campos **Login Name, Limit to Hosts Matching, Password** y confirma la contraseña como se muestra a continuación (Para mayor practicidad, puedes usar como contraseña el mismo nombre de usuario):

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/17.png)

7. En la pestaña Administrative Roles, escoge los privilegios que este usuario tendrá en MySQL. Selecciona DBA; así, todos los privilegios serán otorgados:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/18.png)

8. Haz clic en **Apply**. De esta manera, el usuario será creado.

9. Podemos ahora cerrar la pestaña de la conexión actual en Workbench.

10. En la pantalla de conexiones, crea una nueva conexión (haciendo clic sobre el botón `+`), con el usuario creado en los pasos anteriores:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/19.png)
![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/20.png)

11. Haz clic en **Test Connection** y guarda la conexión.

12. Accede a Workbench con el usuario **admin01**.

13. De igual manera, podemos crear usuarios a través de líneas de comando en SQL. Para crear otro usuario administrador (que llamaremos** admin02**). Digita y ejecuta:

```cmd
CREATE USER 'admin02'@'localhost' IDENTIFIED BY 'admin02';
GRANT ALL PRIVILEGES ON *.* TO 'admin02'@'localhost' WITH GRANT OPTION;
```

14. Para eliminar el usuario **root**, desde un script en la conexión **Local Instance admin01** digita y ejecuta:

```cmd
DROP USER 'root'@'localhost';
```

15. Si intentas conectarte al servidor a través del usuario root no será posible porque este usuario ya no existe.

16. Lo que determina lo que un usuario podrá hacer o no, son sus parámetros, tanto en la caja de diálogo de Workbench como a través de comandos SQL.

17. Ahora, crearemos un usuario llamado **user01**, usando la pestaña **Administration** y la opción **Users and Privileges**. Este usuario tendrá los siguientes privilegios: CREATE TEMPORARY TABLES, DELETE, EXECUTE, INSERT, LOCK TABLES, SELECT y UPDATE:

![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/21.png)
![](https://caelum-online-public.s3.amazonaws.com/ESP-1839-Administraci%C3%B3n+de+MySQL+Seguridad+y+optmizaci%C3%B3n+de+la+base+de+datos+-+Parte+2/22.png)

18. haz clic en Apply.

19. Crea otro usuario normal, pero en esta ocasión será via comandos SQL. Digita y ejecuta:

```SQL
CREATE USER 'user02'@'localhost' IDENTIFIED BY 'user02';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE TEMPORARY TABLES,
LOCK TABLES, EXECUTE ON *.* TO 'user02'@'localhost';
```

20. Adicionalmente, crea un usuario solamente para lectura, con login **read01**, a través de la caja de diálogo y otro, **read02**, via SQL. Para estos usuarios, los privilegios serán SELECT y EXECUTE. Los comandos que emplearás son los siguientes:

```SQL
CREATE USER 'read02'@'localhost' identified BY 'read02';
GRANT SELECT, EXECUTE ON *.* TO 'read02'@'localhost';
```

21. Finalmente, crea dos usuarios más para hacer copias de seguridad, con los logins back01 y back02. Aquí, estos usuarios solamente pueden hacer backups:

```SQL
CREATE USER 'back02'@'localhost' IDENTIFIED BY 'back02';
GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT ON 
*.* TO 'back02'@'localhost' 
```

### Lo que aprendimos

Lo que aprendimos en esta aula:

- A crear usuarios administradores y a remover el usuario **root**.
- Cómo crear un usuario con privilegios para acceso normal (sin ser administrador).
- Cómo crear un usuario que solo tiene acceso de lectura a los datos.
- Cómo crear un usuario que solamente ejecuta backups.
- A crear los usuarios a través de cajas de diálogo de Workbench y a través de líneas de comando.

### Proyecto del aula anterior

¿Comenzando en esta etapa? Aquí puedes descargar los archivos del proyecto que hemos avanzado hasta el aula anterior.

[Descargue los archivos en Github](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/tree/aula-5 "Descargue los archivos en Github") o haga clic [aquí](https://github.com/alura-es-cursos/1839-administracion-de-mysql-parte-2/archive/refs/heads/aula-5.zip "aquí") para descargarlos directamente.

