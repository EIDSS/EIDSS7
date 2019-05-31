-- =============================================
-- Author:		Steven Verner
-- Create date: 04.19.2019
-- Description:	Retrieves the ASPNet Users information along with all pertinent employee information
-- =============================================
ALTER PROCEDURE [dbo].[USP_ASPNetUser_GetDetail]
	@Id nvarchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
	 u.Id 
	,ut.idfsSite
	,u.idfUserID 
	,u.Email 
	,u.LockoutEndDateUtc
	,u.LockoutEnabled
	,u.AccessFailedCount
	,u.UserName 
	,ut.idfPerson
	,p.strFirstName 
	,p.strSecondName
	,p.strFamilyName
	,o.idfOffice
	,o.idfOffice Institution
	,isnull( oa.Name, oa.strDefault ) OfficeAbbreviation

	--,s.idfsSite
	FROM AspNetUsers u
	JOIN tstUserTable ut ON ut.idfUserID = u.idfUserID
	JOIN tlbPerson p ON p.idfPerson = ut.idfPerson
	JOIN tlbOffice o ON o.idfOffice = p.idfInstitution
	LEFT JOIN tstSite s ON s.idfOffice = p.idfInstitution AND S.intRowStatus = 0
	JOIN dbo.fnReference( 'en', 19000045 ) oa ON oa.idfsReference = o.idfsOfficeAbbreviation


	WHERE u.id = @Id 
END

GO

