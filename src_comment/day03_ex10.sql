  select p1.name, p2.name, p1.address as common_address
  from person p1 inner join person p2 on p1.id > p2.id and p1.address = p2.address
  order by 1,2,3