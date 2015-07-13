/*
�������� SQL-������, ������� �� ������ ������ ���� ������ (�� ����� ������) 
���������� � ������ �� ���������� ��������� � �������� �������, 
������������� �� �) ������ � �) �������� ����� ������.
*/
	

SELECT d.NAME       OTDEL
	 , m.FIO        MANAGER
     , SUM(s.SUMMA) SUMMA
FROM DEPARTS d
   , MANAGERS m
   , SALES s
WHERE d.ID = m.DEPART
AND   M.ID = S.MANAGER
GROUP BY d.ID
       , d.NAME
       , m.FIO
		
MINUS

SELECT OTDEL
	 , MENEDGER
	 , SUMMA
FROM
(
    SELECT (DEPART_ID ||'-'|| SUMMA) DEPART_SUMMA
	     , OTDEL
	     , MENEDGER
	     , SUMMA
    FROM
    (
        SELECT d.ID         DEPART_ID
	         , d.NAME       OTDEL
	         , m.FIO        MENEDGER
	         , SUM(s.SUMMA) SUMMA
        FROM DEPARTS d
	       , MANAGERS m
           , SALES s
        WHERE d.ID = m.DEPART
	    AND   M.ID = S.MANAGER
        GROUP BY d.ID
	           , d.NAME
	           , m.FIO
    )

    WHERE (DEPART_ID ||'-'|| SUMMA) IN		   
    (		   
        SELECT (DEPART_ID ||'-'|| SUMMA) DEPART_SUMMA 
        FROM
        (			   	  	 	  	 			 	
            --------------------------------------------------------------------
            --������ ���� ���� ������ ���������� �� �������
            SELECT DEPART_ID
	             , SUMMA
            FROM
            (
                SELECT d.ID DEPART_ID
	                 , m.ID MANAGER_ID
	                 , SUM(s.SUMMA) SUMMA
                FROM DEPARTS d
	               , MANAGERS m
                   , SALES s
                WHERE d.ID = m.DEPART
	            AND   M.ID = S.MANAGER
                GROUP BY d.ID
	                   , m.ID
            )

            --------------------------------------------------------------------
            --������ ���� ���� ������ ���������� �� �������
            --����� ������ ������ � ������
            MINUS

            SELECT DEPART_ID
                 , MAX(SUMMA) SUMMA
            FROM
            (
                SELECT d.ID DEPART_ID
	                 , m.ID MANAGER_ID
	                 , SUM(s.SUMMA) SUMMA
                FROM DEPARTS d
	               , MANAGERS m
                   , SALES s
                WHERE d.ID = m.DEPART
	            AND   M.ID = S.MANAGER
                GROUP BY d.ID
	                   , m.ID
            )
            GROUP BY DEPART_ID	

            --------------------------------------------------------------------
            --������ ���� ���� ������ ���������� �� �������
            --����� ������ ������ � ������
            MINUS

            SELECT DEPART_ID
                 , MAX(SUMMA) SUMMA
            FROM
            (
                SELECT DEPART_ID
	                 , SUMMA
                FROM
                (
                    SELECT d.ID DEPART_ID
	                     , m.ID MANAGER_ID
	                     , SUM(s.SUMMA) SUMMA
                    FROM DEPARTS d
	                   , MANAGERS m
                       , SALES s
                    WHERE d.ID = m.DEPART
	                AND   M.ID = S.MANAGER
                    GROUP BY d.ID
	                       , m.ID
                )

                MINUS

                SELECT DEPART_ID
	                 , MAX(SUMMA) SUMMA
                FROM
                (
                    SELECT d.ID DEPART_ID
	                     , m.ID MANAGER_ID
	                     , SUM(s.SUMMA) SUMMA
                    FROM DEPARTS d
	                   , MANAGERS m
                       , SALES s
                    WHERE d.ID = m.DEPART
	                AND   M.ID = S.MANAGER
                    GROUP BY d.ID
	                       , m.ID
                )
                GROUP BY DEPART_ID	
            )
            GROUP BY DEPART_ID

            --------------------------------------------------------------------
            --������ ���� ���� ������ ���������� �� �������
            --����� ������ ������ � ������
            MINUS

            SELECT DEPART_ID
	             , MAX(SUMMA) SUMMA
            FROM
            (
                SELECT DEPART_ID
	                 , SUMMA
                FROM
                (
                    SELECT d.ID DEPART_ID
	                     , m.ID MANAGER_ID
	                     , SUM(s.SUMMA) SUMMA
                    FROM DEPARTS d
	                   , MANAGERS m
                       , SALES s
                    WHERE d.ID = m.DEPART
	                AND   M.ID = S.MANAGER
                    GROUP BY d.ID
	                       , m.ID
                )

                MINUS

                SELECT DEPART_ID
	                 , MAX(SUMMA) SUMMA
                FROM
                (
                    SELECT d.ID DEPART_ID
	                     , m.ID MANAGER_ID
	                     , SUM(s.SUMMA) SUMMA
                    FROM DEPARTS d
	                   , MANAGERS m
                       , SALES s
                    WHERE d.ID = m.DEPART
	                AND   M.ID = S.MANAGER
                    GROUP BY d.ID
	                       , m.ID
                )
                GROUP BY DEPART_ID

                MINUS

                SELECT DEPART_ID
	                 , MAX(SUMMA) SUMMA
                FROM
                (
                    SELECT DEPART_ID
	                     , SUMMA
                    FROM
                    (
                        SELECT d.ID DEPART_ID
	                         , m.ID MANAGER_ID
	                         , SUM(s.SUMMA) SUMMA
                        FROM DEPARTS d
	                       , MANAGERS m
                           , SALES s
                        WHERE d.ID = m.DEPART
	                    AND   M.ID = S.MANAGER
                        GROUP BY d.ID
	                           , m.ID
                    ) 

                    MINUS

                    SELECT DEPART_ID
	                     , MAX(SUMMA) SUMMA
                    FROM
                    (
                        SELECT d.ID DEPART_ID
	                         , m.ID MANAGER_ID
	                         , SUM(s.SUMMA) SUMMA
                        FROM DEPARTS d
	                       , MANAGERS m
                           , SALES s
                        WHERE d.ID = m.DEPART
	                    AND   M.ID = S.MANAGER
                        GROUP BY d.ID
	                           , m.ID
                    )
                    GROUP BY DEPART_ID
                )
                GROUP BY DEPART_ID
            )
            GROUP BY DEPART_ID
        )
    )
)
ORDER BY OTDEL
