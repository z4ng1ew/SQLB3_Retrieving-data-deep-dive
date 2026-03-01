  select person.name
  from person inner join person_order po on person.id = po.person_id
  inner join menu m on m.id = po.menu_id
  where gender= 'male' and pizza_name in ('pepperoni pizza','mushroom pizza')
  and  address  in ('Moscow', 'Samara')
  order by 1 desc





-- ============================================================================
-- Задание 08: Найти мужчин из Москвы/Самары, заказывавших пепперони или грибную пиццу
-- Показывает имена мужчин, которые живут в Москве или Самаре и заказывали
-- пиццу с пепперони, грибами или оба вида
-- ============================================================================

-- ВЫБИРАЕМ только имя человека
SELECT person.name                      -- имя из таблицы person
--     ^^^^^^^^^^^
--     можно без префикса, т.к. только в person есть колонка name

-- ГЛАВНАЯ ТАБЛИЦА: person (информация о людях)
FROM person

-- ПЕРВЫЙ JOIN: связываем людей с заказами
INNER JOIN person_order po              -- присоединяем таблицу заказов (псевдоним po)
    ON person.id = po.person_id         -- условие: id человека = person_id в заказе
--     ^^^^^^^^^    ^^^^^^^^^^^^^^
--     кто          кто заказал

-- ВТОРОЙ JOIN: связываем заказы с меню
INNER JOIN menu m                       -- присоединяем таблицу menu (псевдоним m)
    ON m.id = po.menu_id                -- условие: id пиццы в меню = menu_id в заказе
--     ^^^^    ^^^^^^^^^^^^
--     что      что заказали

-- ФИЛЬТРАЦИЯ: три условия через AND (все должны выполняться)
WHERE gender = 'male'                   -- только мужчины
--    ^^^^^^^^^^^^^^
--    колонка gender из таблицы person

  AND pizza_name IN ('pepperoni pizza', 'mushroom pizza')
--    ^^^^^^^^^^ ^^
--    |          └─ оператор IN = "входит в список"
--    └──────────── колонка pizza_name из таблицы menu
--    только пепперони ИЛИ грибная (один из видов или оба)

  AND address IN ('Moscow', 'Samara')
--    ^^^^^^^ ^^
--    |       └─ только два города
--    └───────── колонка address из таблицы person

-- СОРТИРОВКА: по имени в ОБРАТНОМ алфавитном порядке (Z→A)
ORDER BY 1 DESC;
--       ^ ^^^^
--       | └──── DESC = descending (по убыванию)
--       └────── 1 = первая колонка (name)

-- ============================================================================
-- ЦЕПОЧКА СВЯЗЕЙ:
-- person → person_order (узнаём, ЧТО заказал человек)
--        → menu (узнаём НАЗВАНИЕ пиццы)
--
-- ЛОГИКА РАБОТЫ:
-- 1. Берём всех людей из таблицы person
-- 2. Через person_order находим их заказы
-- 3. Через menu узнаём названия пицц
-- 4. Фильтруем:
--    - только мужчины (gender = 'male')
--    - только из Москвы или Самары
--    - только заказы пепперони или грибной пиццы
-- 5. Сортируем по имени в обратном порядке (от Я до А)
--
-- ВАЖНО: Если человек заказал ОБА вида пиццы, он может появиться
-- в результате дважды (по одному разу для каждого заказа)


---

## 🎤 Объяснение для УСТНОЙ защиты

### **Задача:**

**"Найти имена всех мужчин из Москвы или Самары, которые заказывали пепперони или грибную пиццу (или оба вида)"**

---

### **Блок 1: Зачем 2 JOIN?**

```sql
FROM person
INNER JOIN person_order po ...
INNER JOIN menu m ...
```

**Говоришь:**
"Мне нужно соединить **3 таблицы**:

1. **person** — содержит информацию о людях (пол, адрес, имя)
2. **person_order** — журнал заказов (кто и что заказал)
3. **menu** — меню с названиями пицц

В таблице `person_order` есть только ID пиццы (`menu_id`), но нет названия. Через JOIN с `menu` я получаю `pizza_name` для фильтрации."

---

### **Блок 2: Первый JOIN (person → person_order)**

```sql
FROM person
INNER JOIN person_order po ON person.id = po.person_id
```

**Говоришь:**
"Первый JOIN соединяет людей с их заказами. Условие `person.id = po.person_id` связывает каждого человека с его заказами. Это позволяет узнать, **что** каждый человек заказывал."

**Что получаем:**
```
person + person_order → узнаём, ЧТО заказал каждый человек
```

