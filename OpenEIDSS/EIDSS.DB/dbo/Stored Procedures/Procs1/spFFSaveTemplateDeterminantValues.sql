

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFSaveTemplateDeterminantValues
(
	@idfDeterminantValue Bigint Output
    ,@idfsFormTemplate Bigint
    ,@idfsBaseReference Bigint = Null
    ,@idfsGISBaseReference Bigint = Null	    
)
AS
BEGIN
	Set Nocount On;
	
	-- если id < 0, значит, это временный id и нужно заменить его на настоящий
	If (@idfDeterminantValue < 0) Exec dbo.[spsysGetNewID] @idfDeterminantValue Output
	
	If Not Exists (Select Top 1 1 From dbo.ffDeterminantValue Where [idfDeterminantValue] = @idfDeterminantValue) BEGIN
		 Insert into [dbo].[ffDeterminantValue]
           (
           		[idfDeterminantValue]
				,[idfsFormTemplate]
				,[idfsBaseReference]
				,[idfsGISBaseReference]
           )
		Values
           (
           		@idfDeterminantValue
				,@idfsFormTemplate
				,@idfsBaseReference
				,@idfsGISBaseReference
           )           
	End Else BEGIN
	      Update [dbo].[ffDeterminantValue]
           Set           		
				[idfsFormTemplate] =@idfsFormTemplate 
				,[idfsBaseReference] = @idfsBaseReference
				,[idfsGISBaseReference] = @idfsGISBaseReference
				,[intRowStatus] = 0
	      Where
				[idfDeterminantValue] = @idfDeterminantValue
	End
	
END

