
--##SUMMARY Recalculation of filtration all objects for replication:

--			ActiveSurveillanceSession
--			AggrCase
--			BasicSyndromicSurveillance
--			BasicSyndromicSurveillanceAggregateForm
--			HumanCase
--			VectorSurveillanceSession
--			VetCase

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 05.06.2014

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_AllObjects '20000101'
*/


create proc spFiltered_AllObjects (
	@StartDate datetime 
	)
as

	print '======================================================================================='
	print ' start Active Surveillance Session'
	if Object_ID('tempdb..#MonitoringSession') is not null			drop table #MonitoringSession	
	if Object_ID('tempdb..#MonitoringSessionFiltered') is not null	drop table #MonitoringSessionFiltered
	if Object_ID('tempdb..#TransferOutFiltered_MS') is not null		drop table #TransferOutFiltered_MS
	if Object_ID('tempdb..#Farm_MS') is not null					drop table #Farm_MS
	if Object_ID('tempdb..#Human_MS') is not null					drop table #Human_MS
	if Object_ID('tempdb..#GeoLocation_MS') is not null				drop table #GeoLocation_MS
	if Object_ID('tempdb..#BatchTest_MS') is not null				drop table #BatchTest_MS
	if Object_ID('tempdb..#Observation_MS') is not null				drop table #Observation_MS
	if Object_ID('tempdb..#Notification_MS') is not null			drop table #Notification_MS
	if Object_ID('tempdb..#DataAuditEvent_MS') is not null			drop table #DataAuditEvent_MS	
		
	
	exec spFiltered_ActiveSurveillanceSession @StartDate
	
	if Object_ID('tempdb..#MonitoringSession') is not null				drop table #MonitoringSession	
	if Object_ID('tempdb..#MonitoringSessionFiltered') is not null		drop table #MonitoringSessionFiltered
	if Object_ID('tempdb..#TransferOutFiltered_MS') is not null			drop table #TransferOutFiltered_MS
	if Object_ID('tempdb..#Farm_MS') is not null						drop table #Farm_MS
	if Object_ID('tempdb..#Human_MS') is not null						drop table #Human_MS
	if Object_ID('tempdb..#GeoLocation_MS') is not null					drop table #GeoLocation_MS
	if Object_ID('tempdb..#BatchTest_MS') is not null					drop table #BatchTest_MS
	if Object_ID('tempdb..#Observation_MS') is not null					drop table #Observation_MS
	if Object_ID('tempdb..#Notification_MS') is not null				drop table #Notification_MS
	if Object_ID('tempdb..#DataAuditEvent_MS') is not null				drop table #DataAuditEvent_MS	
	

	print '======================================================================================='
	print ' start Aggr Case'

	if Object_ID('tempdb..#AggrCase') is not null						drop table #AggrCase
	if Object_ID('tempdb..#AggrCaseFiltered') is not null				drop table #AggrCaseFiltered
	if Object_ID('tempdb..#Observation_AC') is not null					drop table #Observation_AC
	if Object_ID('tempdb..#Notification_AC') is not null				drop table #Notification_AC
	if Object_ID('tempdb..#DataAuditEvent_AC') is not null				drop table #DataAuditEvent_AC	

	
	exec spFiltered_AggrCase @StartDate
	
	if Object_ID('tempdb..#AggrCase') is not null						drop table #AggrCase
	if Object_ID('tempdb..#AggrCaseFiltered') is not null				drop table #AggrCaseFiltered
	if Object_ID('tempdb..#Observation_AC') is not null					drop table #Observation_AC
	if Object_ID('tempdb..#Notification_AC') is not null				drop table #Notification_AC
	if Object_ID('tempdb..#DataAuditEvent_AC') is not null				drop table #DataAuditEvent_AC	
	

	print '======================================================================================='
	print ' start Basic Syndromic Surveillance'

	if Object_ID('tempdb..#BasicSyndromicSurveillance') is not null			drop table #BasicSyndromicSurveillance
	if Object_ID('tempdb..#BasicSyndromicSurveillanceFiltered') is not null	drop table #BasicSyndromicSurveillanceFiltered
	if Object_ID('tempdb..#Human_BSS') is not null							drop table #Human_BSS	
	if Object_ID('tempdb..#GeoLocation_BSS') is not null					drop table #GeoLocation_BSS
	if Object_ID('tempdb..#Notification_BSS') is not null					drop table #Notification_BSS		
	if Object_ID('tempdb..#DataAuditEvent_BSS') is not null					drop table #DataAuditEvent_BSS	
		
	
	exec spFiltered_BasicSyndromicSurveillance @StartDate
	
	if Object_ID('tempdb..#BasicSyndromicSurveillance') is not null			drop table #BasicSyndromicSurveillance
	if Object_ID('tempdb..#BasicSyndromicSurveillanceFiltered') is not null	drop table #BasicSyndromicSurveillanceFiltered
	if Object_ID('tempdb..#Human_BSS') is not null							drop table #Human_BSS	
	if Object_ID('tempdb..#GeoLocation_BSS') is not null					drop table #GeoLocation_BSS
	if Object_ID('tempdb..#Notification_BSS') is not null					drop table #Notification_BSS		
	if Object_ID('tempdb..#DataAuditEvent_BSS') is not null					drop table #DataAuditEvent_BSS		
	

	print '======================================================================================='
	print ' start Basic Syndromic Surveillance Aggregate Form'
	
	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeader') is not null			drop table #BasicSyndromicSurveillanceAggregateHeader
	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeaderFiltered') is not null	drop table #BasicSyndromicSurveillanceAggregateHeaderFiltered
	if Object_ID('tempdb..#Notification_BSSa')  is not null									drop table #Notification_BSSa
	if Object_ID('tempdb..#DataAuditEvent_BSSa')  is not null								drop table #DataAuditEvent_BSSa

		
	exec spFiltered_BasicSyndromicSurveillanceAggregateForm @StartDate
	
	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeader') is not null			drop table #BasicSyndromicSurveillanceAggregateHeader
	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeaderFiltered') is not null	drop table #BasicSyndromicSurveillanceAggregateHeaderFiltered
	if Object_ID('tempdb..#Notification_BSSa')  is not null									drop table #Notification_BSSa
	if Object_ID('tempdb..#DataAuditEvent_BSSa')  is not null								drop table #DataAuditEvent_BSSa


	print '======================================================================================='
	print ' start Human Case'
	
	if Object_ID('tempdb..#HumanCase') is not null						drop table #HumanCase
	if Object_ID('tempdb..#HumanCaseFiltered') is not null				drop table #HumanCaseFiltered
	if Object_ID('tempdb..#TransferOutFiltered_HC')  is not null		drop table #TransferOutFiltered_HC
	if Object_ID('tempdb..#Outbreak_HC') is not null					drop table #Outbreak_HC
	if Object_ID('tempdb..#Human_HC') is not null						drop table #Human_HC
	if Object_ID('tempdb..#GeoLocation_HC') is not null					drop table #GeoLocation_HC
	if Object_ID('tempdb..#BatchTest_HC')  is not null					drop table #BatchTest_HC
	if Object_ID('tempdb..#Observation_HC') is not null					drop table #Observation_HC
	if Object_ID('tempdb..#Notification_HC')  is not null				drop table #Notification_HC
	if Object_ID('tempdb..#DataAuditEvent_HC') is not null				drop table #DataAuditEvent_HC
	
			
	exec spFiltered_HumanCase @StartDate
	
	if Object_ID('tempdb..#HumanCase') is not null						drop table #HumanCase
	if Object_ID('tempdb..#HumanCaseFiltered') is not null				drop table #HumanCaseFiltered
	if Object_ID('tempdb..#TransferOutFiltered_HC')  is not null		drop table #TransferOutFiltered_HC
	if Object_ID('tempdb..#Outbreak_HC') is not null					drop table #Outbreak_HC
	if Object_ID('tempdb..#Human_HC') is not null						drop table #Human_HC
	if Object_ID('tempdb..#GeoLocation_HC') is not null					drop table #GeoLocation_HC
	if Object_ID('tempdb..#BatchTest_HC')  is not null					drop table #BatchTest_HC
	if Object_ID('tempdb..#Observation_HC') is not null					drop table #Observation_HC
	if Object_ID('tempdb..#Notification_HC')  is not null				drop table #Notification_HC
	if Object_ID('tempdb..#DataAuditEvent_HC') is not null				drop table #DataAuditEvent_HC	
	

	print '======================================================================================='
	print ' start Vector Surveillance Session'
	
	if Object_ID('tempdb..#VectorSurveillanceSession') is not null				drop table #VectorSurveillanceSession
	if Object_ID('tempdb..#VectorSurveillanceSessionFiltered')  is not null		drop table #VectorSurveillanceSessionFiltered
	if Object_ID('tempdb..#TransferOutFiltered_VSS') is not null				drop table #TransferOutFiltered_VSS
	if Object_ID('tempdb..#Outbreak_VSS') is not null							drop table #Outbreak_VSS
	if Object_ID('tempdb..#GeoLocation_VSS') is not null						drop table #GeoLocation_VSS
	if Object_ID('tempdb..#BatchTest_VSS') is not null							drop table #BatchTest_VSS
	if Object_ID('tempdb..#Observation_VSS') is not null						drop table #Observation_VSS
	if Object_ID('tempdb..#Notification_VSS') is not null						drop table #Notification_VSS
	if Object_ID('tempdb..#DataAuditEvent_VSS') is not null						drop table #DataAuditEvent_VSS

	
	exec spFiltered_VectorSurveillanceSession @StartDate
	
	if Object_ID('tempdb..#VectorSurveillanceSession') is not null				drop table #VectorSurveillanceSession
	if Object_ID('tempdb..#VectorSurveillanceSessionFiltered')  is not null		drop table #VectorSurveillanceSessionFiltered
	if Object_ID('tempdb..#TransferOutFiltered_VSS') is not null				drop table #TransferOutFiltered_VSS
	if Object_ID('tempdb..#Outbreak_VSS') is not null							drop table #Outbreak_VSS
	if Object_ID('tempdb..#GeoLocation_VSS') is not null						drop table #GeoLocation_VSS
	if Object_ID('tempdb..#BatchTest_VSS') is not null							drop table #BatchTest_VSS
	if Object_ID('tempdb..#Observation_VSS') is not null						drop table #Observation_VSS
	if Object_ID('tempdb..#Notification_VSS') is not null						drop table #Notification_VSS
	if Object_ID('tempdb..#DataAuditEvent_VSS') is not null						drop table #DataAuditEvent_VSS	


	print '======================================================================================='
	print ' start Vet Case'
	
	if Object_ID('tempdb..#VetCase') is not null								drop table #VetCase
	if Object_ID('tempdb..#VetCaseFiltered') is not null						drop table #VetCaseFiltered
	if Object_ID('tempdb..#TransferOutFiltered_VC') is not null					drop table #TransferOutFiltered_VC
	if Object_ID('tempdb..#Outbreak_VC') is not null							drop table #Outbreak_VC
	if Object_ID('tempdb..#Farm_VC') is not null								drop table #Farm_VC
	if Object_ID('tempdb..#Human_VC') is not null								drop table #Human_VC
	if Object_ID('tempdb..#GeoLocation_VC') is not null							drop table #GeoLocation_VC
	if Object_ID('tempdb..#BatchTest_VC') is not null							drop table #BatchTest_VC
	if Object_ID('tempdb..#Observation_VC') is not null							drop table #Observation_VC
	if Object_ID('tempdb..#Notification_VC') is not null						drop table #Notification_VC
	if Object_ID('tempdb..#DataAuditEvent_VC') is not null						drop table #DataAuditEvent_VC

	
	exec spFiltered_VetCase @StartDate

	if Object_ID('tempdb..#VetCase') is not null								drop table #VetCase
	if Object_ID('tempdb..#VetCaseFiltered') is not null						drop table #VetCaseFiltered
	if Object_ID('tempdb..#TransferOutFiltered_VC') is not null					drop table #TransferOutFiltered_VC
	if Object_ID('tempdb..#Outbreak_VC') is not null							drop table #Outbreak_VC
	if Object_ID('tempdb..#Farm_VC') is not null								drop table #Farm_VC
	if Object_ID('tempdb..#Human_VC') is not null								drop table #Human_VC
	if Object_ID('tempdb..#GeoLocation_VC') is not null							drop table #GeoLocation_VC
	if Object_ID('tempdb..#BatchTest_VC') is not null							drop table #BatchTest_VC
	if Object_ID('tempdb..#Observation_VC') is not null							drop table #Observation_VC
	if Object_ID('tempdb..#Notification_VC') is not null						drop table #Notification_VC
	if Object_ID('tempdb..#DataAuditEvent_VC') is not null						drop table #DataAuditEvent_VC

