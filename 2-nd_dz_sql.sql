-- 11.Найдите среднюю скорость ПК.

SELECT
    AVG(speed) AS Avg_speed
FROM
    PC

-- 12.Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

SELECT
    avg(speed) as Средняя_скорость
FROM
    laptop
WHERE
    price > 1000

--13.Найдите среднюю скорость ПК, выпущенных производителем A.

SELECT
    avg(speed) as Средняя_скорость
FROM
    product p
    join pc on p.model = pc.model
WHERE
    maker = 'A'

--14.Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

SELECT
    s.class,
    s.name,
    country
FROM
    ships s
    JOIN classes c ON s.class = c.class
WHERE
    numGuns >= 10

--15.Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

SELECT
    hd
FROM
    pc
group by
    hd
having
    count(model) >= 2

--16.Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

SELECT
    DISTINCT pc1.model,
    pc2.model,
    pc1.speed,
    pc1.ram
FROM
    pc AS pc1,
    pc AS pc2
WHERE
    pc1.model > pc2.model
    AND pc1.speed = pc2.speed
    AND pc1.ram = pc2.ram

--17.Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed.

SELECT
    DISTINCT product.type,
    laptop.model,
    laptop.speed
FROM
    laptop,
    product
WHERE
    speed < (
        SELECT
            MIN(speed)
        FROM
            pc
    )
    AND product.type = 'Laptop'

--18.Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price.

SELECT
    DISTINCT maker,
    price
FROM
    product p
    JOIN printer pr ON p.model = pr.model
WHERE
    price = (
        SELECT
            min(price)
        FROM
            printer
        WHERE
            color = 'y'
    )
    AND color = 'y'

--19.Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. Вывести: maker, средний размер экрана.

SELECT
    maker,
    avg(screen) as Средний_размер
FROM
    product p
    join laptop l on p.model = l.model
group by
    maker

--20.Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

SELECT
    maker,
    count(model) as Число_моделей_ПК
FROM
    product
WHERE
    type = 'pc'
group by
    maker
having
    count(model) >= 3