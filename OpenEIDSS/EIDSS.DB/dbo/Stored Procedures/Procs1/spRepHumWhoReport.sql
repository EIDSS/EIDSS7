
   
   --##SUMMARY Select data for Monthly Morbidity and Mortality report
   
   --##REMARKS Author: Romasheva S.
   --##REMARKS Create date: 29.10.2013
    
   --##RETURNS Doesn't use
   
   /*
   --Example of a call of procedure:
   

   --GG
   --Measles
   exec dbo.[spRepHumWhoReport] @LangID=N'en',@StartDate='20130101',@EndDate='20131101', @idfsDiagnosis = 9843460000000
   
   --Rubella   
   exec dbo.[spRepHumWhoReport] @LangID=N'en',@StartDate='20130101',@EndDate='20131101', @idfsDiagnosis = 9843820000000
   
   --AZ
   --Measles
   exec dbo.[spRepHumWhoReport] @LangID=N'en',@StartDate='20120101',@EndDate='20131101', @idfsDiagnosis = 7720040000000
   --rubella
   exec dbo.[spRepHumWhoReport] @LangID=N'en',@StartDate='20130101',@EndDate='20131201', @idfsDiagnosis = 7720770000000
   
   
   */
   
   create  Procedure [dbo].[spRepHumWhoReport]
   	 (
   			@LangID		as nvarchar(50), 
   			@StartDate datetime,
   			@EndDate datetime,
   			@idfsDiagnosis bigint
   	 )
   AS	
   
   	
   begin
   	
    	
   	declare @idfsCountry					bigint
   		
  	
 	SELECT		@idfsCountry = tcpac.idfsCountry
	FROM tstCustomizationPackage tcpac
	JOIN tstSite s ON
		s.idfCustomizationPackage = tcpac.idfCustomizationPackage
	JOIN tstLocalSiteOptions lso ON
		lso.strName = N'SiteID'
		AND lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))

	if @idfsCountry = 780000000
		exec dbo.[spRepHumWhoReport_GG] @LangID, @StartDate, @EndDate, @idfsDiagnosis
	else   				
 	if @idfsCountry = 170000000
 		exec dbo.[spRepHumWhoReport_AZ] @LangID, @StartDate, @EndDate, @idfsDiagnosis
 				  	
   
   	
end


