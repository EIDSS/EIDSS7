<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchHumanSessionUserControl.ascx.vb" Inherits="EIDSS.SearchHumanSessionUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:UpdatePanel ID="upSearchHumanMonitoringSession" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
        <asp:HiddenField ID="hdfidfUserID" runat="server" />
        <asp:HiddenField ID="hdfidfInstitution" runat="server" />
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <div id="divHumanMonitoringSessionSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="pull-right">
                                    <a href="#divHumanMonitoringSessionSearchCriteriaForm" data-toggle="collapse" data-parent="#divHumanMonitoringSessionSearchUserControlCriteria" onclick="toggleHumanMonitoringSessionSearchCriteria(event);">
                                        <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="divHumanMonitoringSessionSearchCriteriaForm" class="panel-collapse collapse in">
                        <p runat="server" meta:resourcekey="Lbl_Search_Instructions"></p>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <label for="<% =txtEIDSSSessionID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                    <asp:TextBox ID="txtEIDSSSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                    <label runat="server" meta:resourcekey="Lbl_Or"></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                    <label for="<% =txtEIDSSCampaignID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_ID_Text") %></label>
                                    <div class="input-group">
                                        <div class="input-group-btn">
                                            <button class="btn" runat="server" id="btnSearchforCampaignID" type="submit" meta:resourcekey="btn_Search_Campaign">
                                                <span class="glyphicon glyphicon-search"></span>
                                            </button>
                                        </div>
                                        <asp:TextBox ID="txtEIDSSCampaignID" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Session_Status">
                                    <label for="<% =ddlStatusTypeID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                    <asp:DropDownList ID="ddlStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Session_Disease">
                                    <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <fieldset runat="server" meta:resourcekey="Dis_Search_Date_Range">
                            <legend><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_Range_Text") %></legend>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtDateEnteredFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_From_Text") %></label>
                                        <eidss:CalendarInput ID="txtDateEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" LinkedPickerID="txtDateEnteredTo"></eidss:CalendarInput>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtDateEnteredTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_To_Text") %></label>
                                        <eidss:CalendarInput ID="txtDateEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                        <asp:CompareValidator ID="Val_Entered_Date_Compare" runat="server" CssClass="text-danger" ControlToCompare="txtDateEnteredTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtDateEnteredFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Entered_Date_Compare" ValidationGroup="HMSSearch"></asp:CompareValidator>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                        <eidss:Location ID="ucLocation" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowTownOrVillage="false" ShowStreet="false" ShowPostalCode="false" ShowCoordinates="false" ShowElevation="false" ShowBuildingHouseApartmentGroup="false" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div id="divHumanSessionSearchResults" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:UpdatePanel ID="upSearchResults" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvHumanSessions" EventName="RowCommand" />
                            <asp:AsyncPostBackTrigger ControlID="gvHumanSessions" EventName="Sorting" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvHumanSessions" runat="server" AllowPaging="true" AllowSorting="true" PageSize="10" AutoGenerateColumns="false" CssClass="table table-striped table-hover" GridLines="None" RowStyle-CssClass="table" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="True" DataKeyNames="HumanMonitoringSessionID" UseAccessibleHeader="true" PagerSettings-Visible="false">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Session_ID_Text %>" SortExpression="EIDSSSessionID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEIDSSSessionID" runat="server" Text='<%# Eval("EIDSSSessionID") %>'></asp:Label>
                                                <asp:LinkButton ID="btnSelect" runat="server" CausesValidation="False" CommandName="Select" meta:resourceKey="Btn_Select" CommandArgument='<%# Eval("HumanMonitoringSessionID").ToString() + "," + Eval("EIDSSSessionID") + "," + Eval("DiseaseID").ToString() %>' Text='<%# Eval("EIDSSSessionID") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="StatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Session_Status_Text %>" SortExpression="StatusTypeName" />
                                        <asp:BoundField DataField="EnteredDate" DataFormatString="{0:MM/dd/yyyy}" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Date_Entered_Text %>" SortExpression="EnteredDate" />
                                        <asp:BoundField DataField="RegionName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" SortExpression="RegionName" />
                                        <asp:BoundField DataField="RayonName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" SortExpression="RayonName" />
                                        <asp:BoundField DataField="DiseaseName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" SortExpression="DiseaseName" />
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<%# Eval("HumanMonitoringSessionID") %>' OnDataBinding="GridViewSelection_OnDataBinding">
                                                    <span class="glyphicon glyphicon-edit"></span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <span class="glyphicon glyphicon-triangle-bottom" onclick="showHumanMonitoringSessionSubGrid(event,'divHumanSession<%#Eval("HumanMonitoringSessionID") %>');"></span>
                                                <tr id="divHumanSession<%# Eval("HumanMonitoringSessionID") %>" style="display: none;">
                                                    <td colspan="6" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                        <div>
                                                            <div class="form-group form-group-sm">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="Lbl_Start_Date"></label>
                                                                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control input-sm" Text='<%# String.Format("{0:MM/dd/yyyy}", Eval("StartDate")) %>' Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="Lbl_End_Date"></label>
                                                                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control input-sm" Text='<%# String.Format("{0:MM/dd/yyyy}", Eval("EndDate")) %>' Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-group form-group-sm">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="Lbl_Site"></label>
                                                                        <asp:TextBox ID="txtSiteName" runat="server" CssClass="form-control input-sm" Text='<%# Eval("SiteName") %>' Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="Lbl_Officer"></label>
                                                                        <asp:TextBox ID="txtPersonEnteredByName" runat="server" CssClass="form-control input-sm" Text='<%# Eval("PersonEnteredByName") %>' Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-group form-group-sm">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="Lbl_Town"></label>
                                                                        <asp:TextBox ID="txtSettlementName" runat="server" CssClass="form-control input-sm" Text='<%# Eval("SettlementName") %>' Enabled="false"></asp:TextBox>
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
                            </div>
                            <div class="row">
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
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
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <div class="modal-footer text-center">
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="HMSSearch" />
            <asp:Button ID="btnAddHumanSession" runat="server" CssClass="btn btn-default" meta:resourceKey="Btn_Add_Session" />
        </div>
        <script type="text/javascript">
            function showHumanMonitoringSessionSubGrid(e, f) {
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

            function toggleHumanMonitoringSessionSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $('#divHumanMonitoringSessionSearchCriteriaForm').collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $('#divHumanMonitoringSessionSearchCriteriaForm').collapse('show');
                }
            }

            function hideHumanMonitoringSessionSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                $('#divHumanMonitoringSessionSearchCriteriaForm').collapse('hide');
            }

            function showHumanMonitoringSessionSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                $('#divHumanMonitoringSessionSearchCriteriaForm').collapse('show');
            }

            function focusSearch() {
                var search = document.getElementById("<% = divHumanMonitoringSessionSearchUserControlCriteria.ClientID %>");
                    if (search != undefined && <%= (Not Page.IsPostBack).ToString().ToLower() %>)
                        $('#<%= txtEIDSSSessionID.ClientID %>').focus();
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
