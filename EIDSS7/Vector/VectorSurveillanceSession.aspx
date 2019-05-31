 <%@ Page Title="" Language="vb" AutoEventWireup="true" MasterPageFile="~/NormalView.Master" CodeBehind="VectorSurveillanceSession.aspx.vb" EnableEventValidation="true" Inherits="EIDSS.VectorSurveillanceSession" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/DropDownSearch.ascx" TagPrefix="eidss" TagName="DropDownSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <asp:UpdatePanel runat="server">

        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSearchList" EventName="Click" />
        </Triggers>

        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Vector_Surveillance_Session"></h2>                            
                        </div>
                        <div class="panel-body">

<%--Begin: Hidden fields--%>
                            <div id="divHiddenFieldsSection" runat="server" style="display:none">
                                <asp:DropDownList ID="ddlVSSFormSection" runat="server" AutoPostBack="true" />
                                <asp:DropDownList ID="ddlVSSFormSectionShowHide" runat="server" AutoPostBack="true" />
                                <asp:DropDownList ID="ddlVSSFormAction" runat="server" />
                                <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                                <asp:HiddenField runat="server" ID="hdfidfsSite" Value="" />
                                <asp:HiddenField runat="server" ID="hdfVSSSearchResultsRow" Value="-1" />
                                <asp:HiddenField runat="server" ID="hdfidfGeoLocation" Value="NULL" />
                            </div>
<%--End: Hidden fields--%>

<%--Begin: Search section--%>
                            <div id="divSearch" runat="server">
                                <div id="divSearchForm" runat="server" class="row embed-panel" style="display:none">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                    <h3 id="searchCriteria" class="heading" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                    <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" style="display:none" onclick="showSection(event);" meta:resourcekey="btn_Show_Search_Criteria"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="divSearchFields" runat="server" class="panel-body">
                                            <p runat="server" meta:resourcekey="lbl_Search_Instructions"></p>
                                            <p><asp:CustomValidator ID="cvSearchSessionID" runat="server" OnServerValidate="cvSearchSessionID_ServerValidate" ValidationGroup="SearchFields" CssClass="text-danger" meta:resourcekey="val_Search_Form_Fields"></asp:CustomValidator></p>
                                            <p><asp:CustomValidator ID="cvFutureDate" runat="server" OnServerValidate="cvFutureDate_ServerValidate" ValidationGroup="SearchFieldsFutureDate" CssClass="text-danger" meta:resourcekey="val_Search_Form_Fields_Future_Date"></asp:CustomValidator></p>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSearchEIDSSSessionID" runat="server" meta:resourcekey="lbl_Session_ID"></label>
                                                        <asp:TextBox ID="txtSearchEIDSSSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="txtSearchFieldSessionID" runat="server" meta:resourcekey="lbl_Field_Session_ID"></label>
                                                        <asp:TextBox ID="txtSearchFieldSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label for="ddlSearchSessionStatusTypeID" runat="server" meta:resourcekey="lbl_Status"></label>
                                                        <asp:DropDownList ID="ddlSearchSessionStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <fieldset id="startDate" runat="server">
                                                <legend runat="server" meta:resourcekey="lbl_Start_Date_Range"></legend>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_From"></label>
                                                            <eidss:CalendarInput ID="txtSearchStartDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:CompareValidator ID="cvSearchStartDateFrom" runat="server" ControlToValidate="txtSearchStartDateFrom" ControlToCompare="txtSearchStartDateTo" CssClass="text-danger" meta:resourceKey="val_StartDateFrom" CultureInvariantValues="true" ValidationGroup="ValidDateRange" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_To"></label>
                                                            <eidss:CalendarInput ID="txtSearchStartDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:CompareValidator ID="cvSearchStartDateTo" runat="server" ControlToValidate="txtSearchStartDateTo" ControlToCompare="txtSearchStartDateFrom" CssClass="text-danger" meta:resourceKey="val_StartDateTo" CultureInvariantValues="true" ValidationGroup="ValidDateRange" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                                        </div>
                                                    </div>
                                                    
                                                </div>
                                            </fieldset>
                                            <fieldset id="endDate" runat="server">
                                                <legend runat="server" meta:resourcekey="lbl_End_Date_Range"></legend>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_From"></label>
                                                            <eidss:CalendarInput ID="txtSearchCloseDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:CompareValidator ID="cvSearchCloseDateFrom" runat="server" ControlToValidate="txtSearchCloseDateFrom" ControlToCompare="txtSearchCloseDateTo" CssClass="text-danger" meta:resourceKey="val_EndDateFrom" CultureInvariantValues="true" ValidationGroup="ValidDateRange" Type="Date" Operator="LessThanEqual"></asp:CompareValidator>
                                                            <br />
                                                            <asp:CustomValidator ID="cvSearchEndDateFromStartDate" runat="server" ControlToValidate="txtSearchCloseDateFrom" OnServerValidate="cvSearchEndDateStartDate_ServerValidate" ValidationGroup="ValidateDates" CssClass="text-danger" meta:resourceKey="val_EndDateFromStartDate"></asp:CustomValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_To"></label>
                                                            <eidss:CalendarInput ID="txtSearchCloseDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:CompareValidator ID="cvSearchCloseDateTo" runat="server" ControlToValidate="txtSearchCloseDateTo" ControlToCompare="txtSearchCloseDateFrom" CssClass="text-da nger" meta:resourceKey="val_EndDateTo" CultureInvariantValues="true" ValidationGroup="ValidDateRange" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                                                            <br />
                                                            <asp:CustomValidator ID="cvSearchEndDateToStartDate" runat="server" ControlToValidate="txtSearchCloseDateTo" OnServerValidate="cvSearchEndDateStartDate_ServerValidate" ValidationGroup="ValidateDates" CssClass="text-danger" meta:resourceKey="val_EndDateToStartDate"></asp:CustomValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-3 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Vector_Type"></label>
                                                        <asp:DropDownList ID="ddlSearchVectorType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSearchVectorType_SelectedIndexChanged"></asp:DropDownList>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Species"></label>
                                                        <asp:DropDownList ID="ddlSearchSpeciesTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                        <asp:DropDownList ID="ddlSearchDiseaseID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <eidss:LocationUserControl ID="LocCtr" runat="server" ClientIDMode="Static" ShowPostalCode="false" IsHorizontalLayout="true" ShowStreet="false" ShowCoordinates="false" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowApartment="false" ShowBuilding="true" ShowHouse="false" ShowMap="false" ShowTownOrVillage="true" ShowRayon="true" ShowRegion="true"  AutoPostBack="true"/>
                                        </div>
                                    </div>
                                </div>
                                <div id="divSearchResults" runat="server" class="row embed-panel"  style="display:none">
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
                                                    <asp:AsyncPostBackTrigger ControlID="gvVSSSearchResults" EventName="RowCommand" />
                                                    <asp:AsyncPostBackTrigger ControlID="gvVSSSearchResults" EventName="Sorting" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <div class="table-responsive">
                                                        <asp:GridView ID="gvVSSSearchResults" 
                                                            runat="server" 
                                                            AllowSorting="True" 
                                                            AutoGenerateColumns="False" 
                                                            CssClass="table table-striped" 
                                                            DataKeyNames="EIDSSSessionID" 
                                                            ShowHeaderWhenEmpty="true" 
                                                            ShowHeader="true" 
                                                            EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                            ShowFooter="False" 
                                                            GridLines="None" 
                                                            AllowPaging="true" 
                                                            PagerSettings-Visible="false">
                                                            <HeaderStyle CssClass="table-striped-header" />
                                                            <PagerSettings Visible="False" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Session_ID_Text %>" SortExpression="EIDSSSessionID">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="btnSelectVSSSearchResults" runat="server" Text='<%# Eval("EIDSSSessionID") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("VectorSurveillanceSessionID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                        <br />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="StatusTypeName" ReadOnly="true" SortExpression="StatusTypeName" HeaderText="<%$ Resources: Labels, lbl_Status_Text %>" />
                                                                <asp:BoundField DataField="StartDate" ReadOnly="true" SortExpression="StartDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources: Labels, Lbl_Start_Date_Text %>" />
                                                                <asp:BoundField DataField="CloseDate" ReadOnly="true" SortExpression="CloseDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources: Labels, Lbl_Close_Date_Text %>" />
                                                                <asp:BoundField DataField="RegionName" ReadOnly="true" SortExpression="RegionName" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" />
                                                                <asp:BoundField DataField="RayonName" ReadOnly="true" SortExpression="RayonName" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" />
                                                                <asp:BoundField DataField="Vectors" ReadOnly="true" SortExpression="Vectors" HeaderText="<%$ Resources: Labels, Lbl_Vector_Type_Text %>" />
                                                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                    <ItemTemplate>
                                                                        <asp:UpdatePanel ID="upEditVSSSearchResults" runat="server">
                                                                            <Triggers>
                                                                                <asp:AsyncPostBackTrigger ControlID="btnEditVSSSearchResults" />
                                                                            </Triggers>
                                                                            <ContentTemplate>
                                                                                <asp:LinkButton ID="btnEditVSSSearchResults" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("VectorSurveillanceSessionID") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </ItemTemplate>
                                                                    <ItemStyle CssClass="icon" />
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                        <span class="glyphicon glyphicon-triangle-bottom" style="cursor:pointer" onclick="showVSSSubGrid(event,'divVSS<%# Eval("EIDSSSessionID") %>');"></span>
                                                                        <tr id="divVSS<%# Eval("EIDSSSessionID") %>" style="display: none;">
                                                                            <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                                                <div>
                                                                                    <div class="form-group form-group-sm">
                                                                                        <div class="row">
                                                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Field_Session_ID_Text") %></label>
                                                                                                <asp:TextBox ID="txtFieldSessionID" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("FieldSessionID") %>' />
                                                                                            </div>
                                                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Settlement_Text") %></label>
                                                                                                <asp:TextBox ID="txtSettlement" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("SettlementName") %>'></asp:TextBox>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="form-group form-group-sm">
                                                                                        <div class="row">
                                                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Latitude_Text") %></label>
                                                                                                <asp:TextBox ID="txtLatitude" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("Latitude") %>' />
                                                                                            </div>
                                                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Longitude_Text") %></label>
                                                                                                <asp:TextBox ID="txtLongitude" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("Longitude") %>'></asp:TextBox>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </div>
                                                    <div id="divSearchResultsPager" class="row" runat="server">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblSearchResultsNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblSearchResultsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                            <asp:Repeater ID="rptSearchResultsPager" runat="server">
                                                                <ItemTemplate>
                                                                    <asp:UpdatePanel ID="upSearchResultsPager" runat="server" RenderMode="Inline">
                                                                        <ContentTemplate>
                                                                            <asp:LinkButton ID="lnkSearchResultsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                </div>
                                <div class="row text-center">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" style="display:none"/>
                                        <button type="button" ID="btnSearchCancel" runat="server" class="btn btn-default" meta:resourcekey="Btn_Cancel" data-toggle="modal" data-target="#divCancelModal" style="display:none"/>
                                        <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Clear" style="display:none"/>
                                        <asp:Button ID="btnSearchList" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Search" style="display:none"/>
                                        <asp:Button ID="btnCreateVectorSurveillance" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Vector_Surveillance" />
                                    </div>
                                </div>
                            </div>
