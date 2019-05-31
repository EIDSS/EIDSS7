

--*************************************************************
-- Name 				: USP_GBL_ASCAMPAIGN_GETDetail
-- Description			: SELECTs data for Active Surveillance Campaign form
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name        Date        Change Detail
--		m.jessee	20180426	revised to GBL usage
--      VThomas	   5/25/2018   Update the ReferenceType key from 19000169 to 19000502 for 'Session Categorye'
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_ASCAMPAIGN_GETDetail]
(  
	@idfCampaign			AS	BIGINT,--##PARAM @idfCampaign - campaign ID  
 	@LangID					AS NVARCHAR(50)--##PARAM @LangID - language ID  
)  
AS  
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	
		-- 0- Campaign  
		SELECT	tc.idfCampaign,  
				tc.idfsCampaignType,
				CampaignType.name As CampaignType,
				tc.idfsCampaignStatus,  
				CampaignStatus.name As CampaignStatus,
				tc.datCampaignDateStart,  
				tc.datCampaignDateEND,  
				tc.strCampaignID,  
				tc.strCampaignName,  
				tc.strCampaignAdministrator,  
				tc.strComments,  
				tc.strConclusion,
				tc.idfsDiagnosis,
				Diagnosis.name AS Diagnosis,
				tc.CampaignCategoryID
		FROM	dbo.tlbCampaign  tc
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000115) CampaignStatus ON
					tc.idfsCampaignStatus = CampaignStatus.idfsReference
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000116) CampaignType ON
					tc.idfsCampaignType = CampaignType.idfsReference
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000019) diagnosis ON
					tc.idfsDiagnosis = diagnosis.idfsReference and diagnosis.intRowStatus = 0 
		WHERE	tc.idfCampaign = @idfCampaign
		AND		tc.intRowStatus = 0  
  
		  --1 Sample Types  
  
		SELECT	cts.idfCampaign, 
				cts.CampaignToSampleTypeUID,
				cts.intOrder,
				idfsSpeciesType,
				SpeciesType.name AS SpeciesType,
				cts.intPlannedNumber, 
				cts.idfsSampleType,
				SampleType.name AS sampleType,
				dbo.FN_VCT_ASCampaign_HASSESSION(@idfCampaign, cts.CampaignToSampleTypeUID) AS HasOpenSession
		FROM	dbo.CampaignToSampleType  cts
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000087) SampleType ON
					cts.idfsSampleType = SampleType.idfsReference
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000086) SpeciesType ON
					cts.idfsSpeciesType = SpeciesType.idfsReference
		WHERE	idfCampaign = @idfCampaign  
		AND		cts.intRowStatus = 0  
		ORDER BY cts.intOrder  

		-- 2 Monitoring Sessions
		SELECT	tms.idfMonitoringSession,
				tms.idfsMonitoringSessionStatus,
				SessionStatus.name AS SessionStatus,
				tms.idfCampaign,
				tms.idfsCountry,
				Country.name AS Country,
				tms.idfsRegion,
				Region.name AS Region,
				tms.idfsRayon,
				Rayon.name AS Rayon,
				tms.idfsSettlement,
				Settlement.name AS Settlement,
				tms.idfPersonEnteredBy,
				ISNULL(Person.strFirstName, '') + ' ' + ISNULL(Person.strFamilyName, '') As PersonEnteredBy,
				tms.datEnteredDate,
				tms.strMonitoringSessionID,
				tms.datStartDate,
				tms.datEndDate,
				tms.idfsDiagnosis,
				Diagnosis.strDefault AS Diagnosis,
				tms.SessionCategoryID,
				SessionCategory.name AS SessionCategory
		FROM	dbo.tlbMonitoringSession tms
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000117) SessionStatus ON 
					SessionStatus.idfsReference = tms.idfsMonitoringSessionStatus
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID, 19000001) Country ON 
					Country.idfsReference = tms.idfsCountry
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID, 19000003) Region ON 
					Region.idfsReference = tms.idfsRegion
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID, 19000002) Rayon ON 
					Rayon.idfsReference = tms.idfsRayon
		LEFT JOIN	FN_GBL_GIS_Reference(@LangID, 19000004) Settlement ON 
					Settlement.idfsReference = tms.idfsSettlement
		LEFT JOIN	dbo.tlbPerson Person ON
					person.idfPerson = tms.idfPersonEnteredBy
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000019) Diagnosis ON 
					Diagnosis.idfsReference = tms.idfsDiagnosis
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000502) SessionCategory ON
					SessionCategory.idfsReference = tms.SessionCategoryID
		WHERE		tms.idfCampaign = @idfCampaign
		AND			tms.intRowStatus = 0

		-- 3 Monitoring Session Sameple Types
		SELECT		msts.MonitoringSessionToSampleType,
					msts.idfMonitoringSession,
					msts.idfsSpeciesType,
					SpeciesType.name As SpeciesType,
					msts.idfsSampleType,
					SampleType.name AS SampleType,
					msts.intOrder
		FROM		dbo.MonitoringSessionToSampleType msts
		INNER JOIN	dbo.tlbMonitoringSession ms ON
					ms.idfMonitoringSession = msts.idfMonitoringSession
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000087) SampleType ON
					SampleType.idfsReference = msts.idfsSampleType
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000086) SpeciesType ON
					SpeciesType.idfsReference= SampleType.idfsReference
		WHERE		ms.idfCampaign = @idfCampaign
		AND			msts.intRowStatus = 0
		
		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 
		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()
		SELECT @returnCode, @returnMsg
	END CATCH
END


