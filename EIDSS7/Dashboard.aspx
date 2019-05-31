<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="EIDSS.Dashboard" EnableSessionState="true" meta:resourcekey="Page" %>

<%@ Import Namespace="System.Threading" %>
<%@ Register Src="~/Controls/PageHeaderUserControl.ascx" TagPrefix="eidss" TagName="PageHeaderUserControl" %>
<%@ Register Src="~/Controls/PageFooterUserControl.ascx" TagPrefix="eidss" TagName="PageFooterUserControl" %>

<!DOCTYPE html>
<%
    Dim lines As String()
    lines = System.IO.File.ReadAllLines(Server.MapPath("~/App_Data/EIDSS.txt"))
    Dim parts As String()
    For Each line In lines
        parts = line.Split("=")
        If (parts.Length = 2) Then
            Me.ViewState(parts(0).Trim()) = parts(1).Trim()
        End If
    Next
%>
<html>
<head runat="server">
    <meta charset="ISO-8859-5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%: Page.Title %></title>
    <script lang="javascript" type="text/javascript">
        //Disable browser back button 
        function _disableBackBtn() { window.history.forward(); }
        _disableBackBtn();
        window.onload = _disableBackBtn();
        window.onpageshow = function (evt) { if (evt.persisted) _disableBackBtn(); }
        window.onunload = function () { void (0); }
        //End of diabling browser back button

        //Disable Backspace from browser
        function killBackSpace(e) {
            e = e ? e : window.event;
            var t = e.target ? e.target : e.srcElement ? e.srcElement : null;
            if (t && t.tagName && (t.type && /(password)|(text)|(file)/.test(t.type.toLowerCase())) || t.tagName.toLowerCase() == 'textarea')
                return true;

            var k = e.keyCode ? e.keyCode : e.which ? e.which : null;
            if (k == 8) {
                if (e.preventDefault)
                    e.preventDefault();

                return false;
            };
            return true;
        };

        if (typeof document.addEventListener != 'undefined')
            document.addEventListener('keydown', killBackSpace, false);
        else if (typeof document.attachEvent != 'undefined')
            document.attachEvent('onkeydown', killBackSpace);
        else {
            if (document.onkeydown != null) {
                var oldOnkeydown = document.onkeydown;

                document.onkeydown = function (e) {
                    oldOnkeydown(e);
                    killBackSpace(e);
                };

            }
            else
                document.onkeydown = killBackSpace;
        }
        //End Disable Backspace from browser

        // Usage: AddOnloadFunction(function () { <function name>() });
        // <function name> is the function defined in any js file that is loaded in page_load
        // Mutiple functions can be called by calling AddOnLoadFunction mutiple times
        function addLoadEvent(func) {
            var oldonload = window.onload;
            if (typeof window.onload != 'function') {
                window.onload = func;
            } else {
                window.onload = function () {
                    if (oldonload) {
                        oldonload();
                    }
                    func();
                }
            }
        }
    </script>
