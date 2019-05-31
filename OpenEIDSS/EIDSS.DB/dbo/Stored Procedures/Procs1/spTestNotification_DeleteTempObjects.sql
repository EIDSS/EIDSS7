
--##SUMMARY This procedure is intened for use in notification service tests
--##SUMMARY It deletes dummy objects created by spTestNotification_GetObjectID

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 31.07.2014

--##RETURNS Doesn't use
/*
Example of procedure call:
--отключаем аудит-триггеры
ALTER      function [dbo].[fnTriggersWork] ()
returns bit
as
begin
return 0
END

GO
exec spTestNotification_DeleteTempObjects 
GO
--отключаем аудит-триггеры
ALTER      function [dbo].[fnTriggersWork] ()
returns bit
as
begin
return 0
END

GO

*/
CREATE PROCEDURE [dbo].[spTestNotification_DeleteTempObjects]
AS
delete from tlbHumanCase where strReservedAttribute = 'test'
delete from tlbBasicSyndromicSurveillance where strReservedAttribute = 'test'
delete from tlbHuman where strReservedAttribute = 'test'
delete from tlbVetCaseDisplayDiagnosis where idfVetCase in (select idfVetCase from tlbVetCase where strReservedAttribute = 'test')
delete from tlbVetCase where strReservedAttribute = 'test'
delete from tlbFarm where strReservedAttribute = 'test'
delete from tlbOutbreak where strReservedAttribute = 'test'
delete from tlbVectorSurveillanceSession where strReservedAttribute = 'test'
delete from tlbCampaign where strReservedAttribute = 'test'
delete from tlbMonitoringSession where strReservedAttribute = 'test'
delete from tlbAggrCase where strReservedAttribute = 'test'
delete from tlbTransferOUT where strReservedAttribute = 'test'
delete from tlbTesting where strReservedAttribute = 'test'
delete from tlbMaterial where strReservedAttribute = 'test'
delete from tlbObservation where strReservedAttribute = 'test'
delete from tlbBasicSyndromicSurveillanceAggregateHeader where strReservedAttribute = 'test'
delete from tasLayout where strReservedAttribute = 'test'
delete from tasLayout 
from tasLayout l inner join tasglLayout gl on gl.idfsLayout = l.idfsGlobalLayout where gl.strReservedAttribute = 'test'
delete from tasglLayout where strReservedAttribute = 'test'
delete from tasLayoutFolder where strReservedAttribute = 'test'
delete from tasLayoutFolder 
from tasLayoutFolder lf inner join tasglLayoutFolder glf on glf.idfsLayoutFolder = lf.idfsGlobalLayoutFolder where glf.strReservedAttribute = 'test'
delete from tasglLayoutFolder where strReservedAttribute = 'test'
delete from tasglQuery where strReservedAttribute = 'test'

RETURN 0

