


--##SUMMARY Deletes human case with its contacts, antimicrobial therapies, observations, and geographical location.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 22.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@ID bigint
exec	spHumanCase_Delete @ID
*/

CREATE	procedure	[dbo].[spHumanCase_Delete]
		@ID bigint --##PARAM  @ID - Human case ID
as
exec	spHumanCase_DeleteInternal @ID, 1


