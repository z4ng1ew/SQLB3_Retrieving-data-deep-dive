  select m.pizza_name,  p2.name as pizzeria_name
  from person_order inner join person p on p.id = person_order.person_id
  inner join menu m on m.id = person_order.menu_id
  inner join pizzeria p2 on m.pizzeria_id = p2.id
  where p.name in ('Denis', 'Anna')
  order by 1,2