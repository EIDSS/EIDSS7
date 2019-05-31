
--##SUMMARY Selects lookup table of diagnosis enabled for specific sample

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.12.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spLabTestEditable_GetSampleDiagnosis 1, 'en'
*/

CREATE PROCEDURE [dbo].[spLabTestEditable_GetSampleDiagnosis]
	@idfMaterial bigint, 
	@idfCase bigint = null, 
	@idfCaseType bigint = null, 
	--@idfsDiagnosis bigint = null,
	@LangID NVARCHAR(50)
AS
	DECLARE @idfMonitoringSession bigint
	DECLARE @idfVsSession bigint
	DECLARE @idfHumanCase bigint
	DECLARE @idfVetCase bigint
	
IF NOT @idfCase	IS NULL AND NOT @idfCaseType IS NULL
BEGIN
	IF @idfCaseType = 10012001 -- Human
		SELECT @idfHumanCase = @idfCase
	ELSE IF @idfCaseType = 10012003 -- Livestock
		SELECT @idfVetCase = @idfCase
	ELSE IF @idfCaseType = 10012004 -- Avian
		SELECT @idfVetCase = @idfCase
	ELSE IF @idfCaseType = 10012005 -- Veterinary
		SELECT @idfMonitoringSession = @idfCase
	ELSE IF @idfCaseType = 10012006 -- Vector
		SELECT @idfVsSession = @idfCase
END
ELSE	
BEGIN
	SELECT 
		@idfMonitoringSession = m.idfMonitoringSession,
		@idfVsSession = m.idfVectorSurveillanceSession,
		@idfHumanCase = hc.idfHumanCase,
		@idfVetCase = vc.idfVetCase
	FROM tlbMaterial m with(nolock)
	Left join tlbHumanCase hc with(nolock) on
		m.idfHumanCase = hc.idfHumanCase
		and hc.intRowStatus = 0
	left join tlbVetCase vc with(nolock) on 
		m.idfVetCase = vc.idfVetCase
		and vc.intRowStatus = 0
	WHERE
		m.idfMaterial = @idfMaterial
		and m.intRowStatus=0
END

IF NOT @idfMonitoringSession IS NULL
BEGIN
		DECLARE @idfsSpeciesType bigint
		SELECT @idfsSpeciesType = tlbSpecies.idfsSpeciesType
		FROM tlbMaterial with(nolock)
		INNER JOIN tlbAnimal with(nolock) ON
			tlbAnimal.idfAnimal = tlbMaterial.idfAnimal
		INNER JOIN tlbSpecies with(nolock) ON
			tlbSpecies.idfSpecies = tlbAnimal.idfSpecies
		WHERE tlbMaterial.idfMaterial = @idfMaterial
		SELECT	trtDiagnosis.idfsDiagnosis
				, fnReferenceRepair.name
				, trtDiagnosis.strIDC10
				, trtDiagnosis.strOIECode 
				, fnReferenceRepair.intHACode
				, fnReferenceRepair.intRowStatus
				,CAST(0 as BIT) as blnFinalDiagnosis
		FROM	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
		INNER JOIN trtDiagnosis with(nolock)
			ON trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
		WHERE 
			trtDiagnosis.idfsDiagnosis in (	SELECT DISTINCT
								idfsDiagnosis 
						FROM	tlbMonitoringSessionToDiagnosis 
						WHERE	idfMonitoringSession = @idfMonitoringSession
								AND (idfsSpeciesType IS NULL OR idfsSpeciesType = @idfsSpeciesType)
								AND intRowStatus=0)
		ORDER BY	fnReferenceRepair.intOrder, fnReferenceRepair.name 
END
ELSE IF NOT @idfVsSession IS NULL
		SELECT	trtDiagnosis.idfsDiagnosis
				, fnReferenceRepair.name
				, trtDiagnosis.strIDC10
				, trtDiagnosis.strOIECode 
				, fnReferenceRepair.intHACode
				, fnReferenceRepair.intRowStatus
				,CAST(0 as BIT) as blnFinalDiagnosis
		FROM	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
		INNER JOIN trtDiagnosis with(nolock)
			on trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
		WHERE 
			trtDiagnosis.idfsUsingType = 10020001 --Standard 
			AND intHACode & 128 > 0 --vectors only
		ORDER BY	fnReferenceRepair.intOrder, fnReferenceRepair.name 
ELSE IF NOT @idfHumanCase IS NULL
		SELECT	trtDiagnosis.idfsDiagnosis
				, fnReferenceRepair.name
				, trtDiagnosis.strIDC10
				, trtDiagnosis.strOIECode 
				, fnReferenceRepair.intHACode
				, fnReferenceRepair.intRowStatus
				,CAST(0 as BIT) as blnFinalDiagnosis
		FROM	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
		INNER JOIN trtDiagnosis with(nolock)
			on trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
		INNER JOIN tlbHumanCase with(nolock) ON
			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) = trtDiagnosis.idfsDiagnosis
		WHERE 
			tlbHumanCase.idfHumanCase = @idfHumanCase
		ORDER BY	fnReferenceRepair.intOrder, fnReferenceRepair.name 
ELSE IF NOT @idfVetCase IS NULL
		SELECT	trtDiagnosis.idfsDiagnosis
				, fnReferenceRepair.name
				, trtDiagnosis.strIDC10
				, trtDiagnosis.strOIECode 
				, fnReferenceRepair.intHACode
				, fnReferenceRepair.intRowStatus
				,CAST(CASE WHEN tlbVetCase.idfsFinalDiagnosis = trtDiagnosis.idfsDiagnosis THEN 1 ELSE 0 END as BIT)  as blnFinalDiagnosis
		FROM	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
		INNER JOIN trtDiagnosis with(nolock) ON
			trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
		INNER JOIN tlbVetCase with(nolock) ON
			(tlbVetCase.idfsFinalDiagnosis = trtDiagnosis.idfsDiagnosis)
			OR (tlbVetCase.idfsTentativeDiagnosis = trtDiagnosis.idfsDiagnosis)
			OR (tlbVetCase.idfsTentativeDiagnosis1 = trtDiagnosis.idfsDiagnosis)
			OR (tlbVetCase.idfsTentativeDiagnosis2 = trtDiagnosis.idfsDiagnosis)
			--OR (@idfsDiagnosis IS NOT NULL AND trtDiagnosis.idfsDiagnosis = @idfsDiagnosis)
		WHERE 
			tlbVetCase.idfVetCase = @idfVetCase
		ORDER BY	fnReferenceRepair.intOrder, fnReferenceRepair.name 
ELSE --if sample doesn't exist or doesn't related with any object, return empty list of diagnosis
	 --this situation can occur we create new test
		select	trtDiagnosis.idfsDiagnosis
				, fnReferenceRepair.name
				, trtDiagnosis.strIDC10
				, trtDiagnosis.strOIECode 
				, fnReferenceRepair.intHACode
				, fnReferenceRepair.intRowStatus
		from	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
		inner join trtDiagnosis with(nolock)
			on trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
		where		
					trtDiagnosis.idfsDiagnosis = -1
					--trtDiagnosis.idfsUsingType = 10020001 --Standard 
		--order by	fnReferenceRepair.intOrder, fnReferenceRepair.name  
	

RETURN 0
