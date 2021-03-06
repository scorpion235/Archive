CREATE TABLE DSM.EMPLOYEES
(
  ID   NUMBER                                   NOT NULL,
  FIO  VARCHAR2(200 BYTE)                       NOT NULL,
  SEX  VARCHAR2(1 BYTE),
  AGE  INTEGER
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE DSM.EMPLOYEES IS '����������';

COMMENT ON COLUMN DSM.EMPLOYEES.ID IS 'ID ����������';

COMMENT ON COLUMN DSM.EMPLOYEES.FIO IS '��� ����������';

COMMENT ON COLUMN DSM.EMPLOYEES.SEX IS '��� (� - �������, � - �������)';

COMMENT ON COLUMN DSM.EMPLOYEES.AGE IS '�������';


CREATE UNIQUE INDEX DSM.EMPLOYEES_PK ON DSM.EMPLOYEES
(ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE DSM.EMPLOYEES ADD (
  CONSTRAINT EMPLOYEES_PK
 PRIMARY KEY
 (ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

