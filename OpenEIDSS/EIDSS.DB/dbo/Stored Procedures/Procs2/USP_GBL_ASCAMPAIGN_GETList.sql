
--*************************************************************
-- Name 				: USP_GBL_ASCAMPAIGN_GETList
-- Description			: SELECTs data for Active Surveillance Campaign form
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name		Date		Change Detail
--		m.jessee	20180425	revised to include campaign category to distinguish between human and veterinary
--      VThomas	   5/25/2018   Update the ReferenceType key from 19000168 to 19000501 for 'Campaign Category'
-- Stephen Long     05/31/2018 Removed left join of CampaignToSampleType 
--                             and associated fields as this was causing 
--                             duplicates on campaigns that have 
--                             multiple records on CampaignTo
--                             SampleType.  Added those as 
--                             separate sub-selects.
--		MKulkarni	06/07/2018 Added filter criteria for disease
--Arnold Kennedy    01-07-19   added Return Code and Return Message columns for API
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_ASCAMPAIGN_GETList]
(  
	@CampaignStrIDFilter		NVARCHAR(200), -- strCampaignId
	@CampaignNameFilter			NVARCHAR(200), -- Campaign Name
	@CampaignTypedFilter		BIGINT,
	@CampaignStatusFilter		BIGINT,
	@StartDateFromFilter		DATETIME,
	@StartToFilter				DATETIME,
	@CampaignDiseaseFilter		BIGINT,
 	@LangID						NVARCHAR(50),	--##PARAM @LangID - language ID  
	@CampaignModule 			NVARCHAR(100)	-- expected values are: Vet , Human
)  
AS  

DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
DECLARE @returnCode				BIGINT = 0;
DECLARE @CampaignCategory		NVARCHAR (100);

BEGIN
	BEGIN TRY  	
		--	set campaign category value based on input campaign module
		SET						@CampaignCategory =
									CASE UPPER ( @CampaignModule )
										WHEN UPPER ( 'Human' ) THEN  'Human Active Surveillance Campaign'
										WHEN UPPER ( 'Vet'	 ) THEN  'Veterinary Active Surveillance Campaign'
										ELSE '-1'
									END;

		IF @CampaignCategory = '-1' 
			BEGIN
				RAISERROR			('Invalid Campaign Module', 16, 1);
				RETURN;
			END

		-- 0- Campaign  
		SELECT						tc.idfCampaign,  
									idfsCampaignType,
									CampaignType.name As CampaignType,
									idfsCampaignStatus,  
									CampaignStatus.name As CampaignStatus,
									tc.idfsDiagnosis,
									Diagnosis.name As Diagnosis,
									SpeciesList = STUFF --Used in expanded details of campaign search results as per use case.
									(
										(
											SELECT			', ' + speciesType.name 
											FROM			dbo.CampaignToSampleType cst
											INNER JOIN		FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
											ON				speciesType.idfsReference = cst.idfsSpeciesType 
											WHERE			cst.idfCampaign = tc.idfCampaign  
											GROUP BY speciesType.name
											FOR XML PATH(''), TYPE
										).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''
									), 
									SampleTypesList = STUFF --Used in expanded details of campaign search results as per use case.
									(
										(
											SELECT			', ' + sampleType.name 
											FROM			dbo.CampaignToSampleType cst
											INNER JOIN		dbo.FN_GBL_ReferenceRepair(@LangID, 19000087) sampleType 
											ON				sampleType.idfsReference= cst.idfsSampleType
											WHERE			cst.idfCampaign = tc.idfCampaign  
											GROUP BY		sampleType.name
											FOR XML PATH(''), TYPE
										).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''
									), 
									tc.datCampaignDateStart,  
									tc.datCampaignDateEND,  
									tc.strCampaignID,  
									tc.strCampaignName,  
									tc.strCampaignAdministrator,  
									tc.strComments,  
									tc.strConclusion,
									tc.CampaignCategoryID
		FROM						dbo.tlbCampaign  tc
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangID, 19000115) CampaignStatus ON
									tc.idfsCampaignStatus = CampaignStatus.idfsReference
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangID, 19000116) CampaignType ON
									tc.idfsCampaignType = CampaignType.idfsReference
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangID, 19000019) diagnosis ON
									tc.idfsDiagnosis = diagnosis.idfsReference AND diagnosis.intRowStatus = 0 
		WHERE						
		(							
									(CASE WHEN @CampaignStrIDFilter IS NULL THEN 1 WHEN ISNULL(tc.strCampaignID,'') LIKE '%' + @CampaignStrIDFilter +'%' THEN 1 WHEN tc.strCampaignID = @CampaignStrIDFilter THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @CampaignNameFilter IS NULL THEN 1 WHEN ISNULL(tc.strCampaignName,'') LIKE '%' + @CampaignNameFilter +'%' THEN 1 WHEN tc.strCampaignName = @CampaignNameFilter THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @CampaignTypedFilter IS NULL THEN 1 WHEN ISNULL(tc.idfsCampaignType,'') = @CampaignTypedFilter THEN 1 WHEN tc.idfsCampaignType = @CampaignTypedFilter THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @CampaignStatusFilter IS NULL THEN 1 WHEN ISNULL(tc.idfsCampaignStatus,'') = @CampaignStatusFilter THEN 1 WHEN tc.idfsCampaignStatus = @CampaignStatusFilter THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @CampaignDiseaseFilter IS NULL THEN 1 WHEN ISNULL(tc.idfsDiagnosis,'') = @CampaignDiseaseFilter THEN 1 WHEN tc.idfsDiagnosis = @CampaignDiseaseFilter THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @StartDateFromFilter IS NULL THEN 1 WHEN datCampaignDateStart >= (CASE ISNULL(@StartDateFromFilter, '') WHEN '' THEN datCampaignDateStart ELSE @StartDateFromFilter END) THEN 1 ELSE 0 END = 1)
			AND						(CASE WHEN @StartToFilter IS NULL THEN 1 WHEN datCampaignDateStart <= (CASE ISNULL(@StartToFilter, '') WHEN '' THEN datCampaignDateStart ELSE @StartToFilter END) THEN 1 ELSE 0 END = 1)
			--Leaving the following in here until QA testing shows that this works. If this is into the first week of August 2018...then delete it.
			--AND						datCampaignDateStart >= CASE ISNULL(@StartDateFromFilter, '') WHEN '' THEN datCampaignDateStart ELSE @StartDateFromFilter END
			--AND						datCampaignDateStart <= CASE ISNULL(@StartToFilter, '') WHEN '' THEN datCampaignDateStart ELSE @StartToFilter END
			AND						tc.intRowStatus = 0  
			AND						tc.CampaignCategoryID = (SELECT idfsReference FROM dbo.FN_GBL_ReferenceRepair('en', 19000168) WHERE strDefault = @CampaignCategory)
		)

	END TRY  
	BEGIN CATCH 

	Throw;

	END CATCH
END


