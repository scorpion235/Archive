/*
Ќаписать SQL запрос дл€ получени€ списка сотрудников и числа их опозданий
за мес€ц, отсортированного по числу опозданий (в обратном пор€дке) и именам сотрудников.

ѕредполагаетс€, что суббота  и воскресенье - нерабочие дни. Ќачало рабочего дн€ - 9:00.  
  00:00 все сотрудники покидают помещение. ¬ течение рабочего дн€ сотрудники могут
входить/выходить из здани€ неограниченное количество раз с отражением в журнале. 
ѕредполагаетс€, что размер журнала достаточно большой, требуетс€ наименее ресурсоемкий запрос.
*/

SELECT s.FIO            MANAGER
     , COUNT(j.SUBJ_ID) LATE_COUNT
FROM SUBJ s
LEFT JOIN 
( 	   
    SELECT SUBJ_ID  
         , TRUNC(DTIME) REG_DATE
         , MIN(DTIME)   MIN_VHOD
    FROM JOURNAL
    WHERE TYPE = '¬ход'
	AND TO_CHAR(DTIME, 'D') NOT IN (6, 7)
    GROUP BY SUBJ_ID
           , TRUNC(DTIME)
    ORDER BY SUBJ_ID
) j
on s.ID = j.SUBJ_ID
AND TO_CHAR(MIN_VHOD, 'HH24:MI:SS') > '09:00:00'
GROUP BY s.FIO
ORDER BY LATE_COUNT DESC
       , FIO
