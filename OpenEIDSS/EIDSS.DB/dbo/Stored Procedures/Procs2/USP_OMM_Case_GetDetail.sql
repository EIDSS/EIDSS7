USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_Case_GetDetail]    Script Date: 5/30/2019 7:16:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*************************************************************
-- Name: [USP_OMM_Case_GetDetail]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    Doug Albanese	5-29-2010	Changes for OMUC07 (Vet Disease details)
--*************************************************************
ALTER PROCEDURE [dbo].[USP_OMM_Case_GetDetail]
(    
	@LangID									nvarchar(50),
	@OutbreakCaseReportUID					BIGINT = -1
)
AS

BEGIN    

	DECLARE	@returnCode						INT = 0;
	DECLARE @returnMsg						NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY

			SELECT
											DISTINCT
											--General
											h.idfHumanActual,
											--Notification
											hc.datNotificationDate,
											hc.idfSentByOffice,
											sbf.strSiteName AS NotificationSentByFacility,
											hc.strSentByFirstName + ' ' + hc.strSentByLastName AS NotificationSentByName,
											hc.idfReceivedByOffice,
											rbf.strSiteName AS NotificationReceivedByFacility,
											hc.strReceivedByFirstName + ' ' + hc.strReceivedByLastName AS NotificationReceivedByName,
											--Case Locatiton
											geo.idfsCountry,
											geo.idfsRegion,
											geo.idfsRayon,
											geo.idfsSettlement,  
											geo.strStreetName,
											geo.strPostCode, 
											geo.strBuilding,
											geo.strHouse,		   
											geo.strApartment,
											geo.strPostCode,
											geo.dblLatitude,
											geo.dblLongitude,
											--Clinical Information
											ocr.OutbreakCaseStatusID AS CaseStatus,
											hc.datOnSetDate AS DateOfSymptomsOnset ,
											hc.datFinalDiagnosisDate AS DateOfDiagnosis,
											hc.strHospitalizationPlace AS HospitalName,
											hc.datHospitalizationDate,
											hc.datDischargeDate,
											amt.strAntimicrobialTherapyName,
											amt.strDosage As strAntibioticAntiviralDose,
											amt.datFirstAdministeredDate AS datAntibioticAntiviralFirstAdministered,
											hc.strNote AS ClinicalAdditionalComments,
											--Outbreak Investigation
											hc.idfInvestigatedByOffice,
											ibo.strSiteName AS strInvestigatorOrganization,
											hc.idfInvestigatedByPerson,
											ibp.strSiteName AS strInvestigatorName,
											ocr.IsPrimaryCaseFlag AS PrimaryCase,
											'' AS InvestigationAdditionalComments,
											--Case Monitoring
											'' AS datMonitoringDate,
											'' AS MonitoringAdditionalComments,
											'' AS MonitoringInvestigatorOrganization,
											'' AS MonitoringInvestigatorName
			FROM
											OutbreakCaseReport ocr
			INNER JOIN						tlbHumanCase hc
			ON								hc.idfHumanCase = ocr.idfHumanCase
			INNER JOIN						tlbHuman h
			ON								h.idfHuman = hc.idfHuman
			INNER JOIN						tlbHumanActual ha
			ON								ha.idfHumanActual = h.idfHumanActual
			INNER JOIN						HumanActualAddlInfo haai
			ON								haai.HumanActualAddlInfoUID = ha.idfHumanActual
			INNER JOIN						tlbOutbreak o
			ON								o.idfOutbreak = OCR.idfOutbreak
			LEFT JOIN						tlbGeoLocation geo 
			ON								o.idfGeoLocation = geo.idfGeoLocation
			LEFT JOIN						FN_GBL_GIS_REFERENCE(@langId, 19000002) Rayon
			ON								Rayon.idfsReference = geo.idfsRayon
			LEFT JOIN						FN_GBL_GIS_REFERENCE(@langId,19000003) Region
			ON								Region.idfsReference = geo.idfsRegion
			LEFT JOIN						FN_GBL_GIS_REFERENCE(@langId,19000004) Settlement
			ON								Settlement.idfsReference = geo.idfsSettlement
			LEFT JOIN						tlbAntimicrobialTherapy amt
			ON								amt.idfHumanCase = ocr.idfHumanCase
			LEFT JOIN						HumanDiseaseReportVaccination hdrv
			ON								hdrv.idfHumanCase = ocr.idfHumanCase
			LEFT JOIN						tstSite sbf
			ON								sbf.idfOffice = hc.idfSentByOffice
			LEFT JOIN						tstSite rbf
			ON								rbf.idfOffice = hc.idfReceivedByOffice
			LEFT JOIN						tstSite ibo
			ON								ibo.idfOffice = hc.idfInvestigatedByOffice
			LEFT JOIN						tstSite ibp
			ON								ibp.idfOffice = hc.idfInvestigatedByPerson
			
			WHERE
											OCR.OutBreakCaseReportUID = @OutbreakCaseReportUID
	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		throw;
	END CATCH

	SELECT	@returnCode, @returnMsg;

END
