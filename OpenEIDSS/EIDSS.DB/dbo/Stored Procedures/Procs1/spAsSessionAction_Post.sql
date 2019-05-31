

--##SUMMARY Posts monitoring session actions related with specific session.
--##SUMMARY Called by CaseLog panel.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 20.08.2010

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

*/








CREATE    PROC	spAsSessionAction_Post
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfMonitoringSessionAction bigint output --##PARAM @idfMonitoringSessionAction - action record ID
			,@idfsMonitoringSessionActionStatus bigint --##PARAM @idfsMonitoringSessionActionStatus - status of session action, reference to rftMonitoringSessionActionStatus (19000128)
			,@idfMonitoringSession bigint --##PARAM @idfMonitoringSession - sesson ID
			,@idfPersonEnteredBy bigint --##PARAM @idfPersonEnteredBy - ID of person that entered action record
			,@datActionDate datetime --##PARAM @datActionDate - date of session action
			,@idfsMonitoringSessionActionType bigint --##PARAM @idfsMonitoringSessionActionType - session action Type , reference to rftMonitoringSessionActionType (19000127)
			,@strComments nvarchar(500) --##PARAM @strComments - expanded description of session action

AS


-- Do nothing if all parameters are NULL. For test purpose
IF	(	@idfMonitoringSession IS NULL 
	AND	@Action IS NULL 
	AND @idfMonitoringSessionAction IS NULL 
	AND @idfsMonitoringSessionActionStatus IS NULL 
	AND @idfMonitoringSession IS NULL 
	AND @idfPersonEnteredBy IS NULL 
	AND @datActionDate IS NULL 
	AND @idfsMonitoringSessionActionType IS NULL 
	AND @strComments IS NULL
	) 
	RETURN 0
	

IF ISNULL(@idfMonitoringSessionAction,-1) < 0
BEGIN
	IF @Action = 8
		RETURN 0
	ELSE
	BEGIN
		EXEC spsysGetNewID	@idfMonitoringSessionAction OUTPUT
		SET @Action = 4
	END
END


	
IF @Action = 16 --update
BEGIN
UPDATE tlbMonitoringSessionAction
   SET idfMonitoringSessionAction = @idfMonitoringSessionAction
      ,idfMonitoringSession = @idfMonitoringSession
      ,idfPersonEnteredBy = @idfPersonEnteredBy
      ,idfsMonitoringSessionActionType = @idfsMonitoringSessionActionType
      ,idfsMonitoringSessionActionStatus = @idfsMonitoringSessionActionStatus
      ,datActionDate = @datActionDate
      ,strComments = @strComments
 WHERE 
		idfMonitoringSessionAction = @idfMonitoringSessionAction		
END
ELSE IF @Action = 8 --delete
BEGIN
	DELETE tlbMonitoringSessionAction WHERE idfMonitoringSessionAction = @idfMonitoringSessionAction
END
ELSE IF @Action = 4 --insert
BEGIN
	INSERT INTO tlbMonitoringSessionAction
           (
			idfMonitoringSessionAction
           ,idfMonitoringSession
           ,idfPersonEnteredBy
           ,idfsMonitoringSessionActionType
           ,idfsMonitoringSessionActionStatus
           ,datActionDate
           ,strComments
           )
     VALUES
           (
			@idfMonitoringSessionAction
           ,@idfMonitoringSession
           ,@idfPersonEnteredBy
           ,@idfsMonitoringSessionActionType
           ,@idfsMonitoringSessionActionStatus
           ,@datActionDate
           ,@strComments
           )
END


