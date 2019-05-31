
CREATE PROCEDURE [dbo].[spGetTargetSiteForRemoteTestResult]
	@idfTesting bigint
AS
	select s.idfsSite
	from tlbTransferOUT t
	inner join tstSite s on s.idfOffice = t.idfSendFromOffice
	inner join tlbTransferOutMaterial tm on tm.idfTransferOut = t.idfTransferOut
	inner join tlbMaterial m on m.idfParentMaterial = tm.idfMaterial
	inner join tlbTesting tst on tst.idfMaterial = m.idfMaterial
	where tst.idfTesting = @idfTesting
RETURN 0

