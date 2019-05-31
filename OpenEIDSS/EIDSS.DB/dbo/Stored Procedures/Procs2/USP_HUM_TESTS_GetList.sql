--*************************************************************
-- Name 				: USP_HUM_TESTS_GetList
-- Description			: List Human Disease Report TESTS by hcid
--          
-- Author               : JWJ
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				20180603		created 
-- HAP				20181105		Added strTestResult field to result set 
-- HAP              20181109		Added TestValidation fields to result set 
-- HAP              20181203        Added strInterpretedStatus field to result set
--
-- Testing code:
-- EXEC USP_HUM_TESTS_GetList 'en', @idfHumanCase=19  --10
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_TESTS_GetList] 
	@LangID							NVARCHAR(50) , --##PARAM @LangID - language ID
	@idfHumanCase					BIGINT = NULL,
	@SearchDiagnosis 				BIGINT = NULL
AS
Begin
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;
 
BEGIN TRY  
		SELECT		
					Samples.idfHumanCase
					,Samples.idfMaterial 
					,Samples.strBarcode -- Lab sample ID
					,Samples.strFieldBarcode -- Local Sample ID
					,Samples.idfsSampleType
					,SampleType.name AS strSampleTypeName

					,Samples.datFieldCollectionDate
					,Samples.idfSendToOffice
					,OfficeSendTo.[name] as strSendToOffice
					,Samples.idfFieldCollectedByOffice
					,CollectedByOffice.name as strFieldCollectedByOffice
					,Samples.datFieldSentDate
					----,Samples.strNote
					----,Samples.datAccession			--verify this is date received
					----,Samples.idfsAccessionCondition
					----,Samples.strCondition
					----,Location.idfsRegion as idfsRegion
					----,ISNULL(Region.[name], Region.strDefault) AS [strRegionName]
					----,Location.idfsRayon as idfsRayon
					----,ISNULL(Rayon.[name], Rayon.strDefault) AS [strRayonName]
					----,Samples.blnAccessioned
					----,'' as RecordAction
					,Samples.idfsSampleKind
					,sampleKind.name AS SampleKindTypeName
					--find stridfsSampleKind
					--find strTestDiagnosis and it's id
					,Samples.idfsSampleStatus
					,sampleStatus.name AS SampleStatusTypeName
					,Samples.idfFieldCollectedByPerson  
					--,find strFieldCollectedByPerson   --verify this is the employee
					,Samples.datSampleStatusDate   --verify this is the result date
					,Samples.rowGuid as sampleGuid

					, t.idfTesting
					, t.idfsTestName
					, t.idfsTestCategory
					, t.idfsTestResult
					, t.idfsTestStatus
					, t.idfsDiagnosis
					, tstatus.name as strTestStatus
					, tresult.name as strTestResult

					, TestName.name
					, t.datReceivedDate
					, t.datConcludedDate
					, t.idfTestedByPerson
					, t.idfTestedByOffice
					, isnull(tv.datInterpretationDate, getDate()) as datInterpretedDate
					, tv.idfsInterpretedStatus
					, InterpretedStatus.name as strInterpretedStatus
					, tv.strInterpretedComment
					, p.strFamilyName as strInterpretedBy
					, isnull(tv.datValidationDate, getDate()) as datValidationDate
					, isnull(tv.blnValidateStatus,0) as blnValidateStatus
					, tv.strValidateComment
					, p.strFamilyName as strValidatedBy
					, u.strAccountName
					, t.rowGuid as testGuid
					, t.intRowStatus					  

		FROM		dbo.tlbMaterial Samples 
		INNER JOIN	dbo.tlbHumanCase as hc ON Samples.idfHumanCase  = hc.idfHumanCase 		 
		LEFT JOIN	dbo.tlbGeoLocation as Location	ON Location.idfGeoLocation = hc.idfPointGeoLocation
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000087) SampleType ON	SampleType.idfsReference = Samples.idfsSampleType
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID,19000003) Region ON Region.idfsReference = Location.idfsRegion
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID,19000002) Rayon ON	Rayon.idfsReference = Location.idfsRayon
		LEFT JOIN	tlbMaterial ParentSample ON	ParentSample.idfMaterial = Samples.idfParentMaterial AND ParentSample.intRowStatus = 0
		LEFT JOIN	dbo.FN_GBL_INSTITUTION(@LangID) AS CollectedByOffice ON CollectedByOffice.idfOffice = Samples.idfFieldCollectedByOffice
		LEFT JOIN	dbo.FN_GBL_INSTITUTION(@LangID) AS OfficeSendTo ON OfficeSendTo.idfOffice = Samples.idfSendToOffice
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000158) AS sampleKind	ON sampleKind.idfsReference = Samples.idfsSampleKind 
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000015) AS sampleStatus ON sampleStatus.idfsReference = Samples.idfsSampleStatus 

		LEFT JOIN	dbo.tlbTesting t ON t.idfMaterial = Samples.idfMaterial AND t.intRowStatus = 0
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000097) TestName ON	TestName.idfsReference = t.idfsTestName

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000001) tstatus
		ON			tstatus.idfsReference = t.idfsTestStatus
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000096) tresult		
		ON			tresult	.idfsReference = t.idfsTestResult
		LEFT JOIN   dbo.tlbTestValidation as tv on  tv.idfTesting = t.idfTesting AND tv.intRowStatus = 0
		LEFT JOIN   dbo.tstUserTable u on (tv.idfInterpretedByPerson = u.idfPerson or tv.idfValidatedByPerson = u.idfPerson) and u.intRowStatus = 0 
		LEFT JOIN   dbo.tlbPerson p on (p.idfPerson = tv.idfInterpretedByPerson or p.idfPerson = tv.idfValidatedByPerson) and p.intRowStatus = 0
		LEFT JOIN   FN_GBL_ReferenceRepair(@LangID, 19000106) InterpretedStatus ON InterpretedStatus.idfsReference = tv.idfsInterpretedStatus 

		WHERE		
		--Samples.blnShowInCaseOrSession = 1 
		--AND 
		Samples.idfHumanCase = @idfHumanCase
		AND	Samples.intRowStatus = 0
		AND t.intRowStatus = 0
		--AND NOT	(ISNULL(Samples.idfsSampleKind,0) = 12675420000000/*derivative*/ 
		--AND (ISNULL(Samples.idfsSampleStatus,0) = 10015002 or ISNULL(Samples.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
		--optional param, filter samples by diagnosis: @SearchDiagnosis
		--AND	((idfsFinalDiagnosis = @SearchDiagnosis) OR (@SearchDiagnosis is null))




		SELECT	@returnCode, @returnMsg;



	END TRY  

	BEGIN CATCH 
		BEGIN
			SET @returnCode = ERROR_NUMBER();
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
				+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT @returnCode, @returnMsg;
		END
	END CATCH
END
