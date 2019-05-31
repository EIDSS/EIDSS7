
--##SUMMARY Selects data for AS session summary samples
--##SUMMARY It is assumed that if you pass posistive @idfMonitoringSessionSummary as input parameter,
--##SUMMARY procedure will return samples matrix even if summary record doesn't exist yet.
--##SUMMARY This can be used for creation new samples matrix for not saved summary records.
--##SUMMARY To retreive table structure without any data pass NULL as idfMonitoringSessionSummary.
 
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSessionSummarySamples_SelectDetail 1, 'en'
*/

CREATE PROCEDURE [dbo].[spASSessionSummarySamples_SelectDetail]
	@idfMonitoringSessionSummary bigint
	,@LangID nvarchar(50)
AS


	
--2 monitoring session summary samples
-- each summary record contains checked list of all livestock sample types
SELECT	(CAST(st.idfsReference AS  VARCHAR) + '.' + CAST(@idfMonitoringSessionSummary AS  VARCHAR))  AS id
		,st.idfsReference as idfsSampleType
		,st.[name]
		,@idfMonitoringSessionSummary AS idfMonitoringSessionSummary
		,CAST(ISNULL(ss.blnChecked, 0) AS BIT)	AS  blnChecked
FROM fnReferenceRepair(@LangID, 19000087) st 
LEFT JOIN  (
	tlbMonitoringSessionSummarySample ss	
	INNER  JOIN tlbMonitoringSessionSummary s ON 
	ss.idfMonitoringSessionSummary = s.idfMonitoringSessionSummary
	)ON 
	ss.idfsSampleType = st.idfsReference
	AND (s.idfMonitoringSessionSummary = @idfMonitoringSessionSummary)
WHERE		
	(st.intHACode IS NULL OR st.intHACode = 0 OR (st.intHACode & 32)<>0)
	AND (st.intRowStatus = 0 OR st.idfsReference = ss.idfsSampleType)
	AND @idfMonitoringSessionSummary>0
	AND st.idfsReference<>10320001 --Unknown sample
ORDER BY st.intOrder, st.name

 

RETURN 0
