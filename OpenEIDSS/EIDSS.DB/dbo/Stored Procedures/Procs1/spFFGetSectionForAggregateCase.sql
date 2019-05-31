
-- =============================================
-- Author:		Leonov Eugene
-- Create date: 24.05.2013
-- Description:	Select actual special section for Aggregate case
-- =============================================

CREATE PROCEDURE [dbo].[spFFGetSectionForAggregateCase] 
(	
	@idfsFormTemplate Bigint = Null
	,@idfsFormType Bigint = Null	
	,@idfsSection Bigint Output
	,@idfsMatrixType Bigint Output
)
AS
Begin	
	SET NOCOUNT ON;
	
	declare @idfsCountry bigint
	declare @idfsActualFormTemplate bigint 
	declare @idfFormType_ Bigint
	
	Select @idfsSection = Null, @idfsMatrixType = null;
	
	select @idfsCountry = dbo.fnCurrentCountry()
	
	if @idfsFormTemplate is null
		exec spFFGetActualTemplate @idfsCountry, null, @idfsFormType, @idfsFormTemplate output, 0
	
	If (@idfsFormTemplate Is Not null) Begin
	    Select @idfFormType_ = idfsFormType From dbo.ffFormTemplate Where idfsFormTemplate = @idfsFormTemplate
	    Select Top 1 @idfsSection = S.idfsSection, @idfsMatrixType = S.idfsMatrixType from dbo.ffSection S
		Inner Join dbo.trtMatrixType MT On S.idfsMatrixType = MT.idfsMatrixType And MT.idfsFormType = @idfFormType_ And MT.intRowStatus = 0
		Inner Join dbo.ffSectionForTemplate ST On S.idfsSection = ST.idfsSection And ST.idfsFormTemplate = @idfsFormTemplate And ST.intRowStatus = 0
		Where S.idfsParentSection is Null
	end
END


