  select pizza_name, name as pizzeria_name, price
  from menu inner join pizzeria p on menu.pizzeria_id = p.id
  where pizza_name in ('mushroom pizza', 'pepperoni pizza')
  order by 1,2






  ```sql
-- ============================================================================
-- Задание 04: Найти информацию о грибных и пепперони пиццах
-- Показывает название пиццы, пиццерию и цену для двух видов пицц
-- ============================================================================

-- ВЫБИРАЕМ три колонки
SELECT pizza_name,                      -- название пиццы из таблицы menu
       name AS pizzeria_name,           -- название пиццерии (переименовываем в pizzeria_name)
       price                            -- цена из таблицы menu

-- ГЛАВНАЯ ТАБЛИЦА: menu (содержит информацию о пиццах и ценах)
FROM menu

-- INNER JOIN = берём только записи, где ЕСТЬ совпадения в обеих таблицах
INNER JOIN pizzeria p                   -- присоединяем таблицу пиццерий (псевдоним p)
    ON menu.pizzeria_id = p.id          -- УСЛОВИЕ: id пиццерии в menu должен совпадать с id в pizzeria
    -- ^^^^^^^^^^^^^^^^   ^^^^
    -- внешний ключ       первичный ключ

-- ФИЛЬТРАЦИЯ: оставляем только два вида пицц
WHERE pizza_name IN ('mushroom pizza', 'pepperoni pizza')
--    ^^^^^^^^^^^ ^^
--    |           └─ оператор IN = "входит в список"
--    └───────────── колонка из таблицы menu

-- СОРТИРОВКА: сначала по названию пиццы, потом по названию пиццерии
ORDER BY 1, 2;
--       ^  ^
--       |  └─ 2-я колонка (pizzeria_name)
--       └──── 1-я колонка (pizza_name)

-- ============================================================================
-- ЛОГИКА РАБОТЫ:
-- 1. INNER JOIN соединяет menu и pizzeria по связи pizzeria_id = id
-- 2. Для каждой пиццы из menu находим название пиццерии из pizzeria
-- 3. WHERE фильтрует только грибные и пепперони пиццы
-- 4. ORDER BY сортирует: сначала по названию пиццы (алфавит), 
--    потом по пиццерии (алфавит)
--
-- РЕЗУЛЬТАТ: список всех вариантов грибной и пепперони пиццы 
-- во всех пиццериях с ценами
-- ============================================================================
```

---

## 🎤 Объяснение для УСТНОЙ защиты

### **Блок 1: SELECT — что выбираем**

```sql
SELECT pizza_name, name AS pizzeria_name, price
```

**Говоришь:**
"Выбираю три колонки:
1. `pizza_name` — название пиццы из таблицы `menu`
2. `name` — название пиццерии из таблицы `pizzeria`, переименовываю в `pizzeria_name` для ясности (иначе будет просто `name`, что непонятно)
3. `price` — цена пиццы из таблицы `menu`"

---

### **Блок 2: FROM и INNER JOIN**

```sql
FROM menu
INNER JOIN pizzeria p ON menu.pizzeria_id = p.id
```

**Говоришь:**
"Начинаю с таблицы `menu`, которая содержит информацию о пиццах и ценах. Использую **INNER JOIN** для соединения с таблицей `pizzeria`, чтобы получить название пиццерии.

Условие соединения: `menu.pizzeria_id = p.id`
- В таблице `menu` есть поле `pizzeria_id` — это **внешний ключ**, ссылка на пиццерию
- В таблице `pizzeria` есть `id` — **первичный ключ**
- INNER JOIN находит совпадения: для каждой пиццы подтягивает название её пиццерии

Использую INNER JOIN, потому что мне нужны только пиццы, у которых **есть** пиццерия. Если бы вдруг была пицца без пиццерии (pizzeria_id = NULL), она бы не попала в результат."

---

### **Блок 3: WHERE фильтр**

```sql
WHERE pizza_name IN ('mushroom pizza', 'pepperoni pizza')
```

**Говоришь:**
"Фильтрую результат оператором `IN`. Он проверяет: входит ли `pizza_name` в список. Мне нужны только два вида:
- 'mushroom pizza' (грибная)
- 'pepperoni pizza' (пепперони)