<%--End: Search section--%>

<%--Begin: Vector Section--%>
                            <div id="divVector" class="row embed-panel" runat="server" style="display:none">
                                <p><asp:CustomValidator ID="cvVectorSummary" runat="server" OnServerValidate="cvVectorSummary_ServerValidate" ValidationGroup="VectorSummary"></asp:CustomValidator></p>
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                    <h3 id="vectorSummaryHeader" class="heading" runat="server" meta:resourcekey="hdg_Vector_Surveillance_Session_Summary"></h3>
                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                    <span id="btnShowVectorSummary" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" style="display:none" onclick="showSection(event);" meta:resourcekey="btn_Show_Vector_Summary"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
<%--Begin: Vector summary Section--%>
                                            <div class="row" id="divVectorSummarySection" runat="server">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Session_ID">
                                                            <label for="txtstrSessionID" runat="server" meta:resourcekey="lbl_Session_ID"></label>
                                                            <asp:TextBox ID="txtstrSessionID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Field_Session_ID">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Field_Session_ID"></div>
                                                            <label for="txtstrFieldSessionID" runat="server" meta:resourcekey="lbl_Field_Session_ID"></label>
                                                            <asp:TextBox ID="txtstrFieldSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtstrFieldSessionID" CssClass="alert-danger" Display="Dynamic" meta:resourceKey="val_Field_Session_ID" ValidationGroup="VectorSection"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Vector_Surveillance_Status">
                                                            <div class="glyphicon glyphicon-certificate text-danger"></div>
                                                            <label for="ddlidfsVectorSurveillanceStatus" runat="server" meta:resourcekey="lbl_Status"></label>
                                                            <asp:DropDownList ID="ddlidfsVectorSurveillanceStatus" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator ControlToValidate="ddlidfsVectorSurveillanceStatus" runat="server" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Vector_Surveillance_Status"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="divVectorSummary" runat="server">
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Outbreak_ID">
                                                                <label for="txtidfOutbreak" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                                <asp:TextBox ID="txtidfOutbreak" runat="server" CssClass="form-control" Enabled="false" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Start_Date">
                                                                <div class="glyphicon glyphicon-certificate text-danger"></div>
                                                                <label for="txtdatStartDate" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                                <eidss:CalendarInput ID="txtdatStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                <asp:RequiredFieldValidator ControlToValidate="txtdatStartDate" runat="server" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Start_Date"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div id="divCloseDates" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" style="display:none">
                                                                <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Close_Date"></div>
                                                                <label for="txtdatCloseDate" runat="server" meta:resourcekey="lbl_Close_Date"></label>
                                                                <asp:TextBox ID="txtdatCloseDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Description">
                                                                <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Description"></div>
                                                                <label for="txtstrDescription" runat="server" meta:resourcekey="lbl_Description"></label>
                                                                <asp:TextBox ID="txtstrDescription" runat="server" CssClass="form-control" TextMode="MultiLine" MaxLength="100"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ControlToValidate = "txtstrDescription" runat="server" ValidationExpression = "^[\s\S]{0,300}$" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Vector_Description"></asp:RegularExpressionValidator>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div id="VectorTypes" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Vector_Types" style="display:none">
                                                                <label for="txtstrVectors" runat="server" meta:resourcekey="lbl_Vector_Types"></label>
                                                                <asp:TextBox ID="txtstrVectors" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Collection_Effort">
                                                                <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Collection_Effort"></div>
                                                                <label for="txtintCollectionEffort" runat="server" meta:resourcekey="lbl_Collection_Efforts"></label>
                                                                <eidss:NumericSpinner ID="txtintCollectionEffort" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                                <asp:RequiredFieldValidator ControlToValidate="txtintCollectionEffort" runat="server" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Collection_Effort"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div id="VectorDiseases" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Diseases" style="display:none">
                                                                <label for="txtstrDiagnoses" runat="server" meta:resourcekey="lbl_Diseases"></label>
                                                                <asp:TextBox ID="txtstrDiagnoses" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
<%--End: Vector summary Section--%>

