<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchFarmUserControl.ascx.vb" Inherits="EIDSS.SearchFarmUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
    <asp:UpdatePanel ID="upSearchCriteria" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
            <asp:HiddenField ID="hdfSearchFarmType" runat="server" Value="" />
            <asp:HiddenField ID="hdfSearchCountryID" runat="server" Value="" />
            <asp:HiddenField ID="hdfSearchRegionID" runat="server" Value="" />
            <asp:HiddenField ID="hdfSearchRayonID" runat="server" Value="" />
            <asp:HiddenField ID="hdfSearchSettlementID" runat="server" Value="" />
            <div id="divFarmSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                <a href="#divFarmSearchCriteriaForm" data-toggle="collapse" style="height: 24px;" data-parent="#divFarmSearchUserControlCriteria" onclick="toggleFarmSearchCriteria(event);">
                                    <span id="toggleIcon" runat="server" role="button" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button"></span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div id="divFarmSearchCriteriaForm" class="panel-collapse collapse in">
                            <div class="form-group">
                                <p><%= GetLocalResourceObject("Page_Text_1") %></p>
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                        <label for="<% =txtEIDSSFarmID.ClientID %>"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                        <asp:TextBox ID="txtEIDSSFarmID" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                        <legend class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Type_Text") %></legend>
                                        <div class="form-check form-check-inline">
                                            <asp:CheckBoxList ID="cbxFarmTypeID" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="form-check-input formatRadioButtonList"></asp:CheckBoxList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <fieldset>
                                <legend><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_Text") %></legend>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="txtFarmOwnerLastName"><% =GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                            <asp:TextBox ID="txtFarmOwnerLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="txtFarmOwnerFirstName"><% =GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                            <asp:TextBox ID="txtFarmOwnerFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<% =txtEIDSSPersonID.ClientID %>"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_ID_Text") %></label>
                                            <asp:TextBox ID="txtEIDSSPersonID" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                        <label for="<% =txtFarmName.ClientID %>"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Name_Text") %></label>
                                        <asp:TextBox ID="txtFarmName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <eidss:LocationUserControl ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowSettlementType="true" ShowSettlement="true" />
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
            <asp:Button ID="btnCancelSearchCriteria" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchPerson" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnAddFarm" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="gvFarms" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvFarms" EventName="Sorting" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfSearchCount" runat="server" Value="0" />
        <div id="divFarmSearchResults" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <eidss:GridView ID="gvFarms" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="FarmMasterID" GridLines="None"
                            EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" SortExpression="EIDSSFarmID">
                                    <ItemTemplate>
                                        <asp:UpdatePanel ID="upSelectViewFarm" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="btnSelectFarm" EventName="Click" />
                                                <asp:AsyncPostBackTrigger ControlID="btnViewFarm" EventName="Click" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <asp:LinkButton ID="btnSelectFarm" runat="server" Text='<%# Eval("EIDSSFarmID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("FarmMasterID").ToString() + "," + Eval("EIDSSFarmID") + "," + Eval("FarmName") %>' CausesValidation="false"></asp:LinkButton>
                                                <asp:LinkButton ID="btnViewFarm" runat="server" Text='<%# Eval("EIDSSFarmID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("FarmMasterID").ToString() %>' CausesValidation="false"></asp:LinkButton>

                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <br />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="FarmTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Type_Text %>" SortExpression="FarmTypeName" />
                                <asp:BoundField DataField="FarmOwnerName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_Name_Text %>" SortExpression="FarmOwnerName" />
                                <asp:BoundField DataField="EIDSSFarmOwnerID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_ID_Text %>" SortExpression="EIDSSFarmOwnerID" />
                                <asp:BoundField DataField="FarmName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Name_Text %>" SortExpression="FarmName" />
                                <asp:BoundField DataField="RegionName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" SortExpression="RegionName" />
                                <asp:BoundField DataField="RayonName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" SortExpression="RayonName" />
                                <asp:BoundField DataField="SettlementName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Settlement_Text %>" SortExpression="SettlementName" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("FarmMasterID") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
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
            <asp:Button ID="btnAddFarm" runat="server" CssClass="btn btn-primary" meta:resourcekey="Btn_Add_Farm" CausesValidation="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<script type="text/javascript">
    function showFarmSubGrid(e, f) {
        var cl = e.target.className;
        if (cl == 'glyphicon glyphicon-triangle-bottom') {
            e.target.className = "glyphicon glyphicon-triangle-top";
            $('#' + f).show();
        }
        else {
            e.target.className = "glyphicon glyphicon-triangle-bottom";
            $('#' + f).hide();
        }
    }

    function toggleFarmSearchCriteria(e) {
        var cl = e.target.className;
        if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
            $('#<%= btnClear.ClientID %>').show();
            $('#<%= btnSearch.ClientID %>').show();
            $("#divFarmSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').hide();
            $('#<%= btnPrintSearchResults.ClientID %>').hide();
            $('#<%= btnAddFarm.ClientID %>').hide();
        }
        else {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button"
            $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divFarmSearchCriteriaForm").collapse('show');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddFarm.ClientID %>').show();
        }
    }

    function hideFarmSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
        $('#<%= btnClear.ClientID %>').hide();
        $('#<%= btnSearch.ClientID %>').hide();
        $("#divFarmSearchCriteriaForm").collapse('hide');
        $('#<%= btnCancelSearchResults.ClientID %>').show();
        $('#<%= btnPrintSearchResults.ClientID %>').show();
        $('#<%= btnAddFarm.ClientID %>').show();
    }

    function showFarmSearchCriteria() {
        $('#<%= btnCancelSearchCriteria.ClientID %>').show();
        $('#<%= btnClear.ClientID %>').show();
        $('#<%= btnSearch.ClientID %>').show();
        $("#divFarmSearchCriteriaForm").collapse('show');
        $('#<%= btnCancelSearchResults.ClientID %>').hide();
        $('#<%= btnPrintSearchResults.ClientID %>').hide();
        $('#<%= btnAddFarm.ClientID %>').hide();
    }
</script>
