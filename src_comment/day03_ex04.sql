  select pizza_name, name as pizzeria_name, price
  from menu inner join pizzeria p on menu.pizzeria_id = p.id
  where pizza_name in ('mushroom pizza', 'pepperoni pizza')
  order by 1,2