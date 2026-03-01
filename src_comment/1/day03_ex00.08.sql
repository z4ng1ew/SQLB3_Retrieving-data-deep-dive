
--  JOIN БЕЗ псевдонимов

SELECT pizzeria.name, menu.pizza_name, menu.price
FROM menu
JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
WHERE menu.price < 900;



--  JOIN С псевдонимами

SELECT p.name, m.pizza_name, m.price
FROM menu m
JOIN pizzeria p ON m.pizzeria_id = p.id
WHERE m.price < 900;
























-- # ❌ СТОП! Это МИФ!

-- ## JOIN работает И БЕЗ псевдонимов!

-- Псевдонимы **НЕ обязательны** для JOIN. Просто с ними **удобнее**! Давай разберём.

-- ---

-- ## 🔬 Эксперимент 1: JOIN БЕЗ псевдонимов

-- ### **Работает отлично! ✅**

-- ```sql
-- SELECT pizzeria.name, menu.pizza_name, menu.price
-- FROM menu
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
-- WHERE menu.price < 900;
-- ```

-- **Результат:**
-- ```
-- | name       | pizza_name   | price |
-- |------------|--------------|-------|
-- | Dominos    | cheese pizza | 800   |
-- | Best Pizza | cheese pizza | 700   |
-- ```

-- ✅ **Никаких ошибок! Всё работает!**

-- ---

-- ## 🔬 Эксперимент 2: Тот же JOIN С псевдонимами

-- ```sql
-- SELECT p.name, m.pizza_name, m.price
-- FROM menu m
-- JOIN pizzeria p ON m.pizzeria_id = p.id
-- WHERE m.price < 900;
-- ```

-- **Результат ТАКОЙ ЖЕ:**
-- ```
-- | name       | pizza_name   | price |
-- |------------|--------------|-------|
-- | Dominos    | cheese pizza | 800   |
-- | Best Pizza | cheese pizza | 700   |
-- ```

-- ---

-- ## 🤔 Тогда зачем псевдонимы?

-- ### **Сравни сам:**

-- ### ❌ БЕЗ псевдонимов (ДЛИННО и НЕКРАСИВО):

-- ```sql
-- SELECT pizzeria.name, 
--        menu.pizza_name, 
--        menu.price
-- FROM menu
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
-- WHERE menu.price < 900 
--   AND pizzeria.rating > 4;
-- ```

-- **Считаем символы:**
-- - `pizzeria` — 8 символов × 3 раза = 24
-- - `menu` — 4 символа × 3 раза = 12
-- - **Итого:** много повторений!

-- ---

-- ### ✅ С псевдонимами (КОРОТКО и ЧИТАЕМО):

-- ```sql
-- SELECT p.name, 
--        m.pizza_name, 
--        m.price
-- FROM menu m
-- JOIN pizzeria p ON m.pizzeria_id = p.id
-- WHERE m.price < 900 
--   AND p.rating > 4;
-- ```

-- **Считаем:**
-- - `p` вместо `pizzeria` — в 8 раз короче!
-- - `m` вместо `menu` — в 4 раза короче!

-- ---

-- ## 🎯 Когда БЕЗ псевдонимов — ОШИБКА

-- ### **Случай 1: Две таблицы с одинаковыми именами колонок**

-- ```sql
-- -- ❌ ОШИБКА! Какой "id"? Из какой таблицы?
-- SELECT name, id
-- FROM menu
-- JOIN pizzeria ON pizzeria_id = id;
-- ```

-- **База думает:** 😵 "У `menu` есть `id`, у `pizzeria` тоже `id`! Какой брать?"

-- **Ошибка:** `column reference "id" is ambiguous`

-- ---

-- ### **Исправление БЕЗ псевдонимов:**

-- ```sql
-- SELECT pizzeria.name, menu.id
-- FROM menu
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id;
-- --               ^^^^                ^^^^^^^^^
-- --               уточнили           уточнили
-- ```

