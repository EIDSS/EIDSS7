

--##SUMMARY select queries for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsQuerySelectLookup 'ru'
*/ 
 
create PROCEDURE [dbo].[spAsQuerySelectLookup]
	@LangID	as nvarchar(50),
	@QueryID	as bigint = null
AS
BEGIN
	select		 q.idflQuery
				,q.idfsGlobalQuery
				,refQuery.strEnglishName	as DefQueryName
				,refQuery.strName			as QueryName
				,q.strFunctionName			as strFunctionName
				,refDescription.strName		as strDescription
				,refDescription.strEnglishName		as strEnglishDescription
				,q.blnReadOnly				as blnReadOnly
				,isnull(brQuery.intOrder,0)	as intOrder
				,qso_counter.blnSingleSearchObject	
				,case
					when	qsoOutbreak.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsOutbreak
				,case
					when	qsoHumanCase.idfQuerySearchObject is not null
							or qsoHCSample.idfQuerySearchObject is not null
							or qsoHCTest.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsHumanCase
				,case
					when	qsoVetCase.idfQuerySearchObject is not null
							or qsoVCSample.idfQuerySearchObject is not null
							or qsoVCTest.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsVetCase
				,case
					when	qsoASCampaign.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsASCampaign
				,case
					when	qsoASSession.idfQuerySearchObject is not null
							or qsoASSample.idfQuerySearchObject is not null
							or qsoASTest.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsASSession
				,case
					when	qsoHCSample.idfQuerySearchObject is not null
							or qsoVCSample.idfQuerySearchObject is not null
							or qsoASSample.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsSample
				,case
					when	qsoHCTest.idfQuerySearchObject is not null
							or qsoVCTest.idfQuerySearchObject is not null
							or qsoASTest.idfQuerySearchObject is not null
						then	1
					else	0
				 end							as blnIsTest
				,br_so_root.intHACode
				,qso_root.idfsSearchObject

		  from	dbo.tasQuery						as q
	inner join	dbo.fnLocalReference(@LangID)	as refQuery
			on	refQuery.idflBaseReference = q.idflQuery
	 left join	dbo.fnLocalReference(@LangID)	as refDescription
			on	q.idflDescription = refDescription.idflBaseReference

	left join	(
					select	idflQuery, 
							case COUNT(idfQuerySearchObject) 
								when 1 then 1
								else 0 
							end				 as blnSingleSearchObject
					from	tasQuerySearchObject qso_root
					inner join	trtBaseReference br_so_root
					on	br_so_root.idfsBaseReference = qso_root.idfsSearchObject
					group by idflQuery
				) as qso_counter
				on	qso_counter.idflQuery = q.idflQuery

	 left join	tasQuerySearchObject qso_root
		inner join	trtBaseReference br_so_root
		on			br_so_root.idfsBaseReference = qso_root.idfsSearchObject
			on	qso_root.idflQuery = q.idflQuery
				and qso_root.idfParentQuerySearchObject is null


	 left join	dbo.tasQuerySearchObject			as qsoOutbreak
		inner join	fnReference('en', 19000082)		as ref_sob_Outbreak		-- rftSearchObject
				on	ref_sob_Outbreak.idfsReference = qsoOutbreak.idfsSearchObject
					and ref_sob_Outbreak.[name] = N'Outbreak'
			on  q.idflQuery = qsoOutbreak.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoHumanCase
		inner join	fnReference('en', 19000082)		as ref_sob_HumanCase	-- rftSearchObject
				on	ref_sob_HumanCase.idfsReference = qsoHumanCase.idfsSearchObject
					and ref_sob_HumanCase.[name] = N'Human Case'
			on  q.idflQuery = qsoHumanCase.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoVetCase
		inner join	fnReference('en', 19000082)		as ref_sob_VetCase	-- rftSearchObject
				on	ref_sob_VetCase.idfsReference = qsoVetCase.idfsSearchObject
					and ref_sob_VetCase.[name] = N'Vet Case'
			on  q.idflQuery = qsoVetCase.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoASCampaign
		inner join	fnReference('en', 19000082)		as ref_sob_ASCampaign	-- rftSearchObject
				on	ref_sob_ASCampaign.idfsReference = qsoASCampaign.idfsSearchObject
					and ref_sob_ASCampaign.[name] = N'Active Surveillance Campaign'
			on  q.idflQuery = qsoASCampaign.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoASSession
		inner join	fnReference('en', 19000082)		as ref_sob_ASSession	-- rftSearchObject
				on	ref_sob_ASSession.idfsReference = qsoASSession.idfsSearchObject
					and ref_sob_ASSession.[name] = N'Active Surveillance Session'
			on  q.idflQuery = qsoASSession.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoHCSample
		inner join	fnReference('en', 19000082)		as ref_sob_HCSample		-- rftSearchObject
				on	ref_sob_HCSample.idfsReference = qsoHCSample.idfsSearchObject
					and ref_sob_HCSample.[name] = N'Human Case Sample'
			on  q.idflQuery = qsoHCSample.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoHCTest
		inner join	fnReference('en', 19000082)		as ref_sob_HCTest		-- rftSearchObject
				on	ref_sob_HCTest.idfsReference = qsoHCTest.idfsSearchObject
					and ref_sob_HCTest.[name] = N'Human Case Test'
			on  q.idflQuery = qsoHCTest.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoVCSample
		inner join	fnReference('en', 19000082)		as ref_sob_VCSample		-- rftSearchObject
				on	ref_sob_VCSample.idfsReference = qsoVCSample.idfsSearchObject
					and ref_sob_VCSample.[name] = N'Vet Case Sample'
			on  q.idflQuery = qsoVCSample.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoVCTest
		inner join	fnReference('en', 19000082)		as ref_sob_VCTest		-- rftSearchObject
				on	ref_sob_VCTest.idfsReference = qsoVCTest.idfsSearchObject
					and ref_sob_VCTest.[name] = N'Vet Case Test'
			on  q.idflQuery = qsoVCTest.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoASSample
		inner join	fnReference('en', 19000082)		as ref_sob_ASSample		-- rftSearchObject
				on	ref_sob_ASSample.idfsReference = qsoASSample.idfsSearchObject
					and ref_sob_ASSample.[name] = N'Active Surveillance Sample'
			on  q.idflQuery = qsoASSample.idflQuery
	 left join	dbo.tasQuerySearchObject			as qsoASTest
		inner join	fnReference('en', 19000082)		as ref_sob_ASTest		-- rftSearchObject
				on	ref_sob_ASTest.idfsReference = qsoASTest.idfsSearchObject
					and ref_sob_ASTest.[name] = N'Active Surveillance Test'
			on  q.idflQuery = qsoASTest.idflQuery
	 left join trtBaseReference brQuery
		on	brQuery.idfsBaseReference = q.idfsGlobalQuery

	where		(@QueryID is null or @QueryID = q.idflQuery)
				and IsNull(q.blnSubQuery, 0) = 0
	order by	intOrder, refQuery.strName

END

