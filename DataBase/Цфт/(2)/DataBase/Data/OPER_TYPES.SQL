SET DEFINE OFF;
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (1, 'приход', 'WarehouseIn', 1);
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (2, 'отгрузка', 'WarehouseOut', -1);
Insert into OPER_TYPES
   (ID, NAME, CODE, SIGN)
 Values
   (3, 'продажа со склада', 'Buy', -1);
COMMIT;