Все остальные пиццы (сырная, сосисочная и т.д.) исключаются из результата."

---

### **Блок 4: ORDER BY сортировка**

```sql
ORDER BY 1, 2
```

**Говоришь:**
"Сортирую результат по двум колонкам:
1. Сначала по первой колонке — `pizza_name` (в алфавитном порядке)
2. Потом по второй колонке — `pizzeria_name` (тоже в алфавитном порядке)

Это даёт упорядоченный вывод: сначала все грибные пиццы (mushroom идёт раньше pepperoni), внутри каждой группы — по названию пиццерии."

---

## 📊 Пошаговая визуализация

### **Исходные данные:**

```
menu:
┌────┬─────────────┬────────────────┬───────┐
│ id │ pizzeria_id │ pizza_name     │ price │
├────┼─────────────┼────────────────┼───────┤
│ 1  │ 1           │ cheese pizza   │ 900   │
│ 2  │ 1           │ pepperoni pizza│ 1200  │ ← нужна! ✓
│ 9  │ 2           │ mushroom pizza │ 1100  │ ← нужна! ✓
│ 13 │ 4           │ mushroom pizza │ 950   │ ← нужна! ✓
│ 14 │ 4           │ pepperoni pizza│ 1000  │ ← нужна! ✓
│ 17 │ 5           │ pepperoni pizza│ 800   │ ← нужна! ✓
│ ...│ ...         │ ...            │ ...   │
└────┴─────────────┴────────────────┴───────┘

pizzeria:
┌────┬────────────┬────────┐
│ id │ name       │ rating │
├────┼────────────┼────────┤
│ 1  │ Pizza Hut  │ 4.6    │
│ 2  │ Dominos    │ 4.3    │
│ 4  │ Papa Johns │ 4.9    │
│ 5  │ Best Pizza │ 2.3    │
│ ...│ ...        │ ...    │
└────┴────────────┴────────┘
```

---

### **Шаг 1: FROM menu**

```
Начинаем с таблицы menu:
┌────────────────┬─────────────┬───────┐
│ pizza_name     │ pizzeria_id │ price │
├────────────────┼─────────────┼───────┤
│ cheese pizza   │ 1           │ 900   │
│ pepperoni pizza│ 1           │ 1200  │
│ mushroom pizza │ 2           │ 1100  │
│ mushroom pizza │ 4           │ 950   │
│ ...            │ ...         │ ...   │
└────────────────┴─────────────┴───────┘
```

---

### **Шаг 2: INNER JOIN pizzeria**

```sql
INNER JOIN pizzeria p ON menu.pizzeria_id = p.id
```

**Процесс соединения:**

```
menu строка 2: pizzeria_id = 1
  ↓
  Ищем в pizzeria где id = 1
  ↓
  Находим: Pizza Hut
  ↓
  Соединяем:
  | pepperoni pizza | Pizza Hut | 1200 |

menu строка 3: pizzeria_id = 2
  ↓
  Ищем в pizzeria где id = 2
  ↓
  Находим: Dominos
  ↓
  Соединяем:
  | mushroom pizza | Dominos | 1100 |
```

**Результат после INNER JOIN:**

```
┌────────────────┬──────────────┬───────┐
│ pizza_name     │ p.name       │ price │
├────────────────┼──────────────┼───────┤
│ cheese pizza   │ Pizza Hut    │ 900   │
│ pepperoni pizza│ Pizza Hut    │ 1200  │
│ sausage pizza  │ Pizza Hut    │ 1200  │
│ supreme pizza  │ Pizza Hut    │ 1200  │
│ cheese pizza   │ DinoPizza    │ 950   │
│ pepperoni pizza│ DinoPizza    │ 800   │
│ sausage pizza  │ DinoPizza    │ 1000  │
│ cheese pizza   │ Dominos      │ 800   │
│ mushroom pizza │ Dominos      │ 1100  │
│ cheese pizza   │ DoDo Pizza   │ 780   │
│ supreme pizza  │ DoDo Pizza   │ 850   │
│ cheese pizza   │ Papa Johns   │ 700   │
│ mushroom pizza │ Papa Johns   │ 950   │
│ pepperoni pizza│ Papa Johns   │ 1000  │
│ sausage pizza  │ Papa Johns   │ 950   │
│ cheese pizza   │ Best Pizza   │ 700   │
│ pepperoni pizza│ Best Pizza   │ 800   │
│ supreme pizza  │ Best Pizza   │ 850   │
└────────────────┴──────────────┴───────┘
```

