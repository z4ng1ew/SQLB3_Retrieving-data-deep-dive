  select p.name
  from person p inner join person_order po on p.id = po.person_id
  inner join menu m on m.id = po.menu_id
  where m.pizza_name = 'pepperoni pizza' and p.gender = 'female'
  intersect
  select p.name
  from person p inner join person_order po on p.id = po.person_id
  inner join menu m on m.id = po.menu_id
  where m.pizza_name = 'cheese pizza' and p.gender = 'female'
  order by 1
















-- ============================================================================
-- Задание 09: Найти женщин, заказывавших И пепперони, И сырную пиццу
-- Показывает имена женщин, которые заказывали ОБА вида пиццы
-- ============================================================================

-- ПЕРВЫЙ ПОДЗАПРОС: женщины, заказывавшие пепперони
SELECT p.name                           -- имя из таблицы person
FROM person p

INNER JOIN person_order po              -- присоединяем заказы
    ON p.id = po.person_id              -- условие: id человека = person_id в заказе

INNER JOIN menu m                       -- присоединяем меню
    ON m.id = po.menu_id                -- условие: id пиццы = menu_id в заказе

WHERE m.pizza_name = 'pepperoni pizza'  -- только пепперони
  AND p.gender = 'female'               -- только женщины

-- ОПЕРАТОР INTERSECT: пересечение множеств (логическое "И")
INTERSECT
--^^^^^^^^
-- Берёт только те имена, которые есть в ОБОИХ запросах
-- Результат: женщины, которые заказывали И пепперони, И сырную

-- ВТОРОЙ ПОДЗАПРОС: женщины, заказывавшие сырную пиццу
SELECT p.name                           -- имя из таблицы person (та же структура!)
FROM person p

INNER JOIN person_order po              -- присоединяем заказы
    ON p.id = po.person_id

INNER JOIN menu m                       -- присоединяем меню
    ON m.id = po.menu_id

WHERE m.pizza_name = 'cheese pizza'     -- только сырная
  AND p.gender = 'female'               -- только женщины

-- СОРТИРОВКА применяется к итоговому результату INTERSECT
ORDER BY 1;                             -- по имени в алфавитном порядке
--       ^
--       сортируем ПОСЛЕ пересечения

-- ============================================================================
-- ЧТО ДЕЛАЕТ INTERSECT:
-- INTERSECT = пересечение множеств = логическое "И"
-- 
-- Пример:
-- Запрос 1 вернул: Anna, Kate, Nataly     (заказали пепперони)
-- Запрос 2 вернул: Anna, Elvira, Nataly   (заказали сырную)
-- INTERSECT даст:  Anna, Nataly           (заказали ОБА вида!)
--
-- ВАЖНОЕ ОТЛИЧИЕ ОТ IN:
-- IN ('pepperoni', 'cheese')  → заказала ХОТЯ БЫ ОДИН вид
-- INTERSECT                   → заказала ОБА вида ОБЯЗАТЕЛЬНО
-- ============================================================================

-- ============================================================================
-- ЛОГИКА РАБОТЫ:
-- 1. Первый запрос находит всех женщин, заказывавших пепперони
-- 2. Второй запрос находит всех женщин, заказывавших сырную пиццу
-- 3. INTERSECT берёт только тех, кто в ОБОИХ списках
-- 4. ORDER BY сортирует финальный результат
--
-- СТРУКТУРА ЗАПРОСОВ:
-- Оба подзапроса должны иметь:
-- - Одинаковое количество колонок (здесь: 1 колонка - name)
-- - Совместимые типы данных (здесь: оба VARCHAR)
-- ============================================================================


---

## 🎤 Объяснение для УСТНОЙ защиты

### **Задача:**

**"Найти женщин, которые заказывали И пепперони пиццу, И сырную пиццу"**

**Ключевое слово: "И" — не "или", а именно "И"!**

---

### **Блок 1: Что такое INTERSECT?**

```sql
SELECT ... 
INTERSECT
SELECT ...
```

**Говоришь:**
"INTERSECT — это оператор **пересечения множеств**. Он берёт результаты двух запросов и оставляет только те строки, которые присутствуют в **ОБОИХ** результатах.

Это как логическое **И**: нужно выполнить условие **И** первого запроса, **И** второго запроса."

---

### **Блок 2: Первый подзапрос**

```sql
SELECT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE m.pizza_name = 'pepperoni pizza' AND p.gender = 'female'
```

