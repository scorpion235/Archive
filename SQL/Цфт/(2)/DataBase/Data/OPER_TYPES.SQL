SET DEFINE OFF;
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (1, '������', 'WarehouseIn', 1);
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (2, '��������', 'WarehouseOut', -1);
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (3, '������� �� ������', 'Buy', -1);
COMMIT;