<%--Begin: Location Section--%>
                                            <div id="divLocation" runat="server" class="panel panel-default" style="display:none">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                            <h3 id="vectorLocationHeader" class="heading" runat="server" meta:resourcekey="hdg_Location"></h3>
                                                        </div>
                                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                            <h3 id="btnShowVectorLocation" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" style="display:none" onclick="showSection(event);" meta:resourcekey="btn_Show_Vector_Summary"></h3>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div id="divVectorLocation" runat="server" class="panel-body">
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label for="hdfAddressType" runat="server" meta:resourcekey="lbl_Type_of_Address"></label>
                                                                <div class="input-group">
                                                                    <div class="btn-group">
                                                                        <asp:RadioButtonList ID="rblidfLocation" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>                                                       

                                                    <div id="divVectorLocationType" class="form-group" runat="server">
                                                        <div id="vectorIns_country_required" class="glyphicon glyphicon-certificate text-danger" runat="server" style="display:none"></div>

                                                        <eidss:LocationUserControl ID="ucLocVD" runat="server" IsHorizontalLayout="true" ValidationGroup="VectorSection" />

                                                        <div id="divForeignAddress" class="form-group" runat="server" style="display:none">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Foreign_Address_Type" runat="server"></div>
                                                            <label runat="server" id="lbl_Address" meta:resourcekey="lbl_Address"></label>
                                                            <asp:TextBox ID="txtForeignAddressType" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtForeignAddressType" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Foreign_Address_Type"></asp:RequiredFieldValidator>
                                                        </div>
                                                            
                                                        <div class="form-group" id="divRelativeAddress" runat="server" style="display:none">
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Ground_Type" runat="server"></div>
                                                                    <label runat="server" meta:resourcekey="lbl_Groud_Type"></label>
                                                                    <asp:DropDownList ID="ddlGroundType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Distance">
                                                                    <label runat="server" meta:resourcekey="lbl_Distance"></label>
                                                                    <eidss:NumericSpinner ID="txtDistance" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Direction">
                                                                    <label runat="server" meta:resourcekey="lbl_Direction"></label>
                                                                    <eidss:NumericSpinner ID="txtDirection" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="form-group" id="divLocationDesc" runat="server" style="display:none">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Country_Location_Desc" runat="server"></div>
                                                            <label for="txtLocationDescription" runat="server" meta:resourcekey="lbl_Description_of_Location"></label>
                                                            <asp:TextBox ID="txtLocationDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLocationDescription" Display="Dynamic" ValidationGroup="VectorSection" meta:resourceKey="val_Country_Location_Desc"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
<%--End: Location Section--%>

<%--Begin: Detailed Collection Section--%>
                                            <div id="divDetailedCollection" class="panel panel-default" runat="server" style="display:none">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                            <h3 id="vectorDetailedCollectionHeader" class="heading" runat="server" meta:resourcekey="hdg_Detailed_Collections"></h3>
                                                        </div>
                                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                            <span id="btnShowVectorDetailedCollection" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" style="display:none" onclick="showSection(event);" meta:resourcekey="btn_Show_Vector_Summary"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="divVectorDetailedCollection" runat="server" class="panel-body">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                        <asp:Button ID="btnNewDetailedCollection" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Detailed_Collection" />
                                                    </div>
                                                    <asp:UpdatePanel ID="upDetailedCollections" runat="server">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="gvDetailedCollections" EventName="RowCommand" />
                                                            <asp:AsyncPostBackTrigger ControlID="gvDetailedCollections" EventName="Sorting" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <div class="table-responsive">
                                                                <asp:GridView ID="gvDetailedCollections"
                                                                    runat="server"
                                                                    AllowSorting="True" 
                                                                    AutoGenerateColumns="False" 
                                                                    CssClass="table table-striped" 
                                                                    DataKeyNames="idfVector" 
                                                                    ShowHeaderWhenEmpty="true" 
                                                                    ShowHeader="true" 
                                                                    EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                                    ShowFooter="False" 
                                                                    GridLines="None" 
                                                                    AllowPaging="true" 
                                                                    PagerSettings-Visible="false">
                                                                    <HeaderStyle CssClass="table-striped-header" />
                                                                    <PagerSettings Visible="False" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="<%$ Resources:btn_Copy_Detailed_Collection.InnerText %>">
                                                                            <ItemTemplate>
                                                                                <asp:CheckBox ID="chkCopyVSSDetailedCollectionResults" runat="server" AutoPostBack="true" CausesValidation="false" OnCheckedChanged="chkCopyVSSDetailedCollectionResults_CheckedChanged" />
                                                                                <br />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_Pool_Vector_ID.InnerText %>" SortExpression="idfVector">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="btnSelectVSSDetailedCollectionResults" runat="server" Text='<%# Eval("idfVector") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("idfVector").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="strFieldVectorID" SortExpression="strFieldVectorID" HeaderText="<%$ Resources:lbl_Field_Pool_Vector_ID.InnerText %>" />
                                                                        <asp:BoundField DataField="strVectorType" SortExpression="strVectorType" HeaderText="<%$ Resources:lbl_Vector_Type.InnerText %>" />
                                                                        <asp:BoundField DataField="datCollectionDateTime" SortExpression="datCollectionDateTime" DataFormatString="{0:d}" HeaderText="<%$ Resources:lbl_Collection_Date.InnerText %>" />
                                                                        <asp:BoundField DataField="strRegion" SortExpression="strRegion" HeaderText="<%$ Resources: lbl_Region.InnerText %>" />
                                                                        <asp:BoundField DataField="strRayon" SortExpression="strRayon" HeaderText="<%$ Resources: lbl_Rayon.InnerText %>" />
                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                            <ItemTemplate>
                                                                                <asp:UpdatePanel ID="upEditVSSDetailedCollection" runat="server">
                                                                                    <Triggers>
                                                                                        <asp:AsyncPostBackTrigger ControlID="btnEditVSSDetailedCollection" />
                                                                                    </Triggers>
                                                                                    <ContentTemplate>
                                                                                        <asp:LinkButton ID="btnEditVSSDetailedCollection" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("idfVector") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </ItemTemplate>
                                                                            <ItemStyle CssClass="icon" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                            <ItemTemplate>
                                                                                <asp:UpdatePanel ID="upDeleteVSSDetailedCollection" runat="server">
                                                                                    <Triggers>
                                                                                        <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSDetailedCollection" />
                                                                                    </Triggers>
                                                                                    <ContentTemplate>
                                                                                        <asp:LinkButton ID="btnDeleteVSSDetailedCollection" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfVector") %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </ItemTemplate>
                                                                            <ItemStyle CssClass="icon" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField>
                                                                            <ItemTemplate>
                                                                                <span class="glyphicon glyphicon-triangle-bottom" style="cursor:pointer" onclick="showVSSSubGrid(event,'divDC<%#Eval("idfVector") %>');"></span>
                                                                                <tr id="divDC<%# Eval("idfVector") %>" style="display: none">
                                                                                    <td style="border-top: 0 none transparent"></td>
                                                                                    <td colspan="6" style="border-top: 0 none transparent">
                                                                                        <div class="form-group form-group-sm">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Collected_by_Institution"></label>
                                                                                                    <asp:TextBox ID="txtCollectedByOffice" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Species"></label>
                                                                                                    <asp:TextBox ID="txtSpecies" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strSpecies") %>'></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-group form-group-sm">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Disease"></label>
                                                                                                    <asp:TextBox ID="txtDisease" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Field_Sample_ID"></label>
                                                                                                    <asp:TextBox ID="txtFieldSampleID" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-group form-group-sm">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                                                                                    <asp:TextBox ID="txtSampleType" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Result_Date"></label>
                                                                                                    <asp:TextBox ID="txtdatResultDate" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-group form-group-sm">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                                                                                    <asp:TextBox ID="txtTestName" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Test_Result"></label>
                                                                                                    <asp:TextBox ID="txtTestResult" runat="server" CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </div>
                                                            <div id="divDetailedCollectionsPager" class="row" runat="server">
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                                    <asp:Repeater ID="rptDetailedCollectionsPager" runat="server">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upDetailedCollectionsPager" runat="server" RenderMode="Inline">
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="lnkDetailedCollectionsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </div>
<%--End: Detailed Collection Section--%>

