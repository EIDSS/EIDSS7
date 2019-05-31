


--##SUMMARY Posts outbreak data for OutbreakDetail form.
--##SUMMARY Called by OutbreakDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.11.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @Action int
DECLARE @idfOutbreak bigint
DECLARE @idfsDiagnosisOrDiagnosisGroup bigint
DECLARE @idfsOutbreakStatus bigint
DECLARE @idfGeoLocation bigint
DECLARE @strOutbreakID nvarchar(200)
DECLARE @datStartDate datetime
DECLARE @datFinishDate datetime
DECLARE @strDescription nvarchar(2000)


EXECUTE spOutbreak_Post
   @Action
  ,@idfOutbreak
  ,@idfsDiagnosisOrDiagnosisGroup
  ,@idfsOutbreakStatus
  ,@idfGeoLocation
  ,@strOutbreakID OUTPUT
  ,@datStartDate
  ,@datFinishDate
  ,@strDescription

*/



CREATE    PROCEDURE dbo.spOutbreak_Post
	@Action int,  --##PARAM @Action - action to be perfomed: 4 - Added, 8 - Deleted, 16 - Modified
	@idfOutbreak bigint,  --##PARAM @idfOutbreak - outbreak ID
    @idfsDiagnosisOrDiagnosisGroup bigint, --##PARAM @idfsDiagnosisOrDiagnosisGroup - outbreak diagnosis (reference to rftDiagnosis = 19000019) or diagnosisgroup (reference to rftDiagnosis = 19000156)
    @idfsOutbreakStatus bigint, --##PARAM @idfsOutbreakStatus - outbreak status (reference to rftOutbreakStatus = 19000063)
    @idfGeoLocation bigint, --##PARAM outbreak location
    @strOutbreakID nvarchar (200) OUTPUT, --##PARAM @strOutbreakID - human readable outbreak Code
	@datStartDate datetime, --##PARAM @datStartDate - outbreak start date
	@datFinishDate datetime, --##PARAM @datFinishDate - outbreak finish date
	@strDescription nvarchar (2000), --##PARAM @strDescription - outbreak description
	@idfPrimaryCaseOrSession bigint, --##PARAM @idfPrimaryCaseOrSession - link to primary case
	@datModificationForArchiveDate datetime = null
as
	IF @idfsDiagnosisOrDiagnosisGroup < 0
		SET @idfsDiagnosisOrDiagnosisGroup=NULL

	IF @Action = 8
	BEGIN
		exec spOutbreak_Delete @idfOutbreak
	END
	IF @Action = 4 --Added
	BEGIN
		IF ISNULL(@strOutbreakID, N'') = N''
			EXEC dbo.spGetNextNumber 10057015, @strOutbreakID OUTPUT , NULL --N'nbtOutbreak'

		INSERT INTO tlbOutbreak
				   (idfOutbreak
				   ,idfsDiagnosisOrDiagnosisGroup
				   ,idfsOutbreakStatus
				   ,idfGeoLocation
				   ,strOutbreakID
				   ,datStartDate
				   ,datFinishDate
				   ,strDescription
				   ,idfPrimaryCaseOrSession
				   ,datModificationForArchiveDate)
			 VALUES
				   (@idfOutbreak
				   ,@idfsDiagnosisOrDiagnosisGroup
				   ,@idfsOutbreakStatus
				   ,@idfGeoLocation
				   ,@strOutbreakID
				   ,@datStartDate
				   ,@datFinishDate
				   ,@strDescription
				   ,@idfPrimaryCaseOrSession
				   ,getdate())
	END
	IF @Action = 16 --Modified
	BEGIN
		UPDATE tlbOutbreak
		   SET 
			   idfsDiagnosisOrDiagnosisGroup = @idfsDiagnosisOrDiagnosisGroup
			  ,idfsOutbreakStatus = @idfsOutbreakStatus
			  ,idfGeoLocation = @idfGeoLocation
			  ,strOutbreakID = @strOutbreakID
			  ,datStartDate = @datStartDate
			  ,datFinishDate = @datFinishDate
			  ,strDescription = @strDescription
			  ,idfPrimaryCaseOrSession = @idfPrimaryCaseOrSession
			  ,datModificationForArchiveDate = getdate()
		 WHERE 
				idfOutbreak = @idfOutbreak
	END
		




