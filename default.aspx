<%@ Page Title="Ctrl-F" Language="VB" AutoEventWireup="true" SmartNavigation="true" debug="true" %>
<%@ Import Namespace="System.IO" %> 
<script runat="server">
    Dim questions() As String
    Const PW As String = "kwong"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Not IsPostBack Then
            ddlExam.Items.Add(New ListItem("CISM", "CISM.txt"))
            ddlExam.Items.Add(New ListItem("PM", "projectP.txt"))
            ddlExam.SelectedIndex = 0
            divEntered.Visible = False
            divAccess.Visible = True
            txtPW.Focus()
        Else
            If ViewState("pw") <> PW Then
                If txtPW.Text <> PW Then
                    divResult.InnerHtml = "Please try again<br>"
                    txtPW.Text = ""
                    txtPW.Focus()
                    Exit Sub
                Else
                    ViewState("pw") = PW
                    divEntered.Visible = True
                    divAccess.Visible = False
                    txtFind.Focus()
                    divResult.InnerHtml = ""
                End If
            End If
            If Trim(txtFind.Text) = "" Then Exit Sub
            questions = Split(GetQuestions(ddlExam.SelectedValue), "$$")
            Dim str As String = ""
            Dim i As Integer, j As Integer = 0
            For i = 0 To questions.Length - 1
                If InStr(LCase(questions(i)), LCase(txtFind.Text)) > 0 Then
                    j += 1
                    If j > 5 Then Exit For
                    str = str & HiLite(questions(i), LCase(txtFind.Text)) & "<br><br>"
                End If
            Next 'i
            If i = questions.Length Then
                divResult.InnerHtml = Replace(str, vbCrLf, "<br>")
            Else
                divResult.InnerHtml = "Type more words to help me find the questions, please<br>"
            End If
        End If
        txtFind.Text = ""
        txtFind.Focus()
    End Sub

    Function HiLite(ByVal question As String, find As String)
        Dim str As String = "", i As Integer = 1, j As Integer
        Do
            j = InStr(i, LCase(question), find)
            If j > 0 Then
                str = str + Mid(question, i, j - i) & "<span>" & Mid(question, j, Len(find)) & "</span>"
                i = j + Len(find)
            Else
                str = str + Mid(question, i)
                Exit Do
            End If
        Loop
        HiLite = str
    End Function

    Function GetQuestions(ByVal ChPath As String) As String
        Dim strContents As String
        Try
            Using reader As StreamReader = New StreamReader(Server.MapPath(ChPath))
                strContents = reader.ReadToEnd()
            End Using
        Catch ex As Exception
            strContents = "FAIL: " + ex.Message
        End Try
        Return strContents
    End Function

 </script> 
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ctrl-F</title>
<style>
span {
  background-color: yellow;
}
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div id ="divAccess" runat="server">
           Enter password:&nbsp;<asp:TextBox ID="txtPW" runat="server" Width="128px" AutoPostBack="True" />
        </div>
        <div id="divEntered" runat="server">
        <div>
            Choose Exam:&nbsp;<asp:DropDownList ID ="ddlExam" runat="server" AutoPostBack="True" EnableViewState="True" />
        </div><br />
        <div>
           Enter text:&nbsp;<asp:TextBox ID="txtFind" runat="server" Width="720px" AutoPostBack="True" />
        </div><br />
        </div>
        <div id="divResult" runat="server"></div>
    </form>
</body>
</html>
