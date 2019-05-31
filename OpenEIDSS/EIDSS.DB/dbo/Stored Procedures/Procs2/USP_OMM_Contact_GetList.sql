
-- ================================================================================================
-- Name: USP_OMM_Contact_GetList
--
-- Description: Gets a list of Contactrs for a given outbreak case.
--          
-- Author: Doug Albanese
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Doug Albanese    02/20/2019 Added Procedure to obtain list of contacts for given case
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_OMM_Contact_GetList]
(
    @LangID							NVARCHAR(50),
    @OutbreakCaseReportUID			BIGINT = NULL,
	@QuicKSearch					NVARCHAR(100) = '',
	@FollowUp						INT = 0,
	@PaginationSet					INT = 1, 
	@PageSize						INT = 10,
	@MaxPagesPerFetch				INT = 10
)
AS
BEGIN
    DECLARE @returnCode					INT = 0;
    DECLARE @returnMsg					NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @records					INT
	DECLARE @ContactTracingFrequency	INT = 0

	--Obtain the Contact Tracking Freuqency, in case it will be used below
	SELECT
					@ContactTracingFrequency = OSP.ContactTracingFrequency
	FROM
					OutbreakSpeciesParameter OSP
	INNER JOIN		OutbreakCaseReport OCR
	ON				OCR.idfOutbreak = OSP.idfOutbreak
	WHERE
					OCR.OutbreakCaseReportUID = @OutbreakCaseReportUID AND
					OSP.intRowStatus = 0

	IF @OutbreakCaseReportUID = -1
		BEGIN
			SET @OutbreakCaseReportUID = ''
		END

    BEGIN TRY
		
		IF @QuickSearch = '' OR @QuickSearch IS NULL 
			BEGIN
			--Get the count of records for pagination
				SELECT
								@records = COUNT(OutbreakCaseContactUID)
				FROM
								OutbreakCaseContact OCC
				INNER JOIN		tlbHuman H
				ON				H.idfHuman = OCC.idfHuman
				INNER JOIN		FN_GBL_Reference_GETList(@LangID, 19000043) G
				ON				G.idfsReference = H.idfsHumanGender
				LEFT JOIN		dbo.tlbGeoLocation geo 
				ON				H.idfCurrentResidenceAddress = geo.idfGeoLocation
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
				ON				Rayon.idfsReference = geo.idfsRayon
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
				ON				Region.idfsReference = geo.idfsRegion
				LEFT JOIN		dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
				ON				Settlement.idfsReference = geo.idfsSettlement
				LEFT JOIN		dbo.FN_GBL_Reference_GetList(@LangID,19000517) ConstactStatus
				ON				ConstactStatus.idfsReference = OCC.ContactStatusID
				WHERE
								OCC.intRowStatus = 0 AND
								((OCC.OutbreakCaseReportUID = CASE ISNULL(@OutbreakCaseReportUID, '') WHEN '' THEN OCC.OutbreakCaseReportUID ELSE @OutbreakCaseReportUID END) OR @OutbreakCaseReportUID IS NULL) AND
								(OCC.DateOfLastContact < CASE @FollowUp WHEN 0 THEN GETDATE() WHEN 1 THEN DATEADD(day, -(@ContactTracingFrequency), GETDATE()) END)

				--Get the records for the gridview
				SELECT
								@records AS Records,
								OCC.OutbreakCaseContactUID,
								OCC.ContactedHumanCasePersonID,
								strLastName + ', ' + strFirstName AS Name,
								G.strDefault AS Gender,
								OCC.DateOfLastContact,
								Coalesce(ConstactStatus.name, '') AS ContactStatus,
								--'Data Of Last Follow-Up' As FollowUpDate,
								Region.name + ' ' + Rayon.Name + ' ' + Settlement.Name AS CurrentLocation,
								'Contact Monitoring Questions' AS ContactMonitoringQuestions
				FROM
								OutbreakCaseContact OCC
				INNER JOIN		tlbHuman H
				ON				H.idfHuman = OCC.idfHuman
				INNER JOIN		FN_GBL_Reference_GetList(@LangID, 19000043) G
				ON				G.idfsReference = H.idfsHumanGender
				LEFT JOIN		dbo.tlbGeoLocation geo 
				ON				H.idfCurrentResidenceAddress = geo.idfGeoLocation
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
				ON				Rayon.idfsReference = geo.idfsRayon
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
				ON				Region.idfsReference = geo.idfsRegion
				LEFT JOIN		dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
				ON				Settlement.idfsReference = geo.idfsSettlement
				LEFT JOIN		dbo.FN_GBL_Reference_GetList(@LangID,19000517) ConstactStatus
				ON				ConstactStatus.idfsReference = OCC.ContactStatusID
				
				WHERE
								OCC.intRowStatus = 0 AND
								((OCC.OutbreakCaseReportUID = CASE ISNULL(@OutbreakCaseReportUID, '') WHEN '' THEN OCC.OutbreakCaseReportUID ELSE @OutbreakCaseReportUID END) OR @OutbreakCaseReportUID IS NULL) AND
								(OCC.DateOfLastContact < CASE @FollowUp WHEN 0 THEN GETDATE() WHEN 1 THEN DATEADD(day, -(@ContactTracingFrequency), GETDATE()) END)
				ORDER BY							
								OCC.OutbreakCaseContactUID
								OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
								FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY
			END
		ELSE
			BEGIN
				--Get the count of records for pagination
				SELECT
								@records = COUNT(OutbreakCaseContactUID)
				FROM
								OutbreakCaseContact OCC
				INNER JOIN		tlbHuman H
				ON				H.idfHuman = OCC.idfHuman
				INNER JOIN		FN_GBL_Reference_GETList(@LangID, 19000043) G
				ON				G.idfsReference = H.idfsHumanGender
				LEFT JOIN		dbo.tlbGeoLocation geo 
				ON				H.idfCurrentResidenceAddress = geo.idfGeoLocation
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
				ON				Rayon.idfsReference = geo.idfsRayon
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
				ON				Region.idfsReference = geo.idfsRegion
				LEFT JOIN		dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
				ON				Settlement.idfsReference = geo.idfsSettlement
				LEFT JOIN		dbo.FN_GBL_Reference_GetList(@LangID,19000517) ConstactStatus
				ON				ConstactStatus.idfsReference = OCC.ContactStatusID
				WHERE
								OCC.intRowStatus = 0 AND
								((OCC.OutbreakCaseReportUID = CASE ISNULL(@OutbreakCaseReportUID, '') WHEN '' THEN OCC.OutbreakCaseReportUID ELSE @OutbreakCaseReportUID END) OR @OutbreakCaseReportUID IS NULL) AND
								(OCC.OutbreakCaseContactUID like '%' + @QuickSearch + '%' OR
								OCC.ContactedHumanCasePersonID like '%' + @QuickSearch + '%' OR
								strLastName like '%' + @QuickSearch + '%' OR
								strFirstName like '%' + @QuickSearch + '%' OR
								G.strDefault like '%' + @QuickSearch + '%' OR
								OCC.DateOfLastContact like '%' + @QuickSearch + '%' OR
								ConstactStatus.Name like '%' + @QuickSearch + '%' OR
								Region.name like '%' + @QuickSearch + '%' OR
								Rayon.name like '%' + @QuickSearch + '%' OR
								Settlement.name like '%' + @QuickSearch + '%' OR
								G.strDefault like '%' + @QuickSearch + '%') AND
								(OCC.DateOfLastContact < CASE @FollowUp WHEN 0 THEN GETDATE() WHEN 1 THEN DATEADD(day, -(@ContactTracingFrequency), GETDATE()) END)

				--Get the records for the gridview
				SELECT
								@records AS Records,
								OCC.OutbreakCaseContactUID,
								OCC.ContactedHumanCasePersonID,
								strLastName + ', ' + strFirstName AS Name,
								G.strDefault AS Gender,
								OCC.DateOfLastContact,
								Coalesce(ConstactStatus.name, '') AS ContactStatus,
								--'Data Of Last Follow-Up' As FollowUpDate,
								Region.name + ' ' + Rayon.Name + ' ' + Settlement.Name AS CurrentLocation,
								'Contact Monitoring Questions' AS ContactMonitoringQuestions
				FROM
								OutbreakCaseContact OCC
				INNER JOIN		tlbHuman H
				ON				H.idfHuman = OCC.idfHuman
				INNER JOIN		FN_GBL_Reference_GETList(@LangID, 19000043) G
				ON				G.idfsReference = H.idfsHumanGender
				LEFT JOIN		dbo.tlbGeoLocation geo 
				ON				H.idfCurrentResidenceAddress = geo.idfGeoLocation
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
				ON				Rayon.idfsReference = geo.idfsRayon
				LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
				ON				Region.idfsReference = geo.idfsRegion
				LEFT JOIN		dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
				ON				Settlement.idfsReference = geo.idfsSettlement
				LEFT JOIN		dbo.FN_GBL_Reference_GetList(@LangID,19000517) ConstactStatus
				ON				ConstactStatus.idfsReference = OCC.ContactStatusID
				WHERE
								OCC.intRowStatus = 0 AND
								((OCC.OutbreakCaseReportUID = CASE ISNULL(@OutbreakCaseReportUID, '') WHEN '' THEN OCC.OutbreakCaseReportUID ELSE @OutbreakCaseReportUID END) OR @OutbreakCaseReportUID IS NULL) AND
								(OCC.OutbreakCaseContactUID like '%' + @QuickSearch + '%' OR
								OCC.ContactedHumanCasePersonID like '%' + @QuickSearch + '%' OR
								strLastName like '%' + @QuickSearch + '%' OR
								strFirstName like '%' + @QuickSearch + '%' OR
								G.strDefault like '%' + @QuickSearch + '%' OR
								OCC.DateOfLastContact like '%' + @QuickSearch + '%' OR
								ConstactStatus.Name like '%' + @QuickSearch + '%' OR
								Region.name like '%' + @QuickSearch + '%' OR
								Rayon.name like '%' + @QuickSearch + '%' OR
								Settlement.name like '%' + @QuickSearch + '%' OR
								G.strDefault like '%' + @QuickSearch + '%') AND
								(OCC.DateOfLastContact < CASE @FollowUp WHEN 0 THEN GETDATE() WHEN 1 THEN DATEADD(day, -(@ContactTracingFrequency), GETDATE()) END)
				ORDER BY							
								OCC.OutbreakCaseContactUID
								OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
								FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY
			END
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT = 1
            ROLLBACK;
		throw;
    END CATCH;

	SELECT @returnCode, @returnMsg;
END;
