

--##SUMMARY post layout search fields (with aggregate functions) for analytical module

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 03.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##REMARKS UPDATED BY: Vasilyev I.
--##REMARKS Date: 11.01.2012


--##RETURNS Don't use

/*
--Example of a call of procedure:



exec spAsLayoutSearchFieldPost 
@LangID=N'en',
@idflLayout=708000000000,
@LayoutSearchFieldXml=
N'<ItemList>
	<Item  idfLayoutSearchField="51589910000000" idfsAggregateFunction="10004002" idfsBasicCountFunction = "10004002" strSearchFieldAlias="sflHC_CaseID" strOriginalFieldENCaption="Human Case - Case ID" strOriginalFieldCaption="Human Case - Case ID" strNewFieldENCaption="" strNewFieldCaption="" idfsGroupDate="" blnShowMissedValue="0" datDiapasonStartDate="" datDiapasonEndDate="" intPrecision="-1" intFieldCollectionIndex="12" intPivotGridAreaType="3" intFieldPivotGridAreaIndex="0" blnVisible="1" blnHiddenFilterField="0" intFieldColumnWidth="100" blnSortAcsending="1" idfUnitLayoutSearchField="" idfDateLayoutSearchField="" />
	<Item  idfLayoutSearchField="51589920000000" idfsAggregateFunction="10004002" idfsBasicCountFunction = "10004002"  strSearchFieldAlias="sflHC_CaseID" strOriginalFieldENCaption="Human Case - Case ID" strOriginalFieldCaption="Human Case - Case ID" strNewFieldENCaption="" strNewFieldCaption="" idfsGroupDate="" blnShowMissedValue="0" datDiapasonStartDate="" datDiapasonEndDate="" intPrecision="-1" intFieldCollectionIndex="13" intPivotGridAreaType="2" intFieldPivotGridAreaIndex="6" blnVisible="1" blnHiddenFilterField="1" intFieldColumnWidth="100" blnSortAcsending="1" idfUnitLayoutSearchField="" idfDateLayoutSearchField="" />
</ItemList>'

*/ 


create  PROCEDURE [dbo].[spAsLayoutSearchFieldPost]
	@LangID						as nvarchar(50),
	@idflLayout					as bigint,
	@LayoutSearchFieldXml	as XML
