USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_Case_GetList]    Script Date: 5/30/2019 7:12:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Name: USP_OMM_Case_GetList
--
-- Description: Gets a list of outbreak case reports.
--          
-- Author: Doug Albanese
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Doug Albanese	5-20-2019	Added capabilities for Vet Disease retrieval
--                            schema.
-- ================================================================================================
ALTER PROCEDURE [dbo].[USP_OMM_Case_GetList]
(
    @LangID							NVARCHAR(50),
    @idfOutbreak					BIGINT = NULL,
	@QuicKSearch					NVARCHAR(100) = '',
    @HumanMasterID					BIGINT = NULL,
	@VetMasterID					BIGINT = NULL
)
AS
BEGIN
    DECLARE @returnCode INT = 0;
    DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

    BEGIN TRY
        DECLARE @OutbreakCases TABLE
        (
            idfOutbreak BIGINT,
            OutbreakCaseReportUID BIGINT,
            strOutbreakCaseID NVARCHAR(200),
            idfHumanCase BIGINT,
            idfVetCase BIGINT,
            FarmOwner VARCHAR(200),
            CaseType VARCHAR(200),
            CaseFarmStatus VARCHAR(200),
            DateOfSymptomOnset DATETIME,
            CaseClassification VARCHAR(200),
            CaseLocation VARCHAR(200),
			DateEntered VARCHAR(200)
        );
		
		INSERT INTO @OutbreakCases
		SELECT OCR.idfOutbreak,
				OCR.OutBreakCaseReportUID,
				HC.strCaseID AS strOutbreakCaseID,
				OCR.idfHumanCase,
				NULL AS idfVetCase,
				NULL AS FarmOwner,
				'Human' AS CaseType,
				'Not an outbreak' AS CaseFarmStatus,
				HC.datOnSetDate AS DateOfSymptomOnset,
				Classification.name AS CaseClassification,
				Rayon.name + ', ' + Region.name AS CaseLocation,
				CONVERT(VARCHAR(10), OCR.AuditCreateDTM, 101) AS DateEntered
		FROM dbo.OutbreakCaseReport OCR
			INNER JOIN dbo.tlbHumanCase HC
				ON HC.idfHumanCase = OCR.idfHumanCase
			INNER JOIN dbo.tlbHuman H
				ON H.idfHuman = HC.idfHuman
			INNER JOIN dbo.tlbGeoLocation GL
				ON GL.idfGeoLocation = H.idfCurrentResidenceAddress
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID, 19000002) Rayon
				ON Rayon.idfsReference = GL.idfsRayon
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID, 19000003) Region
				ON Region.idfsReference = GL.idfsRegion
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LangID, 19000011) Classification
				ON Classification.idfsReference = HC.idfsInitialCaseStatus
		WHERE OCR.idfHumanCase IS NOT NULL AND
				OCR.intRowStatus = 0 AND
				(
					(OCR.idfOutbreak = @idfOutbreak)
					OR (@idfOutbreak IS NULL)
				)
				AND
				(
					(H.idfHumanActual = @HumanMasterID)
					OR (@HumanMasterID IS NULL)
				);

		INSERT INTO @OutbreakCases
		SELECT OCR.idfOutbreak,
				OCR.OutBreakCaseReportUID,
				vc.strCaseID AS strOutbreakCaseID,
				NULL AS idfHumanCase,
				OCR.idfVetCase,
				NULL AS FarmOwner,
				'Veterinary' AS CaseType,
				'Not an outbreak' AS CaseFarmStatus,
				vc.datReportDate AS DateOfSymptomOnset,
				Classification.name AS CaseClassification,
				Rayon.name + ', ' + Region.name AS CaseLocation,
				CONVERT(VARCHAR(10), OCR.AuditCreateDTM, 101) AS DateEntered
		FROM dbo.OutbreakCaseReport OCR
			LEFT JOIN dbo.tlbVetCase vc
				ON vc.idfVetCase = OCR.idfVetCase
			LEFT JOIN	tlbFarm F
				ON F.idfFarm = vc.idfFarm
			LEFT JOIN dbo.tlbGeoLocation GL
				ON GL.idfGeoLocation = f.idfFarmAddress
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID, 19000002) Rayon
				ON Rayon.idfsReference = GL.idfsRayon
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID, 19000003) Region
				ON Region.idfsReference = GL.idfsRegion
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LangID, 19000011) Classification
				ON Classification.idfsReference = vc.idfsCaseProgressStatus
		WHERE OCR.idfVetCase IS NOT NULL AND
				OCR.intRowStatus = 0 AND
				(
					(OCR.idfOutbreak = @idfOutbreak)
					OR (@idfOutbreak IS NULL)
				)
				AND
				(
					(f.idfFarmActual = @VetMasterID)
					OR (@VetMasterID IS NULL)
				);

		DECLARE	@iRecordCount	INT = 0

		IF @QuickSearch = '' OR @QuickSearch IS NULL 
			BEGIN
				SELECT
						@iRecordCount = Count(idfOutbreak)
				FROM 
						@OutbreakCases

				SELECT
						idfOutbreak,
						OutbreakCaseReportUID,
						strOutbreakCaseID,
						idfHumanCase,
						idfVetCase,
						FarmOwner,
						CaseType,
						CaseFarmStatus,
						DateOfSymptomOnset,
						CaseClassification,
						CaseLocation,
						DateEntered,
						@iRecordCount AS RecordCount
				FROM 
						@OutbreakCases
			END
		ELSE
			BEGIN
				SELECT
						@iRecordCount = Count(idfOutbreak)
				FROM 
						@OutbreakCases
				WHERE
						idfOutbreak like '%' + @QuickSearch + '%' OR
						OutbreakCaseReportUID like '%' + @QuickSearch + '%' OR
						strOutbreakCaseID like '%' + @QuickSearch + '%' OR
						idfHumanCase like '%' + @QuickSearch + '%' OR
						idfVetCase like '%' + @QuickSearch + '%' OR
						FarmOwner like '%' + @QuickSearch + '%' OR
						CaseType like '%' + @QuickSearch + '%' OR
						CaseFarmStatus like '%' + @QuickSearch + '%' OR
						DateOfSymptomOnset like '%' + @QuickSearch + '%' OR
						CaseClassification like '%' + @QuickSearch + '%' OR
						CaseLocation like '%' + @QuickSearch + '%'

				SELECT
						idfOutbreak,
						OutbreakCaseReportUID,
						strOutbreakCaseID,
						idfHumanCase,
						idfVetCase,
						FarmOwner,
						CaseType,
						CaseFarmStatus,
						DateOfSymptomOnset,
						CaseClassification,
						CaseLocation,
						DateEntered,
						@iRecordCount AS RecordCount
				FROM 
						@OutbreakCases
				WHERE
						idfOutbreak like '%' + @QuickSearch + '%' OR
						OutbreakCaseReportUID like '%' + @QuickSearch + '%' OR
						strOutbreakCaseID like '%' + @QuickSearch + '%' OR
						idfHumanCase like '%' + @QuickSearch + '%' OR
						idfVetCase like '%' + @QuickSearch + '%' OR
						FarmOwner like '%' + @QuickSearch + '%' OR
						CaseType like '%' + @QuickSearch + '%' OR
						CaseFarmStatus like '%' + @QuickSearch + '%' OR
						DateOfSymptomOnset like '%' + @QuickSearch + '%' OR
						CaseClassification like '%' + @QuickSearch + '%' OR
						CaseLocation like '%' + @QuickSearch + '%'
			END

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT = 1
            ROLLBACK;

        SET @returnCode = ERROR_NUMBER();
        SET @returnMsg
            = N'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + N' ErrorSeverity: '
              + CONVERT(VARCHAR, ERROR_SEVERITY()) + N' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
              + N' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '') + N' ErrorLine: '
              + CONVERT(VARCHAR, ISNULL(ERROR_LINE(), '')) + N' ErrorMessage: ' + ERROR_MESSAGE();

        SELECT @returnCode,
               @returnMsg;
    END CATCH;
END;
