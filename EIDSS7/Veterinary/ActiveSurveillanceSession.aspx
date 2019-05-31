<%@ Page AutoEventWireup="false" CodeBehind="ActiveSurveillanceSession.aspx.vb" Inherits="EIDSS.VeterinaryActiveSurveillanceSession" Language="vb" MasterPageFile="~/NormalView.Master" meta:resourcekey="Page" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/SearchVeterinaryCampaignUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinaryCampaign" %>
<%@ Register Src="~/Controls/SearchFarmUserControl.ascx" TagPrefix="eidss" TagName="SearchFarm" %>
<%@ Register Src="~/Controls/AddUpdateFarmUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateFarm" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPerson" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePerson" %>
<%@ Register Src="~/Controls/SearchVeterinarySessionUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinarySession" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upHiddenFields" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divHiddenFieldsSection" runat="server">
                <asp:HiddenField ID="hdfMonitoringSessionID" runat="server" Value="-1" />
                <asp:HiddenField ID="hdfCampaignID" runat="server" Value="" />
                <asp:HiddenField ID="hdfRowID" runat="server" Value="0" />
                <asp:HiddenField ID="hdfRowAction" runat="server" Value="" />
                <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
                <asp:HiddenField ID="hdfRowStatus" runat="server" Value="0" />
                <asp:HiddenField ID="hdfSessionCategoryTypeID" runat="server" Value="10169002" />
                <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
                <asp:HiddenField ID="hdfParentSampleID" runat="server" Value="" />
                <asp:HiddenField ID="hdfDetailedInfoFarmCount" runat="server" Value="0" />
                <asp:HiddenField ID="hdfAggregateInfoFarmCount" runat="server" Value="0" />
                <asp:HiddenField ID="hdfPendingFarmID" runat="server" Value="" />
                <asp:HiddenField ID="hdfPendingEIDSSFarmID" runat="server" Value="" />
                <asp:HiddenField ID="hdfFarmMasterID" runat="server" Value="" />
                <asp:HiddenField ID="hdfFarmID" runat="server" Value="" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2 id="hdgActiveSurveillanceSession"><%= GetGlobalResourceObject("Labels", "Lbl_Active_Surveillance_Session_Text") %></h2>
        </div>
        <div class="panel-body">
            <div class="col-md-12">
                <div class="glyphicon glyphicon-asterisk text-danger"></div>
                <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
            </div>
            <asp:UpdatePanel ID="upSearchActiveSurveillanceSession" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <eidss:SearchVeterinarySession ID="ucSearchVeterinarySession" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel ID="upAddUpdateActiveSurveillanceSession" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divActiveSurveillanceMonitoringSessionForm" class="embed-panel" runat="server">
                        <div class="sectionContainer expanded">
                            <section id="SessionInfo" runat="server" class="col-md-12">
                                <asp:UpdatePanel ID="upSessionInformation" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlSpeciesType" EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="lbxDiseaseID" EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="btnClearCampaign" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                        <h3 class="header"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Information_Text") %></h3>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Session_Location_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_ID" runat="server">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_ID" runat="server"></span>
                                                            <label for="txtEIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                            <asp:TextBox CssClass="form-control" ID="txtEIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEIDSSSessionID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_ID" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_Status" runat="server">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_Status" runat="server"></span>
                                                            <label for="ddlMonitoringSessionStatusTypeID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                            <asp:DropDownList CssClass="form-control" ID="ddlMonitoringSessionStatusTypeID" runat="server"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator ControlToValidate="ddlMonitoringSessionStatusTypeID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_Status" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <fieldset>
                                                    <legend><%= GetGlobalResourceObject("Labels", "Lbl_Campaign_Information_Text") %></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Campaign_ID" runat="server">
                                                                <label for="txtEIDSSCampaignID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Campaign_ID_Text") %></label>
                                                                <div id="divSearchCampaignContainer" class="input-group" runat="server">
                                                                    <asp:TextBox ID="txtEIDSSCampaignID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    <asp:LinkButton ID="btnSearchCampaign" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-search" role="button"></span></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Campaign_Name" runat="server">
                                                                <label for="txtCampaignName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Campaign_Name_Text") %></label>
                                                                <asp:TextBox CssClass="form-control" ID="txtCampaignName" runat="server" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Information_Campaign_Type" runat="server">
                                                                <label for="txtCampaignTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Campaign_Type_Text") %></label>
                                                                <asp:TextBox CssClass="form-control" ID="txtCampaignTypeName" runat="server" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <br />
                                                                <asp:Button ID="btnClearCampaign" runat="server" CausesValidation="false" CssClass="btn btn-sm btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_Session_From_Campaign_ToolTip %>" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_Start_Date" runat="server">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_Start_Date" runat="server"></span>
                                                            <label for="txtStartDate" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Start_Date_Text") %></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtStartDate" runat="server" LinkedPickerID="EIDSSBodyCPH_txtEndDate"></eidss:CalendarInput>
                                                            <asp:TextBox ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtCampaignStartDate" runat="server"></asp:TextBox>
                                                            <asp:CompareValidator ID="cmvFutureSessionStartDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtStartDate" meta:resourcekey="Val_Future_Start_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="SessionInfo" SetFocusOnError="True"></asp:CompareValidator>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtStartDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_Start_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                            <asp:CompareValidator ID="cmvSessionStartDateCampaignStartDate" runat="server" ControlToValidate="txtStartDate" ControlToCompare="txtCampaignStartDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Session_Start_Date_Campaign_Start_Date_Range" CultureInvariantValues="true" ValidationGroup="SessionInfo" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                                            <asp:CompareValidator ID="cmvSessionStartDateCampaignEndDate" runat="server" ControlToValidate="txtStartDate" ControlToCompare="txtCampaignEndDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Session_Start_Date_Campaign_End_Date_Range" CultureInvariantValues="true" ValidationGroup="SessionInfo" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_End_Date" runat="server">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_End_Date" runat="server"></span>
                                                            <label for="txtEndDate" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_End_Date_Text") %></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtEndDate" runat="server"></eidss:CalendarInput>
                                                            <asp:TextBox ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtCampaignEndDate" runat="server"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEndDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_End_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                            <asp:CompareValidator ID="cmvSessionDateRange" runat="server" ControlToValidate="txtStartDate" ControlToCompare="txtEndDate" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_End_Date_Range" CultureInvariantValues="true" ValidationGroup="SessionInfo" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                            <asp:CompareValidator ID="cmvFutureSessionEndDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtEndDate" meta:resourcekey="Val_Future_End_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="SessionInfo" SetFocusOnError="True"></asp:CompareValidator>
                                                            <asp:CompareValidator ID="cmvSessionEndDateCampaignStartDate" runat="server" ControlToValidate="txtEndDate" ControlToCompare="txtCampaignStartDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Session_End_Date_Campaign_Start_Date_Range" CultureInvariantValues="true" ValidationGroup="SessionInfo" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                                            <asp:CompareValidator ID="cmvSessionEndDateCampaignEndDate" runat="server" ControlToValidate="txtEndDate" ControlToCompare="txtCampaignEndDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Session_End_Date_Campaign_End_Date_Range" CultureInvariantValues="true" ValidationGroup="SessionInfo" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label for="ddlSpeciesType" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Species_Type_Text") %></label>
                                                            <eidss:DropDownList ID="ddlSpeciesType" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator ControlToValidate="ddlSpeciesType" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species_Type" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" meta:resourcekey="Dis_Disease" runat="server">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Disease" runat="server"></span>
                                                            <label for="lbxDiseaseID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                            <asp:ListBox CssClass="form-control" ID="lbxDiseaseID" runat="server" AutoPostBack="true" SelectionMode="Single" Rows="1"></asp:ListBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="lbxDiseaseID" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Disease" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Site" runat="server">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Site" runat="server"></span>
                                                        <label for="txtSiteName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Site_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSiteName" runat="server" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSiteName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Site" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Officer" runat="server">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Officer" runat="server"></span>
                                                        <label for="txtEnteredByPersonName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Officer_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtEnteredByPersonName" runat="server" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtEnteredByPersonName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Officer" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Date" runat="server">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date" runat="server"></span>
                                                        <label for="txtEnteredDate" cssclass="control-label" meta:resourcekey="Lbl_Date_Entered" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Date_Entered_Text") %></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtEnteredDate" runat="server" Enabled="false"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtEnteredDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <h3 class="header"><%= GetGlobalResourceObject("Labels", "Lbl_Location_Text") %></h3>
                                                    </div>
                                                </div>
                                                <eidss:Location ID="MonitoringSessionAddress" runat="server" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" IsHorizontalLayout="true" IsDbRequiredCountry="true" IsDbRequiredRegion="true" />
                                            </div>
                                        </div>
                                        <div class="panel panel-default">
                                            <div class="panel-body">
                                                <div class="table-responsive" style="overflow-x: hidden;">
                                                    <eidss:GridView ID="gvSpeciesAndSamples" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="MonitoringSessionToSampleTypeID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" GridLines="None" ShowFooter="false" ShowHeader="true" ShowHeaderWhenEmpty="true" UseAccessibleHeader="true" CellPadding="0" CellSpacing="0">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="100%">
                                                                <HeaderTemplate>
                                                                    <div class="col-lg-4">
                                                                        <span style="font-size: 11px;" class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Species_Type" runat="server"></span>
                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                                    </div>
                                                                    <div class="col-lg-4">
                                                                        <span style="font-size: 11px;" class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Sample_Type" runat="server"></span>
                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                                                    </div>
                                                                    <div class="col-lg-2"></div>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:UpdatePanel ID="upSpeciesToSampleTypeItemTemplate" runat="server" UpdateMode="Conditional" RenderMode="Block">
                                                                        <Triggers>
                                                                            <asp:AsyncPostBackTrigger ControlID="btnEditSpeciesToSampleType" EventName="Click" />
                                                                            <asp:AsyncPostBackTrigger ControlID="ddlEditSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                                            <asp:AsyncPostBackTrigger ControlID="ddlEditSampleTypeID" EventName="SelectedIndexChanged" />
                                                                        </Triggers>
                                                                        <ContentTemplate>
                                                                            <div class="form-group">
                                                                                <div class="col-lg-4">
                                                                                    <eidss:DropDownList ID="ddlEditSpeciesTypeID" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="EditSpeciesTypeID_SelectedIndexChanged" />
                                                                                    <asp:RequiredFieldValidator ControlToValidate="ddlEditSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                                </div>
                                                                                <div class="col-lg-4">
                                                                                    <eidss:DropDownList ID="ddlEditSampleTypeID" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="EditSampleTypeID_SelectedIndexChanged" />
                                                                                    <asp:RequiredFieldValidator ControlToValidate="ddlEditSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                                </div>
                                                                            </div>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                    <div class="col-lg-2">
                                                                        <asp:LinkButton ID="btnEditSpeciesToSampleType" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<%# Bind("MonitoringSessionToSampleTypeID") %>' CausesValidation="false"></asp:LinkButton>
                                                                        <asp:LinkButton ID="btnDeleteSpeciesAndSample" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("MonitoringSessionToSampleTypeID") %>' CausesValidation="false"></asp:LinkButton>
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
                                                                    <div class="col-lg-4">
                                                                        <eidss:DropDownList CssClass="form-control" ID="ddlInsertSpeciesTypeID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                                        <asp:RequiredFieldValidator ControlToValidate="ddlInsertSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div class="col-lg-4">
                                                                        <eidss:DropDownList CssClass="form-control" ID="ddlInsertSampleTypeID" runat="server" Enabled="false"></eidss:DropDownList>
                                                                        <asp:RequiredFieldValidator ControlToValidate="ddlInsertSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
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
                            </section>
                            <section id="DetailedInformation" runat="server" class="col-md-12">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                <h3 class="header"><%= GetGlobalResourceObject("Labels", "Lbl_Detailed_Information_Text") %></h3>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Detailed_Information_Tab"></a>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec2EIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec2EIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec2SessionStatusTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec2SessionStatusTypeName" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec2DiseaseName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec2DiseaseName" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                    </div>
                                    <asp:UpdatePanel ID="upFarmDetails" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div id="divFarmDetails" runat="server" class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <h3><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Details_Text") %></h3>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                            <label for="<%= txtEIDSSFarmID.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                                            <div id="divFarmLookup" class="input-group">
                                                                <asp:TextBox ID="txtEIDSSFarmID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                <asp:LinkButton ID="btnFarmLookup" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-search" role="button"></span></asp:LinkButton>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                            <label for="<%= txtFarmName.ClientID %>" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Name_Text") %></label>
                                                            <asp:TextBox ID="txtFarmName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <fieldset>
                                                    <legend><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_Text") %></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                <label for="<%= txtEIDSSFarmOwnerID.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_ID_Text") %></label>
                                                                <asp:TextBox ID="txtEIDSSFarmOwnerID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                <label for="<%= txtFarmOwnerLastName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                                                <asp:TextBox ID="txtFarmOwnerLastName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                <label for="<%= txtFarmOwnerFirstName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                                                <asp:TextBox ID="txtFarmOwnerFirstName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                <label for="<%= txtFarmOwnerSecondName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Middle_Name_Text") %></label>
                                                                <asp:TextBox ID="txtFarmOwnerSecondName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <label for="<%= txtPhone.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Phone_Text") %></label>
                                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                            <label for="<%= txtEmail.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Email_Text") %></label>
                                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label runat="server" meta:resourcekey="Lbl_Current_Address"></label>
                                                </div>
                                                <eidss:Location ID="FarmAddress" runat="server" IsHorizontalLayout="true" ShowCountry="true" IsDbRequiredCountry="true" ShowRegion="true" IsDbRequiredRegion="true" ShowRayon="true" IsDbRequiredRayon="true" ShowSettlementType="true" ShowSettlement="true" ShowStreet="true" ShowBuildingHouseApartmentGroup="true" ShowPostalCode="true" ShowElevation="false" ShowMap="true" ShowCoordinates="true" />
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <asp:UpdatePanel ID="upFarmList" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div id="divFarmList" runat="server" class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <h3 class="header"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_List_Text") %></h3>
                                                    </div>
                                                </div>
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvDetailedInfoFarms" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="FarmMasterID" GridLines="None"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" SortExpression="EIDSSFarmID">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnSelectFarm" runat="server" Text='<%# Eval("EIDSSFarmID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("FarmMasterID").ToString() + "," + Eval("EIDSSFarmID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="EIDSSFarmOwnerID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_ID_Text %>" SortExpression="EIDSSFarmOwnerID" />
                                                            <asp:BoundField DataField="FarmName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Name_Text %>" SortExpression="FarmName" />
                                                            <asp:BoundField DataField="FarmOwnerName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_Name_Text %>" SortExpression="FarmOwnerName" />
                                                            <asp:BoundField DataField="FarmAddress" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Address_Text %>" SortExpression="RegionName" />
                                                        </Columns>
                                                    </eidss:GridView>
                                                    <div id="divDetailedInfoFarmPager" class="row grid-footer" runat="server">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                                            <asp:Label ID="lblDetailedInfoFarmRecordCount" runat="server" CssClass="control-label"></asp:Label>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblDetailedInfoFarmPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                            <asp:Repeater ID="rptDetailedInfoFarmPager" runat="server">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkDetailedInfoFarmPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="DetailedInfoFarmPage_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <asp:Button ID="btnFarmSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" CausesValidation="false" />
                                                        <asp:Button ID="btnCancelFarmLookup" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                                    </div>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upFarmInventory" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                    </Triggers>
                                    <ContentTemplate>
                                        <div id="divFarmInventory" runat="server" class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <h3 class="header"><%= GetGlobalResourceObject("Labels", "Lbl_Herd_Flock_Species_Details_Text") %></h3>
                                                    </div>
                                                    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddFlock" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: Buttons, Btn_Add_Flock_ToolTip %>" Text="<%$ Resources: Buttons, Btn_Add_Flock_Text %>" />
                                                        <asp:Button ID="btnAddHerd" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: Buttons, Btn_Add_Herd_ToolTip %>" Text="<%$ Resources: Buttons, Btn_Add_Herd_Text %>" />
                                                    </div>
                                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvFlocksHerds" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped"
                                                        DataKeyNames="RecordID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" GridLines="None" PagerSettings-Visible="false"
                                                        ShowFooter="true" UseAccessibleHeader="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="100%">
                                                                <HeaderTemplate>
                                                                    <div class="col-lg-4">
                                                                        <asp:Label ID="lblHdrSpecies" runat="server" Text="<%$ Resources: Labels, Lbl_Species_Text %>"></asp:Label>
                                                                    </div>
                                                                    <div class="col-lg-3">
                                                                        <asp:Label ID="lblHdrTotalAnimalQty" runat="server" Text="<%$ Resources: Labels, Lbl_Total_Animal_Quantity_Text %>"></asp:Label>
                                                                    </div>
                                                                    <div class="col-lg-5"></div>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <div class="row">
                                                                        <div class="col-lg-4">
                                                                            <asp:Label runat="server" ID="lblEIDSSHerdID" CssClass="form-control"></asp:Label>
                                                                            <asp:HiddenField ID="hdfHerdMasterID" runat="server" Value='<% #Eval("HerdMasterID") %>' />
                                                                        </div>
                                                                        <div class="col-lg-3">
                                                                            <asp:Label runat="server" ID="lblTotalAnimalQuantity" Text='<% #Eval("TotalAnimalQuantity") %>' CssClass="form-control"></asp:Label>
                                                                        </div>
                                                                        <div class="col-lg-4">&nbsp;</div>
                                                                        <div class="col-lg-1">
                                                                            <asp:LinkButton ID="btnAddSpecies" runat="server" CssClass="btn glyphicon glyphicon-plus" CommandName="Add" CommandArgument='<% #Eval("HerdMasterID") %>' CausesValidation="false" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>"></asp:LinkButton>
                                                                            <asp:LinkButton ID="btnDeleteFlockHerd" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("RecordID") %>' CausesValidation="false"></asp:LinkButton>
                                                                        </div>
                                                                    </div>
                                                                    <div class="row">
                                                                        <eidss:GridView ID="gvSpecies" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="SpeciesMasterID"
                                                                            EmptyDataText="" GridLines="None" ShowFooter="False" UseAccessibleHeader="False" OnRowDataBound="Species_RowDataBound" OnRowCommand="Species_RowCommand">
                                                                            <Columns>
                                                                                <asp:TemplateField>
                                                                                    <ItemTemplate>
                                                                                        <asp:UpdatePanel ID="upSpecies" runat="server" UpdateMode="Conditional">
                                                                                            <Triggers>
                                                                                                <asp:AsyncPostBackTrigger ControlID="ddlFarmSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                                                                <asp:AsyncPostBackTrigger ControlID="txtFarmTotalAnimalQuantity" EventName="TextChanged" />
                                                                                            </Triggers>
                                                                                            <ContentTemplate>
                                                                                                <div class="row">
                                                                                                    <div class="col-lg-3">
                                                                                                        <asp:HiddenField ID="hdfSpeciesMasterID" runat="server" Value='<%# Bind("SpeciesMasterID") %>' />
                                                                                                        <eidss:DropDownList ID="ddlFarmSpeciesTypeID" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="FarmSpeciesTypeID_SelectedIndexChanged"></eidss:DropDownList>
                                                                                                    </div>
                                                                                                    <div class="col-lg-3">
                                                                                                        <eidss:NumericSpinner ID="txtFarmTotalAnimalQuantity" runat="server" CssClass="form-control" Text='<% #Bind("TotalAnimalQuantity") %>' MinValue="0" AutoPostBack="true" OnTextChanged="FarmTotalAnimalQuantity_TextChanged"></eidss:NumericSpinner>
                                                                                                        <asp:RequiredFieldValidator ControlToValidate="txtFarmTotalAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Total_Animal_Qty" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                    </div>
                                                                                                    <div class="col-lg-2">
                                                                                                        <asp:LinkButton ID="btnDeleteSpecies" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("SpeciesMasterID") %>' CausesValidation="false"></asp:LinkButton>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </asp:UpdatePanel>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </eidss:GridView>
                                                                    </div>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:UpdatePanel ID="upDetailedAnimalsAndSamples" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnAddSample" EventName="Click" />
                                        <asp:AsyncPostBackTrigger ControlID="btnDeleteSelectedSamples" EventName="Click" />
                                        <asp:AsyncPostBackTrigger ControlID="btnCopySelectedSamples" EventName="Click" />
                                        <asp:AsyncPostBackTrigger ControlID="txtNumberToCopy" EventName="TextChanged" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <h3 runat="server" meta:resourcekey="Hdg_Detailed_Animals_And_Samples"></h3>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                        <asp:Button ID="btnAddSample" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                        <asp:Button ID="btnDeleteSelectedSamples" runat="server" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" />
                                                        <asp:Button ID="btnCopySelectedSamples" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Copy_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Copy_ToolTip %>" />
                                                    </div>
                                                </div>
                                                <div id="divNumberToCopy" runat="server" class="row" visible="false">
                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9"></div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                        <label for="<%= txtNumberToCopy.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Number_To_Copy_Text") %></label>
                                                        <eidss:NumericSpinner ID="txtNumberToCopy" runat="server" CssClass="form-control" MinValue="1" AutoPostBack="true" OnTextChanged="NumberToCopy_TextChanged"></eidss:NumericSpinner>
                                                    </div>
                                                </div>
                                                <div class="row"></div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label class="control-label" for="<%= txtTotalNumberAnimalsSampled.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Total_Number_Of_Animals_Sampled_Text") %></label>
                                                            <asp:TextBox ID="txtTotalNumberAnimalsSampled" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label class="control-label" for="<%= txtTotalNumberSamples.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Total_Number_Of_Samples_Text") %></label>
                                                            <asp:TextBox ID="txtTotalNumberSamples" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvSamples" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="SampleID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkSelectSample" runat="server" CssClass="form-control" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Field_Sample_ID_Text %>" />
                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Labels, Lbl_Animal_ID_Text %>" />
                                                            <asp:BoundField DataField="CollectionDate" HeaderText="<%$ Resources:Labels, Lbl_Collection_Date_Text %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="AccessionConditionTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Condition_Received_Text %>" />
                                                            <asp:BoundField DataField="SentToOrganizationName" HeaderText="<%$ Resources: Labels, Lbl_Sent_To_Organization_Text %>" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditSample" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDeleteSample" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <a id="expandCollapseSampleAliquotDetails" runat="server" style="vertical-align: bottom"><span class="glyphicon glyphicon-triangle-bottom" onclick="showSampleSubGrid(event,'div<%# Eval("SampleID") %>');"></span></a>
                                                                    <tr id="div<%# Eval("SampleID") %>" style="display: none;">
                                                                        <td colspan="100">
                                                                            <div style="position: relative; left: 10px; overflow: auto; overflow-x: hidden; width: 80%;">
                                                                                <asp:Label ID="lblAliquotPlaceholder" CssClass="col-lg-2 col-md-2 col-sm-3 col-xs-6 control-label" runat="server" Text="Aliquots" />
                                                                                <br />
                                                                                <eidss:GridView ID="gvAliquots" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="SampleID" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                                    <HeaderStyle CssClass="table-striped-header" />
                                                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                                    <Columns>
                                                                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                                                        <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                                                        <asp:BoundField DataField="SampleStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>" />
                                                                                        <asp:BoundField DataField="CollectedByOrganizationName" HeaderText="<%$ Resources:Labels, Lbl_Lab_Text %>" />
                                                                                        <asp:BoundField DataField="SentToOrganizationName" HeaderText="<%$ Resources: Labels, Lbl_Functional_Lab_Text %>" />
                                                                                    </Columns>
                                                                                </eidss:GridView>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </section>
                            <section id="TestsResultSummaries" runat="server" class="col-md-12 hidden">
                                <asp:UpdatePanel ID="upTestsResultSummaries" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnAddLabTest" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                                        <h3 runat="server" class="header" meta:resourcekey="Hdg_Detailed_Information_Tests"></h3>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddLabTest" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Test_Information_Tab"></a>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec3EIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec3EIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec3SessionStatusTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec3SessionStatusTypeName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec3DiseaseName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec3DiseaseName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row">&nbsp;</div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvLabTests" runat="server" AllowPaging="True" AllowSorting="False" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="TestID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                            <asp:BoundField DataField="EIDSSFarmID" HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" />
                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Field_Sample_ID_Text %>" />
                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Labels, Lbl_Animal_ID_Text %>" />
                                                            <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                            <asp:BoundField DataField="ResultDate" HeaderText="<%$ Resources: Labels, Lbl_Result_Date_Text %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="TestCategoryTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Category_Text %>" />
                                                            <asp:BoundField DataField="TestStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Status_Text %>" />
                                                            <asp:BoundField DataField="TestResultTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Result_Text %>" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <div class="divDetailsContainer" style="white-space: nowrap; vertical-align: top;">
                                                                        <asp:UpdatePanel ID="upResultSummary" runat="server" UpdateMode="Conditional">
                                                                            <Triggers>
                                                                                <asp:AsyncPostBackTrigger ControlID="btnAddResultSummary" EventName="Click" />
                                                                            </Triggers>
                                                                            <ContentTemplate>
                                                                                <asp:Button ID="btnAddResultSummary" runat="server" CssClass="btn btn-default btn-sm" CommandName="Add Interpretation" CommandArgument='<% #Bind("TestID") %>' CausesValidation="False" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </div>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditLabTest" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("TestID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDeleteLabTest" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("TestID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <h3 runat="server" meta:resourcekey="Hdg_Results_Summary"></h3>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvTestInterpretations" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="TestInterpretationID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundField DataField="EIDSSFarmID" HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" />
                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Labels, Lbl_Animal_ID_Text %>" />
                                                            <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                            <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Field_Sample_ID_Text %>" />
                                                            <asp:BoundField DataField="InterpretedStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Rule_In_Rule_Out_Text %>" />
                                                            <asp:BoundField DataField="ValidatedStatusIndicator" HeaderText="<%$ Resources: Labels, Lbl_Validated_Text %>" />
                                                            <asp:BoundField DataField="ValidatedDate" HeaderText="<%$ Resources: Labels, Lbl_Date_Validated_Text %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="ValidatedByPersonName" HeaderText="<%$ Resources: Labels, Lbl_Validated_By_Text %>" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditResultSummary" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("TestInterpretationID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                    <asp:LinkButton ID="btnDeleteResultSummary" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("TestInterpretationID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </section>
                            <section id="Actions" class="col-md-12 hidden" runat="server">
                                <asp:UpdatePanel ID="upActions" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnAddAction" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                                        <h3 runat="server" meta:resourcekey="Hdg_Actions"></h3>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddAction" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(3, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Actions_Tab"></a>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec4EIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec4EIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec4SessionStatusTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec4SessionStatusTypeName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec4DiseaseName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec4DiseaseName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row">&nbsp;</div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvActions" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="MonitoringSessionActionID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundField DataField="MonitoringSessionActionTypeName" HeaderText="<%$ Resources: Labels, Lbl_Action_Required_Text %>" />
                                                            <asp:BoundField DataField="ActionDate" HeaderText="<%$ Resources: Labels, Lbl_Date_Text %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="PersonName" HeaderText="<%$ Resources: Labels, Lbl_Entered_By_Text %>" />
                                                            <asp:BoundField DataField="Comments" HeaderText="<%$ Resources: Labels, Lbl_Comment_Text %>" />
                                                            <asp:BoundField DataField="MonitoringSessionActionStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Status_Text %>" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditAction" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("MonitoringSessionActionID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                    <asp:LinkButton ID="btnDeleteAction" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("MonitoringSessionActionID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </section>
                            <section id="AggregateInfo" class="col-md-12 hidden" runat="server">
                                <asp:UpdatePanel ID="upAggregateInfos" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnAddAggregateInfo" EventName="Click" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                                        <h3 runat="server" meta:resourcekey="Hdg_Aggregate_Info" class="header"></h3>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddAggregateInfo" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(4, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Aggregate_Info_Tab"></a>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec5EIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec5EIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec5SessionStatusTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec5SessionStatusTypeName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSec5DiseaseName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                        <asp:TextBox CssClass="form-control" ID="txtSec5DiseaseName" runat="server" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row">&nbsp;</div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvAggregateInfos" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="MonitoringSessionSummaryID"
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundField DataField="EIDSSFarmID" HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" />
                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                            <asp:BoundField DataField="AnimalGenderTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sex_Text %>" />
                                                            <asp:BoundField DataField="SampledAnimalsQuantity" HeaderText="<%$ Resources: Labels, Lbl_Animals_Sampled_Text %>" />
                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                            <asp:BoundField DataField="SamplesQuantity" HeaderText="<%$ Resources: Labels, Lbl_Number_Of_Samples_Text %>" />
                                                            <asp:BoundField DataField="CollectionDate" HeaderText="<%$ Resources: Labels, Lbl_Collection_Date_Text %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="PositiveAnimalsQuantity" HeaderText="<%$ Resources: Labels, Lbl_Positive_Number_Text %>" />
                                                            <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditAggregateInfo" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("MonitoringSessionSummaryID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                    <asp:LinkButton ID="btnDeleteAggregateInfo" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("MonitoringSessionSummaryID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </section>
                            <section id="DiseaseReports" class="col-md-12 hidden" runat="server">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                <h3 class="heading" id="DiseaseReportsHdg" runat="server" meta:resourcekey="Hdg_Disease_Report"></h3>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-xs-3 col-xs-3 text-right">
                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(5, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Disease_Report_Tab"></a>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec6EIDSSSessionID" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_ID_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec6EIDSSSessionID" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec6SessionStatusTypeName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Session_Status_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec6SessionStatusTypeName" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                <label for="txtSec6DiseaseName" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                                <asp:TextBox CssClass="form-control" ID="txtSec6DiseaseName" runat="server" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <eidss:GridView ID="gvVeterinaryDiseaseReports" meta:resourcekey="Grd_Disease_Reports" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top"
                                                CssClass="table table-striped" DataKeyNames="VeterinaryDiseaseReportID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:BoundField DataField="EIDSSReportID" HeaderText="<%$ Resources: Labels, Lbl_Report_ID_Text %>" SortExpression="DiseaseReportID" />
                                                    <asp:BoundField DataField="CaseClassificationTypeName" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" SortExpression="CaseClassification" />
                                                    <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" SortExpression="Disease" />
                                                    <%--<asp:BoundField DataField="Location" meta:resourcekey="Grd_Disease_Reports_Location_Header" SortExpression="Location" />--%>
                                                    <asp:BoundField DataField="FarmAddressString" HeaderText="<%$ Resources: Labels, Lbl_Address_Text %>" SortExpression="Address" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnEditVeterinaryDiseaseReport" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("VeterinaryDiseaseReportID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                            <asp:LinkButton ID="btnDeleteVeterinaryDiseaseReport" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("VeterinaryDiseaseReportID") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>
                        <eidss:SideBarNavigation ID="VeterinaryActiveSurveillanceSessionSideBarPanel" runat="server">
                            <MenuItems>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiSessionInformation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Session_Information" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiDetailedInformation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Detailed_Information" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiDetailedTests" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Test_Information" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiActions" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Actions" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiAggregateInfo" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Aggregate_Info" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiDiseaseReports" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_DiseaseReports" runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem CssClass="glyphicon glyphicon-file" ID="sbiReview" IsActive="true" ItemStatus="IsReview" meta:resourcekey="Tab_Review" runat="server"></eidss:SideBarItem>
                            </MenuItems>
                        </eidss:SideBarNavigation>
                        <div class="row text-center">
                            <div runat="server" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <asp:Button ID="btnCancel" CssClass="btn btn-default" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                <asp:Button ID="btnSubmit" CssClass="btn btn-primary" runat="server" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" />
                                <asp:Button ID="btnDelete" CssClass="btn btn-primary" runat="server" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:HiddenField runat="server" Value="0" ID="hdfVeterinaryActiveSurveillanceSessionPanelController" />
        </div>
    </div>
    <div id="divSearchFarmModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchFarmModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchFarmModal')">&times;</button>
                <h4 id="hdgSearchFarm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Farm_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchFarm ID="ucSearchFarm" runat="server" RecordMode="Select" />
            </div>
        </div>
    </div>
    <div id="divSampleModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divAggregateInfoModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Detailed_Animal_And_Sample"></h4>
            </div>
            <asp:UpdatePanel ID="upSampleModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlSampleFarmID" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="btnSampleSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnSampleCancel" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divSampleForm" class="modal-body" runat="server">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Sample_Type" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Sample_Type" runat="server"></span>
                                    <label for="ddlSampleSampleTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleSampleTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Sample_Type" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server"></span>
                                    <label for="txtSampleEIDSSLocalOrFieldSampleID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Field_Sample_ID_Text") %></label>
                                    <asp:TextBox ID="txtSampleEIDSSLocalOrFieldSampleID" runat="server" MaxLength="200" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleEIDSSLocalOrFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Farm" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Farm_ID" runat="server"></span>
                                    <label for="ddlSampleFarmID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleFarmID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleFarmID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Farm_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Species" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Species" runat="server"></span>
                                    <label for="ddlSampleSpeciesID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleSpeciesID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Species" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" runat="server" id="divSampleAnimalContainer1">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_ID" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_ID" runat="server"></span>
                                    <label for="ddlSampleAnimalID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Animal_ID_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleAnimalID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Name" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Name" runat="server"></span>
                                    <label for="txtSampleAnimalName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Name_Text") %></label>
                                    <asp:TextBox ID="txtSampleAnimalName" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleAnimalName" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Name" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" runat="server" id="divSampleAnimalContainer2">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Age" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Age" runat="server"></span>
                                    <label for="ddlSampleAnimalAgeTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Age_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleAnimalAgeTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleAnimalAgeTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Age" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Gender" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Gender" runat="server"></span>
                                    <label for="ddlSampleAnimalGenderTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sex_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleAnimalGenderTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleAnimalGenderTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Gender" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Color" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Color" runat="server"></span>
                                    <label for="txtSampleAnimalColor" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Color_Text") %></label>
                                    <asp:TextBox ID="txtSampleAnimalColor" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleAnimalColor" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Color" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Collection_Date" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Collection_Date" runat="server"></span>
                                    <label for="txtSampleCollectionDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Collection_Date_Text") %></label>
                                    <eidss:CalendarInput ID="txtSampleCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" MaxDate='<%# Date.Today %>'></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Detailed_Animals_And_Samples_Collection_Date" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cmvFutureCollectionDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtSampleCollectionDate" meta:resourcekey="Val_Detailed_Animals_And_Samples_Future_Collection_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="SamplesSection" SetFocusOnError="True"></asp:CompareValidator>
                                    <asp:CompareValidator ID="cmvSessionStartDateRange" runat="server" ControlToValidate="txtSampleCollectionDate" ControlToCompare="txtStartDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Detailed_Animals_And_Samples_Collection_Date_Session_Start_Date_Range" CultureInvariantValues="true" ValidationGroup="SamplesSection" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                    <asp:CompareValidator ID="cmvSessionEndDateRange" runat="server" ControlToValidate="txtSampleCollectionDate" ControlToCompare="txtEndDate" Enabled="false" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Detailed_Animals_And_Samples_Collection_Date_Session_End_Date_Range" CultureInvariantValues="true" ValidationGroup="SamplesSection" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Condition_Received" runat="server"></span>
                                    <label for="txtSampleAccessionComment" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Condition_Received_Text") %></label>
                                    <asp:TextBox ID="txtSampleAccessionComment" runat="server" CssClass="form-control" MaxLength="200" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleAccessionComment" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Condition_Received" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Comment" runat="server"></span>
                                    <label for="txtSampleNote" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Comments_Text") %></label>
                                    <asp:TextBox ID="txtSampleNote" runat="server" CssClass="form-control" MaxLength="500" Enabled="false" TextMode="MultiLine"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleNote" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Comment" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Sent_To_Organization" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Sent_To_Organization" runat="server"></span>
                                    <label for="ddlSampleSentToOrganizationID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sent_To_Organization_Text") %></label>
                                    <eidss:DropDownList ID="ddlSampleSentToOrganizationID" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleSentToOrganizationID" CssClass="alert-danger" InitialValue="" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Sent_To_Organization" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnSampleSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" ValidationGroup="SamplesSection" />
                            <asp:Button ID="btnSampleCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divLabTestModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divLabTestModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Detailed_Information_Tests"></h4>
            </div>
            <asp:UpdatePanel ID="upLabTestModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlLabTestSampleID" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="chkFilterByDisease" EventName="CheckedChanged" />
                    <asp:AsyncPostBackTrigger ControlID="chkFilterByTestName" EventName="CheckedChanged" />
                    <asp:AsyncPostBackTrigger ControlID="btnLabTestCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnLabTestSave" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divTestForm" class="modal-body" runat="server">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Field_Sample_ID" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Field_Sample_ID" runat="server"></span>
                                    <label for="ddlLabTestSampleID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Field_Sample_ID_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlLabTestSampleID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlLabTestSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Field_Sample_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Lab_Sample_ID" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Lab_Sample_ID" runat="server"></span>
                                    <label for="txtLabTestEIDSSLaboratorySampleID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Lab_Sample_ID_Text") %></label>
                                    <asp:TextBox ID="txtLabTestEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Lab_Sample_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Sample_Type" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Sample_Type" runat="server"></span>
                                    <label for="txtLabTestSampleTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                    <asp:TextBox ID="txtLabTestSampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestSampleTypeName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Sample_Type" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Farm_ID" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Farm_ID" runat="server"></span>
                                    <label for="txtLabTestEIDSSFarmID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                    <asp:TextBox ID="txtLabTestEIDSSFarmID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSFarmID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Farm_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Animal_ID" runat="server" id="divTestAnimalContainer">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Animal_ID" runat="server"></span>
                                    <label for="txtLabTestEIDSSAnimalID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Animal_ID_Text") %></label>
                                    <asp:TextBox ID="txtLabTestEIDSSAnimalID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Animal_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <asp:CheckBox ID="chkFilterByDisease" runat="server" CssClass="form-control" AutoPostBack="true" Checked="true" Text="<%$ Resources: Labels, Lbl_Filter_By_Disease_Text %>" />
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Name" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Name" runat="server"></span>
                                    <label for="ddlLabTestTestNameTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Name_Text") %></label>
                                    <eidss:DropDownList ID="ddlLabTestTestNameTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Disease" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Disease" runat="server"></span>
                                    <label for="txtLabTestDiseaseName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Disease_Text") %></label>
                                    <asp:TextBox ID="txtLabTestDiseaseName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestDiseaseName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Test_Disease" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <asp:CheckBox ID="chkFilterByTestName" runat="server" CssClass="form-control" AutoPostBack="true" Checked="true" Text="<%$ Resources: Labels, Lbl_Filter_By_Test_Name_Text %>" />
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Status" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Status" runat="server"></span>
                                    <label for="txtLabTestTestStatusTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Status_Text") %></label>
                                    <asp:TextBox ID="txtLabTestTestStatusTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestTestStatusTypeName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Test_Status" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Category" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Category" runat="server"></span>
                                    <label for="ddlLabTestTestCategoryTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Category_Text") %></label>
                                    <eidss:DropDownList ID="ddlLabTestTestCategoryTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Result_Date" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result_Date" runat="server"></span>
                                    <label for="txtLabTestResultDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Result_Date_Text") %></label>
                                    <eidss:CalendarInput ID="txtLabTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestResultDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Result_Date" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cmvFutureResultDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtLabTestResultDate" meta:resourcekey="Val_Test_Future_Result_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="TestSection" SetFocusOnError="True"></asp:CompareValidator>
                                    <asp:CompareValidator ID="cmvTestResultDateCollectionDate" runat="server" ControlToValidate="txtLabTestResultDate" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Test_Result_Date_Collection_Date_Range" CultureInvariantValues="true" ValidationGroup="TestSection" Operator="GreaterThanEqual"></asp:CompareValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Result_Observation" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result_Observation" runat="server"></span>
                                    <label for="ddlLabTestTestResultTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Result_Text") %></label>
                                    <eidss:DropDownList ID="ddlLabTestTestResultTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnLabTestSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" ValidationGroup="TestSection" />
                            <asp:Button ID="btnLabTestCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divResultSummaryModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divResultSummaryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Results_Summary"></h4>
                <asp:HiddenField ID="hdfTestID" runat="server" Value="" />
            </div>
            <asp:UpdatePanel ID="upResultSummaryModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnResultSummaryCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnResultSummarySave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="ddlResultSummaryInterpretedStatusTypeID" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="chkResultSummaryValidatedStatusIndicator" EventName="CheckedChanged" />
                </Triggers>
                <ContentTemplate>
                    <div id="divResultSummaryForm" class="modal-body" runat="server">
                        <div class="form-group" meta:resourcekey="Dis_Result_Summary_Farm_ID" runat="server">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <label for="txtResultSummaryEIDSSFarmID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryEIDSSFarmID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <label for="txtResultSummarySpeciesTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                    <asp:TextBox ID="txtResultSummarySpeciesTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Animal" runat="server" id="divResultSummaryAnimalContainer">
                                    <label for="txtResultSummaryEIDSSAnimalID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Animal_ID_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryEIDSSAnimalID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Lab_Sample_ID" runat="server">
                                    <label for="txtResultSummaryEIDSSLaboratorySampleID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Lab_Sample_ID_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Sample_Type" runat="server">
                                    <label for="txtResultSummarySampleTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                    <asp:TextBox ID="txtResultSummarySampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <label for="txtResultSummaryEIDSSLocalOrFieldSampleID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Field_Sample_ID_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryEIDSSLocalOrFieldSampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Disease" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Test_Disease" runat="server"></span>
                                    <label for="txtResultSummaryDiseaseName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryDiseaseName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Name" runat="server">
                                    <label for="txtResultSummaryTestTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Name_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryTestTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Category" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Test_Category" runat="server"></span>
                                    <label for="txtResultSummaryTestCategoryTypeName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Category_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryTestCategoryTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Rule_Out_Rule_In" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Rule_Out_Rule_In" runat="server"></span>
                                    <label for="ddlResultSummaryInterpretedStatusTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Rule_In_Rule_Out_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlResultSummaryInterpretedStatusTypeID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlResultSummaryInterpretedStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Result_Summary_Rule_In_Rule_Out" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Date_Interpreted" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Date_Interpreted" runat="server"></span>
                                    <label for="txtResultSummaryInterpretedDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Interpreted_Text") %></label>
                                    <eidss:CalendarInput ID="txtResultSummaryInterpretedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryInterpretedDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Date_Interpreted" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Interpreted_By" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Interpreted_By" runat="server"></span>
                                    <label for="txtResultSummaryInterpretedByPersonName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Interpreted_By_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryInterpretedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:HiddenField ID="hdfResultSummaryInterpretedByPersonID" runat="server" Value="null" />
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryInterpretedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Interpreted_By" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Result_Summary_Interpreted_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Interpreted_Comment" runat="server"></span>
                                    <label for="txtResultSummaryInterpretedComment" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Interpreted_Comment_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryInterpretedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false" TextMode="MultiLine"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryInterpretedComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Interpreted_Comment" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Validated" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated" runat="server"></span>
                                    <asp:CheckBox ID="chkResultSummaryValidatedStatusIndicator" runat="server" meta:resourcekey="Lbl_Validated" AutoPostBack="true" CssClass="checkbox-inline" />
                                    <%-- <asp:RequiredFieldValidator ControlToValidate="chkInterpretationblnValidateStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Validated" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>--%>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Date_Validated" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Date_Validated" runat="server"></span>
                                    <label for="txtResultSummaryValidatedDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Validated_Text") %></label>
                                    <eidss:CalendarInput ID="txtResultSummaryValidatedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryValidatedDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Date_Validated" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Validated_By" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated_By" runat="server"></span>
                                    <label for="txtResultSummaryValidatedByPersonName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Validated_By_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryValidatedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:HiddenField ID="hdfResultSummaryValidatedByPersonID" runat="server" Value="null" />
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryValidatedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Validated_By" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Result_Summary_Validated_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated_Comment" runat="server"></span>
                                    <label for="txtResultSummaryValidatedComment" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Validated_Comment_Text") %></label>
                                    <asp:TextBox ID="txtResultSummaryValidatedComment" runat="server" MaxLength="200" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryValidatedComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Validated_Comment" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:Button ID="btnResultSummarySave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="ResultSummarySection"></asp:Button>
                        <asp:Button ID="btnResultSummaryCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        <asp:LinkButton ID="btnCreateDiseaseReport" runat="server" CssClass="btn btn-default" CausesValidation="false"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;<span><%= GetLocalResourceObject("Btn_Add_Disease_Report.Text") %></span></asp:LinkButton>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divActionModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divActionModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Actions"></h4>
            </div>
            <asp:UpdatePanel ID="upActionModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnActionCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnActionSave" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divActionForm" class="modal-body" runat="server">
                        <div class="form-group" meta:resourcekey="Dis_Action_Required" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Required" runat="server"></span>
                                    <label for="ddlActionMonitoringSessionActionTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Action_Required_Text") %></label>
                                    <eidss:DropDownList ID="ddlActionMonitoringSessionActionTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Action_Date" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Date" runat="server"></span>
                                    <label for="txtActionActionDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Text") %></label>
                                    <eidss:CalendarInput ID="txtActionActionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtActionActionDate" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Action_Date" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Action_Entered_By" runat="server">
                                    <label for="txtActionEnteredByPersonName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Entered_By_Text") %></label>
                                    <asp:TextBox ID="txtActionEnteredByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Action_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Comment" runat="server"></span>
                                    <label for="txtActionComments" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Comment_Text") %></label>
                                    <asp:TextBox ID="txtActionComments" runat="server" CssClass="form-control" MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtActionComments" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Action_Comment" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Action_Status" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Status" runat="server"></span>
                                    <label for="ddlActionMonitoringSessionActionStatusTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Status_Text") %></label>
                                    <asp:DropDownList ID="ddlActionMonitoringSessionActionStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlActionMonitoringSessionActionStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Action_Status" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnActionSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="ActionSection"></asp:Button>
                            <asp:Button ID="btnActionCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divAggregateInfoModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divAggregateInfoModal">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Aggregate_Info"></h4>
            </div>
            <asp:UpdatePanel ID="upAggregateInfo" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAggregateInfoCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnAggregateInfoSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnAggregateInfoFarmLookup" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="txtSamplesQuantity" EventName="TextChanged" />
                </Triggers>
                <ContentTemplate>
                    <div class="modal-body">
                        <div class="form-group" meta:resourcekey="Dis_Aggregate_Info_Farm_ID" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Farm_ID" runat="server"></span>
                                    <label for="txtAggregateInfoEIDSSFarmID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                    <asp:HiddenField ID="hdfAggregateInfoFarmMasterID" runat="server" Value="" />
                                    <div id="divAggregateInfoFarmLookup" class="input-group">
                                        <asp:TextBox ID="txtAggregateInfoEIDSSFarmID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        <asp:LinkButton ID="btnAggregateInfoFarmLookup" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-search" role="button"></span></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Species" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Species" runat="server"></span>
                                    <label for="ddlAggregateInfoSpeciesID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoSpeciesID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Species" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Animal_Sex" runat="server" id="divAggregateInfoAnimalContainer">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Animal_Sex" runat="server"></span>
                                    <label for="ddlAggregateInfoAnimalGenderTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sex_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoAnimalGenderTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoAnimalGenderTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Animal_Sex" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Animals_Sampled" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Animals_Sampled" runat="server"></span>
                                    <label for="txtSampledAnimalsQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Animals_Sampled_Text") %></label>
                                    <eidss:NumericSpinner ID="txtSampledAnimalsQuantity" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampledAnimalsQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Aggregate_Info_Animals_Sampled" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Number_Of_Samples" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Number_Of_Samples" runat="server"></span>
                                    <label for="txtSamplesQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Number_Of_Samples_Text") %></label>
                                    <eidss:NumericSpinner ID="txtSamplesQuantity" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:NumericSpinner>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSamplesQuantity" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Number_Of_Samples" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Positive_Animals" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Positive_Animals" runat="server"></span>
                                    <label for="txtPositiveAnimalsQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Positive_Number_Text") %></label>
                                    <eidss:NumericSpinner ID="txtPositiveAnimalsQuantity" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                    <asp:RequiredFieldValidator ControlToValidate="txtPositiveAnimalsQuantity" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Positive_Animals" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Sample_Type" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Sample_Type" runat="server"></span>
                                    <label for="ddlAggregateInfoSampleTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoSampleTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Sample_Type" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Collection_Date" runat="server">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Collection_Date" runat="server"></span>
                                    <label for="txtAggregateInfoCollectionDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Collection_Date_Text") %></label>
                                    <eidss:CalendarInput ID="txtAggregateInfoCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" MaxDate='<%# Date.Today %>'></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtAggregateInfoCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Collection_Date" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Aggregate_Info_Disease" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <span class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Disease" runat="server"></span>
                                    <label for="ddlAggregateInfoDiseaseID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoDiseaseID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoDiseaseID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Disease" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnAggregateInfoSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="AggregateInfoSection"></asp:Button>
                            <asp:Button ID="btnAggregateInfoCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divAggregateInfoLookupFarmModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divAggregateInfoLookupFarmModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAggregateInfoLookupFarmModal')">&times;</button>
                <h4 id="hdgAggregateInfoSearchFarm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Farm_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upAggregateInfoFarms" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <eidss:GridView ID="gvAggregateInfoFarms" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="FarmMasterID" GridLines="None"
                                EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="true" UseAccessibleHeader="true" PagerSettings-Visible="false">
                                <HeaderStyle CssClass="table-striped-header" />
                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>" SortExpression="EIDSSFarmID">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnSelectFarm" runat="server" Text='<%# Eval("EIDSSFarmID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("FarmMasterID").ToString() + "," + Eval("EIDSSFarmID") %>' CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EIDSSFarmOwnerID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_ID_Text %>" SortExpression="EIDSSFarmOwnerID" />
                                    <asp:BoundField DataField="FarmName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Name_Text %>" SortExpression="FarmName" />
                                    <asp:BoundField DataField="FarmOwnerName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Owner_Name_Text %>" SortExpression="FarmOwnerName" />
                                    <asp:BoundField DataField="FarmAddress" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Address_Text %>" SortExpression="RegionName" />
                                </Columns>
                            </eidss:GridView>
                            <div id="divAggregateInfoFarmPager" class="row grid-footer" runat="server">
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                    <asp:Label ID="lblAggregateInfoFarmRecordCount" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblAggregateInfoFarmPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptAggregateInfoFarmPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkAggregateInfoFarmPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="AggregateInfoFarmPage_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                <asp:Button ID="btnCancelAggregateInfoFarmLookup" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="hideModal('#divAggregateInfoLookupFarmModal'); return false;" />
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSearchCampaignModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchCampaignModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchCampaignModal')">&times;</button>
                <h4 id="hdgSearchCampaign" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Veterinary_Campaign_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchVeterinaryCampaign ID="ucSearchVeterinaryCampaign" runat="server" RecordMode="Select" />
            </div>
        </div>
    </div>
    <div id="divAddUpdateFarmModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divAddUpdateFarmModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAddUpdateFarmModal')">&times;</button>
                <h4 id="hdgAddUpdateFarm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Add_Update_Farm_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upAddUpdateFarm" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <eidss:AddUpdateFarm ID="ucAddUpdateFarm" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSearchPersonModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divSearchPersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 id="hdgSearchPerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <div class="form-group">
                    <asp:UpdatePanel ID="upSearchPerson" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <eidss:SearchPerson ID="ucSearchPerson" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <div id="divAddUpdatePersonModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divAddUpdatePersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 id="hdgAddUpdatePerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Add_Update_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <div class="form-group">
                    <asp:UpdatePanel ID="upAddUpdatePerson" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <eidss:AddUpdatePerson ID="ucAddUpdatePerson" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <div id="divSearchCancelModal" class="modal" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Active_Surveillance_Session"></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                        </div>
                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                            <p runat="server" meta:resourcekey="Lbl_Cancel_Search"></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <a class="btn btn-primary" runat="server" href="~/Dashboard.aspx" title="<%$ Resources: Buttons, Btn_Yes_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_Yes_Text") %></a>
                    <input type="button" class="btn btn-default" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>" value="<%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %>" />
                </div>
            </div>
        </div>
    </div>
    <div id="divCancelModalContainer" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="panel-heading">
                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Cancel_Disease_Report"></h4>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-alert modal-icon"></span></div>
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <p runat="server" meta:resourcekey="Lbl_Cancel_Disease_Report"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <asp:Button ID="btnCancelYes" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                    <button type="button" class="btn btn-default" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                </div>
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
                                <asp:Button ID="btnReturnToMonitoringSession" runat="server" CssClass="btn btn-primary" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Session_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Session_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
                                <asp:Button ID="btnReturnToCampaign" runat="server" CssClass="btn btn-default" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Campaign_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Return_To_Active_Surveillance_Campaign_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
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
    <div id="divWarningModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
        <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
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
                        <div class="panel-heading" style="background-color: transparent;">
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
    <script type="text/javascript">
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
            var section = document.getElementById("EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm");
            if (section != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));
            }
        });

        function callBackHandler() {
            var section = document.getElementById("EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm");
            if (section != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));
            }

            var farmSection = document.getElementById("EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm");
            if (farmSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));
            }

            var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");
            if (personSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
            }
        };

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0) {
                showModal(modalID);
            }
            else {
                showModalOnModal(modalID);
            }
        };

        function showModal(modalID) {
            //var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            $("body").addClass("modal-open");
            //bd.appendTo(document.body);
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');
        };

        function hideModal(modalID) {
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };

        function hideModalAndWarningModal(modalID) {
            $('#divWarningModal').modal('hide');
            $(modalID).modal('hide');
        };

        function hideModalShowModal(hideModalID, showModalID) {
            $(hideModalID).modal('hide');

            $(showModalID).modal({ show: true });
        };

        function showProcessing(button) {
            var btn = $("#" + button.id);

            btn.button('loading');
        };

        function showAge() {
            var txtDateOfBirth = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtDateOfBirth");

            if (txtDateOfBirth.value != '') {
                var today = new Date();
                var dob = txtDateOfBirth.value;
                var BD = new Date(dob);

                var dateDiff = Math.abs((today.getTime() - BD.getTime()) / (1000 * 3600 * 24));
                dateDiff = Math.floor(dateDiff);

                if (dateDiff <= 30)
                    document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042001';
                else if (dateDiff > 30 && dateDiff < 365) {
                    document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042002';
                    dateDiff = Math.floor(dateDiff / 30);
                }
                else {
                    document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042003';
                    dateDiff = Math.floor(dateDiff / 365);
                }

                document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").value = dateDiff;

                document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").disabled = true;
                document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").disabled = true;
            }
            else {
                document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").disabled = false;
                document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").disabled = false;
            }
        };

        function validateFarmType(sender, args) {
            var radioButtonList = document.getElementById(sender.controltovalidate);
            var radioButtons = radioButtonList.getElementsByTagName("input");
            var isValid = false;
            for (var i = 0; i < radioButtons.length; i++) {
                if (radioButtons[i].checked) {
                    isValid = true;
                    break;
                }
            }
            args.IsValid = isValid;
        };
    </script>
</asp:Content>
