

--*************************************************************
-- Name: [USP_ILI_Aggregate_GetList]
-- Description: Get ILI Aggregate list for the ILI Aggregate use cases
--          
-- Author: Arnold Kennedy
-- Revision History
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Arnold Kennedy    03/21/2019 Initial release.
--Arnold Kennedy	04/16/2019  Updates for details added
--  EXEC USP_ILI_Aggregate_GetList @LangID= 'en', @idfAggregateHeader = 1, @idfHospital = 1, @datStartDate = GETDATE(), @datFinishDate=DATEADD(day, 14, datStartDate)
--
-- 
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ILI_Aggregate_GetList]
(    
	@LangID	NVARCHAR(50),
	@strFormID	NVARCHAR(200),
	@idfAggregateHeader	 BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@idfHospital BIGINT = NULL,
	@datStartDate DATETIME = NULL,
	@datFinishDate DATETIME = NULL


)
AS

BEGIN    

	DECLARE	@returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		
		SELECT 
			AG.idfAggregateHeader,
			AG.strFormID,
			AG.datDateEntered,
			AG.datDateLastSaved,
			AG.idfEnteredBy,
			AG.idfsSite AS OrganizationID,
			P.strFirstName + ' ' + P.strFamilyName AS UserName,
			B.strDefault AS Organization,
			HR.strDefault AS HospitalName,
			AD.idfHospital AS idfHospital,
			AG.intYear,
			AG.intWeek,
			AG.datStartDate,
			AG.datFinishDate,
			AG.SourceSystemNameID, -- I don't think this is necessary.  This will have no meaning to the application
			AD.intAge0_4,
			AD.intAge5_14,
			AD.intAge15_29,
			AD.intAge30_64,
			AD.intAge65,
			AD.inTotalILI,
			AD.intTotalAdmissions,
			AD.intILISamples

		FROM tlbBasicSyndromicSurveillanceAggregateHeader AG
		LEFT JOIN tlbPerson P ON P.idfPerson = AG.idfEnteredBy
		LEFT JOIN tlbOffice O ON O.idfOffice = P.idfInstitution
		LEFT JOIN trtBaseReference B ON B.idfsBaseReference = O.idfsOfficeAbbreviation
		LEFT JOIN trtBaseReference UP ON UP.idfsBaseReference = AG.SourceSystemNameID
		LEFT JOIN tlbBasicSyndromicSurveillanceAggregateDetail AD ON AG.idfAggregateHeader = AD.idfAggregateHeader
		LEFT JOIN tlbOffice Hospital ON Hospital.idfOffice = @idfHospital
		LEFT JOIN dbo.trtBaseReference HR ON Hospital.idfsOfficeName = HR.idfsBaseReference
		
		WHERE (@idfAggregateHeader IS NULL OR AG.idfAggregateHeader = @idfAggregateHeader OR @idfAggregateHeader =0)
		AND ((AG.strFormID LIKE '%' + @strFormID +'%' OR @strFormID IS NULL OR @strFormID = '' ) 
		--	 OR (AG.datFinishDate >= @datStartDate AND AG.datStartDate <= @datFinishDate)
		--	 OR (@datStartDate IS NULL AND @datFinishDate IS NULL)

			)
		AND	AG.intRowStatus = 0
		
	END TRY
	BEGIN CATCH
		ROLLBACK
		SET @returnCode = ERROR_NUMBER()
		SET @returnMsg = 
		'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
		+ ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
		+ ' ErrorState: ' + convert(varchar,ERROR_STATE())
		+ ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
		+ ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
		+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SELECT @returnCode, @returnMsg
	END CATCH


END