---

### **Блок 3: Второй JOIN (person_order → menu)**

```sql
INNER JOIN menu m ON m.id = po.menu_id
```

**Говоришь:**
"Второй JOIN добавляет информацию о пицце. В `person_order` есть `menu_id` (номер пиццы), но нет названия. Через JOIN с `menu` я получаю `pizza_name` — название пиццы, чтобы отфильтровать нужные виды."

**Что получаем:**
```
person_order + menu → узнаём НАЗВАНИЕ пиццы
```

---

### **Блок 4: WHERE фильтр (3 условия)**

```sql
WHERE gender = 'male' 
  AND pizza_name IN ('pepperoni pizza', 'mushroom pizza')
  AND address IN ('Moscow', 'Samara')
```

**Говоришь:**
"Фильтрую результат **тремя условиями** через AND:

1. **`gender = 'male'`** — только мужчины (из таблицы `person`)
2. **`pizza_name IN (...)`** — только пепперони или грибная пицца (из `menu`)
3. **`address IN (...)`** — только из Москвы или Самары (из `person`)

Все три условия должны выполняться **одновременно**. Если человек мужчина, но из Казани — не подходит. Если из Москвы, но заказал сырную пиццу — не подходит."

---

### **Блок 5: ORDER BY DESC**

```sql
ORDER BY 1 DESC
```

**Говоришь:**
"Сортирую по имени в **обратном алфавитном порядке** (от Я до А). `DESC` означает descending — по убыванию. Без `DESC` была бы сортировка от А до Я."

**Примеры:**
```
С DESC:    Dmitriy, Andrey
Без DESC:  Andrey, Dmitriy
```

---

## 📊 Пошаговая визуализация

### **Исходные данные:**

```
person:
┌────┬─────────┬─────┬────────┬───────────────────┐
│ id │ name    │ age │ gender │ address           │
├────┼─────────┼─────┼────────┼───────────────────┤
│ 1  │ Anna    │ 16  │ female │ Moscow            │
│ 2  │ Andrey  │ 21  │ male   │ Moscow            │ ← мужчина из Москвы ✓
│ 3  │ Kate    │ 33  │ female │ Kazan             │
│ 4  │ Denis   │ 13  │ male   │ Kazan             │ ← мужчина, но не из Москвы/Самары
│ 7  │ Peter   │ 24  │ male   │ Saint-Petersburg  │
│ 9  │ Dmitriy │ 18  │ male   │ Samara            │ ← мужчина из Самары ✓
│ ...│ ...     │ ... │ ...    │ ...               │
└────┴─────────┴─────┴────────┴───────────────────┘

person_order:
┌────┬───────────┬─────────┬────────────┐
│ id │ person_id │ menu_id │ order_date │
├────┼───────────┼─────────┼────────────┤
│ 3  │ 2 (Andrey)│ 8       │ 2022-01-01 │
│ 4  │ 2 (Andrey)│ 9       │ 2022-01-01 │
│ 19 │ 9 (Dmitriy)│ 18     │ 2022-01-09 │
│ 20 │ 9 (Dmitriy)│ 6      │ 2022-01-10 │
│ ...│ ...       │ ...     │ ...        │
└────┴───────────┴─────────┴────────────┘

menu:
┌────┬─────────────┬────────────────┬───────┐
│ id │ pizzeria_id │ pizza_name     │ price │
├────┼─────────────┼────────────────┼───────┤
│ 6  │ 6           │ pepperoni pizza│ 800   │
│ 8  │ 2           │ cheese pizza   │ 800   │
│ 9  │ 2           │ mushroom pizza │ 1100  │
│ 18 │ 5           │ supreme pizza  │ 850   │
│ ...│ ...         │ ...            │ ...   │
└────┴─────────────┴────────────────┴───────┘
```

---

### **Шаг 1: FROM person**

```
Все люди:
┌────┬─────────┬────────┬──────────────────┐
│ id │ name    │ gender │ address          │
├────┼─────────┼────────┼──────────────────┤
│ 1  │ Anna    │ female │ Moscow           │
│ 2  │ Andrey  │ male   │ Moscow           │
│ 3  │ Kate    │ female │ Kazan            │
│ 4  │ Denis   │ male   │ Kazan            │
│ 7  │ Peter   │ male   │ Saint-Petersburg │
│ 9  │ Dmitriy │ male   │ Samara           │
│ ...│ ...     │ ...    │ ...              │
└────┴─────────┴────────┴──────────────────┘
```

---

