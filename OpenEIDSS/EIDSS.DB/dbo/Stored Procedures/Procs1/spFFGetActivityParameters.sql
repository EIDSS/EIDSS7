

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 
-- Description:	
-- =============================================

--##REMARKS Update date: 22.05.2013 by Romasheva S.



create PROCEDURE dbo.spFFGetActivityParameters
(	
	@observationList Nvarchar(max)		
	,@LangID Nvarchar(50) = Null	
)	
AS
BEGIN	
	Set Nocount On;
	
	Declare @ResultTable Table (
		[idfObservation] Bigint
		,[idfsFormTemplate] Bigint
		,[idfsParameter] Bigint
		,[idfsSection] Bigint
		,[idfRow] Bigint
		,[intNumRow] Int
		,[Type] Bigint
		,[varValue]	Sql_variant
		,[strNameValue] Nvarchar(200)
		,[numRow] Int
	)	
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
	Declare @observationsTable Table
	(
		[idfObservation] Bigint
		,[idfVersion] Bigint
		,[intRowNumber] Int
	)
	
	Insert into @observationsTable([idfObservation], [intRowNumber])
	Select Cast([Value] As Bigint), Row_number() Over (Order By [Value]) 
		From [dbo].[fnsysSplitList](@observationList, null, null)
		
	Insert into @ResultTable
	(
		idfObservation
		,idfsFormTemplate
		,idfsParameter
		,idfsSection
		,idfRow
		,varValue
		,[Type]
		,[numRow]
	)	
	Select
		AP.idfObservation
		,O.idfsFormTemplate
		,AP.idfsParameter
		,P.idfsSection
		,AP.idfRow
		,AP.varValue
		,dbo.fnFFGetTypeActivityParameters(AP.	idfsParameter)
		,Row_number() Over (Partition By AP.[idfObservation] Order By AP.[idfRow])
	 From dbo.tlbActivityParameters AP
	    Left Join dbo.ffParameter P On P.idfsParameter = AP.idfsParameter And P.intRowStatus = 0
		Inner Join dbo.tlbObservation O On AP.idfObservation = O.idfObservation
		Where AP.idfObservation In
		(Select [idfObservation] From @observationsTable)
		 And AP.[intRowStatus] = 0 And O.[intRowStatus] = 0
	Order By AP.[idfObservation], P.idfsSection,  AP.idfRow
	
	Declare @MatrixInfo As Table 
	(
		[idfVersion] Bigint
		,[idfsAggrCaseType] Bigint
		,[idfAggregateCaseSection] Bigint
	)
	
	Declare @matrixTable As Table 
	(
		idfVersion Bigint
		,idfRow Bigint
		,idfsParameter Bigint
		,strDefaultParameterName Nvarchar(400)
		,idfsParameterValue Sql_variant
		,NumRow Int
		,[strNameValue] Nvarchar(200)
		,[idfsSection] Bigint
		,[langid] Nvarchar(20)	
	)
	
	Declare @rowCount Int, @currentRow Int, @currentObservation Bigint, @idfVersion Bigint
	,@NumRow Int, @idfRow Bigint, @CurrentIdfRow Bigint, @type Bigint
	,@innerCurrentRow Int, @innerRowCount Int, @idfsParameter Bigint, @idfsSection Bigint, @idfsCurrentSection Bigint
	
	Select @rowCount = Max([intRowNumber]) From @observationsTable
	
	DECLARE @OldType BIGINT = 0
	
	Set @currentRow = 1;	
	While(@currentRow <= @rowCount) Begin
			Select @currentObservation = [idfObservation] From @observationsTable Where intRowNumber = @currentRow;
			Delete from @MatrixInfo
			Insert into @MatrixInfo Exec dbo.spAggregateObservation_GetMatrixVersion @currentObservation
			Select Top 1 @idfVersion = [idfVersion] From @MatrixInfo
			
			If (@idfVersion Is Null) Begin
				Select Top 1 @idfVersion = [idfVersion] From dbo.tlbAggrMatrixVersionHeader Where idfsMatrixType in (Select Top 1 [idfAggregateCaseSection] From @MatrixInfo) And [blnIsActive]= 1 ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC
			End;
			Update @observationsTable
				Set [idfVersion] = @idfVersion Where intRowNumber = @currentRow;	
						
			Select @innerRowCount = Null
			Select @innerRowCount = Max([numRow]) From @ResultTable Where [Type] = 1 And [idfObservation] = @currentObservation
			
			If (@innerRowCount > 0) Begin									
					Select @NumRow = -1, @CurrentIdfRow = 0, @innerCurrentRow = 1;				
					
					
					Declare curs Cursor Local Forward_only Static For
						Select [idfRow],[idfsSection]	From @ResultTable Where [Type] = 1 And [idfObservation] = @currentObservation
						
					Open curs
						Fetch Next From curs into @idfRow,@idfsSection
						
						While @@FETCH_STATUS = 0 Begin					
							If (@idfsCurrentSection Is Null) Set @idfsCurrentSection = @idfsSection;
							
							If  (@idfsCurrentSection <> @idfsSection) Begin								
								Set @idfsCurrentSection = @idfsSection;
								Set @NumRow = -1;
							end
							
							If (@CurrentIdfRow <> @idfRow) BEGIN
								Set @CurrentIdfRow = @idfRow;                                          	
								Set @NumRow = @NumRow + 1;
							    
								Update @ResultTable
								Set			    	
			    					[intNumRow] = @NumRow
								Where
									[idfRow] = @idfRow
									And [idfObservation] = @currentObservation							    	
							End
							
							Fetch Next From curs into @idfRow,@idfsSection
						End
					
					Close curs
					Deallocate curs
			End
			
			Select @innerRowCount = Null
			Select @innerRowCount = Max([numRow]) From @ResultTable Where [Type] > 1 And [idfObservation] = @currentObservation
					
			If (@innerRowCount > 0) Begin
				Select @NumRow = Null, @idfRow = Null, @innerCurrentRow = 1;
				
				Declare curs Cursor Local Forward_only Static For
						Select [idfRow], [Type] From @ResultTable Where [Type] > 1 And [idfObservation] = @currentObservation
					
				Open curs
					Fetch Next From curs into @idfRow, @type
					
					While @@FETCH_STATUS = 0 Begin
						
						IF @OldType <> ISNULL(@type, -1)
						BEGIN
							Delete from @matrixTable
							Insert into @matrixTable Exec dbo.spFFGetPredefinedStub @type, @idfVersion, @langid_int	
							
							SET @OldType = 	ISNULL(@type, 0)	
						END	
						
						Set  @NumRow = Null   
						Select @NumRow = [NumRow] From @matrixTable Where [idfRow] = @idfRow
						
						Update @ResultTable
						Set			    	
	    					[intNumRow] = @NumRow
						Where
							[idfRow] = @idfRow
							And [idfObservation] = @currentObservation;
							
						Fetch Next From curs into @idfRow, @type
					End
				
				Close curs
				Deallocate curs
			
			End
				
			Set @currentRow = @currentRow + 1;
	End	
	
	Update @ResultTable
	Set [intNumRow] = 0
	Where [Type] = 0	
	
	Update @ResultTable
		Set RT.[strNameValue] = IsNull(SNT.[strTextString], BR.[strDefault])	
		From @ResultTable As RT
		Inner Join dbo.ffParameter P On RT.idfsParameter = P.idfsParameter And P.idfsEditor = 10067002 And P.[intRowStatus] = 0
		Inner Join dbo.trtBaseReference BR On BR.idfsBaseReference = CASE WHEN (sql_variant_property(RT.varValue, 'BaseType') = 'bigint') or 
			(sql_variant_property(RT.varValue, 'BaseType') = 'nvarchar' and IsNumeric(CAST(RT.varValue AS NVARCHAR)) = 1)
			then CAST(RT.varValue as bigint) 
			else -1 end
		Left Join dbo.trtStringNameTranslation SNT On SNT.idfsBaseReference = RT.varValue And SNT.idfsLanguage = @langid_int And SNT.[intRowStatus] = 0
	
	Select
		[idfObservation]
		,[idfsFormTemplate]
		,[idfsParameter]
		,[idfsSection]
		,[idfRow]
		,[intNumRow]
		,[Type]
		,[varValue]	
		,[strNameValue]	
		,[numRow]
		, 0 as [FakeField]
	From @ResultTable
	Order By
		[idfObservation], [idfsParameter], [idfRow]
	
End

