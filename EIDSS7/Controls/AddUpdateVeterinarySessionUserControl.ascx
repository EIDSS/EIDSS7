<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateVeterinarySessionUserControl.ascx.vb" Inherits="EIDSS.AddUpdateVeterinarySessionUserControl" %>

<%@ Register Src="~/Controls/DropDownAdd.ascx" TagPrefix="eidss" TagName="DropDownAdd" %>
<%@ Register Src="~/Controls/DropDownSearch.ascx" TagPrefix="eidss" TagName="DropDownSearch" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<div id="divHiddenFieldsSection" runat="server">
    <asp:HiddenField runat="server" ID="hdfidfMonitoringSession" Value="-1" />
    <asp:HiddenField runat="server" ID="hdfidfVetCase" Value="NULL" />
    <asp:HiddenField runat="server" ID="hdfidfFarm" Value="" />
    <asp:HiddenField runat="server" ID="hdfstrFarmCode" Value="" />
    <asp:HiddenField runat="server" ID="hdfidfCampaign" Value="" />
    <asp:HiddenField runat="server" ID="hdfidfFarmActual" Value="" />
    <asp:HiddenField runat="server" ID="hdfRecordID" Value="0" />
    <asp:HiddenField runat="server" ID="hdfRecordAction" Value="" />
    <asp:HiddenField runat="server" ID="hdfIdentity" Value="0" />
    <asp:HiddenField runat="server" ID="hdfidfPerson" Value="null" />
    <asp:HiddenField runat="server" ID="hdfstrUserName" Value="null" />
    <asp:HiddenField runat="server" ID="hdfidfPersonEnteredBy" Value="null" />
    <asp:HiddenField runat="server" ID="hdfidfsSite" Value="null" />
    <asp:HiddenField runat="server" ID="hdfstrLoginOrganization" Value="null" />
    <asp:HiddenField runat="server" ID="hdfintRowStatus" Value="0" />
    <asp:HiddenField runat="server" ID="hdfAvianOrLivestock" Value="" />
    <asp:HiddenField runat="server" ID="hdfReferenceTypeName" Value="Diagnoses Groups" />
    <asp:HiddenField runat="server" ID="hdfintHACode" Value="" />
    <asp:HiddenField runat="server" ID="hdfCampaignModule" Value="Vet" />
    <asp:HiddenField runat="server" ID="hdfSessionCategoryID" Value="10169002" />
    <asp:HiddenField runat="server" ID="hdfMonitoringSessionidfsCountry" Value="null" />
</div>
<div id="divFarmSearchContainer" runat="server">
    <asp:HiddenField runat="server" ID="hdfSearchFarmType" Value="null" />
    <asp:HiddenField runat="server" ID="hdfsearchFormidfsRegion" Value="null" />
    <asp:HiddenField runat="server" ID="hdfsearchFormidfsRayon" Value="null" />
    <asp:HiddenField runat="server" ID="hdfsearchFormidfsSettlement" Value="null" />
</div>
<div id="divLabModuleFields" runat="server">
    <asp:HiddenField runat="server" ID="hdfidfRootMaterial" Value="NULL" />
