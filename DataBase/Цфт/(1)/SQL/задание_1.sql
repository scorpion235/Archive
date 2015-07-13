/*
�������� SQL ������ ��� ��������� ������ ����������� � ����� �� ���������
�� �����, ���������������� �� ����� ��������� (� �������� �������) � ������ �����������.

��������������, ��� �������  � ����������� - ��������� ���. ������ �������� ��� - 9:00.  
� 00:00 ��� ���������� �������� ���������. � ������� �������� ��� ���������� �����
�������/�������� �� ������ �������������� ���������� ��� � ���������� � �������. 
��������������, ��� ������ ������� ���������� �������, ��������� �������� ������������ ������.
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
    WHERE TYPE = '����'
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
