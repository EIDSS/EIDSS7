--*************************************************************
-- Name 				: USP_HUM_DISEASE_ANTIVIRALTHERAPIES_GetList
-- Description			: List Human Disease Report Antiviral Therapies by HDID
--          
-- Author               : HAP
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- 
--
-- Testing code:
-- EXEC USP_HUM_DISEASE_ANTIVIRALTHERAPIES_GetList @LangID = 'en', @idfHumanCase  = 19 
--*************************************************************
CREATE  PROCEDURE [dbo].[USP_HUM_DISEASE_ANTIVIRALTHERAPIES_GetList] 
@idfHumanCase 	bigint,		
@LangID			nvarchar(50)
AS
Begin
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;

BEGIN TRY  
		select  
		   amt.idfAntimicrobialTherapy,
		   amt.idfHumanCase,		
		   amt.datFirstAdministeredDate,
		   amt.strAntimicrobialTherapyName,
		   amt.strDosage	
        
		from tlbAntimicrobialTherapy amt
		inner join tlbHumanCase  hc
			on   hc.idfHumanCase = amt.idfHumanCase  		
		where  
			amt.idfHumanCase = @idfHumanCase  
			and strAntimicrobialTherapyName is not null
			and strAntimicrobialTherapyName <> ''
			and amt.intRowStatus = 0 

		SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';
	END TRY  

	BEGIN CATCH 
		THROW;

	END CATCH
END
