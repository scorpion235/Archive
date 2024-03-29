--таблица работников
CREATE TABLE WORKERS
(
  WORKER_ID  DT_IDENTIFIER IDENTITY(1,1), --ID работника
  FIO        DT_TEXT_NN,    --ФИО работника
  EMAIL      DT_TEXT,       --e-mail работника
  CONSTRAINT PK_WORKER_ID PRIMARY KEY (WORKER_ID)
);

--таблица проектов
CREATE TABLE PROJECTS
(
  PROJECT_ID DT_IDENTIFIER IDENTITY(1,1), --ID проекта
  NAME       DT_TEXT_NN,    --название проекта
  CLIENT     DT_TEXT_NN,    --название компании-заказчика
  EXECUTOR   DT_TEXT_NN,    --название компании-исполнителя
  MANAGER_ID DT_IDENTIFIER, --ID руководителя проекта
  BDATE      DT_DAY_NN,     --дата начала проекта
  EDATE      DT_DAY_NN,     --дата окончания проекта
  PRIORITY   DT_INT_NN,     --приоритет проекта
  COMMENT    DT_TEXT,       --комментарий
  CONSTRAINT PK_PROJECT_ID PRIMARY KEY(PROJECT_ID),
  CONSTRAINT FK_MANAGER_ID FOREIGN KEY(MANAGER_ID) REFERENCES WORKERS(WORKER_ID)
);

--таблица связи проектов и работников
CREATE TABLE PROJECT2WORKER
(
  PROJECT2WORKER_ID DT_IDENTIFIER IDENTITY(1,1), --ID связи
  PROJECT_ID        DT_IDENTIFIER, --ID проекта
  WORKER_ID         DT_IDENTIFIER, --ID работника
  CONSTRAINT PK_PROJECT2WORK_ID PRIMARY KEY(PROJECT2WORKER_ID),
  CONSTRAINT FK_PROJECT_ID      FOREIGN KEY(PROJECT_ID) REFERENCES PROJECTS(PROJECT_ID),
  CONSTRAINT FK_WORKER_ID       FOREIGN KEY(WORKER_ID)  REFERENCES WORKERS(WORKER_ID)
);