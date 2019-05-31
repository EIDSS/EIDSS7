<%@ Page Title="Organization Details" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" EnableViewState="true"
    CodeBehind="OrganizationDetails.aspx.vb" Inherits="EIDSS.OrganizationDetails" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <style type="text/css">
        #foreignAddressType {
            display: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdateProgress runat="server">
        <ProgressTemplate>
            <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                <div class="modal-content">
                    <div class="modal-body">
                        <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
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
                                <div class="sectionContainer expanded">
                                    <section id="OrganizationSection" runat="server" class="col-md-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Hdg_Organization_Info" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group" meta:resourcekey="Dis_Organization_Unique_Id" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Organization_Unique_Id"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrOrganizationID"
                                                        meta:Resourcekey="Lbl_Organization_Unique_Id"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtstrOrganizationID"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrOrganizationID"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Organization_Unique_Id"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Abbreviation" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtEnglishName"
                                                        meta:Resourcekey="Lbl_Abbreviation"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtEnglishName"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtEnglishName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Abbreviation"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Organization_Full_Name" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtFullName"
                                                        meta:Resourcekey="Lbl_Organization_Full_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        ID="txtFullName"
                                                        runat="server"
                                                        CssClass="form-control"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtFullName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Organization_Full_Name"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Accessory_Code" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="lsbintHACode1"
                                                        meta:Resourcekey="Lbl_Accessory_Code" runat="server"> </asp:Label>


   <%--                                                 
                                                    <asp:DropDownList
                                                        ID="lsbintHACode"
                                                        CssClass="form-control"
                                                        runat="server"
                                                        selectionMode=""></asp:DropDownList>--%>



                                                    <eidss:DropDownList
                                                        ID="lsbintHACode1"
                                                        CssClass="form-control"
                                                        runat="server"
                                                        size="5" selectionMode="multiple"  ></eidss:DropDownList>

                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="lsbintHACode1"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Accessory_Code"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Order" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Order"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtintOrder"
                                                        meta:Resourcekey="Lbl_Order"
                                                        runat="server"></asp:Label>
                                                    <eidss:NumericSpinner
                                                        CssClass="form-control"
                                                        ID="txtintOrder"
                                                        runat="server"></eidss:NumericSpinner>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtintOrder"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Order"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Foreign_Address" runat="server">
                                                    <asp:Label
                                                        AssociatedControlID="chkblnForeignAddress"
                                                        meta:Resourcekey="Lbl_Foreign_Address_CheckBox"
                                                        runat="server"></asp:Label>
                                                    <asp:CheckBox
                                                        ID="chkblnForeignAddress"
                                                        runat="server" onchange="foreignAddressCheckboxChanged()" />
                                                </div>
                                                
                                                <eidss:LocationUserControl runat="server"
                                                    ID="LUCDetails"
                                                    ShowCoordinates="false"
                                                    ValidationGroup="OrganizationSection"
                                                    IsDbRequiredCountry="true" 
                                                    IsDbRequiredRegion="true"
                                                    IsDbRequiredRayon="true" 
                                                    ShowStreet="true" ShowBuildingHouseApartmentGroup="true" ShowPostalCode="true" />
                                                
                                                <div id="foreignAddressType" class="form-group addressType">                                                    
                                                    <asp:label 
                                                        AssociatedControlID="txtForeignAddressType"
                                                        meta:resourcekey="lbl_Address"
                                                        runat="server" ></asp:label>
                                                    <asp:TextBox 
                                                        ID="txtForeignAddressType" 
                                                        runat="server" 
                                                        TextMode="MultiLine" 
                                                        Rows="3" 
                                                        CssClass="form-control"></asp:TextBox>                                                    
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Phone" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Phone"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrContactPhone"
                                                        meta:Resourcekey="Lbl_Phone"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtstrContactPhone"
                                                        runat="server" />
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrContactPhone"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Phone"
                                                        runat="server"
                                                        ValidationGroup="OrganizationSection"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                                <%--fields the are not on form but are required to save--%>
                                                <asp:HiddenField runat="server" Value="" ID="hdfidfOrganization" />
                                                <asp:HiddenField runat="server" Value="en-us" ID="hdfLangID" />
                                                <asp:HiddenField runat="server" Value="" ID="hdfreturnCode" />
                                                <asp:HiddenField runat="server" Value="0" ID="hdfUser" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfOffice" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfGeoLocation" />
                                                <asp:HiddenField runat="server" Value="0" ID="hdfidfOfficeNewID" />
                                                <asp:HiddenField runat="server" Value="" ID="hdfname" />
                                                <asp:HiddenField runat="server" Value="" ID="hdfEnglishFullName" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfLocation" />
                                                <asp:HiddenField runat="server" Value="0" ID="hdfintHACode" />
                                                <asp:HiddenField runat="server" Value="0" ID="hddidfsSite" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlidfsCountry" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlidfsRegion" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlidfsRayon" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlidfsSettlement" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlstrApartment" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlstrBuilding" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlstrStreetName" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControlstrHouse" />
                                                <asp:HiddenField runat="server" Value="" ID="hdfstrPostCode" />
                                                <asp:HiddenField runat="server" Value="0" ID="hdfstrForeignAddress" />
                                                <asp:HiddenField runat="server" Value="0" ID="hdfstrAddressString" />
                                                <asp:HiddenField runat="server" Value="0" ID="fldstrShortAddressString" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControldblLatitude" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfLocationUserControldblLongitude" />
                                                <asp:HiddenField runat="server" Value="1" ID="hdfblnGeoLocationShared" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfsCurrentCustomization" />
                                            </div>
                                        </div>
                                    </section>
                                    <section id="DepartmentsSection" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading"
                                                            meta:resourcekey="Hdg_Departments"
                                                            runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group" meta:resourcekey="Dis_Departments" runat="server">
                                                    <eidss:GridView
                                                        AllowPaging="true"
                                                        AllowSorting="true"
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped table-hover"
                                                        GridLines="None"
                                                        DataKeyNames="idfDepartment, idfInstitution"
                                                        ID="gvDepartments"
                                                        meta:ResourceKey="Grd_Departments"
                                                        runat="server"
                                                        ShowFooter="true"
                                                        ShowHeader="true"
                                                        ShowHeaderWhenEmpty="true"
                                                        UseAccessibleHeader="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <SortedAscendingHeaderStyle CssClass="" />
                                                        <SortedDescendingHeaderStyle CssClass="" />
                                                        <SortedAscendingCellStyle CssClass="" />
                                                        <SortedDescendingCellStyle CssClass="" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="<%$ Resources:Hdg_Name_Text %>">
                                                                <ItemTemplate>
                                                                    <div><%# Eval("name") %></div>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    <!-- this footer lets us add a new record-->
                                                                    <asp:TextBox Style="width: 90%;" ID="txtDepartmentName" runat="server"></asp:TextBox>
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton
                                                                        CommandArgument='<%# Eval("name") %>'
                                                                        CommandName="DepartmentDelete"
                                                                        CssClass="btn glyphicon glyphicon-trash"
                                                                        ID="btnDepartmentDelete"
                                                                        runat="server" />
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    <asp:LinkButton
                                                                        CommandArgument=""
                                                                        CommandName="DepartmentsAdd"
                                                                        CssClass="btn glyphicon glyphicon-plus"
                                                                        ID="btnDepartmentAdd"
                                                                        runat="server" />
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="False">
                                                                <ItemTemplate><%# Eval("name") %></ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <tr>
                                                                <td>
                                                                    <asp:TextBox Style="width: 90%;" ID="txtDepartmentName" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                    <asp:LinkButton
                                                                        CommandArgument=""
                                                                        CommandName="DepartmentsAddEmptyData"
                                                                        CssClass="btn glyphicon glyphicon-plus"
                                                                        ID="btnDepartmentAdd"
                                                                        runat="server"></asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </EmptyDataTemplate>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                            <div class="panel-footer"></div>
                                        </div>
                                    </section>
                                </div>
                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            ID="sideBarItemOrganizationInfo"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Organization_Info"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="1"
                                            ID="sideBarItemDepartments"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Departments"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="2"
                                            ID="sideBarItem1"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
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
                                        onclick="location.replace('OrganizationAdmin.aspx')"
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
                                        meta:resourcekey="Btn_Continue"
                                        onclick="goForwardToNextPanel(); return false;"
                                        runat="server"
                                        type="button" />
                                    <!-- hiding save button while we decide if it stays or goes away -->
                                    <asp:Button
                                        CssClass="btn btn-primary"
                                        ID="btnSave"
                                        meta:Resourcekey="Btn_Save"
                                        runat="server"
                                        Visible="false" />
                                    <asp:Button
                                        CssClass="btn btn-primary hidden"
                                        ID="btnSubmit"
                                        meta:Resourcekey="Btn_Submit"
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

                                function foreignAddressCheckboxChanged() {
                                    var foreign = $("#<%= chkblnForeignAddress.ClientID %>").prop("checked");

                                    var countryGroup = $("#<% = LUCDetails.FindControl("countryGroup").ClientID %>");

                                    var regionGroup = $("#<% = LUCDetails.FindControl("regionGroup").ClientID %>");
                                    var rayonGroup = $("#<% = LUCDetails.FindControl("rayonGroup").ClientID %>");
                                    var townGroup = $("#<% = LUCDetails.FindControl("townGroup").ClientID %>");
                                    var streetGroup = $("#<% = LUCDetails.FindControl("streetGroup").ClientID %>");

                                    var buildingHouseApartmentGroup = $("#<% = LUCDetails.FindControl("buildingHouseApartmentGroup").ClientID %>");
                                    $('.addressType').hide();
                                    //if (foreign) {
                                    //    $('#foreignAddressType').show();
                                    //    regionGroup.addClass("hidden");
                                    //    rayonGroup.addClass("hidden");
                                    //    townGroup.addClass("hidden");
                                    //    streetGroup.addClass("hidden");
                                    //    buildingHouseApartmentGroup.addClass("hidden");
                                    //    countryGroup.removeClass("hidden");
                                    //}
                                    //else {
                                    //    $('#foreignAddressType').hide();
                                    //    regionGroup.removeClass("hidden");
                                    //    rayonGroup.removeClass("hidden");
                                    //    townGroup.removeClass("hidden");
                                    //    streetGroup.removeClass("hidden");
                                    //    buildingHouseApartmentGroup.removeClass("hidden");
                                    //    countryGroup.removeClass("hidden");
                                    //}
                                 if (foreign) {
                                     $('#foreignAddressType').show();
                                   //  regionGroup.addClass("hidden");
                                   //  rayonGroup.addClass("hidden");
                                   //  townGroup.addClass("hidden");
                                  //   streetGroup.addClass("hidden");
                                  //   buildingHouseApartmentGroup.addClass("hidden");
                                     countryGroup.removeClass("hidden");
                                 }
                                 else {
                                     $('#foreignAddressType').hide();
                                     regionGroup.removeClass("hidden");
                                     rayonGroup.removeClass("hidden");
                                     townGroup.removeClass("hidden");
                                     streetGroup.removeClass("hidden");
                                     buildingHouseApartmentGroup.removeClass("hidden");
                                     countryGroup.removeClass("hidden");
                                 }


                                }
                            </script>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
