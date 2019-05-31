<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="EIDSS.Login" UICulture="auto" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html>

<script runat="server">
    Protected Overrides Sub InitializeCulture()
        If Request.Form("ListBox1") IsNot Nothing Then
            ' TODO: replace this hard-coded english/spanish piece with actual code found here:
            ' https://msdn.microsoft.com/en-us/library/bz9tc508.aspx?cs-save-lang=1&cs-lang=vb#code-snippet-3
            'en-US - English
            'es-MX - Español

            Dim selectedLanguage As String = "usEN"

            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(selectedLanguage)
            Thread.CurrentThread.CurrentUICulture = New CultureInfo(selectedLanguage)
        End If
        MyBase.InitializeCulture()

    End Sub
</script>

<%--Create system level session variables--%>
<%
    Dim lines As String()
    lines = System.IO.File.ReadAllLines(Server.MapPath("~/App_Data/EIDSS.txt"))
    Dim parts As String()
    For Each line In lines
        parts = line.Split("=")
        If (parts.Length = 2) Then
            Me.Session(parts(0).Trim()) = parts(1).Trim()
        End If
    Next
%>  

<html lang="<%=PageLanguage %>">
    <head>

        <title>EIDSS: Web Login</title>

        <link href="Includes/CSS/Styles.css" rel="stylesheet" />
        <link href="Includes/CSS/bootstrap.css" rel="stylesheet" />

        <script lang="ja" type="text/javascript">

            //Disable browser back button 

            function _disableBackBtn() { window.history.forward(); }
            _disableBackBtn();
            window.onload = _disableBackBtn();
            window.onpageshow = function (evt) { if (evt.persisted) _disableBackBtn(); }
            window.onunload = function () { void (0); }

    	    function AddOnloadFunction(func) {

                if (window.onload) {
                    var oldfunc = window.onload;
                    window.onload = function () {
                        oldfunc();
                        func();
                    };
                }
                else {
                    window.onload = func;
                }
    	    }
        </script>

    </head>
    <body>
        <form id="frmLogin" runat="server">
            
            <div id="headerwrap">
                <div id="header">
                    <table style="width:100%;border:none;">
                        <tr>
                            <td>
                                <div class="infoLoginPanel" />
                                <h1 style="color:transparent; position:absolute; left:-1000px;">Electronic Integrated Disease Surveilance System</h1>
                            </td>
                        </tr>
                        <tr style="text-align:center;">
                            <td style="align-content:center;">
                                <div style="background-image:url('/Includes/Images/Web_Login_Title.png');
