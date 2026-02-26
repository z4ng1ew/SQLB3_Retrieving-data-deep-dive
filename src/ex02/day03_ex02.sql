  select coalesce(p.name,'-') as person_name,
  pv.visit_date,
  coalesce(pz.name, '-') as pizzeria_name
  from person p
  full join (select * from person_visits po where visit_date between '2022-01-01' and '2022-01-03') pv on p.id = pv.person_id
  full join pizzeria pz on pz.id = pv.pizzeria_id
  order by  1,2, 3