</div>
<div id="divVeterinaryActiveSurveillanceSessionForm" class="embed-panel" runat="server">
    <div class="panel panel-default">
        <div class="panel-heading" role="tab">
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col-lg-10">
                        <h3 class="heading" id="hdgSessionInformation" meta:resourcekey="Hdg_Session_Information" runat="server"></h3>
                    </div>
                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                        <a id="surveillanceSessionSummaryCollapsible" data-toggle="collapse" data-parent="#surveillanceSessionSummary" href="#surveillanceSessionSummaryDetail" role="button" aria-expanded="false" aria-controls="surveillanceSessionSummaryDetail">
                            <span class="glyphicon glyphicon-triangle-bottom"></span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="surveillanceSessionSummaryDetail" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
            <div class="panel-body">
                <div id="sessionSummary" runat="server">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_ID" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_ID" runat="server"></div>
                                <asp:Label AssociatedControlID="txtstrMonitoringSessionID" CssClass="control-label" meta:Resourcekey="Lbl_Session_ID" runat="server"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtstrMonitoringSessionID" runat="server" Enabled="false"></asp:TextBox>
                                <asp:RequiredFieldValidator ControlToValidate="txtstrMonitoringSessionID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_ID" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Session_Status" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_Status" runat="server"></div>
                                <asp:Label AssociatedControlID="ddlidfsMonitoringSessionStatus" CssClass="control-label" meta:Resourcekey="Lbl_Session_Status" runat="server"></asp:Label>
                                <asp:DropDownList CssClass="form-control" ID="ddlidfsMonitoringSessionStatus" runat="server"></asp:DropDownList>
                                <asp:RequiredFieldValidator ControlToValidate="ddlidfsMonitoringSessionStatus" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_Status" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <fieldset>
                        <legend runat="server" meta:resourcekey="Lbl_Campaign_Information"></legend>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Campaign_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtstrCampaignID" CssClass="control-label" meta:Resourcekey="Lbl_Campaign_ID" runat="server"></asp:Label>
                                    <div id="divSearchCampaignContainer" class="input-group" runat="server">
                                        <asp:LinkButton ID="lnbSearchCampaign" runat="server" CssClass="input-group-addon"><span class="glyphicon glyphicon-search" role="button"></span></asp:LinkButton>
                                        <asp:TextBox ID="txtstrCampaignID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    </div>
                                    <asp:RequiredFieldValidator ControlToValidate="txtstrCampaignID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_ID" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Campaign_Name" runat="server">
                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Campaign_Name" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtstrCampaignName" CssClass="control-label" meta:Resourcekey="Lbl_Campaign_Name" runat="server"></asp:Label>
                                    <asp:TextBox CssClass="form-control" ID="txtstrCampaignName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtstrCampaignName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Campaign_Name" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Campaign_Information_Campaign_Type" runat="server">
                                    <div class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="Req_Campaign_Type" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlidfsCampaignType" CssClass="control-label" meta:resourcekey="Lbl_Campaign_Information_Dis_Campaign_Information_Campaign_Type" runat="server"></asp:Label>
                                    <asp:DropDownList CssClass="form-control" ID="ddlidfsCampaignType" runat="server"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlidfsCampaignType" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Campaign_Information_Dis_Campaign_Information_Campaign_Type" runat="server" ValidationGroup="CampaignInfo"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Session_Start_Date" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_Start_Date" runat="server"></div>
                                <asp:Label AssociatedControlID="txtdatCampaignDateStart" CssClass="control-label" meta:Resourcekey="Lbl_Session_Start_Date" runat="server"></asp:Label>
                                <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtdatCampaignDateStart" runat="server"></eidss:CalendarInput>
                                <asp:RequiredFieldValidator ControlToValidate="txtdatCampaignDateStart" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_Start_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="Dis_Session_End_Date" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Session_End_Date" runat="server"></div>
                                <asp:Label AssociatedControlID="txtdatCampaignDateEND" CssClass="control-label" meta:Resourcekey="Lbl_Session_End_Date" runat="server"></asp:Label>
                                <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtdatCampaignDateEND" runat="server"></eidss:CalendarInput>
                                <asp:RequiredFieldValidator ControlToValidate="txtdatCampaignDateEND" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_End_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="cmpCampaignDate" runat="server" ControlToValidate="txtdatCampaignDateEND" ControlToCompare="txtdatCampaignDateStart" Display="Dynamic" CssClass="text-danger" meta:resourceKey="Val_Session_End_Date_Range" CultureInvariantValues="true" ValidationGroup="sessionInfo" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Site" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Site" runat="server"></div>
                                <asp:Label AssociatedControlID="txtSiteName" CssClass="control-label" meta:Resourcekey="Lbl_Site" runat="server"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtSiteName" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ControlToValidate="txtSiteName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Site" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Officer" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Officer" runat="server"></div>
                                <asp:Label AssociatedControlID="txtPersonEnteredByName" CssClass="control-label" meta:resourceKey="Lbl_Officer" runat="server"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtPersonEnteredByName" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ControlToValidate="txtPersonEnteredByName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Officer" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" meta:resourcekey="Dis_Date" runat="server">
                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date" runat="server"></div>
                                <asp:Label AssociatedControlID="txtdatEnteredDate" CssClass="control-label" meta:Resourcekey="Lbl_Date_Entered" runat="server"></asp:Label>
                                <eidss:CalendarInput ContainerCssClass="input-group datepicker" CssClass="form-control" ID="txtdatEnteredDate" runat="server"></eidss:CalendarInput>
                                <asp:RequiredFieldValidator ControlToValidate="txtdatEnteredDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Date" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="sectionContainer expanded" id="divSectionContainer" runat="server">
        <section id="SessionInformation" runat="server" class="col-md-12">
            <asp:UpdatePanel ID="upSessionInformation" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAddSpeciesAndSample" EventName="ServerClick" />
                    <asp:AsyncPostBackTrigger ControlID="ddlidfsDiagnosis" EventName="SelectedIndexChanged" />
                    <asp:PostBackTrigger ControlID="btnSpeciesAndSampleOK" />
                    <asp:PostBackTrigger ControlID="btnCopySample" />
                </Triggers>
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                    <h3 class="heading" runat="server" meta:resourcekey="Lbl_Session_Location"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Session_Location_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <eidss:LocationUserControl ID="MonitoringSessionAddress" runat="server" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" IsHorizontalLayout="true" />
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                    <h3 class="heading" runat="server" meta:resourcekey="Hdg_Diseases_And_Species_List"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                    <input type="submit" id="btnAddSpeciesAndSample" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" meta:resourcekey="Dis_Disease" runat="server">
                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Disease" runat="server"></div>
                                        <asp:Label AssociatedControlID="ddlidfsDiagnosis" CssClass="control-label" meta:Resourcekey="Lbl_Disease" runat="server"></asp:Label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlidfsDiagnosis" runat="server" AutoPostBack="true" eidssJsIgnore="true"></eidss:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlidfsDiagnosis" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Disease" runat="server" ValidationGroup="SessionInfo"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="divAvianLiveStock" visible="false" runat="server">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="Lbl_Farm_Type"></label>
                                        <div class="input-group">
                                            <div class="btn-group">
                                                <asp:RadioButtonList ID="rblAvianLivestock" runat="server" CellPadding="5" CssClass="radio-inline" OnSelectedIndexChanged="rblAvianLivestock_SelectedIndexChanged" RepeatDirection="Horizontal" AutoPostBack="true"></asp:RadioButtonList>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvSpeciesAndSamples" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CaptionAlign="Top" CssClass="table table-striped table-hover" DataKeyNames="MonitoringSessionToSampleType" EmptyDataText="<%$ Resources:Grd_Species_And_Samples_List_Empty_Data %>" GridLines="None" ShowFooter="false" ShowHeader="true" ShowHeaderWhenEmpty="true" UseAccessibleHeader="true">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Species_and_Samples_List_Species_Heading %>" />
                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Species_and_Samples_List_Sample_Type_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditSpeciesAndSample" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("MonitoringSessionToSampleType") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteSpeciesAndSample" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("MonitoringSessionToSampleType") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </eidss:GridView>
                            </div>
                            <div id="divSpeciesAndSampleContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Species_And_Samples"></h4>
                                        </div>
                                        <div id="divSpeciesAndSampleForm" class="modal-body" runat="server">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Species_And_Samples_Species_Type" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Species_And_Samples_Species_Type" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSpeciesAndSamplesidfsSpeciesType" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSpeciesAndSamplesidfsSpeciesType" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSpeciesAndSamplesidfsSpeciesType" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species_And_Samples_Species_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Species_And_Samples_Sample_Type" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Species_And_Samples_Sample_Type" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSpeciesAndSamplesidfsSampleType" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSpeciesAndSamplesidfsSampleType" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSpeciesAndSamplesidfsSampleType" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Species_And_Samples_Sample_Type" runat="server" ValidationGroup="SpeciesAndSamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer text-center">
                                                <asp:Button ID="btnSpeciesAndSampleOK" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="SpeciesAndSamplesSection" />
                                                <button type="button" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
        <section id="FarmHerdSpecies" runat="server" class="cold-md-12 hidden">
            <asp:UpdatePanel ID="upFarmHerdSpecies" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                    <h3 runat="server" meta:resourcekey="Hdg_Herd_Flock_Species"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                    <input type="submit" id="btnAddFarm" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="btn_Go_To_Session_Location_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <eidss:GridView ID="gvFarmHerdSpecies" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="RecordID" EmptyDataText="<%$ Resources: Grd_Species_List_Empty_Data %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="strHerdCode" />
                                        <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Species_List_Species_Type_Name_Heading %>" />
                                        <asp:BoundField DataField="intTotalAnimalQty" HeaderText="<%$ Resources: Grd_Species_List_Total_Animal_Qty_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDeleteFarm" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfFarmActual") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <a id="lnbExpandFarm" runat="server" data-toggle="collapse" href="#" role="button" aria-expanded="false" meta:resourcekey="btn_Show_Addition_Fields"><span class="glyphicon glyphicon-triangle-bottom"></span></a>
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
        <section id="DetailedAnimalsAndSamples" runat="server" class="col-md-12 hidden">
            <asp:UpdatePanel ID="upDetailedAnimalsAndSamples" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAddSample" EventName="ServerClick" />
                    <asp:PostBackTrigger ControlID="ddlSampleidfFarm" />
                    <asp:PostBackTrigger ControlID="btnSampleOK" />
                </Triggers>
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <h3 runat="server" meta:resourcekey="Hdg_Detailed_Animals_And_Samples"></h3>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <input type="submit" id="btnAddSample" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                    <input type="submit" id="btnDeleteSelectedSamples" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Delete_Text %>" title="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" />
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Detailed_Animals_Samples_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <asp:Label AssociatedControlID="txtTotalNumberAnimalsSampled" CssClass="control-label" meta:resourcekey="Lbl_Total_Number_Animals_Sampled" runat="server"></asp:Label>
                                        <asp:TextBox ID="txtTotalNumberAnimalsSampled" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <asp:Label AssociatedControlID="txtTotalNumberSamples" CssClass="control-label" meta:resourcekey="Lbl_Total_Number_Sampled" runat="server"></asp:Label>
                                        <asp:TextBox ID="txtTotalNumberSamples" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <eidss:GridView ID="gvSamples" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfMaterial" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Sample_Type_Heading %>" />
                                        <asp:BoundField DataField="strFieldBarCode" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sample_ID_Heading %>" />
                                        <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Species_Heading %>" />
                                        <asp:BoundField DataField="strAnimalCode" HeaderText="<%$ Resources: Grd_Samples_List_Animal_Heading %>" />
                                        <asp:BoundField DataField="datFieldCollectionDate" HeaderText="<%$ Resources: Grd_Samples_List_Collection_Date_Heading %>" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="AccessionConditionTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Sample_Condition_Received_Heading %>" meta:resourcekey="Dis_Condition_Received" />
                                        <asp:BoundField DataField="SendToOfficeSiteName" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sent_To_Organization_Heading %>" meta:resourcekey="Dis_Sent_To_Organization" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditSample" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfMaterial") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDeleteSample" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfMaterial") %>' CausesValidation="false"></asp:LinkButton>
                                                <br />
                                                <asp:CheckBox ID="chkDeleteSample" runat="server" meta:resourcekey="Lbl_Delete" CssClass="form-control" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <a id="expandCollapseSampleAliquotDetails" runat="server" style="vertical-align: bottom"><span class="glyphicon glyphicon-triangle-bottom" onclick="showSampleSubGrid(event,'div<%# Eval("idfMaterial") %>');"></span></a>
                                                <tr id="div<%# Eval("idfMaterial") %>" style="display: none;">
                                                    <td colspan="100">
                                                        <div style="position: relative; left: 10px; overflow: auto; overflow-x: hidden; width: 80%;">
                                                            <asp:Label ID="lblAliquotPlaceholder" CssClass="col-lg-2 col-md-2 col-sm-3 col-xs-6 control-label" runat="server" Text="Aliquots" />
                                                            <br />
                                                            <eidss:GridView ID="gvAliquots" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfMaterial" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Aliquots_List_Sample_Type_Heading %>" />
                                                                    <asp:BoundField DataField="strBarCode" HeaderText="<%$ Resources: Grd_Aliquots_List_Lab_Sample_ID_Heading %>" />
                                                                    <asp:BoundField DataField="SampleStatusTypeName" HeaderText="<%$ Resources: Grd_Aliquots_List_Status_Heading %>" />
                                                                    <asp:BoundField DataField="FieldCollectedByOfficeSiteName" HeaderText="<%$ Resources: Grd_Aliquots_List_Lab_Heading %>" />
                                                                    <asp:BoundField DataField="SendToOfficeSiteName" HeaderText="<%$ Resources: Grd_Aliquots_List_Field_Functional_Lab_Heading %>" />
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
                            <div id="divSampleContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Detailed_Animal_And_Sample"></h4>
                                        </div>
                                        <div id="divSampleForm" class="modal-body" runat="server">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Sample_Type" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Sample_Type" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfsSampleType" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfsSampleType" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfsSampleType" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Sample_Type" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSamplestrFieldBarCode" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtSamplestrFieldBarCode" runat="server" MaxLength="200" CssClass="form-control"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSamplestrFieldBarCode" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Detailed_Animals_And_Samples_Field_Sample_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Farm" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Farm_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfFarm" CssClass="control-label" meta:resourcekey="Lbl_Farm_ID" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfFarm" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfFarm" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Farm_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Species" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Species" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfSpecies" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfSpecies" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfSpecies" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Species" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" id="divSampleAnimalContainer1">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_ID" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfAnimal" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfAnimal" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfAnimal" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Name" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Name" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSamplestrName" CssClass="control-label" meta:resourcekey="Lbl_Animal_Name" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtSamplestrName" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSamplestrName" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Name" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" id="divSampleAnimalContainer2">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Age" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Age" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfsAnimalAge" CssClass="control-label" meta:resourcekey="Lbl_Animal_Age" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfsAnimalAge" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfsAnimalAge" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Age" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Gender" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Gender" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfsAnimalGender" CssClass="control-label" meta:resourcekey="Lbl_Animal_Gender" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleidfsAnimalGender" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleidfsAnimalGender" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Gender" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Animal_Color" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Animal_Color" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSamplestrColor" CssClass="control-label" meta:resourcekey="Lbl_Animal_Color" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtSamplestrColor" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSamplestrColor" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Detailed_Animals_And_Samples_Animal_Color" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Collection_Date" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Collection_Date" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSampledatFieldCollectionDate" CssClass="control-label" meta:resourcekey="Lbl_Collection_Date" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtSampledatFieldCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSampledatFieldCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Detailed_Animals_And_Samples_Collection_Date" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                        <asp:RangeValidator ID="rvSampleCollectionDate" Type="Date" ControlToValidate="txtSampledatFieldCollectionDate" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Collection_Date_Range" runat="server" ValidationGroup="SamplesSection"></asp:RangeValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Condition_Received" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSamplestrCondition" CssClass="control-label" meta:resourcekey="Lbl_Sample_Condition_Received" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtSamplestrCondition" runat="server" CssClass="form-control" MaxLength="200" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSamplestrCondition" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Condition_Received" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Comment" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Comment" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtSamplestrNote" CssClass="control-label" meta:resourcekey="Lbl_Comments" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtSamplestrNote" runat="server" CssClass="form-control" MaxLength="500" Enabled="false" TextMode="MultiLine"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSamplestrNote" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Detailed_Animals_And_Samples_Comment" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Detailed_Animals_And_Samples_Sent_To_Organization" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Detailed_Animals_And_Samples_Sent_To_Organization" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlSampleidfsSendToOffice" CssClass="control-label" meta:resourcekey="Lbl_Sent_To_Organization" runat="server"></asp:Label>
                                                        <eidss:DropDownSearch ID="ddlSampleidfsSendToOffice" runat="server" SearchType="Organization" FillOnLoad="true" />
                                                        <%--<asp:RequiredFieldValidator ControlToValidate="ddlSampleidfsSendToOffice" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Sent_To_Organization" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>--%>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <asp:Label ID="lblNumberToCopy" AssociatedControlID="txtNumberToCopy" CssClass="control-label" meta:resourcekey="Lbl_Copy_Number" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtNumberToCopy" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer text-center">
                                                <asp:Button ID="btnSampleOK" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="SamplesSection" />
                                                <button type="button" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"></button>
                                                <asp:Button CssClass="btn btn-default" ID="btnCopySample" meta:resourcekey="Btn_Copy_Sample" runat="server" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
        <section id="TestsResultSummaries" runat="server" class="col-md-12 hidden">
            <asp:UpdatePanel ID="upTestResultSummary" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAddTest" EventName="ServerClick" />
                    <asp:PostBackTrigger ControlID="ddlTestidfMaterial" />
                    <asp:PostBackTrigger ControlID="ddlResultSummaryidfsInterpretedStatus" />
                    <asp:PostBackTrigger ControlID="chkResultSummaryblnValidateStatus" />
                    <asp:PostBackTrigger ControlID="btnTestOK" />
                    <asp:PostBackTrigger ControlID="btnResultSummaryOK" />
                </Triggers>
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                    <h3 runat="server" meta:resourcekey="Hdg_Test_Information"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                    <input type="submit" id="btnAddTest" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(3, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Test_Information_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <eidss:GridView ID="gvTests" runat="server" AllowPaging="True" AllowSorting="False" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfTesting" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="strBarCode" HeaderText="<%$ Resources: Grd_Tests_List_Lab_Sample_ID_Heading %>" />
                                        <asp:BoundField DataField="strFarmCode" HeaderText="<%$ Resources: Grd_Tests_List_Farm_ID_Heading %>" />
                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Tests_List_Sample_Type_Heading %>" />
                                        <asp:BoundField DataField="strFieldBarCode" HeaderText="<%$ Resources: Grd_Tests_List_Field_Sample_ID_Heading %>" />
                                        <asp:BoundField DataField="strAnimalCode" HeaderText="<%$ Resources: Grd_Tests_List_Animal_ID_Heading %>" />
                                        <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Grd_Tests_List_Test_Name_Heading %>" />
                                        <asp:BoundField DataField="datConcludedDate" HeaderText="<%$ Resources: Grd_Tests_List_Result_Date_Heading %>" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="TestCategoryTypeName" HeaderText="<%$ Resources: Grd_Tests_List_Test_Category_Heading %>" />
                                        <asp:BoundField DataField="TestStatusTypeName" HeaderText="<%$ Resources: Grd_Tests_List_Test_Status_Heading %>" />
                                        <asp:BoundField DataField="TestResultTypeName" HeaderText="<%$ Resources: Grd_Tests_List_Test_Result_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <div class="divDetailsContainer" style="white-space: nowrap; vertical-align: top;">
                                                    <asp:UpdatePanel ID="upResultSummary" runat="server" UpdateMode="Conditional">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="btnAddResultSummary" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:Button ID="btnAddResultSummary" runat="server" CssClass="btn btn-default btn-sm" CommandName="Add Interpretation" CommandArgument='<% #Bind("idfTesting") %>' CausesValidation="False" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditTest" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfTesting") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDeleteTest" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfTesting") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </eidss:GridView>
                            </div>
                            <div id="divTestContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Test_Information"></h4>
                                        </div>
                                        <div id="divTestForm" class="modal-body" runat="server">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Field_Sample_ID" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Field_Sample_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlTestidfMaterial" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlTestidfMaterial" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlTestidfMaterial" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Field_Sample_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Lab_Sample_ID" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Lab_Sample_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTeststrBarCode" CssClass="control-label" meta:resourcekey="Lbl_Lab_Sample_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTeststrBarCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTeststrBarCode" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Lab_Sample_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Sample_Type" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Sample_Type" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTestSampleTypeName" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTestSampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTestSampleTypeName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Sample_Type" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Farm_ID" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Farm_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTeststrFarmCode" CssClass="control-label" meta:resourcekey="Lbl_Farm_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTeststrFarmCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTeststrFarmCode" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Farm_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Animal_ID" runat="server" id="divTestAnimalContainer">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Animal_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTeststrAnimalCode" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTeststrAnimalCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTeststrAnimalCode" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Animal_ID" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Disease" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Disease" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTestDiagnosis" CssClass="control-label" meta:resourcekey="Lbl_Test_Disease" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTestDiagnosis" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTestDiagnosis" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Test_Disease" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Name" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Name" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlTestidfsTestName" CssClass="control-label" meta:resourcekey="Lbl_Test_Name" runat="server"></asp:Label>
                                                        <eidss:DropDownAdd ID="ddlTestidfsTestName" runat="server" AddType="Reference" AccessoryCode="10040007" HACode="96" ReferenceType="TestName" BaseReferenceName="Test Name" Enabled="<%$ Resources:Val_Test_Test_Name.Enabled %>" ErrorMessage="<%$ Resources:Val_Test_Test_Name.ErrorMessage %>" Text="<%$ Resources:Val_Test_Test_Name.Text %>" InitialValue="null" ValidationGroup="TestSection" />
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Status" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Status" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTestTestStatus" CssClass="control-label" meta:resourcekey="Lbl_Test_Status" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtTestTestStatus" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTestTestStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Test_Status" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Test_Test_Category" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Test_Category" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlTestidfsTestCategory" CssClass="control-label" meta:resourcekey="Lbl_Test_Category" runat="server"></asp:Label>
                                                        <eidss:DropDownAdd ID="ddlTestidfsTestCategory" runat="server" AddType="Reference" AccessoryCode="10040007" HACode="96" ReferenceType="TestCategory" BaseReferenceName="Test Category" Enabled="<%$ Resources:Val_Test_Test_Category.Enabled %>" ErrorMessage="<%$ Resources:Val_Test_Test_Category.ErrorMessage %>" Text="<%$ Resources:Val_Test_Test_Category.Text %>" InitialValue="null" ValidationGroup="TestSection" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Result_Date" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result_Date" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtTestdatConcludedDate" CssClass="control-label" meta:resourcekey="Lbl_Result_Date" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtTestdatConcludedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtTestdatConcludedDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Result_Date" runat="server" ValidationGroup="TestSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Test_Result_Observation" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result_Observation" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlTestidfsTestResult" CssClass="control-label" meta:resourcekey="Lbl_Test_Result" runat="server"></asp:Label>
                                                        <eidss:DropDownAdd ID="ddlTestidfsTestResult" runat="server" AddType="Reference" AccessoryCode="10040007" HACode="32" ReferenceType="TestResult" BaseReferenceName="Test Result" Enabled="<%$ Resources:Val_Test_Test_Result.Enabled %>" ErrorMessage="<%$ Resources:Val_Test_Test_Result.ErrorMessage %>" Text="<%$ Resources:Val_Test_Test_Result.Text %>" InitialValue="null" ValidationGroup="TestSection" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer text-center">
                                                <asp:Button ID="btnTestOK" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="TestSection" />
                                                <button type="button" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal" causesvalidation="false"></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
                                <eidss:GridView ID="gvResultSummaries" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfTestValidation" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="strFarmCode" HeaderText="<%$ Resources: Grd_Result_Summary_List_Farm_ID_Heading %>" />
                                        <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Result_Summary_List_Species_Heading %>" />
                                        <asp:BoundField DataField="strAnimalCode" HeaderText="<%$ Resources: Grd_Result_Summary_List_Animal_ID_Heading %>" />
                                        <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Grd_Result_Summary_List_Test_Name_Heading %>" />
                                        <asp:BoundField DataField="strBarCode" HeaderText="<%$ Resources: Grd_Result_Summary_List_Lab_Sample_ID_Heading %>" />
                                        <asp:BoundField DataField="strFieldBarCode" HeaderText="<%$ Resources: Grd_Result_Summary_List_Field_Sample_ID_Heading %>" />
                                        <asp:BoundField DataField="InterpretedStatusTypeName" HeaderText="<%$ Resources: Grd_Result_Summary_List_Rule_In_Rule_Out_Heading %>" />
                                        <asp:BoundField DataField="blnValidateStatus" HeaderText="<%$ Resources: Grd_Result_Summary_List_Validated_Heading %>" />
                                        <asp:BoundField DataField="datValidationDate" HeaderText="<%$ Resources: Grd_Result_Summary_List_Date_Validated_Heading %>" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="ValidatedByPersonName" HeaderText="<%$ Resources: Grd_Result_Summary_List_Validated_By_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditResultSummary" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfTestValidation") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteResultSummary" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfTestValidation") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </eidss:GridView>
                            </div>
                            <div id="divResultSummaryContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Results_Summary"></h4>
                                            <asp:HiddenField ID="hdfidfTesting" runat="server" Value="" />
                                        </div>
                                        <div id="divResultSummaryForm" class="modal-body" runat="server">
                                            <div class="form-group" meta:resourcekey="Dis_Result_Summary_Farm_ID" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                        <asp:Label AssociatedControlID="txtResultSummarystrFarmCode" CssClass="control-label" meta:resourcekey="Lbl_Farm_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrFarmCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                        <asp:Label AssociatedControlID="txtResultSummarySpeciesTypeName" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarySpeciesTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Animal" runat="server" id="divResultSummaryAnimalContainer">
                                                        <asp:Label AssociatedControlID="txtResultSummarystrAnimalCode" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrAnimalCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Lab_Sample_ID" runat="server">
                                                        <asp:Label AssociatedControlID="txtResultSummarystrBarCode" CssClass="control-label" meta:resourcekey="Lbl_Lab_Sample_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrBarCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Sample_Type" runat="server">
                                                        <asp:Label AssociatedControlID="txtResultSummarySampleTypeName" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarySampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                        <asp:Label AssociatedControlID="txtResultSummarystrFieldCode" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrFieldCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Disease" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Test_Disease" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummaryDiagnosis" CssClass="control-label" meta:resourcekey="Lbl_Disease" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummaryDiagnosis" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Name" runat="server">
                                                        <asp:Label AssociatedControlID="txtResultSummaryTestTypeName" CssClass="control-label" meta:resourcekey="Lbl_Test_Name" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummaryTestTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Test_Category" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Test_Category" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultsummaryTestCategoryTypeName" CssClass="control-label" meta:resourcekey="Lbl_Test_Category" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultsummaryTestCategoryTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Rule_Out_Rule_In" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Rule_Out_Rule_In" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlResultSummaryidfsInterpretedStatus" CssClass="control-label" meta:resourcekey="Lbl_Rule_In_Rule_Out" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlResultSummaryidfsInterpretedStatus" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlResultSummaryidfsInterpretedStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Result_Summary_Rule_In_Rule_Out" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Date_Interpreted" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Date_Interpreted" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummarydatInterpretationDate" CssClass="control-label" meta:resourcekey="Lbl_Date_Interpreted" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtResultSummarydatInterpretationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummarydatInterpretationDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Date_Interpreted" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Interpreted_By" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Interpreted_By" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummaryInterpretedByPersonName" CssClass="control-label" meta:resourcekey="Lbl_Interpreted_By" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummaryInterpretedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:HiddenField ID="hdfResultSummaryidfInterpretedByPerson" runat="server" Value="null" />
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryInterpretedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Interpreted_By" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Result_Summary_Interpreted_Comment" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Interpreted_Comment" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummarystrInterpretedComment" CssClass="control-label" meta:resourcekey="Lbl_Interpreted_Comment" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrInterpretedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false" TextMode="MultiLine"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummarystrInterpretedComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Interpreted_Comment" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Validated" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated" runat="server"></div>
                                                        <asp:CheckBox ID="chkResultSummaryblnValidateStatus" runat="server" meta:resourcekey="Lbl_Validated" AutoPostBack="true" CssClass="checkbox-inline" />
                                                        <%-- <asp:RequiredFieldValidator ControlToValidate="chkInterpretationblnValidateStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Validated" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>--%>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Date_Validated" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Date_Validated" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummarydatValidationDate" CssClass="control-label" meta:resourcekey="Lbl_Date_Validated" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtResultSummarydatValidationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummarydatValidationDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Date_Validated" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Result_Summary_Validated_By" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated_By" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummaryValidatedByPersonName" CssClass="control-label" meta:resourcekey="Lbl_Validated_By" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummaryValidatedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        <asp:HiddenField ID="hdfResultSummaryidfValidatedByPerson" runat="server" Value="null" />
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummaryValidatedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Validated_By" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Result_Summary_Validated_Comment" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Summary_Validated_Comment" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtResultSummarystrValidateComment" CssClass="control-label" meta:resourcekey="Lbl_Validated_Comment" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtResultSummarystrValidateComment" runat="server" MaxLength="200" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtResultSummarystrValidateComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Result_Summary_Validated_Comment" runat="server" ValidationGroup="ResultSummarySection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer text-center">
                                            <asp:Button ID="btnResultSummaryOK" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="ResultSummarySection"></asp:Button>
                                            <button type="submit" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"></button>
                                            <asp:LinkButton ID="btnCreateDiseaseReport" runat="server" CssClass="btn btn-default" CausesValidation="false"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;<span><%= GetLocalResourceObject("Btn_Add_Disease_Report.Text") %></span></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
        <section id="Actions" class="col-md-12 hidden" runat="server">
            <asp:UpdatePanel ID="upAction" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAddAction" EventName="ServerClick" />
                    <asp:PostBackTrigger ControlID="btnActionOK" />
                </Triggers>
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                    <h3 runat="server" meta:resourcekey="Hdg_Actions"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                    <input type="submit" id="btnAddAction" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(4, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Actions_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <eidss:GridView ID="gvActions" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfMonitoringSessionAction" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="MonitoringSessionActionTypeName" HeaderText="<%$ Resources: Grd_Action_List_Action_Required_Heading %>" />
                                        <asp:BoundField DataField="datActionDate" HeaderText="<%$ Resources: Grd_Action_List_Date_Heading %>" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="PersonName" HeaderText="<%$ Resources: Grd_Action_List_Entered_By_Heading %>" />
                                        <asp:BoundField DataField="strComments" HeaderText="<%$ Resources: Grd_Action_List_Comment_Heading %>" />
                                        <asp:BoundField DataField="MonitoringSessionActionStatusName" HeaderText="<%$ Resources: Grd_Action_List_Status_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditAction" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfMonitoringSessionAction") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteAction" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfMonitoringSessionAction") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </eidss:GridView>
                            </div>
                            <div id="divActionContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Actions"></h4>
                                        </div>
                                        <div id="divActionForm" class="modal-body" runat="server">
                                            <div class="form-group" meta:resourcekey="Dis_Action_Required" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Required" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlActionidfsMonitoringSessionActionType" CssClass="control-label" meta:resourcekey="Lbl_Action_Required" runat="server"></asp:Label>
                                                        <eidss:DropDownAdd ID="ddlActionidfsMonitoringSessionActionType" runat="server" AddType="Reference" AccessoryCode="10040007" HACode="96" ReferenceType="ASSessionActionType" BaseReferenceName="AS Session Action Type" Enabled="<%$ Resources:Val_Action_Action_Required.Enabled %>" ErrorMessage="<%$ Resources:Val_Action_Action_Required.ErrorMessage %>" Text="<%$ Resources:Val_Action_Action_Required.Text %>" InitialValue="null" ValidationGroup="ActionSection" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Action_Date" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Date" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtActiondatActionDate" CssClass="control-label" meta:resourcekey="Lbl_Date" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtActiondatActionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtActiondatActionDate" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Action_Date" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Action_Entered_By" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Entered_By" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlActionidfPersonEnteredBy" CssClass="control-label" meta:resourcekey="Lbl_Entered_By" runat="server"></asp:Label>
                                                        <asp:DropDownList ID="ddlActionidfPersonEnteredBy" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlActionidfPersonEnteredBy" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Action_Entered_By" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Action_Comment" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Comment" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtActionstrComments" CssClass="control-label" meta:resourcekey="Lbl_Comments" runat="server"></asp:Label>
                                                        <asp:TextBox ID="txtActionstrComments" runat="server" CssClass="form-control" MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtActionstrComments" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Action_Comment" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Action_Status" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Status" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlActionidfsMonitoringSessionActionStatus" CssClass="control-label" meta:resourcekey="Lbl_Status" runat="server"></asp:Label>
                                                        <asp:DropDownList ID="ddlActionidfsMonitoringSessionActionStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlActionidfsMonitoringSessionActionStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Action_Status" runat="server" ValidationGroup="ActionSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer text-center">
                                                <asp:Button ID="btnActionOK" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="ActionSection"></asp:Button>
                                                <button type="submit" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
        <section id="AggregateInfo" class="col-md-12 hidden" runat="server">
            <asp:UpdatePanel ID="upAggregateInfo" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAddAggregateInfo" EventName="ServerClick" />
                    <asp:PostBackTrigger ControlID="ddlAggregateInfoidfFarm" />
                    <asp:PostBackTrigger ControlID="btnAggregateInfoOK" />
                </Triggers>
                <ContentTemplate>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                    <h3 runat="server" meta:resourcekey="Hdg_Aggregate_Info"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                    <input type="submit" id="btnAddAggregateInfo" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Add_Text %>" title="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(5, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Aggregate_Info_Tab"></a>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <eidss:GridView ID="gvAggregateInfos" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfMonitoringSessionSummary" EmptyDataText="No data available." ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                    <HeaderStyle CssClass="table-striped-header" />
                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="strFarmCode" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Farm_ID_Heading %>" />
                                        <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Species_Heading %>" />
                                        <asp:BoundField DataField="AnimalGenderTypeName" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Sex_Heading %>" />
                                        <asp:BoundField DataField="intSampledAnimalsQty" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Animals_Sampled_Heading %>" />
                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Sample_Type_Heading %>" />
                                        <asp:BoundField DataField="intSamplesQty" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Number_Of_Samples_Heading %>" />
                                        <asp:BoundField DataField="datCollectionDate" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Collection_Date_Heading %>" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="intPositiveAnimalsQty" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Positive_Number_Heading %>" />
                                        <asp:BoundField DataField="DiagnosisName" HeaderText="<%$ Resources: Grd_Aggregate_Info_List_Disease_Heading %>" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditAggregateInfo" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfMonitoringSessionSummary") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteAggregateInfo" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfMonitoringSessionSummary") %>' CausesValidation="false"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </eidss:GridView>
                            </div>
                            <div id="divAggregateInfoContainer" class="modal" data-backdrop="static" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Aggregate_Info"></h4>
                                        </div>
                                        <div id="divAggregateInfoForm" class="modal-body" runat="server">
                                            <div class="form-group" meta:resourcekey="Dis_Aggregate_Info_Farm_ID" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Farm_ID" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlAggregateInfoidfFarm" CssClass="control-label" meta:resourcekey="Lbl_Farm_ID" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoidfFarm" AutoPostBack="true" runat="server"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Species" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Species" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlAggregateInfoidfSpecies" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoidfSpecies" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoidfSpecies" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Species" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Animal_Sex" runat="server" id="divAggregateInfoAnimalContainer">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Animal_Sex" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlAggregateInfoidfsAnimalSex" CssClass="control-label" meta:resourcekey="Lbl_Sex" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoidfsAnimalSex" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoidfsAnimalSex" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Animal_Sex" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Animals_Sampled" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Animals_Sampled" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtintSampledAnimalsQty" CssClass="control-label" meta:resourcekey="Lbl_Animals_Sampled" runat="server"></asp:Label>
                                                        <eidss:NumericSpinner ID="txtintSampledAnimalsQty" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtintSampledAnimalsQty" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Aggregate_Info_Animals_Sampled" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Number_Of_Samples" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Number_Of_Samples" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtintSamplesQty" CssClass="control-label" meta:resourcekey="Lbl_Number_Of_Samples" runat="server"></asp:Label>
                                                        <eidss:NumericSpinner ID="txtintSamplesQty" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtintSamplesQty" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Number_Of_Samples" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Aggregate_Info_Positive_Animals" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Positive_Animals" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtintPositiveAnimalsQty" CssClass="control-label" meta:resourcekey="Lbl_Number_Positive" runat="server"></asp:Label>
                                                        <eidss:NumericSpinner ID="txtintPositiveAnimalsQty" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtintPositiveAnimalsQty" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Positive_Animals" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Sample_Type" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Sample_Type" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlAggregateInfoidfsSampleType" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoidfsSampleType" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoidfsSampleType" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Sample_Type" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Aggregate_Info_Collection_Date" runat="server">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Collection_Date" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtAggregateInfodatCollectionDate" CssClass="control-label" meta:resourcekey="Lbl_Collection_Date" runat="server"></asp:Label>
                                                        <eidss:CalendarInput ID="txtAggregateInfodatCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtAggregateInfodatCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Collection_Date" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                        <asp:RangeValidator ID="rvAggregateInfoCollectionDate" ControlToValidate="txtAggregateInfodatCollectionDate" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Aggregate_Info_Collection_Date_Range" runat="server" ValidationGroup="AggregateInfoSection"></asp:RangeValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" meta:resourcekey="Dis_Aggregate_Info_Disease" runat="server">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Aggregate_Info_Disease" runat="server"></div>
                                                        <asp:Label AssociatedControlID="ddlAggregateInfoidfsDiagnosis" CssClass="control-label" meta:resourcekey="Lbl_Disease" runat="server"></asp:Label>
                                                        <eidss:DropDownList CssClass="form-control" ID="ddlAggregateInfoidfsDiagnosis" runat="server"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlAggregateInfoidfsDiagnosis" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aggregate_Info_Disease" runat="server" ValidationGroup="AggregateInfoSection"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer text-center">
                                                <asp:Button ID="btnAggregateInfoOK" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="AggregateInfoSection"></asp:Button>
                                                <button type="submit" class="btn btn-default" runat="server" value="<%$ Resources: Buttons, Btn_Cancel_Text %>" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(6, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));" runat="server" meta:resourcekey="Btn_Go_To_Disease_Report_Tab"></a>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <eidss:GridView ID="gvVeterinaryDiseaseReports" meta:resourcekey="Grd_Disease_Reports" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped table-hover" DataKeyNames="" GridLines="None">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <Columns>
                                <asp:BoundField DataField="strCaseID" meta:resourcekey="Grd_Disease_Reports_Report_ID_Header" SortExpression="DiseaseReportID" />
                                <asp:BoundField DataField="CaseClassificationTypeName" meta:resourcekey="Grd_Disease_Reports_Case_Classification_Header" SortExpression="CaseClassification" />
                                <asp:BoundField DataField="FinalDiagnosisName" meta:resourcekey="Grd_Disease_Reports_Disease_Header" SortExpression="Disease" />
                                <%--<asp:BoundField DataField="Location" meta:resourcekey="Grd_Disease_Reports_Location_Header" SortExpression="Location" />--%>
                                <asp:BoundField DataField="FormattedFarmAddressString" meta:resourcekey="Grd_Disease_Reports_Address_Header" SortExpression="Address" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEditVeterinaryDiseaseReport" runat="server" CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<% #Bind("idfVetCase") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteVeterinaryDiseaseReport" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfVetCase") %>' CausesValidation="false"></asp:LinkButton>
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
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiSessionInformation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Session_Information" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="1, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiFarmHerdSpecies" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Farm_Herd_Species" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="2, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiDetailedAnimalsAndSamples" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Detailed_Animals_Samples" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="3, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiTestInformation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Test_Information" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="4, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiActions" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Actions" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="5, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiAggregateInfo" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Aggregate_Info" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="6, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiDiseaseReports" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_DiseaseReports" runat="server"></eidss:SideBarItem>
            <eidss:SideBarItem CssClass="glyphicon glyphicon-file" GoToSideBarSection="7, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiReview" IsActive="true" ItemStatus="IsReview" meta:resourcekey="Tab_Review" runat="server"></eidss:SideBarItem>
        </MenuItems>
    </eidss:SideBarNavigation>
    <div class="row text-center">
        <div runat="server" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <asp:Button ID="btnCancel" CssClass="btn btn-default" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />
            <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divVeterinaryActiveSurveillanceSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />            
            <asp:Button ID="btnSubmit" CssClass="btn btn-primary" runat="server" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" CausesValidation="true" />
            <asp:Button ID="btnDelete" CssClass="btn btn-primary" runat="server" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" CausesValidation="false" />
        </div>
    </div>
