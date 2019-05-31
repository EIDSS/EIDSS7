
/*
declare @NextNumberValue AS NVARCHAR(200)
exec spGetNextNumber 10057022, @NextNumberValue output, 1
print @NextNumberValue
*/

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE                   PROCEDURE [dbo].[spGetNextNumber]( 
	@NextNumberName AS BIGINT,
	@NextNumberValue AS NVARCHAR(200) OUTPUT,
	@InstallationSite AS BIGINT 
)
AS
DECLARE @NextID BIGINT
DECLARE @Year int
DECLARE @MinNumberLength INT
DECLARE @Suffix NVARCHAR(50)
DECLARE @Prefix NVARCHAR(50)
DECLARE @ShowPrefix BIT
DECLARE @ShowSiteID BIT
DECLARE @ShowYear BIT
DECLARE @ShowHASCCodeSite BIT
DECLARE @HASCCodeSite nvarchar(200)
DECLARE @strSiteID nvarchar(10)
DECLARE @ShowAlphaNumeric BIT
--select name, idfsReference from fnReference('en',19000057) -- next number Type
--select name, idfsReference from fnReference('en',19000002) --subdivision Type

IF @NextNumberName IS NULL RETURN -1

IF ISNULL(@InstallationSite, 0) = 0 SELECT @InstallationSite=CAST(dbo.fnSiteOption('SiteID', N'') as bigint)
	
SELECT	@HASCCodeSite = substring(ISNULL(strHASCsiteID,N''), 3, 5),
		@strSiteID = strSiteID
FROM	tstSite
WHERE	idfsSite = @InstallationSite
SET @HASCCodeSite = ISNULL(@HASCCodeSite,'')
SET @strSiteID = ISNULL(@strSiteID,'')

SET @Year = Year(getdate())

SELECT 
	@NextID = ISNULL(intNumberValue,0),
	@Suffix=ISNULL(strSuffix,N''),
	@Prefix=ISNULL(strPrefix,N''),
	@MinNumberLength = ISNULL(intMinNumberLength, 5),
	@ShowPrefix = ISNULL(blnUsePrefix, 0),
	@ShowSiteID = ISNULL(blnUseSiteID, 0),
	@ShowYear = ISNULL(blnUseYear, 0),
	@ShowHASCCodeSite = ISNULL(blnUseHACSCodeSite, 0),
	@ShowAlphaNumeric = ISNULL(blnUseAlphaNumericValue, 0)
FROM	tstNextNumbers
WHERE	idfsNumberName = @NextNumberName

IF @@ROWCOUNT = 0 
BEGIN
	EXEC dbo.spNextNumbers_Init

	SELECT 
		@NextID = ISNULL(intNumberValue,0),
		@Suffix=ISNULL(strSuffix,N''),
		@Prefix=ISNULL(strPrefix,N''),
		@MinNumberLength = ISNULL(intMinNumberLength, 5),
		@ShowPrefix = ISNULL(blnUsePrefix, 0),
		@ShowSiteID = ISNULL(blnUseSiteID, 0),
		@ShowYear = ISNULL(blnUseYear, 0),
		@ShowHASCCodeSite = ISNULL(blnUseHACSCodeSite, 0),
		@ShowAlphaNumeric = ISNULL(blnUseAlphaNumericValue, 0)
	FROM	tstNextNumbers
	WHERE	idfsNumberName = @NextNumberName

	IF @@ROWCOUNT = 0 
	BEGIN
		SET @NextID = 0
		SET @Suffix = N''
		SET @Prefix = N'#'
		SET @MinNumberLength = 4
		SET @ShowPrefix = 1
		SET @ShowSiteID = 1
		SET @ShowYear = 1
		SET @ShowHASCCodeSite = 0
		SET @ShowAlphaNumeric = 1
	END
END
ELSE
BEGIN
	IF @ShowYear = 1
	BEGIN
		IF NOT EXISTS	(	
			SELECT * 
			FROM	tstNextNumbers
			WHERE	idfsNumberName = @NextNumberName
				AND intYear = @Year  
				) 
		UPDATE	tstNextNumbers
		SET	intNumberValue = 0,
			intYear = @Year
		WHERE	idfsNumberName = @NextNumberName
	END
