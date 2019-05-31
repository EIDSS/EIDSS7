



--##SUMMARY Checks if event of specific Type exists for specific object.
--##SUMMARY Only event types that require request to database are processed here.
--##SUMMARY All other event types are checked in client application to reduce database load.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS 1 if event exists, 
--##RETURNS 0 in other case

/*
--Example of a call of procedure:
DECLARE @RC INT
DECLARE @idfsEventTypeID BIGINT
DECLARE @idfObject BIGINT

EXEC @RC = spEventLog_EventForObjectExists @idfsEventTypeID, @idfObject

Print ISNULL(@RC,0)
*/




CREATE          procedure dbo.spEventLog_EventForObjectExists( 
	@idfsEventTypeID as bigint,--##PARAM @idfEventID - event record ID
	@idfObject as bigint --##PARAM @intProcessed - returns flag that defined was record processed or not
	
)
as
	DECLARE @ObjectName NVARCHAR(50)
	DECLARE @Result int
	SET @Result = 0
	SELECT @ObjectName = dbo.fnEventLog_GetObjectType(@idfsEventTypeID)
	IF @ObjectName = N'HumanCase'
	BEGIN
		SELECT @Result = 1 from tlbHumanCase Where idfHumanCase = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'VetCase'
	BEGIN
		SELECT @Result = 1  from tlbVetCase Where idfVetCase = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'Settlement'
	BEGIN
		SELECT @Result = 1  from gisSettlement Where idfsSettlement = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'Outbreak'
	BEGIN
		SELECT @Result = 1  from tlbOutbreak Where idfOutbreak = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'VsSession'
	BEGIN
		SELECT @Result = 1  from tlbVectorSurveillanceSession Where idfVectorSurveillanceSession = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'AsCampaign'
	BEGIN
		SELECT @Result = 1  from tlbCampaign Where idfCampaign = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'AsSession'
	BEGIN
		SELECT @Result = 1  from tlbMonitoringSession Where idfMonitoringSession = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'HumanAggrCase' OR  @ObjectName = N'VetAggrCase' OR  @ObjectName = N'VetAggrAction'
	BEGIN
		SELECT @Result = 1  from tlbAggrCase Where idfAggrCase = @idfObject and intRowStatus = 0
	END
	ELSE IF @ObjectName = N'AvrLayout'
	BEGIN
		SELECT @Result = 1  from tasLayout Where idflLayout = @idfObject
	END
	ELSE IF @ObjectName = N'AvrFolder'
	BEGIN
		SELECT @Result = 1  from tasLayoutFolder Where idflLayoutFolder = @idfObject
	END
	ELSE IF @ObjectName = N'AvrQuery'
	BEGIN
		SELECT @Result = 1  from tasQuery Where idflQuery = @idfObject
	END
	ELSE IF @ObjectName = N'AggregateSettings' OR @ObjectName = N'FFDesigner' OR  @ObjectName = N'SecurityPolicy' OR  @ObjectName =N'Reference' OR  @ObjectName =N'Matrix'
	BEGIN
		SELECT @Result = 1  
	END
	ELSE IF @ObjectName = N'SampleTransfer'
	BEGIN
		SELECT @Result = 1  from tlbTransferOUT Where idfTransferOut = @idfObject
	END
	ELSE IF @ObjectName = N'Test'
	BEGIN
		SELECT @Result = 1  from tlbTesting Where idfTesting = @idfObject
	END
	ELSE IF @ObjectName = N'BssForm'
	BEGIN
		SELECT @Result = 1  from tlbBasicSyndromicSurveillance Where idfBasicSyndromicSurveillance = @idfObject
	END
	ELSE IF @ObjectName = N'BssAggrForm'
	BEGIN
		SELECT @Result = 1  from tlbBasicSyndromicSurveillanceAggregateHeader Where idfAggregateHeader = @idfObject
	END
	ELSE IF @ObjectName=N''
		SELECT @Result = 1
	ELSE
		SELECT @Result = 0

RETURN @Result



