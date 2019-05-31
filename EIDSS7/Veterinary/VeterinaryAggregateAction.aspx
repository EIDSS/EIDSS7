<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="VeterinaryAggregateAction.aspx.vb" Inherits="EIDSS.VeterinaryAggregateAction" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="gvVAC" />
            <%--            <asp:AsyncPostBackTrigger ControlID="gvVAC" EventName="RowCommand" />--%>
        </Triggers>

        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h2>
                        </div>
                        <%--Begin: Hidden fields--%>
                        <div id="divHiddenFieldsSection" runat="server">
                            <asp:HiddenField ID="hdfidfsCountry" runat="server" />
                            <asp:HiddenField runat="server" ID="hdfLangID" />
                            <asp:HiddenField runat="server" ID="hdfidfAggrCase" Value="" />
                            <asp:HiddenField runat="server" ID="hdfidfsAggrCaseType" />
                            <asp:HiddenField runat="server" ID="hdfidfsAdministrativeUnit" />
                            <asp:HiddenField runat="server" ID="hdfidfEnteredByOffice" />
                            <asp:HiddenField runat="server" ID="hdfidfEnteredByPerson" Value=" NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfCaseObservation" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsCaseObservationFormTemplate" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfDiagnosticObservation" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsDiagnosticObservationFormTemplate" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfProphylacticObservation" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsProphylacticObservationFormTemplate" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfSanitaryObservation" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfVersion" Value="" />
                            <asp:HiddenField runat="server" ID="hdfidfDiagnosticVersion" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfProphylacticVersion" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfSanitaryVersion" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsSanitaryObservationFormTemplate" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfdatStartDate" />
                            <asp:HiddenField runat="server" ID="hdfdatFinishDate" />
                            <asp:HiddenField runat="server" ID="hdfdatModificationForArchiveDate" />
                            <asp:HiddenField ID="hdfidfsSite" runat="server" Value='NULL' />
                        </div>
                        <asp:HiddenField runat="server" ID="hdfstrCaseID" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfSuccessPopUpFlag" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfidfEnteredByDate" Value=" NULL" />
                        <div id="divMonitoringSessionSearchContainer" runat="server" visible="false">
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsRegion" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsRayon" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsSettlement" Value="null" />
                        </div>
                        <%--End: Hidden fields--%>
                        <div class="panel panel-default">
                            <%-- Section Header --%>
                            <div id="search" runat="server">
                                <%-- ==========================================================Search Panel ===================================== --%>
                                <div id="searchForm" class="embed-panel" runat="server">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 id="hdgSearchCriteria" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                    <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" visible="false" meta:resourcekey="btn_Show_Search_Criteria" onclick="showSearchCriteria(event);"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body" runat="server" id="searchCriteria">
                                            <p runat="server" meta:resourcekey="lbl_Search_Instructions"></p>
                                            <div class="form-group" runat="server" meta:resourcekey="dis_Search_Case_ID">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server">
                                                        <label runat="server" meta:resourcekey="lbl_Report_ID"></label>
                                                        <asp:TextBox ID="txtstrSearchCaseID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
