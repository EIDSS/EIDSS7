--=====================================================================================================
-- Created by:				Mandar Kulkarni
-- LASt modified date:		01/26/2018
-- Description:				SELECTs data for OrganizationDetail form
/*
----testing code:
DECLARE @idfOffice bigint
EXECUTE USP_ADMIN_ORG_GETDetail
	49860000000,
	'ru'
EXECUTE USP_ADMIN_ORG_GETDetail
	NULL,
	'en'
EXECUTE USP_ADMIN_ORG_GETDetail
	709230000000,
	'en'
	
*/
--=====================================================================================================
CREATE      PROCEDURE [dbo].[USP_ADMIN_ORG_GETDetail]
(
	@idfOffice	AS BIGINT, --##PARAM @idfOffice - organization ID
	@LangID		AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
DECLARE @ReturnCode BIGINT = 0 
DECLARE @ReturnMsg VARCHAR(MAX) = 'Success'
BEGIN

	BEGIN TRY  	

		--0 Organization

		SELECT 
				fn.idfOffice
				, fn.EnglishName
				, fn.EnglishFullName
				, fn.[name]
				, fn.FullName
				, fn.strContactPhone
				, fn.idfLocation as [idfGeoLocation]
				, fn.intHACode
				, fn.strOrganizationID
				, fn.intOrder
				,tg.idfsCountry as LocationUserControlidfsCountry
				,tg.idfsRegion as LocationUserControlidfsRegion
				,tg.idfsRayon as LocationUserControlidfsRayon
				,tg.idfsSettlement as LocationUserControlidfsSettlement
				,tg.idfsSite
				,tg.strPostCode
				,tg.strStreetName as LocationUserControlstrStreetName
				,tg.strHouse as LocationUserControlstrHouse
				,tg.strBuilding as LocationUserControlstrBuilding
				,tg.strApartment as LocationUserControlstrApartment
				,tg.blnForeignAddress
				,tg.strForeignAddress
				,tg.strAddressString
				,tg.[strShortAddressString]
		FROM 	dbo.FN_GBL_Institution(@LangID)  fn
		left outer join dbo.tlbGeoLocationShared tg
		on fn.idfLocation=tg.idfGeoLocationShared
		WHERE 		fn.idfOffice=@idfOffice

		--1 Departments

		SELECT  idfDepartment, @idfOffice AS idfOrganization, DefaultName, [name] 
		FROM 	dbo.fnDepartment(@LangID) 
		WHERE 	idfInstitution=@idfOffice

		--2 Persons

		SELECT	idfPerson
				,idfsStaffPosition
				,idfInstitution
				,idfDepartment
				,strFamilyName
				,strFirstName
				,strSecondName
				,strContactPhone
				,strBarcode
				,tlbEmployee.idfsSite
		FROM	tlbPerson
		INNER JOIN tlbEmployee ON
				tlbPerson.idfPerson=tlbEmployee.idfEmployee
		WHERE 	tlbPerson.idfInstitution=@idfOffice
		AND		tlbEmployee.intRowStatus=0 
		AND		tlbEmployee.idfsEmployeeType=10023002 --Person 

		SELECT @ReturnCode, @ReturnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @ReturnCode = ERROR_NUMBER()
			SET @ReturnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @ReturnMsg
		END

	END CATCH;
END




