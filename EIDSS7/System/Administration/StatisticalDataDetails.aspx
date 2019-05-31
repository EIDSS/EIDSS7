<%@ Page Title="Statisical Data Details (C13)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" 
    CodeBehind="StatisticalDataDetails.aspx.vb" Inherits="EIDSS.StatisticalDataDetails" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
 <%--   <asp:UpdateProgress runat="server">
        <ProgressTemplate>
            <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                <div class="modal-content">
                    <div class="modal-body">
                        <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress> --%>
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
                            <%--<div class="row">
                                <asp:ValidationSummary DisplayMode="BulletList" EnableClientScript="true" runat="server" ValidationGroup="StatisticalDataSection" />
                            </div>--%>
                            <div class="row">
                                <div class="sectionContainer expanded">
                                    <section id="StatisticalDataSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 meta:resourcekey="Hdg_Statistical_Data" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">                                                
                                                <div class="form-group" meta:resourcekey="Dis_Statistical_Data_Type" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Statistical_Data_Type"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlidfsStatisticDataType"
                                                        ID="lblStatisticalDataType"
                                                        meta:ResourceKey="Lbl_Statistical_Data_Type"
                                                        runat="server"></asp:Label>
                                                    <asp:DropDownList
                                                        AppendDataBoundItems="true"
                                                        AutoPostBack="true"
                                                        CssClass="form-control"
                                                        ID="ddlidfsStatisticDataType"
                                                        runat="server">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfsStatisticDataType"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Statistical_Data_Type"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="statisticalPeriodTypeContainer" meta:resourcekey="Dis_Statistical_Period_Type" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtsetnPeriodTypeName"
                                                        ID="lblStatisticalPeriodType"
                                                        meta:ResourceKey="Lbl_Statistical_Period_Type"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtsetnPeriodTypeName"
                                                        ReadOnly="true"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtsetnPeriodTypeName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Statistical_Period_Type"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="statisticalPeriodStartDateContainer" meta:resourcekey="Dis_Statistical_Date_for_Period" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtdatStatisticStartDate"
                                                        ID="lblStatisticalDateforPeriod"
                                                        meta:ResourceKey="Lbl_Statistical_Date_for_Period"
                                                        runat="server"></asp:Label>
                                                    <eidss:CalendarInput   ID="txtdatStatisticStartDate"
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                         runat="server"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator  ID="valDay"
                                                        ControlToValidate="txtdatStatisticStartDate"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Statistical_Date_for_Period"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="areaTypeContainer" meta:resourcekey="Dis_Statistical_Area_Type" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtsetnAreaTypeName"
                                                        ID="lblStatisticalAreaType"
                                                        meta:ResourceKey="Lbl_Statistical_Area_Type"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtsetnAreaTypeName"
                                                        ReadOnly="true"
                                                        runat="server"></asp:TextBox>
 <%--                                                   <asp:Label
                                                        AssociatedControlID="ddlsetnAreaTypeName"
                                                        ID="lblStatisticalAreaType"
                                                        meta:ResourceKey="Lbl_Statistical_Area_Type"
                                                        runat="server"></asp:Label>
                                                  <asp:DropDownList
                                                        AppendDataBoundItems="true"
                                                        AutoPostBack="true"
                                                        CssClass="form-control"
                                                        ID="ddlsetnAreaTypeName"
                                                        runat="server">
                                                    </asp:DropDownList>--%>



                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtsetnAreaTypeName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Statistical_Area_Type"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <eidss:LocationUserControl
                                                    ID="LocationUserControl"
                                                    runat="server"
                                                    ShowBuildingHouseApartmentGroup="false"
                                                    ShowCoordinates="false"
                                                    ShowPostalCode="false"
                                                    ShowStreet="false"
                                                    ShowTownOrVillage="false" 
                                                    ValidationGroup="StatisticalDataSection"/>
                                                <div class="form-group" id="valueContainer" meta:resourcekey="Dis_Value" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtvarValue"
                                                        ID="lblValue"
                                                        meta:ResourceKey="Lbl_Value"
                                                        runat="server"></asp:Label>
                                                    <eidss:NumericSpinner
                                                        CssClass="form-control"
                                                        ID="txtvarValue"
                                                        runat="server"></eidss:NumericSpinner>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtvarValue"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Value"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="ageGroupContainer" meta:resourcekey="Dis_Statistical_Age_Group" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="ddlidfsStatisticalAgeGroup"
                                                        ID="lblStatisticalAgeGroup"
                                                        meta:ResourceKey="Lbl_Statistical_Age_Group"
                                                        runat="server"></asp:Label>
                                                    <asp:DropDownList
                                                        CssClass="form-control"
                                                        ID="ddlidfsStatisticalAgeGroup"
                                                        runat="server">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfsStatisticalAgeGroup"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Statistical_Age_Group"
                                                        runat="server"                                                        
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="parameterTypeContainer" meta:resourcekey="Dis_Parameter_Type" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtParameterType"
                                                        ID="lblParameterType"
                                                        meta:ResourceKey="Lbl_Parameter_Type"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox
                                                        CssClass="form-control"
                                                        ID="txtParameterType"
                                                        ReadOnly="true"
                                                        runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ID="rfvParameterType"
                                                        ControlToValidate="txtParameterType"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Parameter_Type"
                                                        runat="server"                                                        
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" id="parameterNameContainer" meta:resourcekey="Dis_Parameter" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="ddlidfsParameterName"
                                                        ID="lblParameter"
                                                        meta:ResourceKey="Lbl_Parameter"
                                                        runat="server"></asp:Label>
                                                    <asp:DropDownList
                                                        CssClass="form-control"
                                                        ID="ddlidfsParameterName"
                                                        runat="server">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfsParameterName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Parameter"
                                                        runat="server"
                                                        ValidationGroup="StatisticalDataSection"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                                <%--fields the are not on form but are required to save--%>

                                                <asp:HiddenField runat="server" Value="" ID="hdfLangID" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfStatistic" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfStatisticDataType" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfNewStatisticID" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfsMainBaseReference" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfsStatisticPeriodType" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfsStatisticAreaType" />
                                                <asp:HiddenField runat="server" Value="null" ID="hdfidfsParameterType" />

                                                <asp:HiddenField runat="server" Value="0" ID="hdfUser" />
                                            </div>
                                        </div>
                                    </section>
                                </div>
                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            ID="sideBarItemStatisticalData"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Statistical_Data"
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
                                        onclick="location.replace('StatisticalDataAdmin.aspx')"
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
                                        meta:ResourceKey="Btn_Save"
                                        runat="server"
                                        Visible="false" />
                                    <asp:Button
                                        CssClass="btn btn-primary hidden"
                                        ID="btnSubmit"
                                        meta:ResourceKey="Btn_Submit"
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
