


--##SUMMARY Select data for Armenian Form 85 custom report

--##REMARKS Author: Romasheva R.
--##REMARKS Create date: 25.01.2016


--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec dbo.[spRepHumFormN85Third] @LangID=N'ru',@Year=2012

*/ 

create  Procedure [dbo].[spRepHumFormN85Third]
 (
		 @LangID		as nvarchar(50), 
		 @Year			as int,
		 @Month			as int = null,
		 @RegionID		as bigint = null,
		 @RayonID		as bigint = null
	 )
AS	 
begin
	exec dbo.[spRepHumFormN85FirstAndThird] @LangID,@Year, @Month, @RegionID, @RayonID, @idfsCustomReportType = 10290047
end
