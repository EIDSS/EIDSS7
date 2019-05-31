

--##SUMMARY delete record from locBaseReference and translations

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.04.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

EXEC	dbo.spAsReferenceDelete 126330000000		
				
*/ 

CREATE PROCEDURE [dbo].[spAsReferenceDelete]
	@idflBaseReference			bigint
AS
BEGIN
	-- delete from locStringNameTranslation
	delete	
	  from	locStringNameTranslation
	 where	idflBaseReference = @idflBaseReference
	-- delete from locBaseReference
	delete
	  from	locBaseReference
	 where	idflBaseReference = @idflBaseReference

	return 0
END