-- ✅ **Работает!** Но длинно...

-- ---

-- ### **Исправление С псевдонимами:**

-- ```sql
-- SELECT p.name, m.id
-- FROM menu m
-- JOIN pizzeria p ON m.pizzeria_id = p.id;
-- ```

-- ✅ **Работает И короче!**

-- ---

-- ## 🚨 Когда псевдонимы ОБЯЗАТЕЛЬНЫ

-- ### **Self-JOIN — таблица соединяется САМА С СОБОЙ**

-- Задача: найти людей из одного города.

-- ```sql
-- -- ❌ ЭТО НЕВОЗМОЖНО написать без псевдонимов:
-- SELECT ???
-- FROM person
-- JOIN person ON person.address = person.address
-- --   ^^^^^^    ^^^^^^
-- --   Одна и та же таблица! Как различить?
-- ```

-- **База в шоке:** 😵 "Это одна таблица или две??"

-- ---

-- ### **С псевдонимами — ЕДИНСТВЕННЫЙ способ:**

-- ```sql
-- SELECT p1.name, p2.name, p1.address
-- FROM person p1
-- JOIN person p2 ON p1.address = p2.address 
--                   AND p1.id > p2.id;
-- --     ^^^^^^ ^^     ^^         ^^
-- --     одна   вторая различаем!
-- --     копия  копия
-- ```

-- **Результат:**
-- ```
-- | name   | name   | address |
-- |--------|--------|---------|
-- | Andrey | Anna   | Moscow  |
-- | Denis  | Kate   | Kazan   |
-- ```

-- **БЕЗ псевдонимов это НЕВОЗМОЖНО!**

-- ---

-- ## 📊 Большой пример: 3 таблицы

-- ### **БЕЗ псевдонимов (работает, но ужасно!):**

-- ```sql
-- SELECT person.name, 
--        menu.pizza_name, 
--        pizzeria.name, 
--        menu.price
-- FROM person_order
-- JOIN person ON person_order.person_id = person.id
-- JOIN menu ON person_order.menu_id = menu.id
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
-- WHERE person.name = 'Anna'
--   AND pizzeria.rating > 4;
-- ```

-- **Проблемы:**
-- - Две колонки `name` (из `person` и `pizzeria`) — запутаешься!
-- - Много повторений длинных слов
-- - Тяжело читать

-- ---

-- ### **С псевдонимами (красиво!):**

-- ```sql
-- SELECT p.name AS person_name,
--        m.pizza_name, 
--        pz.name AS pizzeria_name,
--        m.price
-- FROM person_order po
-- JOIN person p ON po.person_id = p.id
-- JOIN menu m ON po.menu_id = m.id
-- JOIN pizzeria pz ON m.pizzeria_id = pz.id
-- WHERE p.name = 'Anna'
--   AND pz.rating > 4;
-- ```

-- **Преимущества:**
-- - Короткие имена: `p`, `m`, `pz`, `po`
-- - Ясно, какая `name` откуда: `person_name` vs `pizzeria_name`
-- - Легко читать и понимать

-- ---

-- ## 🎨 Визуальное сравнение

-- ### **Вариант 1: БЕЗ псевдонимов**

-- ```sql
-- FROM person_order
-- JOIN person ON person_order.person_id = person.id
-- JOIN menu ON person_order.menu_id = menu.id
--      ^^^^                          ^^^^
--      33 символа на строку!
-- ```

-- ### **Вариант 2: С псевдонимами**

-- ```sql
-- FROM person_order po
-- JOIN person p ON po.person_id = p.id
-- JOIN menu m ON po.menu_id = m.id
--      ^^^^                    ^^^^
--      13 символов — в 2.5 раза меньше!
-- ```

-- ---

-- ## 💡 Когда можно БЕЗ псевдонимов?

-- ### **Простые запросы с 1-2 таблицами:**

