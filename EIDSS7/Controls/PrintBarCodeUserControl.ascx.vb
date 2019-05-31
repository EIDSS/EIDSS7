Imports System.Reflection
Imports OpenEIDSS.Domain

Public Class PrintBarCodeUserControl
    Inherits UserControl

#Region "Global Values"

    Private Shared Log = log4net.LogManager.GetLogger(GetType(PrintBarCodeUserControl))

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub Setup(samples As List(Of LabSampleGetListModel))

        Try
            dlBarCodes.DataSource = samples
            dlBarCodes.DataBind()

            upPrintBarCode.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' Add class for page break after 12 records have bound.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BarCodes_ItemDataBound(sender As Object, e As DataListItemEventArgs) Handles dlBarCodes.ItemDataBound

        If e.Item.ItemType = ListItemType.Item Then
            Dim divSeparator As HtmlGenericControl = CType(e.Item.FindControl("divSeparator"), HtmlGenericControl)

            If e.Item.ItemIndex > 0 Then
                If e.Item.ItemIndex Mod 14 = 0 Then
                    divSeparator.Attributes.Add("class", "pageBreak")
                End If
            End If
        End If

    End Sub

End Class