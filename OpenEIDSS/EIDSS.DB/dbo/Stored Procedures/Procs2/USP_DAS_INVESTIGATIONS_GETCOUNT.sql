-- ================================================================================================================
-- NAME: USP_DAS_INVESTIGATIONS_GETCOUNT
-- DESCRIPTION: Returns a count of veterinary disease reports
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			05/07/2018		Initial Release
-- Testing Code:
-- exec USP_DAS_INVESTIGATIONS_GETCOUNT
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_INVESTIGATIONS_GETCOUNT]
AS  
BEGIN
	BEGIN TRY
		SELECT	COUNT(vc.idfVetCase) AS RecordCount
		FROM						dbo.tlbVetCase vc 
		INNER JOIN					dbo.tlbFarm AS f
		ON							f.idfFarm = vc.idfFarm
		INNER JOIN					dbo.tlbFarmActual AS fa
		ON							fa.idfFarmActual = f.idfFarmActual 
		LEFT JOIN					dbo.tlbHumanActual AS ha 
		ON							ha.idfHumanActual = fa.idfHumanActual
		LEFT JOIN					dbo.tlbPerson AS personInvestigatedBy 
		ON							personInvestigatedBy.idfPerson = vc.idfPersonInvestigatedBy AND personInvestigatedBy.intRowStatus = 0
		LEFT JOIN					dbo.tlbGeoLocation AS glFarm
		ON							glFarm.idfGeoLocation = f.idfFarmAddress AND glFarm.intRowStatus = 0
		WHERE vc.idfsCaseProgressStatus = 10109001
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END