</head>
<body>
    <form id="frmMain" name="frmMain" runat="server">
        <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
        <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
        <asp:HiddenField ID="hdfUserID" runat="server" Value="" />
        <asp:HiddenField ID="hdfUserName" runat="server" Value="" />
        <asp:HiddenField ID="hdfUserOrganization" runat="server" Value="" />
        <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
        <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />

        <div id="gridCount" runat="server">
            <asp:HiddenField ID="hdfUnaccessionedSamplesCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfUsersCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfNotificationsCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfMyNotificationsCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfInvestigationsCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfMyInvestigationsCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfMyCollectionsCount" runat="server" Value="0" />
        </div>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <nav class="navbar navbar-default  navbar-fixed-top">
            <div class="container-fluid">
                <eidss:PageHeaderUserControl runat="server" ID="ucPageHeader" />
            </div>
        </nav>
        <div>
            <asp:UpdatePanel runat="server" ID="upDashboard" UpdateMode="Conditional">
                <ContentTemplate>
                    <section class="dashboard-links">
                        <div class="container">
                            <p class="db-title" meta:resourcekey="Hdg_Form_Title" runat="server"></p>
                            <div class="row">
                                <div class="col-md-8 col-sm-6">
                                    <div class="row" id="dashboardLinks" runat="server">
                                    </div>
                                </div>
                                <div class="col-md-4 col-sm-6 sidebox" runat="server">
                                    <div class="sidebox-group">
                                        <h4 id="heading7"><a href="#" meta:resourcekey="Hdg_Download_Paper_Forms" runat="server"> </a></h4>
                                    </div>
                                    <div class="sidebox-group">
                                        <h4 id="heading8"><a href="#" meta:resourcekey="Hdg_Training_Videos" runat="server"></a></h4>
                                    </div>
                                    <div class="sidebox-group">
                                        <h4 id="heading9"><a href="/System/SystemPreferences.aspx" meta:resourcekey="Hdg_System_Preferences" runat="server"></a></h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <section class="dashboard-grid">
                        <div id="usersDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_Users" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <eidss:GridView
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfEmployee"
                                        GridLines="None"
                                        ID="gvUsers"
                                        meta:resourcekey="Grd_My_Cases"
                                        runat="server"
                                        PagerSettings-Visible="false"
                                        UseAccessibleHeader="true"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="strFirstName" HeaderText="<%$ Resources:Grd_First_Name_Heading %>" SortExpression="strFirstName" />
                                            <asp:BoundField DataField="strFamilyName" HeaderText="<%$ Resources:Grd_Family_Name_Heading %>" SortExpression="strFamilyName" />
                                            <asp:BoundField DataField="strSecondName" HeaderText="<%$ Resources:Grd_Second_Name_Heading %>" SortExpression="strSecondName" />
                                            <asp:BoundField DataField="Organization" HeaderText="<%$ Resources:Grd_Organization_Heading %>" SortExpression="Organization" />
                                            <asp:BoundField DataField="OrganizationFullName" HeaderText="<%$ Resources:Grd_Organization_Full_Name_Heading %>" SortExpression="OrganizationFullName" />
                                            <asp:BoundField DataField="Position" HeaderText="<%$ Resources:Grd_Position_Heading %>" SortExpression="Position" />
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_Edit"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </eidss:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divUsersPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-4 text-left">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblUsersNumberOfRecords" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-1 col-xs-1 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblUsersPageNumber" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-7 text-right">
                                    <asp:Repeater ID="rptUsersPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkUsersPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="unaccessionedSamplesDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_Unaccessioned_Samples" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <eidss:GridView ID="gvUnaccessionedSamples" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="table table-striped" PagerSettings-Visible="false"
                                        DataKeyNames="SampleID" GridLines="None" meta:resourcekey="Grd_Unaccessioned_Samples" runat="server" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" />
                                            <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" />
                                            <asp:BoundField DataField="EIDSSLocalFieldSampleID" SortExpression="EIDSSLocalFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>" />
                                            <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                            <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                        </Columns>
                                    </eidss:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divUnaccessionedSamplesPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6 text-left">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblUnaccessionedSamplesNumberofRecords" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-2 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblUnaccessionedSamplesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptUnaccessionedSamplesPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkUnaccessionedSamplesPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="UnaccessionedSamplesPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="approvalsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_My_Approvals" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <eidss:GridView ID="gvMyApprovals"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        GridLines="None"
                                        meta:resourcekey="Grd_My_Approvals"
                                        runat="server"
                                        UseAccessibleHeader="true"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <Columns>
                                            <asp:BoundField DataField="Approval" HeaderText="<%$ Resources: Labels, Lbl_Approvals_Text %>" />
                                            <asp:BoundField DataField="NumberOfRecords" HeaderText="<%$ Resources: Labels, Lbl_Number_Of_Records_Heading_Text %>" />
                                            <asp:HyperLinkField HeaderText="<%$ Resources: Labels, Lbl_Actions_Text %>" Text="<%$ Resources: Labels, Lbl_View_Text %>" DataNavigateUrlFields="Action" />
                                        </Columns>
                                    </eidss:GridView>
                                </div>
                            </div>
                        </div>
                        <div id="notificationsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_Notifications" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvNotifications" runat="server"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfHumanCase" PagerSettings-Visible="false"
                                        GridLines="None"
                                        UseAccessibleHeader="true"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="strReportID" HeaderText='<%$ Resources:lbl_Report_ID.InnerText %>' SortExpression="strReportID" />
                                            <asp:BoundField DataField="datEnteredDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText='<%$ Resources:lbl_Date_Entered.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strPersonName" HeaderText="Person Name" SortExpression="strPersonName" />
                                            <asp:BoundField DataField="strDisease" HeaderText='<%$ Resources:lbl_Disease.InnerText %>' SortExpression="strDisease" />
                                            <asp:BoundField DataField="strNotifyingOrganization" HeaderText='<%$ Resources:lbl_Organization_Full_Name.InnerText %>' SortExpression="strNotifyingOrganization" />
                                            <asp:BoundField DataField="InpatientOrOutpatient" HeaderText='<%$ Resources:lbl_Inpatient_Or_Outpatient.InnerText %>' SortExpression="InpatientOrOutpatient" />
                                            <asp:BoundField DataField="strNotifiedBy" HeaderText='<%$ Resources:lbl_Notified_By.InnerText %>' SortExpression="strNotifiedBy" />
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnView" runat="server" CausesValidation="False" CommandName="view"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_View"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnAdd" runat="server" CausesValidation="False" CommandName="add"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divNotificationsPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblNotificationsNumberofRecords" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-2 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblNotificationsPageNumber" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 text-right">
                                    <asp:Repeater ID="rptNotificationsPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkNotificationsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="NotificationsPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="mynotificationsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_My_Notifications" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvMyNotifications" runat="server"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfHumanCase"
                                        GridLines="None"
                                        meta:resourcekey="Grd_My_Cases"
                                        UseAccessibleHeader="true"
                                        PagerSettings-Visible="false"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="datEnteredDate" HeaderText='<%$ Resources:lbl_Date_Entered.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strReportID" HeaderText='<%$ Resources:lbl_Report_ID.InnerText %>' SortExpression="strReportID" />
                                            <asp:BoundField DataField="strPerson" HeaderText='<%$ Resources:lbl_Person.InnerText %>' SortExpression="strPerson" />
                                            <asp:BoundField DataField="strDiagnosis" HeaderText='<%$ Resources:lbl_Disease.InnerText %>' SortExpression="strDisease" />
                                            <asp:BoundField DataField="datDiseaseDate" HeaderText='<%$ Resources:lbl_Disease_Date.InnerText %>' SortExpression="datDiseaseDate" />
                                            <asp:BoundField DataField="strClassification" HeaderText='<%$ Resources:lbl_Classification.InnerText %>' SortExpression="strClassification" />
                                            <asp:BoundField DataField="strInvestigatedBy" HeaderText='<%$ Resources:lbl_Investigated_By.InnerText %>' SortExpression="strInvestigatedBy" />
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnView" runat="server" CausesValidation="False" CommandName="view"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_View"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divMyNotificationsPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblMyNotificationsNumberofRecords" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-2 col-xs-1 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblMyNotificationsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-7 text-right">
                                    <asp:Repeater ID="rptMyNotificationsPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkMyNotificationsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="MyNotificationsPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="investigationsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_Investigations" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvInvestigations" runat="server"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfVetCase"
                                        GridLines="None"
                                        UseAccessibleHeader="true"
                                        PagerSettings-Visible="false"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="strReportID" HeaderText='<%$ Resources:lbl_Report_ID.InnerText %>' SortExpression="strReportID" />
                                            <asp:BoundField DataField="datEnteredDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText='<%$ Resources:lbl_Date_Entered.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strSpecies" HeaderText='<%$ Resources:lbl_Species.InnerText %>' SortExpression="strSpecies" />
                                            <asp:BoundField DataField="strDisease" HeaderText='<%$ Resources:lbl_Disease.InnerText %>' SortExpression="strDisease" />
                                            <asp:BoundField DataField="datInvestigationDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText='<%$ Resources:lbl_Investigation_Date.InnerText %>' SortExpression="datInvestigationDate" />
                                            <asp:BoundField DataField="strInvestigatedBy" HeaderText='<%$ Resources:lbl_Investigation_By.InnerText %>' SortExpression="strInvestigatedBy" />
                                            <asp:BoundField DataField="strClassification" HeaderText='<%$ Resources:lbl_Classification.InnerText %>' SortExpression="strClassification" />
                                            <asp:BoundField DataField="strAddress" HeaderText='<%$ Resources:lbl_Address.InnerText %>' SortExpression="strAddress" />
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnView" runat="server" CausesValidation="False" CommandName="view"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_View"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div id="divInvestigationsPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblInvestigationsNumberofRecords" runat="server"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-2 col-xs-1 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblInvestigationsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-7 text-right">
                                    <asp:Repeater ID="rptInvestigationsPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkInvestigationsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="InvestigationsPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="myinvestigationsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_My_Investigations" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvMyInvestigations" runat="server"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfVetCase"
                                        GridLines="None"
                                        meta:resourcekey="Grd_My_Cases"
                                        UseAccessibleHeader="true"
                                        PagerSettings-Visible="false"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="strReportID" HeaderText='<%$ Resources:lbl_Report_ID.InnerText %>' SortExpression="strReportID" />
                                            <asp:BoundField DataField="datEnteredDate" HeaderText='<%$ Resources:lbl_Date_Entered.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strSpecies" HeaderText='<%$ Resources:lbl_Species.InnerText %>' SortExpression="strSpecies" />
                                            <asp:BoundField DataField="strDisease" HeaderText='<%$ Resources:lbl_Disease.InnerText %>' SortExpression="strDisease" />
                                            <asp:BoundField DataField="datInvestigationDate" HeaderText='<%$ Resources:lbl_Investigation_Date.InnerText %>' SortExpression="datInvestigationDate" />
                                            <asp:BoundField DataField="strClassification" HeaderText='<%$ Resources:lbl_Classification.InnerText %>' SortExpression="strClassification" />
                                            <asp:BoundField DataField="strAddress" HeaderText='<%$ Resources:lbl_Address.InnerText %>' SortExpression="strAddress" />
                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_Edit"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divMyInvestigationsPager" class="row" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblMyInvestigationsNumberofRecords" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-2 col-xs-1 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblMyInvestigationsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-7 text-right">
                                    <asp:Repeater ID="rptMyInvestigationsPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkMyInvestigationsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="MyInvestigationsPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div id="myCollectionsDiv" runat="server" class="container" visible="false">
                            <div class="heading">
                                <h3 meta:resourcekey="Hdg_My_Collections" runat="server"></h3>
                            </div>
                            <div class="row">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvMyCollections" runat="server"
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CaptionAlign="Bottom"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfVectorSurveillanceSession"
                                        GridLines="None"
                                        PagerSettings-Visible="false"
                                        UseAccessibleHeader="true"
                                        ShowHeader="true">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <FooterStyle HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="strSessionID" HeaderText='<%$ Resources:lbl_Session_ID.InnerText %>' SortExpression="strSessionID" />
                                            <asp:BoundField DataField="datEnteredDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText='<%$ Resources:lbl_Date_Entered.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strVectors" HeaderText='<%$ Resources:lbl_Vectors.InnerText %>' SortExpression="datEnteredDate" />
                                            <asp:BoundField DataField="strDisease" HeaderText='<%$ Resources:lbl_Disease.InnerText %>' SortExpression="strDisease" />
                                            <asp:BoundField DataField="datStartDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText='<%$ Resources:lbl_Start_Date.InnerText %>' SortExpression="datStartDate" />
                                            <asp:BoundField DataField="strRegion" HeaderText='<%$ Resources:lbl_Region.InnerText %>' SortExpression="strRegion" />
                                            <asp:BoundField DataField="strRayon" HeaderText='<%$ Resources:lbl_Rayon.InnerText %>' SortExpression="strRayon" />
                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" meta:resourceKey="btn_Edit" CommandName="edit"
                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">&nbsp;</div>
                            <div id="divMyCollectionsPager" runat="server" class="row">
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblMyCollectionsNumberofRecords" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-2 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblMyCollectionsPager" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptMyCollectionsPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkMyCollectionsPager" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="MyCollectionsPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </section>
                    <div id="errorModal" class="modal" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Dashboard"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                <span class="glyphicon glyphicon-remove-sign modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <p id="lbl_Error" runat="server"></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <button id="btnErrorOK" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="humanDiseaseNotification" class="modal" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Notification"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                <label meta:resourcekey="Lbl_Disease_Diagnosis" runat="server"></label>
                                                <asp:Label ID="lblstrFinalDiagnosis" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label runat="server" meta:resourcekey="lbl_Date_of_Diagnosis"></label>
                                                <asp:Label ID="lbldatDateOfDiagnosis" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label runat="server" meta:resourcekey="lbl_Date_of_Notification"></label>
                                                <asp:Label ID="lbldatNotificationDate" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Status_of_Patient"></label>
                                                <asp:Label ID="lblstrFinalState" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Notification_Sent_by"></label>
                                                <asp:Label ID="lblstrNotificationSentby" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Notification_Received_by"></label>
                                                <asp:Label ID="lblstrNotificationReceivedby" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Hospitalization_Status"></label>
                                                <asp:Label ID="lblstrHospitalizationStatus" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                <asp:Label ID="lblstrHospital" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Current_Location"></label>
                                                <asp:Label ID="lblstrCurrentLocation" runat="server" CssClass="form-control"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <button runat="server" type="submit" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" id="btnNotificationsOK"></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="veterinaryDiseaseNotification" runat="server" class="modal" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Investigation"></h4>
                                </div>
                                <div class="modal-body">
                                    <fieldset>
                                        <legend runat="server" meta:resourcekey="lbl_Notification"></legend>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Organization"></label>
                                                    <asp:Label ID="lblReportedByOrganization" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Reported_By"></label>
                                                    <asp:Label ID="lblReportedByPersonID" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Initial_Report_Date"></label>
                                                    <asp:Label ID="lblReportDate" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                    <fieldset>
                                        <legend runat="server" meta:resourcekey="lbl_Investigated"></legend>
                                        <div class="form-group" runat="server">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Investigation_Organization"></label>
                                                    <asp:Label ID="lblInvestigatedByOrganizationName" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Investigator_Name"></label>
                                                    <asp:Label ID="lblInvestigatedByPersonName" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Assigned_Date"></label>
                                                    <asp:Label ID="lblAssignedDate" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Invesigation_Date"></label>
                                                    <asp:Label ID="lblInvestigationDate" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                    <fieldset>
                                        <legend runat="server" meta:resourcekey="lbl_Data_Entry"></legend>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Site"></label>
                                                    <asp:Label ID="lblSiteName" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Officer"></label>
                                                    <asp:Label ID="lblEnteredByPersonName" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_Date"></label>
                                                    <asp:Label ID="lblEnteredDate" runat="server" CssClass="form-control"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                                <div class="modal-footer text-center">
                                    <button runat="server" type="submit" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" id="btnInvestigationsOK"></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <eidss:PageFooterUserControl runat="server" ID="ucPageFooter" />
    </form>
</body>
<script type="text/javascript">
    $(function () {
        $('.modal').modal({ show: false, backdrop: 'static' });
    });

    function hideModal(modalPopup) {
        var p = '#' + modalPopup;
        $(p).modal('hide');
    };

    function showModal(modalPopup) {
        var p = '#' + modalPopup;
        $(p).modal({ show: true, backdrop: 'static' });
    };
</script>
</html>
