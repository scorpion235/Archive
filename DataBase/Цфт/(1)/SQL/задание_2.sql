/*
С помощью простых операций написать SQL выражение/запрос для вычисления
числа рабочих дней между двумя датами.
Выходными предполагаются суббота, воскресенье.
Желательно чтобы результат не зависел от локализации БД.
*/

SELECT DECODE
(
       MOD(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)), 7),

       -- 0, 7, 14, 21, ...
       0, (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7),
		  
       -- 1, 8, 15, 22, ...
       1, DECODE(TO_CHAR(LEAST(:d1, :d2), 'D'),
	      '6', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
		       (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7)),
		  
       -- 2, 9, 16, 23
       2, DECODE(TO_CHAR(LEAST(:d1, :d2), 'D'),
	      '5', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '6', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
		       (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7)),

       -- 3, 10, 17, 24
       3, DECODE(TO_CHAR(LEAST(:d1, :d2), 'D'),
	      '4', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '5', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '6', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
		       (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7)),
		   
       -- 4, 11, 18, 25
       4, DECODE(TO_CHAR(LEAST(:d1, :d2), 'D'),
	      '3', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '4', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '5', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '6', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
		       (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7)),
		  
       -- 5, 11, 18, 25
       5, DECODE(TO_CHAR(LEAST(:d1, :d2), 'D'),
	      '2', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '3', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '4', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '5', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
	      '6', (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1,
		       (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7)),
		  
       -- 6, 12, 19, 26
       6, (GREATEST(:d1, :d2) - LEAST(:d1, :d2)) - 2 * TRUNC(TRUNC(GREATEST(:d1, :d2) - LEAST(:d1, :d2)) / 7) - 1
)  	   
WORK_DAY_COUNT
FROM DUAL