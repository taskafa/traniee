USE [repo-db]
GO
/****** Object:  StoredProcedure [dbo].[GetModelParams]    Script Date: 13.08.2018 10:18:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetModelParams] (
	@ModelName varchar(55),
	@LastVersion int = 1
)
AS
BEGIN
	WITH OBJT_RESULT AS (
	SELECT OBJT AS LAST_OBJT
	FROM PMOBJT AS MODELS 
	WHERE (MODELS.[NAME]=@ModelName AND 
	   MODELS.[OMDT]=(SELECT MAX(OMDT) FROM (SELECT * FROM PMOBJT WHERE PMOBJT.[NAME]=@ModelName) AS SRC_SUBSET)))
	(SELECT srce.NAME ModelName, 
			srce.OBJT Model_OBJT,
			srce.NAME TableName,
			srce.OBJT TableOBJT,
			srce_clss.NAME TableClass,
			trgt.NAME ColumnName, 
			trgt.OBJT Column_OBJT,
			trgt_clss.NAME ColumnClass,
			trgt.OCDT ColumnCDT,
			trgt.OCUS ColumnCreator,
			trgt.OMDT ColumnLMDT,
			trgt.OMUS ColumnLastModifier,
			trgt.GOID GlobalID 
	FROM PMOBJT srce 
		INNER JOIN PMRLSH rlsh ON srce.OBJT=rlsh.SRCE 
		INNER JOIN PMOBJT trgt ON trgt.OBJT=rlsh.TRGT
		INNER JOIN PMOBJT srce_objt ON srce_objt.OBJT=rlsh.SRCE
		INNER JOIN PMCLSS srce_clss ON srce_clss.CLSS=trgt.CLSS
		INNER JOIN PMCLSS trgt_clss ON trgt_clss.CLSS=trgt.CLSS
	WHERE (@LastVersion=1 AND rlsh.SRCE=(SELECT * FROM OBJT_RESULT))
			OR
			@LastVersion=0 AND srce_objt.[NAME]=@ModelName)
	UNION
	(SELECT srce.NAME ModelName, 
			srce.OBJT Model_OBJT,
			table_objt.NAME TableName,
			table_objt.OBJT TableOBJT,
			table_clss.NAME TableClass,
			trgt.NAME ColumnName, 
			trgt.OBJT Column_OBJT,
			trgt_clss.NAME ColumnClass,
			trgt.OCDT ColumnCDT,
			trgt.OCUS ColumnCreator,
			trgt.OMDT ColumnLMDT,
			trgt.OMUS ColumnLastModifier,
			trgt.GOID GlobalID  
	FROM PMOBJT srce 
		INNER JOIN PMRLSH rlsh_model ON srce.OBJT=rlsh_model.SRCE
		INNER JOIN PMRLSH rlsh_objt ON rlsh_objt.SRCE=rlsh_model.TRGT
		INNER JOIN PMOBJT srce_objt ON srce_objt.OBJT=rlsh_model.SRCE
		INNER JOIN PMOBJT trgt ON trgt.OBJT=rlsh_objt.TRGT
		INNER JOIN PMOBJT table_objt ON table_objt.OBJT=rlsh_model.TRGT
		INNER JOIN PMCLSS table_clss ON table_clss.CLSS=table_objt.CLSS
		INNER JOIN PMCLSS trgt_clss ON trgt_clss.CLSS=trgt.CLSS
	WHERE (@LastVersion=1 AND rlsh_model.SRCE=(SELECT * FROM OBJT_RESULT))
			OR
			@LastVersion=0 AND srce_objt.[NAME]=@ModelName)

END