<%--Begin: Aggregate Collection Section--%>
                                            <div id="divAggregateCollection" class="panel panel-default" runat="server" style="display:none">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                            <h3 id="vectorAggregateCollectionHeader" class="heading" runat="server" meta:resourcekey="hdg_Aggregate_Collections"></h3>                                                                
                                                        </div>
                                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                            <span id="btnShowVectorAggregateCollection" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" style="display:none" onclick="showSection(event);" meta:resourcekey="btn_Show_Vector_Summary"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="divVectorAggregateCollection" runat="server" class="panel-body">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                        <asp:Button ID="btnAddNewAggregateCollection" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Aggregate_Collection" />
                                                    </div>
                                                    <asp:UpdatePanel ID="upAggregateCollection" runat="server">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="gvAggregateCollections" EventName="RowCommand" />
                                                            <asp:AsyncPostBackTrigger ControlID="gvAggregateCollections" EventName="Sorting" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <div class="table-responsive">
                                                                <asp:GridView ID="gvAggregateCollections"
                                                                    runat="server"
                                                                    AllowSorting="True" 
                                                                    AutoGenerateColumns="False" 
                                                                    CssClass="table table-striped" 
                                                                    DataKeyNames="idfsVSSessionSummary" 
                                                                    ShowHeaderWhenEmpty="true" 
                                                                    ShowHeader="true" 
                                                                    EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                                    ShowFooter="False" 
                                                                    GridLines="None" 
                                                                    AllowPaging="true" 
                                                                    PagerSettings-Visible="false">
                                                                    <HeaderStyle CssClass="table-striped-header" />
                                                                    <PagerSettings Visible="False" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_Record_ID.InnerText %>" SortExpression="idfsVSSessionSummary">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="btnSelectVSSAggregateCollectionResults" runat="server" Text='<%# Eval("idfsVSSessionSummary") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("idfsVSSessionSummary").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="strVectorType" SortExpression="strVectorType" HeaderText="<%$ Resources:lbl_Vector_Type.InnerText %>" />
                                                                        <asp:BoundField DataField="datCollectionDateTime" SortExpression="datCollectionDateTime" DataFormatString="{0:d}" HeaderText="<%$ Resources:lbl_Collection_Date.InnerText %>" />
                                                                        <asp:BoundField DataField="intQuantity" SortExpression="intQuantity" HeaderText="<%$ Resources: lbl_Number_of_Positive_Pools_Vectors.InnerText %>" />
                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                            <ItemTemplate>
                                                                                <asp:UpdatePanel ID="upEditVSSAggregateCollection" runat="server">
                                                                                    <Triggers>
                                                                                        <asp:AsyncPostBackTrigger ControlID="btnEditVSSAggregateCollection" />
                                                                                    </Triggers>
                                                                                    <ContentTemplate>
                                                                                        <asp:LinkButton ID="btnEditVSSAggregateCollection" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("idfsVSSessionSummary") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </ItemTemplate>
                                                                            <ItemStyle CssClass="icon" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                            <ItemTemplate>
                                                                                <asp:UpdatePanel ID="upDeleteVSSAggregateCollection" runat="server">
                                                                                    <Triggers>
                                                                                        <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSAggregateCollection" />
                                                                                    </Triggers>
                                                                                    <ContentTemplate>
                                                                                        <asp:LinkButton ID="btnDeleteVSSAggregateCollection" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfsVSSessionSummary") %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </ItemTemplate>
                                                                            <ItemStyle CssClass="icon" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField>
                                                                            <ItemTemplate>
                                                                                <span class="glyphicon glyphicon-triangle-bottom" style="cursor:pointer" onclick="showVSSSubGrid(event,'divAC<%#Eval("idfsVSSessionSummary") %>');"></span>
                                                                                <tr id="divAC<%# Eval("idfsVSSessionSummary") %>" style="display: none">
                                                                                    <td></td>
                                                                                    <td colspan="6">
                                                                                        <div class="form-group">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Species"></label>
                                                                                                    <asp:TextBox ID="txtSpecies" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strVectorSubType") %>'></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Sex"></label>
                                                                                                    <asp:TextBox ID="txtSex" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strSex") %>'></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-group">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Region"></label>
                                                                                                    <asp:TextBox ID="txtRegion" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("Region") %>'></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-lg-4 col-md-4 col-xs-6 col-sm-6">
                                                                                                    <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                                                                                    <asp:TextBox ID="txtRayon" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("Rayon") %>'></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="idfsVSSessionSummary" visible="false" />
                                                                        <asp:BoundField DataField="idfsVectorType" visible="false" />
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </div>
                                                            <div id="divAggregateCollectionsPager" class="row" runat="server">
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblAggregateCollectionsNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblAggregateCollectionsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                                    <asp:Repeater ID="rptAggregateCollectionsPager" runat="server">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upAggregateCollectionsPager" runat="server" RenderMode="Inline">
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="lnkAggregateCollectionsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </div>
<%--End: Aggregate Collection Section--%>
                                        </div>
                                    </div>
                                </div>
                                <div id="divCreateVectorSurveillance" runat="server" class="row" style="display:none">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                        <button type="button" id="btnVectorSummaryCancel" runat="server" class="btn btn-default" meta:resourcekey="Btn_Cancel" data-toggle="modal" data-target="#divCancelModal" style="display:none"/>
                                        <asp:Button ID="btnReturnToSearchFromVector" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Cancel" style="display:none" />
                                        <asp:Button ID="btnVectorSummarySubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" style="display:none" />
                                        <asp:Button ID="btnVectorSummaryPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" style="display:none" />
                                        <asp:Button ID="btnVectorSummaryDelete" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Delete" style="display:none" />
                                    </div>
                                </div>
                            </div>
<%--End: Vector Section--%>

<%--Begin: Detailed Collection Detail Section--%>
                            <div id="divDetailedCollectionDetail" class="row embed-panel" runat="server" style="display:none">
                                <div class="sectionContainer expanded">
                                    <section class="col-md-12" id="vectorGeneral" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hdg_Collection_Data" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" id="sidebar_edit_menu_0" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)" meta:resourcekey="lbl_Collection_Data_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div id="PoolVectorID" runat="server" class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Vector">
                                                            <label runat="server" meta:resourcekey="lbl_PoolVectorId"></label>
                                                            <asp:TextBox ID="txtidfVector" runat="server" CssClass="form-control" Enabled="False"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Field_Pool_Vector_ID">
                                                            <label runat="server" meta:resourcekey="lbl_FieldPoolVectorID"></label>
                                                            <asp:TextBox ID="txtstrFieldVectorID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" runat="server" meta:resourcekey="dis_Detailed_Vector_Type">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                            <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Detailed_Vector_Type"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Vector_Type"></label>
                                                            <asp:DropDownList ID="ddlidfDetailedVectorType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfDetailedVectorType" InitialValue="null" Display="Static" ValidationGroup="vectorGeneral" meta:resourceKey="val_Detailed_Vector_Type" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="rdbDifferentLocationfromSession" class="form-group" runat="server" style="display:inline">
                                                    <label for="hdfblnDifferentLocationfromSession" runat="server" meta:resourcekey="lbl_Different_Location_from_Session"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group" style="margin-bottom:10px">
                                                            <asp:RadioButton ID="rdbDifferentLocationfromSessionYes" runat="server" CssClass="radio-inline" GroupName="DifferentDetailedLocationfromSession" Text="<%$ resources:lbl_Yes.InnerText %>" AutoPostBack="true" />
                                                            <asp:RadioButton ID="rdbDifferentLocationfromSessionNo" runat="server" CssClass="radio-inline" GroupName="DifferentDetailedLocationfromSession" Text="<%$ resources:lbl_No.InnerText %>" AutoPostBack="true" />
                                                        </div>
                                                    </div>
                                                </div>

