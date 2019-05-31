

-- ================================================================================================
-- Name: FN_ADMIN_FF_FullPathBySections_GET
-- Description: Gets Full paths By Sections.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
Create Function [dbo].[FN_ADMIN_FF_FullPathBySections_GET]
(
	@LangID Nvarchar(50) = null
	,@idfsSection Bigint
)
Returns
@ResultTable Table
(
	[FullPathStr] Nvarchar(Max) COLLATE database_default
	,[FullPathIdfs] Nvarchar(Max) COLLATE database_default
)
AS
Begin
	If (@LangID Is Null) Set @LangID = 'en';
	
	DECLARE @idfsParentSection Bigint,  
			@DefaultName Nvarchar(400), 
			@NationalName Nvarchar(600)
	
	SELECT @idfsParentSection = S.idfsParentSection,  
		   @DefaultName = RF.strDefault, 
		   @NationalName = RF.[name]
	FROM dbo.ffSection S 
	INNER JOIN dbo.fnReference(@LangID, 19000101/*'rftSection'*/) RF On S.idfsSection = RF.idfsReference
	WHERE S.idfsSection = @idfsSection
	AND S.intRowStatus = 0
			
	--
	DECLARE @FullPathStr Nvarchar(Max),
			@FullPathIdfs Nvarchar(Max)
	
	SELECT @FullPathStr = Isnull(@NationalName, @DefaultName), 
		   @FullPathIdfs = @idfsSection;
	
	If (@idfsParentSection Is Not null) 
	BEGIN
	     DECLARE @parentFullPathStr Nvarchar(Max), 
				 @parentFullPathIdfs Nvarchar(Max)
	     
		 SELECT @parentFullPathStr = '', 
				@parentFullPathIdfs = '';
	     SELECT @parentFullPathStr = [FullPathStr], 
				@parentFullPathIdfs = [FullPathIdfs] 
		 FROM dbo.fnFFGetFullPathBySections(@LangID, @idfsParentSection);  
		           	
		 SELECT @FullPathStr = @parentFullPathStr + ' > ' + @FullPathStr, 
				@FullPathIdfs = @parentFullPathIdfs +';' + @FullPathIdfs
	END
     
	INSERT INTO @ResultTable
	(
		FullPathStr,
		FullPathIdfs
	)
	VALUES
	(
		@FullPathStr
		,@FullPathIdfs
	)
	
	Return
END


