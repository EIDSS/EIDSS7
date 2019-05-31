
create PROCEDURE [dbo].[spBasicSyndromicSurveillance_Post](
	@Action Int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfBasicSyndromicSurveillance BIGINT,
	@strFormID NVARCHAR(200) = NULL output,
	@datDateEntered DATETIME,	
	@idfEnteredBy BIGINT,
	@idfsSite BIGINT,
	@idfsBasicSyndromicSurveillanceType BIGINT = NULL,
	@idfHospital Bigint = NULL,
	@datReportDate DATETIME = NULL,
	@intAgeYear Int = NULL,
	@intAgeMonth INT = NULL,	
	@strPersonalID NVARCHAR(100) = NULL,
	@idfsYNPregnant BIGINT  = NULL,
	@idfsYNPostpartumPeriod BIGINT  = NULL,
	@datDateOfSymptomsOnset DATETIME  = NULL,
	@idfsYNFever BIGINT  = NULL,
	@idfsMethodOfMeasurement BIGINT  = NULL,
	@strMethod NVARCHAR(500)  = NULL,
	@idfsYNCough BIGINT =  NULL,
	@idfsYNShortnessOfBreath BIGINT =  NULL,
	@idfsYNSeasonalFluVaccine BIGINT =  NULL,
	@datDateOfCare DATETIME =  NULL,
	@idfsYNPatientWasHospitalized BIGINT =  NULL,
	@idfsOutcome BIGINT =  NULL,
	@idfsYNPatientWasInER BIGINT =  NULL,
	@idfsYNTreatment BIGINT =  NULL,
	@idfsYNAdministratedAntiviralMedication BIGINT =  NULL,
	@strNameOfMedication NVARCHAR(200) =  NULL,
	@datDateReceivedAntiviralMedication DATETIME =  NULL,
	@blnRespiratorySystem bit =  NULL,
	@blnAsthma BIT =  NULL,
	@blnDiabetes BIT =  NULL,
	@blnCardiovascular BIT =  NULL,
	@blnObesity BIT =  NULL,
	@blnRenal BIT =  NULL,
	@blnLiver BIT =  NULL,
	@blnNeurological BIT =  NULL,
	@blnImmunodeficiency BIT =  NULL,
	@blnUnknownEtiology BIT =  NULL,
	@datSampleCollectionDate date =  NULL,
	@strSampleID NVARCHAR(200) = NULL,
	@idfsTestResult BIGINT = NULL,
	@datTestResultDate DATETIME = NULL,
	@datModificationForArchiveDate DATETIME = Null,
	@idfHuman bigint
)
As
Begin
	Declare @datDateLastSaved Datetime
	If (@datDateLastSaved Is Null) Set @datDateLastSaved = Getdate()
	
	IF @Action = 4
