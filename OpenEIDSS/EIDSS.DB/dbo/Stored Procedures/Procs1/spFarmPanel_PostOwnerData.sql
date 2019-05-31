
--##SUMMARY Posts data for farm owner.
--##SUMMARY If owner with passed @idfOwner exists, procedure updates owner name.
--##SUMMARY In other case new farm owner is created.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 011.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 17.07.2011

--##RETURNS Doesn't use


CREATE          PROCEDURE [dbo].[spFarmPanel_PostOwnerData]
	@idfOwner bigint,			--##PARAM @idfOwner - farm owner ID
	@idfRootOwner bigint OUTPUT,--##PARAM @idfOwner - ID of root owner copy
	@strOwnerLastName nvarchar(200),	--##PARAM @strOwnerLastName - farm owner last name
	@strOwnerFirstName nvarchar(200),	--##PARAM @strOwnerFirstName - farm owner first name
	@strOwnerSecondName nvarchar(200),	--##PARAM @strOwnerSecondName - farm owner second name
	@blnRootFarm bit	
AS
	IF @idfOwner IS NULL
		RETURN 0
		
	SET @strOwnerLastName = RTRIM(ISNULL(@strOwnerLastName,N''))
	SET @strOwnerFirstName = RTRIM(ISNULL(@strOwnerFirstName,N''))
	SET @strOwnerSecondName = RTRIM(ISNULL(@strOwnerSecondName,N''))
	
	declare	@idfEmployerAddress			bigint
	declare	@idfRegistrationAddress		bigint				 			 

	IF @blnRootFarm = 0 --- Case-related owner
	BEGIN
		--Root owner
		IF @idfRootOwner IS NULL
		BEGIN		 			 
			 exec spsysGetNewID @idfEmployerAddress output
			 exec spsysGetNewID @idfRegistrationAddress output
			 
			 INSERT INTO tlbGeoLocationShared
			   (
				idfGeoLocationShared
				,idfsGeoLocationType				
			   )
			 VALUES
				   (
					@idfEmployerAddress
					,10036001 --'lctAddress'				
				   )
					
			INSERT INTO tlbGeoLocationShared
			   (
				idfGeoLocationShared
				,idfsGeoLocationType				
			   )
			 VALUES
				   (
					@idfRegistrationAddress
					,10036001 --'lctAddress'				
				   )
					 	
			 EXEC dbo.spsysGetNewID @idfRootOwner OUTPUT
			 INSERT INTO tlbHumanActual(
						[idfHumanActual]
					   ,[strLastName]
					   ,[strSecondName]
					   ,[strFirstName]					   
					   ,idfEmployerAddress
					   ,idfRegistrationAddress
					)
			 VALUES(
						@idfRootOwner
					   ,@strOwnerLastName
					   ,@strOwnerSecondName
					   ,@strOwnerFirstName					   
					   ,@idfEmployerAddress
					   ,@idfRegistrationAddress
					)						

		END
		ELSE
		BEGIN
				UPDATE tlbHumanActual
				SET strLastName=@strOwnerLastName,
					strFirstName=@strOwnerFirstName,
					strSecondName=@strOwnerSecondName
				WHERE 
					idfHumanActual = @idfRootOwner
					AND (strLastName<>@strOwnerLastName
					OR strFirstName<>@strOwnerFirstName
					OR strSecondName<>@strOwnerSecondName)
			
		END

		IF EXISTS (SELECT idfHuman FROM	tlbHuman
					WHERE (idfHuman = @idfOwner))
		BEGIN
			--Mike: I commented this check because sometimes we need to replace existing farm using new root farm
			--in this case we doen't change farm/owner id, but replace links to root oblects.
			-- check!
			--if exists  (SELECT idfHuman FROM	tlbHuman
			--		WHERE (idfHuman = @idfOwner)
			--		and idfHumanActual <> @idfRootOwner)
			--begin
			--	raiserror('Try to change record with incorrect RootHuman in [spFarmPanel_PostOwnerData]',16,1)
			--	return 0
			--end
			-- update
			UPDATE tlbHuman
			SET strLastName=@strOwnerLastName,
				strFirstName=@strOwnerFirstName,
				strSecondName=@strOwnerSecondName,
				idfHumanActual=@idfRootOwner
			WHERE 
				idfHuman = @idfOwner
				AND (strLastName<>@strOwnerLastName
				OR strFirstName<>@strOwnerFirstName
				OR strSecondName<>@strOwnerSecondName
				OR idfHumanActual<>@idfRootOwner
				)
		END
		ELSE
		BEGIN
			INSERT INTO tlbHuman(
						[idfHuman]
						,idfHumanActual
					   ,[strLastName]
					   ,[strSecondName]
					   ,[strFirstName]					   
					)
			 VALUES(
						@idfOwner
						,@idfRootOwner
					   ,@strOwnerLastName
					   ,@strOwnerSecondName
					   ,@strOwnerFirstName					   
					)		
		END
		--- in version4 farm owner dasn't related to case
	END
	ELSE --- root owner
	BEGIN
		SET @idfRootOwner = @idfOwner
		
		IF EXISTS (SELECT idfHumanActual FROM	tlbHumanActual
					WHERE (idfHumanActual = @idfOwner))
		BEGIN
			UPDATE tlbHumanActual
			SET strLastName=@strOwnerLastName,
				strFirstName=@strOwnerFirstName,
				strSecondName=@strOwnerSecondName
			WHERE 
				idfHumanActual = @idfOwner
				AND (strLastName<>@strOwnerLastName
				OR strFirstName<>@strOwnerFirstName
				OR strSecondName<>@strOwnerSecondName
				)
		END
		ELSE
		BEGIN			
			 exec spsysGetNewID @idfEmployerAddress output
			 exec spsysGetNewID @idfRegistrationAddress output
			 
			 INSERT INTO tlbGeoLocationShared
			   (
				idfGeoLocationShared
				,idfsGeoLocationType				
			   )
			 VALUES
				   (
					@idfEmployerAddress
					,10036001 --'lctAddress'				
				   )
					
			INSERT INTO tlbGeoLocationShared
			   (
				idfGeoLocationShared
				,idfsGeoLocationType				
			   )
			 VALUES
				   (
					@idfRegistrationAddress
					,10036001 --'lctAddress'				
				   )
		
			INSERT INTO tlbHumanActual(
						idfHumanActual
					   ,[strLastName]
					   ,[strSecondName]
					   ,[strFirstName]
					   ,idfEmployerAddress
					   ,idfRegistrationAddress					   
					)
			 VALUES(
						@idfRootOwner
					   ,@strOwnerLastName
					   ,@strOwnerSecondName
					   ,@strOwnerFirstName
					   ,@idfEmployerAddress
					   ,@idfRegistrationAddress
					)		
		END
	END
 



