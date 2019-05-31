







CREATE    PROCEDURE spRayon_Validate(
	@idfsRegion varchar(50),
	@idfsRayon varchar(50),
	@strDefaultName nvarchar(200),
	@strNationalName nvarchar(200),
	@LangID varchar(50),
	@Result int = 0 OUTPUT
	)
as
IF ISNULL(@idfsRegion,'')=''
BEGIN
	
	SELECT 	@idfsRegion=idfsRegion
	FROM 	gisRayon
	WHERE 
		@idfsRayon = @idfsRayon
	
	IF @@ROWCOUNT=0 OR ISNULL(@idfsRegion,'')=''
	BEGIN
		SET @Result = 0
		Return 0
	END
END

IF EXISTS (
	SELECT  
		idfsRayon 
	FROM 
		gisRayon
	INNER JOIN gisRegion 
	ON 	gisRayon.idfsRegion = gisRegion.idfsRegion
	LEFT JOIN 
		fnReference('en',19000002) as enRayon --'rftRayon'
	on	enRayon.idfsReference = idfsRayon
	WHERE
		enRayon.[name] = @strDefaultName
		AND idfsRayon <> @idfsRayon
		AND gisRegion.idfsRegion = @idfsRegion
	)

BEGIN
	SET @Result = 1
	Return 1
END	

IF @LangID <> N'en' AND EXISTS (
	SELECT  
		idfsRayon
	FROM 
		gisRayon
	INNER JOIN gisRegion 
	ON 	gisRayon.idfsRegion = gisRegion.idfsRegion
	LEFT JOIN 
		fnGisReference(@LangID,19000002) as natRayon --'rftRayon'
	on	natRayon.idfsReference = idfsRayon
	WHERE
		natRayon.[name] = @strNationalName
		AND idfsRayon <> @idfsRayon
		AND gisRegion.idfsRegion = @idfsRegion
	)
BEGIN
	SET @Result = 2
	Return 2
END 

SET @Result = 0
Return 0








