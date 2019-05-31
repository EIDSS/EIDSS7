<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchVeterinarySessionUserControl.ascx.vb" Inherits="EIDSS.SearchVeterinarySessionUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
    <asp:UpdatePanel ID="upSearchCriteria" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnCancelSearchCriteria" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
            <asp:HiddenField ID="hdfCampaignModule" runat="server" Value="Vet" />
            <asp:HiddenField ID="hdfSessionCategoryID" runat="server" Value="10169002" />
            <div id="divVeterinaryMonitoringSessionSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="pull-right">
                                    <a href="#divVeterinaryMonitoringSessionSearchCriteriaForm" data-toggle="collapse" style="height: 24px;" data-parent="#divVeterinaryMonitoringSessionSearchCriteria" onclick="toggleVeterinaryMonitoringSessionSearchCriteria(event);">
                                        <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button"></span>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="divVeterinaryMonitoringSessionSearchCriteriaForm" class="panel-collapse collapse in">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Session_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_ID" runat="server"></div>
                                    <label for="<% =txtEIDSSSessionID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                    <asp:TextBox CssClass="form-control" ID="txtEIDSSSessionID" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSSessionID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_ID" runat="server" ValidationGroup="VMSSearch"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Session_Status" runat="server">
                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_Status" runat="server"></div>
                                    <label for="<% =ddlStatusTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                    <asp:DropDownList CssClass="form-control" ID="ddlStatusTypeID" runat="server"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlStatusTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Session_Status" runat="server" ValidationGroup="VMSSearch"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Disease" runat="server">
                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Disease" runat="server"></div>
                                    <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                    <asp:DropDownList CssClass="form-control" ID="ddlDiseaseID" runat="server"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlDiseaseID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Disease" runat="server" ValidationGroup="VMSSearch"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <eidss:Location ID="ucLocation" runat="server" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowCountry="false" ShowPostalCode="false" ShowStreet="false" ShowTownOrVillage="false" IsHorizontalLayout="true" />
                        <fieldset>
                            <legend><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_Range_Text") %></legend>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6" meta:resourcekey="Dis_Date_Entered_From" runat="server">
                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date_Entered_From" runat="server"></div>
                                        <label for="<% =txtDateEnteredFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_From_Text") %></label>
                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtDateEnteredFrom" runat="server"></eidss:CalendarInput>
                                        <asp:RequiredFieldValidator ControlToValidate="txtDateEnteredFrom" Display="Dynamic" meta:resourcekey="Val_Date_Entered_From" runat="server" ValidationGroup="VMSSearch"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6" meta:resourcekey="Dis_Date_Entered_To" runat="server">
                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date_Entered_To" runat="server"></div>
                                        <label for="<% =txtDateEnteredTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_To_Text") %></label>
                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtDateEnteredTo" runat="server"></eidss:CalendarInput>
                                        <asp:RequiredFieldValidator ControlToValidate="txtDateEnteredTo" Display="Dynamic" meta:resourcekey="Val_Date_Entered_To" runat="server" ValidationGroup="VMSSearch"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