### **Шаг 2: INNER JOIN person_order**

```sql
INNER JOIN person_order po ON person.id = po.person_id
```

**Процесс:**

```
Andrey (id=2):
  ↓
  Ищем в person_order где person_id = 2
  ↓
  Находим: заказы #3 (menu_id=8) и #4 (menu_id=9)
  ↓
  Результат: две строки для Andrey

Dmitriy (id=9):
  ↓
  Ищем в person_order где person_id = 9
  ↓
  Находим: заказы #19 (menu_id=18) и #20 (menu_id=6)
  ↓
  Результат: две строки для Dmitriy
```

**Результат после 1-го JOIN:**

```
┌────┬─────────┬────────┬──────────────────┬─────────┐
│ id │ name    │ gender │ address          │ menu_id │
├────┼─────────┼────────┼──────────────────┼─────────┤
│ 1  │ Anna    │ female │ Moscow           │ 1       │
│ 1  │ Anna    │ female │ Moscow           │ 2       │
│ 2  │ Andrey  │ male   │ Moscow           │ 8       │ ← теперь знаем заказы!
│ 2  │ Andrey  │ male   │ Moscow           │ 9       │
│ 9  │ Dmitriy │ male   │ Samara           │ 18      │ ← теперь знаем заказы!
│ 9  │ Dmitriy │ male   │ Samara           │ 6       │
│ ...│ ...     │ ...    │ ...              │ ...     │
└────┴─────────┴────────┴──────────────────┴─────────┘
```

---

### **Шаг 3: INNER JOIN menu**

```sql
INNER JOIN menu m ON m.id = po.menu_id
```

**Процесс:**

```
Andrey, заказ menu_id=8:
  ↓
  Ищем в menu где id = 8
  ↓
  Находим: cheese pizza
  ↓
  Результат: Andrey + cheese pizza

Andrey, заказ menu_id=9:
  ↓
  Ищем в menu где id = 9
  ↓
  Находим: mushroom pizza
  ↓
  Результат: Andrey + mushroom pizza ✓

Dmitriy, заказ menu_id=18:
  ↓
  Ищем в menu где id = 18
  ↓
  Находим: supreme pizza
  ↓
  Результат: Dmitriy + supreme pizza

Dmitriy, заказ menu_id=6:
  ↓
  Ищем в menu где id = 6
  ↓
  Находим: pepperoni pizza
  ↓
  Результат: Dmitriy + pepperoni pizza ✓
```

**Результат после 2-го JOIN:**

```
┌────┬─────────┬────────┬──────────────────┬────────────────┐
│ id │ name    │ gender │ address          │ pizza_name     │
├────┼─────────┼────────┼──────────────────┼────────────────┤
│ 1  │ Anna    │ female │ Moscow           │ cheese pizza   │
│ 1  │ Anna    │ female │ Moscow           │ pepperoni pizza│
│ 2  │ Andrey  │ male   │ Moscow           │ cheese pizza   │
│ 2  │ Andrey  │ male   │ Moscow           │ mushroom pizza │ ← знаем название!
│ 9  │ Dmitriy │ male   │ Samara           │ supreme pizza  │
│ 9  │ Dmitriy │ male   │ Samara           │ pepperoni pizza│ ← знаем название!
│ ...│ ...     │ ...    │ ...              │ ...            │
└────┴─────────┴────────┴──────────────────┴────────────────┘
```

---

### **Шаг 4: WHERE фильтрует (3 условия)**

```sql
WHERE gender = 'male' 
  AND pizza_name IN ('pepperoni pizza', 'mushroom pizza')
  AND address IN ('Moscow', 'Samara')
```

**Проверка каждой строки:**

```
Anna, cheese pizza:
  gender = 'male'?  'female' = 'male'? ❌ НЕТ → убираем
  
Anna, pepperoni pizza:
  gender = 'male'?  'female' = 'male'? ❌ НЕТ → убираем

Andrey, cheese pizza:
  gender = 'male'?        'male' = 'male'? ✅ ДА
  pizza_name IN (...)?    'cheese pizza' IN (...) ❌ НЕТ → убираем
  
Andrey, mushroom pizza:
  gender = 'male'?        'male' = 'male'? ✅ ДА
  pizza_name IN (...)?    'mushroom pizza' IN (...) ✅ ДА
  address IN (...)?       'Moscow' IN ('Moscow', 'Samara') ✅ ДА
  → ✅ ✅ ✅ = ПОДХОДИТ!

Dmitriy, supreme pizza:
  gender = 'male'?        'male' = 'male'? ✅ ДА
  pizza_name IN (...)?    'supreme pizza' IN (...) ❌ НЕТ → убираем
  
Dmitriy, pepperoni pizza:
  gender = 'male'?        'male' = 'male'? ✅ ДА
  pizza_name IN (...)?    'pepperoni pizza' IN (...) ✅ ДА
  address IN (...)?       'Samara' IN ('Moscow', 'Samara') ✅ ДА
  → ✅ ✅ ✅ = ПОДХОДИТ!
```

