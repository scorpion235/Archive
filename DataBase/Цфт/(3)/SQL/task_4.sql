select s.name           worker,
       count(z.subj_id) number_of_delays
  from
  ( 
    select j.subj_id,
           min(j.dtime)
      from journal j
     where j.dtime >= sysdate - 30
       and j.type = 0
       and to_char(j.dtime,'D') <= 5
     group by trunc(j.dtime),
              j.subj_id
    having to_char(min(j.dtime), 'hh24') >= 9
  ) z,
    subj s
 where z.subj_id = s.id
 group by s.name