---

### **Шаг 3: WHERE фильтрует**

```sql
WHERE pizza_name IN ('mushroom pizza', 'pepperoni pizza')
```

**Оставляем только нужные пиццы:**

```
┌────────────────┬──────────────┬───────┐
│ pizza_name     │ p.name       │ price │
├────────────────┼──────────────┼───────┤
│ pepperoni pizza│ Pizza Hut    │ 1200  │ ✓
│ pepperoni pizza│ DinoPizza    │ 800   │ ✓
│ mushroom pizza │ Dominos      │ 1100  │ ✓
│ mushroom pizza │ Papa Johns   │ 950   │ ✓
│ pepperoni pizza│ Papa Johns   │ 1000  │ ✓
│ pepperoni pizza│ Best Pizza   │ 800   │ ✓
└────────────────┴──────────────┴───────┘
```

---

### **Шаг 4: ORDER BY сортирует**

```sql
ORDER BY 1, 2
```

**Сортировка:**
1. По `pizza_name`: 'm' < 'p' → mushroom идёт первым
2. Внутри группы по `pizzeria_name`: алфавитный порядок

**Финальный результат:**

```
┌────────────────┬──────────────┬───────┐
│ pizza_name     │ pizzeria_name│ price │
├────────────────┼──────────────┼───────┤
│ mushroom pizza │ Dominos      │ 1100  │ ← 'm' первое, 'D' первое
│ mushroom pizza │ Papa Johns   │ 950   │ ← 'm' первое, 'P' второе
│ pepperoni pizza│ Best Pizza   │ 800   │ ← 'p' второе, 'B' первое
│ pepperoni pizza│ DinoPizza    │ 800   │ ← 'p' второе, 'D' второе
│ pepperoni pizza│ Papa Johns   │ 1000  │ ← 'p' второе, 'P' третье
│ pepperoni pizza│ Pizza Hut    │ 1200  │ ← 'p' второе, 'P' четвёртое
└────────────────┴──────────────┴───────┘
```

✅ **Именно то, что требовалось!**

---

## 🎯 Схема связи таблиц

```
menu                          pizzeria
┌───────────────────────┐    ┌──────────────┐
│ id (PK)               │    │ id (PK)      │
│ pizzeria_id (FK) ─────┼────┤              │
│ pizza_name            │    │ name         │
│ price                 │    │ rating       │
└───────────────────────┘    └──────────────┘

PK = Primary Key (первичный ключ)
FK = Foreign Key (внешний ключ)

Связь: menu.pizzeria_id → pizzeria.id
Тип: многие к одному (много пицц → одна пиццерия)
```

---

## 🔍 Зачем INNER JOIN?

### **Что даёт INNER JOIN:**

```
menu без JOIN:              menu с INNER JOIN:
┌────────────────┬────┐    ┌────────────────┬──────────┬────┐
│ pepperoni pizza│ 1  │    │ pepperoni pizza│ Pizza Hut│ 1200│
│ mushroom pizza │ 2  │    │ mushroom pizza │ Dominos  │ 1100│
└────────────────┴────┘    └────────────────┴──────────┴────┘
     ↑                           ↑
   непонятно                   понятно!
   что за "1", "2"?            название пиццерии
```

**INNER JOIN "расшифровывает" ID в читаемые названия!**

---

## ❓ Возможные вопросы на защите

### **Q1: Почему INNER JOIN, а не LEFT JOIN?**

**A:** "INNER JOIN подходит, потому что в базе данных у каждой пиццы из `menu` **обязательно есть** пиццерия (внешний ключ `pizzeria_id` ссылается на существующую запись в `pizzeria`). 

LEFT JOIN был бы нужен, если бы могли быть пиццы **без** пиццерии (pizzeria_id = NULL), но в этой базе такого нет — внешний ключ гарантирует целостность данных."

---

### **Q2: Зачем псевдоним `p` для pizzeria?**

