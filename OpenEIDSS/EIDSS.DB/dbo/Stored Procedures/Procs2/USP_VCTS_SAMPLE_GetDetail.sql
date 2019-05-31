
--*************************************************************
-- Name 				: USP_VCTS_SAMPLE_GetDetail
-- Description			: Get Vector Surveillance Sample details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor 5/9/2018   Updated to pass in @idfMaterial parameter 
--  Harold Pryor 5/16/2018  Updated to return strCondition
--  Harold Pryor 5/20/2018  Updated to return strFieldCollectedByOffice
--
-- Testing code:
--EXECUTE USP_VCTS_SAMPLE_GetDetail @idfMaterial, @idfVector,'en'
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_SAMPLE_GetDetail]
(
	@idfMaterial	BIGINT,
	@idfVector	BIGINT,
	@LangID		NVARCHAR(50)
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

		SELECT		
					Samples.idfVector
					,Vector.idfsVectorType
					,Vector.idfsVectorSubType
					,Samples.idfMaterial 
					,Samples.strBarcode -- Lab sample ID
					,Samples.strFieldBarcode -- Field Sample ID
					,Samples.idfsSampleType
					,SampleType.name AS strSampleName
					,Samples.datFieldCollectionDate
					,Samples.idfSendToOffice
					,OfficeSendTo.[name] as strSendToOffice
					,Samples.idfFieldCollectedByOffice
					,CollectedByOffice.name as strFieldCollectedByOffice
					,Samples.datFieldSentDate
					,Samples.strNote
					,Samples.datAccession
					,Samples.idfsAccessionCondition
					,Samples.strCondition
					,ISNULL(Samples.idfHumanCase, Samples.idfVetCase) AS idfCase
					,Samples.idfVectorSurveillanceSession
					,ISNULL(VectorType.[name], VectorType.strDefault) AS [strVectorTypeName]
					,ISNULL(VectorSubType.[name], VectorSubType.strDefault) AS [strVectorSubTypeName]
					,Location.idfsRegion
					,ISNULL(Region.[name], Region.strDefault) AS [strRegionName]
					,Location.idfsRayon
					,ISNULL(Rayon.[name], Rayon.strDefault) AS [strRayonName]
					,Vector.intQuantity
					,Vector.datCollectionDateTime
					,Vector.strVectorID
					,Samples.blnAccessioned AS Used

		FROM		dbo.tlbMaterial Samples 

		INNER JOIN	dbo.tlbVector Vector ON Samples.idfVector = Vector.idfVector 
		LEFT JOIN	dbo.FN_GBL_Reference_GETList(@LangID, 19000140) VectorType ON Vector.idfsVectorType = VectorType.idfsReference
		LEFT JOIN	dbo.FN_GBL_Reference_GETList(@LangID, 19000141) VectorSubType ON Vector.idfsVectorSubType = VectorSubType.idfsReference
		LEFT JOIN	dbo.tlbGeoLocation Location	ON Location.idfGeoLocation = Vector.idfLocation

		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000087) SampleType ON	SampleType.idfsReference = Samples.idfsSampleType
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID,19000003) Region ON Region.idfsReference = Location.idfsRegion
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID,19000002) Rayon ON	Rayon.idfsReference = Location.idfsRayon
		LEFT JOIN	tlbMaterial ParentSample ON	ParentSample.idfMaterial = Samples.idfParentMaterial AND ParentSample.intRowStatus = 0
		LEFT JOIN	dbo.FN_GBL_INSTITUTION(@LangID) AS CollectedByOffice ON CollectedByOffice.idfOffice = Samples.idfFieldCollectedByOffice
		LEFT JOIN	dbo.FN_GBL_INSTITUTION(@LangID) AS OfficeSendTo ON OfficeSendTo.idfOffice = Samples.idfSendToOffice

		WHERE		Samples.blnShowInCaseOrSession = 1 AND Samples.idfVector = @idfVector
		AND			Samples.intRowStatus = 0
		AND NOT		(ISNULL(Samples.idfsSampleKind,0) = 12675420000000/*derivative*/ AND (ISNULL(Samples.idfsSampleStatus,0) = 10015002 or ISNULL(Samples.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
		and Samples.idfMaterial = @idfMaterial


		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
END