**Результат после WHERE:**

```
┌─────────┬────────┬─────────┬────────────────┐
│ name    │ gender │ address │ pizza_name     │
├─────────┼────────┼─────────┼────────────────┤
│ Andrey  │ male   │ Moscow  │ mushroom pizza │ ← подходит!
│ Dmitriy │ male   │ Samara  │ pepperoni pizza│ ← подходит!
└─────────┴────────┴─────────┴────────────────┘
```

---

### **Шаг 5: SELECT выбирает только имя**

```sql
SELECT person.name
```

**Убираем лишние колонки:**

```
┌─────────┐
│ name    │
├─────────┤
│ Andrey  │
│ Dmitriy │
└─────────┘
```

---

### **Шаг 6: ORDER BY 1 DESC**

```sql
ORDER BY 1 DESC
```

**Сортировка в обратном порядке:**

```
Было:          После DESC:
Andrey    →    Dmitriy      (D > A, поэтому Dmitriy первый)
Dmitriy        Andrey
```

**Финальный результат:**

```
┌─────────┐
│ name    │
├─────────┤
│ Dmitriy │  ← 'D' идёт первым в DESC
│ Andrey  │  ← 'A' идёт вторым в DESC
└─────────┘
```

✅ **Готово!**

---

## 🎯 Схема связей

```
person
│ gender = 'male' ✓
│ address IN ('Moscow', 'Samara') ✓
↓
person_order (заказы этого человека)
↓
menu
│ pizza_name IN ('pepperoni pizza', 'mushroom pizza') ✓

Andrey:  male + Moscow ✓ + mushroom pizza ✓ → ПОДХОДИТ
Dmitriy: male + Samara ✓ + pepperoni pizza ✓ → ПОДХОДИТ
Denis:   male + Kazan ✗ → НЕ ПОДХОДИТ (неправильный город)
```

---

## 💡 Операторы IN

### **`pizza_name IN ('pepperoni pizza', 'mushroom pizza')`**

**Означает:** "pizza_name РАВЕН 'pepperoni pizza' **ИЛИ** 'mushroom pizza'"

**Эквивалент:**

```sql
-- С IN (короче):
pizza_name IN ('pepperoni pizza', 'mushroom pizza')

-- Без IN (длиннее):
pizza_name = 'pepperoni pizza' OR pizza_name = 'mushroom pizza'
```

---

### **`address IN ('Moscow', 'Samara')`**

**Означает:** "адрес — это Москва **ИЛИ** Самара"

**Важно:** Внутри одного IN работает **ИЛИ**, но между разными условиями — **И** (AND).

---

## 🔍 Логика условий

```sql
WHERE gender = 'male'                               -- условие 1
  AND pizza_name IN ('pepperoni pizza', 'mushroom pizza')  -- условие 2 (ИЛИ внутри)
  AND address IN ('Moscow', 'Samara')               -- условие 3 (ИЛИ внутри)
```

**Таблица истинности:**

| Условие 1 | Условие 2 | Условие 3 | Результат |
|-----------|-----------|-----------|-----------|
| ✅ male | ✅ mushroom | ✅ Moscow | ✅ ПОДХОДИТ |
| ✅ male | ✅ pepperoni | ✅ Samara | ✅ ПОДХОДИТ |
| ✅ male | ❌ cheese | ✅ Moscow | ❌ НЕ подходит |
| ✅ male | ✅ mushroom | ❌ Kazan | ❌ НЕ подходит |
| ❌ female | ✅ mushroom | ✅ Moscow | ❌ НЕ подходит |

---

## ❓ Возможные вопросы на защите

### **Q1: Почему ORDER BY DESC?**

**A:** "Задание требует сортировку в **обратном** алфавитном порядке (от Я до А). `DESC` означает descending — по убыванию. Это противоположность `ASC` (ascending — по возрастанию), который стоит по умолчанию."

**Примеры:**

```sql
ORDER BY name      -- или ORDER BY name ASC  → A, B, C, D...
ORDER BY name DESC                           → Z, Y, X, W...
```

---

