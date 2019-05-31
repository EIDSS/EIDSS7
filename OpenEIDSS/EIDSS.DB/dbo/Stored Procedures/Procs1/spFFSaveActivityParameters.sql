

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 
-- Description:
-- =============================================
CREATE Procedure [dbo].[spFFSaveActivityParameters]
(
	@idfsParameter Bigint
	,@idfObservation Bigint  
	,@idfsFormTemplate Bigint   
    ,@varValue Sql_variant
    ,@idfRow Bigint Output
    ,@IsDynamicParameter Bit = 0
	,@idfActivityParameters BIGINT = NULL OUTPUT
)	
AS
BEGIN	
	Set Nocount On;	

	-- определим, нужно ли сохранять данные по этому параметру
	-- данные можно сохранять если только этот параметр принадлежит шаблону
	If (@IsDynamicParameter = 0) Begin
		If Not Exists(
					Select Top 1 1 From dbo.ffParameterForTemplate Where idfsParameter = @idfsParameter And idfsFormTemplate = @idfsFormTemplate And intRowStatus = 0
						
		) Return;
	End;
	
	-- если нет observation, то выходим (он мог быть создан и удалён носителем FFPresenter во время сеанса)
	If Not Exists (Select Top 1 1 From dbo.tlbObservation Where idfObservation = @idfObservation) Return;

	-- если id < 0, значит, это временный id и нужно заменить его на настоящий
	If (@idfRow < 0) BEGIN
		DECLARE @idSection BIGINT
		SELECT @idSection = [idfsSection] FROM dbo.ffParameter WHERE idfsParameter = @idfsParameter;
		DECLARE @isSectionTable BIT
		SET @isSectionTable = 0;
		IF (@idSection IS NOT NULL) BEGIN
			SELECT @isSectionTable = [blnGrid] FROM dbo.ffSection WHERE idfsSection = @idSection;
			IF (@isSectionTable = 1) begin
				Exec dbo.[spsysGetNewID] @idfRow OUTPUT
			END ELSE BEGIN
			    SET @idfRow = 0;     	
			END
		END ELSE BEGIN
		    SET @idfRow = 0;     	
		END
	END

	-- если переданное значение пустое, то надо удалить эту строку
	If ((@varValue Is Null) Or (Len(cast(@varValue As Varchar(Max))) = 0)) Begin
			Exec dbo.spFFRemoveActivityParameters @idfsParameter, @idfObservation, @idfRow                                                  	
	End Else BEGIN	
			If Not Exists (Select Top 1 1 From dbo.tlbActivityParameters Where [idfsParameter] = @idfsParameter And [idfObservation] = @idfObservation And [idfRow] = @idfRow) BEGIN
					 
					IF @idfActivityParameters IS NULL
					BEGIN
						EXEC spsysGetNewID @idfActivityParameters OUTPUT
					END
					 
					 Insert into [dbo].[tlbActivityParameters]
							 (
							 		idfActivityParameters
			   						,[idfsParameter]
									,[idfObservation]
									,[varValue]
									,[idfRow]		
							)
					VALUES
							(
									@idfActivityParameters
									,@idfsParameter
									,@idfObservation
									,@varValue
									,@idfRow
							)
			End Else BEGIN
				   Update [dbo].[tlbActivityParameters]
							   SET 								
									[varValue] = @varValue
									,[intRowStatus] = 0									
								WHERE [idfsParameter] = @idfsParameter And [idfObservation] = @idfObservation And [idfRow] = @idfRow
			End
	 END		
End

