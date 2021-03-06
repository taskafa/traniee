USE [repo-db]
GO
/****** Object:  StoredProcedure [dbo].[pr_MODEL_PARAM]    Script Date: 13.08.2018 15:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pr_MODEL_PARAM] (
	@Model_Ad varchar(55),
	@SON_VERSIYON_FLAG int = 1
)
AS
BEGIN
	WITH OBJT_RESULT AS (
	SELECT OBJT AS LAST_OBJT
	FROM PMOBJT AS MODELS 
	WHERE (MODELS.[NAME]=@Model_Ad AND 
	   MODELS.[OMDT]=(SELECT MAX(OMDT) FROM (SELECT * FROM PMOBJT WHERE PMOBJT.[NAME]=@Model_Ad) AS SRC_SUBSET)))
	(SELECT srce.NAME MODEL_AD,
			srce.POID MODEL_ID, 
			srce.OBJT MODEL_VERS_ID,
			srce.BRNC MODEL_BRNC_NUM,
			srce.VRSN MODEL_VERS_NUM,
			srce.FRZN MODEL_DOND,
			srce.STRN MODEL_STRN,
			srce_clss.NAME MODEL_TIP,
			srce.OCDT MODEL_YRTM_ZAMAN,
			srce.OCUS MODEL_YRTM_KULLANICI_ID,
			srce.OMDT MODEL_GUNC_ZAMAN,
			srce.OMUS MODEL_GUNC_KULLANICI_ID,
			srce.GOID MODEL_KURESEL_ID,
			srce.NAME TABLO_AD,
			srce.POID TABLO_ID,
			srce.OBJT TABLO_VERS_ID,
			srce.BRNC TABLO_BRNC_NUM,
			srce.VRSN TABLO_VERS_NUM,
			srce.FRZN TABLO_DOND,
			srce.STRN TABLO_STRN,
			srce_clss.NAME TABLO_TIP,
			srce.OCDT TABLO_YRTM_ZAMAN,
			srce.OCUS TABLO_YRTM_KULLANICI_ID,
			srce.OMDT TABLO_GUNC_ZAMAN,
			srce.OMUS TABLO_GUNC_KULLANICI_ID,
			srce.GOID TABLO_KURESEL_ID,
			trgt.NAME KOLON_AD,
			trgt.POID KOLON_ID, 
			trgt.OBJT KOLON_VERS_ID,
			trgt.BRNC KOLON_BRNC_NUM,
			trgt.VRSN KOLON_VERS_NUM,
			trgt.FRZN KOLON_DOND,
			trgt.STRN KOLON_VERS_STRN,
			trgt_clss.NAME KOLON_TIP,
			trgt.OCDT KOLON_YRTM_ZAMAN,
			trgt.OCUS KOLON_YRTM_KULLANICI_ID,
			trgt.OMDT KOLON_GUNC_ZAMAN,
			trgt.OMUS KOLON_GUNC_KULLANICI_ID,
			trgt.GOID KOLON_KURESEL_ID,
			trgt_trgr.GENE KOLON_TRGR_GENER,
			trgt_trgr.MNAM KOLON_TRGR_METOD,
			trgt_trgr.ORDR KOLON_TRGR_SIRA,
			trgt_trgr.TEVT KOLON_TRGR_OLAY,
			trgt_trgr.TTIM KOLON_TRGR_ZAMAN,
			trgt_trgr.TXTV KOLON_TRGR_KOD,
			trgt_indx.OPTS KOLON_INDX_OPSIYON,
			trgt_indx.OTYP KOLON_INDX_TIP,
			trgt_indx.UNIQ KOLON_INDX_OZGUN,
			trgt_refr.CARD KOLON_REFR_KARDINAL,
			trgt_refr.CMMT KOLON_REFR_COMMIT,
			trgt_refr.CPRT KOLON_REFR_DEGST,
			trgt_refr.CROL KOLON_REFR_ALT_ROL,
			trgt_refr.PROL KOLON_REFR_UST_ROL,
			trgt_refr.DRUL KOLON_REFR_SIL_CONSTR,
			trgt_refr.FKCN KOLON_REFR_FK_CONSTR,
			trgt_refr.GENE KOLON_REFR_GENER,
			trgt_refr.IMPL KOLON_REFR_IMPL,
			trgt_refr.URUL KOLON_REFR_GUNC_CONSTR,
			trgt_refr.SRTJ KOLON_REFR_SIRALI_JOIN,
			trgt_view.DTYP KOLON_VIEW_BOYUT_TIP,
			trgt_view.FOOT KOLON_VIEW_FOOT,
			trgt_view.GENE KOLON_VIEW_GENER,
			trgt_view.HEAD KOLON_VIEW_HEADER,
			trgt_view.OPTS KOLON_VIEW_OPSIYON,
			trgt_view.TSQL KOLON_VIEW_ETIKET_SQL,
			trgt_view.TTYP KOLON_VIEW_TIP,
			trgt_view.USAG KOLON_VIEW_KULLN,
			trgt_view.USQL KOLON_VIEW_KULLN_SQL,
			trgt_view.VSQL KOLON_VIEW_SQL,
			trgt_view.XELT KOLON_VIEW_XML_ELMN,
			trgt_view.XSCH KOLON_VIEW_XML_SCHEMA			 
	FROM PMOBJT srce 
		INNER JOIN PMRLSH rlsh ON srce.OBJT=rlsh.SRCE 
		INNER JOIN PMOBJT trgt ON trgt.OBJT=rlsh.TRGT
		INNER JOIN PMOBJT srce_objt ON srce_objt.OBJT=rlsh.SRCE
		INNER JOIN PMCLSS srce_clss ON srce_clss.CLSS=srce.CLSS
		INNER JOIN PMCLSS trgt_clss ON trgt_clss.CLSS=trgt.CLSS
		LEFT OUTER JOIN PMPDMINDX trgt_indx ON trgt.OBJT=trgt_indx.OBJT
		LEFT OUTER JOIN PMPDMTRGR trgt_trgr ON trgt.OBJT=trgt_trgr.OBJT
		LEFT OUTER JOIN PMPDMREFR trgt_refr ON trgt.OBJT=trgt_refr.OBJT
		LEFT OUTER JOIN PMPDMVIEW trgt_view ON trgt.OBJT=trgt_view.OBJT
	WHERE (@SON_VERSIYON_FLAG=1 AND rlsh.SRCE=(SELECT * FROM OBJT_RESULT))
			OR
			@SON_VERSIYON_FLAG=0 AND srce_objt.[NAME]=@Model_Ad)
	UNION
	(SELECT srce.NAME MODEL_AD,
			srce.POID MODEL_ID, 
			srce.OBJT MODEL_VERS_ID,
			srce.BRNC MODEL_BRNC_NUM,
			srce.VRSN MODEL_VERS_NUM,
			srce.FRZN MODEL_DOND,
			srce.STRN MODEL_STRN,
			srce_clss.NAME MODEL_TIP,
			srce.OCDT MODEL_YRTM_ZAMAN,
			srce.OCUS MODEL_YRTM_KULLANICI_ID,
			srce.OMDT MODEL_GUNC_ZAMAN,
			srce.OMUS MODEL_GUNC_KULLANICI_ID,
			srce.GOID MODEL_KURESEL_ID,
			table_objt.NAME TABLO_AD,
			table_objt.POID TABLO_ID,
			table_objt.OBJT TABLO_VERS_ID,
			table_objt.BRNC TABLO_BRNC_NUM,
			table_objt.VRSN TABLO_VERS_NUM,
			table_objt.FRZN TABLO_DOND,
			table_objt.STRN TABLO_STRN,
			table_clss.NAME TABLO_TIP,
			table_objt.OCDT TABLO_YRTM_ZAMAN,
			table_objt.OCUS TABLO_YRTM_KULLANICI_ID,
			table_objt.OMDT TABLO_GUNC_ZAMAN,
			table_objt.OMUS TABLO_GUNC_KULLANICI_ID,
			table_objt.GOID TABLO_KURESEL_ID,
			trgt.NAME KOLON_AD,
			trgt.POID KOLON_ID, 
			trgt.OBJT KOLON_VERS_ID,
			trgt.BRNC KOLON_BRNC_NUM,
			trgt.VRSN KOLON_VERS_NUM,
			trgt.FRZN KOLON_DOND,
			trgt.STRN KOLON_STRN,
			trgt_clss.NAME KOLON_TIP,
			trgt.OCDT KOLON_YRTM_ZAMAN,
			trgt.OCUS KOLON_YRTM_KULLANICI_ID,
			trgt.OMDT KOLON_GUNC_ZAMAN,
			trgt.OMUS KOLON_GUNC_KULLANICI_ID,
			trgt.GOID KOLON_KURESEL_ID,
			trgt_trgr.GENE KOLON_TRGR_GENER,
			trgt_trgr.MNAM KOLON_TRGR_METOD,
			trgt_trgr.ORDR KOLON_TRGR_SIRA,
			trgt_trgr.TEVT KOLON_TRGR_OLAY,
			trgt_trgr.TTIM KOLON_TRGR_ZAMAN,
			trgt_trgr.TXTV KOLON_TRGR_KOD,
			trgt_indx.OPTS KOLON_INDX_OPSIYON,
			trgt_indx.OTYP KOLON_INDX_TIP,
			trgt_indx.UNIQ KOLON_INDX_OZGUN,
			trgt_refr.CARD KOLON_REFR_KARDINAL,
			trgt_refr.CMMT KOLON_REFR_COMMIT,
			trgt_refr.CPRT KOLON_REFR_DEGST,
			trgt_refr.CROL KOLON_REFR_ALT_ROL,
			trgt_refr.PROL KOLON_REFR_UST_ROL,
			trgt_refr.DRUL KOLON_REFR_SIL_CONSTR,
			trgt_refr.FKCN KOLON_REFR_FK_CONSTR,
			trgt_refr.GENE KOLON_REFR_GENER,
			trgt_refr.IMPL KOLON_REFR_IMPL,
			trgt_refr.URUL KOLON_REFR_GUNC_CONSTR,
			trgt_refr.SRTJ KOLON_REFR_SIRALI_JOIN,
			trgt_view.DTYP KOLON_VIEW_BOYUT_TIP,
			trgt_view.FOOT KOLON_VIEW_FOOT,
			trgt_view.GENE KOLON_VIEW_GENER,
			trgt_view.HEAD KOLON_VIEW_HEADER,
			trgt_view.OPTS KOLON_VIEW_OPSIYON,
			trgt_view.TSQL KOLON_VIEW_ETIKET_SQL,
			trgt_view.TTYP KOLON_VIEW_TIP,
			trgt_view.USAG KOLON_VIEW_KULLN,
			trgt_view.USQL KOLON_VIEW_KULLN_SQL,
			trgt_view.VSQL KOLON_VIEW_SQL,
			trgt_view.XELT KOLON_VIEW_XML_ELMN,
			trgt_view.XSCH KOLON_VIEW_XML_SCHEMA
	FROM PMOBJT srce 
		INNER JOIN PMRLSH rlsh_model ON srce.OBJT=rlsh_model.SRCE
		INNER JOIN PMRLSH rlsh_objt ON rlsh_objt.SRCE=rlsh_model.TRGT
		INNER JOIN PMOBJT srce_objt ON srce_objt.OBJT=rlsh_model.SRCE
		INNER JOIN PMOBJT trgt ON trgt.OBJT=rlsh_objt.TRGT
		INNER JOIN PMOBJT table_objt ON table_objt.OBJT=rlsh_model.TRGT
		INNER JOIN PMCLSS table_clss ON table_clss.CLSS=table_objt.CLSS
		INNER JOIN PMCLSS trgt_clss ON trgt_clss.CLSS=trgt.CLSS
		INNER JOIN PMCLSS srce_clss ON srce_clss.CLSS=srce.CLSS
		LEFT OUTER JOIN PMPDMINDX trgt_indx ON trgt.OBJT=trgt_indx.OBJT
		LEFT OUTER JOIN PMPDMTRGR trgt_trgr ON trgt.OBJT=trgt_trgr.OBJT
		LEFT OUTER JOIN PMPDMREFR trgt_refr ON trgt.OBJT=trgt_refr.OBJT
		LEFT OUTER JOIN PMPDMVIEW trgt_view ON trgt.OBJT=trgt_view.OBJT
	WHERE (@SON_VERSIYON_FLAG=1 AND rlsh_model.SRCE=(SELECT * FROM OBJT_RESULT))
			OR
			@SON_VERSIYON_FLAG=0 AND srce_objt.[NAME]=@Model_Ad)

END