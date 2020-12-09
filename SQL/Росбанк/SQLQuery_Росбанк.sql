/* ������� �.�.*/
/* ���������� �� MS SQL 2012 */

-- (1) ������� ����� �� �������
WITH cte AS
(
    SELECT fld,
           ROW_NUMBER() OVER(PARTITION BY fld ORDER BY fld) num
      FROM dbo.TBL
)
DELETE
  FROM cte
 WHERE num > 1

-- (2) ���������� ����� � ������
UPDATE c
   SET c.������������ = c.������������ * COALESCE(cr.����, 1)
  FROM dbo.CARRY c
 OUTER APPLY
 (
    SELECT TOP(1)
           cr.����
      FROM dbo.CURRENCY_RATE cr
     WHERE cr.��������� = c.���������
     ORDER BY ABS(DATEDIFF(MINUTE, c.����, cr.����))
 ) cr

-- (3) ���������� ������� ��� ��������� �����������, ����� ����� ������������ (������������� �����������������) ������ ��� ����� ����������
WITH cte AS
(
    SELECT e.�����,
           e.�������������,
           e.��������������������������������,
           e.�����                              RootSalary,
           0                                    RootSalaryDiff,
           e.�������������                      RootID,
           0                                    Step
      FROM dbo.Employee e

    UNION ALL

    SELECT e.�����,
           e.�������������,
           e.��������������������������������,
           c.RootSalary                         RootSalary,
           c.RootSalary - e.�����               RootSalaryDiff,
           c.RootID                             RootID,
           c.Step + 1                           Step
      FROM dbo.Employee e
     INNER JOIN cte c
             ON c.������������� = e.��������������������������������
)
SELECT c.RootID,
       c.�������������
  FROM cte c
 WHERE c.RootSalaryDiff < 0
 ORDER BY c.RootID,
          c.�������������

-- (4) ���������� � ����� ������� ������� ��� ���������, ������ ������� �������� ���� fld ���������� (�� ��������)
SELECT DISTINCT
       MIN(s.fld) OVER(PARTITION BY s.num) fld_from,
       MAX(s.fld) OVER(PARTITION BY s.num) fld_to
  FROM
  (
    SELECT fld,
           fld - ROW_NUMBER() OVER(ORDER BY fld) num
      FROM dbo.TBL
  )s

-- (5) ����� �����������, ������� �������� ��� ����� ������� �������� � ������ ������
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

 -- (6) ���������� ������, ������� � ���� ���� ����� 3 ��� ����� ���������������� ����� (�� visit_id) � ���������� ������� ����� 100 (������������)
WITH cte AS
(
    SELECT visit_id,
           �������������,
           ���������������,
           MIN(visit_id) OVER(PARTITION BY ������������� ORDER BY visit_id) min_id,
           MAX(visit_id) OVER(PARTITION BY ������������� ORDER BY visit_id) max_id,
           DENSE_RANK() OVER(PARTITION BY ������������� ORDER BY visit_id)  rnk
      FROM dbo.Stat
     WHERE ��������������� >= 100
)
SELECT s.visit_id,
       s.�������������,
       s.���������������
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