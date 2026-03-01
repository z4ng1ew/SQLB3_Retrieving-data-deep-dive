  select m.pizza_name,  p2.name as pizzeria_name
  from person_order inner join person p on p.id = person_order.person_id
  inner join menu m on m.id = person_order.menu_id
  inner join pizzeria p2 on m.pizzeria_id = p2.id
  where p.name in ('Denis', 'Anna')
  order by 1,2
















-- ============================================================================
-- Задание 06: Найти пиццы, которые заказывали Denis или Anna
-- Показывает название пиццы и пиццерию для заказов Denis и Anna
-- ============================================================================

-- ВЫБИРАЕМ две колонки
SELECT m.pizza_name,                    -- название пиццы из таблицы menu
       p2.name AS pizzeria_name         -- название пиццерии (переименовываем в pizzeria_name)
--     ^^^^^^^^
--     p2 = псевдоним для pizzeria (используем p2, т.к. p уже занят для person)

-- ГЛАВНАЯ ТАБЛИЦА: person_order (журнал заказов)
FROM person_order

-- ПЕРВЫЙ JOIN: связываем заказы с людьми
INNER JOIN person p                     -- присоединяем таблицу person (псевдоним p)
    ON p.id = person_order.person_id    -- условие: id человека = person_id в заказе
--     ^^^^    ^^^^^^^^^^^^^^^^^^^^^^^
--     кто      кто заказал

-- ВТОРОЙ JOIN: связываем заказы с меню
INNER JOIN menu m                       -- присоединяем таблицу menu (псевдоним m)
    ON m.id = person_order.menu_id      -- условие: id пиццы в меню = menu_id в заказе
--     ^^^^    ^^^^^^^^^^^^^^^^^^^^^^
--     что      что заказали

-- ТРЕТИЙ JOIN: связываем меню с пиццериями
INNER JOIN pizzeria p2                  -- присоединяем таблицу pizzeria (псевдоним p2)
    ON m.pizzeria_id = p2.id            -- условие: id пиццерии в меню = id пиццерии
--     ^^^^^^^^^^^^^    ^^^^^
--     откуда пицца     какая пиццерия

-- ФИЛЬТРАЦИЯ: только заказы Denis или Anna
WHERE p.name IN ('Denis', 'Anna')
--    ^^^^^^ ^^
--    |      └─ оператор IN = "входит в список"
--    └──────── имя из таблицы person

-- СОРТИРОВКА: сначала по названию пиццы, потом по пиццерии
ORDER BY 1, 2;
--       ^  ^
--       |  └─ 2-я колонка (pizzeria_name)
--       └──── 1-я колонка (pizza_name)

