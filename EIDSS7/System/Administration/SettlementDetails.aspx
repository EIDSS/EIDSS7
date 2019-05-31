<%@ Page Title="Settlement Details" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master"
    CodeBehind="SettlementDetails.aspx.vb" Inherits="EIDSS.SettlementDetails" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

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
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %></h2>
                </div>

                <div class="panel-body">
                    <asp:UpdatePanel runat="server">
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnSubmit" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <asp:ValidationSummary DisplayMode="BulletList" EnableClientScript="true" runat="server" ValidationGroup="SettlementSection" />
                            </div>
                            <div class="row">
                                <div class="sectionContainer expanded">
                                    <section id="SettlementSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Hdg_Settlement_Info" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">


                                                <div class="form-group" meta:resourcekey="Dis_Unique_Code" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Unique_Code"
                                                        runat="server"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrSettlementCode"
                                                        meta:resourcekey="Lbl_Unique_Code"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtstrSettlementCode"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrSettlementCode"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Unique_Code"
                                                        runat="server"
                                                        ValidationGroup="SettlementSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Settlement_Name" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrEnglishName"
                                                        meta:resourcekey="Lbl_Settlement_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtstrEnglishName"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrEnglishName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Settlement_Name"
                                                        runat="server"
                                                        ValidationGroup="SettlementSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Settlement_National_Name" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrNationalName"
                                                        meta:resourcekey="Lbl_Settlement_National_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtstrNationalName"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrNationalName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Settlement_National_Name"
                                                        runat="server"
                                                        ValidationGroup="SettlementSection"></asp:RequiredFieldValidator>
                                                </div>

                                                <div class="form-group" meta:resourcekey="Dis_Settlement_Type" runat="server">

                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Settlement_Type"
                                                        runat="server"></div>

                                                   <asp:Label
                                                        AssociatedControlID="ddlidfsSettlementType"
                                                        meta:resourcekey="Lbl_Settlement_Type"
                                                        runat="server"></asp:Label>

                                                    <eidss:DropDownList
                                                       CssClass="form-control"
                                                        ID="ddlidfsSettlementType"
                                                        runat="server" >

                                                    </eidss:DropDownList>

                                                    <asp:RequiredFieldValidator
                                                    ControlToValidate="ddlidfsSettlementType"

                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Settlement_Type"
                                                        runat="server"
                                                        InitialValue="null"
                                                        ValidationGroup="SettlementSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <eidss:LocationUserControl
                                                    ID="LocationUserControl"
                                                    runat="server"
                                                    ShowTownOrVillage="false"
                                                    ShowBuildingHouseApartmentGroup="false"
                                                    ShowPostalCode="false"
                                                    ShowStreet="false"
                                                    ValidationGroup="SettlementSection" 
                                                     IsDbRequiredCountry="true" 
                                                    IsDbRequiredRegion="true"
                                                    IsDbRequiredRayon="true" />
                                            </div>
                                            <div class="panel-footer">
                                                <%--fields the are not on form but are required to save--%>
                                                <asp:HiddenField ID="hdfidfSettlement" runat="server" Value="null" /> 

                                                <asp:HiddenField ID="hdfidfSettlementType" runat="server" Value="NULL" /> 

                                                <%-- New SettlementId parameter for the ihsert case --%>
                                                <asp:HiddenField ID="hdfidfsSettlementID" runat="server" Value="null" />

                                                <%-- New SettlementId parameter for the ihsert case --%>
                                                <asp:HiddenField ID="hdfidfsSettlementIDNew" runat="server" Value="null" />

                                                <%-- Language ID  --%>
                                                <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                                                <%-- longitute, latitude and elevation : Today be copied into LocationUC --%>
                                                <asp:HiddenField ID="hdfstrLongitude" runat="server" />
                                                <asp:HiddenField ID="hdfstrLatitude" runat="server" />
                                                <asp:HiddenField ID="hdfstrElevation" runat="server" />

                                            </div>
                                        </div>
                                    </section>
                                </div>
                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            ID="sideBarItemSettlement"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Settlement"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-file"
                                            GoToTab="1"
                                            ID="sideBarItemReview"
                                            IsActive="true"
                                            ItemStatus="IsReview"
                                            meta:resourcekey="Tab_Review"
                                            runat="server">
                                        </eidss:SideBarItem>
                                    </MenuItems>
                                </eidss:SideBarNavigation>

                            </div>
                            <div class="row">
                                <div class="sectionContainer text-center">
                                    <input
                                        class="btn btn-default"
                                        id="btnCancel"
                                        meta:resourcekey="Btn_Cancel"
                                        onclick="location.replace('SettlementAdmin.aspx')"
                                        runat="server"
                                        type="button" />
                                    <input
                                        class="btn btn-default"
                                        id="btnPreviousSection"
                                        meta:resourcekey="Btn_Back"
                                        onclick="goBackToPreviousPanel(); return false;"
                                        runat="server"
                                        type="button" />
                                    <input
                                        class="btn btn-default"
                                        id="btnNextSection"
                                        onclick="goForwardToNextPanel(); return false;"
                                        meta:resourcekey="Btn_Continue"
                                        runat="server"
                                        type="button" />
                                    <!-- hiding save button while we decide if it stays or goes away -->
                                    <asp:Button
                                        CssClass="btn btn-primary"
                                        ID="Btn_Save"
                                        meta:resourcekey="Btn_Save"
                                        runat="server"
                                        Visible="false" />
                                    <asp:Button
                                        CssClass="btn btn-primary hidden"
                                        ID="btnSubmit"
                                        meta:resourcekey="Btn_Submit"
                                        runat="server" />

                                </div>
                            </div>

                            <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                            <script type="text/javascript">
                                $(document).ready(function () {
                                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                                    setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
                                })

                                function callBackHandler() {
                                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                                }
                            </script>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
