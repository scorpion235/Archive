--drop table departs;
--drop table managers;
--drop table sales;

create table departs (id number, name varchar2(100));
create table managers (id number, fio varchar2(100),depart number);
create table sales (id number, manager number, summa number(9,2));

insert into departs values (1, '����� ������ �1');
insert into departs values (2, '����� ������ �2');

insert into managers values (1, '������', 1);
insert into managers values (2, '������', 1);
insert into managers values (3, '�������', 1);
insert into managers values (4, '�����������', 2);
insert into managers values (5, '����� �����', 2);
insert into managers values (6, '���������', 2);
insert into managers values (7, '���� ������', 1);
insert into managers values (8, '�������', 2);


insert into sales values (1, 1, 100);
insert into sales values (2, 2, 200);
insert into sales values (3, 1, 900);
insert into sales values (4, 3, 400);
insert into sales values (5, 4, 300);
insert into sales values (6, 5, 200);
insert into sales values (7, 6, 700);
insert into sales values (8, 1, 400);
insert into sales values (9, 6, 500);
insert into sales values (10, 3, 100);
insert into sales values (11, 2, 700);
insert into sales values (12, 1, 500);
insert into sales values (13, 7, 500);
insert into sales values (14, 8, 500);



