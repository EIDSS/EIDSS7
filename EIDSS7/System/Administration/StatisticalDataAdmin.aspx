<%@ Page Title="Statistical Data (C12)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="StatisticalDataAdmin.aspx.vb" Inherits="EIDSS.StatisticalDataAdmin" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
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
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %>
                    <button id="btnOpenModal" class="btn btn-primary btn-sm" type="button" data-toggle="modal" data-target="#searchModal" onclick="isModalShown = true;">
                        <span class="glyphicon glyphicon-search text-right-20" aria-hidden="true"></span>&nbsp;
                        <span><%=GetLocalResourceObject("Btn_Search.Text") %></span>
                    </button>
                    &nbsp;
                    <button id="btnNew" runat="server" type="submit" class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;
                        <span><%= GetLocalResourceObject("Btn_New.Text") %></span>
                    </button>
                        </h2>
                </div>

                <div class="table-responsive">
                    <asp:UpdatePanel runat="server" ID="upStatisticalDataList">
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
                                DataKeyNames="idfStatistic,idfsStatisticDataType,idfsStatisticAreaType,idfsStatisticalAgeGroup"
                                GridLines="None"
                                ID="gvStatisticalDataList"
                                meta:ResourceKey="Grd_Statistical_List"
                                EmptyDataText="<%$ Resources:Lbl_Statistical_List.Empty %>"
                                OnSorting="gvStatisticalDataList_Sorting"
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
                                    <asp:BoundField DataField="idfStatistic" Visible="false" /> 
                                    <asp:BoundField DataField="idfsStatisticDataType" Visible="false" />                             
                                    <asp:BoundField DataField="varValue" HeaderStyle-CssClass="dragtable-drag-handle" HeaderText="<%$ Resources:Grd_Value_Heading %>" SortExpression="varValue"/>                                        
                                    <asp:BoundField DataField="strStatisticalAgeGroup" HeaderText="<%$ Resources:Grd_Statistical_Age_Group_Heading %>" SortExpression="strStatisticalAgeGroup"/>
                                    <asp:BoundField DataField="ParameterType" HeaderText="<%$ Resources:Grd_Parameter_Type_Heading %>" SortExpression="ParameterType"/>
                                    <asp:BoundField DataField="setnParameterName" HeaderText="<%$ Resources:Grd_Parameter_Heading %>" SortExpression="setnParameterName"/>
                                    <asp:BoundField DataField="setnPeriodTypeName" HeaderText="<%$ Resources:Grd_Statistical_Period_Type__Heading %>" SortExpression="setnPeriodTypeName"/>
                                    <asp:BoundField DataField="datStatisticStartDate" HeaderText="<%$ Resources:Grd_Start_Date_Heading %>" SortExpression="datStatisticStartDate"/>
                                    <asp:BoundField DataField="setnAreaTypeName" HeaderText="<%$ Resources:Grd_Statisical_Area_Type_Heading %>" SortExpression="setnAreaTypeName"/>
                                    <asp:BoundField DataField="setnArea" HeaderText="<%$ Resources:Grd_Area_Heading %>" SortExpression="setnArea"/>
                                    <asp:CommandField ShowEditButton="true" ControlStyle-CssClass="btn glyphicon glyphicon-edit" EditText="" AccessibleHeaderText="<%$ Resources:Buttons, Btn_Edit_Text %>" />
                                    <asp:CommandField ShowDeleteButton="true" ControlStyle-CssClass="btn glyphicon glyphicon-trash" DeleteText="" AccessibleHeaderText="<%$ Resources:Buttons, Btn_Delete_Text %>" />
                                </Columns>
                            </eidss:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <asp:UpdatePanel runat="server" ID="SearchUpdatePanel">
                    <ContentTemplate>
                        <%-- Hidden Fields --%>
                        <div runat="server" id="divHiddenFieldsSection" >
                            <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                            <asp:HiddenField runat="server" ID="hdfidfStatistic" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfStatisticalDataType" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfidfsArea" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfStatisticalStartDate" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfStatisticalStartDateFrom" Value="null" />
                            <asp:HiddenField runat="server" ID="hdfStatisticalStartDateTo" Value="null" />
                        </div>
                <div class="modal fade" id="searchModal" role="dialog">
                    <asp:HiddenField runat="server" ID="hdfLangID" Value="null" />
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title" meta:resourcekey="Hdg_Search" runat="server"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group" meta:resourcekey="Dis_Statistical_Data_Type" runat="server">
                                    <asp:Label
                                        AssociatedControlID="ddlidfsStatisticalDataType"
                                        ID="lblStatisticalDataType"
                                        meta:ResourceKey="Lbl_Statistical_Data_Type"
                                        runat="server"/>
                                    <asp:DropDownList
                                        AppendDataBoundItems="true"
                                        AutoPostBack="false"
                                        CssClass="form-control"
                                        ID="ddlidfsStatisticalDataType"
                                        runat="server">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator
                                        ControlToValidate="ddlidfsStatisticalDataType"
                                        CssClass=""
                                        Display="Dynamic"
                                        meta:resourcekey="Val_Statistical_Data_Type"
                                        runat="server"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" meta:resourcekey="Dis_Start_Date_for_Period" runat="server">
                                    <asp:Label
                                        ID="lblStartDateforPeriod"
                                        meta:ResourceKey="Lbl_Start_Date_for_Period"
                                        runat="server"/>
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6">
                                            <asp:Label
                                                AssociatedControlID="txtdatStatisticStartDateFrom"
                                                ID="lblStartDateforFrom"
                                                meta:ResourceKey="Lbl_Start_Date_From"
                                                runat="server"/>
                                            <eidss:CalendarInput
                                                ContainerCssClass="input-group datepicker"
                                                CssClass="form-control"
                                                ID="txtdatStatisticStartDateFrom"
                                                runat="server"></eidss:CalendarInput>                                            
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtdatStatisticStartDateFrom"
                                                CssClass=""
                                                Display="Dynamic" 
                                                meta:resourcekey="Val_Start_Date_From"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-lg-6 col-md-6">
                                            <asp:Label
                                                AssociatedControlID="txtdatStatisticStartDateTo"
                                                ID="lblStartDateforTo"
                                                meta:ResourceKey="Lbl_Start_Date_To"
                                                runat="server"/>
                                            <eidss:CalendarInput
                                                ContainerCssClass="input-group datepicker"
                                                CssClass="form-control"
                                                ID="txtdatStatisticStartDateTo"
                                                runat="server"></eidss:CalendarInput>
                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtdatStatisticStartDateTo"
                                                CssClass=""
                                                Display="Dynamic" 
                                                meta:resourcekey="Val_Start_Date_To"
                                                runat="server"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                                <eidss:LocationUserControl 
                                    ID="LocationUserControl" 
                                    runat="server"
                                    ShowCountry="false" 
                                    ShowBuildingHouseApartmentGroup="false" 
                                    ShowCoordinates="false" 
                                    ShowPostalCode="false" 
                                    ShowStreet="false" />
                            </div>
                            <div class="modal-footer" >
                                <asp:Button
                                    runat="server"
                                    ID="btnClear"
                                    class="btn btn-default"
                                    meta:resourcekey="Btn_Clear"
                                    OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;" />
                                <asp:Button
                                    CssClass="btn btn-default"
                                    ID="btnSearch"
                                    meta:ResourceKey="Btn_Search"
                                    OnClientClick="$('#searchModal').modal('toggle'); isModalShown = false;"
                                    OnClick="btnSearch_Click"
                                    runat="server" />
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
