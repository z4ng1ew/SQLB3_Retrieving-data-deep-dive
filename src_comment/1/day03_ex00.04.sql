
SELECT p.name, p.rating
FROM pizzeria p
WHERE p.id = 1

-- p.name = pizzeria.name   -->   Беру колонку name из таблицы pizzeria




-- ### **Как база это читает:**
-- ```
-- 1. FROM pizzeria p
--    ↓
--    [ПАМЯТЬ БАЗЫ]
--    p → pizzeria  (запомнили связку)

-- 2. SELECT p.name, p.rating
--    ↓
--    p = pizzeria (смотрим в память)
--    ↓
--    SELECT pizzeria.name, pizzeria.rating

-- 3. WHERE p.id = 1
--    ↓
--    p = pizzeria (смотрим в память)
--    ↓
--    WHERE pizzeria.id = 1






-- 🔥 Пример 1: БЕЗ псевдонима



-- SELECT name, rating
-- FROM pizzeria
-- WHERE id = 1
-- ```

-- **Выполнение:**
-- ```
-- ┌──────────────┐
-- │ База данных  │
-- │              │
-- │ 1. Иду в таблицу pizzeria
-- │ 2. Беру name, rating
-- │ 3. Где id = 1
-- └──────────────┘
-- ```

-- **Результат:**
-- ```
-- | name      | rating |
-- |-----------|--------|
-- | Pizza Hut | 4.6    |







-- 🔥 Пример 2: С псевдонимом


-- SELECT p.name, p.rating
-- FROM pizzeria p
-- WHERE p.id = 1
-- ```

-- **Выполнение:**
-- ```
-- ┌──────────────┐
-- │ База данных  │
-- │              │
-- │ 1. Читаю FROM pizzeria p
-- │    → Запоминаю: p = pizzeria
-- │
-- │ 2. Читаю SELECT p.name, p.rating
-- │    → p это pizzeria (смотрю в память)
-- │    → Иду в таблицу pizzeria
-- │    → Беру name, rating
-- │
-- │ 3. Читаю WHERE p.id = 1
-- │    → p это pizzeria
-- │    → Фильтрую где pizzeria.id = 1
-- └──────────────┘
-- ```

-- **Результат ТАКОЙ ЖЕ:**
-- ```
-- | name      | rating |
-- |-----------|--------|
-- | Pizza Hut | 4.6    |
-- ```

-- ---

-- ## ⚡ Пример 3: Зачем это нужно при JOIN

-- ### Таблицы:
-- ```
-- pizzeria:                person_visits:
-- | id | name      |       | id | pizzeria_id | person_id |
-- |----|-----------|       |----|-------------|-----------|
-- | 1  | Pizza Hut |       | 1  | 1           | 5         |
-- | 2  | Dominos   |       | 2  | 2           | 7         |




БЕЗ псевдонимов (ОШИБКА!):

SELECT name, pizzeria_id
FROM pizzeria
JOIN person_visits ON id = pizzeria_id
--                    ^^
-- ОШИБКА! Какой id?
-- У pizzeria есть id
-- У person_visits тоже есть id!