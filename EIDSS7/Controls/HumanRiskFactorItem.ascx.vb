Public Class HumanRiskFactorItem
    Inherits System.Web.UI.UserControl
    Public Property TypeOfRiskFactor As EIDSS.RiskFactorType

    Public Property DropDownItems As ListItemCollection

    Public Property QuestionText As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        RiskFactorQuestion.InnerText = QuestionText

        If TypeOfRiskFactor = EIDSS.RiskFactorType.TextBox Then
            typeTextBoxContainer.Visible = True
        Else
            typeDropDownContainer.Visible = True
            ddlSpecify.DataSource = DropDownItems
            ddlSpecify.DataBind()
        End If
    End Sub

End Class