AS
BEGIN

	if	not exists	(	 
						select	1
						from	tasLayout
						where	idflLayout = @idflLayout
					)
	begin
		RAISERROR (N'Layout with ID=%I64d doesnt exist.', 15, 1,  @idflLayout)
		return 1
	end

	
	DECLARE @SearchFieldTable	TABLE
	(
		 idfLayoutSearchField		BIGINT
		,idfsAggregateFunction		BIGINT
		,idfsBasicCountFunction		BIGINT
		,strSearchFieldAlias		NVARCHAR(MAX)
		,strOriginalFieldENCaption	NVARCHAR(MAX)
		,strOriginalFieldCaption	NVARCHAR(MAX)
		,strNewFieldENCaption		NVARCHAR(MAX)
		,strNewFieldCaption			NVARCHAR(MAX)
		,idfUnitLayoutSearchField	BIGINT
		,idfDateLayoutSearchField	BIGINT
		,strFieldFilterValues		NVARCHAR(MAX)
			
		,idfsGroupDate				BIGINT	
		,blnShowMissedValue			BIT
		,datDiapasonStartDate		DATETIME
		,datDiapasonEndDate			DATETIME
		,intPrecision				INT
		,intFieldCollectionIndex	INT
		,intPivotGridAreaType		INT
		,intFieldPivotGridAreaIndex INT
		,blnVisible					BIT
		,blnHiddenFilterField		BIT
		,intFieldColumnWidth		INT
		,blnSortAcsending			BIT
			
	)	
	DECLARE @SearchFieldAliasTable	TABLE
	(
		 idfQuerySearchField		BIGINT
		,strSearchFieldAlias		NVARCHAR(MAX)
	)
	DECLARE @SearchFieldIdTable	TABLE
	(
		idfLayoutSearchField		bigint
	)


	-- convert search field names from XML to table
	DECLARE @iSearchField	INT
	EXEC sp_xml_preparedocument @iSearchField OUTPUT, @LayoutSearchFieldXml

	INSERT INTO @SearchFieldTable 
	(
		 idfLayoutSearchField			
		,idfsAggregateFunction			
		,idfsBasicCountFunction
		,strSearchFieldAlias
		,strOriginalFieldENCaption
		,strOriginalFieldCaption
		,strNewFieldENCaption
		,strNewFieldCaption
		,idfUnitLayoutSearchField		
		,idfDateLayoutSearchField	
		,strFieldFilterValues
		
		,idfsGroupDate				
		,blnShowMissedValue			
		,datDiapasonStartDate		
		,datDiapasonEndDate			
		,intPrecision				
		,intFieldCollectionIndex	
		,intPivotGridAreaType		
		,intFieldPivotGridAreaIndex 
		,blnVisible					
		,blnHiddenFilterField		
		,intFieldColumnWidth		
		,blnSortAcsending			
	) 
	SELECT * 
	FROM OPENXML (@iSearchField, '/ItemList/Item')
	WITH 
	( 
		 idfLayoutSearchField		BIGINT			'@idfLayoutSearchField'
		,idfsAggregateFunction		BIGINT			'@idfsAggregateFunction'
		,idfsBasicCountFunction		BIGINT			'@idfsBasicCountFunction'
		,strSearchFieldAlias		NVARCHAR(MAX)	'@strSearchFieldAlias'
		,strOriginalFieldENCaption	NVARCHAR(MAX)	'@strOriginalFieldENCaption'
		,strOriginalFieldCaption	NVARCHAR(MAX)	'@strOriginalFieldCaption'
		,strNewFieldENCaption		NVARCHAR(MAX)	'@strNewFieldENCaption'
		,strNewFieldCaption			NVARCHAR(MAX)	'@strNewFieldCaption'
		,idfUnitLayoutSearchField	BIGINT			'@idfUnitLayoutSearchField'
		,idfDateLayoutSearchField	BIGINT			'@idfDateLayoutSearchField'
		,strFieldFilterValues		NVARCHAR(max)  '@strFieldFilterValues'
		
		,idfsGroupDate				BIGINT			'@idfsGroupDate'
		,blnShowMissedValue			BIT				'@blnShowMissedValue'
		,datDiapasonStartDate		DATETIME		'@datDiapasonStartDate'
		,datDiapasonEndDate			DATETIME		'@datDiapasonEndDate'
		,intPrecision				INT				'@intPrecision'
		,intFieldCollectionIndex	INT				'@intFieldCollectionIndex'
		,intPivotGridAreaType		INT				'@intPivotGridAreaType'
		,intFieldPivotGridAreaIndex INT				'@intFieldPivotGridAreaIndex'
		,blnVisible					BIT				'@blnVisible'
		,blnHiddenFilterField		BIT				'@blnHiddenFilterField'
		,intFieldColumnWidth		INT				'@intFieldColumnWidth'
		,blnSortAcsending			BIT				'@blnSortAcsending'
	)												 

	EXEC sp_xml_removedocument @iSearchField
	
	UPDATE	@SearchFieldTable
	SET		idfUnitLayoutSearchField = NULL
	WHERE	idfUnitLayoutSearchField = N''
	
	UPDATE	@SearchFieldTable
	SET		idfDateLayoutSearchField = NULL
	WHERE	idfDateLayoutSearchField = N''
	
	UPDATE	@SearchFieldTable
	SET		strFieldFilterValues = NULL
	WHERE	strFieldFilterValues = N''
	
	UPDATE	@SearchFieldTable
	SET		idfsGroupDate = NULL
	WHERE	idfsGroupDate = N''
	
	UPDATE	@SearchFieldTable
	SET		datDiapasonStartDate = NULL
	WHERE	datDiapasonStartDate = N''

	UPDATE	@SearchFieldTable
	SET		datDiapasonEndDate = NULL
	WHERE	datDiapasonEndDate = N''
		
	-- create cashe for SearchField aliases
	insert into @SearchFieldAliasTable
	SELECT * FROM dbo.fnLayoutSearchFields(@idflLayout)
	
	
   -- Insert (if nessesary) Layout Search Fields into table
	declare @strSearchFieldAlias NVARCHAR(MAX)
	declare @idfLayoutSearchField as BIGINT
	declare	@idfQuerySearchField as BIGINT

    DECLARE SearchFieldAlias_Cursor CURSOR FOR 
    SELECT	idfLayoutSearchField, strSearchFieldAlias
    FROM	@SearchFieldTable  

    OPEN SearchFieldAlias_Cursor;
    FETCH NEXT FROM SearchFieldAlias_Cursor INTO @idfLayoutSearchField, @strSearchFieldAlias;

    WHILE @@FETCH_STATUS = 0
    BEGIN
    	--PRINT '@idfLayoutSearchField='+cast(@idfLayoutSearchField AS NVARCHAR(100)) 
		-- if no layout search field found - insert it
		
		DECLARE @idflAlienLayout bigint
		select	@idflAlienLayout = lsf.idflLayout
		  from	tasLayoutSearchField lsf
		 where	lsf.idflLayout <> @idflLayout
		   and	lsf.idfLayoutSearchField = @idfLayoutSearchField
		if @idflAlienLayout IS NOT NULL 
		begin
		RAISERROR (N'Error inserting field with ID=%I64d into Layout %I64d because it already belongs to Layout with ID=%I64d.', 15, 1,  @idfLayoutSearchField, @idflLayout, @idflAlienLayout)
			return 1
		end
		-- if no layout search field found - insert it
		if not exists 
		(
			select	idfLayoutSearchField
			  from	tasLayoutSearchField
			 where	idfLayoutSearchField = @idfLayoutSearchField
		)
		BEGIN
			-- get query search field id	
			select		@idfQuerySearchField = idfQuerySearchField
			from		@SearchFieldAliasTable 
			where		strSearchFieldAlias = @strSearchFieldAlias
				
			IF (@idfQuerySearchField IS null)
			BEGIN
				PRINT @strSearchFieldAlias
				RAISERROR (N'ID for search Field alias %s not found.', 15, 1,  @strSearchFieldAlias)
				return 1
			END
			insert into	tasLayoutSearchField
					   (
					   		idfLayoutSearchField
						   ,idflLayout
						   ,idfQuerySearchField
						)
				 values
					   (
					   		@idfLayoutSearchField
						   ,@idflLayout
						   ,@idfQuerySearchField
						)
		END
		
        -- insert  layout search field id in temporary table
        insert into	@SearchFieldIdTable
				   (idfLayoutSearchField)
			 values
				   (@idfLayoutSearchField)
						   
		FETCH NEXT FROM SearchFieldAlias_Cursor INTO @idfLayoutSearchField, @strSearchFieldAlias;
    END;
    
    CLOSE SearchFieldAlias_Cursor;
    DEALLOCATE SearchFieldAlias_Cursor;
   
  
   
 -- Update aggregate functions and different field aliases
	declare  @idfsAggregateFunction		as bigint
			,@idfsBasicCountFunction	as bigint
			,@idfUnitLayoutSearchField	as BIGINT
			,@idfDateLayoutSearchField	as BIGINT
			,@strFieldFilterValues		as NVARCHAR(max)
			,@idflLayoutSearchFieldName	as BIGINT
			,@strOriginalFieldENCaption	as NVARCHAR(MAX)
			,@strOriginalFieldCaption	as NVARCHAR(MAX)
			,@strNewFieldENCaption		as NVARCHAR(MAX)
			,@strNewFieldCaption		as NVARCHAR(MAX)
			,@idfsGroupDate				as BIGINT	
			,@blnShowMissedValue		as BIT
			,@datDiapasonStartDate		as DATETIME
			,@datDiapasonEndDate		as DATETIME
			,@intPrecision				as INT
			,@intFieldCollectionIndex	as INT
			,@intPivotGridAreaType		as INT
			,@intFieldPivotGridAreaIndex as INT	
			,@blnVisible				as BIT
			,@blnHiddenFilterField		as BIT
			,@intFieldColumnWidth		as INT
			,@blnSortAcsending			as BIT
										 
    DECLARE AggregateField_Cursor CURSOR FOR 
    SELECT		 idfLayoutSearchField	
				,idfsAggregateFunction	
				,idfsBasicCountFunction		
				,strSearchFieldAlias		
				,strOriginalFieldENCaption		
				,strOriginalFieldCaption
				,strNewFieldENCaption		
				,strNewFieldCaption
				,idfUnitLayoutSearchField			
				,idfDateLayoutSearchField	
				,strFieldFilterValues
				
				,idfsGroupDate				
				,blnShowMissedValue			
				,datDiapasonStartDate		
				,datDiapasonEndDate			
				,intPrecision				
				,intFieldCollectionIndex	
				,intPivotGridAreaType		
				,intFieldPivotGridAreaIndex 
				,blnVisible					
				,blnHiddenFilterField		
				,intFieldColumnWidth		
				,blnSortAcsending			

    FROM		@SearchFieldTable  

    OPEN AggregateField_Cursor;
    FETCH NEXT FROM AggregateField_Cursor INTO 
				 @idfLayoutSearchField			
				,@idfsAggregateFunction	
				,@idfsBasicCountFunction		
				,@strSearchFieldAlias		
				,@strOriginalFieldENCaption
				,@strOriginalFieldCaption		
				,@strNewFieldENCaption
				,@strNewFieldCaption		
				,@idfUnitLayoutSearchField			
				,@idfDateLayoutSearchField	
				,@strFieldFilterValues
								
				,@idfsGroupDate				
				,@blnShowMissedValue			
				,@datDiapasonStartDate		
				,@datDiapasonEndDate			
				,@intPrecision				
				,@intFieldCollectionIndex	
				,@intPivotGridAreaType		
				,@intFieldPivotGridAreaIndex 
				,@blnVisible					
				,@blnHiddenFilterField		
				,@intFieldColumnWidth		
				,@blnSortAcsending	
				 
    WHILE @@FETCH_STATUS = 0
    BEGIN
			if	not exists	(	 
							select	idfsReference
							from	dbo.fnReference('en', 19000004 /*'rftAggregateFunction'*/) as fnRef
							where	fnRef.idfsReference = @idfsAggregateFunction
						)
			begin
				RAISERROR (N'Aggregate function with ID=%I64d doesnt exist.', 15, 1,  @idfsAggregateFunction)
				return 1
			END
			
				if	not exists	(	 
							select	idfsReference
							from	dbo.fnReference('en', 19000004 /*'rftAggregateFunction'*/) as fnRef
							where	fnRef.idfsReference = @idfsBasicCountFunction
						)
			begin
				RAISERROR (N'Basic count function with ID=%I64d doesnt exist.', 15, 1,  @idfsBasicCountFunction)
				return 1
			END
			
			-- get query search field id	
			select	@idfQuerySearchField = idfQuerySearchField
			from	@SearchFieldAliasTable 
			where	strSearchFieldAlias = @strSearchFieldAlias

			-- get layout search field name id	
			select	@idflLayoutSearchFieldName = idflLayoutSearchFieldName
			from	tasLayoutSearchField 
			where	@idfLayoutSearchField = idfLayoutSearchField
			
			-- post layout search field name
			if		@idflLayoutSearchFieldName is not null
				or	@strNewFieldCaption <> @strOriginalFieldCaption 
				or	@strNewFieldENCaption <> @strOriginalFieldENCaption
			begin
				if (@idflLayoutSearchFieldName is null) 
					exec spsysGetNewID	@idflLayoutSearchFieldName output
					
				exec spAsReferencePost	'en',	@idflLayoutSearchFieldName,	@strNewFieldENCaption
				if (@LangID <> 'en')
					exec spAsReferencePost @LangID, @idflLayoutSearchFieldName,	@strNewFieldCaption
			end
			
			-- update aggreagate functions and different search fields
			-- no need to insert because all insert should be completed in previous cursor
			update	tasLayoutSearchField
			   set	 idfsAggregateFunction		= @idfsAggregateFunction
					,strReservedAttribute		= @idfsBasicCountFunction
					,idflLayoutSearchFieldName	= @idflLayoutSearchFieldName
					,idfUnitLayoutSearchField	= @idfUnitLayoutSearchField
					,idfDateLayoutSearchField	= @idfDateLayoutSearchField
					,strFieldFilterValues		= @strFieldFilterValues	
					
					,idfsGroupDate				= @idfsGroupDate				
					,blnShowMissedValue			= @blnShowMissedValue			
					,datDiapasonStartDate		= @datDiapasonStartDate		
					,datDiapasonEndDate			= @datDiapasonEndDate			
					,intPrecision				= @intPrecision				
					,intFieldCollectionIndex	= @intFieldCollectionIndex
					,intPivotGridAreaType		= @intPivotGridAreaType		
					,blnVisible					= @blnVisible
					,intFieldPivotGridAreaIndex = @intFieldPivotGridAreaIndex 
					,blnHiddenFilterField		= @blnHiddenFilterField		
					,intFieldColumnWidth		= @intFieldColumnWidth		
					,blnSortAcsending			= @blnSortAcsending	
												  
			 where	@idfLayoutSearchField = idfLayoutSearchField
			 
						   
		FETCH NEXT FROM AggregateField_Cursor INTO  
				 @idfLayoutSearchField			
				,@idfsAggregateFunction			
				,@idfsBasicCountFunction
				,@strSearchFieldAlias		
				,@strOriginalFieldENCaption		
				,@strOriginalFieldCaption
				,@strNewFieldENCaption		
				,@strNewFieldCaption
				,@idfUnitLayoutSearchField			
				,@idfDateLayoutSearchField
				,@strFieldFilterValues
												
				,@idfsGroupDate				
				,@blnShowMissedValue			
				,@datDiapasonStartDate		
				,@datDiapasonEndDate			
				,@intPrecision				
				,@intFieldCollectionIndex	
				,@intPivotGridAreaType		
				,@intFieldPivotGridAreaIndex 
				,@blnVisible					
				,@blnHiddenFilterField		
				,@intFieldColumnWidth		
				,@blnSortAcsending	
    END;
    
    CLOSE AggregateField_Cursor;
    DEALLOCATE AggregateField_Cursor;
    
    
    
   -- get extra layout search field id 
    DECLARE @ExtraSearchFieldTableId	TABLE
	(
		idfLayoutSearchField	bigint
	)
   insert into	@ExtraSearchFieldTableId
   SELECT distinct lsf.idfLayoutSearchField 
   FROM			tasLayoutSearchField lsf
   LEFT JOIN	@SearchFieldIdTable	sft
   ON			lsf.idfLayoutSearchField = sft.idfLayoutSearchField
   where		lsf.idfLayoutSearchField IS NOT NULL
   AND			sft.idfLayoutSearchField IS NULL
   AND			lsf.idflLayout = @idflLayout
   
   
   
    -- delete extra layout search field id 
   update		lsf 
   SET			lsf.idfUnitLayoutSearchField = null
   FROM			tasLayoutSearchField lsf
   INNER JOIN	@ExtraSearchFieldTableId esft
   ON			lsf.idfUnitLayoutSearchField = esft.idfLayoutSearchField
   AND			lsf.idflLayout = @idflLayout
    
   update		lsf 
   SET			lsf.idfDateLayoutSearchField = null
   FROM			tasLayoutSearchField lsf
   INNER JOIN	@ExtraSearchFieldTableId esft
   ON			lsf.idfDateLayoutSearchField = esft.idfLayoutSearchField
   AND			lsf.idflLayout = @idflLayout

   delete		
   FROM			lsf 
   FROM			tasLayoutSearchField lsf
   INNER JOIN	@ExtraSearchFieldTableId esft
   ON			lsf.idfLayoutSearchField = esft.idfLayoutSearchField 
   AND			lsf.idflLayout = @idflLayout 

END
