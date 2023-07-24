--1. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. Вывести: maker, максимальная цена.
select
    maker,
    max(price) as Max_price
from
    product p
    join pc on p.model = pc.model
group by
    maker 
--2. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.
select
    speed,
    avg(price) as Средняя_цена
from
    pc
group by
    speed
having
    speed > 600
--3. Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker
select
    maker
from
    product p
    join pc on p.model = pc.model
where
    pc.speed >= 750
intersect
select
    maker
from
    product p
    join laptop l on p.model = l.model
where
    l.speed >= 750 
--4. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции
    with all_models as (
        select
            model,
            price
        from
            pc
        union
        select
            model,
            price
        from
            laptop
        union
        select
            model,
            price
        from
            printer
    )
select
    model
from
    all_models
where
    price = (
        select
            max(price)
        from
            all_models
    ) 
--5. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
SELECT
    DISTINCT maker
FROM
    product
WHERE
    maker IN (
        SELECT
            p.maker
        FROM
            product as p
            INNER JOIN pc as pc ON p.model = pc.model
        WHERE
            ram =(
                SELECT
                    MIN(ram)
                FROM
                    pc
            )
            AND pc.speed =(
                SELECT
                    MAX(speed)
                FROM
                    pc
                WHERE
                    speed IN (
                        SELECT
                            speed
                        FROM
                            pc
                        WHERE
                            ram =(
                                SELECT
                                    MIN(ram)
                                FROM
                                    pc
                            )
                    )
            )
    )
    AND type = 'printer' 
--6. Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
    with средняя_цена as (
        select
            maker,
            price
        from
            product p
            join pc on p.model = pc.model
        where
            maker = 'A'
        union
        all
        select
            maker,
            price
        from
            product p
            join laptop l on p.model = l.model
        where
            maker = 'A'
    )
select
    avg(price) as Средняя_цена
from
    средняя_цена
group by
    maker 
--7. Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
select
    distinct maker,
    avg(hd) as Avg_hd
from
    product p
    join pc on p.model = pc.model
group by
    maker
having
    maker in(
        select
            maker
        from
            product
        where
            type = 'Printer'
    ) 
--8. Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
select
    count(maker)
from
    product
where
    maker in (
        Select
            maker
        from
            product
        group by
            maker
        having
            count(model) = 1
    ) 
--9. В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
select
    t1.point,
    t1.date,
    inc,
    out
from
    income_o t1
    left join outcome_o t2 ON t1.point = t2.point
    and t1.date = t2.date
union
select
    t2.point,
    t2.date,
    inc,
    out
from
    income_o t1
    right join outcome_o t2 ON t1.point = t2.point
    and t1.date = t2.date 
--10. В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка. Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).
select
    point,
    date,
    SUM(sum_out),
    SUM(sum_inc)
from
    (
        select
            point,
            date,
            SUM(inc) as sum_inc,
            null as sum_out
        from
            Income
        Group by
            point,
            date
        Union
        select
            point,
            date,
            null as sum_inc,
            SUM(out) as sum_out
        from
            Outcome
        Group by
            point,
            date
    ) as t
group by
    point,
    date
order by
    point