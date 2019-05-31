Public Class HumanCaseClassificationItem
    Inherits System.Web.UI.UserControl

    Protected question As String
    Public Property QuestionText As String
        Get
            Return question
        End Get
        Set(value As String)
            question = value
        End Set
    End Property

    Private questiontype As EIDSS.ClassificationQuestionType
    Public Property TypeOfQuestion As EIDSS.ClassificationQuestionType
        Get
            Return questiontype
        End Get
        Set(value As EIDSS.ClassificationQuestionType)
            questiontype = value
        End Set
    End Property
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        suspectMainQuestion.InnerText = question

        If (questiontype = EIDSS.ClassificationQuestionType.Suspect) Then

            rdoYes.Attributes.Add("onchange", "tallySuspectQuestions('" + ID + "', 'yes')")
            rdoNo.Attributes.Add("onchange", "tallySuspectQuestions('" + ID + "', 'no')")
            rdoUnknown.Attributes.Add("onchange", "tallySuspectQuestions('" + ID + "', 'unknown')")
            rdoYes.GroupName = "SuspectMain"
            rdoNo.GroupName = "SuspectMain"
            rdoUnknown.GroupName = "SuspectMain"
        End If

        If (questiontype = EIDSS.ClassificationQuestionType.Probable) Then

            rdoYes.Attributes.Add("onchange", "tallyProbableQuestions('" + ID + "', 'yes')")
            rdoNo.Attributes.Add("onchange", "tallyProbableQuestions('" + ID + "', 'no')")
            rdoUnknown.Attributes.Add("onchange", "tallyProbableQuestions('" + ID + "', 'unknown')")
            rdoYes.GroupName = "ProbableMain"
            rdoNo.GroupName = "ProbableMain"
            rdoUnknown.GroupName = "ProbableMain"
        End If
    End Sub

End Class