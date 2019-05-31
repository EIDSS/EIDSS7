

--##SUMMARY This procedure is called when case is connected to the outbreak. If user asks to change the diagnosis of outbreak to the diagnoses group.

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 20.08.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:


EXECUTE spOutbreak_Diagnosis_Update
   750650000000
  ,NULL

*/

CREATE PROCEDURE [dbo].[spOutbreak_Diagnosis_Update]
	@idfOutbreak bigint,
	@idfsDiagnosisGroup bigint
AS
BEGIN
	SET NOCOUNT ON;

	if @idfsDiagnosisGroup is null return -1

	update	tlbOutbreak
	set
			idfsDiagnosisOrDiagnosisGroup=@idfsDiagnosisGroup
	where	idfOutbreak=@idfOutbreak
END


