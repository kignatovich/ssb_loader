#!/bin/bash

# Задержка, чтобы ClickHouse сервер успел запуститься
sleep 10

# Переходим в директорию генерации данных
cd /opt/ssb-dbgen

# Генерируем данные с масштабным фактором 1000
./dbgen -s 1000 -T c
./dbgen -s 1000 -T l
./dbgen -s 1000 -T p
./dbgen -s 1000 -T s
./dbgen -s 1000 -T d

# Вот тут нужно поиграться с логином паролем
# Создаем таблицы в ClickHouse
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --multiquery < /docker-entrypoint-initdb.d/create_tables.sql

# Загружаем данные 
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO customer FORMAT CSV" < customer.tbl
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO part FORMAT CSV" < part.tbl
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO supplier FORMAT CSV" < supplier.tbl
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO lineorder FORMAT CSV" < lineorder.tbl
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO date FORMAT CSV" < date.tbl
