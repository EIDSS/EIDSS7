<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="VeterinaryAggregate.aspx.vb" Inherits="EIDSS.VeterinaryAggregate" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Case"></h2>
                        </div>
                        <%--Begin: Hidden fields--%>
                        <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                            <asp:HiddenField ID="hdnLangID" runat="server" />
                            <asp:HiddenField ID="hdnidfsCountry" runat="server" />
                            <asp:HiddenField ID="hdnidfAggrCase" runat="server" />
                            <asp:HiddenField ID="hdnidfsAggrCaseType" runat="server" />
                            <asp:HiddenField ID="hdnidfsAdministrativeUnit" runat="server" />
                            <asp:HiddenField ID="hdnidfEnteredByOffice" runat="server" />
                            <asp:HiddenField ID="hdnidfEnteredByPerson" runat="server" />
                            <asp:HiddenField ID="hdnidfsVersion" runat="server" />
                            <asp:HiddenField ID="hdndatStartDate" runat="server" />
                            <asp:HiddenField ID="hdndatFinishDate" runat="server" />
                        </div>
                    </div>
                        <div class="panel-body">
                            <div ID="alwaysShown" class="embed-panel" runat="server">
                                <div class="panel panel-default">
                                        <div class="form-group" runat="server" meta:resourcekey="dis_Search_Time_Interval">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Time_Interval_Unit"></label>
                                                    <asp:DropDownList ID="ddlidfsTimeInterval" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>  
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 col-md-offset-4">
                                                    <label runat="server" meta:resourcekey="lbl_Administrative_Level"></label>
                                                    <asp:DropDownList ID="ddlifdsSearchAdministrativeLevel" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchAdministrativeLevel_SelectedIndexChanged"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                </div>
                            </div>
                            <%--Search Panel--%>
                            <div id="search" class="embed-panel" runat="server">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 id="hdg_Search_Form" runat="server" meta:resourcekey="hdg_Search_Form"></h3>
                                        <h3 id="hdg_Search_Criteria" runat="server" meta:resourcekey="hdg_Search_Criteria" visible="false"></h3>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group" runat="server" meta:resourcekey="dis_Search_Case_ID">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Report_ID"></label>
                                                    <asp:TextBox ID="txtstrSearchCaseID" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
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
                                        </div>
                                        <div id="adminSearch" runat="server">
                                            <eidss:LocationUserControl ID="lucSearch" runat="server" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                        </div>
                                            <%--<div class="form-group">
                                            <div class="row">
                                                <div id="searchRegion" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Region">
                                                    <label runat="server" meta:resourcekey="lbl_Region"></label>
                                                    <asp:DropDownList ID="ddlifdsSearchRegion" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchRegion_SelectedIndexChanged"></asp:DropDownList>
                                                </div>
                                                <div id="searchRayon" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Rayon">
                                                    <label runat="server" meta:resourcekey="lbl_Rayon"></label>
                                                    <asp:DropDownList ID="ddlifdsSearchRayon" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlifdsSearchRayon_SelectedIndexChanged"></asp:DropDownList>
                                                </div>
                                                <div id="searchSettle" class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Settlement">
                                                    <label runat="server" meta:resourcekey="lbl_Settlement"></label>
                                                    <asp:DropDownList ID="ddlifdsSearchSettlement" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>--%>
                                        <div id="searchOrg" class="form-group" runat="server" meta:resourcekey="dis_Search_0rganization">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Organzation"></label>
                                                    <asp:DropDownList ID="ddlidfsOrganzation" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <%--<div id="OptionalParamters" runat="server" class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <asp:CheckBox ID="enteredbyuser" runat="server" CssClass="checkbox-inline" meta:resourcekey="lbl_MyCases" />
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Institution" />
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <asp:DropDownList ID="ddlstrOperatorOrgNotiRecd" runat="server">
                                                                <asp:ListItem meta:resourceKey="lbl_Blank" />
                                                                <asp:ListItem meta:resourceKey="lbl_Not_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Equals" />
                                                            </asp:DropDownList>
                                                        </span>
                                                        <asp:DropDownList ID="ddlidfsOrgNotiRecd" runat="server" CssClass="form-control" />
                                                    </div>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Date" />
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <asp:DropDownList ID="ddlstrOperatorNotiSentByDate" runat="server">
                                                                <asp:ListItem meta:resourceKey="lbl_Blank" />
                                                                <asp:ListItem meta:resourceKey="lbl_Not_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Equals" />
                                                                <asp:ListItem meta:resourceKey="lbl_Greater_Than" />
                                                                <asp:ListItem meta:resourceKey="lbl_Less_Than" />
                                                                <asp:ListItem meta:resourceKey="lbl_Greater_Than_Or_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Lesser_Than_Or_Equal_To" />
                                                            </asp:DropDownList>
                                                        </span>
                                                        <eidss:CalendarInput runat="server" ID="txtdatNotiRecdDate" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"></div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By_Institution" />
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <asp:DropDownList ID="ddlstrOperatorOrgEnter" runat="server">
                                                                <asp:ListItem meta:resourceKey="lbl_Blank" />
                                                                <asp:ListItem meta:resourceKey="lbl_Not_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Equals" />
                                                            </asp:DropDownList>
                                                        </span>
                                                        <asp:DropDownList ID="ddlidfsOrgEntered" runat="server" CssClass="form-control" />
                                                    </div>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By_Date" />
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <asp:DropDownList ID="ddldatEnteredByDate" runat="server">
                                                                <asp:ListItem meta:resourceKey="lbl_Blank" />
                                                                <asp:ListItem meta:resourceKey="lbl_Not_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Equals" />
                                                                <asp:ListItem meta:resourceKey="lbl_Greater_Than" />
                                                                <asp:ListItem meta:resourceKey="lbl_Less_Than" />
                                                                <asp:ListItem meta:resourceKey="lbl_Greater_Than_Or_Equal_To" />
                                                                <asp:ListItem meta:resourceKey="lbl_Lesser_Than_Or_Equal_To" />
                                                            </asp:DropDownList>
                                                        </span>
                                                        <eidss:CalendarInput runat="server" ID="txtdatEnterByDate" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                                    </div>
                                                </div>
                                            </div>--%>
                                        </div>
                                        <div class="form-group text-center">
                                            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Clear" OnClick="btnClear_Click" />
                                            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnCancel_Click" />
                                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Search" OnClick="btnSearch_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--Search Results--%>
                            <div id="searchResults" class="embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                <h3 id="hdgVAC" runat="server" meta:resourcekey="hdg_Veterinary_Aggregate_Cases"></h3>
                                                <h3 id="hdgSearchResults" runat="server" meta:resourcekey="hdg_Search_Results" visible="false"></h3>
                                            </div>
                                            <div id="editSearch" class="col-lg-2 col-md-2 col-sm-2 col-xs-2" runat="server" visible="false">
                                                <button id="btnEditSearch" runat="server" class="btn btn-default">
                                                    <label runat="server" meta:resourcekey="btn_Edit_Search"></label>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <asp:GridView ID="gvVAC" runat="server"
                                                AllowPaging="True"
                                                AllowSorting="True"
                                                OnSorting="gvVAC_Sorting"
                                                AutoGenerateColumns="False"
                                                CaptionAlign="Top"
                                                CssClass="table table-striped"
                                                DataKeyNames="strCaseID"
                                                EmptyDataText="No data available."
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
                                                    <asp:CommandField ControlStyle-CssClass="btn glyphicon glyphicon-info" ShowSelectButton="true" SelectText="" />
                                                    <asp:BoundField DataField="strCaseID" HeaderText="<%$ Resources:lbl_Report_ID.InnerText %>" />
                                                    <asp:BoundField DataField="datStartDate" HeaderText="<%$ Resources:lbl_Start_Date.InnerText %>" />
                                                    <asp:BoundField DataField="strPeriodName" HeaderText="<%$ Resources:lbl_Time_Interval_Unit.InnerText %>" />
                                                    <asp:BoundField DataField="strRegion" HeaderText="<%$ Resources:lbl_Region.InnerText %>" />
                                                    <asp:BoundField DataField="strRayon" HeaderText="<%$ Resources:lbl_Rayon.InnerText %>" />
                                                    <asp:BoundField DataField="strSettlement" HeaderText="<%$ Resources:lbl_Settlement.InnerText %>" />
                                                    <asp:CommandField ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowEditButton="true" EditText="" />
                                                    <%--data-toggle="modal" data-target="#usrConfirmDelete" onclick="isModalShown = true;"--%>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <span class="glyphicon glyphicon-plus-sign" onclick="showAggSubGrid(event,'div<%# Eval("idfAggrCase") %>');"></span>
                                                            <tr id="div<%# Eval("idfAggrCase") %>" style="display:none;">
                                                                <td style="border-top: 0 none transparent"></td>
                                                                <td colspan="5" style="border-top: 0 none transparent">
                                                                    <div class="form-group">
                                                                        <div class="row">
                                                                            <div class="col-lg-4 col-md-4 col-md-12 col-sm-12">
                                                                                <label runat="server" class="table-striped-header" meta:resourceKey="lbl_Notification_Sent_By_Institution"></label>
                                                                                <asp:TextBox ID="txtNotificationSentBy" runat="server" CssClass="form-control" Enabled="false" Text='<%# Eval("idfSentByOffice") %>'></asp:TextBox>
                                                                            </div>
                                                                            <div class="col-lg-4 col-md-4 col-md-12 col-sm-12">
                                                                                <label runat="server" class="table-striped-header" meta:resourceKey="lbl_Date_Sent"></label>
                                                                                <asp:TextBox ID="txtSentByDate" runat="server" CssClass="form-control" Enabled="false" Text='<%# Eval("datSentByDate") %>' ></asp:TextBox>
                                                                            </div>
                                                                            <div class="col-lg-4 col-md-4 col-md-12 col-sm-12">
                                                                                <label runat="server" class="table-striped-header" meta:resourceKey="lbl_Notification_Received_By_Institution"></label>
                                                                                <asp:TextBox ID="txtReceivedByOffice" runat="server" CssClass="form-control" Enabled="false" Text='<%# Eval("strReceivedByOffice") %>' ></asp:TextBox>
                                                                            </div>
                                                                            <div class="col-lg-4 col-md-4 col-md-12 col-sm-12">
                                                                                <label runat="server" class="table-striped-header" meta:resourceKey="lbl_Date_Received"></label>
                                                                                <asp:TextBox ID="txtReceivedByDate" runat="server" CssClass="form-control" Enabled="false" Text='<%# Eval("datReceivedByDate") %>' ></asp:TextBox>
                                                                            </div>
                                                                            <div class="col-lg-4 col-md-4 col-md-12 col-sm-12">
                                                                                <label runat="server" class="table-striped-header" meta:resourceKey="lbl_Entered_By_Institution"></label>
                                                                                <asp:TextBox ID="txtEnteredByOffice" runat="server" CssClass="form-control" Enabled="false" Text='<%# Eval("strEnteredByOffice") %>' ></asp:TextBox>
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
                                        <div class="form-group text-center">
                                            <asp:Button ID="btnNewSearch" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_New_Search" OnClick="newSearch_Click" />
                                            <asp:Button ID="btnNewVAC" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Veterinary_Aggregate_Case" OnClick="newVAC_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--Veterinary Aggregate Add or Edit--%>
                            <div id="VetAggregate" class="embed-panel" runat="server" visible="false">
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
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Year">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Year"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Year"></label>
                                                    <asp:DropDownList ID="ddlintYear" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlintYear_SelectedIndexChanged"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valYear" runat="server" ControlToValidate="ddlintYear" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Year"></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="quarter" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Quarter">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Quarterly"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Quarter"></label>
                                                    <asp:DropDownList ID="ddlintQuarter" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valQuarterly" runat="server" ControlToValidate="ddlintQuarter" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Quarterly"></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="month" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Month">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Month"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Month"></label>
                                                    <asp:DropDownList ID="ddlintMonth" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="SaveDateRangeFromDDL"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valMonth" runat="server" ControlToValidate="ddlintMonth" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Month"></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="week" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Week">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Week"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Week"></label>
                                                    <asp:DropDownList ID="ddlintWeek" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valWeek" runat="server" ControlToValidate="ddlintWeek" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Week"></asp:RequiredFieldValidator>
                                                </div>
                                                <div id="singleDay" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Day">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Day"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Day"></label>
                                                    <eidss:CalendarInput ID="txtdatDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="SaveDateRange"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ID="valDay" runat="server" ControlToValidate="txtdatDate" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Day"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" runat="server" meta:resourcekey="dis_Country">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Country"></label>
                                                    <asp:TextBox ID="txtstrCountry" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="adminArea" runat="server">
                                            <eidss:LocationUserControl ID="lucVetAggregate" runat="server" ShowCountry="false" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" />
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Sent_by_Institution">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Sent_by_Institution"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_by_Institution"></label>
                                                    <asp:DropDownList ID="ddlidfSentByOffice" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsSentByOffice_SelectedIndexChanged"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valSentByOffice" runat="server" ControlToValidate="ddlidfSentByOffice" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Sent_by_Institution"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Sent_by_Person">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Sent_by_Person"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_by_Officer"></label>
                                                    <asp:DropDownList ID="ddlidfSentByPerson" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsSentByPerson_SelectedIndexChanged"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valSentByPerson" runat="server" ControlToValidate="ddlidfSentByPerson" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Sent_by_Officer"></asp:RequiredFieldValidator>
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
                                                    <asp:RequiredFieldValidator ID="valReceivedByOffice" runat="server" ControlToValidate="ddlidfReceivedByOffice" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Received_by_Institution"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Person">
                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Person"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Officer"></label>
                                                    <asp:DropDownList ID="ddlidfReceivedByPerson" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsReceivedByPerson_SelectedIndexChanged"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valReceivedByPerson" runat="server" ControlToValidate="ddlidfReceivedByPerson" CssClass="text-danger" InitialValue="null" meta:resourceKey="val_Notification_Received_by_Officer"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Notification_Received_by_Date">
                                                    <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Notification_Received_by_Date"></span>
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatReceivedByDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ID="valReceivedByDate" runat="server" ControlToValidate="txtdatReceivedbyDate" CssClass="text-danger" InitialValue="" meta:resourceKey="val_Notification_Received_by_Date"></asp:RequiredFieldValidator>
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
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvDiagnosis" runat="server"
                                                    AllowPaging="True"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    DataKeyNames="strLastName"
                                                    EmptyDataText="No data available."
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
                                                                <label runat="server" meta:resourcekey="lbl_Diagnosis"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("strDiagnosis") %>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <%# Eval("strDiagnosis") %>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_ICD_10_Code"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("strICD10Code") %>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <%# Eval("strICD10Code") %>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Less_1"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintLess1AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtintLess1AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_31_to_60"></label>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint31to60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint31to60AbsoluteNumber" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <%--<asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <td>
                                                                    <label runat="server" meta:resourcekey="lbl_Rate"></label>
                                                                </td>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint31to60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint31to60Rate" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>--%>
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
                                                        <%--<asp:TemplateField>
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
                                                        </asp:TemplateField>--%>
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
                                            <asp:Button ID="btnVACCancel" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnVACCancel_Click" />
                                            <asp:Button ID="btnNext" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Next" OnClick="btnNext_Click" />
                                            <button id="btnTryDelete" runat="server" class="btn btn-default" type="button" data-toggle="modal" data-target="#usrConfirmDelete" meta:resourceKey="btn_Delete_Aggregate" Visible="false"></button>
                                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnSubmit_Click" Visible="false" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal fade" id="missingSearchObject" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Search_Form"></h4>
                                            <h4 class="modal-title" runat="server" meta:resourcekey="lbl_Start_Date"></h4>
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
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="usrConfirmDelete" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="panel-warning alert alert-warning">
                            <div class="panel-heading">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <h3 class="alert-link" runat="server" meta:resourcekey="lbl_DeleteAggregate"></h3>
                            </div>
                            <div class="panel-body">
                                <p runat="server" meta:resourcekey="lbl_Delete_Aggregate"></p>
                            </div>
                            <div class="form-group text-center">
                                <button type="button"
                                    data-dismiss="modal"
                                    class="btn btn-warning alert-link"
                                    meta:resourcekey="btn_No"
                                    runat="server">
                                </button>
                                <button type="submit" data-dismiss="modal"
                                    class="btn btn-warning alert-link"
                                    id="delYes"
                                    meta:resourcekey="Btn_Yes"
                                    runat="server" />
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
                    };


                    function showAggSubGrid(e, f) {
                        var divTag = '#' + f;
                        var cl = e.target.className;
                        if (cl == 'glyphicon glyphicon-plus-sign') {
                            e.target.className = "glyphicon glyphicon-minus-sign";
                            $(divTag).show();
                        }
                        else {
                            e.target.className = "glyphicon glyphicon-plus-sign";
                            $(divTag).hide();
                        }
                    };                    
                </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
