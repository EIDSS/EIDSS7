

--##SUMMARY Selects monitoring session details for report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 20.07.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
exec spRepVSSession  88200000241, 'ru'
*/

CREATE  Procedure [dbo].[spRepVSSession]
	(
		@idfSession bigint,
		@LangID nvarchar(20)
	)
AS	


select  top 1 * from tlbVectorSurveillanceSession
	

