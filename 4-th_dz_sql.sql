--1. Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
select
    c.class,
    c.country
from
    classes c
where
    c.bore >= 16

--2. Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
select
    o.ship
from
    outcomes o
where
    o.battle = 'North Atlantic'
    and o.result = 'sunk'

--4. По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
select
    s.name
from
    ships s
    right join classes c on s.class = c.class
where
    launched is not null
    and launched >= 1922
    and displacement > 35000
    and type = 'bb'

--5. В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра). Вывод: номер модели, тип модели. 
select
    model,
    type
from
    product
where
    model not like '%[^A-Z]%'
    or model not like '%[^0-9]%'

--6. Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
select
    name
from
    Ships s
where
    name = class
Union
select
    ship as name
from
    Outcomes o
    join Classes c on o.ship = c.class

--7. Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
select
    c.class
from
    classes c
    left join (
        select
            class,
            name
        from
            ships
        union
        select
            classes.class as class,
            outcomes.ship as name
        from
            outcomes
            join classes on outcomes.ship = classes.class
    ) as s on c.class = s.class
group by
    c.class
having
    count(name) = 1

--8. Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').

select
    country
from
    classes
where
    type = 'bb'
intersect
select
    country
from
    classes
where
    type = 'bc'

--9. Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.

with b as(
    select
        *
    from
        outcomes o
        join battles b on o.battle = b.name
)
select
    distinct b1.ship
from
    b b1
where
    b1.result = 'damaged'
    and exists(
        select
            b2.ship
        from
            b b2
        where
            b2.date > b1.date
            and b1.ship = b2.ship
    )
--10. Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа. Вывести: maker, type
select
    maker,
    type
from
    Product
where
    maker in (
        select
            maker
        from
            (
                select
                    maker,
                    type
                from
                    Product
                group by
                    maker,
                    type
            ) as x
        group by
            maker
        having
            count(*) = 1
    )
group by
    maker,
    type
having
    count(*) > 1