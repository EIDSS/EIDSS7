

CREATE VIEW [dbo].[LabSampleDiseaseMatrix]
AS
SELECT        m.idfMaterial AS SampleID, (CASE WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '' AND ms.SessionCategoryID = '10169001') THEN STUFF
                             ((SELECT        ',' + CAST(hmsDisease.idfsReference AS VARCHAR(MAX))
                                 FROM            dbo.tlbMonitoringSessionSummary AS msss INNER JOIN
                                                          dbo.tlbMonitoringSessionSummaryDiagnosis AS msssd ON msssd.idfMonitoringSessionSummary = msss.idfMonitoringSessionSummary AND msssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS hmsDisease ON hmsDisease.idfsReference = msssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbMonitoringSession AS ms2 ON ms2.idfMonitoringSession = msss.idfMonitoringSession
                                 WHERE        ms2.idfMonitoringSession = ms.idfMonitoringSession
                                 GROUP BY hmsDisease.idfsReference FOR XML PATH(''), TYPE ).value('.[1]', 'VARCHAR(MAX)'), 1, 2, '') WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '' AND ms.SessionCategoryID = '10169002') THEN STUFF
                             ((SELECT        ',' + CAST(vmsDisease.idfsReference AS VARCHAR(MAX))
                                 FROM            dbo.tlbMonitoringSessionSummary AS msss INNER JOIN
                                                          dbo.tlbMonitoringSessionSummaryDiagnosis AS msssd ON msssd.idfMonitoringSessionSummary = msss.idfMonitoringSessionSummary AND msssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vmsDisease ON vmsDisease.idfsReference = msssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbMonitoringSession AS ms2 ON ms2.idfMonitoringSession = msss.idfMonitoringSession
                                 WHERE        ms2.idfMonitoringSession = ms.idfMonitoringSession
                                 GROUP BY vmsDisease.idfsReference FOR XML PATH(''), TYPE ).value('.[1]', 'VARCHAR(MAX)'), 1, 2, '') WHEN (NOT ISNULL(m.idfHumanCase, '') = '') THEN CAST(hdrDisease.idfsReference AS VARCHAR(MAX)) 
                         WHEN (NOT ISNULL(m.idfVetCase, '') = '') THEN CAST(vdrDisease.idfsReference AS VARCHAR(MAX)) WHEN (NOT ISNULL(m.idfVectorSurveillanceSession, '') = '') THEN STUFF
                             ((SELECT        ',' + CAST(vssDisease.idfsReference AS VARCHAR(MAX))
                                 FROM            dbo.tlbVectorSurveillanceSessionSummary AS vsss INNER JOIN
                                                          dbo.tlbVectorSurveillanceSessionSummaryDiagnosis AS vsssd ON vsssd.idfsVSSessionSummary = vsss.idfsVSSessionSummary AND vsssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vssDisease ON vssDisease.idfsReference = vsssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbVectorSurveillanceSession AS vss2 ON vss2.idfVectorSurveillanceSession = vsss.idfVectorSurveillanceSession
                                 WHERE        vss2.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
                                 GROUP BY vssDisease.idfsReference FOR XML PATH(''), TYPE ).value('.[1]', 'VARCHAR(MAX)'), 1, 2, '') ELSE '' END) AS DiseaseIDList, (CASE WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '' AND 
                         ms.SessionCategoryID = '10169001') THEN STUFF
                             ((SELECT        ', ' + hmsDisease.name
                                 FROM            dbo.tlbMonitoringSessionSummary AS msss INNER JOIN
                                                          dbo.tlbMonitoringSessionSummaryDiagnosis AS msssd ON msssd.idfMonitoringSessionSummary = msss.idfMonitoringSessionSummary AND msssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS hmsDisease ON hmsDisease.idfsReference = msssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbMonitoringSession AS ms2 ON ms2.idfMonitoringSession = msss.idfMonitoringSession
                                 WHERE        ms2.idfMonitoringSession = ms.idfMonitoringSession
                                 GROUP BY hmsDisease.name FOR XML PATH(''), TYPE ).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, '') WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '' AND ms.SessionCategoryID = '10169002') THEN STUFF
                             ((SELECT        ', ' + vmsDisease.name
                                 FROM            dbo.tlbMonitoringSessionSummary AS msss INNER JOIN
                                                          dbo.tlbMonitoringSessionSummaryDiagnosis AS msssd ON msssd.idfMonitoringSessionSummary = msss.idfMonitoringSessionSummary AND msssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vmsDisease ON vmsDisease.idfsReference = msssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbMonitoringSession AS ms2 ON ms2.idfMonitoringSession = msss.idfMonitoringSession
                                 WHERE        ms2.idfMonitoringSession = ms.idfMonitoringSession
                                 GROUP BY vmsDisease.name FOR XML PATH(''), TYPE ).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, '') WHEN (NOT ISNULL(m.idfHumanCase, '') = '') THEN hdrDisease.name WHEN (NOT ISNULL(m.idfVetCase, '') = '') 
                         THEN vdrDisease.name WHEN (NOT ISNULL(m.idfVectorSurveillanceSession, '') = '') THEN STUFF
                             ((SELECT        ', ' + vssDisease.name
                                 FROM            dbo.tlbVectorSurveillanceSessionSummary AS vsss INNER JOIN
                                                          dbo.tlbVectorSurveillanceSessionSummaryDiagnosis AS vsssd ON vsssd.idfsVSSessionSummary = vsss.idfsVSSessionSummary AND vsssd.intRowStatus = 0 INNER JOIN
                                                          dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vssDisease ON vssDisease.idfsReference = vsssd.idfsDiagnosis INNER JOIN
                                                          dbo.tlbVectorSurveillanceSession AS vss2 ON vss2.idfVectorSurveillanceSession = vsss.idfVectorSurveillanceSession
                                 WHERE        vss2.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
                                 GROUP BY vssDisease.name FOR XML PATH(''), TYPE ).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, '') ELSE '' END) AS DiseaseName