-- ============================================================================
-- ЦЕПОЧКА СВЯЗЕЙ (как данные соединяются):
-- person_order → person (узнаём ИМЯ заказчика)
--              → menu (узнаём НАЗВАНИЕ пиццы)
--                    → pizzeria (узнаём НАЗВАНИЕ пиццерии)
--
-- ЛОГИКА РАБОТЫ:
-- 1. Берём все заказы из person_order
-- 2. Через person узнаём, кто заказал (имя человека)
-- 3. Через menu узнаём, что заказали (название пиццы)
-- 4. Через pizzeria узнаём, откуда заказали (название пиццерии)
-- 5. Фильтруем только заказы Denis и Anna
-- 6. Сортируем для удобства чтения
-- ============================================================================
```

---

## 🎤 Объяснение для УСТНОЙ защиты

### **Блок 1: Зачем 3 JOIN?**

```sql
FROM person_order
INNER JOIN person p ...
INNER JOIN menu m ...
INNER JOIN pizzeria p2 ...
```

**Говоришь:**
"Мне нужно соединить **4 таблицы** через 3 JOIN, потому что:

1. В `person_order` есть только **ID** (номера), а не названия
2. Мне нужны **названия**: имя человека, название пиццы, название пиццерии
3. Каждый JOIN добавляет информацию из новой таблицы"

---

### **Блок 2: Первый JOIN (person_order → person)**

```sql
FROM person_order
INNER JOIN person p ON p.id = person_order.person_id
```

**Говоришь:**
"Первый JOIN соединяет заказы с людьми. В таблице `person_order` есть `person_id` (номер человека), но нет имени. Через JOIN с таблицей `person` я получаю имя человека, чтобы потом отфильтровать только Denis и Anna."

**Что получаем:**
```
person_order + person → узнаём, КТО заказал
```

---

### **Блок 3: Второй JOIN (person_order → menu)**

```sql
INNER JOIN menu m ON m.id = person_order.menu_id
```

**Говоришь:**
"Второй JOIN соединяет заказы с меню. В `person_order` есть `menu_id` (номер пиццы в меню), но нет названия пиццы. Через JOIN с `menu` я получаю `pizza_name` — название пиццы."

**Что получаем:**
```
person_order + menu → узнаём, ЧТО заказали
```

---

### **Блок 4: Третий JOIN (menu → pizzeria)**

```sql
INNER JOIN pizzeria p2 ON m.pizzeria_id = p2.id
```

**Говоришь:**
"Третий JOIN соединяет меню с пиццериями. В таблице `menu` есть `pizzeria_id` (номер пиццерии), но нет названия. Через JOIN с `pizzeria` я получаю название пиццерии.

Важно: использую псевдоним `p2` для `pizzeria`, потому что `p` уже занят для таблицы `person`."

**Что получаем:**
```
menu + pizzeria → узнаём, ОТКУДА пицца
```

---

### **Блок 5: WHERE фильтр**

```sql
WHERE p.name IN ('Denis', 'Anna')
```

**Говоришь:**
"Фильтрую только заказы, сделанные Denis или Anna. Оператор `IN` проверяет: входит ли имя человека в список ['Denis', 'Anna']. Это короткая запись вместо `p.name = 'Denis' OR p.name = 'Anna'`."

---

### **Блок 6: SELECT и ORDER BY**

```sql
SELECT m.pizza_name, p2.name AS pizzeria_name
ORDER BY 1, 2
```

**Говоришь:**
"Выбираю только две колонки:
1. Название пиццы из меню (`m.pizza_name`)
2. Название пиццерии (`p2.name`), переименовываю в `pizzeria_name` для ясности

Сортирую сначала по названию пиццы, потом по пиццерии — для упорядоченного вывода."

---

## 📊 Пошаговая визуализация

### **Исходные данные:**

```
person_order (заказы):
┌────┬───────────┬─────────┬────────────┐
│ id │ person_id │ menu_id │ order_date │
├────┼───────────┼─────────┼────────────┤
│ 1  │ 1 (Anna)  │ 1       │ 2022-01-01 │
│ 2  │ 1 (Anna)  │ 2       │ 2022-01-01 │
│ 3  │ 2 (Andrey)│ 8       │ 2022-01-01 │
│ 6  │ 4 (Denis) │ 16      │ 2022-01-07 │
│ 7  │ 4 (Denis) │ 17      │ 2022-01-07 │
│ ...│ ...       │ ...     │ ...        │
└────┴───────────┴─────────┴────────────┘

person:
┌────┬─────────┐
│ id │ name    │
├────┼─────────┤
│ 1  │ Anna    │
│ 2  │ Andrey  │
│ 4  │ Denis   │
│ ...│ ...     │
└────┴─────────┘

menu:
┌────┬─────────────┬────────────────┬───────┐
│ id │ pizzeria_id │ pizza_name     │ price │
├────┼─────────────┼────────────────┼───────┤
│ 1  │ 1           │ cheese pizza   │ 900   │
│ 2  │ 1           │ pepperoni pizza│ 1200  │
│ 8  │ 2           │ cheese pizza   │ 800   │
│ 16 │ 5           │ cheese pizza   │ 700   │
│ 17 │ 5           │ pepperoni pizza│ 800   │
│ ...│ ...         │ ...            │ ...   │
└────┴─────────────┴────────────────┴───────┘

