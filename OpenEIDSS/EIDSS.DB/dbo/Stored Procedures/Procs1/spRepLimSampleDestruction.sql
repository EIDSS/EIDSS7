

--##SUMMARY Select data for Sample destruction report.
--##REMARKS Author: 
--##REMARKS Create date: 

/*
--Example of a call of procedure:

exec dbo.spRepLimSampleDestruction 
@LangID=N'en',
@SampleIDXml=
N'<ItemList>
	<Item idfMaterial="35350500000870"/>
	<Item idfMaterial="35350730000870"/>
</ItemList>'

exec dbo.spRepLimSampleDestruction @LangID=N'en',@SampleIDXml=N'<ItemList>
<Item idfMaterial="51556430000000" />
</ItemList>'

*/


create PROCEDURE [dbo].[spRepLimSampleDestruction]
    (
        @LangID			AS NVARCHAR(10), 
        @SampleIDXml	AS NVARCHAR(MAX)
    )
AS
BEGIN
	
	
	DECLARE @MaterialTable	TABLE
	(
		 idfMaterial BIGINT			
	)	
	
	DECLARE @iMaterial	INT
	EXEC sp_xml_preparedocument @iMaterial OUTPUT, @SampleIDXml
	
	INSERT INTO @MaterialTable 
	(
		 idfMaterial	
	) 
	SELECT * 
	FROM OPENXML (@iMaterial, '/ItemList/Item')
	WITH 
	( 
		 idfMaterial BIGINT '@idfMaterial'
	)												 

	EXEC sp_xml_removedocument @iMaterial
	
	;WITH SentForDestructionBy AS (
		SELECT
			dbo.fnConcatFullName(tp.strFamilyName, tp.strFirstName, tp.strSecondName) AS strSentForDestructionBy
			, ROW_NUMBER () OVER (ORDER BY tp.idfPerson) rn
		FROM (select distinct tm.idfMarkedForDispositionByPerson  from tlbMaterial tm
				JOIN @MaterialTable mt ON
					mt.idfMaterial = tm.idfMaterial
		      where tm.intRowStatus = 0
		) as m
		JOIN tlbPerson tp ON
			tp.idfPerson = m.idfMarkedForDispositionByPerson 
		
		--	AND tm.idfsSampleStatus in (10015003,10015002) --cotDestroy,cotDelete
	)
	, DestructionApprovedBy AS (
		SELECT
			ISNULL(tp.strFamilyName, '') 
				+ CASE WHEN ISNULL(tp.strFamilyName, '') <> '' THEN ' ' ELSE '' END
				+ ISNULL(tp.strFirstName, '') 
				+ CASE WHEN ISNULL(tp.strSecondName, '') <> '' THEN ' ' ELSE '' END
				+ ISNULL(tp.strSecondName, '') AS strDestructionApprovedBy
			, ROW_NUMBER () OVER (ORDER BY tp.idfPerson) rn
		FROM (select distinct tm.idfDestroyedByPerson  from tlbMaterial tm
				JOIN @MaterialTable mt ON
					mt.idfMaterial = tm.idfMaterial
		      where tm.intRowStatus = 0
		) as m
		JOIN tlbPerson tp ON
			tp.idfPerson = m.idfDestroyedByPerson 

		--	AND tm.idfsSampleStatus in (10015003,10015002) --cotDestroy,cotDelete
	)
	
	SELECT
		tm.idfMaterial
		, tm.strBarcode					AS strLabSampleID
		, tm.strBarcode					AS strLabSampleIDBarcode
		, frr_SampleType.name			AS strSampleType
		, frr_Status.name				AS strCondition -- it's not condition, its's status, but i don't want to change binding in the application code
		, frr_DestructionMethod.name	AS strDestructionMethod
		, REPLACE(
			(
				 SELECT
					   CASE WHEN t2.rn > 1 THEN ', ' ELSE '' END + strSentForDestructionBy AS 'data()'  
				 FROM SentForDestructionBy t2
				 FOR XML PATH ('')
			), ' , ', ', ') strSentForDestructionBy
		, REPLACE(
			(
				 SELECT
					   CASE WHEN t2.rn > 1 THEN ', ' ELSE '' END + strDestructionApprovedBy AS 'data()'  
				 FROM DestructionApprovedBy t2
				 FOR XML PATH ('')
			), ' , ', ', ') strDestructionApprovedBy
	FROM tlbMaterial tm
	JOIN dbo.fnReferenceRepair(@LangID, 19000087) frr_SampleType ON
		frr_SampleType.idfsReference = tm.idfsSampleType
	LEFT JOIN dbo.fnReferenceRepair(@LangID, 19000157) frr_DestructionMethod ON
		frr_DestructionMethod.idfsReference = tm.idfsDestructionMethod	
	LEFT JOIN fnReferenceRepair(@LangID, 19000015) frr_Status ON
		frr_Status.idfsReference = tm.idfsSampleStatus
		
	JOIN @MaterialTable mt ON
		mt.idfMaterial = tm.idfMaterial
	WHERE tm.intRowStatus = 0
	--	AND tm.idfsSampleStatus in (10015003,10015002) --cotDestroy,cotDelete
		
END


