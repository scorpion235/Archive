CREATE PROCEDURE ADD_PROJECT
@NAME       DT_TEXT_NN,
@CLIENT     DT_TEXT_NN,
@EXECUTOR   DT_TEXT_NN,
@MANAGER_ID DT_IDENTIFIER,
@BDATE      DT_DAY_NN,
@EDATE      DT_DAY_NN,
@PRIORITY   DT_INT_NN,
@COMMENT    DT_TEXT
AS
BEGIN
  INSERT INTO PROJECTS
  (
    NAME,
    CLIENT,
    EXECUTOR,
    MANAGER_ID,
    BDATE,
    EDATE,
    PRIORITY,
    COMMENT
  )
  VALUES
  (
    @NAME,
    @CLIENT,
    @EXECUTOR,
    @MANAGER_ID,
    @BDATE,
    @EDATE,
    @PRIORITY,
    @COMMENT
  )
  
  SELECT @@IDENTITY AS 'PROJECT_ID'; 
END
GO

CREATE PROCEDURE ADD_PROJECT2WORKER
@PROJECT_ID DT_IDENTIFIER,
@WORKER_ID  DT_IDENTIFIER
AS
BEGIN  
  INSERT INTO PROJECT2WORKER
  (
    PROJECT_ID,
    WORKER_ID
  )
  VALUES
  (
    @PROJECT_ID,
    @WORKER_ID
  ) 
END
GO

CREATE PROCEDURE ADD_WORKER
@FIO   DT_TEXT_NN,
@EMAIL DT_TEXT
AS
BEGIN  
  INSERT INTO WORKERS
  (
    FIO,
    EMAIL
  )
  VALUES
  (
    @FIO,
    @EMAIL
  )
  
  SELECT @@IDENTITY AS 'WORKER_ID';
END
GO

CREATE PROCEDURE DELETE_PROJECT
@PROJECT_ID DT_IDENTIFIER
AS
BEGIN
  DELETE FROM PROJECTS
   WHERE PROJECT_ID = @PROJECT_ID
END
GO

CREATE PROCEDURE DELETE_PROJECT2WORKER
@PROJECT_ID DT_INT_NN,
@WORKER_ID  DT_INT_NN
AS
BEGIN
  DELETE FROM PROJECT2WORKER
   WHERE PROJECT_ID = @PROJECT_ID
     AND WORKER_ID  = @WORKER_ID 
END
GO

CREATE PROCEDURE DELETE_WORKER
@WORKER_ID DT_IDENTIFIER
AS
BEGIN
  DELETE FROM WORKERS
   WHERE WORKER_ID = @WORKER_ID
END
GO

CREATE PROCEDURE EDIT_PROJECT
@PROJECT_ID DT_IDENTIFIER,
@NAME       DT_TEXT_NN,
@CLIENT     DT_TEXT_NN,
@EXECUTOR   DT_TEXT_NN,
@MANAGER_ID DT_IDENTIFIER,
@BDATE      DT_DAY_NN,
@EDATE      DT_DAY_NN,
@PRIORITY   DT_INT_NN,
@COMMENT    DT_TEXT
AS
BEGIN
 UPDATE PROJECTS
     SET NAME        = @NAME,
         CLIENT      = @CLIENT,
         EXECUTOR    = @EXECUTOR,
         MANAGER_ID  = @MANAGER_ID,
         BDATE       = @BDATE,
         EDATE       = @EDATE,
         PRIORITY    = @PRIORITY,
         COMMENT     = @COMMENT
   WHERE @PROJECT_ID = @PROJECT_ID
END
GO

CREATE PROCEDURE EDIT_WORKER
@WORKER_ID DT_IDENTIFIER,
@FIO       DT_TEXT_NN,
@EMAIL     DT_TEXT
AS
BEGIN
  UPDATE WORKERS
     SET FIO       = @FIO,
         EMAIL     = @EMAIL
   WHERE WORKER_ID = @WORKER_ID 
END
GO

CREATE PROCEDURE GET_PROJECTS
@MANAGER  DT_TEXT,
@BDATE    DT_DAY_NN,
@EDATE    DT_DAY_NN,
@PRIORITY DT_INT
AS
BEGIN
 SELECT p.PROJECT_ID,
        p.NAME,
        p.CLIENT,
        p.EXECUTOR,
        w.FIO,
        REPLACE(CONVERT(VARCHAR(10), p.BDATE, 103),'/','.'),
        REPLACE(CONVERT(VARCHAR(10), p.EDATE, 103),'/','.'),
        CONVERT(VARCHAR(250), p.PRIORITY) + ' приоритет',
        p.COMMENT,
        P.MANAGER_ID
   FROM PROJECTS p
  INNER JOIN WORKERS w
          ON w.WORKER_ID = p.MANAGER_ID
         AND (@MANAGER IS NULL OR LOWER(w.FIO) LIKE LOWER('%'+@MANAGER+'%'))
         AND p.BDATE BETWEEN @BDATE AND @EDATE
         AND p.EDATE BETWEEN @BDATE AND @EDATE
         AND (ISNULL(@PRIORITY, 0) = 0 OR p.PRIORITY = @PRIORITY )
END
GO

CREATE PROCEDURE GET_WORKERS
AS
BEGIN
 SELECT WORKER_ID,
        FIO,
        EMAIL
   FROM WORKERS 
END
GO

CREATE PROCEDURE GET_WORKERS_IN_PROJECT
@PROJECT_ID DT_IDENTIFIER
AS
BEGIN
 SELECT w.WORKER_ID,
        w.FIO
   FROM WORKERS w
  INNER JOIN PROJECT2WORKER pw
          ON pw.WORKER_ID = w.WORKER_ID
  INNER JOIN PROJECTS p
          ON p.PROJECT_ID = pw.PROJECT_ID
         AND P.PROJECT_ID = @PROJECT_ID
END
GO

CREATE PROCEDURE GET_WORKERS_OUT_PROJECT
@PROJECT_ID DT_IDENTIFIER,
@MANAGER_ID DT_IDENTIFIER
AS
BEGIN
 SELECT WORKER_ID,
        FIO
   FROM WORKERS
  WHERE WORKER_ID NOT IN
  (
    SELECT w.WORKER_ID
      FROM WORKERS w
     INNER JOIN PROJECT2WORKER pw
        ON pw.WORKER_ID = w.WORKER_ID
     INNER JOIN PROJECTS p
        ON p.PROJECT_ID = pw.PROJECT_ID
       AND P.PROJECT_ID = @PROJECT_ID
  )
  AND WORKER_ID <> @MANAGER_ID
END
GO