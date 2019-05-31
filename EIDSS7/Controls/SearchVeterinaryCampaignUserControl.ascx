<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchVeterinaryCampaignUserControl.ascx.vb" Inherits="EIDSS.SearchVeterinaryCampaignUserControl" %>

<asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
    <asp:UpdatePanel ID="upSearchCriteria" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnCancelSearchCriteria" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
            <div id="divVeterinaryCampaignSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                <a href="#divVeterinaryCampaignSearchCriteriaForm" data-toggle="collapse" style="height: 24px;" data-parent="#divVeterinaryCampaignSearchUserControlCriteria" onclick="toggleVeterinaryCampaignSearchCriteria(event);">
                                    <span id="toggleIcon" runat="server" role="button" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div id="divVeterinaryCampaignSearchCriteriaForm" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <p><%= GetLocalResourceObject("Lbl_Search_Instructions") %></p>
                            <div class="form-group">
                                <div class="row vertical-align-middle">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Campaign_ID" runat="server">
                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Campaign_ID" runat="server"></span>
                                        <label for="txtSearchEIDSSCampaignID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_ID_Number_Text") %></label>
                                        <asp:TextBox CssClass="form-control" ID="txtSearchEIDSSCampaignID" runat="server" AutoPostBack="true"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtSearchEIDSSCampaignID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Campaign_ID" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Or_Text") %></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Campaign_Name" runat="server">
                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Campaign_Name" runat="server"></span>
                                        <label for="txtSearchCampaignName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Name_Text") %></label>
                                        <asp:TextBox CssClass="form-control" ID="txtSearchCampaignName" runat="server" AutoPostBack="true"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtSearchCampaignName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Campaign_Name" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Campaign_Type" runat="server">
                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Campaign_Type" runat="server"></span>
                                        <label for="ddlSearchCampaignTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Type_Text") %></label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlSearchCampaignTypeID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlSearchCampaignTypeID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Campaign_Type" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Campaign_Status" runat="server">
                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Campaign_Status" runat="server"></div>
                                        <label for="ddlSearchCampaignStatusTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Status_Text") %></label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlSearchCampaignStatusTypeID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlSearchCampaignStatusTypeID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Campaign_Status" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row vertical-align-middle">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Disease" runat="server">
                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Disease" runat="server"></span>
                                        <label for="ddlSearchDiseaseID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlSearchDiseaseID" runat="server"></eidss:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlSearchDiseaseID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Disease" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <fieldset class="form-group">
                                <legend><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Start_Date_Range_Text") %></legend>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Start_Date_From" runat="server">
                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Start_Date_From" runat="server"></span>
                                            <label for="txtSearchStartDateFrom" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_From_Text") %></label>
                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtSearchStartDateFrom" runat="server"></eidss:CalendarInput>
                                            <asp:RequiredFieldValidator ControlToValidate="txtSearchStartDateFrom" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Start_Date_From" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Search_Start_Date_To" runat="server">
                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Search_Start_Date_To" runat="server"></span>
                                            <label for="txtSearchStartDateTo" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_To_Text") %></label>
                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtSearchStartDateTo" runat="server"></eidss:CalendarInput>
                                            <asp:RequiredFieldValidator ControlToValidate="txtSearchStartDateTo" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Search_Start_Date_To" runat="server" ValidationGroup="SearchCampaign"></asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="cpvStartDate" runat="server" ControlToValidate="txtSearchStartDateTo" ControlToCompare="txtSearchStartDateFrom" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Search_Start_Date_To_Range" CultureInvariantValues="true" ValidationGroup="SearchCampaign" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
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
            <asp:Button ID="btnCancelSearchCriteria" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showModalHandler('#divCancelSearchWarningModal');" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchCampaign" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnAddCampaign" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="gvCampaigns" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvCampaigns" EventName="Sorting" />
    </Triggers>
    <ContentTemplate>
        <div id="divVeterinaryCampaignSearchResults" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:HiddenField ID="hdfSearchCount" runat="server" Value="0" />
                    <div class="table-responsive">
                        <eidss:GridView ID="gvCampaigns" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped"
                            DataKeyNames="CampaignID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="true" ShowHeaderWhenEmpty="true"
                            ShowHeader="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                            <Columns>
                                <asp:TemplateField AccessibleHeaderText="<%$ Resources: Labels, Lbl_Campaign_ID_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Campaign_ID_Text %>" SortExpression="EIDSSCampaignID">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnSelectRecordData" runat="server" Text='<%# Eval("EIDSSCampaignID") %>' Visible='<%# IIf(hdfSelectMode.Value = "11", True, False) %>' CommandName="Select Record" CommandArgument='<% #Eval("CampaignID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                        <asp:LinkButton ID="btnEIDSSCampaignID" runat="server" Text='<%# Eval("EIDSSCampaignID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Bind("CampaignID") %>' CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CampaignName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Campaign_Name_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Campaign_Name_Text %>" SortExpression="CampaignName" />
                                <asp:BoundField DataField="CampaignTypeName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Campaign_Type_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Campaign_Type_Text %>" SortExpression="CampaignTypeName" />
                                <asp:BoundField DataField="CampaignStatusTypeName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Campaign_Status_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Campaign_Status_Text %>" SortExpression="CampaignStatusTypeName" />
                                <asp:BoundField DataField="CampaignStartDate" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Start_Date_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Start_Date_Text %>" SortExpression="CampaignStartDate" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="DiseaseName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" SortExpression="DiseaseName" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEditCampaign" runat="server" CommandName="Edit" CommandArgument='<%# Bind("CampaignID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <span class="glyphicon glyphicon-triangle-bottom" onclick="showCampaignSubGrid(event, 'divVASC<%# Eval("CampaignID") %>');"></span>
                                        <tr id="divVASC<%# Eval("CampaignID") %>" style="display: none;">
                                            <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                <div class="expand-grid-row">
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label id="lblCampaignEndDate" for="txtSearchCampaignEndDate" class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_End_Date_Text") %></label>
                                                                <asp:TextBox ID="txtSearchCampaignEndDate" CssClass="form-control input-sm" runat="server" Enabled="false" Text='<%# Bind("CampaignEndDate", "{0:d}") %>' />
                                                            </div>
                                                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                <label id="lblCampaignAdministrator" for="txtSearchCampaignAdministrator" class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Administrator_Text") %></label>
                                                                <asp:TextBox ID="txtSearchCampaignAdministrator" CssClass="form-control input-sm" runat="server" Enabled="false" Text='<%# Bind("CampaignAdministrator") %>' />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                <label id="lblSpeciesTypeList" for="txtSpeciesTypeList" class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                                <asp:TextBox ID="txtSpeciesTypeList" CssClass="form-control input-sm" runat="server" Enabled="false" Text='<%# Bind("SpeciesList") %>' />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                <label id="lblSampleTypeList" for="txtSampleTypeList" class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                                                <asp:TextBox ID="txtSampleTypeList" CssClass="form-control input-sm" runat="server" Enabled="false" Text='<%# Bind("SampleTypesList") %>' />
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
                        <div id="divCampaignsPager" class="row grid-footer" runat="server">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                <asp:Label ID="lblCampaignsRecordCount" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblCampaignsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                <asp:Repeater ID="rptCampaignsPager" runat="server">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%# Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="CampaignsPage_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                <asp:Button ID="btnCancelSearchResults" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnPrintSearchResults" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Print_Text %>" CausesValidation="false" />
                                <asp:Button ID="btnAddCampaign" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Add_Text %>" meta:resourcekey="Btn_Add_Campaign" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<script>
    function toggleVeterinaryCampaignSearchCriteria(e) {
        var cl = e.target.className;
        if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
            $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $("#divCampaignSearchCriteriaForm").collapse('hide');
                $('#<%= btnCancelSearchResults.ClientID %>').hide();
                $('#<%= btnPrintSearchResults.ClientID %>').hide();
                $('#<%= btnAddCampaign.ClientID %>').hide();
            }
            else {
                e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button"
                $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $("#divVeterinaryCampaignSearchCriteriaForm").collapse('show');
                $('#<%= btnCancelSearchResults.ClientID %>').show();
                $('#<%= btnPrintSearchResults.ClientID %>').show();
                $('#<%= btnAddCampaign.ClientID %>').show();
        }
    }

    function hideVeterinaryCampaignSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divVeterinaryCampaignSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddCampaign.ClientID %>').show();
    }

    function hideVeterinaryCampaignSearchCriteriaCloseWarningModal() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divVeterinaryCampaignSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddCampaign.ClientID %>').show();
        $('#divWarningModal').modal('hide');
    }

    function showVeterinaryCampaignSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').show();
            $('#<%= btnClear.ClientID %>').show();
            $('#<%= btnSearch.ClientID %>').show();
            $("#divVeterinaryCampaignSearchCriteriaForm").collapse('show');
            $('#<%= btnCancelSearchResults.ClientID %>').hide();
            $('#<%= btnPrintSearchResults.ClientID %>').hide();
            $('#<%= btnAddCampaign.ClientID %>').hide();
    }
</script>