pizzeria:
┌────┬────────────┐
│ id │ name       │
├────┼────────────┤
│ 1  │ Pizza Hut  │
│ 2  │ Dominos    │
│ 5  │ Best Pizza │
│ ...│ ...        │
└────┴────────────┘
```

---

### **Шаг 1: FROM person_order**

```
Начинаем с таблицы заказов:
┌────┬───────────┬─────────┐
│ id │ person_id │ menu_id │
├────┼───────────┼─────────┤
│ 1  │ 1         │ 1       │
│ 2  │ 1         │ 2       │
│ 3  │ 2         │ 8       │
│ 6  │ 4         │ 16      │
│ 7  │ 4         │ 17      │
│ ...│ ...       │ ...     │
└────┴───────────┴─────────┘
```

---

### **Шаг 2: INNER JOIN person (добавляем имена людей)**

```sql
INNER JOIN person p ON p.id = person_order.person_id
```

**Процесс:**

```
Заказ id=1:
  person_id = 1
  ↓
  Ищем в person где id = 1
  ↓
  Находим: Anna
  ↓
  Результат: заказ #1 + Anna

Заказ id=6:
  person_id = 4
  ↓
  Ищем в person где id = 4
  ↓
  Находим: Denis
  ↓
  Результат: заказ #6 + Denis
```

**Результат после 1-го JOIN:**

```
┌────┬───────────┬─────────┬─────────┐
│ id │ person_id │ menu_id │ p.name  │
├────┼───────────┼─────────┼─────────┤
│ 1  │ 1         │ 1       │ Anna    │ ← теперь знаем имя!
│ 2  │ 1         │ 2       │ Anna    │
│ 3  │ 2         │ 8       │ Andrey  │
│ 6  │ 4         │ 16      │ Denis   │ ← теперь знаем имя!
│ 7  │ 4         │ 17      │ Denis   │
│ ...│ ...       │ ...     │ ...     │
└────┴───────────┴─────────┴─────────┘
```

---

### **Шаг 3: INNER JOIN menu (добавляем названия пицц)**

```sql
INNER JOIN menu m ON m.id = person_order.menu_id
```

**Процесс:**

```
Заказ #1:
  menu_id = 1
  ↓
  Ищем в menu где id = 1
  ↓
  Находим: cheese pizza, pizzeria_id=1
  ↓
  Результат: Anna + cheese pizza

Заказ #2:
  menu_id = 2
  ↓
  Ищем в menu где id = 2
  ↓
  Находим: pepperoni pizza, pizzeria_id=1
  ↓
  Результат: Anna + pepperoni pizza
```

**Результат после 2-го JOIN:**

```
┌────┬─────────┬────────────────┬─────────────┐
│ id │ p.name  │ m.pizza_name   │ m.pizzeria_id│
├────┼─────────┼────────────────┼─────────────┤
│ 1  │ Anna    │ cheese pizza   │ 1           │ ← теперь знаем пиццу!
│ 2  │ Anna    │ pepperoni pizza│ 1           │
│ 3  │ Andrey  │ cheese pizza   │ 2           │
│ 6  │ Denis   │ cheese pizza   │ 5           │ ← теперь знаем пиццу!
│ 7  │ Denis   │ pepperoni pizza│ 5           │
│ ...│ ...     │ ...            │ ...         │
└────┴─────────┴────────────────┴─────────────┘
```

---

### **Шаг 4: INNER JOIN pizzeria (добавляем названия пиццерий)**

```sql
INNER JOIN pizzeria p2 ON m.pizzeria_id = p2.id
```

**Процесс:**

```
Строка с Anna, cheese pizza:
  pizzeria_id = 1
  ↓
  Ищем в pizzeria где id = 1
  ↓
  Находим: Pizza Hut
  ↓
  Результат: Anna + cheese pizza + Pizza Hut

Строка с Denis, cheese pizza:
  pizzeria_id = 5
  ↓
  Ищем в pizzeria где id = 5
  ↓
  Находим: Best Pizza
  ↓
  Результат: Denis + cheese pizza + Best Pizza
