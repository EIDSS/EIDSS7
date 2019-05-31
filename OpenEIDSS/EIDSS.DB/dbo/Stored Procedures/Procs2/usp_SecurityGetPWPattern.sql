
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/11/2017
-- Last modified by:		Joan Li
-- Description:				4/11/2017: Created based on spSecurityPolicy_list with a new one : re-write
/*
----testing code:
exec usp_SecurityGetPWPattern
*/

--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_SecurityGetPWPattern]
	
AS
BEGIN

	
	declare		@scid bigint

	select		@scid=idfSecurityConfiguration
	from		fnPolicyValue()


	select		tstSecurityConfigurationAlphabet.*
				--Ref.name as [Description]
	from		tstSecurityConfigurationAlphabet
	inner join	tstSecurityConfigurationAlphabetParticipation
	on			tstSecurityConfigurationAlphabetParticipation.intRowStatus=0 and
				tstSecurityConfigurationAlphabet.intRowStatus=0 and
				tstSecurityConfigurationAlphabetParticipation.idfSecurityConfiguration=@scid

END