**Говоришь:**
"Первый подзапрос находит всех женщин, которые **хотя бы раз** заказывали пепперони пиццу. Структура стандартная:
- person → person_order (их заказы)
- person_order → menu (названия пицц)
- Фильтр: пепперони + женщины"

**Результат первого запроса (пример):**
```
┌────────┐
│ name   │
├────────┤
│ Anna   │  ← заказала pepperoni
│ Kate   │  ← заказала pepperoni
│ Nataly │  ← заказала pepperoni
└────────┘
```

---

### **Блок 3: Второй подзапрос**

```sql
SELECT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE m.pizza_name = 'cheese pizza' AND p.gender = 'female'
```

**Говоришь:**
"Второй подзапрос **абсолютно идентичен** по структуре, но с другим условием: ищет женщин, заказывавших **сырную** пиццу."

**Результат второго запроса (пример):**
```
┌────────┐
│ name   │
├────────┤
│ Anna   │  ← заказала cheese
│ Elvira │  ← заказала cheese
│ Nataly │  ← заказала cheese
└────────┘
```

---

### **Блок 4: INTERSECT — пересечение**

```sql
Запрос 1 INTERSECT Запрос 2
```

**Говоришь:**
"INTERSECT берёт только те имена, которые есть **в обоих** результатах. Сравним:

**Запрос 1:** Anna, Kate, Nataly (пепперони)  
**Запрос 2:** Anna, Elvira, Nataly (сырная)

**INTERSECT:** Anna, Nataly (присутствуют в обоих!)

Kate убирается — она только в первом списке.  
Elvira убирается — она только во втором списке."

**Визуально:**
```
Запрос 1          Запрос 2
┌────────┐        ┌────────┐
│ Anna   │────────│ Anna   │  ✅ в обоих → остаётся
│ Kate   │        │ Elvira │  
│ Nataly │────────│ Nataly │  ✅ в обоих → остаётся
└────────┘        └────────┘

INTERSECT даёт:
┌────────┐
│ Anna   │
│ Nataly │
└────────┘
```

---

### **Блок 5: ORDER BY после INTERSECT**

```sql
ORDER BY 1
```

**Говоришь:**
"ORDER BY применяется **к финальному результату** после пересечения. Сортирует имена в алфавитном порядке."

---

## 📊 Полная визуализация

### **Исходные данные:**

```
person:
┌────┬────────┬────────┐
│ id │ name   │ gender │
├────┼────────┼────────┤
│ 1  │ Anna   │ female │
│ 3  │ Kate   │ female │
│ 5  │ Elvira │ female │
│ 8  │ Nataly │ female │
│ ...│ ...    │ ...    │
└────┴────────┴────────┘

person_order:
┌────┬───────────┬─────────┐
│ id │ person_id │ menu_id │
├────┼───────────┼─────────┤
│ 1  │ 1 (Anna)  │ 1       │  ← cheese
│ 2  │ 1 (Anna)  │ 2       │  ← pepperoni
│ 5  │ 3 (Kate)  │ 16      │  ← cheese
│ 11 │ 5 (Elvira)│ 6       │  ← pepperoni
│ 12 │ 5 (Elvira)│ 7       │  ← sausage
│ 17 │ 8 (Nataly)│ 8       │  ← cheese
│ ...│ ...       │ ...     │
└────┴───────────┴─────────┘

menu:
┌────┬────────────────┐
│ id │ pizza_name     │
├────┼────────────────┤
│ 1  │ cheese pizza   │
│ 2  │ pepperoni pizza│
│ 6  │ pepperoni pizza│
│ 7  │ sausage pizza  │
│ 8  │ cheese pizza   │
│ 16 │ cheese pizza   │
│ ...│ ...            │
└────┴────────────────┘
```

---

### **Выполнение первого подзапроса:**

```sql
WHERE m.pizza_name = 'pepperoni pizza' AND p.gender = 'female'
```

**Процесс:**

```
Anna (id=1):
  → Заказы: menu_id=1 (cheese), menu_id=2 (pepperoni)
  → Есть pepperoni? ✅ ДА → Anna в результате

Kate (id=3):
  → Заказы: menu_id=16 (cheese)
  → Есть pepperoni? ❌ НЕТ → Kate НЕ в результате

Elvira (id=5):
  → Заказы: menu_id=6 (pepperoni), menu_id=7 (sausage)
  → Есть pepperoni? ✅ ДА → Elvira в результате

Nataly (id=8):
  → Заказы: menu_id=8 (cheese)
  → Есть pepperoni? ❌ НЕТ → Nataly НЕ в результате
```