<%--Begin: Detailed Geo Location--%>
                                                <div id="divVSSDetailedCollectionLocation" runat="server" class="form-group" style="display:none">
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Type_of_Address"></label>
                                                                <div class="input-group">
                                                                    <div class="btn-group">
                                                                        <asp:RadioButtonList ID="rbldidfsGeoLocationType" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div id="divVSSDetailedCollectionLocationType" class="form-group" runat="server">
                                                        <div id="lucDetailedCollection_country_required" class="glyphicon glyphicon-certificate text-danger" runat="server" style="display:none"></div>

                                                        <eidss:LocationUserControl ID="ucLocDC" runat="server" IsHorizontalLayout="true" />

                                                        <div id="divVSSDetailedCollectionForeignAddress" class="form-group" runat="server" style="display:none">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Foreign_Address_Type" runat="server"></div>
                                                            <label runat="server" id="lblstrForeignAddress" meta:resourcekey="lbl_Address"></label>
                                                            <asp:TextBox ID="txtstrForeignAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtstrForeignAddress" Display="Dynamic" meta:resourceKey="val_Foreign_Address_Type"></asp:RequiredFieldValidator>
                                                        </div>
                                                            
                                                        <div class="form-group" id="divVSSDetailedCollectionRelativeAddress" runat="server" style="display:none">
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Ground_Type" runat="server"></div>
                                                                    <label runat="server" meta:resourcekey="lbl_Groud_Type"></label>
                                                                    <asp:DropDownList ID="ddlDetailedGroundType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Distance">
                                                                    <label runat="server" meta:resourcekey="lbl_Distance"></label>
                                                                    <eidss:NumericSpinner ID="txtDetailedDistance" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Direction">
                                                                    <label runat="server" meta:resourcekey="lbl_Direction"></label>
                                                                    <eidss:NumericSpinner ID="txtDetailedDirection" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="form-group" id="divVSSDetailedCollectionLocationDesc" runat="server" style="display:none">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Country_Location_Desc" runat="server"></div>
                                                            <label for="txtDetailedLocationDescription" runat="server" meta:resourcekey="lbl_Description_of_Location"></label>
                                                            <asp:TextBox ID="txtDetailedLocationDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDetailedLocationDescription" Display="Dynamic" meta:resourceKey="val_Country_Location_Desc"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
