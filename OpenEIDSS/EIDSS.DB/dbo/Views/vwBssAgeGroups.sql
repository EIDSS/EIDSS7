

--##SUMMARY Selects the Age group for Basic Syndromic Surveillance Form for AVR

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 20.02.2014

--##RETURNS Doesn't use

create view vwBssAgeGroups
as
select   
	dag.idfsDiagnosisAgeGroup, 
	dag.intLowerBoundary, 
	dag.intUpperBoundary, 
    dag.idfsAgeType, 
    dag.intRowStatus, 
    br.strDefault, 
    br.strBaseReferenceCode,
    case when br.strBaseReferenceCode like '%WHOAgeGroup%' then 'WHOAgeGroup'
		 when br.strBaseReferenceCode like '%CDCAgeGroup%' then 'CDCAgeGroup'
		 else '' 
    end as strAgeGroup
from	trtDiagnosisAgeGroup dag
	inner join	trtBaseReference br
	on dag.idfsDiagnosisAgeGroup = br.idfsBaseReference
where 	
	br.strBaseReferenceCode like '%WHOAgeGroup%' or 
	br.strBaseReferenceCode like '%CDCAgeGroup%' 
