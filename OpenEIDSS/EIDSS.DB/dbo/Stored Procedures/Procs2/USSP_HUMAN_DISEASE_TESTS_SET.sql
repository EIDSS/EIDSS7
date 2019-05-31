
--*************************************************************
-- Name 				: USSP_HUMAN_DISEASE_TESTS_SET
-- Description			: add update delete Human Disease Report Tests
--          
-- Author               : JWJ
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				20180703		created 
-- HAP              20181109     Updated to include USSP_GBL_TEST_VALIDATION_SET
-- HAP              20181221     Changed @Tests parameter to NVARCHAR
--	LJM				2019/1/2	 Added @idfTesting to output in Select
-- HAP              20190129   Updated by Mark to fix Cannot insert the value NULL into column 'idfTesting', table 'EIDSS7_DT.dbo.tlbTestValidation' error
-- HAP              20190130   Removed call to USSP_GBL_TEST_VALIDATION_SET after Test Insert and replaced with Test Validation Insert query in this stored proc
-- Testing code:
-- exec USSP_HUMAN_DISEASE_TESTS_SET null
--*************************************************************
CREATE PROCEDURE [dbo].[USSP_HUMAN_DISEASE_TESTS_SET] 
		@idfHumanCase BIGINT = NULL,
		@TestsParameters	NVARCHAR(MAX) = NULL
AS
Begin
	SET NOCOUNT ON;
			Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
	DECLARE