**A:** "Псевдоним `p` делает код короче. Вместо `pizzeria.id` можно писать `p.id`. В этом запросе разница небольшая, но в сложных запросах с несколькими таблицами псевдонимы очень помогают."

**Сравнение:**

```sql
-- Без псевдонима (длинно):
FROM menu INNER JOIN pizzeria ON menu.pizzeria_id = pizzeria.id

-- С псевдонимом (короче):
FROM menu INNER JOIN pizzeria p ON menu.pizzeria_id = p.id
```

---

### **Q3: Что делает оператор IN?**

**A:** "`IN` проверяет, входит ли значение в список. Это сокращённая запись для нескольких `OR`."

**Эквивалентные запросы:**

```sql
-- С IN (короче):
WHERE pizza_name IN ('mushroom pizza', 'pepperoni pizza')

-- Без IN (длиннее):
WHERE pizza_name = 'mushroom pizza' 
   OR pizza_name = 'pepperoni pizza'
```

---

### **Q4: Можно ли без сортировки?**

**A:** "Технически да, запрос выполнится. Но задание **требует** сортировки для упорядоченного вывода. Без `ORDER BY` порядок строк будет **случайным** и может меняться при каждом выполнении."

---

### **Q5: Почему `ORDER BY 1, 2`, а не `ORDER BY pizza_name, pizzeria_name`?**

**A:** "Оба варианта работают одинаково:
- `ORDER BY 1, 2` — короткая запись (номера колонок)
- `ORDER BY pizza_name, pizzeria_name` — явная запись (названия)

Я использую `ORDER BY 1, 2` для краткости, но второй вариант более читаем."

---

## 📋 Альтернативные способы записи

### **Вариант 1: С явными названиями**

```sql
SELECT menu.pizza_name, 
       pizzeria.name AS pizzeria_name, 
       menu.price
FROM menu
INNER JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
WHERE menu.pizza_name IN ('mushroom pizza', 'pepperoni pizza')
ORDER BY menu.pizza_name, pizzeria.name;
```

---

### **Вариант 2: С псевдонимами для обеих таблиц**

```sql
SELECT m.pizza_name, 
       p.name AS pizzeria_name, 
       m.price
FROM menu m
INNER JOIN pizzeria p ON m.pizzeria_id = p.id
WHERE m.pizza_name IN ('mushroom pizza', 'pepperoni pizza')
ORDER BY 1, 2;
```

---

### **Вариант 3: С USING (если колонки называются одинаково)**

```sql
-- НЕ работает в этом случае, потому что:
-- menu.pizzeria_id ≠ pizzeria.id (разные названия)

-- Если бы было menu.id и pizzeria.id:
-- INNER JOIN pizzeria USING (id)
```

---

## ✅ Краткая формула для защиты

**"Мой запрос работает в 4 шага:**

1. **FROM + INNER JOIN:** Соединяю `menu` и `pizzeria` — для каждой пиццы получаю название пиццерии
2. **WHERE:** Фильтрую только грибные и пепперони пиццы
3. **SELECT:** Выбираю три колонки (название пиццы, пиццерия, цена)
4. **ORDER BY:** Сортирую по названию пиццы, затем по пиццерии

**Результат:** список всех вариантов грибной и пепперони пиццы во всех пиццериях с ценами."

---

## 🎓 Финальные комментарии для файла

```sql
-- ============================================================================
-- Задание 04: Информация о грибных и пепперони пиццах
-- ============================================================================

SELECT pizza_name,                      -- название пиццы
       name AS pizzeria_name,           -- название пиццерии (переименовываем)
       price                            -- цена

FROM menu                               -- основная таблица (меню)

INNER JOIN pizzeria p                   -- добавляем информацию о пиццериях
    ON menu.pizzeria_id = p.id          -- связь: внешний ключ = первичный ключ

WHERE pizza_name IN ('mushroom pizza', 'pepperoni pizza')  -- только два вида

ORDER BY 1, 2;                          -- сортировка: пицца → пиццерия

-- ============================================================================
-- РЕЗУЛЬТАТ:
-- Для каждого вида пиццы (грибная, пепперони) показывает ВСЕ пиццерии,
-- где она продаётся, с ценами. Отсортировано для удобства чтения.
-- ============================================================================
```

---

**Готов к защите!** 💪