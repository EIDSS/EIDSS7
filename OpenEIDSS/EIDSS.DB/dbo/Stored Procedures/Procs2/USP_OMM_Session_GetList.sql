
--*************************************************************
-- Name: [USP_OMM_Session_GetList]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--     Lamont Mitchell	1/9/19 Removed ReturnCode and Return Message
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_GetList]
(    
	@LangID						nvarchar(50),
	@strOutbreakID				nvarchar(200) = null,
	@OutbreakTypeID				bigint = null,
	@SearchDiagnosesGroup		bigint = null,
	@StartDateFrom				datetime = NULL,
	@StartDateTo				datetime = NULL,
	@idfsOutbreakStatus			bigint = null,
	@idfsRegion					bigint = null,
	@idfsRayon					bigint = null,
	@QuickSearch				nvarchar(200) = '',
	@PaginationSet				INT = 1, 
	@PageSize					INT = 10,
	@MaxPagesPerFetch			INT = 10
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @records								INT

	--Set defaults for invalid passed parameters
	IF (@StartDateFrom IS  NULL) SET @StartDateFrom = cast(-53690 as datetime)
	IF (@StartDateTo IS NULL) SET @StartDateTo = cast(2958463 as datetime)
	IF (@idfsRegion = -1) SET @idfsRegion = NULL
	IF (@idfsRayon = -1) SET @idfsRayon = NULL
	
	BEGIN TRY

		if @QuickSearch = '' OR @QuickSearch IS NULL 
			BEGIN
				SELECT
													@records = count(o.idfOutbreak)

				FROM								tlbOutbreak o
											
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
													(strOutbreakID like CASE ISNULL(@strOutbreakID, '') WHEN '' THEN '%%' ELSE '%' + @strOutbreakID +'%' end) and
													((OutbreakTypeID = CASE ISNULL(@OutbreakTypeID, '') WHEN '' THEN OutbreakTypeID ELSE @OutbreakTypeID END) OR @OutbreakTypeID IS NULL) AND
													((idfsOutbreakStatus = CASE ISNULL(@idfsOutbreakStatus, '') WHEN '' THEN idfsOutbreakStatus ELSE @idfsOutbreakStatus END) OR @idfsOutbreakStatus IS NULL) AND
													((geo.idfsRegion = CASE ISNULL(@idfsRegion, '') WHEN '' THEN geo.idfsRegion ELSE @idfsRegion END) OR @idfsRegion IS NULL) AND
													((geo.idfsRayon = CASE ISNULL(@idfsRayon, '') WHEN '' THEN geo.idfsRayon ELSE @idfsRayon END) OR @idfsRayon IS NULL) AND
													((o.idfsDiagnosisOrDiagnosisGroup = CASE ISNULL(@SearchDiagnosesGroup, '') WHEN '' THEN o.idfsDiagnosisOrDiagnosisGroup ELSE @SearchDiagnosesGroup END) OR @SearchDiagnosesGroup IS NULL) AND
													o.intRowStatus = 0 AND
													datStartDate between @StartDateFrom AND @StartDateTo

				SELECT
													@records As records,
													o.idfOutbreak,
													strOutbreakID,
													D.name AS [strDiagnosis],
													os.strDefault as strOutbreakStatus,
													ot.strDefault as strOutbreakType,
													Region.name AS Region,
													Rayon.name AS Rayon, 
													o.datStartDate

				FROM								tlbOutbreak o
											
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
													(strOutbreakID like CASE ISNULL(@strOutbreakID, '') WHEN '' THEN '%%' ELSE '%' + @strOutbreakID +'%' end) and
													((OutbreakTypeID = CASE ISNULL(@OutbreakTypeID, '') WHEN '' THEN OutbreakTypeID ELSE @OutbreakTypeID END) OR @OutbreakTypeID IS NULL) AND
													((idfsOutbreakStatus = CASE ISNULL(@idfsOutbreakStatus, '') WHEN '' THEN idfsOutbreakStatus ELSE @idfsOutbreakStatus END) OR @idfsOutbreakStatus IS NULL) AND
													((geo.idfsRegion = CASE ISNULL(@idfsRegion, '') WHEN '' THEN geo.idfsRegion ELSE @idfsRegion END) OR @idfsRegion IS NULL) AND
													((geo.idfsRayon = CASE ISNULL(@idfsRayon, '') WHEN '' THEN geo.idfsRayon ELSE @idfsRayon END) OR @idfsRayon IS NULL) AND
													((o.idfsDiagnosisOrDiagnosisGroup = CASE ISNULL(@SearchDiagnosesGroup, '') WHEN '' THEN o.idfsDiagnosisOrDiagnosisGroup ELSE @SearchDiagnosesGroup END) OR @SearchDiagnosesGroup IS NULL) AND
													o.intRowStatus = 0 AND
													datStartDate between @StartDateFrom AND @StartDateTo

				ORDER BY							o.strOutbreakID
													OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
													FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY
			END
		ELSE
			BEGIN

				SELECT
													@records = count(o.idfOutbreak)

				FROM								tlbOutbreak o
											
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
													strOutbreakID like '%' + @QuickSearch + '%' OR
													D.name like '%' + @QuickSearch + '%' OR
													os.strDefault like '%' + @QuickSearch + '%' OR
													ot.strDefault like '%' + @QuickSearch + '%' OR
													Region.name like '%' + @QuickSearch + '%' OR
													Rayon.name like '%' + @QuickSearch + '%' OR
													o.datStartDate like '%' + @QuickSearch + '%' AND
													o.intRowStatus = 0

				SELECT
													@records As records,
													o.idfOutbreak,
													strOutbreakID,
													D.name AS [strDiagnosis],
													os.strDefault as strOutbreakStatus,
													ot.strDefault as strOutbreakType,
													Region.name AS Region,
													Rayon.name AS Rayon, 
													o.datStartDate

				FROM								tlbOutbreak o
											
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
													(strOutbreakID like '%' + @QuickSearch + '%' OR
													D.name like '%' + @QuickSearch + '%' OR
													os.strDefault like '%' + @QuickSearch + '%' OR
													ot.strDefault like '%' + @QuickSearch + '%' OR
													Region.name like '%' + @QuickSearch + '%' OR
													Rayon.name like '%' + @QuickSearch + '%' OR
													o.datStartDate like '%' + @QuickSearch + '%') AND
													o.intRowStatus = 0

				ORDER BY							o.strOutbreakID
													OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
													FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY
			END

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		Throw;
	END CATCH

	--SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

END