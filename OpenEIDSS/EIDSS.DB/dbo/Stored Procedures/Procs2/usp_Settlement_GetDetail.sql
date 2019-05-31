
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/01/2017
-- Last modified by:		Joan Li
-- Description:				06/01/2017:Created based on V6 spSettlement_SelectDetail: rename for V7 USP42
--                                     Select data for SettlementDetail from gisSettlement,fnGisReference
-- Testing code:
/*
----testing code:
DECLARE @idfsSettlement bigint
DECLARE @LangID varchar(50)
select @idfsSettlement=55750000000
select @LangID='en'
EXECUTE usp_Settlement_GetDetail
   @idfsSettlement
  ,@LangID
  ----or call direct to test
EXECUTE usp_Settlement_GetDetail
   222060000000
  ,'en'
	
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_Settlement_GetDetail]
	(

	@idfsSettlementID AS VARCHAR(36), --##PARAM @idfsSettlement - settlement ID
	@LangID as NVARCHAR(50) --##PARAM @LangID - language ID
	)
AS
		SELECT  
			idfsSettlement As idfsSettlementID
			,strSettlementCode
			,enSettlement.[name] as strEnglishName
			,natSettlement.[name] AS strNationalName
			,idfsSettlementType
			,idfsCountry
			,idfsRegion
			,idfsRayon
			,dblLongitude As strLongitude
			,dblLatitude As strLatitude
			,intElevation As strElevation
		FROM 
			gisSettlement
			LEFT JOIN fnGisReference(@LangID,19000004) AS natSettlement ON
				natSettlement.idfsReference = idfsSettlement
			LEFT JOIN fnGisReference('en',19000004) AS enSettlement ON
				enSettlement.idfsReference = idfsSettlement
		WHERE
			idfsSettlement = @idfsSettlementID 

