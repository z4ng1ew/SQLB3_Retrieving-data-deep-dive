-- БЕЗ псевдонимов (ОШИБКА!):

SELECT name, pizzeria_id
FROM pizzeria
JOIN person_visits ON id = pizzeria_id
--                    ^^
-- ОШИБКА! Какой id?
-- У pizzeria есть id
-- У person_visits тоже есть id!