BEGIN
	IF ISNULL(@idfBasicSyndromicSurveillance,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfBasicSyndromicSurveillance OUTPUT
	END
	IF LEFT(ISNULL(@strFormID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057032, @strFormID OUTPUT , NULL
	END

	INSERT INTO [dbo].[tlbBasicSyndromicSurveillance]
			   (idfBasicSyndromicSurveillance			   
				,strFormID
				,datDateEntered
				,datDateLastSaved
				,idfEnteredBy
				,idfsSite
				,idfsBasicSyndromicSurveillanceType				
				,idfHospital
				,datReportDate
				,intAgeYear
				,intAgeMonth				
				,strPersonalID
				,idfsYNPregnant
				,idfsYNPostpartumPeriod
				,datDateOfSymptomsOnset
				,idfsYNFever
				,idfsMethodOfMeasurement
				,strMethod
				,idfsYNCough
				,[idfsYNShortnessOfBreath]
				,[idfsYNSeasonalFluVaccine]
				,datDateOfCare
				,idfsYNPatientWasHospitalized
				,idfsOutcome
				,idfsYNPatientWasInER
				,idfsYNTreatment
				,idfsYNAdministratedAntiviralMedication
				,strNameOfMedication
				,datDateReceivedAntiviralMedication
				,blnRespiratorySystem
				,blnAsthma
				,blnDiabetes
				,blnCardiovascular
				,blnObesity
				,blnRenal
				,blnLiver
				,blnNeurological
				,blnImmunodeficiency
				,blnUnknownEtiology
				,datSampleCollectionDate
				,strSampleID
				,idfsTestResult				
				,datTestResultDate
				,datModificationForArchiveDate
				,idfHuman
			   )
		 VALUES
			   (
			    @idfBasicSyndromicSurveillance,
				@strFormID,
				@datDateEntered,
				@datDateLastSaved ,
				@idfEnteredBy,
				@idfsSite,
				@idfsBasicSyndromicSurveillanceType,
				@idfHospital,
				@datReportDate,
				@intAgeYear,
				@intAgeMonth,	
				@strPersonalID,
				@idfsYNPregnant,
				@idfsYNPostpartumPeriod,
				@datDateOfSymptomsOnset,
				@idfsYNFever,
				@idfsMethodOfMeasurement,
				@strMethod,
				@idfsYNCough,
				@idfsYNShortnessOfBreath,
				@idfsYNSeasonalFluVaccine,
				@datDateOfCare,
				@idfsYNPatientWasHospitalized,
				@idfsOutcome,
				@idfsYNPatientWasInER,
				@idfsYNTreatment,
				@idfsYNAdministratedAntiviralMedication,
				@strNameOfMedication,
				@datDateReceivedAntiviralMedication,
				@blnRespiratorySystem,
				@blnAsthma,
				@blnDiabetes,
				@blnCardiovascular,
				@blnObesity,
				@blnRenal,
				@blnLiver,
				@blnNeurological,
				@blnImmunodeficiency,
				@blnUnknownEtiology,
				@datSampleCollectionDate,
				@strSampleID,
				@idfsTestResult,
				@datTestResultDate,
				getdate(),
				@idfHuman
			   )
	
END
ELSE IF @Action=16
BEGIN
	UPDATE [dbo].[tlbBasicSyndromicSurveillance]
	   SET 
			    strFormID = @strFormID
				,datDateEntered = @datDateEntered
				,datDateLastSaved = @datDateLastSaved
				,idfEnteredBy = @idfEnteredBy
				,idfsSite = @idfsSite
				,idfsBasicSyndromicSurveillanceType = @idfsBasicSyndromicSurveillanceType				
				,idfHospital = @idfHospital
				,datReportDate = @datReportDate
				,intAgeYear = @intAgeYear
				,intAgeMonth	 = @intAgeMonth			
				,strPersonalID = @strPersonalID
				,idfsYNPregnant = @idfsYNPregnant
				,idfsYNPostpartumPeriod = @idfsYNPostpartumPeriod
				,datDateOfSymptomsOnset = @datDateOfSymptomsOnset
				,idfsYNFever = @idfsYNFever
				,idfsMethodOfMeasurement = @idfsMethodOfMeasurement
				,strMethod = @strMethod
				,idfsYNCough = @idfsYNCough
				,idfsYNShortnessOfBreath = @idfsYNShortnessOfBreath
				,idfsYNSeasonalFluVaccine = @idfsYNSeasonalFluVaccine
				,datDateOfCare = @datDateOfCare
				,idfsYNPatientWasHospitalized = @idfsYNPatientWasHospitalized
				,idfsOutcome = @idfsOutcome
				,idfsYNPatientWasInER = @idfsYNPatientWasInER
				,idfsYNTreatment = @idfsYNTreatment
				,idfsYNAdministratedAntiviralMedication = @idfsYNAdministratedAntiviralMedication
				,strNameOfMedication = @strNameOfMedication
				,datDateReceivedAntiviralMedication = @datDateReceivedAntiviralMedication
				,blnRespiratorySystem = @blnRespiratorySystem
				,blnAsthma = @blnAsthma
				,blnDiabetes = @blnDiabetes
				,blnCardiovascular = @blnCardiovascular
				,blnObesity = @blnObesity
				,blnRenal = @blnRenal
				,blnLiver = @blnLiver
				,blnNeurological = @blnNeurological
				,blnImmunodeficiency = @blnImmunodeficiency
				,blnUnknownEtiology = @blnUnknownEtiology
				,datSampleCollectionDate = @datSampleCollectionDate
				,strSampleID = @strSampleID
				,idfsTestResult	 = @idfsTestResult		
				,datTestResultDate = @datTestResultDate
				,datModificationForArchiveDate	 = getdate()
				,idfHuman = @idfHuman
	 WHERE 
		idfBasicSyndromicSurveillance = @idfBasicSyndromicSurveillance
end Else If @Action = 8 Begin
	Exec dbo.spBasicSyndromicSurveillance_Delete @ID = @idfBasicSyndromicSurveillance

END
	
End