```

**Результат после 3-го JOIN:**

```
┌────┬─────────┬────────────────┬──────────────┐
│ id │ p.name  │ m.pizza_name   │ p2.name      │
├────┼─────────┼────────────────┼──────────────┤
│ 1  │ Anna    │ cheese pizza   │ Pizza Hut    │ ← все данные есть!
│ 2  │ Anna    │ pepperoni pizza│ Pizza Hut    │
│ 3  │ Andrey  │ cheese pizza   │ Dominos      │
│ 6  │ Denis   │ cheese pizza   │ Best Pizza   │ ← все данные есть!
│ 7  │ Denis   │ pepperoni pizza│ Best Pizza   │
│ ...│ ...     │ ...            │ ...          │
└────┴─────────┴────────────────┴──────────────┘
```

---

### **Шаг 5: WHERE фильтрует**

```sql
WHERE p.name IN ('Denis', 'Anna')
```

**Оставляем только Denis и Anna:**

```
┌─────────┬────────────────┬──────────────┐
│ p.name  │ m.pizza_name   │ p2.name      │
├─────────┼────────────────┼──────────────┤
│ Anna    │ cheese pizza   │ Pizza Hut    │ ✅ Anna
│ Anna    │ pepperoni pizza│ Pizza Hut    │ ✅ Anna
│ Andrey  │ cheese pizza   │ Dominos      │ ❌ Andrey (убираем)
│ Denis   │ cheese pizza   │ Best Pizza   │ ✅ Denis
│ Denis   │ pepperoni pizza│ Best Pizza   │ ✅ Denis
└─────────┴────────────────┴──────────────┘

Остаётся 4 строки (только Anna и Denis)
```

---

### **Шаг 6: SELECT выбирает колонки**

```sql
SELECT m.pizza_name, p2.name AS pizzeria_name
```

**Убираем колонку с именами людей:**

```
┌────────────────┬──────────────┐
│ pizza_name     │ pizzeria_name│
├────────────────┼──────────────┤
│ cheese pizza   │ Pizza Hut    │
│ pepperoni pizza│ Pizza Hut    │
│ cheese pizza   │ Best Pizza   │
│ pepperoni pizza│ Best Pizza   │
└────────────────┴──────────────┘
```

---

### **Шаг 7: ORDER BY сортирует**

```sql
ORDER BY 1, 2
```

**Сортировка:**
1. По `pizza_name`: 'c' < 'p' → cheese первая
2. Внутри группы по `pizzeria_name`: 'B' < 'P'

**Финальный результат:**

```
┌────────────────┬──────────────┐
│ pizza_name     │ pizzeria_name│
├────────────────┼──────────────┤
│ cheese pizza   │ Best Pizza   │ ← 'c' первое, 'B' первое
│ cheese pizza   │ Pizza Hut    │ ← 'c' первое, 'P' второе
│ pepperoni pizza│ Best Pizza   │ ← 'p' второе, 'B' первое
│ pepperoni pizza│ Pizza Hut    │ ← 'p' второе, 'P' второе
└────────────────┴──────────────┘
```

✅ **Именно то, что нужно!**

---

## 🎨 Схема связей таблиц

```
person_order
┌──────────────────────┐
│ id (PK)              │
│ person_id (FK) ──────┼──────→ person.id
│ menu_id (FK) ────────┼──┐
│ order_date           │  │
└──────────────────────┘  │
                          │
                          ↓
                       menu
                       ┌───────────────────┐
                       │ id (PK)           │
                       │ pizzeria_id (FK) ─┼──→ pizzeria.id
                       │ pizza_name        │
                       │ price             │
                       └───────────────────┘

Цепочка:
person_order → person (узнаём КТО)
             → menu (узнаём ЧТО)
                   → pizzeria (узнаём ОТКУДА)
```

---

## 💡 Почему псевдоним p2 для pizzeria?

```sql
INNER JOIN person p ...       ← p уже занят!
INNER JOIN pizzeria p2 ...    ← поэтому p2
```

**Объяснение:**
"Не могу использовать `p` для `pizzeria`, потому что `p` уже используется для таблицы `person`. Поэтому использую `p2` (pizzeria 2)."

**Альтернативные варианты:**

```sql
-- Вариант 1 (мой):
person p, pizzeria p2

-- Вариант 2:
person per, pizzeria piz

-- Вариант 3:
person person, pizzeria pizzeria  (длинно!)
```

---

## ❓ Возможные вопросы на защите

### **Q1: Почему 3 INNER JOIN, а не LEFT JOIN?**

**A:** "INNER JOIN подходит, потому что в базе данных:
- У каждого заказа **обязательно есть** человек (person_id не NULL)
- У каждого заказа **обязательно есть** пицца в меню (menu_id не NULL)
- У каждой пиццы в меню **обязательно есть** пиццерия (pizzeria_id не NULL)

Внешние ключи гарантируют целостность. LEFT JOIN был бы нужен, если бы могли быть 'висячие' ссылки (NULL), но их нет."

---

### **Q2: Можно ли поменять порядок JOIN?**

**A:** "Да, но с учётом связей. Например:"

```sql
-- Правильные варианты:
person_order → person → ... ✅
person_order → menu → pizzeria ✅