END





BEGIN TRANSACTION 
BEGIN TRY

retry:

DECLARE @CheckNumber BIT 
DECLARE @AttemptCount INT
SET @CheckNumber=1
SET @AttemptCount = 0
--Restrict new unique next number search attempts by 1000 
WHILE @CheckNumber = 1 AND @AttemptCount < 1000
BEGIN
	IF @AttemptCount = 0 
		SET @NextID = @NextID + 1
	ELSE
		SET @NextID = @NextID + 100
	
	IF @ShowAlphaNumeric = 1 
		SET @NextNumberValue = dbo.fnAlphaNumeric(@NextID, @MinNumberLength)
	ELSE	
		SET @NextNumberValue = cast(@NextID as varchar(100))

	IF (@NextNumberValue IS NULL)
	BEGIN
		UPDATE tstNextNumbers 
		SET intMinNumberLength = @MinNumberLength + 1
			, intNumberValue = 0
		WHERE idfsNumberName = @NextNumberName
		
		SET @MinNumberLength = @MinNumberLength +1
		SET @NextID = 0 
	  
		GOTO retry
	END

	IF LEN(@NextNumberValue) > @MinNumberLength
	BEGIN
	   	RAISERROR ('Cannot generate new unique value.', 16, 1)
	END
	

	IF @MinNumberLength > 0 AND LEN(@NextNumberValue) < @MinNumberLength 
	BEGIN
		SET @NextNumberValue = 
		Replace(SPACE(@MinNumberLength - LEN(@NextNumberValue)) + @NextNumberValue ,N' ',0)
	END

	SET @NextNumberValue = @NextNumberValue + @Suffix
	IF @ShowYear = 1 SET @NextNumberValue = RIGHT(@Year,2) + @NextNumberValue
	IF @ShowSiteID = 1 
	BEGIN
		IF @ShowHASCCodeSite = 1
			SET @NextNumberValue = @HASCCodeSite + @NextNumberValue
		ELSE	
			SET @NextNumberValue = @strSiteID + @NextNumberValue
	END
	IF @ShowPrefix = 1 SET @NextNumberValue = @Prefix + @NextNumberValue

	DECLARE @CNT INT
	-----------------------Speciment Field Barcode-------------------------------------------------
	IF @NextNumberName = 10057019 --'SpecimentFieldBarcode'
	BEGIN
		IF NOT EXISTS (SELECT idfMaterial FROM  dbo.tlbMaterial WHERE strFieldBarcode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM  dbo.tlbMaterial
	END

	-----------------------Container(Specimen barcode is used for container)-----------------------
	ELSE IF @NextNumberName = 10057020 --N'Specimen'
	BEGIN
		IF NOT EXISTS (SELECT idfMaterial FROM  dbo.tlbMaterial WHERE strBarcode=@NextNumberValue)--??where strBarcode
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbMaterial
	END

	-----------------------Freezer ----------------------------------------------------------------
	ELSE IF @NextNumberName = 10057011 --N'nbtFreezerBarcode'
	BEGIN
		IF NOT EXISTS (SELECT idfFreezer FROM dbo.tlbFreezer WHERE strBarcode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbFreezer
	END

	-----------------------Freezer Box ------------------------------------------------------------
	ELSE IF @NextNumberName = 10057006 --N'nbtBoxBarcode'
	BEGIN
		IF NOT EXISTS (SELECT idfSubdivision FROM dbo.tlbFreezerSubdivision WHERE strBarcode=@NextNumberValue AND idfsSubdivisionType=39890000000)--'sbtBox'
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbFreezerSubdivision WHERE  idfsSubdivisionType= 39890000000--'sbtBox'
	END

	-----------------------Freezer Shelf ----------------------------------------------------------
	ELSE IF @NextNumberName = 10057012 --N'nbtFreezerShelfBarcode'
	BEGIN
		IF NOT EXISTS (SELECT idfSubdivision FROM dbo.tlbFreezerSubdivision WHERE strBarcode=@NextNumberValue AND idfsSubdivisionType=39900000000)--'Shelf'
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbFreezerSubdivision WHERE idfsSubdivisionType=39900000000--'sbtShelf'
	END

	-----------------------Human Case--------------------------------------------------------------
	ELSE IF @NextNumberName = 10057014 --N'nbtHumanCaseNumber'
	BEGIN
		IF NOT EXISTS (SELECT strCaseID FROM dbo.tlbHumanCase WHERE strCaseID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbHumanCase
	END

	-----------------------Human Aggregate Case-----------------------------------------------------
	ELSE IF @NextNumberName = 10057001 --N'nbtAggregateCaseNumber'
	BEGIN
		IF NOT EXISTS (SELECT idfAggrCase FROM dbo.tlbAggrCase WHERE strCaseID=@NextNumberValue )
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbAggrCase WHERE  idfsAggrCaseType= 0--'actAggregateCase'
	END
	-----------------------Vet Aggregate Action-----------------------------------------------------
	ELSE IF @NextNumberName = 10057002 --N'nbtVetAggregateAction'
	BEGIN
		IF NOT EXISTS (SELECT idfAggrCase FROM dbo.tlbAggrCase WHERE strCaseID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbAggrCase WHERE  idfsAggrCaseType= 0--'VetAggregateAction'
	END

	-----------------------Vet Aggregate Case-------------------------------------------------------
	ELSE IF @NextNumberName = 10057003 --N'nbtVetAggregateCase'
	BEGIN
		IF NOT EXISTS (SELECT idfAggrCase FROM dbo.tlbAggrCase WHERE strCaseID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbAggrCase WHERE  idfsAggrCaseType= 0--'VetAggregateCase'
	END
	-----------------------Vet Case-----------------------------------------------------------------
	ELSE IF @NextNumberName = 10057024 --N 'nbtVetCaseNumber' 
	BEGIN
		IF NOT EXISTS (SELECT strCaseID FROM dbo.tlbVetCase WHERE strCaseID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVetCase
	END

	-----------------------Vet Case Field Accession ID---------------------------------------------
	ELSE IF @NextNumberName = 10057025 --Vet Case Field Accession Number
	BEGIN
		IF NOT EXISTS (SELECT idfVetCase FROM dbo.tlbVetCase WHERE strFieldAccessionID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVetCase
	END

	-----------------------Outbreak-----------------------------------------------------------------
	ELSE IF @NextNumberName = 10057015 --N'nbtOutbreakNumber'
	BEGIN
		IF NOT EXISTS (SELECT idfOutbreak FROM dbo.tlbOutbreak WHERE strOutbreakID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM tlbOutbreak 
	END

	-----------------------Farm---------------------------------------------------------------------
	ELSE IF @NextNumberName = 10057010 --N'Farm'
	BEGIN
		IF NOT EXISTS (SELECT idfFarm FROM dbo.tlbFarm WHERE strFarmCode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM tlbFarm
	END
	-----------------------Batch Test --------------------------------------------------------------
	ELSE IF @NextNumberName = 10057005 --N'nbtBatchTest'
	BEGIN
		IF NOT EXISTS (SELECT idfBatchTest FROM dbo.tlbBatchTest WHERE strBarcode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbBatchTest
	END

	-----------------------Herd-------- ------------------------------------------------------------
	ELSE IF @NextNumberName = 10057013 --N'nbtHerdNumber'
	BEGIN
		IF NOT EXISTS (SELECT idfHerd FROM dbo.tlbHerd WHERE strHerdCode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbHerd
	END

	-----------------------Animal         ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057004--N'nbtAnimalNumber'
	BEGIN
		IF NOT EXISTS (SELECT idfAnimal FROM dbo.tlbAnimal WHERE strAnimalCode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbAnimal
	END

	-----------------------Sample Trasnfer         ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057026--N'nbtSampleTransfer'
	BEGIN
		IF NOT EXISTS (SELECT idfTransferOut FROM dbo.tlbTransferOUT WHERE strBarcode=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbTransferOUT
	END

	-----------------------AS Campaign         ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057027--N'nbtASCampaign'
	BEGIN
		IF NOT EXISTS (SELECT idfCampaign FROM dbo.tlbCampaign WHERE strCampaignID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbCampaign
	END
	-----------------------AS Session     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057028--N'nbtASSession'
	BEGIN
		IF NOT EXISTS (SELECT idfMonitoringSession FROM dbo.tlbMonitoringSession WHERE strMonitoringSessionID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbMonitoringSession
	END

	-----------------------Vector Surveillance Session     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057029
	BEGIN
		IF NOT EXISTS (SELECT idfVectorSurveillanceSession FROM dbo.tlbVectorSurveillanceSession WHERE strSessionID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVectorSurveillanceSession
	END

	-----------------------Vector Surveillance Vector     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057030
	BEGIN
		IF NOT EXISTS (SELECT idfVector FROM dbo.tlbVector WHERE strVectorID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVector
	END

	-----------------------Vector Surveillance Summary Vector     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057031
	BEGIN
		IF NOT EXISTS (SELECT idfsVSSessionSummary FROM dbo.tlbVectorSurveillanceSessionSummary WHERE strVSSessionSummaryID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVectorSurveillanceSessionSummary
	END

	-----------------------Vector Surveillance Summary Vector     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057031
	BEGIN
		IF NOT EXISTS (SELECT idfsVSSessionSummary FROM dbo.tlbVectorSurveillanceSessionSummary WHERE strVSSessionSummaryID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbVectorSurveillanceSessionSummary
	END

	-----------------------Basic Syndromic Surveillance Form     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057032
	BEGIN
		IF NOT EXISTS (SELECT idfBasicSyndromicSurveillance FROM dbo.tlbBasicSyndromicSurveillance WHERE strFormID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbBasicSyndromicSurveillance
	END

	-----------------------Basic Syndromic Surveillance Aggregate Form     ---------------------------------------------------------
	ELSE IF @NextNumberName = 10057033
	BEGIN
		IF NOT EXISTS (SELECT idfAggregateHeader FROM dbo.tlbBasicSyndromicSurveillanceAggregateHeader WHERE strFormID=@NextNumberValue)
			BREAK
		IF @AttemptCount = 0 
			SELECT @CNT = COUNT(*) FROM dbo.tlbBasicSyndromicSurveillanceAggregateHeader
	END

	-----------------------Penside Test ------------------------------------------------------------
--	ELSE IF @NextNumberName = 10057022--N'Penside Test'
--	BEGIN
--		IF NOT EXISTS (SELECT idfPensideTest FROM dbo.tlbPensideTest WHERE strFieldSampleID=@NextNumberValue)
--			BREAK
--		IF @AttemptCount = 0 
--			SELECT @CNT = COUNT(*) FROM dbo.tlbPensideTest
--	END
	ELSE
		SET @CheckNumber = 0
	IF @AttemptCount =0 AND NOT @CNT IS NULL
		SET @NextID = @CNT+1
	SET @AttemptCount = @AttemptCount + 1
END

IF @AttemptCount<1000
BEGIN
	UPDATE	tstNextNumbers
	SET	intNumberValue = @NextID
	WHERE 	idfsNumberName = @NextNumberName
	COMMIT TRAN
	RETURN 0
END
END TRY
--
BEGIN CATCH
    IF (XACT_STATE()) = -1
    BEGIN
        PRINT
            N'The transaction is in an uncommittable state. ' +
            'Rolling back transaction.'
        ROLLBACK TRAN;
    END
	ELSE IF  (XACT_STATE()) = 1
	BEGIN
		IF @@TRANCOUNT < 2
			ROLLBACK TRAN 
		ELSE
			COMMIT TRAN
	END

IF @AttemptCount>=100
BEGIN 
	RAISERROR ('Can''t generate new number', 16, 1)
END
ELSE 
	RAISERROR ('Unknown error during generating new number', 16, 1)
DECLARE @strNextNumberName AS VARCHAR(200)
SET @strNextNumberName = CAST(@NextNumberName AS VARCHAR)
RAISERROR ('NumberType:%s' , 16, 1, @strNextNumberName)
 

RETURN -1
END CATCH

