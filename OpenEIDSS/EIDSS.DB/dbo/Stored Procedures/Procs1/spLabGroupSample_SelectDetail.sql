
--##REMARKS CREATED BY: Grigoreva E.
--##REMARKS Date: 11.12.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

/*
exec spLabGroupSample_SelectDetail '111' ,'en'
*/

CREATE PROCEDURE [dbo].[spLabGroupSample_SelectDetail]
 @Barcode varchar(50), 
 @LangID varchar(20)
AS

select 
   m.idfMaterial,
   m.strFieldBarcode,
	case	
		when	tlbHumanCase.idfHumanCase IS NOT NULL	-- Human
			then	2
		when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012003	-- Livestock
			then	32
		when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012004	-- Avian
			then	64
		when	ms.idfMonitoringSession is not null	-- Livestock	/*Active Surveillance*/
			then	32
		when	vss.idfVectorSurveillanceSession is not null	-- Vector
			then	128
	end	as HACode,
   m.idfsSampleType,
   st.[name] as strSampleName,
   COALESCE (tlbHumanCase.strCaseID, tlbVetCase.strCaseID, ms.strMonitoringSessionID, vss.strSessionID) as strCase,
   m.strBarcode,
   m.datFieldCollectionDate,
   CAST(NULL  AS  datetime) as datAccession,--N'' as datAccession,--getdate() as datAccession,
   CAST(NULL AS bigint) as idfsAccessionCondition,--10108001 as idfsAccessionCondition,
   CAST(NULL AS NVARCHAR(255)) as strCondition,
   m.idfSubdivision,
   dep.[name] as idfInDepartment,
   ms.idfMonitoringSession,
	CASE 
		WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
		ELSE tlbVetCase.idfsCaseType
	END AS idfsCaseType,
   ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
   vss.idfVectorSurveillanceSession,
   CAST(NULL AS bigint) as idfAccesionByPerson

from  tlbMaterial m

inner join fnReferenceRepair(@LangID,19000087) st -- Sample Type
on   st.idfsReference = m.idfsSampleType

left join tlbHumanCase
on   tlbHumanCase.idfHumanCase = m.idfHumanCase
   and tlbHumanCase.intRowStatus = 0
  left join tlbVetCase
on   tlbVetCase.idfVetCase = m.idfVetCase
   and tlbVetCase.intRowStatus = 0
   
left join tlbMonitoringSession ms
on   ms.idfMonitoringSession = m.idfMonitoringSession
   and ms.intRowStatus = 0
left join tlbVectorSurveillanceSession vss
on   vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
   and vss.intRowStatus = 0

left join fnReferenceRepair(@LangID, 19000019) d -- Diagnosis
on   d.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis)

left join fnDepartment(@LangID) dep
on   dep.idfDepartment=m.idfInDepartment

left join	tlbTransferOutMaterial tOut_M
on			tOut_M.idfMaterial = m.idfMaterial
   
where  IsNull(m.strFieldBarcode, N'') = @Barcode
	and m.blnShowInAccessionInForm = 1
	and m.blnAccessioned = 0
	and tOut_M.idfMaterial is null -- doesn't include transferred materials






