

--*************************************************************
-- Name 				: USP_GLB_LKUP_STREET_SET
-- Description			: Sets street name for quick referencing in the system.
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--
-- Testing code:
-- EXEC USP_GLB_LKUP_STREET_SET @strStreetName, @idfsSettlement, @User, @idfsStreetID OUTPUT
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GLB_LKUP_STREET_SET]
	(
	@strStreetName		NVARCHAR(200)			--##PARAM @strStreetName - street name
	,@idfsSettlement	BIGINT					--##PARAM @idfsSettlement - ID of settlement to which street belongs
	,@User				VARCHAR(100) = NULL		--who required data change
	,@idfStreet			BIGINT = NULL OUTPUT
	)
AS

	DECLARE @LogErrMsg VARCHAR(MAX)
	SELECT @LogErrMsg = ''

	BEGIN TRY  	

		BEGIN
			/*
			MD: Should we be using XACT_STATE() 
				We can check this in the CATCH block
			*/
			BEGIN TRANSACTION

			----get data change date and user info: before app send final user 
			DECLARE @DataChageInfo AS NVARCHAR(MAX)

			/*
			MD: fnzDBdatachageDatePerson uses date format for US
				Do we need to localize it for country?
			*/

			SELECT @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)

			BEGIN

				--If street exists then return the street ID
				IF EXISTS
					(SELECT
						*	
					FROM
						tlbStreet
					WHERE	
						idfsSettlement = @idfsSettlement
						AND 
						strStreetName = @strStreetName
						AND
						intRowStatus = 0
					)
					BEGIN
						SELECT
							@idfStreet = idfStreet	
						FROM
							tlbStreet
						WHERE	
							idfsSettlement = @idfsSettlement
							AND 
							strStreetName = @strStreetName
							AND 
							intRowStatus = 0
					END
				ELSE
					BEGIN
		
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbStreet', @idfStreet OUTPUT
	
						INSERT INTO tlbStreet
							(
							idfStreet
							,idfsSettlement 
							,strStreetName
							,strReservedAttribute 
							)
						VALUES
							(
							@idfStreet
							,@idfsSettlement 
							,@strStreetName
							,@DataChageInfo
							)
					END
			END

			COMMIT  

			SET @LogErrMsg='Success' 
			SELECT @LogErrMsg 
		END

	END TRY  

	BEGIN CATCH 

		-- Execute error retrieval routine. 
		IF @@TRANCOUNT = 0

			--MD: Not sure what to return. But we need a result set to be returned
			BEGIN
				
				SELECT @idfStreet = -1
				SET @LogErrMsg = '' 
				SELECT @LogErrMsg 
				
				RETURN
			END

		IF @@TRANCOUNT > 0

			BEGIN
				ROLLBACK

				SELECT @idfStreet = -1
				SET @LogErrMsg = 
					'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
					+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
					+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
					+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
					+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
					+ ' ErrorMessage: '+ ERROR_MESSAGE()

				SELECT @LogErrMsg
			END

	END CATCH; 