</div>
<asp:HiddenField runat="server" Value="0" ID="hdfVeterinaryActiveSurveillanceSessionPanelController" />
<script type="text/javascript">
    $(document).ready(function () {
        var sessionForm = document.getElementById("<% = divVeterinaryActiveSurveillanceSessionForm.ClientID %>");
        if (sessionForm != undefined) { setViewOnPageLoad("<% = hdfVeterinaryActiveSurveillanceSessionPanelController.ClientID %>"); }
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
        $('.modal').modal({ show: false, backdrop: 'static' });
    })

    function callBackHandler() {
        var sessionForm = document.getElementById("<% = divVeterinaryActiveSurveillanceSessionForm.ClientID %>");
                        if (sessionForm != undefined) { setViewOnPageLoad("<% = hdfVeterinaryActiveSurveillanceSessionPanelController.ClientID %>"); }
                        $('.modal').modal({ show: false, backdrop: 'static' });
                    }

                    function showSpeciesAndSampleModal() {
                        $('#divSpeciesAndSampleContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideSpeciesAndSampleModal() {
                        $('#divSpeciesAndSampleContainer').modal('hide');
                    }

                    function showSampleModal() {
                        $('#divSampleContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideSampleModal() {
                        $('#divSampleContainer').modal('hide');
                    }

                    function showTestModal() {
                        $('#divTestContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideTestModal() {
                        $('#divTestContainer').modal('hide');
                    }

                    function showResultSummaryModal() {
                        $('#divResultSummaryContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideResultSummaryModal() {
                        $('#divResultSummaryContainer').modal('hide');
                    }

                    function showActionModal() {
                        $('#divActionContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideActionModal() {
                        $('#divActionContainer').modal('hide');
                    }

                    function showAggregateInfoModal() {
                        $('#divAggregateInfoContainer').modal({ show: true, backdrop: 'static' });
                    }

                    function hideAggregateInfoModal() {
                        $('#divAggregateInfoContainer').modal('hide');
                    }

                    function showSubGrid(e, divname) {

                        var div = document.getElementById(divname);
                        var cl = e.target.className;
                        if (cl == 'glyphicon glyphicon-triangle-bottom') {
                            $(this).closest("tr").after("")
                            div.style.display = "inline";
                            e.target.className = "glyphicon glyphicon-triangle-top";
                            $('#' + f).show();
                        }
                        else {
                            e.target.className = "glyphicon glyphicon-triangle-bottom";
                            div.style.display = "none";
                            $('#' + f).hide();
                        }
                    };

                    function toggleFarmDetails(e, attribute) {
                        //e.preventDefault();
                        $("[fhs]").each(function (e) {

                            if ($(this).attr("fhs") == attribute) {
                                $(this).toggle();
                            }
                        });
                    }
</script>
