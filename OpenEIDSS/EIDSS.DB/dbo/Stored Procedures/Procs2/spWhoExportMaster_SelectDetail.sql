
CREATE PROCEDURE [dbo].[spWhoExportMaster_SelectDetail]
AS
	SELECT ISNULL(CAST(-1 as bigint),0) as idfsReferenceType

