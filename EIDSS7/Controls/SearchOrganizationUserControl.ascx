<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchOrganizationUserControl.ascx.vb" Inherits="EIDSS.SearchOrganizationUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:UpdatePanel ID="upSearchOrganization" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnAddOrganization" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="chkShowForeignOrganization" EventName="CheckedChanged" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfidfUserID" runat="server" />
        <asp:HiddenField ID="hdfidfInstitution" runat="server" />
        <asp:HiddenField ID="hdfRecordMode" runat="server" Value="" />
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <div id="divOrganizationSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="pull-right">
                                    <a href="#divOrganizationSearchCriteriaForm" data-toggle="collapse" data-parent="#divOrganizationSearchUserControlCriteria" onclick="toggleOrganizationSearchCriteria(event);">
                                        <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="divOrganizationSearchCriteriaForm" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label for="<% =txtOrganizationID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Organization_ID_Text") %></label>
                                        <asp:TextBox ID="txtOrganizationID" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label for="<% =txtOrganizationAbbreviatedName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Abbreviation_Text") %></label>
                                        <asp:TextBox ID="txtOrganizationAbbreviatedName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label for="<% =txtOrganizationFullName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Organization_Name_Text") %></label>
                                        <asp:TextBox ID="txtOrganizationFullName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<% =ddlAccessoryCode.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Accessory_Code_Text") %></label>
                                        <asp:DropDownList ID="ddlAccessoryCode" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<% =ddlOrganizationTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Organization_Type_Text") %></label>
                                        <asp:DropDownList ID="ddlOrganizationTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                        <asp:CheckBox ID="chkShowForeignOrganization" runat="server" CssClass="form-control" AutoPostBack="true" Text="<%$ Resources: Labels, Lbl_Show_Foreign_Organization_Text %>"></asp:CheckBox>
                                    </div>
                                </div>
                            </div>
                            <eidss:LocationUserControl ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowTownOrVillage="true" IsHorizontalLayout="true" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div id="divOrganizationSearchResults" runat="server" class="row embed-panel">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdgSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvOrganizations" EventName="Sorting" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvOrganizations" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped table-hover" DataKeyNames="OrganizationID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="false" UseAccessibleHeader="true" PagerSettings-Visible="false">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Organization_ID_Text %>" SortExpression="OrganizationEIDSSID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOrganizationEIDSSID" runat="server" Text='<%# Eval("OrganizationEIDSSID") %>' Visible='<%# IIf(hdfRecordMode.Value = "9", True, False) %>'></asp:Label>
                                                <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("OrganizationEIDSSID") %>' Visible='<%# IIf(hdfRecordMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("OrganizationID").ToString() + "," + Eval("OrganizationEIDSSID") + "," + Eval("OrganizationFullName").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("OrganizationEIDSSID") %>' Visible='<%# IIf(hdfRecordMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("OrganizationID").ToString() + "," + Eval("OrganizationEIDSSID") + "," + Eval("OrganizationFullName").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="OrganizationAbbreviatedName" HeaderText="<%$ Resources: Labels, Lbl_Abbreviation_Text %>" SortExpression="OrganizationAbbreviatedName" />
                                        <asp:BoundField DataField="OrganizationFullName" HeaderText="<%$ Resources: Labels, Lbl_Organization_Name_Text %>" SortExpression="OrganizationFullName" />
                                        <asp:BoundField DataField="AddressString" HeaderText="<%$ Resources: Labels, Lbl_Organization_Address_Text %>" SortExpression="AddressString" />
                                        <asp:BoundField DataField="OrderNumber" HeaderText="<%$ Resources: Grd_Organization_List_Order_Heading %>" SortExpression="OrderNumber" />
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("OrganizationID") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
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
        <div class="modal-footer text-center" style="padding-left: 0px; padding-right: 0px;">
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchOrganization" />
            <asp:Button ID="btnAddOrganization" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
        </div>
        <script type="text/javascript">
            function toggleOrganizationSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $('#divOrganizationSearchCriteriaForm').collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $('#divOrganizationSearchCriteriaForm').collapse('show');
                }
            }

            function hideOrganizationSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $('#divOrganizationSearchCriteriaForm').collapse('hide');
            }

            function showOrganizationSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $('#divOrganizationSearchCriteriaForm').collapse('show');
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