--		@idfHumanCase	bigint
		@idfMaterial	bigint
		,@strBarcode	nvarchar(200)
		,@strFieldBarcode	nvarchar(200)
		,@idfsSampleType	bigint
		,@strSampleTypeName	nvarchar(2000)
		,@datFieldCollectionDate	datetime2
		,@idfSendToOffice	bigint
		,@strSendToOffice	nvarchar(2000)
		,@idfFieldCollectedByOffice	bigint
		,@strFieldCollectedByOffice	nvarchar(2000)
		,@datFieldSentDate	datetime2
		,@idfsSampleKind	bigint
		,@SampleKindTypeName	nvarchar(2000)
		,@idfsSampleStatus	bigint
		,@SampleStatusTypeName	nvarchar(2000)
		,@idfFieldCollectedByPerson	bigint
		,@datSampleStatusDate	datetime2
		,@sampleGuid	uniqueidentifier
		,@idfTesting	bigint
		,@idfTestingNew bigint
		,@idfsTestName	bigint
		,@idfsTestCategory	bigint
		,@idfsTestResult	bigint
		,@idfsTestStatus	bigint
		,@idfsDiagnosis	bigint
		,@strTestStatus	nvarchar(2000)
		,@name	nvarchar(2000)
		,@datReceivedDate	datetime2
		,@datConcludedDate	datetime2
		,@idfTestedByPerson	bigint
		,@idfTestedByOffice	bigint
		,@idfValidatedByOffice	bigint
		,@idfValidatedByPerson bigint
		,@idfInterpretedByOffice	bigint
		,@idfInterpretedByPerson	bigint
		,@blnCaseCreated bit
		,@idfsInterpretedStatus bigint
		,@strInterpretedComment nvarchar(2000)
		,@datInterpretedDate datetime2
		,@strInterpretedBy nvarchar(2000)
		,@blnValidateStatus bit
		,@strValidateComment nvarchar(2000)
		,@datValidationDate datetime2
		,@strValidatedBy nvarchar(2000)
		,@strAccountName nvarchar(2000)
		,@testGuid	uniqueidentifier
		,@intRowStatus	int
		,@idfTestValidation BIGINT = NULL


	DECLARE @returnCode	INT = 0;
	DECLARE @idfTestValidationTemp INT = null
	DECLARE @idfPersonTemp bigint = null
	DECLARE	@returnMsg	NVARCHAR(MAX) = 'SUCCESS';

	DECLARE	@TestsTemp AS TABLE(
	[idfHumanCase] [bigint] NULL,
	[idfMaterial] [bigint] NULL,
	[strBarcode] [nvarchar](200) NULL,
	[strFieldBarcode] [nvarchar](200) NULL,
	[idfsSampleType] [bigint] NULL,
	[strSampleTypeName] [nvarchar](2000) NULL,
	[datFieldCollectionDate] [datetime2] NULL,
	[idfSendToOffice] [bigint] NULL,
	[strSendToOffice] [nvarchar](2000) NULL,
	[idfFieldCollectedByOffice] [bigint] NULL,
	[strFieldCollectedByOffice] [nvarchar](2000) NULL,
	[datFieldSentDate] [datetime2] NULL,
	[idfsSampleKind] [bigint] NULL,
	[SampleKindTypeName] [nvarchar](2000) NULL,
	[idfsSampleStatus] [bigint] NULL,
	[SampleStatusTypeName] [nvarchar](2000) NULL,
	[idfFieldCollectedByPerson] [bigint] NULL,
	[datSampleStatusDate] [datetime2] NULL,
	[sampleGuid] [uniqueidentifier] NULL,
	[idfTesting] [bigint] NULL,
	[idfsTestName] [bigint] NULL,
	[idfsTestCategory] [bigint] NULL,
	[idfsTestResult] [bigint] NULL,
	[idfsTestStatus] [bigint] NULL,
	[idfsDiagnosis] [bigint] NULL,
	[strTestStatus] [nvarchar](2000) NULL,
	[strTestResult] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[datReceivedDate] [datetime2] NULL,
	[datConcludedDate] [datetime2] NULL,
	[idfTestedByPerson] [bigint] NULL,
	[idfTestedByOffice] [bigint] NULL,
	[idfsInterpretedStatus] [bigint] NULL,
	[strInterpretedComment] [nvarchar](2000) NULL,
	[datInterpretedDate] [datetime2] NULL,
	[strInterpretedBy] [nvarchar](2000) NULL,
	[blnValidateStatus] [bit] NULL,
	[strValidateComment] [nvarchar](2000) NULL,
	[datValidationDate] [datetime2] NULL,
	[strValidatedBy] [nvarchar](2000) NULL,
	[strAccountName] [nvarchar](2000) NULL,
	[testGuid] [uniqueidentifier] NULL,
	[intRowStatus] [int] NULL
)
	
	INSERT INTO	@TestsTemp 
	SELECT * FROM OPENJSON(@TestsParameters) 
			WITH (
				[idfHumanCase] [bigint],
				[idfMaterial] [bigint],
				[strBarcode] [nvarchar](200),
				[strFieldBarcode] [nvarchar](200),
				[idfsSampleType] [bigint] ,
				[strSampleTypeName] [nvarchar](2000) ,
				[datFieldCollectionDate] [datetime2],
				[idfSendToOffice] [bigint],
				[strSendToOffice] [nvarchar](2000), 
				[idfFieldCollectedByOffice] [bigint],
				[strFieldCollectedByOffice] [nvarchar](2000),
				[datFieldSentDate] [datetime2],
				[idfsSampleKind] [bigint],
				[SampleKindTypeName] [nvarchar](2000),
				[idfsSampleStatus] [bigint],
				[SampleStatusTypeName] [nvarchar](2000),
				[idfFieldCollectedByPerson] [bigint],
				[datSampleStatusDate] [datetime2],
				[sampleGuid] [uniqueidentifier],
				[idfTesting] [bigint],
				[idfsTestName] [bigint],
				[idfsTestCategory] [bigint],
				[idfsTestResult] [bigint],
				[idfsTestStatus] [bigint],
				[idfsDiagnosis] [bigint],
				[strTestStatus] [nvarchar](2000),
				[strTestResult] [nvarchar](2000),
				[name] [nvarchar](2000),
				[datReceivedDate] [datetime2],
				[datConcludedDate] [datetime2],
				[idfTestedByPerson] [bigint],
				[idfTestedByOffice] [bigint],
				[idfsInterpretedStatus] [bigint],
				[strInterpretedComment] [nvarchar](2000),
				[datInterpretedDate] [datetime2],
				[strInterpretedBy] [nvarchar](2000),
				[blnValidateStatus] [bit],
				[strValidateComment] [nvarchar](2000),
				[datValidationDate] [datetime2],
				[strValidatedBy] [nvarchar](2000),
				[strAccountName] [nvarchar](2000),
				[testGuid] [uniqueidentifier],
				[intRowStatus] [int]
			) 

	BEGIN TRY  
		WHILE EXISTS (SELECT idfTesting FROM @TestsTemp)
			BEGIN
				SELECT TOP 1
					--@idfHumanCase=	idfHumanCase,
					@idfMaterial=	idfMaterial,
					--@strBarcode=	strBarcode,
					--@strFieldBarcode=	strFieldBarcode,
					--@idfsSampleType=	idfsSampleType,
					--@strSampleTypeName=	strSampleTypeName,
					--@datFieldCollectionDate=	datFieldCollectionDate,
					--@idfSendToOffice=	idfSendToOffice,
					--@strSendToOffice=	strSendToOffice,
					--@idfFieldCollectedByOffice=	idfFieldCollectedByOffice,
					--@strFieldCollectedByOffice=	strFieldCollectedByOffice,
					--@datFieldSentDate=	datFieldSentDate,
					--@idfsSampleKind=	idfsSampleKind,
					--@SampleKindTypeName=	SampleKindTypeName,
					--@idfsSampleStatus=	idfsSampleStatus,
					--@SampleStatusTypeName=	SampleStatusTypeName,
					--@idfFieldCollectedByPerson=	idfFieldCollectedByPerson,
					--@datSampleStatusDate=	datSampleStatusDate,
					@sampleGuid=	sampleGuid,
					@idfTesting=	idfTesting,
					@idfsTestName=	idfsTestName,
					@idfsTestCategory=	idfsTestCategory,
					@idfsTestResult=	idfsTestResult,
					@idfsTestStatus=	idfsTestStatus,
					@idfsDiagnosis=	idfsDiagnosis,
					--@strTestStatus=	strTestStatus,
					--@name=	name,
					@idfValidatedByOffice	=	null, 
					@idfValidatedByPerson	=	null, 
					@idfInterpretedByOffice	=	null, 
					@idfInterpretedByPerson	=	null, 
					@blnCaseCreated	=	null, 
					@datReceivedDate=	null,
					@datConcludedDate=	null,
					@idfTestedByPerson=	idfTestedByPerson,
					@idfTestedByOffice=	idfTestedByOffice,
					@idfsInterpretedStatus=	idfsInterpretedStatus,
					@strInterpretedComment=	strInterpretedComment,
					@datInterpretedDate=	datInterpretedDate,
					@strInterpretedBy=	strInterpretedBy,
					@blnValidateStatus=	blnValidateStatus,
					@strValidateComment= strValidateComment,
					@datValidationDate=	datValidationDate,
					@strValidatedBy=	strValidatedBy,
					@strAccountName=	strAccountName,
					@testGuid=	testGuid,
					@intRowStatus=	intRowStatus
									
				FROM @TestsTemp

			--get the sample id
			if (isnull(@idfMaterial,-1) < 0)  
			BEGIN
				--Print 'Watch this'
				SELECT @idfMaterial = idfMaterial FROM tlbMaterial WHERE rowGuid = @sampleGuid
				--Print 'idf Material is :  '  + CONVERT(varchar(100), @idfMaterial) 
			END

			IF NOT EXISTS(SELECT idfTesting from tlbTesting WHERE idfTesting = @idfTesting)
			BEGIN
		
					INSERT INTO @SupressSelect
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbTesting', @idfTestingNew OUTPUT;
		
					INSERT INTO	dbo.tlbTesting
					(						
						--idfHumanCase
						idfMaterial
						--,strBarcode
						--,strFieldBarcode
						--,idfsSampleType
						--,strSampleTypeName
						--,datFieldCollectionDate
						--,idfSendToOffice
						--,strSendToOffice
						--,idfFieldCollectedByOffice
						--,strFieldCollectedByOffice
						--,datFieldSentDate
						--,idfsSampleKind
						--,SampleKindTypeName
						--,idfsSampleStatus
						--,SampleStatusTypeName
						--,idfFieldCollectedByPerson
						--,datSampleStatusDate
						--,sampleGuid
						,idfTesting
						,idfsTestName
						,idfsTestCategory
						,idfsTestResult
						,idfsTestStatus
						,idfsDiagnosis
						--,strTestStatus
						--,name
						,datReceivedDate
						,datConcludedDate
						,idfTestedByPerson
						,idfTestedByOffice
						,rowGuid
						,intRowStatus
						,idfObservation
						,blnReadOnly
						,blnNonLaboratoryTest 

					)
					VALUES
					(
						--@idfHumanCase
						@idfMaterial
						--,@strBarcode
						--,@strFieldBarcode
						--,@idfsSampleType
						--,@strSampleTypeName
						--,@datFieldCollectionDate
						--,@idfSendToOffice
						--,@strSendToOffice
						--,@idfFieldCollectedByOffice
						--,@strFieldCollectedByOffice
						--,@datFieldSentDate
						--,@idfsSampleKind
						--,@SampleKindTypeName
						--,@idfsSampleStatus
						--,@SampleStatusTypeName
						--,@idfFieldCollectedByPerson
						--,@datSampleStatusDate
						--,@sampleGuid
						,@idfTestingNew
						,@idfsTestName
						,@idfsTestCategory
						,@idfsTestResult
						,@idfsTestStatus
						,@idfsDiagnosis
						--,@strTestStatus
						--,@name
						,@datReceivedDate
						,@datConcludedDate
						,@idfTestedByPerson
						,@idfTestedByOffice
						,@testGuid
						,@intRowStatus
						,0
						,0
						,0


					)
			

					-- TEST_VALIDATION	
					SELECT  @idfPersonTemp = P.IdfPerson from dbo.tlbPerson P 
					INNER JOIN tstUserTable U on U.IdfPerson = P.IdfPerson and strAccountName = @strAccountName
					--Print 'call  USSP_GBL_TEST_VALIDATION_SET after insert to tlbTesting' 
					Insert Into @SupressSelect
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbTestValidation', @idfTestValidation OUTPUT;

					INSERT INTO					dbo.tlbTestValidation
					(						
										idfTestValidation, 
										idfsDiagnosis, 
										idfsInterpretedStatus, 
										idfValidatedByOffice, 
										idfValidatedByPerson, 
										idfInterpretedByOffice,
										idfInterpretedByPerson, 
										idfTesting, 
										blnValidateStatus, 
										blnCaseCreated, 
										strValidateComment,
										strInterpretedComment,
										datValidationDate,
										datInterpretationDate,
										intRowStatus, 
										blnReadOnly, 
										strMaintenanceFlag
					)
					VALUES
					(
										
										@idfTestValidation, 
										@idfsDiagnosis, 
										@idfsInterpretedStatus, 
										@idfValidatedByOffice, 
										@idfPersonTemp, 
										@idfInterpretedByOffice, 
										@idfPersonTemp, 
										@idfTestingNew, 
										@blnValidateStatus, 
										@blnCaseCreated, 
										@strValidateComment,
										@strInterpretedComment,
										@datValidationDate, 
										@datInterpretedDate, 
										0, 
										0, 
										NULL
				);

			END
			ELSE
			BEGIN
					UPDATE dbo.tlbTesting
					SET 
						--idfHumanCase=	@idfHumanCase
						--idfMaterial=	@idfMaterial
						--,strBarcode=	@strBarcode
						--,strFieldBarcode=	@strFieldBarcode
						--,idfsSampleType=	@idfsSampleType
						--,strSampleTypeName=	@strSampleTypeName
						--,datFieldCollectionDate=	@datFieldCollectionDate
						--,idfSendToOffice=	@idfSendToOffice
						--,strSendToOffice=	@strSendToOffice
						--,idfFieldCollectedByOffice=	@idfFieldCollectedByOffice
						--,strFieldCollectedByOffice=	@strFieldCollectedByOffice
						--,datFieldSentDate=	@datFieldSentDate
						--,idfsSampleKind=	@idfsSampleKind
						--,SampleKindTypeName=	@SampleKindTypeName
						--,idfsSampleStatus=	@idfsSampleStatus
						--,SampleStatusTypeName=	@SampleStatusTypeName
						--,idfFieldCollectedByPerson=	@idfFieldCollectedByPerson
						--,datSampleStatusDate=	@datSampleStatusDate
						--,sampleGuid=	@sampleGuid
						--idfTesting=	@idfTesting
						idfsTestName=	@idfsTestName
						,idfsTestCategory=	@idfsTestCategory
						,idfsTestResult=	@idfsTestResult
						,idfsTestStatus=	@idfsTestStatus
						,idfsDiagnosis=	@idfsDiagnosis
						--,strTestStatus=	@strTestStatus
						--,name=	@name
						,datReceivedDate=	@datReceivedDate
						,datConcludedDate=	@datConcludedDate
						,idfTestedByPerson=	@idfTestedByPerson
						,idfTestedByOffice=	@idfTestedByOffice
						,rowGuid=	@testGuid
						,intRowStatus=	@intRowStatus
						,idfObservation=0
						,blnReadOnly = 0
						,blnNonLaboratoryTest = 0

					WHERE	idfTesting = @idfTesting;

					-- TEST_VALIDATION	
					Select @idfTestValidationTemp = idfTestValidation from dbo.tlbTestValidation where idfTesting = @idfTesting	
				
					IF NOT EXISTS(SELECT idfTestValidation from dbo.tlbTestValidation where idfTestValidation = @idfTestValidationTemp)

					BEGIN	
						--Print 'call  USSP_GBL_TEST_VALIDATION_SET after update to tlbTesting' + CONVERT(VARCHAR(MAX), @idfTesting)
						EXEC USSP_GBL_TEST_VALIDATION_SET	
							@LangID = NULL, 
							@idfTestValidation	= NULL, 
							@idfsDiagnosis	=					@idfsDiagnosis, 
							@idfsInterpretedStatus		=		@idfsInterpretedStatus, 
							@idfValidatedByOffice	=			@idfValidatedByOffice, 
							@idfValidatedByPerson	=			@idfPersonTemp, 
							@idfInterpretedByOffice	=			@idfInterpretedByOffice, 
							@idfInterpretedByPerson	=			@idfPersonTemp, 
							@idfTesting  =						@idfTesting	, 
							@blnValidateStatus	=				@blnValidateStatus, 
							@blnCaseCreated		=				@blnCaseCreated, 
							@strValidateComment		=			@strValidateComment	,
							@strInterpretedComment	=			@strInterpretedComment,
							@datValidationDate		=			@datValidationDate, 
							@datInterpretationDate	=			@datInterpretedDate, 
							@intRowStatus		=				0, 
							@blnReadOnly		=				0, 
							@strMaintenanceFlag		=			NULL, 
							@RecordAction		=				'I'

					END
					ELSE
					BEGIN
						EXEC USSP_GBL_TEST_VALIDATION_SET	
							@LangID = NULL, 
							@idfTestValidation = @idfTestValidationTemp, 
							@idfsDiagnosis	=					@idfsDiagnosis, 
							@idfsInterpretedStatus		=		@idfsInterpretedStatus, 
							@idfValidatedByOffice	=			@idfValidatedByOffice, 
							@idfValidatedByPerson	=			@idfValidatedByPerson, 
							@idfInterpretedByOffice	=			@idfInterpretedByOffice, 
							@idfInterpretedByPerson	=			@idfInterpretedByPerson, 
							@idfTesting  =						@idfTesting	, 
							@blnValidateStatus	=				@blnValidateStatus, 
							@blnCaseCreated		=				@blnCaseCreated, 
							@strValidateComment		=			@strValidateComment	,
							@strInterpretedComment	=			@strInterpretedComment,
							@datValidationDate		=			@datValidationDate, 
							@datInterpretationDate	=			@datInterpretedDate, 
							@intRowStatus		=				0, 
							@blnReadOnly		=				0, 
							@strMaintenanceFlag		=			NULL, 
							@RecordAction		=				'U'

					END					
			END
			DELETE FROM	@TestsTemp WHERE testGuid = @testGuid

	END		--end loop, WHILE EXISTS (SELECT * FROM @TestsTemp)


		--SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage',@idfTesting 'idfTesting';

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END

