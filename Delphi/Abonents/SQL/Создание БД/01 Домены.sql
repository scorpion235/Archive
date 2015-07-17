--������
CREATE DOMAIN DATETIME AS
TIMESTAMP;

CREATE DOMAIN DATETIME_NN AS
TIMESTAMP
NOT NULL;

CREATE DOMAIN DATE_NN AS
DATE
NOT NULL;

CREATE DOMAIN DOUBLE_NN AS
DOUBLE PRECISION
NOT NULL;

CREATE DOMAIN FLOAT_10_2 AS
NUMERIC(10,2);

CREATE DOMAIN FLOAT_10_2_NN AS
NUMERIC(10,2)
NOT NULL;

CREATE DOMAIN F_KEY AS
INTEGER;

CREATE DOMAIN "INT" AS
INTEGER;

CREATE DOMAIN INT_NN AS
INTEGER
NOT NULL;

CREATE DOMAIN P_KEY AS
INTEGER
NOT NULL;

CREATE DOMAIN P_KEY AS
INTEGER
NOT NULL;

CREATE DOMAIN SMALLINT_NN AS
SMALLINT
NOT NULL;

CREATE DOMAIN S_10 AS
VARCHAR(10) CHARACTER SET WIN1251
COLLATE WIN1251;

CREATE DOMAIN S_10_NN AS
VARCHAR(10) CHARACTER SET WIN1251
NOT NULL
COLLATE WIN1251;

CREATE DOMAIN S_255 AS
VARCHAR(255) CHARACTER SET WIN1251
COLLATE WIN1251;

CREATE DOMAIN S_255_NN AS
VARCHAR(255) CHARACTER SET WIN1251
NOT NULL
COLLATE WIN1251;

CREATE DOMAIN S_40 AS
VARCHAR(40) CHARACTER SET WIN1251
COLLATE WIN1251;

CREATE DOMAIN S_40_NN AS
VARCHAR(40) CHARACTER SET WIN1251
NOT NULL
COLLATE WIN1251;

CREATE DOMAIN S_7 AS
VARCHAR(7) CHARACTER SET WIN1251
COLLATE WIN1251;

CREATE DOMAIN S_70 AS
VARCHAR(70) CHARACTER SET WIN1251
COLLATE WIN1251;

CREATE DOMAIN S_70_NN AS
VARCHAR(70) CHARACTER SET WIN1251
NOT NULL
COLLATE WIN1251;

CREATE DOMAIN S_7_NN AS
VARCHAR(7) CHARACTER SET WIN1251
NOT NULL
COLLATE WIN1251;

CREATE DOMAIN TIME_NN AS
TIME
NOT NULL;
