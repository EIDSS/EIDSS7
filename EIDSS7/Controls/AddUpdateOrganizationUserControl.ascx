<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateOrganizationUserControl.ascx.vb" Inherits="EIDSS.AddUpdateOrganizationUserControl" %>

<%@ Register Src="HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:UpdatePanel ID="upAddUpdateOrganization" runat="server">
    <Triggers>
        <asp:PostBackTrigger ControlID="btnSubmit" />
<%--        <asp:AsyncPostBackTrigger ControlID="rdbForeignAddressNo" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbForeignAddressYes" EventName="CheckedChanged" />--%>
<%--        <asp:AsyncPostBackTrigger ControlID="gvDepartmentList" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="gvDepartmentList" EventName="Sorting" />--%>
        <asp:PostBackTrigger ControlID="btnCancelYes" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" visible="false">
            <asp:HiddenField ID="hdfForeignAddress" runat="server" Value="False" />
            <asp:HiddenField ID="hdfDepartmentSelectView" runat="server" Value="Label" />
        </div>
        <div class="panel panel-default">
            <div class="row">
                <div class="col-md-12">
                    <p><%= GetLocalResourceObject("Page_Text_1") %></p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                    <% =GetGlobalResourceObject("OtherText", "Pln_Required_Text") %>
                </div>
            </div>
            <div class="panel-body">
                <div id="divOrganizationForm" runat="server" class="row embed-panel">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="sectionContainer expanded">
                                <section id="OrganizationInformation" runat="server" class="col-md-12">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Organization_Information"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="divOrganizationID" runat="server" class="form-group">
                                                <div class="row">
                                                    <div class="col-md-6" runat="server" meta:resourcekey="Dis_Organization_ID">
                                                        <label for="txtEIDSSOrganizationID" runat="server" meta:resourcekey="Lbl_Organization_ID"></label>
                                                        <asp:TextBox ID="txtEIDSSOrganizationID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-md-6" runat="server" meta:resourcekey="Dis_Abbreviation">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Abbreviation" runat="server"></div>
                                                        <label for="txtAbbreviation" runat="server" meta:resourcekey="Lbl_Abbreviation"></label>
                                                        <asp:TextBox ID="txtAbbreviation" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtAbbreviation" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Abbreviation" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-md-6" meta:resourcekey="Dis_Organization_Name">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Organization_Name" runat="server"></div>
                                                        <label for="txtOrganizationName" runat="server" meta:resourcekey="Lbl_Organization_Name"></label>
                                                        <asp:TextBox ID="txtOrganizationName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtOrganizationName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Organization_Name" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Accessory_Code">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Accessory_Code" runat="server"></div>
                                                        <label for="ddlAccessoryCode" runat="server" meta:resourcekey="Lbl_Accessory_Code"></label>
                                                        <eidss:DropDownList ID="ddlAccessoryCode" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlAccessoryCode" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Accessory_Code" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Organization_Type">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Organization_Type" runat="server"></div>
                                                        <label for="ddlOrganizationType" runat="server" meta:resourcekey="Lbl_Organization_Type"></label>
                                                        <eidss:DropDownList ID="ddlOrganizationType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlOrganizationType" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Organization_Type" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Order">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Order" runat="server"></div>
                                                        <label for="txtOrderNumber" runat="server" meta:resourcekey="Lbl_Order"></label>
                                                        <eidss:NumericSpinner ID="txtOrderNumber" runat="server" ContainerCssClass="form-control" CssClass="form-control"></eidss:NumericSpinner>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtOrderNumber" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Order" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Gender">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Gender" runat="server"></div>
                                                        <label for="ddlidfsHumanGender" runat="server" meta:resourcekey="Lbl_Gender"></label>
                                                        <eidss:DropDownList ID="ddlidfsHumanGender" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlidfsHumanGender" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Gender" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Organization_Address"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <label runat="server" meta:resourcekey="Lbl_Foreign_Address"></label>
                                                    </div>
                                                </div>
                                                <asp:CheckBox ID="chkForeignAddress" runat="server" onchange="ForeignAddress_CheckBoxChanged()" />
                                            </div>
                                            <eidss:LocationUserControl ID="Location" runat="server" IsHorizontalLayout="true" ValidationGroup="OrganizationInformation" ShowCountry="false" ShowStreet="true" ShowElevation="false" IsDbRequiredCountry="true" IsDbRequiredRegion="true" IsDbRequiredRayon="true" />
                                            <div id="divForeignAddress" class="form-group" runat="server" meta:resourcekey="Dis_Foreign_Address" visible="false">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Foreign_Address" runat="server"></div>
                                                        <asp:Label AssociatedControlID="txtForeignAddressString" meta:resourcekey="Lbl_Foreign_Address" runat="server"></asp:Label>
                                                        <asp:TextBox CssClass="form-control" ID="txtForeignAddressString" runat="server" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtForeignAddressString" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Foreign_Address" runat="server" ValidationGroup="OrganizationInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="Departments" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 class="heading" runat="server" meta:resourcekey="Hdg_Departments"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <eidss:GridView ID="gvDepartments" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CaptionAlign="Top" CssClass="table table-striped table-hover" GridLines="None" DataKeyNames="DepartmentID,idfInstitution" ShowFooter="true" ShowHeader="true" ShowHeaderWhenEmpty="true" UseAccessibleHeader="true">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="" />
                                                    <SortedDescendingHeaderStyle CssClass="" />
                                                    <SortedAscendingCellStyle CssClass="" />
                                                    <SortedDescendingCellStyle CssClass="" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Name">
                                                            <ItemTemplate>
                                                                <div><%# Eval("DepartmentName") %></div>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                <asp:TextBox ID="txtDepartmentName" runat="server"></asp:TextBox>
                                                            </FooterTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnDeleteDepartment" runat="server" CommandArgument='<%# Eval("DepartmentName") %>' CommandName="DepartmentDelete" CssClass="btn glyphicon glyphicon-trash" />
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                <asp:LinkButton ID="btnAddDepartment" runat="server" CommandArgument="" CommandName="DepartmentsAdd" CssClass="btn glyphicon glyphicon-plus" />
                                                            </FooterTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField Visible="False">
                                                            <ItemTemplate><%# Eval("name") %></ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="txtDepartmentName" runat="server"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <asp:LinkButton CommandArgument="" CommandName="DepartmentsAddEmptyData" CssClass="btn glyphicon glyphicon-plus" ID="btnDepartmentAdd" runat="server"></asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                    </EmptyDataTemplate>
                                                </eidss:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <div class="col-md-12">
                                    <div id="divSelectablePreviewDepartmentList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Departments"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvDepartmentReviewList" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" DataKeyNames="DepartmentID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" meta:Resourcekey="Grd_Farm_List" CssClass="table table-striped" ShowHeaderWhenEmpty="true" ShowFooter="true" GridLines="None">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources: Grd_Department_List_Name_Heading %>">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblstrFarmCode" runat="server" Text='<%# Eval("strFarmCode") %>' Visible='<%# IIf(hdfDepartmentSelectView.Value = "Label", True, False) %>'></asp:Label>
                                                                <asp:LinkButton ID="btnView" runat="server" Text='<%# Eval("strFarmCode") %>' Visible='<%# IIf(hdfDepartmentSelectView.Value = "View", True, False) %>' CommandName="View" CommandArgument='<%# Eval("idfHumanActual").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <eidss:SideBarNavigation ID="OrganizationSideBar" runat="server">
                                <MenuItems>
                                    <eidss:SideBarItem ID="sbiOrganizationInformation" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsNormal" meta:resourcekey="Tab_Organizatioj_Information" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit')" />
                                    <eidss:SideBarItem ID="sbiDepartments" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsNormal" meta:resourcekey="Tab_Departments" GoToSideBarSection="1, document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit')" />
                                    <eidss:SideBarItem ID="sbiOrganizationReview" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsReview" meta:resourcekey="Tab_Organization_Review" GoToSideBarSection="3, document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit')" />
                                </MenuItems>
                            </eidss:SideBarNavigation>
                        </div>
                        <div class="row">
                            <div class="col-lg-8 col-md-8 col-sm-7 col-xs-7 text-center">
                                <div class="modal-footer text-center">
                                    <button id="btnCancel" type="button" class="btn btn-default" runat="server" data-toggle="modal" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-target="#divOrganizationCancelModal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                                    <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                    <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_hdfOrganizationPanelController'), document.getElementById('OrganizationSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_divOrganizationForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateOrganization_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                    <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" CausesValidation="true" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divOrganizationCancelModal" class="modal" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="panel-warning alert alert-warning">
                    <div class="panel-heading">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="alert-link" runat="server" meta:resourcekey="Hdg_Cancel_Organization"></h4>
                    </div>
                    <div class="panel-body">
                        <p runat="server" meta:resourcekey="Lbl_Cancel_Organization"></p>
                    </div>
                    <div class="form-group text-center">
                        <asp:Button ID="btnCancelYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" OnClientClick="$('#divOrganizationCancelModal').modal('hide');" CausesValidation="false" />
                        <button type="button" runat="server" class="btn btn-warning alert-link" data-dismiss="modal" title="<%$ Resources: Buttons, Btn_No_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField runat="server" Value="0" ID="hdfOrganizationPanelController" />
    </ContentTemplate>
</asp:UpdatePanel>
