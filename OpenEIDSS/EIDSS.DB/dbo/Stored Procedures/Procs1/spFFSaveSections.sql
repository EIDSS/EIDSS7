

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Description:	
-- =============================================
Create Procedure dbo.spFFSaveSections
(
	@idfsSection Bigint Output
    ,@idfsParentSection Bigint = Null
    ,@idfsFormType Bigint
    ,@DefaultName Nvarchar(400)
    ,@NationalName Nvarchar(600) = Null
    ,@LangID Nvarchar(50) = Null
    ,@intOrder Int = 0
    ,@blnGrid Bit = 0
    ,@blnFixedRowset Bit = 0
	,@idfsMatrixType Bigint = null
)	
AS
BEGIN	
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	
	-- если id < 0, значит, это временный id и нужно заменить его на настоящий
	If (@idfsSection <= 0) Exec dbo.[spsysGetNewID] @idfsSection Output
	if (@idfsParentSection <= 0) set @idfsParentSection = null;

	-- сохраняем названия
	Exec dbo.spBaseReference_SysPost @idfsSection, 19000101 /*'rftSection'*/, @LangID, @DefaultName, @NationalName, 0
	
	If Not Exists (Select Top 1 1 From dbo.ffSection Where idfsSection = @idfsSection) BEGIN
		 Insert into [dbo].[ffSection]
			   (
			   		[idfsSection]
				   ,[idfsParentSection]
				   ,[idfsFormType]	
				   ,[intOrder]
				   ,[blnGrid]
				   ,[blnFixedRowSet]
				   ,[idfsMatrixType]
			   )
		 Values
			   (
			   		@idfsSection
				   ,@idfsParentSection
				   ,@idfsFormType
				   ,@intOrder
				   ,@blnGrid
				   ,@blnFixedRowset
				   ,@idfsMatrixType
			   )
	End Else BEGIN
	         	Update [dbo].[ffSection]
				   Set 
						[idfsParentSection] = @idfsParentSection
						,[idfsFormType] = @idfsFormType	
						,[intOrder] = @intOrder
						,[blnGrid] = @blnGrid
						,[blnFixedRowSet] = @blnFixedRowset
						,[intRowStatus] = 0
						,[idfsMatrixType] = @idfsMatrixType
				  Where [idfsSection] = @idfsSection
	End	
End

