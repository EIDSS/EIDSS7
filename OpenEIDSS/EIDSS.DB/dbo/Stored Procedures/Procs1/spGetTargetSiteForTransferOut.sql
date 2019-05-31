
CREATE PROCEDURE [dbo].[spGetTargetSiteForTransferOut]
	@idfTransferOut bigint
AS
select	s.idfsSite 
from	tlbTransferOUT t
inner join tstSite s 
on		s.idfOffice=t.idfSendToOffice 
where
		s.intRowStatus=0 
		and t.idfTransferOut=@idfTransferOut

RETURN 0

