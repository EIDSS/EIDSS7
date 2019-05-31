<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" MaintainScrollPositionOnPostback="true" EnableEventValidation="true" CodeBehind="ActiveSurveillanceCampaign.aspx.vb" Inherits="EIDSS.ActiveSurveillanceCampaign"
    meta:resourcekey="Page" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnCreateCampaign" />
          <%--  <asp:PostBackTrigger ControlID="btnSubmit" />--%>
        </Triggers>
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div id="divHiddenFieldsSection" runat="server">
                        <asp:HiddenField ID="hdfidfCampaign" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfstrComments" runat="server" Value="NULL" />

                        <asp:HiddenField runat="server" ID="hdfPageIndex" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfPageSize" Value="10" />
                        <asp:HiddenField runat="server" ID="hdfRecordCount" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfCampaignToSampleTypeID" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfCampaignToSampleTypeIndex" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfCampaignToMonitoringSessionID" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfCampaignToMonitoringSessionIndex" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfDeleteCampaignFromSearchResults" Value="False" />
                        <asp:HiddenField runat="server" ID="hdfCampaignIndex" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfDiseaseSelected" Value="NULL" />


                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 id="hdrHASC" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h2>
                            <h2 id="hdrHASR" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign_Review"></h2>
                        </div>
                        <div class="panel-body">
                            <div id="searchForm" runat="server">
                                <div id="search" class="embed-panel" runat="server">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                    <h3 id="hdgSearchCriteria" class="heading" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                    <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" visible="false" onclick="showSearchCriteria(event);" meta:resourcekey="btn_Show_Search_Criteria"></span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="panel-body" runat="server" id="searchCriteria">
                                            <p runat="server" meta:resourcekey="lbl_Search_Instructions"></p>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Campaign_ID"></label>
                                                        <asp:TextBox ID="txtCampaignStrIDFilter" runat="server" CssClass="form-control" AutoPostBack="true"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                        <label runat="server" meta:resourcekey="dis_Search_Or"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Campaign_Name">
                                                        <label runat="server" meta:resourcekey="lbl_Campaign_Name"></label>
                                                        <asp:TextBox ID="txtCampaignNameFilter" runat="server" CssClass="form-control" AutoPostBack="true"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Campaign_Type">
                                                        <label runat="server" meta:resourcekey="lbl_Campaign_Type"></label>
                                                        <asp:DropDownList ID="ddlCampaignTypedFilter" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Search_Campaign_Status">
                                                        <label runat="server" meta:resourcekey="lbl_Campaign_Status"></label>
                                                        <asp:DropDownList ID="ddlCampaignStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" meta:resourcekey="dis_Search_Campaign_Disease">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                        <asp:DropDownList ID="ddlCampaignDiseaseFilter" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <fieldset>
                                                <legend runat="server" meta:resourcekey="lbl_Start_Date_Range"></legend>
                                                <div class="form-group" runat="server" meta:resourcekey="dis_Search_Campaign_Start_Date">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_From"></label>
                                                            <eidss:CalendarInput ID="txtStartDateFromFilter" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_To"></label>
                                                            <eidss:CalendarInput ID="txtStartToFilter" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                        <asp:CompareValidator ID="valStartDateRange" runat="server" ControlToValidate="txtStartToFilter" ControlToCompare="txtStartDateFromFilter" ValueToCompare="txtStartDateFromFilter" Operator="GreaterThanEqual" SetFocusOnError="true" Type="Date"></asp:CompareValidator>
                                                    </div>
                                                </div>
                                            </fieldset>
                                            <%--Search and Clear buttons go here--%>
                                            <%--Bug 3737:Human Active Surveillance Campaign Search | Search Results | Controls in wrong place when Search Criteria expanded--%>
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                                    <asp:Button ID="btn_scClear" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Clear" OnClick="btnClear_Click" />
                                                    <asp:Button ID="btn_scSearch" CssClass="btn btn-primary" runat="server" meta:resourcekey="btn_Search" OnClick="btnSearch_Click" />
                                                </div>
                                            </div>
                                        </div>
                                        <%-- Search Criteria--%>
                                    </div>
                                </div>
                                <%-- Search embeded--%>



                                <div id="searchResults" class="embed-panel" runat="server" visible="false">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                    <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="table-responsive">
                                            <eidss:GridView ID="gvSearchResults"
                                                runat="server"
                                                AllowPaging="True"
                                                PagerSettings-Visible="false"
                                                AllowSorting="true"
                                                PageSize="10"
                                                AutoGenerateColumns="false"
                                                CssClass="table table-striped table-hover"
                                                GridLines="None"
                                                RowStyle-CssClass="table"
                                                meta:resourcekey="Grd_Organization"
                                                EmptyDataText="<%$ Resources:lbl_No_Search_Results.InnerText %>"
                                                UseAccessibleHeader="true"
                                                ShowHeaderWhenEmpty="true"
                                                ShowFooter="True"
                                                DataKeyNames="idfCampaign"
                                                OnPageIndexChanging="gvSearchResults_PageIndexChanging" OnRowDataBound="gvSearchResults_RowDataBound"
                                                OnRowEditing="gvSearchResults_RowEditing" OnRowDeleting="gvSearchResults_RowDeleting"
                                                OnSelectedIndexChanging="gvSearchResults_SelectedIndexChanging"
                                                OnSorting="gvSearchResults_Sorting">
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Campaign_ID.InnerText %>" SortExpression="strCampaignID">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSelect" runat="server" CausesValidation="False" CommandName="select" meta:resourceKey="btn_Select_Campaign"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' Text='<%# Eval("strCampaignID") %>'></asp:LinkButton>
                                                            <asp:Label ID="lblstrCampaignID" runat="server" Text='<%# Eval("strCampaignID") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="strCampaignName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Campaign_Name.InnerText %>" SortExpression="strCampaignName" />
                                                    <asp:BoundField DataField="CampaignType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Campaign_Type.InnerText %>" SortExpression="CampaignType" />
                                                    <asp:BoundField DataField="CampaignStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Campaign_Status.InnerText %>" SortExpression="CampaignStatus" />
                                                    <asp:BoundField DataField="datCampaignDateStart" DataFormatString="{0:d}" ReadOnly="true" HeaderText="<%$ Resources:lbl_Campaign_Start_Date.InnerText %>" SortExpression="datCampaignDateStart" />
                                                    <asp:BoundField DataField="Diagnosis" ReadOnly="true" HeaderText="<%$ Resources:lbl_Disease.InnerText %>" SortExpression="Diagnosis" />
                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Campaign"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Campaign"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <span role="button" class="glyphicon glyphicon-triangle-bottom" onclick="showSubGrid(event,'divHASC<%#Eval("idfCampaign") %>');"></span>
                                                            <tr id="divHASC<%# Eval("idfCampaign") %>" style="display: none;">
                                                                <td colspan="6" style="border-top: 0 none transparent;">
                                                                    <div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Campaign_End_Date"></label>
                                                                                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%#Eval("datCampaignDateEND", "{0:d}") %>'></asp:TextBox>
                                                                                </div>
                                                                                <div class="col-lg-6 col-md-4 col-sm-6 col-xs-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Campaign_Administrator"></label>
                                                                                    <asp:TextBox ID="txtCampaignAdministrator" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%#Eval("strCampaignAdministrator") %>'></asp:TextBox>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group form-group-sm">
                                                                            <div class="row">
                                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                                    <label runat="server" class="table-striped-header" meta:resourcekey="lbl_Sample_Types"></label>
                                                                                    <asp:TextBox ID="txtSampleTypesList" runat="server" CssClass="form-control input-sm" Enabled="false" Text='<%#Eval("SampleTypesList") %>' TextMode="MultiLine"></asp:TextBox>
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
                                <%--id = searchresults--%>

                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                            <%--<button type="submit" id="btnCancelCampaignRTD" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel_Camp" data-toggle="modal" data-target="#campaignCancelModal" ></button>--%>

                                            <button id="btnCancelCampaignRTD" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Camp" data-toggle="modal" data-target="#campaignCancelModal"></button>
                                            <button id="btnCancelCampaignSearch" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Camp" data-toggle="modal" data-target="#cancelCampaignSearch" visible="False"></button>

                                            <asp:Button ID="btnClear" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Clear" OnClick="btnClear_Click" />
                                            <asp:Button ID="btnSearch" CssClass="btn btn-primary" runat="server" meta:resourcekey="btn_Search" OnClick="btnSearch_Click" />
                                            <asp:Button ID="btnCreateCampaign" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Campaign" OnClick="btnCreateCampaign_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%-- Search Form ends--%>
                        </div>
                        <%--Ends Panel Body for search try this out and remove !!!!--%>





                        <div id="campaignInformation" class="embed-panel" runat="server" visible="false">
                            <div class="sectionContainer expanded">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <h3 class="heading" runat="server" meta:resourcekey="hdg_Campaign_Information"></h3>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" runat="server" meta:resourcekey="btn_Go_To_Campaign_Information" onclick="goToTab(0)"></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="panel-group">
                                    <div class="form-group" runat="server" id="divCampaignID" visible="false">
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Campaign_ID"></label>
                                                <asp:TextBox ID="txtstrCampaignID" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Campaign_Name">
                                                <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Campaign_Name"></div>
                                                <label for="txtstrCampaignName" runat="server" meta:resourcekey="lbl_Campaign_Name"></label>
                                                <asp:TextBox ID="txtstrCampaignName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtstrCampaignName" CssClass="text-danger" InitialValue="" Display="Dynamic" meta:resourceKey="val_Campaign_Name" ValidationGroup="valsubmit" ></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Campaign_Type">
                                                <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Campaign_Type"></div>
                                                <label for="ddlidfsCampaignType" runat="server" meta:resourcekey="lbl_Campaign_Type"></label>
                                                <asp:DropDownList ID="ddlidfsCampaignType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsCampaignType" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="valsubmit" meta:resourceKey="val_Campaign_Type"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Campaign_Status">
                                                <div class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Campaign_Status"></div>
                                                <label for="ddlidfsCampaignStatus" runat="server" meta:resourcekey="lbl_Campaign_Status"></label>
                                                <asp:DropDownList ID="ddlidfsCampaignStatus" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfscampaignStatus_SelectedIndexChanged"></asp:DropDownList>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsCampaignStatus" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="valsubmit" meta:resourceKey="val_Campaign_Status"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Campaign_Start_Date">
                                                <label runat="server" meta:resourcekey="lbl_Campaign_Start_Date"></label>
                                                <eidss:CalendarInput ID="txtdatCampaignDateStart" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                            </div>
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" meta:resourcekey="dis_Campaign_End_Date">
                                                <label runat="server" meta:resourcekey="lbl_Campaign_End_Date"></label>
                                                <eidss:CalendarInput ID="txtdatCampaignDateEND" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                            </div>
                                        </div>
                                        <%--   Error AK - Locked screen input          <asp:CompareValidator ID="valCampaignDateRange" ControlToValidate="txtdatCampaignDateEND" CultureInvariantValues="true" Display="Dynamic" runat="server" CssClass="text-danger" ControlToCompare="txtdatCampaignDateStart" ValueToCompare="txtdatCampaignDateStart" Operator="GreaterThanEqual" SetFocusOnError="true" Type="Date" meta:resourceKey="val_Campaign_Date_Range"></asp:CompareValidator>--%>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Campaign_Administrator">
                                                <label runat="server" meta:resourcekey="lbl_Campaign_Administrator"></label>
                                                <asp:TextBox ID="txtstrCampaignAdministrator" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12" runat="server" meta:resourcekey="dis_Diagnosis">
                                                <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Diagnosis"></span>
                                                <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                <asp:DropDownList ID="ddlidfsDiagnosis" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsDiagnosis_SelectedIndexChanged"></asp:DropDownList>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsDiagnosis" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="valsubmit" meta:resourceKey="val_Diagnosis"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>


                                    <%--Panel Body that needs to Add Sample Information AK--%>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <h3 class="heading" runat="server" meta:resourcekey="hdg_Samples"></h3>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <p runat="server" meta:resourcekey="lbl_Campaign_Samples_Instructions"></p>
                                            <div class="table-responsive">
                                                <eidss:GridView
                                                    AutoGenerateColumns="false"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped table-hover"
                                                    GridLines="None"
                                                    ID="gvSamples"
                                                    DataKeyNames="CampaignToSampleTypeUID"
                                                    KeyNameUsedOnModal="FullName"
                                                    meta:resourcekey="Grd_Sample"
                                                    runat="server"
                                                    ShowFooter="true"
                                                    ShowHeader="true"
                                                    ShowHeaderWhenEmpty="true"
                                                    OnRowDataBound="gvSamples_RowDataBound"
                                                    OnRowEditing="gvSamples_RowEditing"
                                                    OnRowCancelingEdit="gvSamples_RowCancelingEdit"
                                                    OnRowUpdating="gvSamples_RowUpdating"
                                                    OnRowCommand="gvSamples_RowCommand"
                                                    OnRowDeleting="gvSamples_RowDeleting"
                                                    UseAccessibleHeader="true">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <SortedAscendingCellStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingCellStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <Columns>
                                                        <%--Fields to display--%>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <%# GetLocalResourceObject("lbl_Sample_Type.InnerText") %><br />
                                                                <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSampleTypeText" runat="server" Text='<%# Bind("sampleType") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <%# GetLocalResourceObject("lbl_Planned_Number.InnerText") %><br />
                                                                <eidss:NumericSpinner ID="txtPlannedNumber" runat="server" Text='<%# Bind("intPlannedNumber") %>' MinValue="0" MaxValue="100" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblPlannedNumber" runat="server" Text='<%# Bind("intPlannedNumber") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtPlannedNumber" runat="server" Text='<%# Bind("intPlannedNumber") %>' MinValue="0" MaxValue="100" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                            <HeaderTemplate>
                                                                <asp:LinkButton ID="btnAdd" runat="server" CausesValidation="False" CommandName="insert" meta:resourceKey="btn_Add_Sample"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-plus-sign"></span></asp:LinkButton>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Sample"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Update_Sample"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Sample"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="cancel" meta:resourceKey="btn_Cancel_Sample"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-remove"></span></asp:LinkButton>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                            <%--Table Responsive--%>
                                        </div>
                                        <%--Panel Bodyfault Samples --%>
                                    </div>
                                    <%--Panel default Samples --%>



                                    <div class="panel-body" id="sessions" runat="server" visible="false">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Sessions"></h3>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                        <asp:Button ID="btnSearchSessions" runat="server" CssClass="btn btn-default btn-sm" meta:resourceKey="btn_Search" OnClick="btnSearchSessions_Click" />
                                                        <asp:Button ID="btnNewSession" runat="server" CssClass="btn btn-default btn-sm" meta:resourceKey="btn_Add" OnClick="btnNewSession_Click" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" runat="server" meta:resourcekey="btn_Go_To_Sessions" onclick="goToTab(2)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped table-hover"
                                                        DataKeyNames="idfMonitoringSession"
                                                        GridLines="None"
                                                        ID="gvSessions"
                                                        meta:resourcekey="Grd_Sessions_List"
                                                        runat="server"
                                                        ShowFooter="false"
                                                        ShowHeader="true"
                                                        UseAccessibleHeader="true"
                                                        ShowHeaderWhenEmpty="true" OnRowCommand="gvSessions_RowCommand"
                                                        OnSelectedIndexChanging="gvSessions_SelectedIndexChanging"
                                                        OnRowEditing="gvSessions_RowEditing"
                                                        OnRowCancelingEdit="gvSessions_RowCancelingEdit"
                                                        OnRowDeleting="gvSessions_RowDeleting">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Session_ID.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblstrMonitoringSessionID" runat="server" Text='<%# Eval("strMonitoringSessionID") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Region.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblRegion" runat="server" Text='<%# Eval("Region") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Rayon.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblRayon" runat="server" Text='<%# Eval("Rayon") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Settlement_ID.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSettlement" runat="server" Text='<%# Eval("Settlement") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Session_Start_Date.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbldatStartDate" runat="server" Text='<%# Eval("datStartDate", "{0:MM/dd/yyyy}") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Session_End_Date.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lbldatEndDate" runat="server" Text='<%# Eval("datEndDate", "{0:MM/dd/yyyy}") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate><%# GetLocalResourceObject("lbl_Session_Status.InnerText") %></HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblstrSessionStatus" runat="server" Text='<%# Eval("SessionStatus") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Session"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Session"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </div>




                                </div>
                                <%--Panel Group campaignInformation --%>





                                <div class="panel" id="conclusion" runat="server" visible="false">
                                    <div class="panel-heading">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <h3 class="heading" runat="server" meta:resourcekey="hdg_Conclusions"></h3>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Conclusion">
                                            <label runat="server" meta:resourcekey="lbl_Conclusion"></label>
                                            <asp:TextBox ID="txtstrConclusion" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>


                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
