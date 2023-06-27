-- 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT
    pc.model,
    pc.speed,
    pc.hd
FROM
    pc
WHERE
    pc.price < 500 

-- 2. Найдите производителей принтеров. Вывести: maker
SELECT
    DISTINCT maker
FROM
    Product p
WHERE
    p.type = 'Printer' 

-- 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT
    model,
    ram,
    screen
FROM
    Laptop l
WHERE
    l.price > 1000
ORDER BY
    model

-- 4. Найдите все записи таблицы Printer для цветных принтеров.
SELECT
    *
FROM
    Printer p
WHERE
    p.color = 'y'

-- 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT
    model,
    speed,
    hd
FROM
    PC
WHERE
    PC.cd in('12x', '24x')
    and PC.price < 600

-- 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
SELECT
    DISTINCT p.maker,
    l.speed
FROM
    Product p
    LEFT JOIN Laptop l on l.model = p.model
WHERE
    l.hd >= 10
ORDER BY
    l.speed

-- 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT
    p.model,
    pc.price
FROM
    Product p
    JOIN pc on p.model = pc.model
WHERE
    p.maker LIKE 'B'
UNION
SELECT
    DISTINCT p.model,
    l.price
FROM
    Product p
    JOIN laptop l on p.model = l.model
WHERE
    p.maker LIKE 'B'
UNION
SELECT
    DISTINCT p.model,
    pr.price
FROM
    Product p
    JOIN printer pr on p.model = pr.model
WHERE
    p.maker LIKE 'B'

-- 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT
    maker
FROM
    Product
WHERE
    type = 'PC'
EXCEPT
SELECT
    maker
FROM
    Product
WHERE
    type = 'Laptop'

-- 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT
    DISTINCT maker
FROM
    product p
    INNER JOIN PC ON p.model = PC.model
WHERE
    PC.speed >= 450

-- 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price   
SELECT
    model,
    price
FROM
    printer
WHERE
    price = (
        SELECT
            MAX(price)
        FROM
            printer
    )
