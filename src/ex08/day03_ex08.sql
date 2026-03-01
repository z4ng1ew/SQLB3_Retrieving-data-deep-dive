  select person.name
  from person inner join person_order po on person.id = po.person_id
  inner join menu m on m.id = po.menu_id
  where gender= 'male' and pizza_name in ('pepperoni pizza','mushroom pizza')
  and  address  in ('Moscow', 'Samara')
  order by 1 desc






  