<%--                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Or"></label>
                                                    </div>
                                                </div>
                                            </div>--%>
                                            <div class="form-group" runat="server" meta:resourcekey="dis_Search_Case_ID">
                                                <div class="row">
                                                    <div id="div_Time_Interval" class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="dis_Time_Interval" runat="server">
                                                        <span class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="req_Time_Interval" runat="server"></span>
                                                        <label meta:resourcekey="lbl_Time_Interval_Unit" runat="server"></label>
                                                        <asp:DropDownList ID="ddlidfsTimeInterval" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="SaveTimeIntervalRangeFromDDL"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlidfsTimeInterval" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Time_Interval" runat="server"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <%--<div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                <label id ="lbl_Administrative_Level" runat="server" meta:resourcekey="lbl_Administrative_Level"></label>
                                                <asp:DropDownList ID="ddlifdsSearchAdministrativeLevel" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchAdministrativeLevel_SelectedIndexChanged"></asp:DropDownList>
                                            </div>--%>
                                                    <div id="div_Administrative_Level" class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="dis_Administrative_Level" runat="server">
                                                        <span class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="req_Administrative_Level" runat="server"></span>
                                                        <label meta:resourcekey="lbl_Administrative_Level" runat="server"></label>
                                                        <asp:DropDownList ID="ddlifdsSearchAdministrativeLevel" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchAdministrativeLevel_SelectedIndexChanged"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlifdsSearchAdministrativeLevel" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Administrative_Level" runat="server"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                                <%--                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Search_Start_Date">
                                                    <label runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatSearchStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Search_End_Date">
                                                    <label runat="server" meta:resourcekey="lbl_End_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatSearchEndDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>--%>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Search_Start_Date">
                                                        <label runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                        <eidss:CalendarInput ID="txtdatSearchStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Search_End_Date">
                                                        <label runat="server" meta:resourcekey="lbl_End_Date"></label>
                                                        <eidss:CalendarInput ID="txtdatSearchEndDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true"></eidss:CalendarInput>
                                                        <asp:CompareValidator ID="Val_Entered_Date_Compare" runat="server" 
                                                            CssClass="text-danger" ControlToCompare="txtdatSearchEndDate" 
                                                            CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" 
                                                            ControlToValidate="txtdatSearchStartDate" Type="Date" SetFocusOnError="true" 
                                                            Operator="LessThanEqual" meta:resourcekey="Msg_Dates_Are_Invalid" 
                                                            ValidationGroup="Search"></asp:CompareValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="adminAreaSearch" runat="server">
                                                <eidss:LocationUserControl ID="lucVeterinaryAggregate" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                            </div>
                                            <%--<div class="form-group">
                                        <div id="adminSearch" runat="server">
                                            <eidss:LocationUserControl ID="lucSearch" runat="server" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                        </div>
                                </div>--%>
                                            <div id="searchOrg" class="form-group" runat="server" meta:resourcekey="dis_Search_0rganization">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Organzation"></label>
                                                        <asp:DropDownList ID="ddlidfsOrganzation" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- end default panel--%>
                                    </div>
                                    <%--End Search Panel--%>
                                </div>
                                <%-- ==========================================================Search Results ===================================== --%>
                                <div id="searchResults" class="embed-panel" runat="server" visible="false">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                    <h3 id="hdgVAC" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Diseases">
                                                    <label id="searchResultsQty" runat="server"></label>
                                                    <label runat="server" meta:resourcekey="lbl_Items"></label>
                                                </div>
                                                <eidss:GridView ID="gvVAC"
                                                    runat="server"
                                                    AllowPaging="True"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    DataKeyNames="strCaseID"
                                                    EmptyDataText="No data available."
                                                    ShowFooter="True"
                                                    ShowHeaderWhenEmpty="True"
                                                    GridLines="None">
                                                    <EmptyDataTemplate>
                                                        <label runat="server" meta:resourcekey="lbl_No_Record"></label>
                                                    </EmptyDataTemplate>
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_Report_ID.InnerText %>">
                                                            <ItemTemplate>
                                                                <%--<asp:Label ID="lblstrCaseID" runat="server" Text='<%# Eval("strCaseID") %>'></asp:Label>--%>
                                                                <asp:LinkButton ID="lnbstrCaseID" runat="server" CommandName="Edit" 
                                                                    CommandArgument='<%# Eval("strCaseID")%>'  CausesValidation="false" 
                                                                    Text='<%# Eval("strCaseID") %>' Visible="true">
                                                                </asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="datStartDate" HeaderText="<%$ Resources:lbl_Start_Date.InnerText %>" DataFormatString="{0:d}" ReadOnly="True" SortExpression="datStartDate" />
                                                        <asp:BoundField DataField="strPeriodName" HeaderText="<%$ Resources:lbl_Time_Interval_Unit.InnerText %>" ReadOnly="True" SortExpression="strPeriodName" />
                                                        <asp:BoundField DataField="strRegion" HeaderText="<%$ Resources:lbl_Region.InnerText %>" ReadOnly="True" SortExpression="strRegion" />
                                                        <asp:BoundField DataField="strRayon" HeaderText="<%$ Resources:lbl_Rayon.InnerText %>" ReadOnly="True" SortExpression="strRayon" />
                                                        <asp:BoundField DataField="strSettlement" HeaderText="<%$ Resources:lbl_Settlement.InnerText %>" ReadOnly="True" SortExpression="strSettlement" />
                                                        <asp:CommandField ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowEditButton="true" EditText="">
                                                            <ControlStyle CssClass="btn glyphicon glyphicon-edit" />
                                                        </asp:CommandField>
                                                        <%--<asp:CommandField ControlStyle-CssClass="btn glyphicon glyphicon-trash" ShowDeleteButton="true" DeleteText="">
                                                        <ControlStyle CssClass="btn glyphicon glyphicon-trash" />
                                                    </asp:CommandField>--%>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <span class="glyphicon glyphicon-triangle-bottom" onclick="showSubGrid(event,'div<%# Eval("idfAggrCase") %>');"></span>
                                                                <tr id="div<%# Eval("idfAggrCase") %>" style="display: none;">
                                                                    <td colspan="6" style="border-top: 0 none transparent">
                                                                        <div class="form-group">
                                                                            <div class="row">
                                                                                <div class="col-lg-6 col-md-6 col-md-12 col-sm-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Notification_Sent_By_Institution"></label>
                                                                                    <asp:TextBox ID="txtNotificationSentBy" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strSentByOffice") %>'></asp:TextBox>
                                                                                </div>
                                                                                <div class="col-lg-6 col-md-6 col-md-12 col-sm-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Notification_Received_By_Institution"></label>
                                                                                    <asp:TextBox ID="txtReceivedByOffice" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strReceivedByOffice") %>'></asp:TextBox>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <div class="row">
                                                                                <div class="col-lg-6 col-md-6 col-md-12 col-sm-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Entered_By_Institution"></label>
                                                                                    <asp:TextBox ID="txtEnteredByOffice" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("strEnteredByOffice") %>'></asp:TextBox>
                                                                                </div>
                                                                                <div class="col-lg-3 col-md-3 col-md-12 col-sm-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Date_Sent"></label>
                                                                                    <asp:TextBox ID="txtSentByDate" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("datSentByDate") %>'></asp:TextBox>
                                                                                </div>
                                                                                <div class="col-lg-3 col-md-3 col-md-12 col-sm-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Date_Received"></label>
                                                                                    <asp:TextBox ID="txtReceivedByDate" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%# Eval("datReceivedByDate") %>'></asp:TextBox>
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
                                        </div>
                                    </div>
                                </div>
                                <div class="row text-center">
                                    <%--<asp:Button ID="btnPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />--%>
                                    <button id="btnCancelAgg" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Search" data-toggle="modal" data-target="#AggCancelModal" visible="true"></button>

                                    <button id="btnCancelSearch" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Search" data-toggle="modal" data-target="#searchCancelModal" visible="False"></button>

                                    <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Clear" OnClick="btnClear_Click" />
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Search" OnClick="btnSearch_Click" ValidationGroup="Search" />
                                    <asp:Button ID="btnNewVAC" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Veterinary_Aggregate_Case" OnClick="btnNewVAC_Click" />
                                </div>
                            </div>
                            <%-- End Search Results --%>
                            <%--Veterinary Aggregate Add or Edit--%>
                            <%-- ========================================================== Add / Edit ===================================== --%>
                            <div id="VeterinaryAggregate" class="embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case_Details"></h3>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group" runat="server" meta:resourcekey="dis_Case_ID">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Report_ID"></label>
                                                    <asp:TextBox ID="txtstrCaseID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:TextBox ID="txtstrCountry" runat="server" CssClass="form-control" Visible="false"></asp:TextBox>
                                        <!-- DropdownList Year, Month, Qtr -->
                                        <div class="form-group" runat="server" meta:resourcekey="req_fields">
                                            <div class="row">
                                                <div id="year" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Year" visible="True">
                                                    <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Year"></span>
                                                    <label meta:resourcekey="lbl_Year" runat="server"></label>
                                                    <asp:DropDownList ID="ddlintYear" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlintYear_SelectedIndexChanged" Visible="True"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlintYear" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Year"></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="month" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" meta:resourcekey="dis_Month" runat="server" visible="True">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Month" runat="server"></span>
                                                    <label meta:resourcekey="lbl_Month" runat="server"></label>
                                                    <asp:DropDownList ID="ddlintMonth" runat="server" CssClass="form-control" AutoPostBack="false" OnSelectedIndexChanged="SaveDateRangeFromDDL" Visible="True"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valMonth" runat="server" ControlToValidate="ddlintMonth" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Month" ></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="quarter" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Quarter" visible="False">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Quarterly"></span>
                                                    <label meta:resourcekey="lbl_Quarter" runat="server"></label>
                                                    <asp:DropDownList ID="ddlintQuarter" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></asp:DropDownList>
                                                </div>

                                                <div id="week" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Week" visible="False">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Week"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Week"></label>
                                                    <asp:DropDownList ID="ddlintWeek" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></asp:DropDownList>
                                                </div>
                                                <div id="singleDay" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Day" visible="False">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Day"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Day"></label>
                                                    <eidss:CalendarInput ID="txtdatDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="SaveDateRange"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- LocationUserControl-->
                                        <div class="form-group">
                                            <div id="adminSearch" runat="server">
                                                <eidss:LocationUserControl ID="lucSearch" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                            </div>
                                        </div>
                                        <!-- Sent By-->
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="dis_Notification_Sent_by_Institution"
                                                    runat="server">
                                                    <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_Notification_Sent_by_Institution"
                                                        runat="server"></span>
                                                    <label meta:resourcekey="lbl_Notification_Sent_by_Institution" runat="server"></label>
                                                    <eidss:DropDownList runat="server" ID="ddlidfSentByOffice" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ID="valSentByOffice" runat="server" ControlToValidate="ddlidfSentByOffice" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Sent_by_Institution"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="dis_Notification_Sent_by_Person"
                                                    runat="server">
                                                    <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_Notification_Sent_by_Date_Person"
                                                        runat="server"></span>
                                                    <label meta:resourcekey="lbl_Notification_Sent_by_Officer" runat="server"></label>
                                                    <eidss:DropDownList runat="server" ID="ddlidfSentByPerson" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ID="valSentByPerson" runat="server" ControlToValidate="ddlidfSentByPerson" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Sent_by_Person"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Sent_by_Date">
                                                    <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Notification_Sent_by_Date"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_by_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatSentbyDate" runat="server" MaxDate='<%# DateTime.Now.Year %>' ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtdatSentByDate_TextChanged"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ID="valSentbyDate" runat="server" ControlToValidate="txtdatSentbyDate" CssClass="text-danger" InitialValue="" meta:resourceKey="val_Notification_Sent_by_Date"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        <!-- Received By-->
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Institution">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Institution"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Institution"></label>
                                                    <asp:DropDownList ID="ddlidfReceivedByOffice" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsReceivedByOffice_SelectedIndexChanged"></asp:DropDownList>
                                                    <%--<asp:RequiredFieldValidator ID="valReceivedByOffice" runat="server" ControlToValidate="ddlidfReceivedByOffice" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Received_by_Institution"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Person">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Person"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Officer"></label>
                                                    <asp:DropDownList ID="ddlidfReceivedByPerson" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsReceivedByPerson_SelectedIndexChanged"></asp:DropDownList>
                                                    <%--<asp:RequiredFieldValidator ID="valReceivedByPerson" runat="server" ControlToValidate="ddlidfReceivedByPerson" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Received_by_Officer"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Date">
                                                    <%--<span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Date"></span>--%>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatReceivedByDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <%--<asp:RequiredFieldValidator ID="valReceivedByDate" runat="server" ControlToValidate="txtdatReceivedbyDate" CssClass="text-danger" InitialValue="" meta:resourceKey="val_Notification_Received_by_Date"></asp:RequiredFieldValidator>--%>
                                                    <asp:CompareValidator ID="cvSentByReceivedByDate" runat="server" 
                                                        ControlToValidate="txtdatReceivedByDate" CssClass="text-danger" 
                                                        ControlToCompare="txtdatSentbyDate" Display="Dynamic" 
                                                        CultureInvariantValues="true" meta:resourcekey="cv_Sent_By_Received_By_Date"
                                                        Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <!-- Entered By-->
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Entered_by_Institution">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By_Institution"></label>
                                                    <asp:TextBox ID="txtstrEnteredByOffice" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Entered_by_Person">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By_Officer"></label>
                                                    <asp:TextBox ID="txtstrEnteredByPerson" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Entered_by_Date">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatEnteredByDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                    <asp:TextBox ID="txtdatEnteredByDate1" runat="server"  CssClass="form-control" Enabled="false" Visible="false"></asp:TextBox>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="table-responsive">
                                                <!-- Diagnosis -->
                                                <asp:GridView ID="gvDiagnosis" runat="server"
                                                    AllowPaging="True"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    DataKeyNames="strLastName"
                                                    EmptyDataText="No data available for Grid Diagnosis."
                                                    ShowFooter="True"
                                                    ShowHeader="True"
                                                    ShowHeaderWhenEmpty="true"
                                                    GridLines="None">
                                                    <EmptyDataTemplate>
                                                        <label runat="server" meta:resourcekey="lbl_No_Record"></label>
                                                    </EmptyDataTemplate>
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Investigation_Type"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("strInvestigationType") %>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <%# Eval("strInvestigationType") %>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Species"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("strSpecies") %>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                w
                                                        <%# Eval("strSpecies") %>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <%--                                                        <label runat="server" meta:resourcekey="lbl_Diagnosis"></label> Changed to Disease   --%>
                                                                <label runat="server" meta:resourcekey="lbl_Di"></label>

                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtDiagnosis" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtDiagnosis" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_OIECode"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtOIECode" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtOIECode" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Unhealthy_Farms"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtTested" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtTested" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Unhealthy_Farm_Animals"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtPositiveAction" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtPositiveAction" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Sick_Animals"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtNote" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtNote" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Vaccinated_Animals"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtMeasureType" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtMeasureType" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Destroyed_Animals"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtMeasureCode" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtMeasureCode" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Num_Sanitary_Slaughter"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtNumberOfFacilities" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtNumberOfFacilities" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Area"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtArea" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtArea" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Total"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintTotalAbsoluteNumber" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintTotalAbsoluteNumber" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>

                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                        <!-- Buttons -->
                                        <div class="form-group text-center">
                                            <asp:Button ID="btnPrintNewAgg" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />
                                            <asp:Button ID="btnCancelDelete" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Delete_Aggregate" OnClick="btnCancelDelete_Click" Visible="false"></asp:Button>
                                            <asp:Button ID="btnVACCancel" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnVACCancel_Click" Visible="false" />
                                            <button id="btnNotSubmit" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_NotSubmit" data-toggle="modal" data-target="#submitCancelModal" visible="false"></button>
                                            <asp:Button ID="btnNext" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Next" OnClick="btnNext_Click" />
                                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnSubmit_Click" Visible="false" />
                                            <button id="btnTryDelete" runat="server" class="btn btn-primary" type="button" data-toggle="modal" data-target="#usrConfirmDelete" meta:resourcekey="btn_Delete_Aggregate" visible="false"></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%-- End Veterinary Aggregate Section --%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal" id="missingSearchObject" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                    <span class="glyphicon glyphicon-ok-sign"></span>
                                </div>
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <h5 id="msgBody" runat="server" meta:resourcekey="val_SearchStartDate"></h5>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button
                                runat="server"
                                ID="btnNo"
                                CssClass="btn btn-default"
                                meta:resourcekey="btn_No"
                                OnClick="btnNo_Click"
                                OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;" />
                            <asp:Button
                                CssClass="btn btn-default"
                                ID="btnYes"
                                meta:resourcekey="btn_Yes"
                                runat="server"
                                OnClick="btnYes_Click"
                                OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="submitCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Submit"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                 <%--           <a runat="server" class="btn btn-primary" href="~/Dashboard.aspx" meta:resourcekey="Btn_Yes"></a>--%>

							 <a id="returnToVetAggSearch" runat="server" class="btn btn-primary" href="../Veterinary/VeterinaryAggregateCase.aspx" meta:resourcekey="Btn_Yes" visible="false"></a>
                             <button id="btnReturnToVetAggSearchResult" type="submit" runat="server" meta:resourcekey="Btn_Yes" class="btn btn-primary" Return="true" data-dismiss="modal" CausesValidation="false" Click="btnReturnToVetAggSearchResult_Click"></button>

                            <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="alwaysShown" class="embed-panel" runat="server">
                <div class="panel panel-default">
                    <div class="form-group" runat="server" meta:resourcekey="dis_Search_Time_Interval">
                        <div class="row">
 
                        </div>
                    </div>
                </div>
            </div>
            <div id="returnDashboardModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Lbl_Return_Dashboard"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>
                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="divSuccessModalContainer" class="modal" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <asp:Label ID="lblCASEID" runat="server"></asp:Label>
                                        <p id="lblSuccess" runat="server" meta:resourcekey="Lbl_Success"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a class="btn btn-primary" runat="server" meta:resourcekey="Hdg_Return_Dashboard" href="../Dashboard.aspx"></a>
                            <asp:Button ID="btnReturnToVetAggRecord" runat="server" meta:resourcekey="Btn_Return_VetAgg_Record" CssClass="btn btn-primary" OnClientClick="hideModal();" OnClick="btnReturnToAggrRecord_Click" />

                        </div>
                    </div>
                </div>
            </div>


            <div id="searchCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Search"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">

                            <a id="returnToVetAggReport" runat="server" class="btn btn-primary" href="../Veterinary/VeterinaryAggregateCase.aspx" meta:resourcekey="Btn_Yes" visible="false"></a>
                             <button id="btnReturnToVetAgg" type="submit" runat="server" meta:resourcekey="Btn_Yes" class="btn btn-primary" Return="true" data-dismiss="modal" Click="btnReturnToVetAgg_Click"></button>




                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>


            <div id="AggCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Agg"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>
                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>





            <div class="modal" id="usrConfirmDelete" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="lbl_Delete_Aggregate"></p>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <asp:Label ID="lblCASEIDDel" runat="server"></asp:Label>
                                        <p id="lblDeleteCase" runat="server" meta:resourcekey="Lbl_Delete_CaseID"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" data-dismiss="modal" class="btn btn-primary" id="delYes" meta:resourcekey="Btn_Yes" runat="server" />
                            <button type="button" data-dismiss="modal" class="btn btn-default" meta:resourcekey="Btn_No" runat="server"></button>
                        </div>
                    </div>
                </div>
            </div>




            <script type="text/javascript">
                var isModalShown = false;

                $(document).ready(function () {
                    $("#missingSearchStartDate").on("shown.bs.modal", function () { isModalShown = true; })
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(showDelModalAfterPostBack);
                    showDelModalAfterPostBack();
                    $('.modal').modal({ show: false, backdrop: 'static' });
                });

                function showDateModalAfterPostBack() {
                    if (isModalShown) {
                        $('.modal-backdrop').remove();
                        $('#missingSearchStartDate').modal({ show: true });
                    }
                };

                function showDelModalAfterPostBack() {
                    if (isModalShown) {
                        $('.modal-backdrop').remove();
                        $('#usrConfirmDelete').modal({ show: true });
                    }

                    $('.modal').modal({ show: false, backdrop: 'static' });
                };

                function showSubGrid(e, f) {
                    var divTag = '#' + f;
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom') {
                        e.target.className = "glyphicon glyphicon-triangle-top";
                        $(divTag).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom";
                        $(divTag).hide();
                    }
                };

                function hideModal() {
                    $('#<%= divSuccessModalContainer.ClientID %>').modal('hide');
                };

                function showSearchCriteria(e) {
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom header-button') {
                        e.target.className = "glyphicon glyphicon-triangle-top header-button";
                        $('#<%= searchCriteria.ClientID %>').show();
                        $('#<%= btnClear.ClientID %>').show();
                        $('#<%= btnSearch.ClientID %>').show();
                        <%--$('#<%= btnPrint.ClientID %>').hide();--%>
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom header-button";
                        $('#<%= searchCriteria.ClientID %>').hide();
                        $('#<%= btnClear.ClientID %>').hide();
                        $('#<%= btnSearch.ClientID %>').hide();
                        <%--$('#<%= btnPrint.ClientID %>').show();--%>
                    }
                };
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
