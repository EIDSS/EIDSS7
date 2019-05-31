



CREATE Procedure [dbo].[spFFGetFormTemplate]
(
	@idfsDiagnosis BIGINT,
	@idfsFormType BIGINT,
	@idfsFormTemplate BIGINT OUTPUT
)
As
BEGIN

DECLARE @idfsCountry AS BIGINT
SET @idfsCountry = CAST (dbo.fnCurrentCountry() as NVARCHAR)

Declare @tmpTemplate as Table(idfsFormTemplate bigint, IsUNITemplate BIT)

Insert Into @tmpTemplate EXECUTE spFFGetActualTemplate 
   @idfsCountry
  ,@idfsDiagnosis
  ,@idfsFormType

Select TOP 1 @idfsFormTemplate = idfsFormTemplate
From @tmpTemplate

IF @idfsFormTemplate = -1
	SET @idfsFormTemplate = NULL
	
END



