
--##SUMMARY Returns idfCase by strFieldBarcode if material exists.
--##REMARKS Author: Grigoreva E.
--##REMARKS Create date: 08.01.2012

CREATE PROCEDURE [dbo].[spLabSample_BarcodeExistsInMaterial]( 
	@value AS nvarchar(30)
)
AS

begin

select top 1 ISNULL(idfHumanCase, idfVetCase) AS idfCase from tlbMaterial where strFieldBarcode = @value and intRowStatus = 0

end