### **Q2: Может ли человек появиться в результате дважды?**

**A:** "Да! Если человек заказал **оба** вида пиццы (и пепперони, и грибную), он появится **два раза** — по разу для каждого заказа."

**Пример:**

```
Если Andrey заказал:
- mushroom pizza (подходит) ✓
- pepperoni pizza (подходит) ✓

Результат:
┌─────────┐
│ name    │
├─────────┤
│ Andrey  │  ← первый заказ
│ Andrey  │  ← второй заказ
└─────────┘
```

**Чтобы убрать дубликаты:**

```sql
SELECT DISTINCT person.name  -- DISTINCT убирает повторы
...
```

---

### **Q3: Почему начинаем с person, а не с person_order?**

**A:** "Можно начать и с `person_order`, результат будет тот же. Но начинать с `person` логичнее, потому что:
1. Фильтр по полу и адресу применяется к `person`
2. Сначала отсеиваем ненужных людей, потом смотрим их заказы"

**Альтернатива:**

```sql
FROM person_order po
INNER JOIN person ON person.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
...
```

**Результат одинаковый!**

---

### **Q4: Что если в Москве нет мужчин, заказывавших эти пиццы?**

**A:** "Результат будет **пустым** — ни одной строки. INNER JOIN показывает только тех, у кого **есть** совпадения во всех таблицах."

---

### **Q5: Зачем JOIN с menu, если можно проверить menu_id?**

**A:** "Нельзя! В `person_order` есть только `menu_id` (номер), а мне нужно фильтровать по **названию** пиццы. Название (`pizza_name`) хранится только в таблице `menu`, поэтому JOIN обязателен."

**Неправильно:**

```sql
-- ❌ ЭТО НЕ РАБОТАЕТ!
WHERE menu_id IN ('pepperoni pizza', 'mushroom pizza')
--    ^^^^^^^
--    это НОМЕР (8, 9, 14...), а не название!
```

**Правильно:**

```sql
-- ✅ ТАК РАБОТАЕТ!
INNER JOIN menu m ON m.id = po.menu_id
WHERE pizza_name IN ('pepperoni pizza', 'mushroom pizza')
```

---

## 📋 Альтернативные способы

### **Вариант 1: С DISTINCT (убрать дубликаты)**

```sql
SELECT DISTINCT person.name
FROM person 
...

-- Результат: каждое имя только раз
-- (даже если человек заказал обе пиццы)
```

---

### **Вариант 2: С явными названиями в ORDER BY**

```sql
ORDER BY person.name DESC
--       вместо 1 DESC
```

---

### **Вариант 3: Без псевдонимов (длиннее)**

```sql
SELECT person.name
FROM person
INNER JOIN person_order ON person.id = person_order.person_id
INNER JOIN menu ON menu.id = person_order.menu_id
WHERE person.gender = 'male' 
  AND menu.pizza_name IN ('pepperoni pizza', 'mushroom pizza')
  AND person.address IN ('Moscow', 'Samara')
ORDER BY person.name DESC;
```

---

## ✅ Краткая формула для защиты

**"Мой запрос находит мужчин, которые:**

1. **Живут в Москве или Самаре** (фильтр на `address`)
2. **Заказывали пепперони или грибную пиццу** (фильтр на `pizza_name`)

**Цепочка JOIN:**
- person → person_order (их заказы)
- person_order → menu (названия пицц)

**Сортировка:** по имени в обратном порядке (DESC)

**Результат:** Dmitriy, Andrey (в обратном алфавитном порядке)"

---

## 🎓 Финальные комментарии для файла

```sql
-- ============================================================================
-- Задание 08: Мужчины из Москвы/Самары, заказывавшие определённые пиццы
-- ============================================================================

SELECT person.name                      -- имя человека

FROM person                             -- начинаем с таблицы людей

INNER JOIN person_order po              -- их заказы
    ON person.id = po.person_id

INNER JOIN menu m                       -- названия пицц
    ON m.id = po.menu_id

WHERE gender = 'male'                   -- только мужчины
  AND pizza_name IN ('pepperoni pizza', 'mushroom pizza')  -- только эти виды
  AND address IN ('Moscow', 'Samara')   -- только эти города

ORDER BY 1 DESC;                        -- обратный алфавит (Z→A)

-- ============================================================================
-- РЕЗУЛЬТАТ:
-- Dmitriy (из Самары, заказал pepperoni)
-- Andrey (из Москвы, заказал mushroom)
-- (порядок может отличаться в зависимости от данных)
-- ============================================================================
```

---