FROM            dbo.tlbMaterial m LEFT JOIN
                         dbo.tlbHumanCase AS hc ON hc.idfHumanCase = m.idfHumanCase AND hc.intRowStatus = 0 LEFT JOIN
                         dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS hdrDisease ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis LEFT JOIN
                         dbo.tlbVetCase AS vc ON vc.idfVetCase = m.idfVetCase AND vc.intRowStatus = 0 LEFT JOIN
                         dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vdrDisease ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis LEFT JOIN
                         dbo.tlbVectorSurveillanceSession AS vss ON vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession AND vss.intRowStatus = 0 LEFT JOIN
                         dbo.tlbVectorSurveillanceSessionSummary AS vsssMain ON vsssMain.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession AND vsssMain.intRowStatus = 0 LEFT JOIN
                         dbo.tlbVectorSurveillanceSessionSummaryDiagnosis AS vsssdMain ON vsssdMain.idfsVSSessionSummary = vsssMain.idfsVSSessionSummary AND vsssdMain.intRowStatus = 0 LEFT JOIN
                         dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS vssDisease ON vssDisease.idfsReference = vsssdMain.idfsDiagnosis LEFT JOIN
                         dbo.tlbMonitoringSession AS ms ON ms.idfMonitoringSession = m.idfMonitoringSession AND ms.intRowStatus = 0 LEFT JOIN
                         dbo.tlbMonitoringSessionSummary AS mssMain ON mssMain.idfMonitoringSession = ms.idfMonitoringSession AND mssMain.intRowStatus = 0 LEFT JOIN
                         dbo.tlbMonitoringSessionSummaryDiagnosis AS mssdMain ON mssdMain.idfMonitoringSessionSummary = mssMain.idfMonitoringSessionSummary AND mssdMain.intRowStatus = 0 LEFT JOIN
                         dbo.FN_GBL_ReferenceRepair('EN', 19000019) AS mssDisease ON mssDisease.idfsReference = mssdMain.idfsDiagnosis

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LabSampleDiseaseMatrix';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LabSampleDiseaseMatrix';