<%--                                        <button type="button" runat="server" class="btn btn-default" data-toggle="modal" data-target="#cancelCampaign" meta:resourcekey="btn_Cancel" />--%>
                                         <button type="button" id="btnCancelSubmit" runat="server" class="btn btn-default" data-toggle="modal" data-target="#cancelCampaign" meta:resourcekey="btn_Cancel"></button>
                                        <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Previous" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" visible="false" />
                                        <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Next" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" visible="false" />
                                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" ValidationGroup="valsubmit" causesvalidation="true" OnClick ="btnSubmit_Click" />

                                        <button id="btnDelete" type="button" runat="server" class="btn btn-primary" data-toggle="modal" data-target="#deleteCampaign" meta:resourcekey="btn_Delete_Campaign" visible="false"></button>
                                    </div>
                                </div>
                            </div>
                            <%--sectionContainer expanded--%>
                        </div>
                        <%--CampaigneInformation End--%>


                        <section id="conclusion1" runat="server" class="col-md-12 hidden" visible="True">
                            <div class="panel panel-default">
                            </div>
                        </section>

                        <section id="samples" runat="server" class="col-md-12 hidden">
                        </section>
                    </div> <%-- panel default  line 31--%>
                    
                </div>  <%-- class =  row line 15--%>
                
            </div> <%-- class =  container line 14--%>
            

            <div id="errorCampaign" class="modal" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-remove-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Error" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>



            <div id="campaignCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Hpl_Return_to_Dashboard"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" href="~/Dashboard.aspx" meta:resourcekey="btn_Yes"></a>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>


                        </div>
                    </div>
                </div>
            </div>



            <div id="successCreateCampaignModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="P1" runat="server" meta:resourcekey="lbl_Create_Campaign"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="button" id="btnCreateYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" onclick="btnSubmit_Click"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>



            <div id="successCampaign" class="modal" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblCampaignSuccess" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button id="btnRTDSC" type="submit" runat="server" meta:resourcekey="Hpl_Return_to_Dashboard" class="btn btn-primary" data-dismiss="modal"></button>
                            <button id="btnRTS" type="submit" runat="server" meta:resourcekey="btn_Return_to_Search" class="btn btn-primary" data-dismiss="modal"></button>
                            <button id="btnRTCR" type="submit" runat="server" meta:resourcekey="btn_Return_to_Campaign_Record" class="btn btn-primary" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>


            <div id="successDeleteCampaign" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p runat="server" meta:resourcekey="lbl_Successful_Delete"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button id="btnRTDSD" type="submit" runat="server" meta:resourcekey="Hpl_Return_to_Dashboard" class="btn btn-primary" data-dismiss="modal"></button>
                            <button id="btnReturnToSearch" type="submit" runat="server" meta:resourcekey="btn_Return_to_Search" class="btn btn-primary" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="cancelCampaign" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblCampaignCancel" runat="server" meta:resourcekey="lbl_Cancel_Campaign"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnCancelYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="cancelCampaignSearch" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="P2" runat="server" meta:resourcekey="lbl_Cancel_Campaign"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnCancelYesSearch" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>


            <div id="cancelSampleType" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p runat="server" meta:resourcekey="lbl_Cancel_Sample_Type"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnCancelSampleTypeYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="deleteSampleType" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblRemoveSampleType" runat="server" meta:resourcekey="lbl_Remove_Sample_Type"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnDeleteSampleType" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="deleteSession" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p runat="server" meta:resourcekey="lbl_Remove_Session"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnDeleteSession" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="deleteCampaign" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Campaign"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblDeleteCampaign" runat="server" meta:resourcekey="lbl_Delete_Campaign"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" id="btnDeleteYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>


            <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
            <script type="text/javascript">
                $(document).ready(function () {
                    modalize();
                    var campaignInformation = document.getElementById("<% = campaignInformation.ClientID %>");
                    if (campaignInformation != null || campaignInformation != undefined) {
                        setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                       $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click(function () { headerTitle(); });
                        $('.sidepanel ul li').click(function () { headerTitle(); });
                    }
                    //  This registers a call back handler that is triggered after every successful postback (sync or async)
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                    $('#<%= errorCampaign.ClientID %>').modal({ show: false, backdrop: 'static' });
                    $('#<%= successCampaign.ClientID %>').modal({ show: false, backdrop: 'static' });
                    var search = document.getElementById("<% = search.ClientID %>");
                    if (search != undefined && <%= (Not Page.IsPostBack).ToString().ToLower() %>)
                        $('#<%= txtCampaignStrIDFilter.ClientID %>').focus();
                });

                function callBackHandler() {
                    var campaignInformation = document.getElementById("<% = campaignInformation.ClientID %>");
                    if (campaignInformation != undefined) {
                        setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                        $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click(function () { headerTitle(); });
                        $('.sidepanel ul li').click(function () { headerTitle(); });
                    }

                    modalize();
                }

                function modalize() {
                    $('.modal').modal({ show: false, backdrop: 'static' });
                }

                function showSubGrid(e, f) {
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom') {
                        e.target.className = "glyphicon glyphicon-triangle-top";
                        $('#' + f).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom";
                        $('#' + f).hide();
                    }
                }

                function showSearchCriteria(e) {
                    //alert("e => " + e);
                    //alert("e.target.className => " + e.target.className);
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom header-button') {
                        e.target.className = "glyphicon glyphicon-triangle-top header-button";
                        $('#<%= searchCriteria.ClientID %>').show();
                        $('#<%= btn_scClear.ClientID %>').show();
                        $('#<%= btn_scSearch.ClientID %>').show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom header-button";
                        $('#<%= searchCriteria.ClientID %>').hide();
                        $('#<%= btn_scClear.ClientID %>').hide();
                        $('#<%= btn_scSearch.ClientID %>').hide();
                    }
                }

                function headerTitle() {
                    var campaignID = $('#<%= hdfidfCampaign.ClientID %>').val();
                    var panelController = $('#<%= hdnPanelController.ClientID %>').val();

                    if ((campaignID == 'NULL' && panelController == "2") || (campaignID != 'NULL' && panelController == "4")) {
                        $('#<%= hdrHASC.ClientID %>').hide();
                        $('#<%= hdrHASR.ClientID %>').show();
                    }
                    else {
                        $('#<%= hdrHASR.ClientID %>').hide();
                        $('#<%= hdrHASC.ClientID %>').show();
                    }

                }

                function showModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal({ show: true, backdrop: 'static' });
                }


                function hideModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal('hide');
                }



            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