**Результат запроса 1:**
```
┌────────┐
│ name   │
├────────┤
│ Anna   │  ← заказала pepperoni
│ Elvira │  ← заказала pepperoni
└────────┘
```

---

### **Выполнение второго подзапроса:**

```sql
WHERE m.pizza_name = 'cheese pizza' AND p.gender = 'female'
```

**Процесс:**

```
Anna (id=1):
  → Заказы: menu_id=1 (cheese), menu_id=2 (pepperoni)
  → Есть cheese? ✅ ДА → Anna в результате

Kate (id=3):
  → Заказы: menu_id=16 (cheese)
  → Есть cheese? ✅ ДА → Kate в результате

Elvira (id=5):
  → Заказы: menu_id=6 (pepperoni), menu_id=7 (sausage)
  → Есть cheese? ❌ НЕТ → Elvira НЕ в результате

Nataly (id=8):
  → Заказы: menu_id=8 (cheese)
  → Есть cheese? ✅ ДА → Nataly в результате
```

**Результат запроса 2:**
```
┌────────┐
│ name   │
├────────┤
│ Anna   │  ← заказала cheese
│ Kate   │  ← заказала cheese
│ Nataly │  ← заказала cheese
└────────┘
```

---

### **INTERSECT — пересечение:**

```
Запрос 1:         Запрос 2:         INTERSECT:
┌────────┐        ┌────────┐        ┌────────┐
│ Anna   │────────│ Anna   │───────→│ Anna   │  ✅ в обоих!
│ Elvira │        │ Kate   │        └────────┘
└────────┘        │ Nataly │
                  └────────┘

Anna есть в ОБОИХ списках → остаётся
Elvira только в первом → убирается
Kate только во втором → убирается
Nataly только во втором → убирается
```

**Финальный результат:**
```
┌────────┐
│ name   │
├────────┤
│ Anna   │  ← единственная, кто заказал ОБА вида!
└────────┘
```

✅ **Anna — единственная женщина, заказавшая И пепперони, И сырную пиццу!**

---

## 🎯 Схема логики INTERSECT

```
                ЖЕНЩИНЫ

        ┌─────────────────────────┐
        │                         │
   ┌────┴────┐              ┌─────┴────┐
   │Pepperoni│              │  Cheese  │
   │  pizza  │              │  pizza   │
   └────┬────┘              └─────┬────┘
        │                         │
        │    ┌──────────┐         │
        └────┤  ОБОИХ!  ├─────────┘
             │ (INTERSECT)
             └─────┬────┘
                   │
                 Anna
```

---

## 💡 Отличие INTERSECT от IN

### **С IN (ИЛИ):**

```sql
WHERE pizza_name IN ('pepperoni pizza', 'cheese pizza')
```

**Означает:** заказала **ХОТЯ БЫ ОДИН** вид (или оба)

**Результат:**
```
Anna   ✅ (заказала оба)
Kate   ✅ (заказала cheese)
Elvira ✅ (заказала pepperoni)
Nataly ✅ (заказала cheese)
```

---

### **С INTERSECT (И):**

```sql
SELECT ... WHERE pizza_name = 'pepperoni pizza'
INTERSECT
SELECT ... WHERE pizza_name = 'cheese pizza'
```

**Означает:** заказала **ОБА** вида обязательно

**Результат:**
```
Anna   ✅ (заказала оба)
Kate   ❌ (только cheese)
Elvira ❌ (только pepperoni)
Nataly ❌ (только cheese)
```

---

## 🔍 Требования к INTERSECT

### **Оба запроса должны иметь:**

1. **Одинаковое количество колонок:**

```sql
-- ✅ Правильно (оба SELECT возвращают 1 колонку):
SELECT name ...
INTERSECT
SELECT name ...

-- ❌ Неправильно (разное количество):
SELECT name, age ...    -- 2 колонки
INTERSECT
SELECT name ...         -- 1 колонка
```

2. **Совместимые типы данных:**

```sql
-- ✅ Правильно (оба VARCHAR):
SELECT name ...         -- VARCHAR
INTERSECT
SELECT name ...         -- VARCHAR

-- ❌ Неправильно (разные типы):
SELECT name ...         -- VARCHAR
INTERSECT
SELECT age ...          -- INTEGER
```

---

## ❓ Возможные вопросы на защите

### **Q1: Что делает INTERSECT?**

