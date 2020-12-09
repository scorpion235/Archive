/* Дюгуров С.М.*/
/* Реализация на MS SQL 2012 */

-- (1) Удалить дубли из таблицы
WITH cte AS
(
    SELECT fld,
           ROW_NUMBER() OVER(PARTITION BY fld ORDER BY fld) num
      FROM dbo.TBL
)
DELETE
  FROM cte
 WHERE num > 1

-- (2) Рассчитать сумму в рублях
UPDATE c
   SET c.СуммаВРублях = c.СуммаВВалюте * COALESCE(cr.Курс, 1)
  FROM dbo.CARRY c
 OUTER APPLY
 (
    SELECT TOP(1)
           cr.Курс
      FROM dbo.CURRENCY_RATE cr
     WHERE cr.КодВалюты = c.КодВалюты
     ORDER BY ABS(DATEDIFF(MINUTE, c.Дата, cr.Дата))
 ) cr

-- (3) Необходимо вывести все сочетания сотрудников, когда оклад руководителя (необязательно непосредственного) меньше чем оклад сотрудника
WITH cte AS
(
    SELECT e.Оклад,
           e.КодСотрудника,
           e.КодНепосредственногоРуководителя,
           e.Оклад                              RootSalary,
           0                                    RootSalaryDiff,
           e.КодСотрудника                      RootID,
           0                                    Step
      FROM dbo.Employee e

    UNION ALL

    SELECT e.Оклад,
           e.КодСотрудника,
           e.КодНепосредственногоРуководителя,
           c.RootSalary                         RootSalary,
           c.RootSalary - e.Оклад               RootSalaryDiff,
           c.RootID                             RootID,
           c.Step + 1                           Step
      FROM dbo.Employee e
     INNER JOIN cte c
             ON c.КодСотрудника = e.КодНепосредственногоРуководителя
)
SELECT c.RootID,
       c.КодСотрудника
  FROM cte c
 WHERE c.RootSalaryDiff < 0
 ORDER BY c.RootID,
          c.КодСотрудника

-- (4) Необходимо в одном запросе вывести все диапазоны, внутри которых значение поля fld непрерывно (по значению)
SELECT DISTINCT
       MIN(s.fld) OVER(PARTITION BY s.num) fld_from,
       MAX(s.fld) OVER(PARTITION BY s.num) fld_to
  FROM
  (
    SELECT fld,
           fld - ROW_NUMBER() OVER(ORDER BY fld) num
      FROM dbo.TBL
  )s

-- (5) найти сотрудников, которые получают три самые высокие зарплаты в каждом отделе
WITH cte AS
(
    SELECT DepartmentId,
           [Name],
           Salary,
           DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) rnk
      FROM dbo.Salary
)
SELECT d.DepartmentName Department,
       c.[Name]         Employee,
       c.Salary
  FROM cte c
 INNER JOIN dbo.Department d
         ON d.DepartmentId = c.DepartmentId
 WHERE c.rnk <= 3

 -- (6) отобразить записи, которые в один день имеют 3 или более последовательных строк (по visit_id) и количество человек более 100 (включительно)
WITH cte AS
(
    SELECT visit_id,
           ДатаПосещения,
           КоличествоЛюдей,
           MIN(visit_id) OVER(PARTITION BY ДатаПосещения ORDER BY visit_id) min_id,
           MAX(visit_id) OVER(PARTITION BY ДатаПосещения ORDER BY visit_id) max_id,
           DENSE_RANK() OVER(PARTITION BY ДатаПосещения ORDER BY visit_id)  rnk
      FROM dbo.Stat
     WHERE КоличествоЛюдей >= 100
)
SELECT s.visit_id,
       s.ДатаПосещения,
       s.КоличествоЛюдей
  FROM dbo.Stat s
 INNER join
 (
 SELECT ISNULL(min_id, -1) min_id,
        ISNULL(max_id, -1) max_id
   FROM cte
  WHERE rnk >= 3
    AND rnk = cte.max_id - min_id + 1
)q
ON s.visit_id BETWEEN q.min_id AND q.max_id