<%--End: Detailed Geo Location--%>

                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Elevation">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Detailed_Elevation"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Elevation"></label>
                                                            <eidss:NumericSpinner ID="txtintDetailedElevation" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtintDetailedElevation" ValidationGroup="vectorGeneral" meta:resourceKey="val_Detailed_Elevation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Surroundings">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Detailed_Surroundings"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Surroundings"></label>
                                                            <asp:DropDownList ID="ddlDetailedSurroundings" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDetailedSurroundings" ValidationGroup="vectorGeneral" meta:resourceKey="val_Detailed_Surroundings" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_GEO_Reference_Source">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_GEO_Reference_Source"></div>
                                                            <label runat="server" meta:resourcekey="lbl_GEO_Reference_Source"></label>
                                                            <asp:TextBox ID="txtstrGEOReferenceSource" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtstrGEOReferenceSource" ValidationGroup="vectorGeneral" meta:resourceKey="val_GEO_Reference_Source" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Basis_of_Record">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Basis_of_Record"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Basis_of_Record"></label>
                                                            <asp:DropDownList ID="ddlidfsBasisofRecord" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsBasisofRecord" InitialValue="null" ValidationGroup="vectorGeneral" meta:resourceKey="val_Basis_of_Record" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div id="detailedHostReference" class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Basis_of_Record" visible="false">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Host_Reference"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Hosts_Reference"></label>
                                                            <asp:DropDownList ID="ddlidfsHostReference" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Collected_By_Office">
                                                            <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Collected_By_Office"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Collected_by_Institution"></label>
                                                            <asp:DropDownList ID="ddlidfCollectedByOffice" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfCollectedByOffice" InitialValue="null" Display="Dynamic" ValidationGroup="vectorGeneral" meta:resourceKey="val_Collected_By_Office" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Collected_By_Person">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Collected_By_Person"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Collected_by_Person"></label>
                                                            <asp:DropDownList ID="ddlidfCollectedByPerson" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfCollectedByPerson" InitialValue="null" Display="Dynamic" ValidationGroup="vectorGeneral" meta:resourceKey="val_Collected_By_Person" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                            <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Collection_Date"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Collection_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatCollectionDateTime" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtdatCollectionDateTime" Display="Dynamic" ValidationGroup="vectorGeneral" meta:resourceKey="val_Collection_Date" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Day_Period">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Day_Period"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Collection_Time"></label>
                                                            <asp:DropDownList ID="ddlidfsDayPeriod" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsDayPeriod" InitialValue="" Display="Dynamic" ValidationGroup="vectorGeneral" meta:resourceKey="val_Day_Period" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Collection_Method">
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Collection_Method"></div>
                                                            <label runat="server" meta:resourcekey="lbl_Collection_Method"></label>
                                                            <asp:DropDownList ID="ddlidfsCollectionMethod" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsCollectionMethod" InitialValue="null" Display="Dynamic" ValidationGroup="vectorGeneral" meta:resourceKey="val_Collection_Method" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Ectoparasites_Collected">
                                                            <label runat="server" meta:resourcekey="lbl_Ectoparasites_Collected"></label>
                                                            <asp:DropDownList ID="ddlidfsEctoparasitesCollected" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                    <section class="col-md-12 hidden" id="vectorData" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hdg_Vector_Data" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" id="sidebar_edit_menu_1" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)" meta:resourcekey="lbl_Vector_Data_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Quantity">
                                                            <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Quantity"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Quantity"></label>
                                                            <eidss:NumericSpinner ID="txtintQuantity" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtintQuantity" Display="Dynamic" ValidationGroup="vectorData" meta:resourceKey="val_Quantity" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12" meta:resourcekey="dis_Vector_SubType">
                                                            <span class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="req_Vector_SubType"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Species"></label>
                                                            <asp:DropDownList ID="ddlidfsVectorSubType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsVectorSubType" InitialValue="null" Display="Dynamic" ValidationGroup="vectorData" meta:resourceKey="val_Vector_Sub_Type" CssClass="alert-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Sex">
                                                            <span class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Sex"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Sex"></label>
                                                            <asp:DropDownList ID="ddlidfsSex" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsSex" InitialValue="null" Display="Dynamic" ValidationGroup="vectorData" meta:resourceKey="val_Vector_Sex" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Identified_by_Office">
                                                            <label runat="server" meta:resourcekey="lbl_Identified_by_Office"></label>
                                                            <asp:DropDownList ID="ddlidfIdentifiedByOffice" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="dis_Identified_by_Person">
                                                            <label runat="server" meta:resourcekey="lbl_Identified_by_Person"></label>
                                                            <asp:LinkButton ID="btnCreateIdentifiedByPerson" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false" visible="false"><span class="glyphicon glyphicon-plus-sign""></span></asp:LinkButton>
                                                            <asp:DropDownList ID="ddlidfIdentifiedByPerson" runat="server" CssClass="form-control"></asp:DropDownList>                                                      
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Identifying_Method">
                                                            <label runat="server" meta:resourcekey="lbl_Identifying_Method"></label>
                                                            <asp:DropDownList ID="ddlidfsIdentificationMethod" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Identification_Date">
                                                            <label runat="server" meta:resourcekey="lbl_Identification_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatIdentifiedDateTime" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                    <section class="col-md-12 hidden" id="vectorSpecificData" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hdg_Vector_Specific_Data" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" id="sidebar_edit_menu_2" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(2)" meta:resourcekey="lbl_Vector_Specifics_Data_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                            </div>
                                        </div>
                                    </section>
                                    <section class="col-md-12 hidden" id="vectorSamples" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hpl_Samples" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <input type="button" id="addSamplebtn" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Add_Sample" />
                                                        <a href="#" id="sidebar_edit_menu_3" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(3)" meta:resourcekey="lbl_Vector_Samples_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <asp:UpdatePanel ID="upDetailedCollectionsSample" runat="server">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsSample" EventName="RowCommand" />
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsSample" EventName="Sorting" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="table-responsive">
                                                            <asp:GridView ID="gvDetailedCollectionsSample"
                                                                runat="server"
                                                                AllowSorting="True" 
                                                                AutoGenerateColumns="False" 
                                                                CssClass="table table-striped" 
                                                                DataKeyNames="idfMaterial, idfsSampleType, strSampleName, idfFieldCollectedByOffice, idfSendToOffice, RecordAction" 
                                                                ShowHeaderWhenEmpty="true" 
                                                                ShowHeader="true" 
                                                                EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                                ShowFooter="False" 
                                                                GridLines="None" 
                                                                AllowPaging="true" 
                                                                PagerSettings-Visible="false">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerSettings Visible="False" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:hdg_Lab_Bar_Code.InnerText %>" SortExpression="strBarcode">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelectVSSDetailedCollectionSampleResults" runat="server" Text='<%# Eval("strBarcode") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("idfMaterial").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                            <br />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:BoundField DataField="strFieldBarcode" SortExpression="strFieldBarcode" HeaderText="<%$ Resources:hdg_Field_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" SortExpression="datFieldCollectionDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources:lbl_Collection_Date.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleName" SortExpression="strSampleName" HeaderText="<%$ Resources:hdg_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="strFieldCollectedByOffice" SortExpression="strFieldCollectedByOffice" HeaderText="<%$ Resources: hdg_Collected_By.InnerText %>" />
                                                                    <asp:BoundField DataField="strSendToOffice" SortExpression="strSendToOffice" HeaderText="<%$ Resources: hdg_Sent_To.InnerText %>" />
                                                                    <asp:BoundField DataField="strCondition" SortExpression="strCondition" HeaderText="<%$ Resources: hdg_Condition_Received.InnerText %>" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upEditVSSDetailedCollectionSample" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnEditVSSDetailedCollectionSample" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnEditVSSDetailedCollectionSample" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("idfMaterial") %>'><span id="gvRowEdit_Sample" class="btn glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upDeleteVSSDetailedCollectionSample" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSDetailedCollectionSample" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteVSSDetailedCollectionSample" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfMaterial") %>'><span id="gvRowDelete_Sample" class="btn glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                        <div id="divDetailedCollectionsSamplePager" class="row" runat="server">
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsSampleNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsSamplePageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                                <asp:Repeater ID="rptDetailedCollectionsSamplePager" runat="server">
                                                                    <ItemTemplate>
                                                                        <asp:UpdatePanel ID="upDetailedCollectionsSamplePager" runat="server" RenderMode="Inline">
                                                                            <ContentTemplate>
                                                                                <asp:LinkButton ID="lnkDetailedCollectionsSamplePage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </section>
                                    <section class="col-md-12 hidden" id="vectorFieldTests" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hpl_Field_Tests" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <input type="button" id="addFieldTestbtn" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Add_Field_Test" />
                                                        <a href="#" id="sidebar_edit_menu_4" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(4)" meta:resourcekey="lbl_Field_Tests_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <asp:UpdatePanel ID="upDetailedCollectionsFieldTests" runat="server">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsFieldTests" EventName="RowCommand" />
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsFieldTests" EventName="Sorting" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="table-responsive">
                                                            <asp:GridView ID="gvDetailedCollectionsFieldTests"
                                                                runat="server"
                                                                AllowSorting="True" 
                                                                AutoGenerateColumns="False" 
                                                                CssClass="table table-striped" 
                                                                DataKeyNames="idfTesting, idfsTestName, idfsTestCategory, idfTestedByOffice, idfsTestResult, idfTestedByPerson, idfsDiagnosis, RecordAction" 
                                                                ShowHeaderWhenEmpty="true" 
                                                                ShowHeader="true" 
                                                                EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                                ShowFooter="False" 
                                                                GridLines="None" 
                                                                AllowPaging="true" 
                                                                PagerSettings-Visible="false">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerSettings Visible="False" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:hdg_Field_Sample_ID.InnerText %>" SortExpression="strFieldBarcode">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelectVSSDetailedCollectionFieldTestsResults" runat="server" Text='<%# Eval("strFieldBarcode") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("idfTesting").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                            <br />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:BoundField DataField="strTestName" SortExpression="strTestName" HeaderText="<%$ Resources:hdg_Field_Test.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestCategoryName" SortExpression="strTestCategoryName" HeaderText="<%$ Resources:hdg_Test_Category.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestedByOfficeName" SortExpression="strTestedByOfficeName" HeaderText="<%$ Resources: hdg_Test_By_Office.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestResultName" SortExpression="strTestResultName" HeaderText="<%$ Resources: hdg_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestedByPersonName" SortExpression="strTestedByPersonName" HeaderText="<%$ Resources: hdg_Test_By_Person.InnerText %>" />
                                                                    <asp:BoundField DataField="strDiagnosisName" SortExpression="strDiagnosisName" HeaderText="<%$ Resources: hdg_Diagnosis.InnerText %>" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upEditVSSDetailedCollectionFieldTests" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnEditVSSDetailedCollectionFieldTests" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnEditVSSDetailedCollectionFieldTests" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("idfTesting") %>'><span id="gvRowEdit_FieldTests" class="btn glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upDeleteVSSDetailedCollectionFieldTests" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSDetailedCollectionFieldTests" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteVSSDetailedCollectionFieldTests" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfTesting") %>'><span id="gvRowDelete_FieldTests" class="btn glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                        <div id="divDetailedCollectionsFieldTestsPager" class="row" runat="server">
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsFieldTestsNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsFieldTestsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                                <asp:Repeater ID="rptDetailedCollectionsFieldTestsPager" runat="server">
                                                                    <ItemTemplate>
                                                                        <asp:UpdatePanel ID="upDetailedCollectionsFieldTestsPager" runat="server" RenderMode="Inline">
                                                                            <ContentTemplate>
                                                                                <asp:LinkButton ID="lnkDetailedCollectionsFieldTestsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </section>
                                    <section class="col-md-12 hidden" id="vectorLabTests" runat="server">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="hpl_Lab_Tests" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <input type="button" id="addLabTestsbtn" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Add_Lab_Tests" />
                                                        <a href="#" id="sidebar_edit_menu_5" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(5)" meta:resourcekey="lbl_Lab_Tests_Tab"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <asp:UpdatePanel ID="upDetailedCollectionsLabSample" runat="server">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsLabTests" EventName="RowCommand" />
                                                        <asp:AsyncPostBackTrigger ControlID="gvDetailedCollectionsLabTests" EventName="Sorting" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="table-responsive">
                                                            <asp:GridView ID="gvDetailedCollectionsLabTests"
                                                                runat="server"
                                                                AllowSorting="True" 
                                                                AutoGenerateColumns="False" 
                                                                CssClass="table table-striped" 
                                                                DataKeyNames="idfMaterial" 
                                                                ShowHeaderWhenEmpty="true" 
                                                                ShowHeader="true" 
                                                                EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                                ShowFooter="False" 
                                                                GridLines="None" 
                                                                AllowPaging="true" 
                                                                PagerSettings-Visible="false">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerSettings Visible="False" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:hdg_Lab_Sample_ID.InnerText %>" SortExpression="strLabSampleID">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelectVSSDetailedCollectionLabSampleResults" runat="server" Text='<%# Eval("strLabSampleID") %>' Visible="true" CommandName="Select" CommandArgument='<%# Eval("idfMaterial").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                            <br />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:BoundField DataField="strFieldSampleID" SortExpression="strFieldSampleID" HeaderText="<%$ Resources:hdg_Field_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSpeciesName" SortExpression="strSpeciesName" HeaderText="<%$ Resources:hdg_Species.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestName" SortExpression="strTestName" HeaderText="<%$ Resources:hdg_Test.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestResultName" SortExpression="strTestResultName" HeaderText="<%$ Resources: hdg_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="strDiseaseName" SortExpression="strDiseaseName" HeaderText="<%$ Resources: hdg_Disease.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" SortExpression="strSampleTypeName" HeaderText="<%$ Resources: hdg_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" SortExpression="datFieldCollectionDate" DataFormatString="{0:d}" HeaderText="<%$ Resources:hdg_Field_Collection_Date.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestCategoryName" SortExpression="strTestCategoryName" HeaderText="<%$ Resources: hdg_Test_Category.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestedByInstitutionName" SortExpression="strTestedByInstitutionName" HeaderText="<%$ Resources: hdg_Tested_By_Institution.InnerText %>" />
                                                                    <asp:BoundField DataField="strTestedByPersonName" SortExpression="strTestedByPersonName" HeaderText="<%$ Resources: hdg_Test_By_Person.InnerText %>" />
                                                                    <asp:BoundField DataField="strAmendmentHistory" SortExpression="strAmendmentHistory" HeaderText="<%$ Resources: hdg_Amendment_History.InnerText %>" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upEditVSSDetailedCollectionLabTests" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnEditVSSDetailedCollectionLabTests" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnEditVSSDetailedCollectionLabTests" runat="server" CausesValidation="False" CommandName="Edit" CommandArgument='<% #Bind("idfMaterial") %>'><span id="gvRowEdit_LabTests" class="btn glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:UpdatePanel ID="upDeleteVSSDetailedCollectionLabTests" runat="server">
                                                                                <Triggers>
                                                                                    <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSDetailedCollectionLabTests" />
                                                                                </Triggers>
                                                                                <ContentTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteVSSDetailedCollectionLabTests" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfMaterial") %>'><span id="gvRowDelete_LabTests" class="btn glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="icon" />
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                        <div id="divDetailedCollectionsLabTestsPager" class="row" runat="server">
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsLabTestsNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblDetailedCollectionsLabTestsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                                <asp:Repeater ID="rptDetailedCollectionsLabTestsPager" runat="server">
                                                                    <ItemTemplate>
                                                                        <asp:UpdatePanel ID="upDetailedCollectionsLabTestsPager" runat="server" RenderMode="Inline">
                                                                            <ContentTemplate>
                                                                                <asp:LinkButton ID="lnkDetailedCollectionsLabTestsPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            ID="sideBarItemGeneralData"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Collection_Data"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="1"
                                            ID="sideBarItemVectorData"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Vector_Data"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="2"
                                            ID="sideBarItemVectorSpecificData"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Vector_Specific_Data"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="3"
                                            ID="sideBarItemSamples"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Samples"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="4"
                                            ID="sideBarItemFieldTests"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Field_Tests"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="5"
                                            ID="sideBarItemLabTests"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Lab_Tests"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-file disabled"
                                            GoToTab="6"
                                            ID="sideBarItemReview"
                                            IsActive="true"
                                            ItemStatus="IsReview"
                                            meta:resourcekey="Tab_Review_Collection"
                                            runat="server">
                                        </eidss:SideBarItem>
                                    </MenuItems>
                                </eidss:SideBarNavigation>
                                <div class="col-lg-8 col-md-8 col-sm-12 col-xs-12 text-center">
                                    <button type="button" class="btn btn-default" runat="server" meta:resourcekey="Btn_Cancel" data-toggle="modal" data-target="#divCancelModal"></button>
                                    <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Previous" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                    <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Next" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                    <asp:Button ID="btnSubmit" runat="server" meta:resourcekey="btn_Submit" OnClientClick="goToTab(0);" CssClass="btn btn-primary" />
                                    <button id="btnDetailedCollCopy" type="button" runat="server" class="btn btn-primary" meta:resourcekey="btn_Copy" visible="false"></button>
                                    <button id="btnTryDetailedCollectionDelete" runat="server" class="btn btn-default" type="button" data-toggle="modal" data-target="#usrConfirmDetailedCollectionDelete" meta:resourcekey="lbl_Delete"></button>
                                </div>
                            </div>
