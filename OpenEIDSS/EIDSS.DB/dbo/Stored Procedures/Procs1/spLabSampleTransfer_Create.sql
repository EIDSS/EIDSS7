

CREATE PROCEDURE [dbo].[spLabSampleTransfer_Create]
	@idfTransferOut bigint,
	@idfSendFromOffice bigint
AS
BEGIN

	insert	tlbTransferOUT(idfTransferOut,idfSendFromOffice,idfsTransferStatus)
	values	(@idfTransferOut,@idfSendFromOffice,10001003)
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--INSERT INTO Activity(idfActivity,idfsActivity_Type,idfsActivity_Status)
	--VALUES(@idfActivity,'actTransferOut','acsUndefined')

	--INSERT INTO Lab_Manage_Activity(idfActivity,idfsLab_Manage_Activity_Type)
	--VALUES(@idfActivity,'latDef')

	--INSERT INTO Office_for_Activity(idfActivity,idfOffice,idfsOffice_for_Activity_Type)
	--VALUES(@idfActivity,@idfOffice,'oatFromInstitution')

	--INSERT INTO Office_for_Activity(idfActivity,idfOffice,idfsOffice_for_Activity_Type)
	--VALUES(@idfActivity,@idfOffice,'oatFromInstitution')

END