**A:** "INTERSECT — это оператор **пересечения множеств**. Он берёт результаты двух запросов и оставляет только те строки, которые присутствуют в **обоих** результатах. Это логическое **И**."

---

### **Q2: Чем INTERSECT отличается от IN?**

**A:**

| Подход | Что проверяет | Результат |
|--------|---------------|-----------|
| **IN** | Заказала ХОТЯ БЫ ОДИН вид | Больше людей |
| **INTERSECT** | Заказала ОБА вида | Меньше людей |

**Пример:**

```sql
-- С IN (или):
WHERE pizza_name IN ('pepperoni', 'cheese')
-- Anna (оба), Kate (cheese), Elvira (pepperoni) → 3 человека

-- С INTERSECT (и):
... WHERE = 'pepperoni' INTERSECT ... WHERE = 'cheese'
-- Только Anna (оба) → 1 человек
```

---

### **Q3: Можно ли решить без INTERSECT?**

**A:** "Да, можно! Есть несколько способов:"

**Способ 1: С подзапросами**

```sql
SELECT DISTINCT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE p.gender = 'female'
  AND p.id IN (
    SELECT person_id FROM person_order 
    INNER JOIN menu ON menu.id = person_order.menu_id
    WHERE pizza_name = 'pepperoni pizza'
  )
  AND p.id IN (
    SELECT person_id FROM person_order
    INNER JOIN menu ON menu.id = person_order.menu_id
    WHERE pizza_name = 'cheese pizza'
  );
```

**Способ 2: С GROUP BY и HAVING**

```sql
SELECT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE p.gender = 'female'
  AND m.pizza_name IN ('pepperoni pizza', 'cheese pizza')
GROUP BY p.name
HAVING COUNT(DISTINCT m.pizza_name) = 2;
--     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--     заказала ОБА вида (2 разных названия)
```

"Но INTERSECT — самый **наглядный** способ для этой задачи!"

---

### **Q4: Почему ORDER BY в конце, а не в каждом подзапросе?**

**A:** "ORDER BY применяется к **финальному результату** после INTERSECT. Можно добавить ORDER BY в каждый подзапрос, но это не имеет смысла — INTERSECT всё равно **пересортирует** результат."

**Пример:**

```sql
-- ❌ Бессмысленно:
SELECT name FROM ... ORDER BY 1
INTERSECT
SELECT name FROM ... ORDER BY 1
ORDER BY 1;  -- всё равно пересортирует

-- ✅ Правильно:
SELECT name FROM ...
INTERSECT
SELECT name FROM ...
ORDER BY 1;  -- сортируем один раз в конце
```

---

### **Q5: Может ли результат быть пустым?**

**A:** "Да! Если **ни одна** женщина не заказала оба вида пиццы, результат будет пустым."

**Пример:**

```
Если:
- Anna заказала только pepperoni
- Kate заказала только cheese
- Elvira заказала только supreme

Результат INTERSECT: (пусто)
```

---

## 📋 Другие операторы множеств

### **Помимо INTERSECT есть:**

| Оператор | Что делает | Аналог |
|----------|------------|--------|
| **UNION** | Объединение (без дубликатов) | ИЛИ |
| **UNION ALL** | Объединение (с дубликатами) | ИЛИ |
| **INTERSECT** | Пересечение | И |
| **EXCEPT** | Разность (в первом, но не во втором) | НЕ |

---

### **Примеры:**

```sql
-- UNION: заказали pepperoni ИЛИ cheese (или оба)
SELECT name ... WHERE pizza_name = 'pepperoni pizza'
UNION
SELECT name ... WHERE pizza_name = 'cheese pizza'
-- Результат: Anna, Kate, Elvira, Nataly (все)

-- INTERSECT: заказали pepperoni И cheese (оба!)
SELECT name ... WHERE pizza_name = 'pepperoni pizza'
INTERSECT
SELECT name ... WHERE pizza_name = 'cheese pizza'
-- Результат: Anna (только она)

-- EXCEPT: заказали pepperoni, НО НЕ заказали cheese
SELECT name ... WHERE pizza_name = 'pepperoni pizza'
EXCEPT
SELECT name ... WHERE pizza_name = 'cheese pizza'
-- Результат: Elvira (pepperoni есть, cheese нет)
```

---

## ✅ Краткая формула для защиты

**"Мой запрос использует INTERSECT для поиска женщин, заказавших ОБА вида пиццы:**

1. **Первый запрос:** находит женщин с пепперони
2. **Второй запрос:** находит женщин с сырной
3. **INTERSECT:** берёт только тех, кто в **обоих** списках
4. **ORDER BY:** сортирует финальный результат

