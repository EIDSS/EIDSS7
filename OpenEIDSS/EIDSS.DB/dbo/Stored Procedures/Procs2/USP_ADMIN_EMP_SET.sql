
--=====================================================================================================
-- Created by:				Joan Li
-- Description:				04/19/2017: Created based on V6 spPerson_Post: V7 USP
--                          JL:Input: 11 parameters related to person ,organization,site outPut: idfPersonNewID
--							04/26/2017: JL:change name to: USP_ADMIN_EMP_SET	
--                          06/05/2017: JL:Dev group asking add calling usp_sysGetNewID if app calling this 
--                          SP with action=4 and @idfPerson=NULL
--                          06/12/2017: JL: Dev group asking to set @idfPerson input param =NULL
--                          06/13/2017: JL:Dev group asking to return idfpersonnewid
--                          06/21/2017: JL:  add data modify date and user info
--                          09/25/2017: JL: returns status for success; returns @idfPerson for update
/*
----testing code:
declare @retirnid bigint 
----execute dbo.USP_ADMIN_EMP_SET 'I',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Lij',@retirnid
execute dbo.USP_ADMIN_EMP_SET 'U',55471930000000,NULL,NULL,NULL,'Backend','Test','Unit','88888888',NULL,NULL,'Lij',@retirnid
SELECT @retirnid
SELECT * from tlbperson where idfperson=55471930000000
SELECT * from tlbemployee
*/

--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_EMP_SET]
( 

	@idfPerson			BIGINT = NULL  --##PARAM @idfPerson person ID
	,@idfsStaffPosition BIGINT--##PARAM @idfsStaffPosition - person position (reference to rftPosition, 19000073)
	,@idfInstitution	BIGINT--##PARAM @idfInstitution - person organization
	,@idfDepartment		BIGINT--##PARAM @idfDepartment - person department
	,@strFamilyName		NVARCHAR(200)--##PARAM @strFamilyName - person last name
	,@strFirstName		NVARCHAR(200)--##PARAM @strFirstName - person first name
	,@strSecondName		NVARCHAR(200)--##PARAM @strSecondName - person second name
	,@strContactPhone	NVARCHAR(200)--##PARAM @strContactPhone - person contact phone
	,@strBarcode		NVARCHAR(200)=NULL--##PARAM @strBarcode - person uniquue barcode (doesn't use now)
	,@idfsSite			BIGINT--##PARAM @idfsSite - site where the record was created
	,@User				VARCHAR(100)=NULL  --who required data change
)
AS

DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0 

Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
BEGIN
	BEGIN TRY  	
	BEGIN TRANSACTION
		----get data change date and user info: before app send final user 
		DECLARE @DataChageInfo as NVARCHAR(MAX)
		SELECT @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)

		IF NOT EXISTS (SELECT idfEmployee FROM dbo.tlbEmployee WHERE idfEmployee = @idfPerson)

			BEGIN    
				insert into @SupressSelect
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbEmployee', @idfPerson OUTPUT

				----first inset into tlbEmployes
				INSERT INTO tlbEmployee

						(
						idfEmployee,
						idfsEmployeeType,
						idfsSite,
						strReservedAttribute
						)
					VALUES
						(
						@idfPerson
						,10023002 --@idfsEmployeeType, Person
						,ISNULL(@idfsSite,dbo.FN_GBL_SITEID_GET())
						,@DataChageInfo
						)

					----second insert into tlbPerson with same id input
					INSERT INTO tlbPerson
							(
							idfPerson
							,idfsStaffPosition
							,idfInstitution
							,idfDepartment
							,strFamilyName
							,strFirstName
							,strSecondName
							,strContactPhone
							,strBarcode
							,strReservedAttribute
							)
						VALUES
							(
							@idfPerson
							,@idfsStaffPosition
							,@idfInstitution
							,@idfDepartment
							,@strFamilyName
							,@strFirstName
							,@strSecondName
							,@strContactPhone
							,@strBarcode
							,@DataChageInfo
							)

			END  ----end action =4

		ELSE 
			BEGIN
				BEGIN	
						
					----first updatte tlbPerson
					UPDATE tlbPerson
						SET 
							idfsStaffPosition = @idfsStaffPosition
							,idfInstitution = @idfInstitution
							,idfDepartment = @idfDepartment
							,strFamilyName = @strFamilyName
							,strFirstName = @strFirstName
							,strSecondName = @strSecondName
							,strContactPhone = @strContactPhone
							,strBarcode = @strBarcode
							,strReservedAttribute=@DataChageInfo
					WHERE idfPerson=@idfPerson
				END

				----second update tstUserTable
				DECLARE @idfsPersonSite BIGINT

				SELECT	@idfsPersonSite = s.idfsSite
				FROM	tlbPerson p 
				INNER JOIN tstSite s ON s.idfOffice = p.idfInstitution AND s.intRowStatus = 0
				WHERE	p.idfPerson = @idfPerson

				BEGIN
					UPDATE [dbo].[tstUserTable]
					SET idfsSite = @idfsPersonSite
					WHERE idfPerson = @idfPerson AND idfsSite<>@idfsPersonSite

				END 
			END---end update 


		IF @@TRANCOUNT > 0 
			COMMIT  

		SELECT @returnCode 'ReturnCode', @returnMsg 'RetunMessage',@idfPerson 'idfPerson'
	END TRY  

	BEGIN CATCH  

		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK

			END;
		Throw
	END CATCH 
END





