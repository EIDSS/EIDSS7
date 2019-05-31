<%@ Page Title="Laboratory Home" Language="vb" AutoEventWireup="false" MasterPageFile="~/FullView.Master" CodeBehind="Laboratory.aspx.vb" Inherits="EIDSS.Laboratory" %>

<%@ Register Src="~/Controls/LaboratoryMenuUserControl.ascx" TagPrefix="eidss" TagName="Menu" %>
<%@ Register Src="~/Controls/LaboratorySearchUserControl.ascx" TagPrefix="eidss" TagName="Search" %>
<%@ Register Src="~/Controls/LaboratoryColumnViewPreferencesUserControl.ascx" TagPrefix="eidss" TagName="ColumnViewPreferences" %>
<%@ Register Src="~/Controls/AliquotsDerivativesUserControl.ascx" TagPrefix="eidss" TagName="AliquotsDerivatives" %>
<%@ Register Src="~/Controls/AssignTestUserControl.ascx" TagPrefix="eidss" TagName="AssignTest" %>
<%@ Register Src="~/Controls/GroupAccessionInUserControl.ascx" TagPrefix="eidss" TagName="GroupAccessionIn" %>
<%--<%@ Register Src="~/Controls/ReferenceUserControl.ascx" TagPrefix="eidss" TagName="Reference" %>--%>
<%@ Register Src="~/Controls/RegisterNewSampleUserControl.ascx" TagPrefix="eidss" TagName="RegisterNewSample" %>
<%@ Register Src="~/Controls/AddUpdateSampleUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateSample" %>
<%@ Register Src="~/Controls/AddUpdateTestUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateTest" %>
<%@ Register Src="~/Controls/AddUpdateBatchUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateBatch" %>
<%@ Register Src="~/Controls/AmendTestResultUserControl.ascx" TagPrefix="eidss" TagName="AmendTestResult" %>
<%@ Register Src="~/Controls/AdditionalTestDetailsUserControl.ascx" TagPrefix="eidss" TagName="AdditionalTestDetails" %>
<%@ Register Src="~/Controls/AmendmentHistoryUserControl.ascx" TagPrefix="eidss" TagName="AmendmentHistory" %>
<%@ Register Src="~/Controls/PrintBarCodeUserControl.ascx" TagPrefix="eidss" TagName="PrintBarCode" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPerson" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePerson" %>
<%@ Register Src="~/Controls/SearchSampleUserControl.ascx" TagPrefix="eidss" TagName="SearchSample" %>
<%@ Register Src="~/Controls/SearchHumanDiseaseReportUserControl.ascx" TagPrefix="eidss" TagName="SearchHumanDiseaseReport" %>
<%@ Register Src="~/Controls/SearchHumanSessionUserControl.ascx" TagPrefix="eidss" TagName="SearchHumanSession" %>
<%@ Register Src="~/Controls/SearchVectorSessionUserControl.ascx" TagPrefix="eidss" TagName="SearchVectorSession" %>
<%@ Register Src="~/Controls/SearchVeterinaryDiseaseReportUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinaryDiseaseReport" %>
<%@ Register Src="~/Controls/SearchVeterinarySessionUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinarySession" %>
<%@ Register Src="~/Controls/TransferSampleUserControl.ascx" TagPrefix="eidss" TagName="TransferSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:HiddenField ID="hdfCurrentTab" runat="server" Value="" />
    <div>
        <div id="divHiddenFieldsSection" runat="server" visible="false">
            <asp:HiddenField ID="hdfTestID" runat="server" Value="" />
            <asp:HiddenField ID="hdfEIDSSLocalFieldSampleID" runat="server" Value="" />
            <asp:HiddenField ID="hdfEIDSSLaboratorySampleID" runat="server" Value="" />
            <asp:HiddenField ID="hdfDiseaseIDList" runat="server" Value="" />
            <asp:HiddenField ID="hdfAccessionedIndicator" runat="server" Value="" />
            <asp:HiddenField ID="hdfTestUnassignedIndicator" runat="server" Value="" />
            <asp:HiddenField ID="hdfTestCompleteIndicator" runat="server" Value="" />
            <asp:HiddenField ID="hdfAdvancedSearchIndicator" runat="server" Value="10100002" />
            <asp:HiddenField ID="hdfRecordID" runat="server" Value="0" />
            <asp:HiddenField ID="hdfRecordAction" runat="server" Value="" />
            <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
            <asp:HiddenField ID="hdfSamplesCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfTestingCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfBatchesCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfBatchTestID" runat="server" />
            <asp:HiddenField ID="hdfUnaccessionedSamplesSelectedCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfAccessionedSamplesSelectedCount" runat="server" Value="0" />
            <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserID" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserName" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserOrganization" runat="server" Value="" />
            <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
            <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
            <asp:HiddenField ID="hdfCurrentModuleAction" runat="server" Value="" />
            <asp:HiddenField ID="hdfSamplePrintBarcodes" runat="server" Value="False" />
            <asp:HiddenField ID="hdfTransferPrintBarcodes" runat="server" Value="True" />
            <asp:HiddenField ID="hdfAliquotDerivativePrintBarcodes" runat="server" Value="False" />
            <asp:HiddenField ID="hdfSamplesSelectAll" runat="server" Value="False" />
            <asp:HiddenField ID="hdfTestingSelectAll" runat="server" Value="False" />
            <asp:HiddenField ID="hdfTransferredSelectAll" runat="server" Value="False" />
            <asp:HiddenField ID="hdfBatchesSelectAll" runat="server" Value="False" />
            <asp:HiddenField ID="hdfMyFavoritesSelectAll" runat="server" Value="False" />
            <asp:HiddenField ID="hdfApprovalsSelectAll" runat="server" Value="False" />
        </div>
        <div class="row">
            <div class="col-xs-12">
                <div class="lab-heading">
                    <h2 runat="server" class="lab-heading"><%= GetGlobalResourceObject("Labels", "Lbl_Laboratory_Text") %></h2>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <asp:UpdatePanel ID="upLaboratoryTabCounts" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <ul class="nav nav-tabs lab" id="tabLaboratory">
                            <li id="liSamples"><a id="lnkSamples" href="#EIDSSBodyCPH_NavSamples" data-toggle="tab" onclick="tabChanged(this, 'Samples');">
                                <asp:Label ID="lblSamples" runat="server" meta:resourcekey="Lbl_Samples"></asp:Label>
                                <asp:Label ID="lblSamplesCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                            <li id="liTesting"><a id="lnkTesting" href="#EIDSSBodyCPH_NavTesting" data-toggle="tab" onclick="tabChanged(this, 'Testing');">
                                <asp:Label ID="lblTesting" runat="server" meta:resourcekey="Lbl_Testing"></asp:Label>
                                <asp:Label ID="lblTestingCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                            <li id="liTransferred"><a id="lnkTransferred" href="#EIDSSBodyCPH_NavTransferred" data-toggle="tab" onclick="tabChanged(this, 'Transferred');">
                                <asp:Label ID="lblTransferred" runat="server" meta:resourcekey="Lbl_Transferred"></asp:Label>
                                <asp:Label ID="lblTransferredCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                            <li id="liMyFavorites"><a id="lnkFavorites" href="#EIDSSBodyCPH_NavMyFavorites" data-toggle="tab" onclick="tabChanged(this, 'Favorites');">
                                <asp:Label ID="lblMyFavorites" runat="server" meta:resourcekey="Lbl_My_Favorites"></asp:Label>
                                <asp:Label ID="lblMyFavoritesCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                            <li id="liBatches"><a id="lnkBatches" href="#EIDSSBodyCPH_NavBatches" data-toggle="tab" onclick="tabChanged(this, 'Batches');">
                                <asp:Label ID="lblBatches" runat="server" meta:resourcekey="Lbl_Batches"></asp:Label>
                                <asp:Label ID="lblBatchesCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                            <li id="liApprovals"><a id="lnkApprovals" href="#EIDSSBodyCPH_NavApprovals" data-toggle="tab" onclick="tabChanged(this, 'Approvals');">
                                <asp:Label ID="lblApprovals" runat="server" meta:resourcekey="Lbl_Approvals"></asp:Label>
                                <asp:Label ID="lblApprovalsCount" runat="server" Font-Bold="True"></asp:Label></a>
                            </li>
                        </ul>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div class="tab-content">
                    <div id="NavSamples" class="tab-pane" role="tabpanel" aria-labelledby="NavSamplesTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upSamplesMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucSamplesMenu" runat="server" Tab="Samples" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divSamplesDivider1" class="divider-panel">&nbsp;</div>
                                <div id="divSamplesCommand" class="lab-command-panel">
                                    <asp:UpdatePanel ID="upSamplesButtons" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="gvSamples" EventName="RowCommand" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <button type="button" id="btnAccession" runat="server" data-toggle="popover" class="btn popup-window" data-placement="right"><% =GetGlobalResourceObject("Labels", "Lbl_Accession_Text") %></button>
                                            <div id="divAccessionContainer" class="popup-content hide">
                                                <div class="">
                                                    <asp:DropDownList ID="ddlAccessionIn" runat="server" CssClass="form-control" AutoPostBack="true" Width="200"></asp:DropDownList>
                                                    <div>
                                                        <asp:CheckBox ID="chkSamplePrintBarcodes" runat="server" AutoPostBack="true" />&nbsp;<asp:Label ID="lblPrintBarcode" runat="server" CssClass="control-label" meta:resourceKey="Lbl_Print_Barcode_Question"></asp:Label>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Button ID="btnSamplesAliquot" runat="server" meta:resourceKey="Btn_Aliquot" CssClass="btn btn-default" CausesValidation="false" />
                                            <asp:Button ID="btnSamplesAssignTest" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Assign_Test_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Assign_Test_ToolTip %>" CausesValidation="false" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="divSamplesDivider2" class="divider-panel">&nbsp;</div>
                                <div class="search-panel" id="divSamplesSearch">
                                    <eidss:Search ID="ucSamplesSearch" runat="server" />
                                </div>
                                <div id="divSamplesDivider3" class="divider-panel">&nbsp;</div>
                                <div class="samples-save-panel">
                                    <asp:UpdatePanel ID="upSamplesSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnSamplesSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnSamplesSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" Height="35" CausesValidation="false" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="divSamplesDivider4" class="divider-panel">&nbsp;</div>
                                <asp:UpdatePanel ID="upSamplesSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgSamplesQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgSamplesSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div id="divSamplesFilter" class="filter-panel">
                                    <div class="container-fluid">
                                        <asp:UpdatePanel ID="upSamplesFilter" runat="server" UpdateMode="Conditional">
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="chkTestNotAssigned" EventName="CheckedChanged" />
                                                <asp:AsyncPostBackTrigger ControlID="chkTestComplete" EventName="CheckedChanged" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <label id="lblFilter" runat="server" meta:resourcekey="Lbl_Filter" class="control-label"></label>
                                                <br />
                                                <div class="checkbox-inline">
                                                    <asp:CheckBox ID="chkTestNotAssigned" runat="server" meta:resourceKey="Lbl_Test_Not_Assigned" Enabled="true" AutoPostBack="true" />
                                                </div>
                                                <br />
                                                <div class="checkbox-inline">
                                                    <asp:CheckBox ID="chkTestComplete" runat="server" meta:resourceKey="Lbl_Test_Complete" Enabled="true" AutoPostBack="true" />
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divSamplesDivider5" class="divider-panel"></div>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upSamplesColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnSamplesColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnSamplesColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upSamples" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvSamples" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvSamples" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divSamples">
                                            <eidss:GridView ID="gvSamples" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CssClass="table lab-table-striped table-hover" DataKeyNames="SampleID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnToggleAllSamples" runat="server" CommandName="Toggle Select All" CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnToggleSamples" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("SampleID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn" ShowHeader="False">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSamplesEdit" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnHeaderSamplesSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="Select All Records My Favorite" CommandArgument='All' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgHeaderSamplesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSamplesSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="My Favorite" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgSamplesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" HeaderStyle-CssClass="eidssReportSessionStickyColumn" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                    <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" HeaderStyle-CssClass="patientFarmOwnerStickyColumn" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                    <asp:BoundField DataField="EIDSSLocalFieldSampleID" SortExpression="EIDSSLocalFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>" />
                                                    <asp:BoundField DataField="AccessionDate" SortExpression="AccessionDate" HeaderText="<%$ Resources: Labels, Lbl_Accession_Date_Time_Text %>" />
                                                    <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" SortExpression="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upSamplesAccessionItemTemplate" runat="server" UpdateMode="Conditional">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlSamplesSampleStatusType" />
                                                                    <asp:AsyncPostBackTrigger ControlID="txtSamplesCommentTextBoxEmpty" EventName="TextChanged" />
                                                                    <asp:AsyncPostBackTrigger ControlID="txtSamplesCommentTextBox" EventName="TextChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblSamplesSampleStatusTypeName" runat="server" Text='<% #Bind("AccessionConditionOrSampleStatusTypeName") %>'></asp:Label>
                                                                        <eidss:DropDownList ID="ddlSamplesSampleStatusType" runat="server" CssClass="form-control" AutoPostBack="true" Width="225" OnSelectedIndexChanged="SamplesSampleStatusType_SelectedIndexChanged"></eidss:DropDownList>
                                                                        <div class="divEmptyCommentContainer">
                                                                            <a href="#" id="lnkSamplesSampleStatusCommentEmpty" runat="server" data-placement="right" data-html="true">
                                                                                <div id="divSamplesEmptyCommentBox" class="commentBoxDefault">
                                                                                    <div class="whiteCommentBox">
                                                                                        <img class="imgWhiteCommentBox" src="../Includes/Images/commentBoxEmpty.png" />
                                                                                    </div>
                                                                                    <div id="divSamplesCommentRequired" runat="server" class="redAsterisk">
                                                                                        <img class="imgRedAsterisk" src="../Includes/Images/redAsterisk.png" />
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div id="divSamplesCommentBoxEmptyContainer" runat="server" class="hide">
                                                                                <asp:TextBox ID="txtSamplesCommentTextBoxEmpty" runat="server" CssClass="txtCommentTextBoxEmpty" TextMode="MultiLine" AutoPostBack="true" OnTextChanged="SamplesCommentTextBoxEmpty_TextChanged"></asp:TextBox>
                                                                            </div>
                                                                        </div>
                                                                        <div class="divCommentContainer">
                                                                            <a href="#" id="lnkSamplesSampleStatusComment" runat="server" data-placement="right" data-html="true">
                                                                                <div id="divSamplesCommentBox" class="commentBoxDefault">
                                                                                    <div class="blueCommentBox">
                                                                                        <img class="imgBlueCommentBox" src="../Includes/Images/commentBoxNonEmpty.png" />
                                                                                    </div>
                                                                                    <div class="redAsterisk">
                                                                                        <img class="imgSamplesRedAsterisk" src="../Includes/Images/redAsterisk.png" />
                                                                                    </div>
                                                                                </div>
                                                                            </a>
                                                                            <div id="divSamplesCommentBoxContainer" runat="server" class="hide">
                                                                                <asp:TextBox ID="txtSamplesCommentTextBox" runat="server" CssClass="txtCommentTextBox" TextMode="MultiLine" AutoPostBack="true" OnTextChanged="SamplesCommentTextBox_TextChanged"></asp:TextBox>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="FunctionalAreaName" HeaderText="<%$ Resources: Labels, Lbl_Functional_Area_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upSamplesFunctionalArea" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlSamplesFunctionalArea" EventName="SelectedIndexChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <asp:Label ID="lblSamplesFunctionalAreaName" runat="server" Text='<% #Bind("FunctionalAreaName") %>'></asp:Label>
                                                                    <eidss:DropDownList ID="ddlSamplesFunctionalArea" runat="server" CssClass="form-control" AutoPostBack="true" Width="225" OnSelectedIndexChanged="SamplesFunctionalArea_SelectedIndexChanged"></eidss:DropDownList>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divSamplesPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblSamplesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptSamplesPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upSamplesPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkSamplesPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkSamplesPage" runat="server" CssClass="btn btn-primary btn-sm" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="SamplesPage_Changed" CausesValidation="False"></asp:LinkButton>
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
                    <div id="NavTesting" class="tab-pane" role="tabpanel" aria-labelledby="NavTestingTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upTestingMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucTestingMenu" runat="server" Tab="Testing" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divTestingDivider1" class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upTestingButtons" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnTestingBatch" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnTestingAssignTest" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnTestingBatch" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Batch_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Batch_ToolTip %>" CausesValidation="false" />
                                            <asp:Button ID="btnTestingAssignTest" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Assign_Test_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Assign_Test_ToolTip %>" CausesValidation="false" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="divTestingDivider2" class="divider-panel">&nbsp;</div>
                                <div class="search-panel">
                                    <asp:UpdatePanel ID="upTestingSearch" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <eidss:Search ID="ucTestingSearch" runat="server" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="divTestingDivider3" class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upTestingSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnTestingSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnTestingSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" Enabled="false" Height="35" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upTestingSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgTestingQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgTestingSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upTestingColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnTestingColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnTestingColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upTesting" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvTesting" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvTesting" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divTesting">
                                            <eidss:GridView ID="gvTesting" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CssClass="table lab-table-striped table-hover" DataKeyNames="TestID" GridLines="None" runat="server" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnToggleAllTesting" runat="server" CommandName="Toggle Select All" CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnToggleTesting" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("TestID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn" ShowHeader="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnTestingEdit" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("TestID") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnHeaderTestingSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="Select All Records My Favorite" CommandArgument='All' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgHeaderTestingMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnTestingSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="My Favorite" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgTestingMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" HeaderStyle-CssClass="eidssReportSessionStickyColumn" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                    <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" HeaderStyle-CssClass="patientFarmOwnerStickyColumn" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                    <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:BoundField DataField="TestNameTypeName" SortExpression="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                    <asp:TemplateField SortExpression="TestStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Status_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upTestingTestStatus" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlTestingTestStatusType" EventName="SelectedIndexChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblTestingTestStatusTypeName" runat="server" Text='<% #Bind("TestStatusTypeName") %>'></asp:Label>
                                                                        <eidss:DropDownList ID="ddlTestingTestStatusType" runat="server" CssClass="form-control" OnSelectedIndexChanged="TestingTestStatusType_SelectedIndexChanged"></eidss:DropDownList>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="StartedDate" HeaderText="<%$ Resources: Labels, Lbl_Test_Started_Date_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upTestingTestStartedDate" runat="server" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="txtTestingTestStartedDate" EventName="TextChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblTestingTestStartedDate" runat="server" Text='<% #Bind("StartedDate") %>'></asp:Label>
                                                                        <eidss:CalendarInput ID="txtTestingTestStartedDate" runat="server" ContainerCssClass="input-group datepicker" Width="120" CssClass="form-control" OnTextChanged="TestingTestStartedDate_TextChanged" />
                                                                        <asp:CompareValidator ID="cvFutureTestingTestStartedDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtTestingTestStartedDate" meta:resourcekey="Val_Future_Test_Started_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Testing" SetFocusOnError="True"></asp:CompareValidator>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <div class="flex-container">
                                                                    <asp:Label ID="lblTestingSampleStatusTypeName" runat="server" Text='<% #Bind("AccessionConditionOrSampleStatusTypeName") %>'></asp:Label>
                                                                    <div class="divEmptyCommentContainer">
                                                                        <a href="#" id="lnkTestingSampleStatusCommentEmpty" runat="server" data-placement="right" data-html="true">
                                                                            <div id="divTestingEmptyCommentBox" class="commentBoxDefault">
                                                                                <div class="whiteCommentBox">
                                                                                    <img class="imgWhiteCommentBox" src="../Includes/Images/commentBoxEmpty.png" />
                                                                                </div>
                                                                            </div>
                                                                        </a>
                                                                        <div id="divTestingCommentBoxEmptyContainer" runat="server" class="hide">
                                                                            <asp:TextBox ID="txtTestingCommentTextBoxEmpty" runat="server" CssClass="txtCommentTextBoxEmpty" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="divCommentContainer">
                                                                        <a href="#" id="lnkTestingSampleStatusComment" runat="server" data-placement="right" data-html="true">
                                                                            <div id="divTestingCommentBox" class="commentBoxDefault">
                                                                                <div class="blueCommentBox">
                                                                                    <img class="imgBlueCommentBox" src="../Includes/Images/commentBoxNonEmpty.png" />
                                                                                </div>
                                                                            </div>
                                                                        </a>
                                                                        <div id="divTestingCommentBoxContainer" runat="server" class="hide">
                                                                            <asp:TextBox ID="txtTestingCommentTextBox" runat="server" CssClass="txtCommentTextBox" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="TestResultTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Result_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upTestingTestResult" runat="server" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlTestingTestResultType" EventName="SelectedIndexChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblTestingTestResultTypeName" runat="server" Text='<% #Bind("TestResultTypeName") %>'></asp:Label>
                                                                        <eidss:DropDownList ID="ddlTestingTestResultType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="TestingTestResultType_SelectedIndexChanged"></eidss:DropDownList>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="ConcludedDate" HeaderText="<%$ Resources: Labels, Lbl_Result_Date_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upTestingResultDate" runat="server" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="txtTestingResultDate" EventName="TextChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblTestingResultDate" runat="server" Text='<% #Bind("ResultDate") %>'></asp:Label>
                                                                        <eidss:CalendarInput ID="txtTestingResultDate" runat="server" ContainerCssClass="input-group datepicker" Width="120" CssClass="form-control" OnTextChanged="TestingResultDate_TextChanged" />
                                                                        <asp:CompareValidator ID="cvFutureTestingResultDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtTestingResultDate" meta:resourcekey="Val_Future_Result_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Testing" SetFocusOnError="True"></asp:CompareValidator>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="TestCategoryTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Category_Text %>">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upTestingTestCategory" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlTestingTestCategoryType" EventName="SelectedIndexChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <div class="flex-container">
                                                                        <asp:Label ID="lblTestingTestCategoryTypeName" runat="server" Text='<% #Bind("TestCategoryTypeName") %>'></asp:Label>
                                                                        <eidss:DropDownList ID="ddlTestingTestCategoryType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="TestingTestCategoryType_SelectedIndexChanged"></eidss:DropDownList>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="AccessionDate" SortExpression="AccessionDate" HeaderText="<%$ Resources: Labels, Lbl_Accession_Date_Time_Text %>" />
                                                    <asp:TemplateField SortExpression="FunctionalAreaName" HeaderText="<%$ Resources: Labels, Lbl_Functional_Area_Text %>">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblTestingFunctionalAreaName" runat="server" Text='<% #Bind("FunctionalAreaName") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divTestingPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblTestingPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptTestingPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upTestingPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkTestingPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkTestingPage" runat="server" CssClass="btn btn-primary btn-sm" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="TestingPage_Changed" CausesValidation="False"></asp:LinkButton>
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
                    <div id="NavTransferred" class="tab-pane" role="tabpanel" aria-labelledby="NavTransferredTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upTransferredMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucTransferredMenu" runat="server" Tab="Transferred" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divTransferredDivider1" class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upTransferredButtons" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnCancelTransfer" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnPrintTransfer" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnCancelTransfer" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Cancel_Transfer" Height="35" CausesValidation="false" />
                                            <asp:LinkButton ID="btnPrintTransfer" runat="server" CssClass="btn btn-default btn-md" CausesValidation="false" Height="35">
                                                <span class="glyphicon glyphicon-print" aria-hidden="true"></span> <% =GetGlobalResourceObject("Labels", "Lbl_Print_Transfer_Form_Text") %>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="divTransferredDivider2" class="divider-panel">&nbsp;</div>
                                <div class="search-panel">
                                    <eidss:Search ID="ucTransferredSearch" runat="server" />
                                </div>
                                <div id="divTransferredDivider3" class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upTransferredSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnTransferredSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnTransferredSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" Enabled="false" Height="35" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upTransferredSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgTransferredQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgTransferredSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upTransferredColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnTransferredColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnTransferredColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upTransferred" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvTransferred" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvTransferred" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divTransferred">
                                            <eidss:GridView ID="gvTransferred" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="table lab-table-striped table-hover" DataKeyNames="TransferID,TestID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" runat="server" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="True" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnToggleAllTransferred" runat="server" CommandName="Toggle Select All" CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upToggleTransferred" runat="server" UpdateMode="Conditional">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="btnToggleTransferred" EventName="Click" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <asp:LinkButton ID="btnToggleTransferred" runat="server" CommandName="Toggle Select" CommandArgument='<%# Eval("TransferID").ToString() + "," + If(Eval("TestID") Is Nothing, "", Eval("TestID").ToString()) %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn" ShowHeader="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnTransferredEdit" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<%# Eval("TransferID").ToString() + "," + If(Eval("TestID") Is Nothing, "", Eval("TestID").ToString()) %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnHeaderTransferredSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="Select All Records My Favorite" CommandArgument='All' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgHeaderTransferredMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnTransferredSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="MyFavorite" CommandArgument='<% #Bind("TransferredOutSampleID") %>' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgTransferredMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" HeaderStyle-CssClass="eidssReportSessionStickyColumn" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                    <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" HeaderStyle-CssClass="patientFarmOwnerStickyColumn" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" SortExpression="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                    <asp:BoundField DataField="EIDSSTransferID" SortExpression="EIDSSTransferID" HeaderText="<%$ Resources: Labels, Lbl_Transfer_ID_Text %>" />
                                                    <asp:BoundField DataField="TransferredToOrganizationName" SortExpression="TransferredToOrganizationName" HeaderText="<%$ Resources: Labels, Lbl_Transferred_To_Text %>" />
                                                    <asp:BoundField DataField="TransferDate" SortExpression="TransferDate" HeaderText="<%$ Resources: Labels, Lbl_Transfer_Date_Text %>" DataFormatString="{0:d}" />
                                                    <asp:BoundField DataField="TestRequested" SortExpression="TestRequested" HeaderText="<%$ Resources: Labels, Lbl_Test_Requested_Text %>" />
                                                    <asp:BoundField DataField="TestNameTypeName" SortExpression="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                    <asp:TemplateField SortExpression="TestResultTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Result_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:UpdatePanel ID="upTransferredTestResultType" runat="server" RenderMode="Inline">
                                                                    <Triggers>
                                                                        <asp:AsyncPostBackTrigger ControlID="ddlTransferredTestResultType" EventName="SelectedIndexChanged" />
                                                                    </Triggers>
                                                                    <ContentTemplate>
                                                                        <asp:Panel ID="pnlTestResultType" runat="server">
                                                                            <eidss:DropDownList ID="ddlTransferredTestResultType" runat="server" CssClass="form-control" Height="33" AutoPostBack="true" OnSelectedIndexChanged="TransferredTestResultType_SelectedIndexChanged"></eidss:DropDownList>
                                                                        </asp:Panel>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="ResultDate" HeaderText="<%$ Resources: Labels, Lbl_Result_Date_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <eidss:CalendarInput ID="txtTransferredResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Width="120" UseCurrent="False" AutoPostBack="true" OnTextChanged="TransferredResultDate_TextChanged" />
                                                                <asp:CompareValidator ID="cvFutureTransferredResultDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtTransferredResultDate" meta:resourcekey="Val_Future_Result_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Transferred" SetFocusOnError="True"></asp:CompareValidator>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="ContactPersonName" HeaderText="<%$ Resources: Labels, Lbl_Point_Of_Contact_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:UpdatePanel ID="upTransferredPointOfContact" runat="server" RenderMode="Inline">
                                                                    <Triggers>
                                                                        <asp:AsyncPostBackTrigger ControlID="txtPointOfContact" EventName="TextChanged" />
                                                                    </Triggers>
                                                                    <ContentTemplate>
                                                                        <asp:TextBox ID="txtPointOfContact" runat="server" CssClass="form-control" Height="33" MaxLength="200" Text='<% #Bind("ContactPersonName") %>' Width="225" AutoPostBack="true" OnTextChanged="PointOfContact_TextChanged"></asp:TextBox>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSLocalFieldSampleID" SortExpression="EIDSSLocalFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>" />
                                                    <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:BoundField DataField="AccessionDate" SortExpression="AccessionDate" HeaderText="<%$ Resources: Labels, Lbl_Accession_Date_Time_Text %>" />
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblTransferredSampleStatusTypeName" runat="server" Text='<% #Bind("AccessionConditionOrSampleStatusTypeName") %>'></asp:Label>
                                                                <div class="divEmptyCommentContainer">
                                                                    <a href="#" id="lnkTransferredSampleStatusCommentEmpty" runat="server" data-placement="right" data-html="true">
                                                                        <div id="divTransferredEmptyCommentBox" class="commentBoxDefault">
                                                                            <div class="whiteCommentBox">
                                                                                <img class="imgWhiteCommentBox" src="../Includes/Images/commentBoxEmpty.png" />
                                                                            </div>
                                                                        </div>
                                                                    </a>
                                                                    <div id="divTransferredCommentBoxEmptyContainer" runat="server" class="hide">
                                                                        <asp:TextBox ID="txtTransferredCommentTextBoxEmpty" runat="server" CssClass="txtCommentTextBoxEmpty" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="divCommentContainer">
                                                                    <a href="#" id="lnkTransferredSampleStatusComment" runat="server" data-placement="right" data-html="true">
                                                                        <div id="divTransferredCommentBox" class="commentBoxDefault">
                                                                            <div class="blueCommentBox">
                                                                                <img class="imgBlueCommentBox" src="../Includes/Images/commentBoxNonEmpty.png" />
                                                                            </div>
                                                                        </div>
                                                                    </a>
                                                                    <div id="divTransferredCommentBoxContainer" runat="server" class="hide">
                                                                        <asp:TextBox ID="txtTransferredCommentTextBox" runat="server" CssClass="txtCommentTextBox" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divTransferredPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblTransferredPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptTransferredPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upTransferredPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkTransferredPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkTransferredPage" runat="server" CssClass="btn btn-primary btn-sm" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="TransferredPage_Changed" CausesValidation="False"></asp:LinkButton>
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
                    <div id="NavMyFavorites" class="tab-pane" role="tabpanel" aria-labelledby="NavMyFavoritesTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upMyFavoritesMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucMyFavoritesLaboratoryMenu" runat="server" Tab="Favorites" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divMyFavoritesDivider1" class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upMyFavoritesButtons" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <button id="btnMyFavoritesBatch" runat="server" class="btn btn-default" data-target="#divCreateBatchModal" data-toggle="modal"><% =GetGlobalResourceObject("Buttons", "Btn_Batch_Text") %></button>
                                            <asp:Button ID="btnMyFavoritesAssignTest" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Assign_Test_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Assign_Test_ToolTip %>" CausesValidation="false" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="search-panel">
                                    <eidss:Search ID="ucMyFavoritesSearch" runat="server" />
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upMyFavoritesSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnMyFavoritesSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnMyFavoritesSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" Enabled="false" Height="35" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upMyFavoritesSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgMyFavoritesQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgMyFavoritesSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upMyFavoritesColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnMyFavoritesColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnMyFavoritesColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upMyFavorites" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvMyFavorites" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvMyFavorites" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divMyFavorites">
                                            <eidss:GridView ID="gvMyFavorites" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="table lab-table-striped table-hover" DataKeyNames="SampleID" GridLines="None" runat="server" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnToggleAllMyFavorites" runat="server" CommandName="Toggle Select All" CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnToggleMyFavorites" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("SampleID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn" ShowHeader="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnMyFavoritesEdit" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnHeaderMyFavoritesSetMyFavorite" runat="server" CssClass="myFavorite" CommandName="Select All Records My Favorite" CommandArgument='All' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgHeaderMyFavoritesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/whiteStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnMyFavoritesSetMyFavorite" runat="server" CssClass="myFavorite" CommandName="MyFavorite" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false" Height="25" Width="17">
                                                                <asp:Image ID="imgMyFavoritesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/whiteStar.png" Height="11" Width="11" />
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" HeaderStyle-CssClass="eidssReportSessionStickyColumn" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                    <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" HeaderStyle-CssClass="patientFarmOwnerStickyColumn" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                    <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" SortExpression="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                    <asp:BoundField DataField="TestNameTypeName" SortExpression="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                    <asp:TemplateField SortExpression="TestStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Status_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblMyFavoritesTestStatusTypeName" runat="server" Text='<% #Bind("TestStatusTypeName") %>'></asp:Label>
                                                                <eidss:DropDownList ID="ddlMyFavoritesTestStatusType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="StartedDate" HeaderText="<%$ Resources: Labels, Lbl_Test_Started_Date_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblMyFavoritesTestStartedDate" runat="server" Text='<% #Bind("StartedDate") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="TestResultTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Result_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <eidss:DropDownList ID="ddlMyFavoritesTestResultType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="ResultDate" HeaderText="<%$ Resources: Labels, Lbl_Result_Date_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblMyFavoritesResultDate" runat="server" Text='<% #Bind("ResultDate") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField SortExpression="TestCategoryTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Category_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <eidss:DropDownList ID="ddlMyFavoritesTestCategoryType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="AccessionDate" SortExpression="AccessionDate" HeaderText="<%$ Resources: Labels, Lbl_Accession_Date_Time_Text %>" />
                                                    <asp:TemplateField SortExpression="FunctionalAreaName" HeaderText="<%$ Resources: Labels, Lbl_Functional_Area_Text %>">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblMyFavoritesFunctionalAreaName" runat="server" Text='<% #Bind("FunctionalAreaName") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblMyFavoritesSampleStatusTypeName" runat="server" Text='<% #Bind("AccessionConditionOrSampleStatusTypeName") %>'></asp:Label>
                                                                <div class="divEmptyCommentContainer">
                                                                    <a href="#" id="lnkMyFavoritesSampleStatusCommentEmpty" runat="server" data-placement="right" data-html="true">
                                                                        <div id="divMyFavoritesEmptyCommentBox" class="commentBoxDefault">
                                                                            <div class="whiteCommentBox">
                                                                                <img class="imgWhiteCommentBox" src="../Includes/Images/commentBoxEmpty.png" />
                                                                            </div>
                                                                        </div>
                                                                    </a>
                                                                    <div id="divMyFavoritesCommentBoxEmptyContainer" runat="server" class="hide">
                                                                        <asp:TextBox ID="txtMyFavoritesCommentTextBoxEmpty" runat="server" CssClass="txtCommentTextBoxEmpty" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="divCommentContainer">
                                                                    <a href="#" id="lnkMyFavoritesSampleStatusComment" runat="server" data-placement="right" data-html="true">
                                                                        <div id="divMyFavoritesCommentBox" class="commentBoxDefault">
                                                                            <div class="blueCommentBox">
                                                                                <img class="imgBlueCommentBox" src="../Includes/Images/commentBoxNonEmpty.png" />
                                                                            </div>
                                                                        </div>
                                                                    </a>
                                                                    <div id="divMyFavoritesCommentBoxContainer" runat="server" class="hide">
                                                                        <asp:TextBox ID="txtMyFavoritesCommentTextBox" runat="server" CssClass="txtCommentTextBox" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="EIDSSAnimalID" SortExpression="EIDSSAnimalID" HeaderText="<%$ Resources: Labels, Lbl_Animal_ID_Text %>" />
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divMyFavoritesPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblMyFavoritesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptMyFavoritesPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upMyFavoritesPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkMyFavoritesPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkMyFavoritesPage" runat="server" CssClass="btn btn-primary btn-sm" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="MyFavoritesPage_Changed" CausesValidation="False"></asp:LinkButton>
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
                    <div id="NavBatches" class="tab-pane" role="tabpanel" aria-labelledby="NavBatchesTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upBatchesMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucBatchesMenu" runat="server" Tab="Batches" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div id="divBatchesCommand" class="lab-command-panel">
                                    <asp:UpdatePanel ID="upBatchesButtons" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="ddlAddGroupResultTestResultType" EventName="SelectedIndexChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="btnBatchesRemoveSample" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnCloseBatch" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnBatchesRemoveSample" runat="server" Text="Remove Sample" CssClass="btn btn-default" Height="35" CausesValidation="false" />
                                            <button type="button" id="btnAddGroupResult" runat="server" data-toggle="popover" class="btn popup-window" data-placement="right"><% =GetGlobalResourceObject("Labels", "Lbl_Add_Group_Result_Text") %></button>
                                            <div id="divAddGroupResultContainer" class="popup-content hide">
                                                <div class="">
                                                    <asp:DropDownList ID="ddlAddGroupResultTestResultType" runat="server" CssClass="form-control" AutoPostBack="true" Width="200"></asp:DropDownList>
                                                    <br />
                                                </div>
                                            </div>
                                            <asp:Button ID="btnCloseBatch" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Close_Batch_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <asp:UpdatePanel ID="upBatchesSearch" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div id="divBatchesSearch" class="search-panel">
                                            <eidss:Search ID="ucBatchesSearch" runat="server" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upBatchesSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnBatchesSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnBatchesSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" Enabled="false" Height="35" CausesValidation="false" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upBatchesSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgBatchesQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgBatchesSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upBatchesColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnBatchesColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnBatchesColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upBatches" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvBatches" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvBatches" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divBatches">
                                            <eidss:GridView ID="gvBatches" runat="server" AutoGenerateColumns="false" CssClass="table lab-table-striped batch-test" GridLines="None" DataKeyNames="BatchTestID">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="100%">
                                                        <HeaderTemplate>
                                                            <div id="divBatchesHeader">
                                                                <span class="commandStickyColumn">
                                                                    <asp:LinkButton ID="btnToggleAllBatches" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("BatchTestID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                </span>
                                                                <span class="commandStickyColumn">&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                                                <span class="commandStickyColumn">
                                                                    <asp:LinkButton ID="btnBatchesHeaderMyFavoritesSetMyFavorite" runat="server" CssClass="myFavorite" CommandName="Select All Records My Favorite" CommandArgument='All' CausesValidation="false" Height="25" Width="17">
                                                                        <asp:Image ID="imgBatchesHeaderMyFavoritesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/whiteStar.png" Height="11" Width="11" />
                                                                    </asp:LinkButton>
                                                                </span>
                                                                <span class="eidssReportSessionStickyColumnBatchTest"><%= GetGlobalResourceObject("Labels", "Lbl_Report_Session_ID_Text") %></span>
                                                                <span class="patientFarmOwnerStickyColumnBatchTest"><%= GetGlobalResourceObject("Labels", "Lbl_Patient_Farm_Owner_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></span>
                                                                <span class="gridViewColumn150Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Lab_Sample_ID_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Name_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Status_Text") %></span>
                                                                <span class="gridViewColumn150Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Started_Date_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Result_Text") %></span>
                                                                <span class="gridViewColumn150Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Result_Date_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Category_Text") %></span>
                                                                <span class="gridViewColumn150Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Accession_Date_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Functional_Area_Text") %></span>
                                                                <span class="gridViewColumn225Heading"><%= GetGlobalResourceObject("Labels", "Lbl_Sample_Status_Text") %></span>
                                                            </div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <div id="divBatchAccordion" class="batch-test-accordion-wrapper" runat="server">
                                                                    <div class="commandStickyColumn">
                                                                        <span style="padding-left: 7px; width: 30px; margin-right: 0px; margin-bottom: 0px;">
                                                                            <asp:LinkButton ID="btnToggleBatch" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("BatchTestID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                        </span>
                                                                    </div>
                                                                    <div id="divBatchTestAccordion" runat="server" class="batch-test-panel-group" role="tablist" aria-multiselectable="true">
                                                                        <div id="divBatchTestDetailsAccordionPanel" runat="server" class="panel panel-default">
                                                                            <div id="divBatchTestHeading" runat="server" class="panel-heading row batch-test-heading" role="tab">
                                                                                <div class="accordion-col">
                                                                                    <span class="panel-title"><a id="lnkBatchTestAccordion" href="#" runat="server" class="batch-accordion-toggle" data-toggle="collapse" role="button" aria-expanded="true"></a><%= GetGlobalResourceObject("Labels", "Lbl_Batch_ID_Text") %>:&nbsp;&nbsp;<label id="lblEditBatch" class="batchTestButton" runat="server"><%# Eval("EIDSSBatchTestID") %></label>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<asp:Label ID="lblBatchStatusTypeName" runat="server" Text='<% #Bind("BatchStatusTypeName") %>'></asp:Label></span>
                                                                                </div>
                                                                            </div>
                                                                            <div id="divBatchTestDetails" runat="server" class="panel-collapse collapse in" role="tabpanel">
                                                                                <div class="batch-test-panel-body">
                                                                                    <div id="divBatchTests" runat="server">
                                                                                        <eidss:GridView ID="gvBatchTests" OnRowCommand="BatchTests_RowCommand" OnRowDataBound="BatchTests_RowDataBound" AllowPaging="True" AllowSorting="True" EmptyDataRowStyle-Width="100%" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="lab-table-striped batch-test" DataKeyNames="TestID" GridLines="None" runat="server" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="false" ShowHeaderWhenEmpty="false" PagerSettings-Visible="false">
                                                                                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                                            <Columns>
                                                                                                <asp:TemplateField ItemStyle-CssClass="commandStickyColumn">
                                                                                                    <ItemTemplate>
                                                                                                        <div style="padding-left: 7px;">
                                                                                                            <asp:LinkButton ID="btnToggleBatchTest" runat="server" CommandName="Toggle Select" CommandArgument='<%# Eval("BatchTestID").ToString() + "," + Eval("TestID").ToString() %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField ItemStyle-CssClass="commandStickyColumn" ShowHeader="false">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:LinkButton ID="btnBatchTestsEdit" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<%# Eval("TestID").ToString() + "," + Eval("BatchTestID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField ItemStyle-CssClass="commandStickyColumn">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:LinkButton ID="btnBatchesSetMyFavorite" runat="server" CssClass="myFavoriteNo" CommandName="MyFavorite" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false" Height="25" Width="17">
                                                                                                            <asp:Image ID="imgBatchesMyFavoriteStar" runat="server" CssClass="myFavoriteStar" ImageUrl="~/Includes/Images/blueStar.png" Height="11" Width="11" />
                                                                                                        </asp:LinkButton>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                                                                <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                                                                <asp:TemplateField SortExpression="SampleTypeName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesSampleTypeName" runat="server" Text='<% #Bind("SampleTypeName") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="DiseaseName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesDiseaseName" runat="server" Text='<% #Bind("DiseaseName") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="EIDSSLaboratorySampleID">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn150">
                                                                                                            <asp:Label ID="lblBatchesEIDSSLaboratorySampleID" runat="server" Text='<% #Bind("EIDSSLaboratorySampleID") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="TestNameTypeName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesTestNameTypeName" runat="server" Text='<% #Bind("TestNameTypeName") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="TestStatusTypeName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesTestStatusTypeName" runat="server" Text='<% #Bind("TestStatusTypeName") %>'></asp:Label>
                                                                                                            <eidss:DropDownList ID="ddlBatchesTestStatusType" runat="server" CssClass="form-control" Width="215" AutoPostBack="true" OnSelectedIndexChanged="BatchesTestStatusType_SelectedIndexChanged"></eidss:DropDownList>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="StartedDate">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn150">
                                                                                                            <asp:Label ID="lblBatchesStartedDate" runat="server"></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="TestResultTypeName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesTestResultTypeName" runat="server" Text='<% #Bind("TestResultTypeName") %>'></asp:Label>
                                                                                                            <eidss:DropDownList ID="ddlBatchesTestResultType" runat="server" CssClass="form-control" Width="215" AutoPostBack="true" OnSelectedIndexChanged="BatchesTestResultType_SelectedIndexChanged"></eidss:DropDownList>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="ResultDate">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn150">
                                                                                                            <asp:Label ID="lblBatchesResultDate" runat="server"></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="TestCategoryTypeName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesTestCategoryTypeName" runat="server" Text='<% #Bind("TestCategoryTypeName") %>'></asp:Label>
                                                                                                            <eidss:DropDownList ID="ddlBatchesTestCategoryType" runat="server" CssClass="form-control" Width="215" AutoPostBack="true" OnSelectedIndexChanged="BatchesTestCategoryType_SelectedIndexChanged"></eidss:DropDownList>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="AccessionDate">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn150">
                                                                                                            <asp:Label ID="lblBatchesAccessionDate" runat="server" Text='<% #Bind("AccessionDate") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField SortExpression="FunctionalAreaName">
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <asp:Label ID="lblBatchesFunctionalAreaName" runat="server" Text='<% #Bind("FunctionalAreaName") %>'></asp:Label>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                                <asp:TemplateField>
                                                                                                    <ItemTemplate>
                                                                                                        <div class="flex-container gridViewColumn225">
                                                                                                            <div class="flex-container">
                                                                                                                <asp:Label ID="lblBatchesSampleStatusTypeName" runat="server" Text='<% #Bind("AccessionConditionOrSampleStatusTypeName") %>'></asp:Label>
                                                                                                                <div class="divEmptyCommentContainer">
                                                                                                                    <a href="#" id="lnkBatchesSampleStatusCommentEmpty" runat="server" data-placement="right" data-html="true">
                                                                                                                        <div id="divBatchesEmptyCommentBox" class="commentBoxDefault">
                                                                                                                            <div class="whiteCommentBox">
                                                                                                                                <img class="imgWhiteCommentBox" src="../Includes/Images/commentBoxEmpty.png" />
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </a>
                                                                                                                    <div id="divBatchesCommentBoxEmptyContainer" runat="server" class="hide">
                                                                                                                        <asp:TextBox ID="txtBatchesCommentTextBoxEmpty" runat="server" CssClass="txtCommentTextBoxEmpty" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                                                                                                    </div>
                                                                                                                </div>
                                                                                                                <div class="divCommentContainer">
                                                                                                                    <a href="#" id="lnkBatchesSampleStatusComment" runat="server" data-placement="right" data-html="true">
                                                                                                                        <div id="divBatchesCommentBox" class="commentBoxDefault">
                                                                                                                            <div class="blueCommentBox">
                                                                                                                                <img class="imgBlueCommentBox" src="../Includes/Images/commentBoxNonEmpty.png" />
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </a>
                                                                                                                    <div id="divBatchesCommentBoxContainer" runat="server" class="hide">
                                                                                                                                <asp:TextBox ID="txtBatchesCommentTextBox" runat="server" CssClass="txtCommentTextBox" TextMode="MultiLine" Enabled="false" Text='<% #Bind("AccessionComment") %>'></asp:TextBox>
                                                                                                                    </div>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateField>
                                                                                            </Columns>
                                                                                        </eidss:GridView>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divBatchesPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblBatchesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptBatchesPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upBatchesPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkBatchesPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkBatchesPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="BatchesPage_Changed" Height="20"></asp:LinkButton>
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
                    <div id="NavApprovals" class="tab-pane" role="tabpanel" aria-labelledby="NavApprovalsTab" runat="server">
                        <div class="row">
                            <div class="flex-container">
                                <div class="menu-panel">
                                    <div class="dropdown">
                                        <asp:UpdatePanel ID="upApprovalsMenu" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:Menu ID="ucApprovalsMenu" runat="server" Tab="Approvals" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upApprovalsButtons" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnApprove" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnReject" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-default" Height="35" CausesValidation="False" />
                                            <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-default" Height="35" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="search-panel">
                                    <eidss:Search ID="ucApprovalsSearch" runat="server" />
                                </div>
                                <div class="divider-panel">&nbsp;</div>
                                <div class="lab-command-panel">
                                    <asp:UpdatePanel ID="upApprovalsSave" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnApprovalsSave" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Button ID="btnApprovalsSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" Enabled="false" Height="35" CausesValidation="False" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <asp:UpdatePanel ID="upApprovalsSearchResults" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="samples-search-results-panel">
                                            <h3 id="hdgApprovalsQueryText" runat="server" class="searchResultsHeading" style="font-style: italic; float: left;"></h3>
                                            &nbsp;&nbsp;<h3 id="hdgApprovalsSearchResults" runat="server" class="searchResultsHeading" style="float: right;" meta:resourcekey="Hdg_Search_Results"></h3>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="columnChooserPanel">
                                    <asp:UpdatePanel ID="upApprovalsColumnChooser" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnApprovalsColumnChooser" EventName="Click" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnApprovalsColumnChooser" runat="server" CssClass="btn columnChooser" CausesValidation="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:UpdatePanel runat="server" ID="upApprovals" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvApprovals" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvApprovals" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <div id="divApprovals">
                                            <eidss:GridView ID="gvApprovals" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="table lab-table-striped table-hover" DataKeyNames="SampleID,TestID" GridLines="None" runat="server" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="True" PagerSettings-Visible="false">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                <Columns>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn">
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnToggleAllApprovals" runat="server" CommandName="Toggle Select All" CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnToggleApprovals" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("SampleID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderStyle-CssClass="commandStickyColumn" ItemStyle-CssClass="commandStickyColumn" ShowHeader="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnApprovalsEditSample" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ActionRequested" SortExpression="ActionRequested" HeaderText="<%$ Resources: Labels, Lbl_Action_Requested_Text %>" HeaderStyle-CssClass="actionRequestedStickyColumn" ItemStyle-CssClass="actionRequestedStickyColumn" />
                                                    <asp:BoundField DataField="EIDSSReportSessionID" SortExpression="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" HeaderStyle-CssClass="eidssReportSessionStickyColumn" ItemStyle-CssClass="eidssReportSessionStickyColumn" />
                                                    <asp:BoundField DataField="PatientFarmOwnerName" SortExpression="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" HeaderStyle-CssClass="patientFarmOwnerStickyColumn" ItemStyle-CssClass="patientFarmOwnerStickyColumn" />
                                                    <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                                    <asp:BoundField DataField="DiseaseName" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" SortExpression="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                                    <asp:BoundField DataField="AccessionConditionOrSampleStatusTypeName" SortExpression="AccessionConditionOrSampleStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Status_Text %>" />
                                                    <asp:BoundField DataField="TestNameTypeName" SortExpression="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                                    <asp:BoundField DataField="TestStatusTypeName" SortExpression="TestStatusTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Status_Text %>" />
                                                    <asp:BoundField DataField="TestResultTypeName" SortExpression="TestResultTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Result_Text %>" />
                                                    <asp:TemplateField SortExpression="ResultDate" HeaderText="<%$ Resources: Labels, Lbl_Result_Date_Text %>">
                                                        <ItemTemplate>
                                                            <div class="flex-container">
                                                                <asp:Label ID="lblApprovalsResultDate" runat="server" Text='<% #Bind("ResultDate") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="AccessionDate" HeaderText="<%$ Resources: Labels, Lbl_Accession_Date_Time_Text %>" />
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                    <div id="divApprovalsPager" class="row" runat="server">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblApprovalsPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                            <asp:Repeater ID="rptApprovalsPager" runat="server">
                                                <ItemTemplate>
                                                    <asp:UpdatePanel ID="upApprovalsPager" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                        <Triggers>
                                                            <asp:AsyncPostBackTrigger ControlID="lnkApprovalsPage" EventName="Click" />
                                                        </Triggers>
                                                        <ContentTemplate>
                                                            <asp:LinkButton ID="lnkApprovalsPage" runat="server" CssClass="btn btn-primary btn-sm" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="ApprovalsPage_Changed" CausesValidation="False"></asp:LinkButton>
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
            </div>
        </div>
    </div>
    <div id="divGroupAccessionInModal" class="modal container fade" tabindex="-1" data-focus-on="txtEIDSSLocalFieldSampleID" role="dialog" aria-labelledby="divGroupAccessionInModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divGroupAccessionInModal');">&times;</button>
                <h4 id="hdgGroupInAccessionIn" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Group_Accession_In_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:GroupAccessionIn ID="ucGroupAccessionIn" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upGroupAccessionInControls" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnGroupAccessionInSelectSamplesSelect" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="chkGroupAccessionInPrintBarCode" EventName="CheckedChanged" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:CheckBox ID="chkGroupAccessionInPrintBarCode" runat="server" AutoPostBack="true" />&nbsp;<asp:Label ID="lblGroupAccessionInPrintBarCodeIndicator" runat="server" meta:resourceKey="Lbl_Print_Barcode_Question"></asp:Label>
                        <button id="btnGroupAccessionInCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" onclick="hideModal('#divGroupAccessionInModal');" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                        <asp:Button ID="btnGroupAccessionInAccession" runat="server" CssClass="btn btn-primary" Enabled="false" Text="<%$ Resources: Buttons, Btn_Accession_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Accession_ToolTip %>" ValidationGroup="GroupAccessionIn" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divGroupAccessionInSelectSamplesModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divGroupAccessionInSelectSamplesModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divGroupAccessionInSelectSamplesModal')">&times;</button>
                <h4 id="hdgSelectSamples" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Group_Accession_In_Select_Samples_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <p><% =GetGlobalResourceObject("Labels", "Lbl_Multiple_Samples_To_Accession_Text") %></p>

                <asp:UpdatePanel ID="upGroupAccessionInSelectSamples" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="gvGroupAccessionInSelectSamples" EventName="RowCommand" />
                        <asp:AsyncPostBackTrigger ControlID="gvGroupAccessionInSelectSamples" EventName="RowDataBound" />
                    </Triggers>
                    <ContentTemplate>
                        <div class="table-responsive">
                            <eidss:GridView ID="gvGroupAccessionInSelectSamples" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" AllowSorting="false" DataKeyNames="SampleID" GridLines="None" AllowPaging="true" PagerSettings-Visible="false">
                                <HeaderStyle CssClass="table-striped-header" />
                                <FooterStyle HorizontalAlign="Right" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:UpdatePanel ID="upGroupAccessionInSelectSamplesSelection" runat="server" UpdateMode="Conditional">
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnGroupAccessionInSample" EventName="Click" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <asp:LinkButton ID="btnGroupAccessionInSample" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("SampleID") %>' CssClass="btn glyphicon glyphicon-unchecked" CausesValidation="false" OnClientClick="showGroupAccessionInSelectSamplesLoading();"></asp:LinkButton>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                    <asp:BoundField DataField="CollectionDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources: Labels, Lbl_Collection_Date_Text %>" />
                                    <asp:BoundField DataField="EIDSSReportSessionID" HeaderText="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" />
                                    <asp:BoundField DataField="SentToOrganizationName" HeaderText="<%$ Resources: Labels, Lbl_Sent_To_Organization_Text %>" />
                                    <asp:BoundField DataField="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" />
                                </Columns>
                            </eidss:GridView>
                        </div>
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblGroupAccessionInSelectSamplesPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                <asp:HiddenField ID="hdfGroupAccessionInSelectSamplesCount" runat="server" Value="0" />
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                <asp:Repeater ID="rptGroupAccessionInSelectSamples" runat="server">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkGroupAccessionInSelectSamplesPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="GroupAccessionInSelectSamplesPage_Changed" Height="20"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upGroupAccessionInSelectSamplesControls" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnGroupAccessionInSelectSamplesSelect" EventName="Click" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Button ID="btnGroupAccessionInSelectSamplesSelect" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Select_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Select_ToolTip %>" ValidationGroup="GroupAccessionIn" data-loading-text="..." />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divAssignTestModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divAssignTestModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" aria-hidden="true" onclick="hideModal('#divAssignTestModal');">&times;</button>
                <h4 id="hdgAssignTest" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Assign_Test_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:AssignTest ID="ucAssignTest" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upAssignTestCommands" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="pnlAssignTestForm" runat="server" DefaultButton="btnAssignTestSave">
                            <asp:Button ID="btnCancelAssignTest" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnAssignTestSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Assign_Test_ToolTip %>" CausesValidation="false" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divRegisterNewSampleModal" class="modal container fade" tabindex="-1" data-backdrop="static" role="dialog" aria-labelledby="divRegisterNewSampleModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" aria-hidden="true" onclick="hideModal('#divRegisterNewSampleModal');">&times;</button>
                <h4 id="hdgRegisterNewSample" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Register_New_Sample_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:RegisterNewSample ID="ucRegisterNewSample" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upRegisterNewSampleCommands" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddSample" EventName="Click" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Panel ID="pnlRegisterNewSampleForm" runat="server" DefaultButton="btnAddSample">
                            <asp:Button ID="btnCancelRegisterNewSampleModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnAddSample" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" ValidationGroup="RegisterNewSample" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divCreateAliquotDerivativeModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divCreateAliquotDerivativeModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divCreateAliquotDerivativeModal')">&times;</button>
                <h4 id="hdgAliquotsDerivatives" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Aliqouts_Derivatives_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:AliquotsDerivatives ID="ucCreateAliquotDerivative" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upCreateAliquotDerivativeCommands" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="chkAliquotDerivativePrintBarcodes" EventName="CheckedChanged" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Panel ID="pnlCreateAliquotDerivativeForm" runat="server" DefaultButton="btnCreateAliquotDerivativeSave">
                            <asp:CheckBox ID="chkAliquotDerivativePrintBarcodes" runat="server" AutoPostBack="true" CssClass="form-check-input" />&nbsp;<label for="<%= chkAliquotDerivativePrintBarcodes.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Print_Barcode_Text") %></label>
                            <asp:Button ID="btnCancelCreateAliquotDerivativeModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnCreateAliquotDerivativeSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" ValidationGroup="CreateAliquotDerivative" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divAddUpdateBatchTestModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divAddUpdateBatchTestModal">
        <asp:UpdatePanel ID="upAddUpdateBatch" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAddUpdateBatchTestModal')">&times;</button>
                        <h4 id="hdgAddUpdateBatchTest" class="modal-title" runat="server"></h4>
                    </div>
                    <div class="modal-body modal-wrapper">
                        <eidss:AddUpdateBatch ID="ucAddUpdateBatchTest" runat="server" />
                    </div>
                    <div class="modal-footer text-center">
                        <asp:Panel ID="pnlAddUpdateBatchTestForm" runat="server" DefaultButton="btnAddUpdateBatchTestBatch">
                            <asp:Button ID="btnCancelAddUpdateBatchTest" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnAddUpdateBatchTestBatch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Batch_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Batch_ToolTip %>" ValidationGroup="AddUpdateBatchTest" />
                            <asp:Button ID="btnSaveAddUpdateBatchTest" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" ValidationGroup="AddUpdateBatchTest" />
                        </asp:Panel>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divBatchSelectSamplesModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divBatchSelectSamplesModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divBatchSelectSamplesModal')">&times;</button>
                <h4 id="hdgBatchSelectSamples" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Batch_Add_Sample_Select_Samples_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upBatchSelectSamples" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="gvBatchSelectSamples" EventName="RowCommand" />
                        <asp:AsyncPostBackTrigger ControlID="gvBatchSelectSamples" EventName="RowDataBound" />
                    </Triggers>
                    <ContentTemplate>
                        <div class="table-responsive">
                            <eidss:GridView ID="gvBatchSelectSamples" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" AllowSorting="false" DataKeyNames="TestID" GridLines="None" AllowPaging="true" PagerSettings-Visible="false">
                                <HeaderStyle CssClass="table-striped-header" />
                                <FooterStyle HorizontalAlign="Right" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:UpdatePanel ID="upBatchSelectSamplesSelection" runat="server" UpdateMode="Conditional">
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnBatchSample" EventName="Click" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <asp:LinkButton ID="btnBatchSample" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("TestID") %>' CssClass="btn glyphicon glyphicon-unchecked" CausesValidation="false" OnClientClick="showBatchSelectSamplesLoading();"></asp:LinkButton>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                    <asp:BoundField DataField="EIDSSLocalFieldSampleID" HeaderText="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>" />
                                    <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                    <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Labels, Lbl_Test_Name_Text %>" />
                                    <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                </Columns>
                            </eidss:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upBatchSelectSamplesControls" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnBatchSelectSamplesAdd" EventName="Click" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Button ID="btnBatchSelectSamplesAdd" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" data-loading-text="..." CausesValidation="false" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSampleTestDetailsModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSampleTestDetailsModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSampleTestDetailsModal');">&times;</button>
                <h4 id="hdgSampleTestDetails" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Sample_Test_Details_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upSampleTestTransferDetailsAccordion" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div id="divSampleTestDetailsAccordion" runat="server" class="accordion-wrapper center-block">
                            <div id="accordion" class="panel-group" role="tablist" aria-multiselectable="true">
                                <div id="divSampleDetailsAccordionPanel" class="panel panel-default">
                                    <div id="divSampleDetailsHeading" class="panel-heading row" role="tab">
                                        <div class="col-xs-11 accordion-col">
                                            <h4 class="panel-title"><a href="#divSampleDetails" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" role="button" aria-expanded="true" aria-controls="divSampleDetails">Sample Details</a></h4>
                                        </div>
                                        <div class="col-xs-1 accordion-col-shrink">
                                            <asp:UpdatePanel ID="upSampleDetailsForm" runat="server" UpdateMode="Conditional">
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnShowSampleDetailsForm" EventName="Click" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <asp:ImageButton ID="btnShowSampleDetailsForm" runat="server" CssClass="btn accordion-print-icon text-right" ImageUrl="~/Includes/Images/printIcon.png" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                    <div id="divSampleDetails" class="panel-collapse collapse" role="tabpanel" aria-labelledby="divSampleDetailsHeading">
                                        <div class="panel-body">
                                            <asp:UpdatePanel ID="upAccordionAddUpdateSample" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <eidss:AddUpdateSample ID="ucAddUpdateSample" runat="server" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                </div>
                                <div id="divTestDetailsAccordionPanel" runat="server" class="panel panel-default">
                                    <div id="divTestDetailsHeading" class="panel-heading row" role="tab">
                                        <div class="col-xs-11 accordion-col">
                                            <h4 class="panel-title"><a href="#divTestDetails" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" role="button" aria-expanded="true" aria-controls="divTestDetails">Test Details</a></h4>
                                        </div>
                                        <div class="col-xs-1 accordion-col-shrink">
                                            <div class="accordion-print-icon">
                                                <asp:UpdatePanel ID="upShowTestDetailsForm" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnShowTestDetailsForm" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <asp:ImageButton ID="btnShowTestDetailsForm" runat="server" CssClass="btn accordion-print-icon text-right" ImageUrl="~/Includes/Images/printIcon.png" CausesValidation="False" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divTestDetails" class="panel-collapse collapse" role="tabpanel" aria-labelledby="divTestDetailsHeading">
                                        <div class="panel-body">
                                            <asp:UpdatePanel ID="upAccordionAddUpdateTest" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <eidss:AddUpdateTest ID="ucAddUpdateTest" runat="server" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                </div>
                                <div id="divAdditionalTestDetailsAccordionPanel" runat="server" class="panel panel-default">
                                    <div id="divAdditionalTestDetailsHeading" class="panel-heading row" role="tab">
                                        <div class="col-xs-12 accordion-col">
                                            <h4 class="panel-title"><a href="#divAdditionalTestDetails" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" role="button" aria-expanded="true" aria-controls="divAdditionalTestDetails">Additional Test Details</a></h4>
                                        </div>
                                    </div>
                                    <div id="divAdditionalTestDetails" class="panel-collapse collapse" role="tabpanel" aria-labelledby="divAdditionalTestDetailsHeading">
                                        <asp:UpdatePanel ID="upAdditionalTestDetails" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:AdditionalTestDetails ID="ucAdditionalTestDetails" runat="server" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divAmendmentHistoryAccordionPanel" runat="server" class="panel panel-default">
                                    <div id="divAmendmentHistoryHeading" class="panel-heading row" role="tab">
                                        <div class="col-xs-12 accordion-col">
                                            <h4 class="panel-title"><a href="#divAmendmentHistory" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" role="button" aria-expanded="true" aria-controls="divAmendmentHistory">Amendment History</a></h4>
                                        </div>
                                    </div>
                                    <div id="divAmendmentHistory" class="panel-collapse collapse" role="tabpanel" aria-labelledby="divAmendmentHistoryHeading">
                                        <asp:UpdatePanel ID="upAmendmentHistory" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:AmendmentHistory ID="ucAmendmentHistory" runat="server" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div id="divTransferDetailsAccordionPanel" runat="server" class="panel panel-default">
                                    <div id="divTransferDetailsHeading" class="panel-heading row" role="tab">
                                        <div class="col-xs-11 accordion-col">
                                            <h4 class="panel-title"><a href="#divTransferDetails" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" role="button" aria-expanded="true" aria-controls="divTransferDetails">Transfer Details</a></h4>
                                        </div>
                                        <div class="col-xs-1 accordion-col-shrink">
                                            <div class="accordion-print-icon">
                                                <asp:UpdatePanel ID="upShowTransferDetailsForm" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnShowTransferDetailsForm" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <asp:ImageButton ID="btnShowTransferDetailsForm" runat="server" CssClass="btn accordion-print-icon text-right" ImageUrl="~/Includes/Images/printIcon.png" CausesValidation="False" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divTransferDetails" class="panel-collapse collapse" role="tabpanel" aria-labelledby="divTransferDetailsHeading">
                                        <asp:UpdatePanel ID="upTransferDetails" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <eidss:TransferSample ID="ucTransferSampleForSampleTestDetails" runat="server" ClientIDMode="Predictable" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upSampleTestDetailsModalCommands" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnSampleTestDetailsSave" EventName="Click" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSampleTestDetailsSave">
                            <asp:Button ID="btnCancelSampleTestDetailsModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnSampleTestDetailsSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" ValidationGroup="EditSampleTestDetails" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divTransferSampleModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divTransferSampleModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTransferSampleModal');">&times;</button>
                <h4 id="hdgTransferSample" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Transfer_Sample_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:TransferSample ID="ucTransferSample" runat="server" ValidationGroup="TransferOut" ClientIDMode="Predictable" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upTransferSampleCommands" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="chkTransferPrintBarcodes" EventName="CheckedChanged" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Panel ID="pnlTransferSampleForm" runat="server" DefaultButton="btnTransfer">
                            <asp:CheckBox ID="chkTransferPrintBarcodes" runat="server" AutoPostBack="true" CssClass="form-check-input" />
                            <label for="<%= chkTransferPrintBarcodes.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Print_Barcode_Text") %></label>
                            <asp:Button ID="btnCancelTransferModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnTransfer" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Transfer_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Transfer_ToolTip %>" ValidationGroup="TransferOut" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSearchPersonModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchPersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchPersonModal')">&times;</button>
                <h4 id="hdgSearchPerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchPerson ID="ucSearchPerson" runat="server" RecordMode="Select" />
            </div>
        </div>
    </div>
    <div id="divAddUpdatePersonModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divAddUpdatePersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAddUpdatePersonModal')">&times;</button>
                <h4 id="hdgAddUpdatePerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Add_Update_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upAddUpdatePerson" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <eidss:AddUpdatePerson ID="ucAddUpdatePerson" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSearchVeterinaryDiseaseReportModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchVeterinaryDiseaseReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchVeterinaryDiseaseReportModal')">&times;</button>
                <h4 id="hdgSearchVeterinaryDiseaseReports" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Veterinary_Disease_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchVeterinaryDiseaseReport ID="ucSearchVeterinaryDiseaseReport" runat="server" />
            </div>
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
    <div id="divSearchHumanDiseaseReportModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchHumanDiseaseReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchHumanDiseaseReportModal')">&times;</button>
                <h4 id="hdgSearchHumanDiseaseReports" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Human_Disease_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchHumanDiseaseReport ID="ucSearchHumanDiseaseReport" runat="server" />
            </div>
        </div>
    </div>
    <div id="divSearchHumanSessionModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchHumanSessionModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModalOnModal('#divSearchHumanSessionModal')">&times;</button>
                <h4 id="hdgSearchHumanMonitoringSessions" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Human_Monitoring_Session_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchHumanSession ID="ucSearchHumanSession" runat="server" />
            </div>
        </div>
    </div>
    <div id="divSearchVectorSessionModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchVectorSessionModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchVectorSessionModal')">&times;</button>
                <h4 id="hdgSearchVectorSurveillanceSessions" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Vector_Surveillance_Session_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchVectorSession ID="ucSearchVectorSession" runat="server" />
            </div>
        </div>
    </div>
    <div id="divSearchSampleModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchSampleModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchSampleModal')">&times;</button>
                <h4 id="hdgAdvancedSearch" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Advanced_Search_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchSample ID="ucSearchSample" runat="server" />
            </div>
        </div>
    </div>
    <div id="divDeleteSampleModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" data-backdrop="static" role="dialog" aria-labelledby="divDeleteSampleModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divDeleteSampleModal');">&times;</button>
                <h4 id="hdgDeleteSample" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Delete_Sample_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upDeleteSample" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <eidss:GridView ID="gvDeleteSamples" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" AllowPaging="false" AllowSorting="false" GridLines="None">
                                <HeaderStyle CssClass="table-striped-header" />
                                <Columns>
                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                    <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                    <asp:BoundField DataField="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" />
                                </Columns>
                            </eidss:GridView>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                <asp:Label ID="lblDeleteSampleReasonForDeletion" runat="server" Text="<%$ Resources: Labels, Lbl_Reason_For_Deletion_Text %>"></asp:Label>
                            </div>
                            <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                <asp:TextBox ID="txtDeleteSampleReasonForDeletion" runat="server" CssClass="form-control" MaxLength="500"></asp:TextBox>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer text-center">
                <asp:Panel ID="pnlDeleteSampleForm" runat="server" DefaultButton="btnDeleteSampleDelete">
                    <asp:Button ID="btnCancelDeleteSampleModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                    <asp:Button ID="btnDeleteSampleDelete" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" ValidationGroup="DeleteSampleRecord" />
                </asp:Panel>
            </div>
        </div>
    </div>
    <div id="divDeleteTestModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" data-backdrop="static" role="dialog" aria-labelledby="divDeleteTestModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divDeleteTestModal');">&times;</button>
                <h4 id="hdgDeleteTest" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Delete_Sample_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upDeleteTest" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="table-responsive">
                            <eidss:GridView ID="gvDeleteTests" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" AllowPaging="false" AllowSorting="false" GridLines="None">
                                <HeaderStyle CssClass="table-striped-header" />
                                <Columns>
                                    <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                    <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                                    <asp:BoundField DataField="PatientFarmOwnerName" HeaderText="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" />
                                </Columns>
                            </eidss:GridView>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                <asp:Label ID="lblDeleteTestReasonForDeletion" runat="server" Text="<%$ Resources: Labels, Lbl_Reason_For_Deletion_Text %>"></asp:Label>
                            </div>
                            <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                <asp:TextBox ID="txtDeleteTestReasonForDeletion" runat="server" CssClass="form-control" MaxLength="500"></asp:TextBox>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer text-center">
                <asp:Panel ID="pnlDeleteTestForm" runat="server" DefaultButton="btnDeleteTestDelete">
                    <asp:Button ID="btnCancelDeleteTestModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                    <asp:Button ID="btnDeleteTestDelete" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" ValidationGroup="DeleteSampleRecord" />
                </asp:Panel>
            </div>
        </div>
    </div>
    <div id="divColumnViewPreferences" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divColumnViewPreferences">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divColumnViewPreferences');">&times;</button>
                <h4 id="hdgColumnViewPreferences" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Column_View_Preferences_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:ColumnViewPreferences ID="ucColumnViewPreferences" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <button id="btnColumnViewPreferencesCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" onclick="hideModal('#divColumnViewPreferences');" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <asp:Button ID="btnSaveAsDefault" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_As_Default_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_As_Default_ToolTip %>" CausesValidation="false" />
                <asp:Button ID="btnChangeOnce" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Change_Columns_Once_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Change_Columns_Once_ToolTip %>" CausesValidation="false" />
            </div>
        </div>
    </div>
    <div id="divPrintBarCodesModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divPrintBarCodesModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divPrintBarCodesModal');">&times;</button>
                <h4 id="hdgPrintBarcodes" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Bar_Code_Labels_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:PrintBarCode ID="ucPrintBarCode" runat="server" />
            </div>
            <div class="modal-footer text-center">
                <button id="btnPrintBarCodeCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" onclick="hideModal('#divPrintBarCodesModal');" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrint" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divSampleDetailsFormModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSampleDetailsFormModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSampleDetailsFormModal')">&times;</button>
                <h4 id="hdgSampleDetailsForm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Sample_Details_Form_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnSampleDetailsFormCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintSampleDetailsForm" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divTestDetailsFormModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divTestDetailsFormModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTestDetailsFormModal')">&times;</button>
                <h4 id="hdgTestDetailsForm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Details_Form_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnTestDetailsFormCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModalOnModal('#divTestDetailsFormModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintTestDetailsForm" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divTransferDetailsFormModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divTransferDetailsFormModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTransferDetailsFormModal')">&times;</button>
                <h4 id="hdgTransferDetailsForm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Transfer_Details_Form_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnTransferDetailsFormCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModalOnModal('#divSampleTestDetailsModal', '#divTransferDetailsFormModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintTransferDetailsForm" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divSampleReportModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSampleReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSampleReportModal')">&times;</button>
                <h4 id="hdgSampleReport" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Sample_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnSampleReportCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModal('#divSampleReportModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintSampleReport" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divTestResultReportModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divTestResultReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTestResultReportModal')">&times;</button>
                <h4 id="hdgTestResultReport" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Result_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnTestResultReportCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModal('#divTestResultReportModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintTestResultReport" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divTransferReportModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divTransferReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTransferReportModal')">&times;</button>
                <h4 id="hdgTransferReport" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Transfer_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnTransferReportCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModal('#divTransferReportModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintTransferReport" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divAccessionInFormModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divAccessionInFormModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAccessionInFormModal')">&times;</button>
                <h4 id="hdgAccessionInForm" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Accession_In_Form_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnAccessionInFormCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModal('#divAccessionInFormModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintAccessionInForm" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divDestructionReportModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divDestructionReportModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divDestructionReportModal')">&times;</button>
                <h4 id="hdgDestructionReport" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Destruction_Report_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <h3>Coming soon...</h3>
            </div>
            <div class="modal-footer text-center">
                <button id="btnDestructionReportCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal" onclick="hideModal('#divDestructionReportModal')"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <button id="btnPrintDestructionReport" type="button" class="btn btn-primary" title="<%= GetGlobalResourceObject("Buttons", "Btn_Print_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Print_Text") %></button>
            </div>
        </div>
    </div>
    <div id="divAmendTestResultModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divAmendTestResultModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAmendTestResultModal');">&times;</button>
                <h4 id="hdgAmendTestResult" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Amend_Test_Result_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:AmendTestResult ID="ucAmendTestResult" runat="server" ValidationGroup="AmendTestResult" />
            </div>
            <div class="modal-footer text-center">
                <asp:UpdatePanel ID="upAmendTestResultCommands" runat="server" UpdateMode="Conditional">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAmend" EventName="Click" />
                    </Triggers>
                    <ContentTemplate>
                        <asp:Panel ID="pnlAmendTestResult" runat="server" DefaultButton="btnAmend">
                            <asp:Button ID="btnCancelAmendTestResultModal" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            <asp:Button ID="btnAmend" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Amend_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Amend_ToolTip %>" ValidationGroup="AmendTestResult" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
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
                            <asp:Button ID="btnModalSuccessOK" runat="server" CssClass="btn btn-primary" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
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
    <script lang="javascript" type="text/javascript">
        $(function () {
            $(document).ready(function () {
                Sys.WebForms.PageRequestManager.getInstance();
                Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);

                // Bootstrap popover customization for actions
                $('.popup-window').popover({
                    html: true,
                    trigger: 'manual',
                    content: function () {
                        return $(this).next('.popup-content').html();
                    }
                }).click(function (e) {
                    $(this).popover('toggle');
                    $('.popup-window').not(this).popover('hide');

                    e.stopPropagation();
                });

                $('body').on('click', function (e) {
                    $('.popup-window').each(function () {
                        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                            $(this).popover('hide');
                        }
                    });
                });

                $('.has-clear input[type="text"]').on('input propertychange', function () {
                    var $this = $(this);
                    var visible = Boolean($this.val());
                    $this.siblings('.form-control-clear').toggleClass('hidden', !visible);
                }).trigger('propertychange');

                $('.form-control-clear').click(function () {
                    $(this).siblings('input[type="text"]').val('')
                        .trigger('propertychange').focus();
                });

                stickyColumns();

                $('.panel-collapse').on('hidden.bs.collapse', function () {
                    $(this).siblings('.panel-heading').removeClass('active');
                });
            });

            document.getElementById("btnPrint").onclick = function () {
                printElement(document.getElementById("printThis"));
            }
        });

        // Customization for the accession and add group result popover controls.
        function popOver() {
            $('.popup-window').popover({
                html: true,
                trigger: 'manual',
                content: function () {
                    return $(this).next('.popup-content').html();
                }
            }).click(function (e) {
                $(this).popover('toggle');
                $('.popup-window').not(this).popover('hide');

                e.stopPropagation();
            });

            $('body').on('click', function (e) {
                $('.popup-window').each(function () {
                    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                        $(this).popover('hide');
                    }
                });
            });

            $(document).on('show.bs.modal', '.modal', function (event) {
                var zIndex = 1040 + (10 * $('.modal:visible').length);
                $(this).css('z-index', zIndex);
                setTimeout(function () {
                    $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
                }, 0);
            });
        };

        function beginRequestHandler() {

        };

        function endRequestHandler() {
            var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");
            if (personSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
            }

            stickyColumns();

            hideLoading();

            setActiveTabItem();
        };

        function tabChanged(obj, tab) {
            var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");
            hdfCurrentTab.value = tab;

            __doPostBack(obj.id, 'TabChanged');
        }

        function setActiveTabItem() {
            var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");

            switch (hdfCurrentTab.value) {
                case 'Approvals':
                    document.getElementById('liApprovals').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavApprovals').setAttribute('class', 'tab-pane active');
                    break;
                case 'Batches':
                    document.getElementById('liBatches').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavBatches').setAttribute('class', 'tab-pane active');
                    break;
                case 'Favorites':
                    document.getElementById('liMyFavorites').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavMyFavorites').setAttribute('class', 'tab-pane active');
                    break;
                case 'Samples':
                    document.getElementById('liSamples').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavSamples').setAttribute('class', 'tab-pane active');
                    break;
                case 'Testing':
                    document.getElementById('liTesting').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavTesting').setAttribute('class', 'tab-pane active');
                    break;
                case 'Transferred':
                    document.getElementById('liTransferred').setAttribute('class', 'active');
                    document.getElementById('EIDSSBodyCPH_NavTransferred').setAttribute('class', 'tab-pane active');
                    break;
            }
        };

        function stickyColumns() {
            var colsToLock = 5;

            var $gvSamples = $("table[id$=gvSamples]").clone();
            $gvSamples.addClass("stickyColumn");
            $gvSamples.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            $("#divSamples").append($gvSamples);
            $("#divSamples").scroll(function () { $("#divSamples").find(".stickyColumn").css("left", $("#divSamples").scrollLeft()); });

            var $gvTesting = $("table[id$=gvTesting]").clone();
            $gvTesting.addClass("stickyColumn");
            $gvTesting.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            $("#divTesting").append($gvTesting);
            $("#divTesting").scroll(function () { $("#divTesting").find(".stickyColumn").css("left", $("#divTesting").scrollLeft()); });

            var $gvTransferred = $("table[id$=gvTransferred]").clone();
            $gvTransferred.addClass("stickyColumn");
            $gvTransferred.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            $("#divTransferred").append($gvTransferred);
            $("#divTransferred").scroll(function () { $("#divTransferred").find(".stickyColumn").css("left", $("#divTransferred").scrollLeft()); });

            var $gvMyFavorites = $("table[id$=gvMyFavorites]").clone();
            $gvMyFavorites.addClass("stickyColumn");
            $gvMyFavorites.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            $("#divMyFavorites").append($gvMyFavorites);
            $("#divMyFavorites").scroll(function () { $("#divMyFavorites").find(".stickyColumn").css("left", $("#divMyFavorites").scrollLeft()); });

            //var gvBatchTests_0 = $("table[id$=gvBatchTests_0]").clone();
            //gvBatchTests_0.addClass("stickyColumn");
            //gvBatchTests_0.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            //$("#EIDSSBodyCPH_gvBatches_divBatchTests_0").prepend(gvBatchTests_0);
            //$("#EIDSSBodyCPH_gvBatches_divBatchTests_0").scroll(function () { $("#EIDSSBodyCPH_gvBatches_divBatchTests_0").find(".stickyColumn").css("left", $("#EIDSSBodyCPH_gvBatches_divBatchTests_0").scrollLeft()); });

            var $gvApprovals = $("table[id$=gvApprovals]").clone();
            $gvApprovals.addClass("approvalsStickyColumn");
            $gvApprovals.find("td:nth-child(1n+" + (colsToLock + 1) + "), th:nth-child(1n+" + (colsToLock + 1) + ")").remove();
            $("#divApprovals").append($gvApprovals);
            $("#divApprovals").scroll(function () { $("#divApprovals").find(".approvalsStickyColumn").css("left", $("#divApprovals").scrollLeft()); });
        };

        function accessionIn() {
            setActiveTabItem();

            popOver();

            $("#EIDSSBodyCPH_btnAccession").popover('show');
        };

        function addGroupResult() {
            setActiveTabItem();

            popOver();

            $("#EIDSSBodyCPH_btnAddGroupResult").popover('show');
        };

        function showSubGrid(e, divname) {
            var div = document.getElementById(divname);

            var cl = e.target.className;
            if (cl == 'glyphicon glyphicon-plus-sign') {
                $(this).closest("tr").after("")
                div.style.display = "inline";
                e.target.className = "glyphicon glyphicon-minus-sign";
            }
            else {
                e.target.className = "glyphicon glyphicon-plus-sign";
                div.style.display = "none";
            }
        };

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0)
                showModal(modalID);
            else
                showModalOnModal(modalID);
        };

        function showModal(modalID) {
            var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            $("body").addClass("modal-open");
            bd.appendTo(document.body);

            setActiveTabItem();
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');

            setActiveTabItem();
        }

        function hideModal(modalID) {
            setActiveTabItem();
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };

        function hideModalShowModal(hideDiv, showDiv) {
            setActiveTabItem();
            $(hideDiv).modal('hide');
            $(showDiv).modal({ show: true });
        };

        function showSampleTestDetails(accordionItem) {
            setActiveTabItem();

            $('.panel-collapse').on('show.bs.collapse', function () {
                $(this).siblings('.panel-heading').addClass('active');
            });

            switch (accordionItem) {
                case "Sample":
                    $("#divSampleDetails").collapse({ parent: '#accordion', toggle: false });
                    $('#divSampleDetails').collapse('show');
                    break;
                case "Test":
                    $("#divTestDetails").collapse({ parent: '#accordion', toggle: false });
                    $('#divTestDetails').collapse('show');
                    break;
                case "Transfer":
                    $("#divTransferDetails").collapse({ parent: '#accordion', toggle: false });
                    $('#divTransferDetails').collapse('show');
                    break;
            }

            $('#divSampleTestDetailsModal').modal({ show: true });
            $('body').addClass('labModal');
            var bd = $('<div class="modal-backdrop show"></div>');
            bd.appendTo(document.body);
        };

        function showSearchResults() {
            setActiveTabItem();

            $('#divSamplesFilter').hide();

            $('.has-clear input[type="text"]').on('input propertychange', function () {
                var $this = $(this);
                var visible = Boolean($this.val());
                $this.siblings('.form-control-clear').toggleClass('hidden', !visible);
            }).trigger('propertychange');

            $('.form-control-clear').click(function () {
                $(this).siblings('input[type="text"]').val('')
                    .trigger('propertychange').focus();
            });
        }

        function resetSearch() {
            $('#divSamplesFilter').show();

            $('.has-clear input[type="text"]').on('input propertychange', function () {
                var $this = $(this);
                var visible = Boolean($this.val());
                $this.siblings('.form-control-clear').toggleClass('hidden', !visible);
            }).trigger('propertychange');

            $('.form-control-clear').click(function () {
                $(this).siblings('input[type="text"]').val('')
                    .trigger('propertychange').focus();
            });
        }

        function printElement(elem) {
            var domClone = elem.cloneNode(true);

            var $printSection = document.getElementById("printSection");

            if (!$printSection) {
                var $printSection = document.createElement("div");
                $printSection.id = "printSection";
                document.body.appendChild($printSection);
            }

            $printSection.innerHTML = "";
            $printSection.appendChild(domClone);
            window.print();
        }

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
        }

        function showProcessing(button) {
            var btn = $("#" + button.id);

            btn.button('loading');
        }

        function showBaseReferenceEditorModal() {
            $('#divBaseReferenceEditorModal').modal({ show: true });
        };

        function hideBaseReferenceEditorModal() {
            $('#divBaseReferenceEditorModal').modal('hide');
        };

        function showGroupAccessionInSelectSamplesLoading() {
            var btn = $("#EIDSSBodyCPH_btnGroupAccessionInSelectSamplesSelect");
            btn.button('loading');
            $.ajax("").always(function () {
                btn.button('reset');
            });
        };

        function showBatchSelectSamplesLoading() {
            var btn = $("#EIDSSBodyCPH_btnBatchSelectSamplesAdd");
            btn.button('loading');
            $.ajax("").always(function () {
                btn.button('reset');
            });
        };

        function editBatch(batchTestID) {
            __doPostBack(batchTestID, 'EditBatch');
        }
    </script>
</asp:Content>
