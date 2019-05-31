<%@ Page Title="Active Surveillance Campaign" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ActiveSurveillanceCampaign.aspx.vb" Inherits="EIDSS.VeterinaryActiveSurveillanceCampaign" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/SearchVeterinarySessionUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinarySession" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upHiddenFields" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divHiddenFieldsSection" runat="server" visible="false">
                <asp:HiddenField ID="hdfCampaignID" runat="server" Value="-1" />
                <asp:HiddenField ID="hdfHasSession" runat="server" Value="NULL" />
                <asp:HiddenField ID="hdfComments" runat="server" Value="" />
                <asp:HiddenField ID="hdfCampaignModule" runat="server" Value="Vet" />
                <asp:HiddenField ID="hdfRecordID" runat="server" Value="0" />
                <asp:HiddenField ID="hdfRowAction" runat="server" Value="" />
                <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
                <asp:HiddenField ID="hdfAvianOrLivestock" runat="server" Value="" />
                <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                <asp:HiddenField ID="hdfMonitoringSessionCount" runat="server" Value="0" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2><%= GetGlobalResourceObject("Labels", "Lbl_Veterinary_Active_Surveillance_Campaign_Text") %></h2>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-12">
                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                    <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
                </div>
            </div>
            <asp:UpdatePanel ID="upSearchCampaign" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnCancelAddUpdate" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnCancelSearchCriteria" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
                        <div id="divCampaignSearchForm" runat="server">
                            <div id="divCampaignSearchCriteria" runat="server" class="row embed-panel">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                                            </div>
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                <a href="#divCampaignSearchCriteriaForm" data-toggle="collapse" style="height: 24px;" data-parent="#divCampaignSearchCriteria" onclick="toggleCampaignSearchCriteria(event);">
                                                    <span id="toggleIcon" runat="server" role="button" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divCampaignSearchCriteriaForm" class="panel-collapse collapse in">
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
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                                        <asp:Button ID="btnCancelSearchCriteria" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showModalHandler('#divCancelSearchWarningModal');" />
                                                        <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
                                                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchCampaign" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <asp:UpdatePanel ID="upCampaignSearchResults" runat="server" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnAddCampaign" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnCancelSearchResults" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="gvCampaigns" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvCampaigns" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div id="divCampaignSearchResults" class="row embed-panel" runat="server">
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
                                                                    <asp:LinkButton ID="btnEIDSSCampaignID" runat="server" Text='<%# Eval("EIDSSCampaignID") %>' CommandName="View" CommandArgument='<%# Bind("CampaignID") %>' CausesValidation="false"></asp:LinkButton>
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
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel ID="upAddUpdateCampaign" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divVeterinaryActiveSurveillanceCampaignForm" runat="server" class="row embed-panel">
                        <asp:UpdatePanel ID="upCampaignInformation" runat="server" UpdateMode="Conditional">
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnAddCampaign" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="btnNewSpeciesToSampleType" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="ddlDiseaseID" EventName="SelectedIndexChanged" />
                            </Triggers>
                            <ContentTemplate>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <h3 class="heading" id="hdgCampaignInformation" meta:resourcekey="Hdg_Campaign_Information" runat="server"></h3>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" runat="server"></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group" meta:resourcekey="Dis_Campaign_ID" runat="server">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_ID" runat="server"></span>
                                                    <label for="txtEIDSSCampaignID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_ID_Text") %></label>
                                                    <asp:TextBox CssClass="form-control" ID="txtEIDSSCampaignID" Enabled="false" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSCampaignID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_ID" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Name" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_Name" runat="server"></span>
                                                    <label for="txtCampaignName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Name_Text") %></label>
                                                    <asp:TextBox CssClass="form-control" ID="txtCampaignName" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ControlToValidate="txtCampaignName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_Name" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Type" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_Type" runat="server"></span>
                                                    <label for="ddlCampaignTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Type_Text") %></label>
                                                    <asp:DropDownList CssClass="form-control" ID="ddlCampaignTypeID" runat="server"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ControlToValidate="ddlCampaignTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Campaign_Type" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Status" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_Status" runat="server"></span>
                                                    <label for="ddlCampaignStatusTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Status_Text") %></label>
                                                    <asp:DropDownList CssClass="form-control" ID="ddlCampaignStatusTypeID" AutoPostBack="true" runat="server"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ControlToValidate="ddlCampaignStatusTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Campaign_Status" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Start_Date" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Start_Date" runat="server"></span>
                                                    <label for="txtCampaignStartDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Start_Date_Text") %></label>
                                                    <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtCampaignStartDate" runat="server" LinkedPickerID="EIDSSBodyCPH_txtCampaignEndDate"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ControlToValidate="txtCampaignStartDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Start_Date" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cmvFutureCampaignStartDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtCampaignStartDate" meta:resourcekey="Val_Future_Start_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="CampaignInfo" SetFocusOnError="True"></asp:CompareValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_End_Date" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_End_Date" runat="server"></span>
                                                    <label for="txtCampaignEndDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_End_Date_Text") %></label>
                                                    <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtCampaignEndDate" runat="server"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ControlToValidate="txtCampaignEndDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_End_Date" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cmvCampaignDate" runat="server" ControlToValidate="txtCampaignStartDate" ControlToCompare="txtCampaignEndDate" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_End_Date_Range" CultureInvariantValues="true" ValidationGroup="CampaignInfo" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                    <asp:CompareValidator ID="cmvFutureCampaignEndDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtCampaignEndDate" meta:resourcekey="Val_Future_End_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="CampaignInfo" SetFocusOnError="True"></asp:CompareValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Administrator" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_Administrator" runat="server"></span>
                                                    <label for="txtCampaignAdministrator" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Campaign_Administrator_Text") %></label>
                                                    <asp:TextBox CssClass="form-control" ID="txtCampaignAdministrator" runat="server" MaxLength="200"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ControlToValidate="txtCampaignAdministrator" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_Administrator" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8" meta:resourcekey="Dis_Disease" runat="server">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Disease" runat="server"></span>
                                                    <label for="ddlDiseaseID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                    <asp:DropDownList CssClass="form-control" ID="ddlDiseaseID" runat="server" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ControlToValidate="ddlDiseaseID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Disease" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="divSpeciesAndSamplesContainer" runat="server" class="panel panel-default">
                                    <div class="panel-body">
                                        <div class="table-responsive" style="overflow-x: hidden;">
                                            <eidss:GridView ID="gvSpeciesAndSamples" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="CampaignToSampleTypeID"
                                                EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" GridLines="None" ShowFooter="false" ShowHeader="true" ShowHeaderWhenEmpty="true" UseAccessibleHeader="true" CellPadding="0" CellSpacing="0">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="100%">
                                                        <HeaderTemplate>
                                                            <div class="col-lg-2">
                                                                <span style="font-size: 11px;" class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Species_Type" runat="server"></span>
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <span style="font-size: 11px;" class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Sample_Type" runat="server"></span>
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <span style="font-size: 11px;" class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Planned_Number" runat="server"></span>
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Planned_Number_Text") %></label>
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Comments_Descriptions_Text") %></label>
                                                            </div>
                                                            <div class="col-lg-1"></div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upSpeciesToSampleTypeItemTemplate" runat="server" UpdateMode="Conditional" RenderMode="Block">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="btnEditSpeciesToSampleType" EventName="Click" />
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlEditSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlEditSampleTypeID" EventName="SelectedIndexChanged" />
                                                                    <asp:AsyncPostBackTrigger ControlID="txtEditPlannedNumber" EventName="TextChanged" />
                                                                    <asp:AsyncPostBackTrigger ControlID="txtEditComments" EventName="TextChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="form-group">
                                                                        <div class="col-lg-2">
                                                                            <eidss:DropDownList ID="ddlEditSpeciesTypeID" runat="server" CssClass="form-control" Enabled="false" AutoPostBack="true" OnSelectedIndexChanged="EditSpeciesTypeID_SelectedIndexChanged" />
                                                                            <asp:RequiredFieldValidator ControlToValidate="ddlEditSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                        <div class="col-lg-2">
                                                                            <eidss:DropDownList ID="ddlEditSampleTypeID" runat="server" CssClass="form-control" Enabled="false" AutoPostBack="true" OnSelectedIndexChanged="EditSampleTypeID_SelectedIndexChanged" />
                                                                            <asp:RequiredFieldValidator ControlToValidate="ddlEditSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                        <div class="col-lg-2">
                                                                            <eidss:NumericSpinner ID="txtEditPlannedNumber" runat="server" CssClass="form-control" Enabled="false" MinValue="0" OnTextChanged="EditPlannedNumber_TextChanged" />
                                                                            <asp:RequiredFieldValidator ControlToValidate="txtEditPlannedNumber" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Planned_Number" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                        <div class="col-lg-4">
                                                                            <asp:TextBox ID="txtEditComments" runat="server" CssClass="form-control" Enabled="false" OnTextChanged="EditComments_TextChanged"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                            <div class="col-lg-2">
                                                                <asp:LinkButton ID="btnEditSpeciesToSampleType" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<%# Bind("CampaignToSampleTypeID") %>' CausesValidation="false"></asp:LinkButton>
                                                                <asp:LinkButton ID="btnDeleteSpeciesAndSample" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("CampaignToSampleTypeID") %>' CausesValidation="false"></asp:LinkButton>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                            <asp:UpdatePanel ID="upInsertSpeciesToSampleType" runat="server" UpdateMode="Conditional">
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="ddlInsertSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <div class="table table-striped">
                                                        <div class="form-group">
                                                            <div class="col-lg-2">
                                                                <eidss:DropDownList CssClass="form-control" ID="ddlInsertSpeciesTypeID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                                <asp:RequiredFieldValidator ControlToValidate="ddlInsertSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <eidss:DropDownList CssClass="form-control" ID="ddlInsertSampleTypeID" runat="server" Enabled="false"></eidss:DropDownList>
                                                                <asp:RequiredFieldValidator ControlToValidate="ddlInsertSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <eidss:NumericSpinner ID="txtInsertPlannedNumber" runat="server" CssClass="form-control" MinValue="0" Enabled="false"></eidss:NumericSpinner>
                                                                <asp:RequiredFieldValidator ControlToValidate="txtInsertPlannedNumber" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Planned_Number" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col-lg-4">
                                                                <asp:TextBox ID="txtInsertComments" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <asp:LinkButton ID="btnNewSpeciesToSampleType" runat="server" CausesValidation="true" ValidationGroup="SpeciesAndSamplesSection" CommandName="Insert"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <div id="divSessionsContainer" runat="server" class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <h3 class="heading" meta:resourcekey="Hdg_Sessions" runat="server"></h3>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                        <asp:LinkButton ID="btnSearchMonitoringSessions" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                                        <asp:LinkButton ID="btnAddMonitoringSession" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <eidss:GridView AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped table-hover" DataKeyNames="VeterinaryMonitoringSessionID"
                                        GridLines="None" ID="gvMonitoringSessions" meta:resourcekey="Grd_Sessions_List" runat="server" ShowFooter="true" ShowHeader="true" ShowHeaderWhenEmpty="true"
                                        UseAccessibleHeader="true" PagerSettings-Visible="false">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Session_ID_Text %>" SortExpression="EIDSSSessionID">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("EIDSSSessionID") %>' CommandName="View" CommandArgument='<% #Eval("VeterinaryMonitoringSessionID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="RegionName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" SortExpression="RegionName" />
                                            <asp:BoundField DataField="RayonName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" SortExpression="RayonName" />
                                            <asp:BoundField DataField="SettlementName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Settlement_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Settlement_Text %>" SortExpression="SettlementName" />
                                            <asp:BoundField DataField="StartDate" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Session_Start_Date_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Session_Start_Date_Text %>" DataFormatString="{0:d}" SortExpression="StartDate" />
                                            <asp:BoundField DataField="EndDate" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Session_End_Date_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Session_End_Date_Text %>" DataFormatString="{0:d}" SortExpression="EndDate" />
                                            <asp:BoundField DataField="SessionStatusTypeName" AccessibleHeaderText="<%$ Resources: Labels, Lbl_Status_Text %>" HeaderText="<%$ Resources: Labels, Lbl_Status_Text %>" SortExpression="SessionStatusTypeName" />
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEditSession" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("VeterinaryMonitoringSessionID") %>' CausesValidation="false" Text=""></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnDeleteSession" runat="server" CommandArgument='<%# Bind("VeterinaryMonitoringSessionID") %>' CommandName="Delete" CssClass="btn glyphicon glyphicon-trash"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </eidss:GridView>
                                    <div id="divMonitoringSessionsPager" class="row grid-footer" runat="server">
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                            <asp:Label ID="lblMonitoringSessionsRecordCount" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblMonitoringSessionsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptMonitoringSessionsPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%# Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="MonitoringSessionsPage_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="divConclusionContainer" runat="server" class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <h3 class="heading" meta:resourcekey="Hdg_Conclusion" runat="server"></h3>
                                    </div>
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceCampaignPanelController'), document.getElementById('VeterinaryActiveSurveillanceCampaignSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceCampaignForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Conclusion_Tab"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" meta:resourcekey="Dis_Conclusion" runat="server">
                                        <div class="form-group">
                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Conclusion" runat="server"></span>
                                            <asp:Label AssociatedControlID="txtConclusion" CssClass="control-label" meta:resourcekey="Lbl_Campaign_Information_Conclusion" runat="server"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtConclusion" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ControlToValidate="txtConclusion" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_Information_Conclusion" runat="server" ValidationGroup="Conclusion"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnCancelAddUpdate" EventName="Click" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:Button ID="btnCancelAddUpdate" CssClass="btn btn-default" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                    <asp:Button ID="btnSubmit" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" runat="server" ValidationGroup="CampaignInfo" />
                                    <asp:Button ID="btnDelete" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" runat="server" CausesValidation="false" Visible="false" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divSearchVeterinarySessionModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchVeterinarySessionModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchVeterinarySessionModal')">&times;</button>
                <h4 id="hdgSearchVeterinaryMonitoringSessions" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Veterinary_Monitoring_Session_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchVeterinarySession ID="ucSearchVeterinarySession" runat="server" />
            </div>
        </div>
    </div>
    <div id="divSuccessModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divSuccessModal">
        <asp:UpdatePanel ID="upSuccessModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 id="hdgSuccess" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_EIDSS_Success_Message_Text") %></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-ok-sign modal-icon"></span></div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p id="lblSuccessMessage" runat="server" meta:resourcekey="Lbl_Success"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div id="divAddUpdate" runat="server">
                                <asp:Button ID="btnReturnToCampaign" runat="server" CssClass="btn btn-primary" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Campaign_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Campaign_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
                                <asp:Button ID="btnReturnToDashboard" runat="server" CssClass="btn btn-default" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Return_To_Dashboard_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Return_To_Dashboard_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
                            </div>
                            <div id="divSuccessOK" runat="server">
                                <button id="btnSuccessModalOK" type="button" class="btn btn-primary" onclick="hideModal('#divSuccessModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divWarningModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
        <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnWarningModalYes" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnWarningModalNo" EventName="Click" />
            </Triggers>
            <ContentTemplate>
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-warning">
                        <div class="panel-heading">
                            <button type="button" class="close" onclick="hideModal('#divWarningModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="hdgWarning" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="warningSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divWarningBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <div id="divWarningYesNo" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnWarningModalNo" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_No_Text %>" ToolTip="<%$ Resources: Buttons, Btn_No_ToolTip %>" CausesValidation="false" />
                            </div>
                            <div id="divWarningOK" runat="server">
                                <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" onclick="hideModal('#divWarningModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divErrorModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divErrorModal">
        <asp:UpdatePanel ID="upErrorModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-danger">
                        <div class="panel-heading">
                            <button type="button" class="close" onclick="hideModal('#divErrorModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link danger" id="hdgError" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="errorSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divErrorBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <button id="btnErrorModalOK" type="button" class="btn btn-danger alert-link" onclick="hideModal('#divErrorModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script>
        function validateSearchDateRange(args) {

            var startDateInput = $("#<% = txtSearchStartDateFrom.ClientID %>");
            var endDateInput = $("#<% = txtSearchStartDateTo.ClientID %>")

            args.IsValid = dateValidator(startDateInput.val(), endDateInput.val())
        }

        function dateValidator(startDate, endDate) {
            if ((startDate === "") ||
                (endDate === "")) {
                return true;
            }

            try {
                var date1 = new Date(startDate).valueOf();
                var date2 = new Date(endDate).valueOf();

                if (date1 > date2) {
                    return false;
                }
                return true;
            }
            catch (ex) {
                return false;
            }
        }

        function showCampaignSubGrid(e, f) {
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

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0)
                showModal(modalID);
            else
                showModalOnModal(modalID);
        };

        function showModal(modalID) {
            // var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            $("body").addClass("modal-open");
            // bd.appendTo(document.body);
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');
        }

        function hideModal(modalID) {
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };

        function hideModalAndWarningModal(modalID) {
            hideModal(modalID);
            $('#divWarningModal').modal('hide');
        }

        function hideModalShowModal(hideDiv, showDiv) {
            $(hideDiv).modal('hide');
            $(showDiv).modal({ show: true });
        };

        function toggleCampaignSearchCriteria(e) {
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
                $("#divCampaignSearchCriteriaForm").collapse('show');
                $('#<%= btnCancelSearchResults.ClientID %>').show();
                $('#<%= btnPrintSearchResults.ClientID %>').show();
                $('#<%= btnAddCampaign.ClientID %>').show();
            }
        }

        function hideCampaignSearchCriteria() {
            $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divCampaignSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddCampaign.ClientID %>').show();
        }

        function hideCampaignSearchCriteriaCloseWarningModal() {
            $('#<%= btnCancelSearchCriteria.ClientID %>').hide();
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divCampaignSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancelSearchResults.ClientID %>').show();
            $('#<%= btnPrintSearchResults.ClientID %>').show();
            $('#<%= btnAddCampaign.ClientID %>').show();
            $('#divWarningModal').modal('hide');
        }

        function showCampaignSearchCriteria() {
            $('#<%= btnCancelSearchCriteria.ClientID %>').show();
            $('#<%= btnClear.ClientID %>').show();
            $('#<%= btnSearch.ClientID %>').show();
            $("#divCampaignSearchCriteriaForm").collapse('show');
            $('#<%= btnCancelSearchResults.ClientID %>').hide();
            $('#<%= btnPrintSearchResults.ClientID %>').hide();
            $('#<%= btnAddCampaign.ClientID %>').hide();
        }
    </script>
</asp:Content>
