/*
1.	Написать SQL запрос для получения списка сотрудников и числа их опозданий
 за месяц, отсортированного по числу опозданий (в обратном порядке) и именам сотрудников.

Предполагается, что суббота  и воскресенье - нерабочие дни. Начало рабочего дня - 9:00.  
 К 00:00 все сотрудники покидают помещение. В течение рабочего дня сотрудники могут
 входить/выходить из здания неограниченное количество раз с отражением в журнале. 
 Предполагается, что размер журнала достаточно большой, требуется наименее ресурсоемкий запрос.

JOURNAL - Журнал "Входов" и "Выходов" 
JOURNAL.ID - уникальный номер записи в журнале
JOURNAL.SUBJ_ID - идентификатор сотрудника
JOURNAL.DTIME - дата-время записи в журнал
JOURNAL.TYPE - тип записи: "Вход" или "Выход" ( неограниченно за день )

SUBJ - Список сотрудников
SUBJ.ID - идентификатор сотрудника
SUBJ.FIO - фамилия, имя, отчество сотрудника
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
insert into journal values (1, 1,  trunc(sysdate)+9.5/24,'Вход');
insert into journal values (2, 1,  trunc(sysdate)+10/24,'Выход');
insert into journal values (3, 1,  trunc(sysdate)+11/24,'Вход');
insert into journal values (4, 1,  trunc(sysdate)+12/24,'Выход');
insert into journal values (5, 2,  trunc(sysdate)+7/24,'Вход');
insert into journal values (6, 2,  trunc(sysdate)+17/24,'Выход');
insert into journal values (7, 3,  trunc(sysdate+2)+7/24,'Вход');
insert into journal values (8, 3,  trunc(sysdate+2)+17/24,'Выход');
insert into journal values (9, 3,  trunc(sysdate+3)+17/24,'Вход');
insert into journal values (10, 3,  trunc(sysdate+3)+18/24,'Выход');
insert into journal values (11, 4,  trunc(sysdate+1)+9/24,'Вход');
insert into journal values (12, 4,  trunc(sysdate+1)+18/24,'Выход');
commit;

