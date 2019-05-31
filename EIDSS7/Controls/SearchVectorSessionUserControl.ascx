<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchVectorSessionUserControl.ascx.vb" Inherits="EIDSS.SearchVectorSessionUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:UpdatePanel ID="upSearchVectorSurveillanceSession" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="ddlVectorTypeID" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="ddlSessionStatusTypeID" EventName="SelectedIndexChanged" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfSelectMode" runat="server" Value="0" />
        <asp:HiddenField ID="hdfidfUserID" runat="server" />
        <asp:HiddenField ID="hdfidfInstitution" runat="server" />
        <asp:HiddenField ID="hdfSearchDataEntrySite" runat="server" Value="NULL" />
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <div id="divVectorSessionSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="pull-right">
                                    <a href="#divVectorSessionSearchCriteriaForm" data-toggle="collapse" data-parent="#divVectorSessionSearchUserControlCriteria" onclick="toggleVectorSessionSearchCriteria(event);">
                                        <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="divVectorSessionSearchCriteriaForm" class="panel-collapse collapse in">
                        <p runat="server" meta:resourcekey="lbl_Search_Instructions"></p>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <label for="<%= txtVectorSessionID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                    <asp:TextBox ID="txtVectorSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <label for="<%= txtFieldSessionID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Field_Session_ID_Text") %></label>
                                    <asp:TextBox ID="txtFieldSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <label for="<%= ddlSessionStatusTypeID.ClientID  %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                    <asp:DropDownList ID="ddlSessionStatusTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <fieldset id="startDate" runat="server">
                            <legend><% =GetGlobalResourceObject("Labels", "Lbl_Start_Date_Range_Text") %></legend>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtStartDateFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Start_Date_From_Text") %></label>
                                        <eidss:CalendarInput ID="txtStartDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtStartDateTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Start_Date_To_Text") %></label>
                                        <eidss:CalendarInput ID="txtStartDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    </div>
                                </div>
                                <asp:CompareValidator ID="cpvStartDate" runat="server" ControlToValidate="txtStartDateTo" ControlToCompare="txtStartDateFrom" CssClass="text-danger" meta:resourceKey="Val_StartDate" CultureInvariantValues="true" ValidationGroup="VSSSearch" Type="Date" Operator="GreaterThan"></asp:CompareValidator>
                            </div>
                        </fieldset>
                        <fieldset id="closeDate" runat="server">
                            <legend><% =GetGlobalResourceObject("Labels", "Lbl_Close_Date_Range_Text") %></legend>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtCloseDateFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Close_Date_From_Text") %></label>
                                        <eidss:CalendarInput ID="txtCloseDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                        <label for="<% =txtCloseDateTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Close_Date_To_Text") %></label>
                                        <eidss:CalendarInput ID="txtCloseDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    </div>
                                </div>
                                <asp:CompareValidator ID="cpvCloseDate" runat="server" ControlToValidate="txtCloseDateTo" ControlToCompare="txtCloseDateFrom" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_CloseDate" CultureInvariantValues="true" ValidationGroup="VSSSearch" Type="Date" Operator="GreaterThan"></asp:CompareValidator>
                            </div>
                        </fieldset>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-3 col-xs-12">
                                    <label for="<% =ddlVectorTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Vector_Type_Text") %></label>
                                    <asp:DropDownList ID="ddlVectorTypeID" runat="server" AutoPostBack="True" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                    <label for="<% =ddlSpeciesTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                    <asp:DropDownList ID="ddlSpeciesTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                    <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <eidss:LocationUserControl ID="ucLocation" runat="server" ShowPostalCode="false" IsHorizontalLayout="true" ShowStreet="false" ShowCoordinates="false" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowApartment="false" ShowBuilding="true" ShowHouse="false" ShowMap="false" ShowTownOrVillage="true" ShowRayon="true" ShowRegion="true" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div id="divVectorSessionSearchResults" runat="server" class="row embed-panel">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:UpdatePanel ID="upSearchResults" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvVectorSessions" EventName="Sorting" />
                            <asp:AsyncPostBackTrigger ControlID="gvVectorSessions" EventName="RowCommand" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvVectorSessions" runat="server" AllowPaging="true" AllowSorting="true" PageSize="10" AutoGenerateColumns="false" CssClass="table table-striped table-hover" GridLines="None" RowStyle-CssClass="table" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="True" DataKeyNames="VectorSurveillanceSessionID,StatusTypeID,Vectors" PagerSettings-Visible="false">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Session_ID_Text %>" SortExpression="EIDSSSessionID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVectorSessionID" runat="server" Text='<%# Eval("EIDSSSessionID") %>' Visible='<%# IIf(hdfSelectMode.Value = "9", True, False) %>'></asp:Label>
                                                <asp:LinkButton ID="btnSelect" runat="server" CausesValidation="False" Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' Text='<%# Eval("EIDSSSessionID") %>' CommandName="Select" CommandArgument='<% #Eval("VectorSurveillanceSessionID").ToString() + "," + Eval("EIDSSSessionID") + "," + Eval("Disease").ToString() %>'></asp:LinkButton>
                                                <asp:LinkButton ID="btnView" runat="server" CausesValidation="False" Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' Text='<%# Eval("EIDSSSessionID") %>' CommandName="View" CommandArgument='<% #Eval("VectorSurveillanceSessionID").ToString() %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="StatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Session_Status_Text %>" SortExpression="StatusTypeName" />
                                        <asp:BoundField DataField="StartDate" DataFormatString="{0:d}" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Start_Date_Text %>" SortExpression="StartDate" />
                                        <asp:BoundField DataField="CloseDate" DataFormatString="{0:d}" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Close_Date_Text %>" SortExpression="CloseDate" />
                                        <asp:BoundField DataField="RegionName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" SortExpression="RegionName" />
                                        <asp:BoundField DataField="RayonName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" SortExpression="RayonName" />
                                        <asp:BoundField DataField="Vectors" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Vector_Type_Text %>" SortExpression="Vectors" />
                                        <asp:TemplateField>
                                            <HeaderTemplate><a runat="server" href="javascript:__doPostBack(&#39;ctl00$EIDSSBodyCPH$gvVectorSessions&#39;,&#39;Sort$DiseaseID&#39;)" meta:resourcekey="Lbl_Disease"></a></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lblDisease" runat="server" Text='<%# Bind("Disease") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("VectorSurveillanceSessionID") %>' OnDataBinding="GridViewSelection_OnDataBinding">
                                                    <span class="glyphicon glyphicon-edit"></span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" meta:resourceKey="Btn_Delete" CommandArgument='<% #Bind("VectorSurveillanceSessionID") %>' OnDataBinding="GridViewSelection_OnDataBinding">
                                                    <span class="glyphicon glyphicon-trash"></span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <span class="glyphicon glyphicon-triangle-bottom" onclick="showVectorSessionSubGrid(event,'divVectorSession<%#Eval("VectorSurveillanceSessionID") %>');"></span>
                                                <tr id="divVectorSession<%# Eval("VectorSurveillanceSessionID") %>" style="display: none">
                                                    <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                        <div>
                                                            <div class="form-horizontal">
                                                                <div class="form-group form-group-sm">
                                                                    <div class="row">
                                                                        <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                            <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Field_Session_ID_Text") %></label>
                                                                            <asp:TextBox ID="txtFieldSessionID" runat="server" CssClass="form-control input-sm" Text='<%# Eval("FieldSessionID") %>' Enabled="false"></asp:TextBox>
                                                                        </div>
                                                                        <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                            <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Settlement_Text") %></label>
                                                                            <asp:TextBox ID="txtSettlementName" runat="server" CssClass="form-control input-sm" Text='<%# Eval("SettlementName") %>' Enabled="false"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group form-group-sm">
                                                                    <div class="row">
                                                                        <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                            <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Latitude_Text") %></label>
                                                                            <asp:TextBox ID="txtLatitude" runat="server" CssClass="form-control input-sm" Text='<%# Eval("Latitude") %>' Enabled="false"></asp:TextBox>
                                                                        </div>
                                                                        <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                            <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Longitude_Text") %></label>
                                                                            <asp:TextBox ID="txtLongitude" runat="server" CssClass="form-control input-sm" Text='<%# Eval("Longitude") %>' Enabled="false"></asp:TextBox>
                                                                        </div>
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
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="VSSSearch" CausesValidation="true" />
            <asp:Button ID="btnAddVectorSurveillanceSession" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
        </div>
        <script>
            function searchCloseDate() {
                var searchStatus = $("#<%= ddlSessionStatusTypeID.ClientID %> option:selected").text();
                if (searchStatus == "Closed")
                    $("#closeDate").show();
                else
                    $("#closeDate").hide();
            }

            function showVectorSessionSubGrid(e, f) {
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

            function toggleVectorSessionSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $('#divVectorSessionSearchCriteriaForm').collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $('#divVectorSessionSearchCriteriaForm').collapse('show');
                }
            }

            function hideVectorSessionSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $('#divVectorSessionSearchCriteriaForm').collapse('hide');
            }

            function showVectorSessionSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $('#divVectorSessionSearchCriteriaForm').collapse('show');
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
