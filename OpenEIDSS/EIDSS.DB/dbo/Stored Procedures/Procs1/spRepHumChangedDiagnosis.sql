

--##SUMMARY Selects data for DepartmentDetail form

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 3.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use

/*
Example of a call of procedure:

EXEC spRepHumChangedDiagnosis
N'EN', 
2010, 1, 
null, null, null,
N'<ItemList><Item key="784580000000"  /><Item key="784620000000"  /></ItemList>',
N'<ItemList><Item key="784580000000"  /><Item key="784620000000"  /></ItemList>'

EXEC spRepHumChangedDiagnosis
N'EN', 
2012, 1, 
null, null, null,
N'<ItemList/>',
N'<ItemList/>'



*/


create PROCEDURE [dbo].[spRepHumChangedDiagnosis](
     @LangID				as varchar(36)
	,@Year					as int
	,@Month					as int = null
	,@RegionID				as bigint = null
	,@RayonID				as bigint = null
	,@SettlementID			as bigint = null
	,@InitialDiagnosisXml	as xml
	,@FinalDiagnosisXml		as xml
  )
AS
begin
	DECLARE @currentCountry BIGINT  = dbo.fnCurrentCountry()

	DECLARE @FilteredRayons AS TABLE (idfsRayon BIGINT PRIMARY KEY)

	INSERT INTO @FilteredRayons (idfsRayon)
	SELECT 
		gr.idfsRayon
	FROM gisRayon gr 
	WHERE gr.idfsRegion = ISNULL(@RegionID, idfsRegion)
		AND gr.idfsRayon = ISNULL(@RayonID, idfsRayon)
		AND gr.idfsCountry = @currentCountry
	
	
	DECLARE @InitialDiagnosisTable	TABLE
	(
		 idfDiagnosis BIGINT			
	)	
	
	DECLARE @InitialDiagnosis	INT
	EXEC sp_xml_preparedocument @InitialDiagnosis OUTPUT, @InitialDiagnosisXml

	INSERT INTO @InitialDiagnosisTable 
	(
		 idfDiagnosis	
	) 
	SELECT * 
	FROM OPENXML (@InitialDiagnosis, '/ItemList/Item')
	WITH 
	( 
		 idfDiagnosis BIGINT '@key'
	)												 

	EXEC sp_xml_removedocument @InitialDiagnosis
	
	DECLARE @CntInitialDiagnosis INT = 0
	SELECT @CntInitialDiagnosis = COUNT(*) FROM @InitialDiagnosisTable
	
	
	
	DECLARE @FinalDiagnosisTable	TABLE
	(
		 idfDiagnosis BIGINT			
	)	
	
	DECLARE @FinalDiagnosis	INT
	EXEC sp_xml_preparedocument @FinalDiagnosis OUTPUT, @FinalDiagnosisXml
	
	INSERT INTO @FinalDiagnosisTable 
	(
		 idfDiagnosis	
	) 
	SELECT * 
	FROM OPENXML (@FinalDiagnosis, '/ItemList/Item')
	WITH 
	( 
		 idfDiagnosis BIGINT '@key'
	)												 

	EXEC sp_xml_removedocument @FinalDiagnosis
	
	DECLARE @CntFinalDiagnosis INT = 0
	SELECT @CntFinalDiagnosis = COUNT(*) FROM @FinalDiagnosisTable


	DECLARE @Result AS TABLE
	(
		strDiagnosisToDiagnosisKey	NVARCHAR(200) NOT NULL PRIMARY KEY,
		idfsInitialDiagnosis		BIGINT NOT NULL,
		strInitialDiagnosisName		NVARCHAR(200),
		idfsFinalDiagnosis			BIGINT NOT NULL,
		strFinalDiagnosisName		NVARCHAR(200),
		intCount					INT,
		intTotalCount				INT
	)

	DECLARE @intTotalCount BIGINT
 
	SELECT
		@intTotalCount = COUNT(*)
	FROM tlbHumanCase thc
	JOIN tlbHuman th ON
		th.idfHuman = thc.idfHuman
		AND th.intRowStatus = 0
	JOIN tlbGeoLocation tgl ON
		tgl.idfGeoLocation = th.idfCurrentResidenceAddress
		AND tgl.intRowStatus = 0
		AND (@SettlementID IS NULL OR tgl.idfsSettlement = @SettlementID)
	JOIN @FilteredRayons fr ON
		fr.idfsRayon = tgl.idfsRayon
	LEFT JOIN fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis'*/) AS TentativeDiagnosis ON   
		TentativeDiagnosis.idfsReference = thc.idfsTentativeDiagnosis
	LEFT JOIN fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis'*/) AS FinalDiagnosis ON   
		FinalDiagnosis.idfsReference = thc.idfsFinalDiagnosis
	WHERE thc.intRowStatus = 0
		AND YEAR(COALESCE(thc.datOnSetDate, thc.datTentativeDiagnosisDate, thc.datNotificationDate, thc.datEnteredDate)) = @Year
		AND (
			@Month IS NULL
			OR MONTH(COALESCE(thc.datOnSetDate, thc.datTentativeDiagnosisDate, thc.datNotificationDate, thc.datEnteredDate)) = @Month
			)
		AND (
			@CntInitialDiagnosis = 0 
			OR EXISTS (SELECT * FROM @InitialDiagnosisTable idt WHERE idt.idfDiagnosis = thc.idfsTentativeDiagnosis)
			)  
		AND (
			@CntFinalDiagnosis = 0 
			OR EXISTS (SELECT * FROM @FinalDiagnosisTable fdt WHERE fdt.idfDiagnosis = thc.idfsFinalDiagnosis)
		   )
		AND (thc.idfsTentativeDiagnosis IS NULL OR TentativeDiagnosis.idfsReference IS NOT NULL)
		AND (thc.idfsFinalDiagnosis IS NULL OR FinalDiagnosis.idfsReference IS NOT NULL)


	INSERT INTO @Result
	SELECT
		CAST(ISNULL(thc.idfsTentativeDiagnosis, thc.idfsFinalDiagnosis) AS NVARCHAR(50)) + '_' + CAST(ISNULL(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis) AS NVARCHAR(50))
		, ISNULL(thc.idfsTentativeDiagnosis, thc.idfsFinalDiagnosis)
		, ISNULL(TentativeDiagnosis.name, FinalDiagnosis.name)
		, ISNULL(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis)
		, ISNULL(FinalDiagnosis.name, TentativeDiagnosis.name)
		, COUNT(*)
		, @intTotalCount
	FROM tlbHumanCase thc
	JOIN tlbHuman th ON
		th.idfHuman = thc.idfHuman
		AND th.intRowStatus = 0
	JOIN tlbGeoLocation tgl ON
		tgl.idfGeoLocation = th.idfCurrentResidenceAddress
		AND tgl.intRowStatus = 0
		AND (@SettlementID IS NULL OR tgl.idfsSettlement = @SettlementID)
	JOIN @FilteredRayons fr ON
		fr.idfsRayon = tgl.idfsRayon
	LEFT JOIN fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis'*/) AS TentativeDiagnosis ON   
		TentativeDiagnosis.idfsReference = thc.idfsTentativeDiagnosis
	LEFT JOIN fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis'*/) AS FinalDiagnosis ON   
		FinalDiagnosis.idfsReference = thc.idfsFinalDiagnosis
	WHERE thc.intRowStatus = 0
		AND (thc.idfsTentativeDiagnosis IS NOT NULL OR thc.idfsFinalDiagnosis IS NOT NULL)
		AND YEAR(COALESCE(thc.datOnSetDate, thc.datTentativeDiagnosisDate, thc.datNotificationDate, thc.datEnteredDate)) = @Year
		AND (
				@Month IS NULL
				OR MONTH(COALESCE(thc.datOnSetDate, thc.datTentativeDiagnosisDate, thc.datNotificationDate, thc.datEnteredDate)) = @Month
			)
		AND (
				@CntInitialDiagnosis = 0 
				OR EXISTS (SELECT * FROM @InitialDiagnosisTable idt WHERE idt.idfDiagnosis = thc.idfsTentativeDiagnosis)
			)		
		AND (
				@CntFinalDiagnosis = 0 
				OR EXISTS (SELECT * FROM @FinalDiagnosisTable fdt WHERE fdt.idfDiagnosis = thc.idfsFinalDiagnosis)
			)		
		AND (thc.idfsTentativeDiagnosis IS NULL OR TentativeDiagnosis.idfsReference IS NOT NULL)
		AND (thc.idfsFinalDiagnosis IS NULL OR FinalDiagnosis.idfsReference IS NOT NULL)	
		
	GROUP BY CAST(ISNULL(thc.idfsTentativeDiagnosis, thc.idfsFinalDiagnosis) AS NVARCHAR(50)) + '_' + CAST(ISNULL(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis) AS NVARCHAR(50))
		, ISNULL(thc.idfsTentativeDiagnosis, thc.idfsFinalDiagnosis)
		, ISNULL(TentativeDiagnosis.name, FinalDiagnosis.name)
		, ISNULL(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis)
		, ISNULL(FinalDiagnosis.name, TentativeDiagnosis.name)
		
		
	SELECT * FROM @Result		
end		
		
		
	 
