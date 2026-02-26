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