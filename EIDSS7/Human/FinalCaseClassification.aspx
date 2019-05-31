<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="FinalCaseClassification.aspx.vb" Inherits="EIDSS.FinalCaseClassification" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="page-heading">
        <h2>Human Case Classification</h2>
    </div>
    <!-- This is the "REQUIRED ONLY ALERT at top of panels -->
    <div class="form-group">
        <div class="glyphicon glyphicon-asterisk text-danger"></div>
        <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="sectionContainer">
                    <section id="FinalClassClassificationSection" runat="server" class="hidden">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-9">
                                        <h3 class="heading"><%= GetGlobalResourceObject("Tabs", "Tab_Final_Case_Classification_Text") %></h3>
                                    </div>
                                    <div class="col-md-3 heading text-right">
                                        <a role="button" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                    <asp:Label 
                                        AssociatedControlID="ddlFinalCaseClassification" 
                                        ID="lblFinalCaseClassification" 
                                        runat="server" 
                                        Text="<%$ Resources:Tabs, Tab_Final_Case_Classification_Text %>"
                                        ToolTip="<%$ Resources, Tabs, Tab_Final_Case_Classification_ToolTip %>"></asp:Label>
                                    <asp:DropDownList ID="ddlFinalCaseClassification" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" ID="lblDateofFinalClassification" AssociatedControlID="txtDateofFinalClassification" Text="<%$ Resources:lblDateofFinalClassification %>"></asp:Label>
                                    <eidss:CalendarInput ID="txtDateofFinalClassification" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" ID="lblBasisofDiagnosis" Text="<%$ Resources:lblBasisofDiagnosis %>" AssociatedControlID="cblBasisofDiagnosis"></asp:Label>
                                    <asp:CheckBoxList ID="cblBasisofDiagnosis" runat="server" RepeatDirection="Vertical" AppendDataBoundItems="true"></asp:CheckBoxList>
                                </div>
                            </div>
                        </div>
                    </section>
                    <section id="FinalOutcomeSection" runat="server" class="hidden">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-9">
                                        <h3 class="heading"><%= GetGlobalResourceObject("Tabs", "Tab_Final_Outcome_Text") %></h3>
                                    </div>
                                    <div class="col-md-3 heading text-right">
                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <asp:Label runat="server" ID="lblOutcome" AssociatedControlID="ddlOutcome" Text="<%$ Resources:lblOutcome %>"></asp:Label>
                                    <asp:DropDownList ID="ddlOutcome" runat="server" CssClass="form-control" AppendDataBoundItems="false"></asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <asp:Label runat="server" ID="lblDateofDischarge" AssociatedControlID="txtDateofDischarge" Text="<%$ Resources:lblDateofDischarge %>"></asp:Label>
                                            <eidss:CalendarInput ID="txtDateofDischarge" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:Label runat="server" ID="lblDateofDeath" AssociatedControlID="txtDateofDeath" Text="<%$ Resources:lblDateofDeath %>"></asp:Label>
                                            <eidss:CalendarInput ID="txtDateofDeath" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" Text="<%$ Resources:lblOutbreakID %>" AssociatedControlID="ddlOutbreakID"></asp:Label>
                                    <asp:DropDownList ID="ddlOutbreakID" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" Text="<%$ Resources:Labels, LblCommentsText %>" AssociatedControlID="txtComments"></asp:Label>
                                    <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" Text="<%$ Resources:lblEpidemiologistsName %>" AssociatedControlID="ddlEpidemiologistsName"></asp:Label>
                                    <asp:DropDownList ID="ddlEpidemiologistsName" runat="server" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                            <MenuItems>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="" 
                                    Href="UrgentNotification.aspx"
                                    ID="sideBarItemUrgentNotification" 
                                    IsActive="false" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Urgent_Notification"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="" 
                                    Href="CaseInvestigation.aspx"
                                    ID="sideBarItemCaseInvestigation" 
                                    IsActive="false" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Case_Investigation"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="" 
                                    Href=""
                                    ID="sideBarItemCaseOutcome" 
                                    IsActive="false" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Case_Outcome"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="0" 
                                    ID="sideBarItemFinalCaseClassification" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Final_Case_Classification"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="1" 
                                    ID="sideBarItemFinalOutcome" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Final_Outcome"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-file" 
                                    GoToTab="2" 
                                    ID="sideBarItemReview" 
                                    IsActive="true" 
                                    ItemStatus="IsReview" 
                                    meta:resourcekey="Tab_Review"
                                    runat="server"></eidss:SideBarItem>
                            </MenuItems>
                        </eidss:SideBarNavigation>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <input  
                            class="btn btn-default" 
                            id="btnCancel" 
                            onclick="location.replace('Dashboard.aspx')"
                            value="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %>" 
                            type="button" />
                    <input type="button" id="btnPreviousSection" value="<%= GetGlobalResourceObject("Buttons", "Btn_Back_Text") %>" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                    <input type="button" id="btnNextSection" value="<%= GetGlobalResourceObject("Buttons", "Btn_Next_Text") %>" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                    <asp:Button runat="server" Text="<%$ Resources:Buttons, Btn_Save_Text %>" ID="btnSave" CssClass="btn btn-primary" ToolTip="<%$Resources:Buttons, Btn_Save_ToolTip %>"/>
                    <asp:Button runat="server" Text="<%$ Resources:Buttons, Btn_Submit_Text %>" ID="btnSubmit" CssClass="btn btn-primary hidden" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />

    
    <script type="text/javascript">
        $(document).ready(function () {
            setViewOnPageLoad("<% =hdnPanelController.ClientID %>");

        });
    </script>
</asp:Content>
