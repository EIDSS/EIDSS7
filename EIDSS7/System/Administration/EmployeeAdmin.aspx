<%@ Page Title="Employee List (A08)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="EmployeeAdmin.aspx.vb" Inherits="EIDSS.EmployeeAdmin" EnableEventValidation="true" %>

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
                <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfidfEmployee" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfOrganizationFullName" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfidfInstitution" Value="NULL" />
                <asp:HiddenField runat="server" ID="hdfPosition" Value="NULL" />
            </div>
            <%-- End: Hidden Fields --%>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %>
                        <button id="btnOpenModal" type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#searchModal">
                            <span class="glyphicon glyphicon-search text-right-20"></span>&nbsp;
                        <span><%=GetLocalResourceObject("Btn_Search.Text") %></span>
                        </button>
                        &nbsp;
                    <button id="btnNew" type="submit" runat="server" class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;
                        <span><%= GetLocalResourceObject("Btn_New_Employee.Text")  %></span>
                    </button>
                    </h2>
                </div>


              <div id="deleteEmployee" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Employee_Admin"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblDeleteEmployee" runat="server" meta:resourcekey="lbl_Delete_Employee"></p>
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

                <div class="table-responsive">
                    <asp:UpdatePanel runat="server" ID="upEmployeeList">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" />
                        </Triggers>
                        <ContentTemplate>
                            <eidss:GridView
                                AllowPaging="false"
                                AllowSorting="true"
                                AutoGenerateColumns="false"
                                CaptionAlign="Top"
                                CssClass="table table-striped table-hover"
                                DataKeyNames="idfEmployee,strOrganizationId,idfInstitution,idfPosition"
                                GridLines="None"
                                ID="gvEmployeeList"
                                meta:Resourcekey="Grd_Employee_List"
                                EmptyDataText="<%$ Resources:Lbl_Employee_List.Empty %>"
                                runat="server"
                                ShowFooter="false"
                                ShowHeader="true"
                                UseAccessibleHeader="true"
                                OnRowDeleting="gvEmployeeList_RowDeleting">
                                <HeaderStyle CssClass="table-striped-header" />
                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                <SortedAscendingHeaderStyle CssClass="" />
                                <SortedDescendingHeaderStyle CssClass="" />
                                <SortedAscendingCellStyle CssClass="" />
                                <SortedDescendingCellStyle CssClass="" />
                                <Columns>
                                    <%--Key Fields--%>
                                    <asp:BoundField DataField="idfEmployee" Visible="false" />
                                    <asp:BoundField DataField="strOrganizationId" Visible="false" />
                                    <asp:BoundField DataField="idfInstitution" Visible="false" />
                                    <asp:BoundField DataField="idfPosition" Visible="false" />

                                    <%--Show this column only if using this page to select a Facility/Person Name   --%>
                                    <asp:CommandField
                                        AccessibleHeaderText=""
                                        ControlStyle-CssClass="btn glyphicon glyphicon-hand-up"
                                        SelectText=""
                                        ShowSelectButton="true" />

                                    <%--Fields to display--%>
                                    <asp:BoundField
                                        DataField="strFamilyName"
                                        HeaderText="<%$ Resources:Grd_Family_Name_Heading %>"
                                        SortExpression="strFamilyName" />
                                    <asp:BoundField
                                        DataField="strFirstName"
                                        HeaderText="<%$ Resources:Grd_First_Name_Heading %>"
                                        SortExpression="strFirstName" />
                                    <asp:BoundField
                                        DataField="Organization"
                                        HeaderText="<%$ Resources: Grd_Organization_Heading %>"
                                        SortExpression="Organization" />
                                    <asp:BoundField
                                        DataField="OrganizationFullName"
                                        HeaderText="<%$ Resources:Grd_Organization_Full_Name_Heading %>"
                                        SortExpression="OrganizationFullName" />
                                    <asp:BoundField
                                        DataField="Position"
                                        HeaderText="<%$ Resources:Grd_Position_Heading %>"
                                        SortExpression="Position" />

                                    <asp:BoundField
                                        DataField="strContactPhone"
                                        HeaderText="<%$ Resources:Grd_Phone_Heading %>"
                                        SortExpression="strContactPhone" />

                                    <asp:CommandField
                                        AccessibleHeaderText="<%$ Resources:Grd_Edit_Button_Text %>"
                                        ControlStyle-CssClass="btn glyphicon glyphicon-edit"
                                        EditText=""
                                        ShowEditButton="true" />
                                      <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                         <ItemTemplate>
                                             <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Employee" 
                                                  CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                          </ItemTemplate>
                                      </asp:TemplateField>



                                </Columns>
                            </eidss:GridView>
                            <ul class="pagination" style="float:right">
                                <asp:Repeater ID="rptPageSection" runat="server">
                                    <ItemTemplate>
                                        <li class="page-item">
                                            <asp:LinkButton ID="lnkPage" runat="server" CssClass="page-link" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed"></asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="searchUpdatePanel" runat="server">
        <ContentTemplate>
            <div id="divHiddenFieldsEAtoHDRResponse" runat="server" class="row embed-panel" visible="false">
                <asp:HiddenField runat="server" ID="hdfEAEmployeeId" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEAEmployeeFullName" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEAFirstName" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEAPatronymicName" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEALastName" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEAInstitutionId" Value="null" />
                <asp:HiddenField runat="server" ID="hdfEAInstitutionFullName" Value="null" />
                <asp:HiddenField runat="server" ID="hdfstrContactPhone" Value="null" />
            </div>            
            <div class="modal fade" id="searchModal" role="dialog">
                <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                <asp:HiddenField runat="server" ID="hdfPageIndex" Value="1" />
                <asp:HiddenField runat="server" ID="hdfPageSize" Value="10" />
                <asp:HiddenField runat="server" ID="hdfRecordCount" Value="0" />

                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title" id="HdgSearchTitle" meta:resourcekey="Hdg_Search_Title" runat="server"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group" id="PositionContainer" meta:resourcekey="Dis_Position" runat="server">
                                <asp:Label
                                    AssociatedControlID="ddlidfPosition"
                                    meta:Resourcekey="Lbl_Position"
                                    runat="server"></asp:Label>
                                <asp:DropDownList runat="server" ID="ddlidfPosition" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="ddlidfPosition"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_Position"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group" id="FamilyNameContainer" meta:resourcekey="Dis_Family_Name" runat="server">
                                <asp:Label
                                    AssociatedControlID="txtstrFamilyName"
                                    meta:resourcekey="Lbl_Family_Name"
                                    runat="server"></asp:Label>
                                <asp:TextBox runat="server" ID="txtstrFamilyName" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtstrFamilyName"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_FamilyName"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group" id="FirstNameContainer" meta:resourcekey="Dis_First_Name" runat="server">
                                <asp:Label
                                    AssociatedControlID="txtstrFirstName"
                                    meta:resourcekey="Lbl_First_Name"
                                    runat="server"></asp:Label>
                                <asp:TextBox runat="server" ID="txtstrFirstName" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtstrFirstName"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_First_Name"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group" id="MiddleNameContainer" meta:resourcekey="Dis_Middle_Name" runat="server">
                                <asp:Label
                                    AssociatedControlID="txtstrSecondName"
                                    meta:resourcekey="Lbl_Second_Name"
                                    runat="server"></asp:Label>
                                <asp:TextBox runat="server" ID="txtstrSecondName" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtstrSecondName"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_Second_Name"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group" id="OrganizationContainer" meta:resourcekey="Dis_Organization" runat="server">
                                <asp:Label
                                    AssociatedControlID="ddlOrganization"
                                    meta:resourcekey="Lbl_Organization"
                                    runat="server"></asp:Label>
                                <asp:DropDownList ID="ddlOrganization" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="ddlOrganization"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_Organization"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group" id="UniqueIdContainer" meta:resourcekey="Dis_Unique_Organization_ID" runat="server">
                                <asp:Label
                                    AssociatedControlID="txtstrOrganizationID"
                                    meta:resourcekey="Lbl_Organization_Unique_Id"
                                    runat="server"></asp:Label>
                                <asp:TextBox runat="server" ID="txtstrOrganizationID" CssClass="form-control" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtstrOrganizationID"
                                    CssClass=""
                                    Display="Dynamic"
                                    meta:resourcekey="Val_Unique_Organization_ID"
                                    runat="server"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button
                                runat="server"
                                ID="btnClear"
                                CssClass="btn btn-default"
                                meta:resourcekey="Btn_Clear"
                                OnClientClick="$('#searchModal').modal('toggle');" />

                            <asp:Button
                                CssClass="btn btn-default"
                                ID="btnSearch"
                                meta:resourcekey="Btn_Search"
                                OnClientClick="$('#searchModal').modal('toggle');"
                                OnClick="btnSearch_Click"
                                runat="server" />
                        </div>







                    </div>
                </div>
            </div>
            <script type="text/javascript">
                
                function showModal(modalPopup){
                    var p = '#' + modalPopup;
                    debugger
                    $(p).modal({show: true, backdrop: 'static'});
                }

                function hideModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal('hide');
                }
            </script>


        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>