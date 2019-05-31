
--*************************************************************
-- Name: [USP_OMM_Session_GetList]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_GetDetail]
(    
	@LangID			nvarchar(50),
	@idfOutbreak	BIGINT
)
AS



BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SELECT
			idfOutbreak,
			idfsDiagnosisOrDiagnosisGroup,
			D.name AS [strDiagnosis],
			idfsOutbreakStatus,
			os.strDefault as strOutbreakStatus,
			OutbreakTypeId,
			ot.strDefault as strOutbreakType,
			geo.idfsCountry,
			geo.idfsRegion,
			geo.idfsRayon,
			geo.idfsSettlement,  
			geo.strStreetName,
			geo.strPostCode, 
			geo.strBuilding,
			geo.strHouse,		   
			geo.strApartment,
			Region.name AS Region,
			Rayon.name AS Rayon, 
			datStartDate,
			datFinishDate As datCloseDate,
			strOutbreakID,
			o.strDescription,
			o.intRowStatus,
			o.rowguid,
			o.datModificationForArchiveDate,
			idfPrimaryCaseOrSession,
			o.idfsSite,
			o.strMaintenanceFlag,
			o.strReservedAttribute

		FROM
			tlbOutbreak o
		LEFT JOIN							dbo.tlbGeoLocation geo 
		ON									o.idfGeoLocation = geo.idfGeoLocation
		LEFT JOIN							FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
		ON									Rayon.idfsReference = geo.idfsRayon
		LEFT JOIN							FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON									Region.idfsReference = geo.idfsRegion
		LEFT JOIN							dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
		ON									Settlement.idfsReference = geo.idfsSettlement
		INNER JOIN							dbo.FN_GBL_Reference_GETList(@LangID, 19000019) D
		ON									D.idfsReference = o.idfsDiagnosisOrDiagnosisGroup
		INNER JOIN							dbo.FN_GBL_Reference_GETList(@LangID,19000063) os
		ON									os.idfsReference = o.idfsOutbreakStatus
		INNER JOIN							dbo.FN_GBL_Reference_GETList(@LangID,19000513) ot
		ON									ot.idfsReference = o.OutbreakTypeId
		WHERE
			idfOutbreak = @idfOutbreak;
			
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		SET		@returnCode = ERROR_NUMBER();
		SET		@returnMsg = 
					'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
					+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
					+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
					+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
					+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
					+ ' ErrorMessage: '+ ERROR_MESSAGE();
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

END