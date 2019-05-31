

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 22.09.09
-- Description:	Return list of Template Determinant Values
-- =============================================
CREATE PROCEDURE dbo.spFFGetTemplateDeterminantValues
(
	@LangID Nvarchar(50) = Null
	,@idfsFormTemplate Bigint = Null	
)
AS
BEGIN	
	Set Nocount On;

	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

    Select
		DV.idfDeterminantValue
		,FT.idfsFormTemplate
		,FT.idfsFormType
		,Isnull(DV.idfsBaseReference, DV.idfsGISBaseReference) as [DeterminantValue]
		,Case 
			When (DV.idfsBaseReference Is Not null) Then
				(Select [strDefault] From dbo.trtBaseReference Where [idfsBaseReference] = DV.idfsBaseReference  And [intRowStatus] = 0)
			Else
				(Select [strDefault] From dbo.gisBaseReference Where [idfsGISBaseReference] = DV.idfsGISBaseReference AND DV.intRowStatus = 0)
			End As  [DeterminantDefaultName]
		,Case
			When (DV.idfsBaseReference Is Not null) Then
				(Select [strTextString] From dbo.[trtStringNameTranslation] Where [idfsBaseReference] = DV.idfsBaseReference And idfsLanguage = @langid_int  And [intRowStatus] = 0)
			Else
				(Select [strTextString] From dbo.[gisStringNameTranslation] Where [idfsGISBaseReference] = DV.idfsGISBaseReference And idfsLanguage = @langid_int AND intRowStatus = 0)
			End As  [DeterminantNationalName]	
				
		,[idfsBaseReference]
		,[idfsGISBaseReference]
		
		,Case
			When (DV.idfsBaseReference Is Not null) Then
				(Select idfsReferenceType From dbo.trtBaseReference Where [idfsBaseReference] = DV.idfsBaseReference And [intRowStatus] = 0)
			Else
				(Select idfsGISReferenceType From dbo.gisBaseReference Where [idfsGISBaseReference] = DV.idfsGISBaseReference AND DV.intRowStatus = 0)
			End As  [DeterminantType]
			
		,Case
			When (DV.idfsBaseReference Is Not null) Then
				(Select strReferenceTypeName From dbo.trtReferenceType Where [idfsReferenceType] in
					(Select Top 1 idfsReferenceType From dbo.trtBaseReference Where [idfsBaseReference] = DV.idfsBaseReference And [intRowStatus] = 0)  And [intRowStatus] = 0

				)
			Else
				(Select strGISReferenceTypeName From dbo.gisReferenceType Where [idfsGISReferenceType] in
					(Select Top 1 idfsGISReferenceType From dbo.gisBaseReference Where [idfsGISBaseReference] = DV.idfsGISBaseReference AND DV.intRowStatus = 0) AND intRowStatus = 0
				)
			End As  [DeterminantTypeDefaultName]
			
		,Isnull(
					Case
					When (DV.idfsBaseReference Is Not null) Then
						(Select [strTextString] From dbo.[trtStringNameTranslation] Where idfsLanguage = @langid_int And [idfsBaseReference] in
							(Select Top 1 idfsReferenceType From dbo.trtReferenceType Where [idfsReferenceType] in
								(Select Top 1 idfsReferenceType From dbo.trtBaseReference Where [idfsBaseReference] = DV.idfsBaseReference And [intRowStatus] = 0) And [intRowStatus] = 0
							) And [intRowStatus] = 0
						)
					Else
						(
							Select strTextString From dbo.trtStringNameTranslation Where idfsBaseReference = 10003001 And idfsLanguage = @langid_int And [intRowStatus] = 0
						)
					End 
				,
				Case
				When (DV.idfsBaseReference Is Not null) Then
				(Select strReferenceTypeName From dbo.trtReferenceType Where [idfsReferenceType] in
					(Select Top 1 idfsReferenceType From dbo.trtBaseReference Where [idfsBaseReference] = DV.idfsBaseReference And [intRowStatus] = 0)  And [intRowStatus] = 0

				)
				Else
					(
						Select strGISReferenceTypeName From dbo.gisReferenceType Where idfsGISReferenceType = 19000001 AND intRowStatus = 0
					)
				End
			)
			As  [DeterminantTypeNationalName]
		
		From dbo.[ffFormTemplate] FT
		Inner Join dbo.[ffDeterminantValue] DV On FT.idfsFormTemplate = DV.idfsFormTemplate And DV.[intRowStatus]=0 
		Where
			((FT.idfsFormTemplate = @idfsFormTemplate ) OR (@idfsFormTemplate IS null))				
			 And FT.[intRowStatus] = 0
		Order by [DeterminantNationalName]
End

