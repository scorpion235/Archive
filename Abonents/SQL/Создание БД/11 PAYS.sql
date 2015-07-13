
/******************************************************************************/
/***               Generated by IBExpert 20.05.2010 14:00:00                ***/
/******************************************************************************/

/******************************************************************************/
/***      Following SET SQL DIALECT is just for the Database Comparer       ***/
/******************************************************************************/
SET SQL DIALECT 3;



/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/



CREATE TABLE PAYS (
    PAY_ID      P_KEY /* P_KEY = INTEGER NOT NULL */,
    REE_ID      INT_NN /* INT_NN = INTEGER NOT NULL */,
    AGENT_ID    INT_NN /* INT_NN = INTEGER NOT NULL */,
    SERVICE_ID  F_KEY NOT NULL /* F_KEY = INTEGER */,
    SUB_SRV_PU  S_70 DEFAULT NULL /* S_70 = VARCHAR(70) */,
    FIO         S_70 DEFAULT NULL /* S_70 = VARCHAR(70) */,
    CITY        S_40 DEFAULT NULL /* S_40 = VARCHAR(40) */,
    STREET      S_70 DEFAULT NULL /* S_70 = VARCHAR(70) */,
    BUILDING    S_10 DEFAULT NULL /* S_10 = VARCHAR(10) */,
    APARTMENT   S_7 DEFAULT NULL /* S_7 = VARCHAR(7) */,
    ACC_PU      S_40 DEFAULT NULL /* S_40 = VARCHAR(40) */,
    DATE_PAY    DATE_NN /* DATE_NN = DATE NOT NULL */,
    UNO         INT_NN /* INT_NN = INTEGER NOT NULL */,
    SUMM        FLOAT_10_2_NN /* FLOAT_10_2_NN = NUMERIC(10,2) NOT NULL */,
    BALANCE     FLOAT_10_2_NN /* FLOAT_10_2_NN = NUMERIC(10,2) NOT NULL */
);




/******************************************************************************/
/***                              Primary Keys                              ***/
/******************************************************************************/

ALTER TABLE PAYS ADD CONSTRAINT PK_PAYS PRIMARY KEY (PAY_ID);


/******************************************************************************/
/***                              Foreign Keys                              ***/
/******************************************************************************/

ALTER TABLE PAYS ADD CONSTRAINT FK_PAYS_SERVICE_ID FOREIGN KEY (SERVICE_ID) REFERENCES SERVICES (SERVICE_ID);


/******************************************************************************/
/***                          Fields descriptions                           ***/
/******************************************************************************/

COMMENT ON COLUMN PAYS.PAY_ID IS 
'�� �������';

COMMENT ON COLUMN PAYS.REE_ID IS 
'�� ������� ������';

COMMENT ON COLUMN PAYS.AGENT_ID IS 
'�� ������';

COMMENT ON COLUMN PAYS.SERVICE_ID IS 
'������ �� �� ������';

COMMENT ON COLUMN PAYS.SUB_SRV_PU IS 
'ID ��������� � ������� ��';

COMMENT ON COLUMN PAYS.FIO IS 
'��� �����������';

COMMENT ON COLUMN PAYS.CITY IS 
'�����';

COMMENT ON COLUMN PAYS.STREET IS 
'�����';

COMMENT ON COLUMN PAYS.BUILDING IS 
'���';

COMMENT ON COLUMN PAYS.APARTMENT IS 
'��������';

COMMENT ON COLUMN PAYS.ACC_PU IS 
'������� ����';

COMMENT ON COLUMN PAYS.DATE_PAY IS 
'���� �������';

COMMENT ON COLUMN PAYS.UNO IS 
'����� ���������';

COMMENT ON COLUMN PAYS.SUMM IS 
'����� ������';

COMMENT ON COLUMN PAYS.BALANCE IS 
'������� �� �����';



/******************************************************************************/
/***                               Privileges                               ***/
/******************************************************************************/

