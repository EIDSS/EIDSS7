
/************************************************************
* spsysGetListNewID.proc
************************************************************/

--##SUMMARY This procedure returns list new ID from main (system) ID set for current site.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 05.04.2012

--##RETURNS Don't use


/*
--Example of a call of procedure:
exec dbo.[spsysGetListNewID] 3
*/

CREATE PROCEDURE [dbo].[spsysGetListNewID](
	@Cnt INT -- count new id
	)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @RowGuid NVARCHAR(36) = NEWID()
	
	INSERT INTO dbo.tstNewID (strRowGuid) 
	SELECT TOP (@Cnt) 
		@RowGuid 
	FROM
	(SELECT a*1000+b*100+c*10+d num FROM
	(SELECT 0 a UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
	UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION select 9) a
	CROSS JOIN 
	(SELECT 0 b UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION select 4
	UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION select 9) b
	CROSS JOIN 
	(SELECT 0 c UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION select 4
	UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
	cross join 
	(SELECT  0 d UNION SELECT 1 UNION  SELECT 2 UNION SELECT 3 UNION SELECT 4
	UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
	) a ORDER BY 1
	
	SELECT * FROM tstNewID WHERE strRowGuid = @RowGuid ORDER BY [NewID]
  
	SET NOCOUNT OFF 
END