**Результат:** только женщины, которые заказали **И** пепперони, **И** сырную пиццу (не "или", а именно "и"!)"

---

## 🎓 Финальные комментарии для файла

```sql
-- ============================================================================
-- Задание 09: Женщины, любящие И пепперони, И сырную пиццу
-- Находит женщин, которые заказывали ОБА вида пиццы
-- ============================================================================

-- Подзапрос 1: женщины, заказавшие пепперони
SELECT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE m.pizza_name = 'pepperoni pizza' 
  AND p.gender = 'female'

-- INTERSECT: оставляет только тех, кто в ОБОИХ запросах
INTERSECT

-- Подзапрос 2: женщины, заказавшие сырную
SELECT p.name
FROM person p
INNER JOIN person_order po ON p.id = po.person_id
INNER JOIN menu m ON m.id = po.menu_id
WHERE m.pizza_name = 'cheese pizza' 
  AND p.gender = 'female'

ORDER BY 1;                         -- сортировка после пересечения

-- ============================================================================
-- РЕЗУЛЬТАТ:
-- Только женщины, которые заказали ОБА вида (не "или", а именно "и")
-- 
-- ОТЛИЧИЕ ОТ IN:
-- IN ('pepperoni', 'cheese')  → заказала ХОТЯ БЫ ОДИН (или)
-- INTERSECT                   → заказала ОБА (и)
-- ============================================================================
```

---

**Готов к защите!** 💪 INTERSECT — мощный инструмент для поиска записей, удовлетворяющих **нескольким** условиям одновременно!







































  UNION и INTERSECT в SQL — это операторы для работы с наборами данныхкоторые объединяют результаты двух или более запросов SELECTно делают они это абсолютно по-разному. 
IBM
IBM
 +1
Вот основные различия:
1. UNION (Объединение)
Что делает: Берет все строки из первого запроса и добавляет к ним все строки из второго запроса.
Результат: Объединенный набор данных (уникальные строки).
Дубликаты: По умолчанию UNION удаляет дубликаты. Чтобы сохранить дубликатыиспользуйте UNION ALL.
Аналогия (множества): 
 (всё из А + всё из В). 
YouTube
YouTube
 +2
2. INTERSECT (Пересечение)
Что делает: Возвращает только те строкикоторые присутствуют и в первоми во втором запросе.
Результат: Только общие (совпадающие) строки.
Дубликаты: Удаляет дубликатывозвращая только уникальные общие строки.
Аналогия (множества): 
 (только общие элементы). 
YouTube
YouTube
 +3
Сравнительная таблица
Характеристика 	UNION	INTERSECT
Цель	Объединить два набора данных	Найти общие элементы
Результат	Строки из 1-го И 2-го запросов	Строкиобщие для 1-го И 2-го
Дубликаты	Удаляет (если просто UNION)	Удаляет
Аналогия	Логическое ИЛИ (OR)	Логическое И (AND)

























Это **разные способы объединения данных** в SQL. Главное отличие — что они объединяют:

## **JOIN** — объединяет таблицы по **горизонтали** (добавляет колонки)

```sql
SELECT * FROM users
JOIN orders ON users.id = orders.user_id;
```

**Результат:** добавляет колонки из второй таблицы к первой
```
id | name  | order_id | product
1  | Иван  | 101      | Книга
2  | Мария | 102      | Ручка
```

---

## **UNION** — объединяет запросы по **вертикали** (добавляет строки)

```sql
SELECT name FROM customers
UNION
SELECT name FROM suppliers;
```

**Результат:** складывает строки одну под другую (убирает дубликаты)
```
name
Иван
Мария
Петр
```

`UNION ALL` — то же самое, но **оставляет дубликаты**

---

## **INTERSECT** — возвращает только **общие строки** из двух запросов

```sql
SELECT name FROM customers
INTERSECT
SELECT name FROM suppliers;
```

**Результат:** только те имена, которые есть **в обеих таблицах**
```
name
Иван
```

---

## **Краткая таблица:**

| Операция | Что делает | Направление |
|----------|------------|-------------|
| JOIN | Добавляет колонки из другой таблицы | → (горизонтально) |
| UNION | Складывает результаты запросов | ↓ (вертикально) |
| INTERSECT | Оставляет только общие строки | ↓ (вертикально) |

**Важно:** для UNION и INTERSECT количество и типы колонок в запросах должны совпадать!