<%--End: Detailed Collection Detail Section--%>

<%--Begin: Aggregate Collection Detail Section--%>
                            <div id="divAggregateCollectionDetail" class="row embed-panel" runat="server" style="display:none">
                                <div class="panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                <h3 runat="server" meta:resourcekey="hdg_Aggregate_Information"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                    <label for="<%= txtAggstrVSSessionSummaryID.ClientID %>" runat="server" meta:resourcekey="lbl_Record_ID"></label>
                                                    <asp:TextBox ID="txtAggstrVSSessionSummaryID" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Aggregate_Collection_Date">
                                                    <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Aggregate_Collection_Date"></div>
                                                    <label for="<%= txtAggdatCollectionDateTime.ClientID %>" runat="server" meta:resourcekey="lbl_Collection_Date"></label>
                                                    <eidss:CalendarInput ID="txtAggdatCollectionDateTime" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAggdatCollectionDateTime" InitialValue="null" ValidationGroup="VecSummaryCollection" meta:resourceKey="val_Aggregate_Collection_Date" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" meta:resourcekey="dis_Aggregate_Vector_Type">
                                                    <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Aggregate_Vector_Type"></div>
                                                    <label for="<%= ddlAggidfsVectorType.ClientID %>" runat="server" meta:resourcekey="lbl_Vector_Type"></label>
                                                    <asp:DropDownList ID="ddlAggidfsVectorType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlAggidfsVectorType" InitialValue="null" ValidationGroup="VecAggregateCollection" meta:resourceKey="val_Aggregate_Vector_Type" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="dis_Aggregate_Species">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Aggregate_Species"></div>
                                                    <label for="<%= ddlAggidfsVectorSubType.ClientID %>" runat="server" meta:resourcekey="lbl_Species"></label>
                                                    <asp:DropDownList ID="ddlAggidfsVectorSubType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlAggidfsVectorSubType" InitialValue="" ValidationGroup="VecAggregateCollection" meta:resourceKey="val_Aggregate_Species" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="dis_Aggregate_Sex">
                                                    <div class="glyphicon glyphicon-asterik" runat="server" meta:resourcekey="req_Aggregate_Sex"></div>
                                                    <label for="<%= ddlAggidfsSex.ClientID %>" runat="server" meta:resourcekey="lbl_Sex"></label>
                                                    <asp:DropDownList ID="ddlAggidfsSex" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlAggidfsSex" InitialValue="" ValidationGroup="VecAggregateCollection" meta:resourceKey="val_Aggregate_Sex" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="dis_Aggregate_Pools_Vectors">
                                                    <div class="glyphicon glyphicon-asterik" runat="server" meta:resourcekey="req_Aggregate_Pools_Vectors"></div>
                                                    <label for="<%= txtAggintQuantity.ClientID %>" runat="server" meta:resourcekey="lbl_Number_of_Pools_Vectors"></label>
                                                    <eidss:NumericSpinner ID="txtAggintQuantity" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAggintQuantity" InitialValue="" ValidationGroup="VecAggregateCollection" meta:resourceKey="val_Aggregate_Pools_Vectors" CssClass="text-danger"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                <h3 runat="server" meta:resourcekey="hdg_List_of_Diseases"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div id="disDiseaseMessage" runat="server" class="alert alert-danger alert-dismissable" visible="false">
                                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                                <strong runat="server" id="strDiseaseMessage"></strong>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="dis_Aggregate_Diagnosis">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Aggregate_Diagnosis"></div>
                                                <label for="<%= ddlAggregateDiagnosis.ClientID %>" runat="server" meta:resourcekey="lbl_Disease"></label>
                                                <asp:DropDownList ID="ddlAggregateDiagnosis" runat="server" CssClass="form-control"></asp:DropDownList>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlAggregateDiagnosis" InitialValue="" CssClass="text-danger" Display="Dynamic" meta:resourceKey="val_Aggregate_Diagnosis"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="dis_Number_of_Positive_Pools_Vectors">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" runat="server" meta:resourcekey="req_Number_of_Positive_Pools_Vectors"></div>
                                                <label for="<%= txtQuantity.ClientID %>" runat="server" meta:resourcekey="lbl_Number_of_Positive_Pools_Vectors"></label>
                                                <eidss:NumericSpinner ID="txtQuantity" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtQuantity" InitialValue="" CssClass="text-danger" Display="Dynamic" meta:resourceKey="val_Number_of_Positive_Pools_Vectors"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                                                <asp:Button ID="btnAddDisease" runat="server" meta:resourceKey="btn_Add_Disease" CssClass="btn btn-disease btn-sm" />
                                            </div>
                                        </div>
                                        <asp:UpdatePanel ID="upVSSAggregateCollectionDiseases" runat="server">
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="gvAggregateCollectionDiseases" EventName="RowCommand" />
                                                <asp:AsyncPostBackTrigger ControlID="gvAggregateCollectionDiseases" EventName="Sorting" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <div class="table-responsive">
                                                    <asp:GridView ID="gvAggregateCollectionDiseases" 
                                                        runat="server" 
                                                        AllowSorting="True" 
                                                        AutoGenerateColumns="False" 
                                                        CssClass="table table-striped" 
                                                        DataKeyNames="idfsVSSessionSummaryDiagnosis" 
                                                        ShowHeaderWhenEmpty="true" 
                                                        ShowHeader="true" 
                                                        EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                        ShowFooter="False" 
                                                        GridLines="None" 
                                                        AllowPaging="true" 
                                                        PagerSettings-Visible="false">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerSettings Visible="False" />
                                                        <Columns>
                                                            <asp:BoundField DataField="strDiagnosis" ReadOnly="true" SortExpression="strDiagnosis" HeaderText="<%$ Resources: Labels, Lbl_Diagnosis_Text %>" />
                                                            <asp:BoundField DataField="intPositiveQuantity" ReadOnly="true" SortExpression="intPositiveQuantity" HeaderText="<%$ Resources: Labels, Lbl_Quantity_Text %>" />
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:UpdatePanel ID="upDeleteVSSAggregateCollectionDiseases" runat="server">
                                                                        <Triggers>
                                                                            <asp:AsyncPostBackTrigger ControlID="btnDeleteVSSAggregateCollectionDiseases" />
                                                                        </Triggers>
                                                                        <ContentTemplate>
                                                                            <asp:LinkButton ID="btnDeleteVSSAggregateCollectionDiseases" runat="server" CausesValidation="False" CommandName="Delete" CommandArgument='<% #Bind("idfsVSSessionSummaryDiagnosis") %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </ItemTemplate>
                                                                <ItemStyle CssClass="icon" />
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                                <div id="divAggregateCollectionDiseasePager" class="row" runat="server">
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                        <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblAggregateCollectionDiseasesNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                        <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblAggregateCollectionDiseasesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                        <asp:Repeater ID="rptAggregateCollectionDetailDiseasesPager" runat="server">
                                                            <ItemTemplate>
                                                                <asp:UpdatePanel ID="upAggregateCollectionDiseasesPager" runat="server" RenderMode="Inline">
                                                                    <ContentTemplate>
                                                                        <asp:LinkButton ID="lnkAggregateCollectionDiseasesPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </div>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                    <button type="button" class="btn btn-default" runat="server" meta:resourcekey="Btn_Cancel" data-toggle="modal" data-target="#divCancelModal"></button>
                                    <asp:Button ID="btnSaveSummaryCollection" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Submit" />
                                    <button id="btnTryAggregateCollectionDelete" runat="server" class="btn btn-default" type="button" data-toggle="modal" data-target="#usrConfirmAggregateCollectionDelete" meta:resourcekey="lbl_Delete"></button>
                                </div>
                            </div>
