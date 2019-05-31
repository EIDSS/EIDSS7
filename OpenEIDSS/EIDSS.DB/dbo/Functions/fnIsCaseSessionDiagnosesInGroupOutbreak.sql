

--##SUMMARY Checks connection between case/session diagnoses and Outbreak's diagnosis/diagnoses group

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 20.08.2013

--##REMARKS UPDATED BY: 
--##REMARKS Date: 

--##RETURNS -1 if idfsDiagnosisOrDiagnosisGroup of Outbreak with @idfOutbreak is DIAGNOSES GROUP AND one of case diagnoses is contained in this diagnoses group, 
--##RETURNS -2 if idfsDiagnosisOrDiagnosisGroup of Outbreak with @idfOutbreak is DIAGNOSIS AND one of case diagnoses is equal to this diagnosis, 
--##RETURNS ID of case diagnosis if idfsDiagnosisOrDiagnosisGroup of Outbreak with @idfOutbreak is DIAGNOSIS AND one of case diagnoses is contained in the same diagnoses group as input diagnosis, 
--##RETURNS 0 in other case

/*
--Example of function call:
DECLARE @Result bigint
DECLARE @idfCase bigint
DECLARE @idfOutbreak bigint
select @idfCase=SELECT TOP 1 idfHuman from tlbHuman
select @idfOutbreak=SELECT TOP 1 idfOutbreak from tlbOutbreak
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroupOutbreak(@idfCase, @idfOutbreak)
SELECT @idfCase, @Result
select @idfCase=SELECT TOP 1 idfVetCase from tlbVetCase
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroupOutbreak(@idfCase, @idfOutbreak)
SELECT @idfCase, @Result
select @idfCase=SELECT TOP 1 idfVectorSurveillanceSession from tlbVectorSurveillanceSession
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroupOutbreak(@idfCase, @idfOutbreak)
SELECT @idfCase, @Result
*/

CREATE function [dbo].[fnIsCaseSessionDiagnosesInGroupOutbreak]	(
						@idfCase bigint,
						@idfOutbreak bigint)
returns bigint
as
begin

declare @idfsDiagnosisOrDiagnosisGroup bigint
select @idfsDiagnosisOrDiagnosisGroup = idfsDiagnosisOrDiagnosisGroup
from tlbOutbreak
where idfOutbreak=@idfOutbreak

return dbo.fnIsCaseSessionDiagnosesInGroup(@idfCase, @idfsDiagnosisOrDiagnosisGroup)

end

