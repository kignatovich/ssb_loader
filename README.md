# ssb_loader

для того чтобы просмотреть все базы данных в ClickHouse через консоль, используем команду:

```
SHOW DATABASES;
```
эта команда выведет список всех баз данных, доступных в экземпляре ClickHouse.

чтобы переключиться на конкретную базу данных, используем команду USE:

```
USE default;
```
если вы хотим увидеть таблицы в текущей базе данных, используем команду:

```
SHOW TABLES;
```

это отобразит список всех таблиц в выбранной базе данных.

для того чтобы посмотреть данные в таблице используем команду SELECT. например, чтобы увидеть все данные в таблице customer, выполним:

```
SELECT * FROM customer;
```

эта команда отобразит все строки из таблицы customer.

```
SELECT COUNT(*) FROM customer;
```

эта команда посчитает количество строк в таблице customer.
