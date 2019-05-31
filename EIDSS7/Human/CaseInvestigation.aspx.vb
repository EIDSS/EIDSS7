Public Class CaseInvestigation

    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' NOTE:  This code should NOT be replaced
        SetAttributes()
        ' NOTE:  The code below can be safely removed when databinding UI to data
        '  the code was just to get samples of data onto the form while designing it - Evander
        grdSamplesCollection.DataSource = New List(Of TempSampleDataElement)
        grdSamplesCollection.DataBind()
        Dim item1 = New ListItem()
        item1.Text = "Select"
        item1.Value = "0"
        Dim item2 = New ListItem()
        item2.Text = "Gori Support Station of the Laboratory of the Ministry of Agriculture"
        item2.Value = "49710000000"
        Dim items = New List(Of ListItem)
        items.Add(item1)
        items.Add(item2)
        ddlOrganizationSent.DataSource = items
        ddlOrganizationSent.DataBind()
        ddlOrganizationReceived.DataSource = items
        ddlOrganizationReceived.DataBind()
        ddlOrganizationInvestigating.DataSource = items
        ddlOrganizationInvestigating.DataBind()
        DoSuspectQuestions()
        DoProbableQuestions()
        DoRiskFactorQuestions()
    End Sub

    Private Sub DoSuspectQuestions()
        For counter = 1 To 10
            Dim questionText = "This is Suspect Question #" + counter.ToString()
            Dim questionControl = CType(LoadControl("../Controls/HumanCaseClassificationItem.ascx"), HumanCaseClassificationItem)

            questionControl.QuestionText = questionText
            questionControl.TypeOfQuestion = EIDSS.ClassificationQuestionType.Suspect
            questionControl.ID = "suspectQuestion" + counter.ToString()
            suspectQuestionContainer.Controls.Add(questionControl)
        Next

    End Sub

    Private Sub DoProbableQuestions()
        For counter = 1 To 10
            Dim questionText = "This is Probable Question #" + counter.ToString()
            Dim questionControl = CType(LoadControl("../Controls/HumanCaseClassificationItem.ascx"), HumanCaseClassificationItem)

            questionControl.QuestionText = questionText
            questionControl.TypeOfQuestion = EIDSS.ClassificationQuestionType.Probable
            questionControl.ID = "probableQuestion" + counter.ToString()
            probableQuestionContainer.Controls.Add(questionControl)
        Next
    End Sub

    Private Sub DoRiskFactorQuestions()
        For counter = 1 To 10
            Dim questionText = "This is Risk Factor #" + counter.ToString()
            Dim questionControl = CType(LoadControl("../Controls/HumanRiskFactorItem.ascx"), HumanRiskFactorItem)

            questionControl.QuestionText = questionText
            questionControl.TypeOfRiskFactor = EIDSS.RiskFactorType.TextBox
            questionControl.ID = "RiskFactorQuestion" + counter.ToString()
            riskFactorsContainer.Controls.Add(questionControl)
        Next
    End Sub
    Private Sub SetAttributes()
        ddlOrganizationSent.SearchPageUrl = "../System/Administration/OrganizationAdmin.aspx?isModal=true&ListId=" + ddlOrganizationSent.ClientID
        ddlOrganizationReceived.SearchPageUrl = "../System/Administration/OrganizationAdmin.aspx?isModal=true&ListId=" + ddlOrganizationReceived.ClientID
        ddlOrganizationInvestigating.SearchPageUrl = "../System/Administration/OrganizationAdmin.aspx?isModal=true&ListId=" + ddlOrganizationInvestigating.ClientID
    End Sub
End Class
'Note:  this class can be safely removed when writing code for back end data
'  the code was just to get samples of data onto the form while designing it - Evander
Public Class TempSampleDataElement
    Public Property SampleType As String
    Public Property LocalSampleId As String
    Public Property CollectionDate As String
    Public Property SentDate As String

End Class