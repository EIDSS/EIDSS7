<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="SettlementAdmin.aspx.vb" Inherits="EIDSS.SettlementAdmin" EnableEventValidation="false" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>



<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <div class="container-fluid">
<%--        <asp:UpdateProgress runat="server">
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
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %>
                        <button id="btnOpenModal" class="btn btn-primary btn-sm" type="button" data-toggle="modal" data-target="#searchModal" onclick="isModalShown = true;">
                            <span class="glyphicon glyphicon-search text-right-20" aria-hidden="true"></span>&nbsp;
                        <span><%=GetLocalResourceObject("Btn_Search.Text") %></span>
                        </button>
                        &nbsp;
                    <button id="btnNew" type="submit" runat="server" class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;
                        <span><%= GetLocalResourceObject("Btn_New.Text") %></span>
                    </button>

                    </h2>
                </div>

                <div class="table-responsive" meta:resourcekey="Dis_Settlements" runat="server">
                    <asp:UpdatePanel runat="server" ID="upSettlementList">
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
                                DataKeyNames="idfsSettlement,SettlementDefaultName, SettlementNationalName "
                                GridLines="None"
                                ID="gvSettlementList"
                                meta:Resourcekey="Grd_Settlements"
                                OnSorting="gvSettlementList_Sorting"
                                EmptyDataText="<%$ Resources:Lbl_Settlement_List.Empty %>"
                                runat="server"
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
                                    <asp:BoundField DataField="idfsSettlement" Visible="false" />
                                    <asp:BoundField DataField="SettlementDefaultName" HeaderText="<%$ Resources: Grd_Default_Name_Heading %>" />
                                    <asp:BoundField DataField="SettlementNationalName" HeaderText="<%$ Resources: Grd_National_Name_Heading %>" />
                                    <asp:BoundField DataField="SettlementTypeDefaultName" HeaderText="<%$ Resources:Grd_Settlement_Type_Heading %>" />
                                    <asp:BoundField DataField="CountryNationalName" HeaderText="<%$ Resources:Grd_Country_Heading %>" />
                                    <asp:BoundField DataField="RegionNationalName" HeaderText="<%$ Resources:Grd_Region_Heading %>" />
                                    <asp:BoundField DataField="RayonNationalName" HeaderText="<%$ Resources:Grd_Rayon_Heading %>" />
                                    <asp:BoundField DataField="dblLatitude" HeaderText="<%$ Resources:Grd_Latitude_Heading %>" />
                                    <asp:BoundField DataField="dblLongitude" HeaderText="<%$ Resources:Grd_Longitude_Heading %>" />
                                    <asp:BoundField DataField="intElevation" HeaderText="<%$ Resources:Grd_Elevation_Heading %>" />
                                    <asp:CommandField
                                        AccessibleHeaderText="<%$ Resources:Btn_Edit.Text %>"
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
                        <%--Begin: Hidden fields--%>
                        <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                            <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsSettlement" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsSettlementType" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsRegion" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfsRayon" Value="NULL" />

                            <asp:HiddenField runat="server" ID="hdfUniqueCodeID" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfSettlementName" Value ="NULL" />
                            <asp:HiddenField runat="server" ID="hdfNationalName" Value="NULL" />

                        </div>

                        <div class="modal fade" id="searchModal" role="dialog">
                            <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        <h4 class="modal-title" meta:resourcekey="Hdg_Search_Text"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group" meta:resourcekey="Dis_Default_Name" runat="server">
                                            <asp:Label
                                                AssociatedControlID="txtDefaultName"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Default_Name"
                                                runat="server"></asp:Label>
                                            <asp:TextBox
                                                CssClass="form-control"
                                                ID="txtDefaultName"
                                                runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtDefaultName"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Default_Name"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_National_Name" runat="server">
                                            <asp:Label
                                                AssociatedControlID="txtstrNationalName"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_National_Name"
                                                runat="server"></asp:Label>
                                            <asp:TextBox
                                                CssClass="form-control"
                                                ID="txtstrNationalName"
                                                runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtstrNationalName"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_National_Name"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-group" meta:resourcekey="Dis_Settlement_Type" runat="server">
                                            <asp:Label
                                                AssociatedControlID="ddlSettlementType"
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Settlement_Type"
                                                runat="server"></asp:Label>
                                            <asp:DropDownList
                                                CssClass="form-control"
                                                ID="ddlSettlementType"
                                                runat="server" ></asp:DropDownList> 
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="ddlSettlementType"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Settlement_Type"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>

                                        <eidss:LocationUserControl runat="server" ID="LUCSettlement"
                                            ShowBuildingHouseApartmentGroup="false"
                                            ShowCountry="true"
                                            ShowRegion="true"
                                            ShowRayon="true"
                                            ShowTownOrVillage="true"
                                            ShowCoordinates="false"
                                            ShowPostalCode="false"
                                            ShowStreet="false"
                                            ShowMap="false" />

                                        <div class="form-group" meta:resourcekey="Dis_Latitude" runat="server">
                                            <asp:Label
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Latitude"
                                                runat="server"></asp:Label>
                                            <div>
                                                <asp:Label
                                                    AssociatedControlID="txtLatMin"
                                                    CssClass="control-label"
                                                    meta:resourcekey="Lbl_From_Latitude"
                                                    runat="server"></asp:Label>
                                                <eidss:NumericSpinner
                                                    CssClass="form-control"
                                                    ID="txtLatMin"
                                                    min="-90"
                                                    max="89"
                                                    runat="server"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator
                                                    ControlToValidate="txtLatMin"
                                                    CssClass=""
                                                    Display="Dynamic"
                                                    meta:resourcekey="Val_From_Latitude"
                                                    runat="server"></asp:RequiredFieldValidator>
                                            </div>
                                            <div>
                                                <asp:Label
                                                    AssociatedControlID="txtLatMax"
                                                    CssClass="control-label"
                                                    meta:resourcekey="Lbl_To_Latitude"
                                                    runat="server"></asp:Label>
                                                <eidss:NumericSpinner
                                                    CssClass="form-control"
                                                    ID="txtLatMax"
                                                    max="90"
                                                    min="-89"
                                                    runat="server"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator
                                                    ControlToValidate="txtLatMax"
                                                    CssClass=""
                                                    Display="Dynamic"
                                                    meta:resourcekey="Val_To_Latitude"
                                                    runat="server"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <div class="form-group" meta:resourcekey="Dis_Longitude" runat="server">
                                            <asp:Label
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Longitude"
                                                runat="server"></asp:Label>
                                            <div>
                                                <asp:Label
                                                    AssociatedControlID="txtLngMin"
                                                    CssClass="control-label"
                                                    meta:resourcekey="Lbl_From_Longitude"
                                                    runat="server"></asp:Label>
                                                <eidss:NumericSpinner
                                                    CssClass="form-control"
                                                    ID="txtLngMin"
                                                    max="179"
                                                    min="-180"
                                                    runat="server"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator
                                                    ControlToValidate="txtLngMin"
                                                    CssClass=""
                                                    Display="Dynamic"
                                                    meta:resourcekey="Val_From_Longitude"
                                                    runat="server"></asp:RequiredFieldValidator>
                                            </div>
                                            <div>
                                                <asp:Label
                                                    AssociatedControlID="txtLngMax"
                                                    CssClass="control-label"
                                                    meta:resourcekey="Lbl_To_Longitude"
                                                    runat="server"></asp:Label>
                                                <eidss:NumericSpinner
                                                    CssClass="form-control"
                                                    ID="txtLngMax"
                                                    max="180"
                                                    min="-179"
                                                    runat="server"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator
                                                    ControlToValidate="txtLngMax"
                                                    CssClass=""
                                                    Display="Dynamic"
                                                    meta:resourcekey="Val_To_Longitude"
                                                    runat="server"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <div class="form-group" meta:resourcekey="Dis_Elevation" runat="server">
                                            <asp:Label
                                                CssClass="control-label"
                                                meta:resourcekey="Lbl_Elevation"
                                                runat="server"></asp:Label>
                                            <div>
                                                <div>
                                                    <asp:Label
                                                        AssociatedControlID="txtEleMin"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_From_Elevation"
                                                        runat="server"></asp:Label>
                                                    <eidss:NumericSpinner
                                                        CssClass="form-control"
                                                        ID="txtEleMin"
                                                        min="0"
                                                        runat="server"></eidss:NumericSpinner>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtEleMin"
                                                        CssClass=""
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_From_Elevation"
                                                        runat="server"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:Label
                                                        AssociatedControlID="txtEleMax"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_To_Elevation"
                                                        runat="server"></asp:Label>
                                                    <eidss:NumericSpinner
                                                        CssClass="form-control"
                                                        ID="txtEleMax"
                                                        min="0"
                                                        runat="server"></eidss:NumericSpinner>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtEleMax"
                                                        CssClass=""
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_To_Elevation"
                                                        runat="server"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="modal-footer">
                                        <asp:Button
                                            runat="server"
                                            ID="btnClear"
                                            class="btn btn-default"
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

    <script type="text/javascript">
        var isModalShown = false;

        $(document).ready(function () {
            // set flag that indicates
            $("#searchModal").on("shown.bs.modal", function () { isModalShown = true; })
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
