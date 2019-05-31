<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="HumanAggregate1.aspx.vb" Inherits="EIDSS.HumanAggregate1" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
   <link href="../../Includes/CSS/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .sectioncenter {
            text-align: center;
            white-space: pre;
        }

        .Diagnosis {
            white-space: pre;
        }
    </style>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="updateitem" runat="server">
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h2>
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
                        <asp:HiddenField runat="server" ID="hdfidfCaseObservation" />
                        <asp:HiddenField runat="server" ID="hndcount" />
                        <div id="divMonitoringSessionSearchContainer" runat="server" visible="false">
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsRegion" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsRayon" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfsearchFormidfsSettlement" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsCaseObservationFormTemplate" Value="NULL" />
                        </div>
                        <%--End: Hidden fields--%>
                        <div class="panel panel-default">
                            <%-- Section Header --%>
                            <div id="search" runat="server">
                                <%--Search Panel--%>
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
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Or"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" meta:resourcekey="dis_Search_Case_ID">
                                                <div class="row">
                                                    <div id="div_Time_Interval" class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="dis_Time_Interval" runat="server">
                                                        <span class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="req_Time_Interval" runat="server"></span>
                                                        <label meta:resourcekey="lbl_Time_Interval_Unit" runat="server"></label>
                                                        <asp:DropDownList ID="ddlidfsTimeInterval" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="SaveTimeIntervalRangeFromDDL"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlidfsTimeInterval" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Time_Interval" runat="server"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div id="div_Administrative_Level" class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="dis_Administrative_Level" runat="server">
                                                        <span class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="req_Administrative_Level" runat="server"></span>
                                                        <label meta:resourcekey="lbl_Administrative_Level" runat="server"></label>
                                                        <asp:DropDownList ID="ddlifdsSearchAdministrativeLevel" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchAdministrativeLevel_SelectedIndexChanged"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlifdsSearchAdministrativeLevel" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Administrative_Level" runat="server"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
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
                                                        <asp:CompareValidator ID="Val_Entered_Date_Compare" runat="server" CssClass="text-danger" ControlToCompare="txtdatSearchEndDate" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtdatSearchStartDate" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Entered_Date_Compare" ValidationGroup="Search"></asp:CompareValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="adminAreaSearch" runat="server">
                                                <eidss:LocationUserControl ID="lucHumanAggregate" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                            </div>
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
                                <%--Search Results--%>
                                <div id="searchResults" class="embed-panel" runat="server" visible="false">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                    <h3 id="hdgHAC" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">

                                            <div class="table-responsive">
                                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Diseases">
                                                    <label id="searchResultsQty" runat="server"></label>
                                                </div>
                                                <eidss:GridView ID="gvHAC"
                                                    runat="server"
                                                    AllowPaging="True"
                                                    PagerSettings-Visible="false"
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
                                                                <asp:Label ID="lblstrCaseID" runat="server" Text='<%# Eval("strCaseID") %>'></asp:Label>
                                                                <asp:LinkButton ID="lnbstrCaseID" runat="server" Text='<%# Eval("strCaseID") %>' Visible="false"></asp:LinkButton>
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
                                                                <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </div>
                                                </div>














                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%--End Search Results--%>
                                <div class="row text-center">
                                    <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />
                                    <button id="btnCancelAgg" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Search" data-toggle="modal" data-target="#AggCancelModal" visible="true"></button>
                                    <button id="btnCancelSearch" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Search" data-toggle="modal" data-target="#searchCancelModal" visible="False"></button>

                                    <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Clear" OnClick="btnClear_Click" />
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Search" OnClick="btnSearch_Click" />
                                    <asp:Button ID="btnNewHAC" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Human_Aggregate_Case" OnClick="btnNewHAC_Click" />
                                    <asp:Button ID="btnNewSearch" CssClass="btn btn-default" runat="server" meta:resourceKey="Btn_New_Search" Visible="false" />
                                </div>
                            </div>
                            <%-- End Search  --%>
                            <%--Human Aggregate Add or Edit--%>
                            <div id="HumanAggregate" class="embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="hdg_Human_Aggregate_Case_Details"></h3>
                                    </div>
                                    <asp:UpdatePanel runat="server" ID="up2" UpdateMode="Always">
                                        <ContentTemplate>
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

                                                <div class="form-group" runat="server" meta:resourcekey="req_fields">
                                                    <div class="row">
                                                        <div id="year" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Year" visible="True">
                                                            <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Year"></div>
                                                            <asp:Label meta:resourcekey="lbl_Year" runat="server"></asp:Label>
                                                            <eidss:DropDownList ID="ddlintYear" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlintYear_SelectedIndexChanged" Visible="True"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlintYear" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Year"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div id="month" runat="server" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" meta:resourcekey="dis_Month">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Month" runat="server"></div>
                                                            <asp:Label AssociatedControlID="ddlintMonth" meta:resourcekey="lbl_Month" CssClass="control-label" runat="server"></asp:Label>
                                                            <eidss:DropDownList ID="ddlintMonth" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="SaveDateRangeFromDDL" Visible="True"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator ControlToValidate="ddlintMonth" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourceKey="val_Month" runat="server"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div id="quarter" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Quarter" visible="False">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Quarterly"></span>
                                                            <label meta:resourcekey="lbl_Quarter" runat="server"></label>
                                                            <eidss:DropDownList ID="ddlintQuarter" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></eidss:DropDownList>
                                                        </div>

                                                        <div id="week" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Week" visible="False">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Week"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Week"></label>
                                                            <eidss:DropDownList ID="ddlintWeek" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></eidss:DropDownList>
                                                        </div>
                                                        <div id="singleDay" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Day" visible="False">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Day"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Day"></label>
                                                            <eidss:CalendarInput ID="txtdatDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="SaveDateRange"></eidss:CalendarInput>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div id="adminSearch" runat="server">
                                                        <eidss:LocationUserControl ID="lucSearch" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                                    </div>
                                                </div>
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
                                                            <eidss:CalendarInput ID="txtdatSentbyDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtdatSentByDate_TextChanged"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator ID="valSentbyDate" runat="server" ControlToValidate="txtdatSentbyDate" CssClass="text-danger" InitialValue="" meta:resourceKey="val_Notification_Sent_by_Date"></asp:RequiredFieldValidator>

                                                        </div>

                                                    </div>

                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Institution">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Institution"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Institution"></label>
                                                            <asp:DropDownList ID="ddlidfReceivedByOffice" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsReceivedByOffice_SelectedIndexChanged"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Person">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Person"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Officer"></label>
                                                            <asp:DropDownList ID="ddlidfReceivedByPerson" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsReceivedByPerson_SelectedIndexChanged"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Date">
                                                            <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatReceivedByDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
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
                                                            <asp:TextBox ID="txtdatEnteredByDate1" runat="server" CssClass="form-control" Enabled="false" Visible="false"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="table-responsive">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                            </div>
                                                            <div class="col-md-4" runat="server" id="dividfversion" visible="true" style="text-align: right;">
                                                                <asp:Label runat="server" meta:resourcekey="idfversion" class="input-group"></asp:Label>
                                                                <asp:DropDownList ID="ddlidfVersion" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                            <div class="col-md-4" runat="server" id="divTemplate" visible="true" style="text-align: right;">
                                                                <asp:Label runat="server" meta:resourcekey="idfTemplate" class="input-group"></asp:Label>
                                                                <asp:DropDownList ID="ddlTemplate" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                        </div>

                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <fieldset style="overflow: auto;">
                                                                    <legend>
                                                                        <asp:Label runat="server" ID="lbl_legend_title"> Human Aggregate Flex Form </asp:Label></legend>
                                                                    <asp:Panel runat="server" ID="pnlCaseClassification" Width="100%">
                                                                    </asp:Panel>
                                                                </fieldset>
                                                            </div>
                                                        </div>
                                                        <%--<asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Style="display: none" />--%>

                                                        <%--<label for="hdfRiskFactor" runat="server" meta:resourcekey="lbl_List_of_Risks"></label>--%>
                                                        <%--<eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="HumanAggregateFlexForm" 
                                                                            LegendHeader="Human Aggregate Flex Form" />--%>
                                                        <asp:GridView ID="gvDiagnosis" runat="server"
                                                            AllowPaging="True"
                                                            AllowSorting="True"
                                                            AutoGenerateColumns="False"
                                                            CaptionAlign="Top"
                                                            CssClass="table table-striped"
                                                            EmptyDataText="No data available for Grid Diagnosis."
                                                            ShowFooter="True"
                                                            ShowHeader="True"
                                                            ShowHeaderWhenEmpty="true"
                                                            GridLines="None" Width="100%">
                                                            <EmptyDataTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_No_Record"></label>
                                                            </EmptyDataTemplate>
                                                            <HeaderStyle CssClass="table-striped-header" />
                                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Diagnosis"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# Eval("strDefault") %>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <%# Eval("strDefault") %>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_ICD_10_Code"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <%# Eval("strIDC10") %>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>

                                                                        <%# Eval("strIDC10") %>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <%--                                                        <label runat="server" meta:resourcekey="lbl_Diagnosis"></label> Changed to Disease   --%>
                                                                        <label runat="server" meta:resourcekey="lbl_Less_1"></label>

                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintLess1AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintLess1AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintLess1Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintLess1Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_1_to_5"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint1to5AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint1to5AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint1to5Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint1to5Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_6_to_10"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint6to10AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint6to10AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint6to10Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint6to10Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_11_to_15"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint11to15AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint11to15AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint11to15Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint11to15Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_16_to_20"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint16to20AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint16to20AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint16to20Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint16to20Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_21_to_25"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint21to25AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint21to25AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint21to25Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint21to25Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_26_to_30"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint26to30AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint26to30AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint26to30Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint26to30Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_30_to_59"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint31to59AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint31to59AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint31to59Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtint31to59Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Greater_60"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <td>
                                                                            <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                        </td>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
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
                                                                <%--<asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <td>
                                                                    <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                </td>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintTotalRate" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintTotalRate" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>--%>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Proportion_Tested"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Proportion_Laboratory"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintGreater60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderStyle VerticalAlign="Bottom" />
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Proportion_Death"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintTotalAbsoluteNumber" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintTotalAbsoluteNumber" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <label runat="server" meta:resourcekey="lbl_Proportion_Rural"></label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintTotalRate" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:NumericSpinner ID="txtintTotalRate" runat="server" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                                <div class="form-group text-center">
                                                    <asp:Button ID="btnPrintNewAgg" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />
                                                    <asp:Button ID="btnCancelDelete" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Delete_Aggregate" OnClick="btnCancelDelete_Click" Visible="false"></asp:Button>
                                                    <asp:Button ID="btnHACCancel" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnHACCancel_Click" />
                                                    <button id="btnNotSubmit" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_NotSubmit" data-toggle="modal" data-target="#submitCancelModal" visible="false"></button>
                                                    <button id="btnCancelAdd" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Add" data-toggle="modal" data-target="#addCancelModal" visible="false"></button>

                                                    <asp:Button ID="btnNext" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Next" OnClick="btnNext_Click" />
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" OnClientClick="doSomething();" meta:resourceKey="btn_Submit" OnClick="btnSubmit_Click" Visible="false" />
                                                    <button id="btnTryDelete" runat="server" class="btn btn-primary" type="button" data-toggle="modal" data-target="#usrConfirmDelete" meta:resourcekey="btn_Delete_Aggregate" visible="false"></button>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                     <%--   <Triggers>
                                            <asp:PostBackTrigger ControlID="btnNext"/>
                                        </Triggers>--%>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                            <%-- End Human Aggregate Section --%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal" id="missingSearchObject" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <a runat="server" class="btn btn-primary" href="~/Dashboard.aspx" meta:resourcekey="Btn_Yes"></a>


                            <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                        </div>
                    </div>
                </div>
            </div>

            <div id="addCancelModal" class="modal" role="dialog">
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
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Add"></p>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <asp:Button ID="btnReturnToHumanAggRecord" runat="server" meta:resourcekey="Btn_Return_HumanAgg_Record" CssClass="btn btn-primary" OnClientClick="hideModal();" OnClick="btnReturnToAggrRecord_Click" />

                        </div>
                    </div>
                </div>
            </div>


            <div id="searchCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <%--                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>--%>

                            <a id="returnToHumanAggReport" runat="server" class="btn btn-primary" href="../Human/HumanAggregate.aspx" meta:resourcekey="Btn_Yes" visible="false"></a>
                            <button id="btnReturnToHumanAgg" type="submit" runat="server" meta:resourcekey="Btn_Yes" class="btn btn-primary" return="true" data-dismiss="modal" click="btnReturnToHumanAgg_Click"></button>

                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>

            <div id="AggCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Aggregate_Case"></h4>
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
                        $('#<%= btnPrint.ClientID %>').hide();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom header-button";
                        $('#<%= searchCriteria.ClientID %>').hide();
                        $('#<%= btnClear.ClientID %>').hide();
                        $('#<%= btnSearch.ClientID %>').hide();
                        $('#<%= btnPrint.ClientID %>').show();
                    }
                };


            </script>

        </ContentTemplate>
         <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnNext" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
