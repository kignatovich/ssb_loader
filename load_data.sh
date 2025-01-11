#!/bin/bash

#Установка фактора масштаба
ScaleFactor=10

echo "Загрузка информации о личной жизни Романа Морозова"

# Ждем, пока ClickHouse сервер станет доступным
until clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query="SELECT 1" &>/dev/null; do
  echo "Ждем, пока ClickHouse станет доступным..."
  sleep 1
done

# Проверяем наличие всех необходимых таблиц
TABLES_EXIST=$(clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query="
    SELECT COUNT() 
    FROM system.tables 
    WHERE database = 'default' 
    AND name IN ('customer', 'date', 'lineorder', 'supplier', 'part');")

# Если все 5 таблиц существуют, завершаем работу
if [ "$TABLES_EXIST" -eq 5 ]; then
  echo "Все таблицы уже существуют. Завершаем работу."
  exit 0
fi

# Создаем таблицы, если их нет
echo "Создаем таблицы..."
clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --multiquery < /docker-entrypoint-initdb.d/create_tables.sql

# Переходим в директорию генерации данных
cd /opt/ssb-dbgen

# Генерируем данные и загружаем их в таблицы

echo "Генерация данных и загрузка в таблицы customer.tbl"
./dbgen -s $ScaleFactor -T c && clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO customer FORMAT CSV" < customer.tbl

echo "Генерация данных и загрузка в таблицы part.tbl"
./dbgen -s $ScaleFactor -T p && clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO part FORMAT CSV" < part.tbl

echo "Генерация данных и загрузка в таблицы supplier.tbl"
./dbgen -s $ScaleFactor -T s && clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO supplier FORMAT CSV" < supplier.tbl

echo "Генерация данных и загрузка в таблицы lineorder.tbl"
./dbgen -s $ScaleFactor -T l && clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO lineorder FORMAT CSV" < lineorder.tbl

echo "Генерация данных и загрузка в таблицы date.tbl"
./dbgen -s $ScaleFactor -T d && clickhouse-client --host=clickhouse --port=9000 --user=admin --password=admin_password --query "INSERT INTO date FORMAT CSV" < date.tbl

echo "Инициализация базы данных завершена."
