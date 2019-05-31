

CREATE   Proc spSettlement_Delete
	@idfsSettlement as BIGINT
As Begin
	if not @idfsSettlement is null
	begin
		Delete from dbo.gisWKBSettlement Where idfsGeoObject = @idfsSettlement
		Delete from  dbo.gisSettlement Where [idfsSettlement] = @idfsSettlement
		Delete from dbo.gisStringNameTranslation Where idfsGISBaseReference = @idfsSettlement
		Delete from dbo.gisBaseReference Where idfsGISBaseReference = @idfsSettlement
	end
End



