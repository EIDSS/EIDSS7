<%@ Page Title="Organization List (A06)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="OrganizationAdmin.aspx.vb" Inherits="EIDSS.OrganizationAdmin" EnableEventValidation="false" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="uc1" TagName="LocationUserControl" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
<%--    <asp:UpdateProgress runat="server">
        <ProgressTemplate>
            <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                <div class="modal-content">
                    <div class="modal-body">
                        <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
    <div class="container-fluid">
        <div class="row">
            <%--Begin: Hidden fields--%>
            <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfidfOrgID" Value="null" />
                <asp:HiddenField runat="server" ID="hdfidfLocation" Value="null" />
                <asp:HiddenField runat="server" ID="hdfidfsSite" Value="null" />
                <asp:HiddenField runat="server" ID="hdfidfsRegion" Value="null" />
                <asp:HiddenField runat="server" ID="hdfidfsRayon" Value="null" />
                <asp:HiddenField runat="server" ID="hdfintHACode" Value="null" />

                <asp:HiddenField runat="server" ID="hdfUniqueOrgID" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfOrgName" Value ="NULL" />
                <asp:HiddenField runat="server" ID="hdfAbbreviation" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfOfficeID" Value="NULL" />


            </div>

            <%-- End: Hidden Fields --%>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %>  
                        <button id="btnOpenModal" class="btn btn-primary btn-sm" type="button" data-toggle="modal" data-target="#searchModal" onclick="isModalShown = true;">
                            <span class="glyphicon glyphicon-search text-right-20" aria-hidden="true"></span>&nbsp;
                        <span><%=GetLocalResourceObject("Btn_Search.Text") %></span>
                        </button>
                        &nbsp;&nbsp;
                    <button id="btnNew" type="submit" runat="server" class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;
                        <span><%= GetLocalResourceObject("Btn_Add_Organization.Text")  %></span>
                    </button>

                        </h2>

                   
                </div>

                <div class="table-responsive">
                    <asp:UpdatePanel runat="server" ID="upOrganizationList">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" />
                        </Triggers>
                        <ContentTemplate>
                            <eidss:GridView
                                AllowPaging="true"
                                AllowSorting="true"
                                AutoGenerateColumns="false"
                                CaptionAlign="Top"
                                CssClass="table table-striped table-hover"
                                DataKeyNames="idfInstitution,idfLocation,idfsSite,idfsRegion,idfsRayon,intHACode,name,FullName,strOrganizationID"
                                GridLines="None"
                                ID="gvOrganizationList"
                                KeyNameUsedOnModal="FullName"
                                meta:resourcekey="Grd_Organization"
                                EmptyDataText="<%$ Resources:Lbl_Organization_List.Empty %>"
                                runat="server"
                                OnRowEditing="gvOrganizationList_RowEditing"
                                OnSorting="gvOrganizationList_Sorting"
                                ShowFooter="false"
                                ShowHeader="true"
                                UseAccessibleHeader="true">
                                <HeaderStyle CssClass="table-striped-header" />
                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                <SortedAscendingHeaderStyle CssClass="" />
                                <SortedDescendingHeaderStyle CssClass="" />
                                <SortedAscendingCellStyle CssClass="" />
                                <SortedDescendingCellStyle CssClass="" />
                                <Columns>
                                    <%--  Select key must always be first  --%>
                                    <asp:CommandField
                                        AccessibleHeaderText="<%$ Resources:Btn_Select.Text %>"
                                        ControlStyle-CssClass="btn glyphicon glyphicon-asterisk"
                                        SelectText=""
                                        ShowSelectButton="true"
                                        Visible="false" />

                                    <%--Key Fields--%>
                                    <asp:BoundField DataField="idfInstitution" Visible="false" />
                                    <asp:BoundField DataField="idfOffice" Visible="false" />
                                    <asp:BoundField DataField="idfsOfficeName" Visible="false" />
                                    <asp:BoundField DataField="idfsOfficeAbbreviation" Visible="false" />
                                    <asp:BoundField DataField="idfLocation" Visible="false" />
                                    <asp:BoundField DataField="idfsSite" Visible="false" />
                                    <asp:BoundField DataField="idfGeoLocationShared" Visible="false" />
                                    <asp:BoundField DataField="idfsResidentType" Visible="false" />
                                    <asp:BoundField DataField="idfsGroundType" Visible="false" />
                                    <asp:BoundField DataField="idfsGeoLocationType" Visible="false" />
                                    <asp:BoundField DataField="idfsCountry" Visible="false" />
                                    <asp:BoundField DataField="idfsRegion" Visible="false" />
                                    <asp:BoundField DataField="idfsRayon" Visible="false" />
                                    <asp:BoundField DataField="idfsSettlement" Visible="false" />
                                    <asp:BoundField DataField="rowguid" Visible="false" />
                                    <asp:BoundField DataField="intHACode" Visible="false" />
                                    <asp:BoundField DataField="EnglishFullName" Visible="false" />
                                    <asp:BoundField DataField="EnglishName" Visible="false" />
                                    <asp:BoundField DataField="strContactPhone" Visible="false" />
                                    <asp:BoundField DataField="strDefault" Visible="false" />
                                    <asp:BoundField DataField="intRowStatus" Visible="false" />
                                    <asp:BoundField DataField="strStreetName" Visible="false" />

                                    <asp:BoundField DataField="strBuilding" Visible="false" />
                                    <asp:BoundField DataField="strApartment" Visible="false" />
                                    <asp:BoundField DataField="strDescription" Visible="false" />
                                    <asp:BoundField DataField="dblDistance" Visible="false" />
                                    <asp:BoundField DataField="dblLatitude" Visible="false" />
                                    <asp:BoundField DataField="dblLongitude" Visible="false" />
                                    <asp:BoundField DataField="dblAccuracy" Visible="false" />
                                    <asp:BoundField DataField="dblAlignment" Visible="false" />
                                    <asp:BoundField DataField="blnForeignAddress" Visible="false" />
                                    <asp:BoundField DataField="strForeignAddress" Visible="false" />
                                    <asp:BoundField DataField="strAddressString" Visible="false" />
                                    <asp:BoundField DataField="strShortAddressString" Visible="false" />
                                    <asp:BoundField DataField="strMaintenanceFlag" Visible="false" />
                                    <asp:BoundField DataField="strReservedAttribute" Visible="false" />

                                    <%--Fields to display--%>

                                    <asp:BoundField
                                        DataField="name"
                                        HeaderText="<%$ Resources: Grd_Abbreviation_Heading %>"
                                        SortExpression="name" />
                                    <asp:BoundField
                                        DataField="FullName"
                                        HeaderText="<%$ Resources:Grd_Organization_Full_Name_Heading  %>"
                                        SortExpression="FullName" />
                                    <asp:BoundField
                                        DataField="strOrganizationID"
                                        HeaderText="<%$ Resources:Grd_Unique_Organization_Heading %>"
                                        SortExpression="strOrganizationID" />
                                    <asp:BoundField
                                        DataField="idfsSite"
                                        HeaderText="<%$ Resources: Grd_Organization_Address_Heading %>"
                                        SortExpression="Address" />
                                    <asp:BoundField
                                        DataField="intOrder"
                                        HeaderText="<%$ Resources: Grd_Order_Header_Heading %>"
                                        SortExpression="intOrder" />
                                    <asp:CommandField
                                        AccessibleHeaderText="<%$ Resources: Btn_Edit.Text %>"
                                        ControlStyle-CssClass="btn glyphicon glyphicon-edit"
                                        EditText=""
                                        ShowEditButton="true" />
                                    <asp:CommandField
                                        AccessibleHeaderText="<%$ Resources: Btn_Delete.Text %>"
                                        ControlStyle-CssClass="btn glyphicon glyphicon-trash"
                                        DeleteText=""
                                        ShowDeleteButton="true" />
                                </Columns>
                            </eidss:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <asp:UpdatePanel ID="searchUpdatePanel" runat="server">
                    <ContentTemplate>
                        <div class="modal fade" id="searchModal" role="dialog">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        <h4 class="modal-title" id="HdgSearchTitle" meta:resourcekey="Hdg_Search_Title" runat="server"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group" meta:resourcekey="Dis_Organization_Unique_Id" runat="server">
                                            <asp:Label
                                                AssociatedControlID="txtstrOrganizationID"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Organization_Unique_Id"
                                                runat="server"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtstrOrganizationID" runat="server" />
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtstrOrganizationID"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Organization_Unique_Id"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_Abbreviation" runat="server">
                                            <asp:Label
                                                AssociatedControlID="txtstrOrgName"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Abbreviation"
                                                runat="server"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtstrOrgName" runat="server" />
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtstrOrgName"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Abbreviation"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_Organization_Full_Name" runat="server">
                                            <asp:Label
                                                AssociatedControlID="txtstrOrgFullName"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Organization_Full_Name"
                                                runat="server"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtstrOrgFullName" runat="server" />
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtstrOrgFullName"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Organization_Full_Name"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_Specialization" runat="server">
                                            <asp:Label
                                                AssociatedControlID="ddlSpecialization"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Specialization"
                                                runat="server"></asp:Label>
                                            <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" ID="ddlSpecialization" runat="server" />
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="ddlSpecialization"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Specialization"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_Show_Foreign_Organizations" runat="server">
                                            <asp:Label
                                                AssociatedControlID="chkShowForeignOrganizations"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Show_Foreign_Organizations"
                                                runat="server"></asp:Label>
                                            <asp:CheckBox runat="server" ID="chkShowForeignOrganizations" />

                                        </div>
                                        <uc1:LocationUserControl runat="server" ID="LocationUserControl"
                                            ShowBuildingHouseApartmentGroup="false"
                                            ShowCountry="false"
                                            ShowCoordinates="false"
                                            ShowPostalCode="false"
                                            ShowStreet="false" />
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button
                                            runat="server"
                                            ID="btnClear"
                                            CssClass="btn btn-default"
                                            meta:resourcekey="Btn_Clear"
                                            OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;" />

                                        <asp:Button
                                            CssClass="btn btn-default"
                                            ID="btnSearch"
                                            meta:resourcekey="Btn_Search"
                                            runat="server"
                                            OnClick="btnSearch_Click"
                                            OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <script>
        var isModalShown = false;

        $(document).ready(function () {
            // set flag that indicates
            $("#searchModal").on("shown.bs.modal", function () { isModalShown = true; })
            //$("#searchModal").on("hidden.bs.modal", function () { isModalShown = false; })
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(showModalAfterPostBack);
            showModalAfterPostBack();
        });

        function showModalAfterPostBack() {
            if (isModalShown) {
                $('.modal-backdrop').remove();
                $('#searchModal').modal({ show: true });
            }
        }
    </script>
</asp:Content>
