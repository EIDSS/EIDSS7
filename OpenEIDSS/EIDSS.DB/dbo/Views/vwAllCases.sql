
CREATE VIEW [dbo].[vwAllCases]
	(
	idfCase
	)
	AS 
	
	SELECT idfHumanCase FROM tlbHumanCase
	union
	select idfVetCase from tlbVetCase