-- Неправильно:
pizzeria → person_order ❌ (нет прямой связи!)
```

"Главное — соблюдать цепочку связей через внешние ключи."

---

### **Q3: Зачем WHERE, если можно в ON?**

**A:** "Можно переместить фильтр в ON, но это **плохая практика**:"

```sql
-- Плохо (фильтр в ON):
INNER JOIN person p 
    ON p.id = person_order.person_id 
    AND p.name IN ('Denis', 'Anna')

-- Хорошо (фильтр в WHERE):
INNER JOIN person p 
    ON p.id = person_order.person_id
WHERE p.name IN ('Denis', 'Anna')
```

"WHERE более читаем — сразу видно, какие данные фильтруются."

---

### **Q4: Что если Anna не делала заказов?**

**A:** "Её не будет в результате, потому что используется INNER JOIN. Он показывает только тех, у кого **есть** заказы. Если бы нужно было показать Anna даже без заказов, использовал бы LEFT JOIN от person."

---

### **Q5: Почему могут быть дубликаты (две строки 'cheese pizza')?**

**A:** "Это **не дубликаты**, а разные записи! Обе строки — разные заказы:
- Anna заказала cheese pizza в Pizza Hut
- Denis заказал cheese pizza в Best Pizza

Это две разные пиццерии, поэтому две строки. Если бы хотел убрать повторяющиеся комбинации, использовал бы `DISTINCT`."

---

## 📋 Альтернативные способы

### **Вариант 1: С DISTINCT (убрать дубликаты)**

```sql
SELECT DISTINCT m.pizza_name, p2.name AS pizzeria_name
FROM person_order
...

-- Результат: только уникальные комбинации
```

---

### **Вариант 2: С явными названиями в ORDER BY**

```sql
ORDER BY m.pizza_name, p2.name
--       вместо 1, 2
```

---

### **Вариант 3: Если бы нужно показать, кто заказал**

```sql
SELECT p.name AS person_name,
       m.pizza_name, 
       p2.name AS pizzeria_name
...

-- Результат:
-- Anna | cheese pizza | Pizza Hut
-- Denis | cheese pizza | Best Pizza
```

---

## ✅ Краткая формула для защиты

**"Мой запрос соединяет 4 таблицы:**

1. **person_order** (основная) — журнал заказов
2. **JOIN person** — узнаём КТО заказал (имя)
3. **JOIN menu** — узнаём ЧТО заказали (название пиццы)
4. **JOIN pizzeria** — узнаём ОТКУДА (название пиццерии)
5. **WHERE** — фильтруем только Denis и Anna
6. **ORDER BY** — сортируем для читаемости

**Результат:** все пиццы, которые заказывали Denis или Anna, с указанием пиццерии."

---

## 🎓 Финальные комментарии

```sql
-- ============================================================================
-- Задание 06: Пиццы, заказанные Denis или Anna
-- Показывает ВСЕ пиццы, которые заказывали эти два человека
-- ============================================================================

SELECT m.pizza_name,                    -- название пиццы
       p2.name AS pizzeria_name         -- название пиццерии

FROM person_order                       -- основная таблица (заказы)

-- Цепочка JOIN для получения всех названий:
INNER JOIN person p                     -- КТО заказал
    ON p.id = person_order.person_id

INNER JOIN menu m                       -- ЧТО заказали
    ON m.id = person_order.menu_id

INNER JOIN pizzeria p2                  -- ОТКУДА заказали
    ON m.pizzeria_id = p2.id

WHERE p.name IN ('Denis', 'Anna')       -- только эти два человека

ORDER BY 1, 2;                          -- упорядоченный вывод

-- ============================================================================
-- РЕЗУЛЬТАТ: 
-- cheese pizza   | Best Pizza
-- cheese pizza   | Pizza Hut
-- pepperoni pizza| Best Pizza
-- pepperoni pizza| Pizza Hut
-- (могут быть и другие пиццы, если Denis/Anna заказывали)
-- ============================================================================
```

---

**Готов к защите!** 💪 Это отличный пример работы с множественными JOIN!