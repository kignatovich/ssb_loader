#!/bin/bash

# Задержка, чтобы ClickHouse сервер успел запуститься
sleep 60

# Переходим в директорию генерации данных
cd /opt/ssb-dbgen

# Генерируем данные с масштабным фактором 1000
./dbgen -s 1000 -T c
./dbgen -s 1000 -T l
./dbgen -s 1000 -T p
./dbgen -s 1000 -T s
./dbgen -s 1000 -T d

# Создаем таблицы в ClickHouse
clickhouse-client --multiquery < /docker-entrypoint-initdb.d/create_tables.sql

# Загружаем данные в ClickHouse
clickhouse-client --query "INSERT INTO customer FORMAT CSV" < customer.tbl
clickhouse-client --query "INSERT INTO part FORMAT CSV" < part.tbl
clickhouse-client --query "INSERT INTO supplier FORMAT CSV" < supplier.tbl
clickhouse-client --query "INSERT INTO lineorder FORMAT CSV" < lineorder.tbl
clickhouse-client --query "INSERT INTO date FORMAT CSV" < date.tbl
