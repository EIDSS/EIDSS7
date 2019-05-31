<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchHumanDiseaseReportUserControl.ascx.vb" Inherits="EIDSS.SearchHumanDiseaseReportUserControl" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:UpdatePanel ID="upSearchHumanDiseaseReport" runat="server" UpdateMode="Conditional">
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
            <div id="divHumanDiseaseReportSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="pull-right">
                                    <a href="#divHumanDiseaseReportSearchCriteriaForm" data-toggle="collapse" data-parent="#divHumanDiseaseReportSearchUserControlCriteria" onclick="toggleHumanDiseaseReportSearchCriteria(event);">
                                        <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div id="divHumanDiseaseReportSearchCriteriaForm" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <p><% =GetLocalResourceObject("Lbl_Instruction_Text") %></p>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Report_ID">
                                        <label for="<% =txtEIDSSReportID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_ID_Text") %></label>
                                        <asp:TextBox ID="txtEIDSSReportID" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Legacy_ID">
                                        <label for="<% =txtLegacyID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Legacy_ID_Text") %></label>
                                        <asp:TextBox ID="txtLegacyID" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                        <label runat="server" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Or_Text") %></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div runat="server" meta:resourcekey="Dis_Disease" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                        <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div runat="server" meta:resourcekey="Dis_Report_Status_Type_ID" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="ddlReportStatusTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Status_Text") %></label>
                                        <asp:DropDownList ID="ddlReportStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div runat="server" meta:resourcekey="Dis_Last_Name" class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                        <label for="<% =txtPatientLastOrSurname.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                        <asp:TextBox ID="txtPatientLastOrSurname" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div runat="server" meta:resourcekey="Dis_First_Name" class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                        <label for="<% =txtPatientFirstOrGivenName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                        <asp:TextBox ID="txtPatientFirstOrGivenName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div runat="server" meta:resourcekey="Dis_Middle_Name" class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                        <label for="<% =txtPatientMiddleName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Middle_Name_Text") %></label>
                                        <asp:TextBox ID="txtPatientMiddleName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <eidss:Location ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowTownOrVillage="false" IsHorizontalLayout="true" />
                            </div>
                            <fieldset>
                                <legend><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_Range_Text") %></legend>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Date_Entered_From">
                                            <label for="<% =txtHumanDiseaseReportDateEnteredFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_From_Text") %></label>
                                            <eidss:CalendarInput ID="txtHumanDiseaseReportDateEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" LinkedPickerID="txtHumanDiseaseReportDateEnteredTo" />
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Date_Entered_To">
                                            <label for="<% =txtHumanDiseaseReportDateEnteredTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_To_Text") %></label>
                                            <eidss:CalendarInput ID="txtHumanDiseaseReportDateEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                            <asp:CompareValidator ID="Val_Entered_Date_Compare" runat="server" CssClass="text-danger" ControlToCompare="txtHumanDiseaseReportDateEnteredTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtHumanDiseaseReportDateEnteredFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Entered_Date_Compare" ValidationGroup="HDRSearch"></asp:CompareValidator>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            <div class="form-group">
                                <div class="row">
                                    <div runat="server" meta:resourcekey="Dis_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<% =ddlClassificationTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Case_Classification_Text") %></label>
                                        <asp:DropDownList ID="ddlClassificationTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div runat="server" meta:resourcekey="Dis_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<% =ddlHospitalizationStatusTypeId.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Hospitalization_Text") %></label>
                                        <asp:DropDownList ID="ddlHospitalizationStatusTypeID" runat="server" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div id="divHumanDiseaseReportSearchResults" runat="server" class="row embed-panel">
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
                            <asp:AsyncPostBackTrigger ControlID="gvHumanDiseaseReports" EventName="RowCommand" />
                            <asp:AsyncPostBackTrigger ControlID="gvHumanDiseaseReports" EventName="Sorting" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvHumanDiseaseReports" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CaptionAlign="Top" CssClass="table table-striped" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" DataKeyNames="HumanDiseaseReportID,PatientID,HumanMasterID" ShowFooter="true" GridLines="None" PagerSettings-Visible="false">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Report_ID_Text %>" SortExpression="EIDSSReportID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblReportID" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible='<%# IIf(hdfSelectMode.Value = "9", True, False) %>'></asp:Label>
                                                <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("HumanDiseaseReportID").ToString() + "," + Eval("EIDSSReportID") + "," + Eval("DiseaseID").ToString() + "," + Eval("PatientID").ToString() + "," + Eval("PatientName") %>' CausesValidation="false"></asp:LinkButton>
                                                <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("HumanDiseaseReportID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="LegacyCaseID" ReadOnly="true" SortExpression="LegacyCaseID" HeaderText="<%$ Resources: Labels, Lbl_Legacy_ID_Text %>" />
                                        <asp:BoundField DataField="PatientName" ReadOnly="true" SortExpression="PatientName" HeaderText="<%$ Resources: Labels, Lbl_Person_Name_Text %>" />
                                        <asp:BoundField DataField="EnteredDate" ReadOnly="true" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Date_Entered_Text %>" />
                                        <asp:BoundField DataField="DiseaseName" ReadOnly="true" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                        <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" SortExpression="ReportStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Report_Status_Text %>" />
                                        <asp:BoundField DataField="PatientLocation" SortExpression="PatientLocation" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Location_Text %>" />
                                        <asp:BoundField DataField="ClassificationTypeName" SortExpression="ClassificationTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="Btn_Edit_Human_Disease_Report" OnDataBinding="GridViewSelection_OnDataBinding"
                                                    CommandArgument='<%# Eval("HumanDiseaseReportID") %>'><span class="glyphicon glyphicon-edit"></span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <span class="glyphicon glyphicon-triangle-bottom" onclick="showHumanDiseaseReportSubGrid(event,'divHDR<%# Eval("HumanDiseaseReportID") %>');"></span>
                                                <tr id="divHDR<%# Eval("HumanDiseaseReportID") %>" style="display: none;">
                                                    <td colspan="7" style="border-top: 0 none transparent;">
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                    <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Person_ID_Text") %></label>
                                                                    <asp:TextBox ID="txtPersonName" CssClass="form-control input-sm" runat="server" Text='<%# Bind("EIDSSPersonID") %>' Enabled="false"></asp:TextBox>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                    <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Entered_By_Organization_Text") %></label>
                                                                    <asp:TextBox ID="txtEnteredByOrganizationName" CssClass="form-control input-sm" runat="server" Text='<%# Bind("EmployerName") %>' Enabled="false"></asp:TextBox>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                    <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Entered_By_Name_Text") %></label>
                                                                    <asp:TextBox ID="txtEnteredByPersonName" CssClass="form-control input-sm" runat="server" Text='<%# Bind("PersonEnteredByName") %>' Enabled="false"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                    <label class="table-striped-header"><% =GetGlobalResourceObject("Labels", "Lbl_Hospitalization_Text") %></label>
                                                                    <asp:TextBox ID="txtHospitalizationStatusTypeName" CssClass="form-control input-sm" runat="server" Text='<%# Bind("FinalClassificationTypeName") %>' Enabled="false"></asp:TextBox>
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
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="HDRSearch" OnClientClick="showSearchLoading();" data-loading-text="<%$ Resources: Labels, Lbl_Loading_Text %>" />
            <asp:Button ID="btnAddHumanDiseaseReport" runat="server"  CssClass="btn btn-default" meta:resourcekey="Btn_Add_Human_Disease_Report" />
        </div>
        <script type="text/javascript">
            function showHumanDiseaseReportSubGrid(e, f) {
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

            function toggleHumanDiseaseReportSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $('#divHumanDiseaseReportSearchCriteriaForm').collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $('#divHumanDiseaseReportSearchCriteriaForm').collapse('show');
                }
            }

            function hideHumanDiseaseReportSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $('#divHumanDiseaseReportSearchCriteriaForm').collapse('hide');
            }

            function showHumanDiseaseReportSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $('#divHumanDiseaseReportSearchCriteriaForm').collapse('show');
            }

            function showSearchLoading() {
                var form = $('#EIDSSBodyCPH_ucSearchHumanDiseaseReport_divHumanDiseaseReportSearchCriteriaForm');
                form.validate;

                if (form.valid) {
                    $("#EIDSSBodyCPH_ucSearchHumanDiseaseReport_btnSearch").button('loading')

                    return true;
                }
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
