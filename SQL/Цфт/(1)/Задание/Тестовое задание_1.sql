/*
1.	�������� SQL ������ ��� ��������� ������ ����������� � ����� �� ���������
 �� �����, ���������������� �� ����� ��������� (� �������� �������) � ������ �����������.

��������������, ��� �������  � ����������� - ��������� ���. ������ �������� ��� - 9:00.  
 � 00:00 ��� ���������� �������� ���������. � ������� �������� ��� ���������� �����
 �������/�������� �� ������ �������������� ���������� ��� � ���������� � �������. 
 ��������������, ��� ������ ������� ���������� �������, ��������� �������� ������������ ������.

JOURNAL - ������ "������" � "�������" 
JOURNAL.ID - ���������� ����� ������ � �������
JOURNAL.SUBJ_ID - ������������� ����������
JOURNAL.DTIME - ����-����� ������ � ������
JOURNAL.TYPE - ��� ������: "����" ��� "�����" ( ������������� �� ���� )

SUBJ - ������ �����������
SUBJ.ID - ������������� ����������
SUBJ.FIO - �������, ���, �������� ����������
;
*/

drop table journal;
drop table subj;
create table journal (id number, subj_id number, dtime date, type varchar2(10));
create table subj (id number, fio varchar2(100));
insert into subj values (1, 'ivanov');
insert into subj values (2, 'petrov');
insert into subj values (3, 'sidorov');
insert into subj values (4, 'vorobjev');
insert into subj values (5, 'skladovsky-kuri');
insert into journal values (1, 1,  trunc(sysdate)+9.5/24,'����');
insert into journal values (2, 1,  trunc(sysdate)+10/24,'�����');
insert into journal values (3, 1,  trunc(sysdate)+11/24,'����');
insert into journal values (4, 1,  trunc(sysdate)+12/24,'�����');
insert into journal values (5, 2,  trunc(sysdate)+7/24,'����');
insert into journal values (6, 2,  trunc(sysdate)+17/24,'�����');
insert into journal values (7, 3,  trunc(sysdate+2)+7/24,'����');
insert into journal values (8, 3,  trunc(sysdate+2)+17/24,'�����');
insert into journal values (9, 3,  trunc(sysdate+3)+17/24,'����');
insert into journal values (10, 3,  trunc(sysdate+3)+18/24,'�����');
insert into journal values (11, 4,  trunc(sysdate+1)+9/24,'����');
insert into journal values (12, 4,  trunc(sysdate+1)+18/24,'�����');
commit;

