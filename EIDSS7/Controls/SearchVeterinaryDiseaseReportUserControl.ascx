<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchVeterinaryDiseaseReportUserControl.ascx.vb" Inherits="EIDSS.SearchVeterinaryDiseaseReportUsercontrol" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:UpdatePanel ID="upSearchVeterinaryDiseaseReport" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="ddlSpeciesTypeID" EventName="SelectedIndexChanged" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" visible="false">
            <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
            <asp:HiddenField ID="hdfFarmType" runat="server" Value="" />
            <asp:HiddenField ID="hdfCanEdit" runat="server" Value="0" />
        </div>
        <div id="divFarmSearchContainer" runat="server" class="row embed-panel">
            <asp:HiddenField runat="server" ID="hdfSearchFarmType" Value="null" />
            <asp:HiddenField runat="server" ID="hdfRegionID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfRayonID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfSettlementID" Value="null" />
        </div>
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <asp:MultiView ID="mvVeterinaryDiseaseReportSearch" runat="server" ActiveViewIndex="0">
                <asp:View ID="vwSearchCriteria" runat="server">
                    <div class="panel-group row embed-panel" id="accordion">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                        <h3 class="header" onclick="toggleVeterinaryDiseaseReportSearchAdvancedSearch();"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                        <span id="toggleSearch" role="button" class="glyphicon glyphicon-triangle-bottom header-button" onclick="toggleVeterinaryDiseaseReportSearchAdvancedSearch();"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div id="divVeterinaryDiseaseReportSearch" class="panel-collapse collapse in">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =txtEIDSSReportID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_ID_Text") %></label>
                                                <asp:TextBox ID="txtEIDSSReportID" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                <label runat="server" meta:resourcekey="Dis_Search_Or" class="control-label"></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =ddlSpeciesTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Type_Text") %></label>
                                                <asp:DropDownList ID="ddlSpeciesTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                            </div>
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =ddlReportStatusTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Status_Text") %></label>
                                                <asp:DropDownList ID="ddlReportStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </div>
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =ddlReportTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Type_Text") %></label>
                                                <asp:DropDownList ID="ddlReportTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <eidss:Location ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowTownOrVillage="true" IsHorizontalLayout="true" />
                                    <fieldset>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Date_Entered_From"></span>
                                                    <label for="<% =txtDateEnteredFrom.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_From_Text") %></label>
                                                    <eidss:CalendarInput ID="txtDateEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ControlToValidate="txtDateEnteredFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Entered_From" runat="server" EnableClientScript="true" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Date_Entered_To"></span>
                                                    <label for="<% =txtDateEnteredTo.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_To_Text") %></label>
                                                    <eidss:CalendarInput ID="txtDateEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ControlToValidate="txtDateEnteredTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Entered_To" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvEnteredDate" runat="server" CssClass="text-danger" ControlToCompare="txtDateEnteredTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtDateEnteredFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Entered_Date_Compare" ValidationGroup="VDRSearch"></asp:CompareValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                <label for="<% =ddlClassificationTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Case_Classification_Text") %></label>
                                                <asp:DropDownList ID="ddlClassificationTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                        <h3 class="header" onclick="toggleVeterinaryDiseaseReportSearchAdvancedSearch();"><% =GetGlobalResourceObject("Labels", "Lbl_Advanced_Search_Text") %></h3>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                        <span id="toggleAdvancedSearch" role="button" class="glyphicon glyphicon-triangle-bottom header-button" onclick="toggleVeterinaryDiseaseReportSearchAdvancedSearch();"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div id="divVeterinaryDiseaseReportAdvancedSearch" class="panel-collapse collapse">
                                    <div class="form-group" runat="server" meta:resourcekey="Dis_Diagnosis_Date_Range">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Diagnosis_Date_From"></span>
                                                <label for="<% =txtDiagnosisDateFrom.ClientID %>" runat="server" meta:resourcekey="Lbl_Diagnosis_Date_From"></label>
                                                <eidss:CalendarInput ID="txtDiagnosisDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtDiagnosisDateFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Diagnosis_Date_From" runat="server" EnableClientScript="true" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Diagnosis_Date_To"></span>
                                                <label for="<% =txtDiagnosisDateTo.ClientID %>" runat="server" meta:resourcekey="Lbl_Diagnosis_Date_To"></label>
                                                <eidss:CalendarInput ID="txtDiagnosisDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtDiagnosisDateTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Diagnosis_Date_To" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="cvDiagnosisDate" runat="server" CssClass="text-danger" ControlToCompare="txtDiagnosisDateTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtDiagnosisDateFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Diagnosis_Date_Compare" ValidationGroup="VDRSearch"></asp:CompareValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" meta:resourcekey="Dis_Investigation_Date_Range">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Investigation_Date_From"></span>
                                                <label for="<% =txtInvestigationDateFrom.ClientID %>" runat="server" meta:resourcekey="Lb_Investigation_Date_From"></label>
                                                <eidss:CalendarInput ID="txtInvestigationDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtInvestigationDateFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Investigation_Date_From" runat="server" EnableClientScript="true" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Investigation_Date_To"></span>
                                                <label for="<% =txtInvestigationDateTo.ClientID %>" runat="server" meta:resourcekey="Lb_Investigation_Date_To"></label>
                                                <eidss:CalendarInput ID="txtInvestigationDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtInvestigationDateTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Investigation_Date_To" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="cvInvestigationDate" runat="server" CssClass="text-danger" ControlToCompare="txtInvestigationDateTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtInvestigationDateFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Investigation_Date_Compare" ValidationGroup="VDRSearch"></asp:CompareValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" meta:resourcekey="Dis_Local_Field_Sample_ID">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Local_Field_Sample_ID" runat="server"></div>
                                                <label for="<%= txtEIDSSLocalFieldSampleID.ClientID %>" runat="server" meta:resourcekey="Lbl_Local_Field_Sample_ID" class="control-label"></label>
                                                <asp:TextBox ID="txtEIDSSLocalFieldSampleID" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLocalFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Local_Field_Sample_ID" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" meta:resourcekey="Dis_Total_Animal_Quantity_Range">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Total_Animal_Quantity_From"></span>
                                                <label for="<% =txtTotalAnimalQuantityFrom.ClientID %>" runat="server" meta:resourcekey="Lbl_Total_Animal_Quantity_From"></label>
                                                <eidss:NumericSpinner ID="txtTotalAnimalQuantityFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" MinValue="0" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtTotalAnimalQuantityFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Total_Animal_Quantity_From" runat="server" EnableClientScript="true" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Total_Animal_Quantity_To"></span>
                                                <label for="<% =txtTotalAnimalQuantityTo.ClientID %>" runat="server" meta:resourcekey="Lbl_Total_Animal_Quantity_To"></label>
                                                <eidss:NumericSpinner ID="txtTotalAnimalQuantityTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" MinValue="0" />
                                                <asp:RequiredFieldValidator ControlToValidate="txtTotalAnimalQuantityTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Total_Animal_Quantity_To" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="cvTotalAnimalQuantity" runat="server" CssClass="text-danger" ControlToCompare="txtTotalAnimalQuantityTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtTotalAnimalQuantityFrom" Type="Integer" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Total_Animal_Quantity_Compare" ValidationGroup="VDRSearch"></asp:CompareValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" meta:resourcekey="Dis_Data_Entry_Site">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Data_Entry_Site" runat="server"></div>
                                                <label for="<%= ddlDataEntrySite.ClientID %>" runat="server" meta:resourcekey="Lbl_Data_Entry_Site" class="control-label"></label>
                                                <eidss:DropDownList ID="ddlDataEntrySite" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlDataEntrySite" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Data_Entry_Site" runat="server" ValidationGroup="VDRSearch"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="vwSearchResults" runat="server">
                    <div id="divVeterinaryDiseaseReportSearchResults" class="row embed-panel" runat="server">
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
                                        <asp:AsyncPostBackTrigger ControlID="gvVeterinaryDiseaseReports" EventName="Sorting" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:HiddenField ID="hdfSearchCount" runat="server" Value="0" />
                                        <div class="table-responsive">
                                            <eidss:GridView ID="gvVeterinaryDiseaseReports" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="VeterinaryDiseaseReportID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Report_ID_Text %>" SortExpression="EIDSSReportID">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("VeterinaryDiseaseReportID").ToString() + "," + Eval("EIDSSReportID") + "," + If(Eval("DiseaseID") Is Nothing, Nothing, Eval("DiseaseID").ToString()) + "," + If(Eval("FarmOwnerID") Is Nothing, Nothing, Eval("FarmOwnerID").ToString()) + "," + Eval("FarmOwnerName").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                            <asp:UpdatePanel ID="upViewDiseaseReport" runat="server" UpdateMode="Conditional">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("VeterinaryDiseaseReportID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="SpeciesList" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                    <asp:BoundField DataField="EnteredDate" ReadOnly="true" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Date_Entered_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" ReadOnly="true" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:TemplateField SortExpression="FarmName" HeaderText="<%$ Resources: Labels, Lbl_Farm_Name_Text %>">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSelectFarm" runat="server" CommandName="Select Farm" CommandArgument='<% #Eval("FarmMasterID").ToString() %>' Text='<% #Bind("FarmName") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="FormattedFarmAddressString" ReadOnly="true" SortExpression="FormattedFarmAddressString" HeaderText="<%$ Resources: Labels, Lbl_Farm_Address_Text %>" />
                                                    <asp:BoundField DataField="ClassificationTypeName" ReadOnly="true" SortExpression="ClassificationTypeName" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                                    <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" SortExpression="ReportStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Report_Status_Text %>" />
                                                    <asp:BoundField DataField="ReportTypeName" ReadOnly="true" SortExpression="ReportTypeName" HeaderText="<%$ Resources: Labels, Lbl_Report_Type_Text %>" />
                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upEditDiseaseReport" runat="server" UpdateMode="Conditional">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="btnEdit" EventName="Click" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" Visible='<%# IIf(hdfCanEdit.Value = "1", True, False) %>' meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("VeterinaryDiseaseReportID") %>'>
                                                            <span class="glyphicon glyphicon-edit"></span>
                                                                    </asp:LinkButton>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <span class="glyphicon glyphicon-triangle-bottom" onclick="showVeterinaryDiseaseReportSubGrid(event,'divVeterinaryDiseaseReport<%# Eval("VeterinaryDiseaseReportID") %>');"></span>
                                                            <tr id="divVeterinaryDiseaseReport<%# Eval("VeterinaryDiseaseReportID") %>" style="display: none;">
                                                                <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                                    <div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                    <asp:Label ID="lblReportDate" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Report_Date_Text %>" />
                                                                                    <asp:TextBox ID="txtReportDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("ReportDate", "{0:d}") %>' />
                                                                                </div>
                                                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                    <asp:Label ID="lblPersonReportedByName" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Reported_By_Text %>" />
                                                                                    <asp:TextBox ID="txtPersonReportedByName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonReportedByName") %>' />
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                    <asp:Label ID="lblInvestigationDate" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Investigation_Date_Text %>" />
                                                                                    <asp:TextBox ID="txtInvestigationDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("InvestigationDate", "{0:d}") %>' />
                                                                                </div>
                                                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                    <asp:Label ID="lblPersonInvestigatedByID" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Investigated_By_Text %>" />
                                                                                    <asp:TextBox ID="txtPersonInvestigatedByID" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonInvestigatedByName") %>' />
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                                    <asp:Label ID="lblSpeciesType" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                                                    <asp:TextBox ID="txtSpeciesType" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("SpeciesList") %>' />
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                    <asp:Label ID="lblTotalAnimaQuantity" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Total_Animal_Quantity_Text %>" />
                                                                                    <asp:TextBox ID="txtTotalAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalAnimalQuantity") %>' />
                                                                                </div>
                                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                    <asp:Label ID="lblSickAnimalQuantity" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Sick_Animal_Quantity_Text %>" />
                                                                                    <asp:TextBox ID="txtTotalSickAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalSickAnimalQuantity") %>' />
                                                                                </div>
                                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                    <asp:Label ID="lblDeadAnimalQuantity" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Dead_Animal_Quantity_Text %>" />
                                                                                    <asp:TextBox ID="txtTotalDeadAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalDeadAnimalQuantity") %>' />
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
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </asp:View>
            </asp:MultiView>
        </asp:Panel>
        <div class="modal-footer text-center">
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="VDRSearch" />
        </div>
        <script type="text/javascript">
            var advancedSearchShown = false;
            function toggleVeterinaryDiseaseReportSearchAdvancedSearch() {

                if (advancedSearchShown == false) {
                    $('#divVeterinaryDiseaseReportSearch').collapse('hide')
                    $('#divVeterinaryDiseaseReportAdvancedSearch').collapse('show')
                    advancedSearchShown = true;
                }
                else {
                    $('#divVeterinaryDiseaseReportSearch').collapse('show')
                    $('#divVeterinaryDiseaseReportAdvancedSearch').collapse('hide')
                    advancedSearchShown = false;
                }
            }

            function showVeterinaryDiseaseReportSubGrid(e, f) {
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
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