<%--End: Aggregate Collection Detail Section--%>

                        </div>
                    </div>
                </div>
            </div>

<%--Begin: Popup Section--%>

<%--Begin: Error modal popup Section--%>

            <div class="modal" id="divErrorModal" runat="server" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Vector_Surveillance_Session"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                    <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                </div>
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                    <p id="lblErr" runat="server"></p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>

<%--End: Error modal popup Section--%>

<%--Begin: Cancel popup Section--%>

            <div class="modal" id="divCancelModal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Vector_Surveillance_Session"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                    <span class="glyphicon glyphicon-alert modal-icon"></span>
                                </div>
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                    <p id="lblCancelModalMsg" runat="server"></p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnCancelModal" runat="server" CssClass="btn btn-primary" meta:resourcekey="Btn_Yes" />
                            <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                        </div>
                    </div>
                </div>
            </div>

<%--End: Cancel popup Section--%>

<%--Begin: Success popup Section--%>

            <div class="modal" id="divSuccessModal" runat="server" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Vector_Surveillance_Session"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                    <span class="glyphicon glyphicon-ok-circle modal-icon"></span>
                                </div>
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                    <p id="lblSuccess" runat="server"></p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>

<%--End: Success popup Section--%>

<%--Begin: Delete confirm popup Section--%>

            <asp:UpdatePanel ID="upConfirmDeleteModal" runat="server">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnConfirmDeleteModal" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div class="modal" id="divConfirmDeleteModal" runat="server" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" id="h4DeleteHeader" meta:resourcekey="hdg_Vector_Surveillance_Session"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblDeleteModalMsg" runat="server"></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <asp:Button ID="btnConfirmDeleteModal" runat="server" CssClass="btn btn-primary" meta:resourcekey="Btn_Yes" />
                                    <button type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No">
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div> 
                </ContentTemplate>
            </asp:UpdatePanel>

<%--End: Delete confirm popup Section--%>

<%--Begin: Detailed collection copy popup Section--%>

            <asp:UpdatePanel ID="upDetailedCollectionCopyModal" runat="server">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnDetailedCollectionCopyConfirm" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div class="modal" id="divDetailedCollectionCopyModal" runat="server" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" id="h1" meta:resourcekey="hdg_Vector_Surveillance_Session"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server">
                                                            <div class="form-check">
                                                                <asp:CheckBox ID="chkCollectionData" runat="server" CssClass="form-check-input" Checked="true" Enabled="false" />
                                                                <label for="chkCollectionData" runat="server" meta:resourcekey="lbl_CollectionData" ></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server">
                                                            <div class="form-check">
                                                                <asp:CheckBox ID="chkVectorData" runat="server" CssClass="form-check-input" />
                                                                <label for="chkVectorData" runat="server" meta:resourcekey="lbl_VectorData"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server">
                                                            <div class="form-check">
                                                                <asp:CheckBox ID="chkSamples" runat="server" CssClass="form-check-input" />
                                                                <label for="chkSamples" runat="server" meta:resourcekey="lbl_Samples"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server">
                                                            <div class="form-check">
                                                                <asp:CheckBox ID="chkFieldTests" runat="server" CssClass="form-check-input" />
                                                                <label for="chkFieldTests" runat="server" meta:resourcekey="lbl_FieldTests"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>                                            
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <asp:Button ID="btnDetailedCollectionCopyConfirm" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Close" />
                                    <button type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_Cancel">
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div> 
                </ContentTemplate>
            </asp:UpdatePanel>

<%--End: Detailed collection copy popup Section--%>

            <%--Hidden field required for side bar menu navigation--%>
            <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />

<%--Begin: Client scripts Section--%>

            <script type="text/javascript">

                $(document).ready(function () {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                });

                function callBackHandler() {
                    var formSection = $('#<%= ddlVSSFormSection.ClientID %>').val();
                    if (formSection == "7") {
                        //set for Vector Detailed Collection Detail section only
                        //refer to enum FormSection
                        setEnableControlsOvrride(true);
                        setViewOnPageLoad("<%= hdnPanelController.ClientID %>");
                    };
                };

                function showSection(e) {

                    var _ctrl = e.target.id.split("_");
                    _ctrl = _ctrl[(_ctrl.length - 1)];
                    var _top = (e.target.className.indexOf("top") > 0);

                    //Refer to FormSectionShowHide ENUM for sections
                    var _val = 0;
                    switch (_ctrl) {
                        case 'btnShowSearchCriteria': {
                            _val = (_top ? 1 : 0);
                            break;
                        }
                        case 'btnShowVectorSummary': {
                            _val = (_top ? 3 : 2);
                            break;
                        }
                        case 'btnShowVectorLocation': {
                            _val = (_top ? 5 : 4);
                            break;
                        }
                        case 'btnShowVectorDetailedCollection': {
                            _val = (_top ? 7 : 6);
                            break;
                        }
                        case 'btnShowVectorAggregateCollection': {
                            _val = (_top ? 9 : 8);
                            break;
                        }
                        default: {
                            //alert(_val);
                        }
                    }
                    $('#<%= ddlVSSFormSectionShowHide.ClientID %>').val(_val).change();
                }

                function showVSSSubGrid(e, f) {
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

                function showErrorModal() {
                    $("#<%= divErrorModal.ClientID %>").modal('show');
                };

                function showDeleteModal() {
                    $("#<%= divConfirmDeleteModal.ClientID %>").modal('show');
                };

                function showSuccessModal() {
                    $("#<%= divSuccessModal.ClientID %>").modal('show');
                };

                function showDetailedCollectionCopyModal() {
                    $("#<%= divDetailedCollectionCopyModal.ClientID %>").modal('show');
                };

            </script>

<%--End: Client scripts Section--%>                                                                
                                                                                                                                
        </ContentTemplate>
    
    </asp:UpdatePanel>


</asp:Content>