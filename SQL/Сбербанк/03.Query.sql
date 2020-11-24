-- (1) —писок всех клиентов по€вившихс€ за последние 10 дней, с суммарными денежными оборотами за последние 5 дней. ≈сли сделок не было, то выводить нулевой оборот.
SELECT c.FIO,
       ISNULL(SUM(d.Count * d.Summ * (CASE WHEN d.Type = 'BUY' THEN -1 WHEN d.Type = 'SELL' THEN 1 ELSE 0 END)), 0) Value
  FROM dbo.Client c
  LEFT JOIN dbo.Deal d
         ON d.ClientID = c.ID
        AND CAST(d.DealDate AS DATE) >= CAST(GETDATE() - 5 AS DATE)
 WHERE CAST(c.Created AS DATE) >= CAST(GETDATE() - 10 AS DATE)
 GROUP BY c.FIO

-- (2) —писок бумаг, по которым суммарные количественные обороты были >= 1000 и количество клиентов, с которыми совершались сделки >= 5, за предыдущие 30 дней от конкретной даты.
DECLARE @RegDate DATETIME = '2019-07-23'

SELECT p.Name
  FROM dbo.SecurityPaper p
 INNER JOIN dbo.Deal d
         ON d.SecurityPaperID = p.ID
        AND CAST(d.DealDate AS DATE) >= CAST(@RegDate - 30 AS DATE)
 GROUP BY p.Name
HAVING SUM(d.Count) >= 1000 AND COUNT(DISTINCT d.ClientID) >= 5