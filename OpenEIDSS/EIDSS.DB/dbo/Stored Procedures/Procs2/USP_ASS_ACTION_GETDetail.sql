
--*************************************************************
-- Name 				: USP_ASS_ACTION_GETDetail
-- Description			: Selects monitoring session action records related with specific session.
--						: This SP does not return the error is dataset. The error is raised to be caught in caller (SP) error handler
-- Author               : Maheshwar Deo
-- Revision History
--		Name		Date		Change Detail
--
-- Michael Jessee	05/16/2018	added two fields to proc output: strActionRequired and MonitoringSessionType 
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ASS_ACTION_GETDetail]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
	)  
AS  

BEGIN

	BEGIN TRY  	

		SELECT 
			idfMonitoringSessionAction
			,idfMonitoringSession
			,idfPersonEnteredBy
			,idfsMonitoringSessionActionType
			,idfsMonitoringSessionActionStatus
			,datActionDate
			,strComments
			,dbo.FN_GBL_ConcatFullName(tlbPerson.strFamilyName, tlbPerson.strFirstName, tlbPerson.strSecondName) AS strPersonEnteredBy 
			,ActionType.strDefault as strMonitoringSessionActionType
			,ActionStatus.strDefault as strMonitoringSessionActionStatus     
		  FROM 
			tlbMonitoringSessionAction
		  INNER JOIN tlbPerson ON
			tlbMonitoringSessionAction.idfPersonEnteredBy = tlbPerson.idfPerson
		  LEFT JOIN	dbo.FN_GBL_ReferenceRepair('en',19000127) ActionType ON
					tlbMonitoringSessionAction.idfsMonitoringSessionActionType = ActionType.idfsReference
		  LEFT JOIN	dbo.FN_GBL_ReferenceRepair('en',19000128) ActionStatus ON
					tlbMonitoringSessionAction.idfsMonitoringSessionActionStatus = ActionStatus.idfsReference
		WHERE  
			idfMonitoringSession = @idfMonitoringSession  
			AND 
			tlbMonitoringSessionAction.intRowStatus = 0  

	END TRY  

	BEGIN CATCH 

		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT   
			@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()

		RAISERROR 
			(
			@ErrorMessage,	-- Message text.  
			@ErrorSeverity, -- Severity.  
			@ErrorState		-- State.  
			); 
	END CATCH
END