background-repeat:no-repeat; background-size:1024px 150px; border:none; width:1024px; height:150px; margin:auto;"></div>
                                
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="middlewrap">
                <div id="middle">
                    <div id="sidebar">
                        <span id="TabbedVerticalMenu"></span>
                    </div>
                    <div id="topbar" style="width:100%;">
                    </div>
                    <div id="content">
                        <div style="margin-bottom:0;width:100%;" id="divBody">
                            <div style="padding-top:75px;text-align:center">
                                <table style="width:50%;border:inset;border-collapse:collapse; border-spacing:0;padding:0px;margin:auto">
		                            <tr style="text-align:center"> 
			                            <td style="text-align:center">
                                            <asp:ValidationSummary ID="vsLogin" runat="server" ShowMessageBox="False" />
                                        </td>
                                    </tr>

		                            <tr style="text-align:center"> 
			                            <td style="text-align:center">
				                            <table style="width:100%;border:none;border-collapse:collapse; border-spacing:3px;padding:0px;margin:auto;background-color:white;margin:auto">
				                                <tr style="text-align:center">
					                                <td style="text-align:right;height:46px;width:37%">
                                                        <asp:Label 
                                                            AssociatedControl="txtOrganization" 
                                                            runat="server" 
                                                            Text="<%$ Resources:GlobalLabelResources, LblOrganizationText %>" 
                                                            ToolTip="<%$ Resources:GlobalLabelResources, LblOrganizationToolTip %>" AssociatedControlID="txtOrganization"/>
					                                </td>
					                                <td style="height:46px;width:63%;text-align:left">
                                                        <asp:TextBox ID="txtOrganization" runat="server" MaxLength="25" Width="250px" Text="" />
                                                        <asp:RequiredFieldValidator ID="rfvOrganization" runat="server" ControlToValidate="txtOrganization" ErrorMessage="Organization is Required." />
						                            </td>
					                            </tr>

                                                <tr style="text-align:center">
					                                <td id="lblUserName" style="text-align:right;height:46px;width:37%">
                                                        <asp:Label 
                                                            AssociatedControlID="txtUserName" 
                                                            runat="server"
                                                            Text="<%$ Resources:GlobalLabelResources, LblLoginText %>"
                                                            ToolTip="<%$ Resources:GlobalLabelResources, LblLoginToolTip %>"></asp:Label>
                                                        </td>
					                                <td style="height:46px;width:63%;text-align:left">
                                                        <asp:TextBox ID="txtUserName" runat="server" MaxLength="25" Width="250px" Text="" />
                                                        <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="User Name is Required." />
						                            </td>
					                            </tr>

                                                <tr style="text-align:center">
					                                <td id="lblUserKey" style="text-align:right;height:46px;width:37%">
                                                        <asp:Label 
                                                            AssociatedControlID="txtPassword"
                                                            runat="server"
                                                            Text="<%$ Resources:GlobalLabelResources, LblPasswordText %>"    
                                                            ToolTip="<%$ Resources:GlobalLabelResources, lblPasswordToolTip %>"></asp:Label>
                                                    </td>
					                                <td style="height:46px;width:63%;text-align:left">
                                                        <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" MaxLength="25" Width="250px" Text="" />
                                                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is Required." />
						                            </td>
					                            </tr>

                                                <tr style="text-align:center">
					                                <td style="height:46px" colspan="2"> 
                                                        <asp:Button ID="btnLogin" runat="server" Text="<%$ Resources:GlobalButtonResources, BtnLoginText %>" />
						                                <br />
					                                </td>
				                                </tr>
			                                </table>
			                            </td>
		                            </tr>
	                            </table>
	                            <br />
	                            <br />
	                            <br />
	                            <br />
	                            <br />
	                            <table style="border:none">
		                            <tr>
			                            <td>
                                            <p>
                                                The Electronic Integrated Disease Surveillance System (EIDSS) Open Source Software (OSS) is an application that can be configured to support a disease surveillance network, implemented throughout a particular geographic region or country for use by public health practitioners, epidemiologists, and laboratory personnel. The application integrates data collection of infectious diseases in human, veterinary animal and natural vector cases. Recorded information includes demographics, geographical location, laboratory analysis, sample tracking, epidemiological analysis, clinical information (including disease specific clinical signs) and response measures into comprehensive information sets that can be synchronized across sites. A fully integrated system is capable of providing near real time information flow that can be disseminated to the appropriate organizations in a timely manner. Administrative menus easily support customization for language translations or to meet specific reporting standards of an organization. Epidemiological analysis tools include Analysis, Visualization and Reporting tool (AVR) and direct integration with Center for Disease Control and Prevention’s (CDC) Epi Info.
                                            </p>
			                            </td>
		                            </tr>
	                            </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="footerwrap">
                <div id="footer">
                    <table style="width:100%;border:none;">
                        <tr style="height:1px;vertical-align:top">
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td id="_coname" style="vertical-align:top;text-align:center;font-size:10px">
                                <a href="javascript:void(0);">Disclaimer</a>&nbsp;|&nbsp;<span>&copy; 2016 - <%=CStr(Year(Now)) & " " & Session("CompanyName")%>.&nbspAll Rights Reserved.</span>
                            </td>
                        </tr>
                    </table>
                </div>
		    </div>
        </form>
    </body>
</html>
