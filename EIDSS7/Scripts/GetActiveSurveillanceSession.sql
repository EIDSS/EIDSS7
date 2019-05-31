SELECT 
    idfMonitoringSession
    ,MS.strMonitoringSessionID
    ,BR.strDefault As SessionStatus
    ,GISC.strDefault Country
    ,GISR.strDefault Region
    ,GISRa.strDefault  Ryan
    ,GISS.strDefault Settlement
    ,PER.strFirstName + ' ' + PER.strFamilyName As SessionEnteredBy
    ,MS.idfCampaign
    ,S.strSiteName
    ,MS.datEnteredDate
FROM 
	tlbMonitoringSession  MS
	LEFT JOIN gisBaseReference GISC ON MS.idfsCountry = GISC.idfsGISBaseReference
	LEFT JOIN gisBaseReference GISR ON MS.idfsRegion = GISR.idfsGISBaseReference
	LEFT JOIN gisBaseReference GISRa ON MS.idfsRayon = GISRa.idfsGISBaseReference
	LEFT JOIN gisBaseReference GISS ON MS.idfsSettlement = GISS.idfsGISBaseReference
	LEFT JOIN tlbPerson PER ON MS.idfPersonEnteredBy = PER.idfPerson
	LEFT JOIN trtbaseReference BR ON MS.idfsMonitoringSessionStatus = BR.idfsBaseReference
	LEFT JOIN tstSite S ON MS.idfsSite = S.idfsSite
WHERE 
strMonitoringSessionID = @MonitoringSessionID