-- ```sql
-- -- Можно без псевдонимов:
-- SELECT name, price
-- FROM menu
-- WHERE price > 1000;

-- -- Можно и так:
-- SELECT pizza_name
-- FROM menu
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
-- WHERE pizzeria.name = 'Dominos';
-- ```

-- ✅ **Нормально, если:**
-- - Таблиц мало (1-2)
-- - Имена колонок уникальные
-- - Запрос короткий

-- ---

-- ### **Сложные запросы с 3+ таблицами:**

-- ```sql
-- -- Лучше С псевдонимами:
-- SELECT p.name, m.pizza_name, pz.name
-- FROM person_order po
-- JOIN person p ON po.person_id = p.id
-- JOIN menu m ON po.menu_id = m.id
-- JOIN pizzeria pz ON m.pizzeria_id = pz.id;
-- ```

-- ✅ **Псевдонимы обязательны, если:**
-- - Много таблиц (3+)
-- - Self-JOIN
-- - Одинаковые имена колонок
-- - Хочешь читаемый код

-- ---

-- ## 📋 Таблица сравнения

-- | Ситуация | Без псевдонимов | С псевдонимами |
-- |----------|-----------------|----------------|
-- | **1 таблица** | ✅ Отлично | ✅ Можно |
-- | **2 таблицы (простой JOIN)** | ✅ Работает | ✅ Удобнее |
-- | **3+ таблицы** | 😐 Длинно | ✅ Намного лучше |
-- | **Self-JOIN** | ❌ НЕВОЗМОЖНО | ✅ Единственный способ |
-- | **Одинаковые имена колонок** | 😐 Нужно уточнять | ✅ Проще |

-- ---

-- ## 🧪 Попробуй сам!

-- ### **Запрос 1: БЕЗ псевдонимов**

-- ```sql
-- SELECT menu.pizza_name, pizzeria.name
-- FROM menu
-- JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
-- WHERE pizzeria.name = 'Dominos';
-- ```

-- ✅ **Работает!** Попробуй выполнить.

-- ---

-- ### **Запрос 2: С псевдонимами**

-- ```sql
-- SELECT m.pizza_name, p.name
-- FROM menu m
-- JOIN pizzeria p ON m.pizzeria_id = p.id
-- WHERE p.name = 'Dominos';
-- ```

-- ✅ **Тоже работает!** Результат одинаковый.

-- ---

-- ## ✅ Итоговый ответ

-- ### **Вопрос:** JOIN работает только с псевдонимами?

-- ### **Ответ:** 

-- ❌ **НЕТ!** JOIN работает и БЕЗ псевдонимов!

-- **Псевдонимы нужны для:**
-- 1. **Удобства** — короче писать
-- 2. **Читаемости** — легче понимать
-- 3. **Self-JOIN** — без них НЕВОЗМОЖНО
-- 4. **Уникальности** — различать одинаковые имена колонок

-- **Правило:**
-- - Можешь писать без псевдонимов, но с ними **ЛУЧШЕ**
-- - В сложных запросах псевдонимы **ОБЯЗАТЕЛЬНЫ** (особенно self-join)

-- ---

-- ## 🎯 Рекомендация

-- **Всегда используй псевдонимы при JOIN!**

-- Даже если можешь без них — привыкай писать с ними:
-- - Код короче
-- - Легче читать
-- - Профессиональнее выглядит
-- - Коллеги скажут спасибо

-- ```sql
-- -- Новичок пишет:
-- FROM pizzeria JOIN menu ON pizzeria.id = menu.pizzeria_id

-- -- Профи пишет:
-- FROM pizzeria p JOIN menu m ON p.id = m.pizzeria_id
-- ```

-- **Теперь понятно?** 😊


















SELECT pizzeria.name, menu.id
FROM menu
JOIN pizzeria ON menu.pizzeria_id = pizzeria.id;
--               ^^^^                ^^^^^^^^^
--               уточнили           уточнили

