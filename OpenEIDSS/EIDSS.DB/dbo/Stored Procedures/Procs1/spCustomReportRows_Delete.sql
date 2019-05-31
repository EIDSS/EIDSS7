
CREATE PROCEDURE [dbo].[spCustomReportRows_Delete]
(
	@idfReportRows bigint	
)
AS Begin
	Delete from [dbo].[trtReportRows] Where idfReportRows = @idfReportRows			
End
