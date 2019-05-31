

--##SUMMARY delete layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 22.07.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:


EXEC	[dbo].[spAsLayout_Delete]	708000000000			
*/ 

create PROCEDURE [dbo].[spAsLayout_Delete]
	 @idflLayout				bigint
AS
BEGIN
	declare @strLang	nvarchar(50)

    DECLARE ViewDelete_Cursor CURSOR FOR 
		select	strBaseReferenceCode 
		from	trtBaseReference 
		where	idfsReferenceType = 19000049 
		and		intRowStatus = 0

    OPEN ViewDelete_Cursor;
    FETCH NEXT FROM ViewDelete_Cursor INTO @strLang;

    WHILE @@FETCH_STATUS = 0
    BEGIN
		--PRINT @idflUserChartName
		exec [dbo].[spAsView_Delete]  @strLang, @idflLayout 
	
		FETCH NEXT FROM ViewDelete_Cursor INTO @strLang;
    END;
  
    CLOSE ViewDelete_Cursor;
    DEALLOCATE ViewDelete_Cursor;
    
    
	declare @idflDescription	bigint

	select	@idflDescription = idflDescription
	from	dbo.tasLayout
	where	idflLayout = @idflLayout

	declare @LayoutSearchField table (
		idflLayoutSearchFieldName bigint not null primary key
	)
	
	insert into @LayoutSearchField (idflLayoutSearchFieldName)
	select lsf.idflLayoutSearchFieldName
	from tasLayoutSearchField lsf
	where	lsf.idflLayout = @idflLayout

	-- deleting layout search fields
	delete 
	from  tasLayoutSearchField 
	where	idflLayout = @idflLayout

	-- deleting LayoutToMapImage
	delete ltmi
	from tasLayoutToMapImage ltmi
	where ltmi.idflLayout = @idflLayout

	-- delete field names from locBaseReference
	delete lsnt
	from locStringNameTranslation lsnt
	inner join @LayoutSearchField lsfn
	on lsfn.idflLayoutSearchFieldName = lsnt.idflBaseReference
	
	delete lbr
	from locBaseReference lbr 
	inner join @LayoutSearchField lsfn
	on lsfn.idflLayoutSearchFieldName = lbr.idflBaseReference	
	
	-- deleting from layout table
	delete
	from	tasLayout
	where	idflLayout = @idflLayout


	-- deleting references	
	exec spAsReferenceDelete  @idflDescription
	exec spAsReferenceDelete  @idflLayout

	return 0
END