<div class="modal-footer text-center">
    <asp:UpdatePanel ID="upSearchCriteriaCommands" runat="server" UpdateMode="Conditional" RenderMode="Inline">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnCancelSearchCriteria" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:Button ID="btnCancelSearchCriteria" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="VMSSearch" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnAddSession" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="gvVeterinaryMonitoringSessions" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvVeterinaryMonitoringSessions" EventName="Sorting" />
    </Triggers>
    <ContentTemplate>
        <div id="divVeterinaryMonitoringSessionSearchResults" runat="server" class="row embed-panel">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdgSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <asp:HiddenField ID="hdfSearchCount" runat="server" Value="0" />
                        <eidss:GridView ID="gvVeterinaryMonitoringSessions" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="VeterinaryMonitoringSessionID"
                            EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" GridLines="None" runat="server" ShowFooter="true" ShowHeaderWhenEmpty="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Session_ID_Text %>" SortExpression="EIDSSSessionID">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnSelectRecordData" runat="server" Text='<%# Eval("EIDSSSessionID") %>' Visible='<%# IIf(hdfSelectMode.Value = "11", True, False) %>' CommandName="Select Record" CommandArgument='<% #Eval("VeterinaryMonitoringSessionID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                        <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSSessionID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<% #Eval("VeterinaryMonitoringSessionID").ToString() + "," + Eval("EIDSSSessionID") + "," + Eval("DiseaseID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                        <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("EIDSSSessionID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<% #Eval("VeterinaryMonitoringSessionID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="SessionStatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Session_Status_Text %>" SortExpression="SessionStatusTypeName" />
                                <asp:BoundField DataField="EnteredDate" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Date_Entered_Text %>" SortExpression="EnteredDate" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="RegionName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" SortExpression="RegionName" />
                                <asp:BoundField DataField="RayonName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" SortExpression="RayonName" />
                                <asp:BoundField DataField="DiseaseName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" SortExpression="DiseaseName" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:UpdatePanel ID="upEdit" runat="server">
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="btnEdit" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("VeterinaryMonitoringSessionID") %>' OnDataBinding="GridViewSelection_OnDataBinding">
                                                            <span class="glyphicon glyphicon-edit"></span>
                                                </asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <span class="glyphicon glyphicon-triangle-bottom" onclick="showVeterinaryMonitoringSessionSubGrid(event,'divVMS<%# Eval("VeterinaryMonitoringSessionID") %>');"></span>
                                        <tr id="divVMS<%# Eval("VeterinaryMonitoringSessionID") %>" style="display: none;">
                                            <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                <div class="expand-grid-row">
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                <asp:Label ID="lblSessionStartDate" runat="server" AssociatedControlID="txtSessionStartDate" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Session_Start_Date_Text %>"></asp:Label>
                                                                <asp:TextBox CssClass="form-control" ID="txtSessionStartDate" runat="server" Text='<%# Bind("StartDate", "{0:d}") %>' Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                <asp:Label ID="lblSessionEndDate" runat="server" AssociatedControlID="txtSessionEndDate" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Session_End_Date_Text %>"></asp:Label>
                                                                <asp:TextBox CssClass="form-control" ID="txtSessionEndDate" runat="server" Text='<%# Bind("EndDate", "{0:d}") %>' Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                <asp:Label ID="lblOrganizationName" runat="server" AssociatedControlID="txtOrganizationName" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Site_Text %>"></asp:Label>
                                                                <asp:TextBox CssClass="form-control" ID="txtOrganizationName" runat="server" Text='<%# Bind("OrganizationName") %>' Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                <asp:Label ID="lblPersonEnteredByName" runat="server" AssociatedControlID="txtPersonEnteredByName" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Officer_Text %>"></asp:Label>
                                                                <asp:TextBox CssClass="form-control" ID="txtPersonEnteredByName" runat="server" Text='<%# Bind("EnteredByPersonName") %>' Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                <asp:Label ID="lblSettlementName" runat="server" AssociatedControlID="txtSettlementName" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Settlement_Text %>"></asp:Label>
                                                                <asp:TextBox CssClass="form-control" ID="txtSettlementName" runat="server" Text='<%# Bind("SettlementName") %>' Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </eidss:GridView>
                        <div id="divPager" class="row grid-footer" runat="server">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                <asp:Label ID="lblRecordCount" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblPageNumber" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                <asp:Repeater ID="rptPager" runat="server">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<div class="modal-footer text-center">
    <asp:UpdatePanel ID="upSearchResultsCommands" runat="server" UpdateMode="Conditional" RenderMode="Inline">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnCancelSearchResults" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:Button ID="btnCancelSearchResults" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnPrintSearchResults" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Print_Text %>" CausesValidation="false" />
            <asp:Button ID="btnAddSession" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<script type="text/javascript">
    function showVeterinaryMonitoringSessionSubGrid(e, f) {
        var cl = e.target.className;
        if (cl == 'glyphicon glyphicon-triangle-bottom') {
            e.target.className = "glyphicon glyphicon-triangle-top";
            $('#' + f).show();
        }
        else {
            e.target.className = "glyphicon glyphicon-triangle-bottom";
            $('#' + f).hide();
        }
    };

    function toggleVeterinaryMonitoringSessionSearchCriteria(e) {
        var cl = e.target.className;
        if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
            $('#<%= btnClear.ClientID %>').show();
            $('#<%= btnSearch.ClientID %>').show();
            $("#divVeterinaryMonitoringSessionSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').hide();
            $('#<%= btnPrintSearchResults.ClientID %>').hide();
            $('#<%= btnAddSession.ClientID %>').hide();
        }
        else {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button"
            $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divVeterinaryMonitoringSessionSearchCriteriaForm").collapse('show');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddSession.ClientID %>').show();
        }
    }

    function hideVeterinaryMonitoringSessionSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
        $('#<%= btnClear.ClientID %>').hide();
        $('#<%= btnSearch.ClientID %>').hide();
        $("#divVeterinaryMonitoringSessionSearchCriteriaForm").collapse('hide');
        $('#<%= btnCancelSearchResults.ClientID %>').show();
        $('#<%= btnPrintSearchResults.ClientID %>').show();
        $('#<%= btnAddSession.ClientID %>').show();
    }

    function showVeterinaryMonitoringSessionSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').show();
        $('#<%= btnClear.ClientID %>').show();
        $('#<%= btnSearch.ClientID %>').show();
        $("#divVeterinaryMonitoringSessionSearchCriteriaForm").collapse('show');
        $('#<%= btnCancelSearchResults.ClientID %>').hide();
        $('#<%= btnPrintSearchResults.ClientID %>').hide();
        $('#<%= btnAddSession.ClientID %>').hide();
    }

    function focusSearch() {
        var search = document.getElementById("<% = divVeterinaryMonitoringSessionSearchUserControlCriteria.ClientID %>");
        if (search != undefined && <%= (Not Page.IsPostBack).ToString().ToLower() %>)
            $('#<%= txtEIDSSSessionID.ClientID %>').focus();
    }
</script>
