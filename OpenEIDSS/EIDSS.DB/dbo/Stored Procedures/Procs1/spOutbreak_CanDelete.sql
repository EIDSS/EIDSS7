
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE            PROCEDURE dbo.spOutbreak_CanDelete( 
	@ID AS bigint,
	@Result AS BIT OUTPUT
)
as

if exists	(
	select		idfHumanCase
	from		tlbHumanCase
	inner join	tlbOutbreak
	on			tlbOutbreak.idfOutbreak = tlbHumanCase.idfOutbreak
				and tlbHumanCase.intRowStatus = 0
	where		tlbOutbreak.idfOutbreak = @ID
	
	UNION ALL
	
	select		idfVetCase
	from		tlbVetCase
	inner join	tlbOutbreak
	on			tlbOutbreak.idfOutbreak = tlbVetCase.idfOutbreak
				and tlbVetCase.intRowStatus = 0
	where		tlbOutbreak.idfOutbreak = @ID
)
	SET @Result=0
ELSE
	SET @Result=1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spOutbreak_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

Return @Result





