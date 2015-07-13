select g.codgd,
       sum(g.qty * g.price * decode(d.flaginout, 0, -1, 1, 1)) summ
  from StkDocs d,
       StkGds g
 where d.coddoc = g.coddoc
   and d.state = 1
 group by g.codgd
