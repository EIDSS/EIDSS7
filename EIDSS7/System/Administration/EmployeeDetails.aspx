<%@ Page Title="Employee Details" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master"
    CodeBehind="EmployeeDetails.aspx.vb" Inherits="EIDSS.EmployeeDetails" %>

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
    <asp:UpdatePanel runat="server" ID="upEmployeeList">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
        <ContentTemplate>
            <div class="container-fluid">
                <%--Begin: Hidden fields--%>
                <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                    <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                    <asp:HiddenField runat="server" ID="hdfidfEmployee" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfNewUserID" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfsSite" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrBarcode" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfPerson" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfPersonNewID" Value="0" />
                    <asp:HiddenField runat="server" ID="hdfUser" Value="0" />
                    <asp:HiddenField runat="server" ID="fldbonPassword" Value="NULL" />
                </div>
                <%-- End: Hidden Fields --%>

                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %></h2>
                        </div>

                        <div class="panel-body">
                            <div class="row">
                                <div class="sectionContainer expanded">
                                    <section id="PersonalInformationSection" runat="server" class="col-md-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Heading_Personal_Info" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group" meta:resoucekey="Dis_First_Name" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrFirstName"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_First_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox CssClass="form-control" runat="server" ID="txtstrFirstName"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrFirstName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_First_Name"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Second_Name" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Second_Name"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrSecondName"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Second_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox CssClass="form-control" runat="server" ID="txtstrSecondName"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrSecondName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Second_Name"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Family_Name" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrFamilyName"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Family_Name"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox CssClass="form-control" runat="server" ID="txtstrFamilyName"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrFamilyName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Family_Name"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Organization" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="ddlidfInstitution"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Organization"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList CssClass="form-control" AutoPostBack="True" ID="ddlidfInstitution" runat="server" AddPageUrl="" PopUpWindowId="employeePopUpDialog" SearchPageUrl=""></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfInstitution"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Organization"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Department" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Department"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="ddlidfDepartment"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Department"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList CssClass="form-control" ID="ddlidfDepartment" runat="server" AddPageUrl="" PopUpWindowId="employeePopUpDialog" SearchPageUrl=""></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfDepartment"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Department"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Position" runat="server">
                                                    <div class="glyphicon glyphicon-asterisk alert-danger"
                                                        meta:resourcekey="Req_Position"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="ddlidfsStaffPosition"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Position"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList CssClass="form-control" ID="ddlidfsStaffPosition" runat="server" AddPageUrl="" PopUpWindowId="employeePopUpDialog" SearchPageUrl=""></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfsStaffPosition"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Position"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Phone" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrContactPhone"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Phone"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox CssClass="form-control" runat="server" ID="txtstrContactPhone"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrContactPhone"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Phone"
                                                        runat="server"
                                                        ValidationGroup="PersonalInformationSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="panel-footer">
                                                </div>
                                            </div>
                                        </div>
                                    </section>

                                    <section id="LoginSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Hdg_Login" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group" meta:resourcekey="Dis_Login" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtstrAccountName"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Login"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtstrAccountName"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrAccountName"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Login"
                                                        runat="server"
                                                        ValidationGroup="LoginSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Password" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger" id="iconBinPass" runat="server"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtPassword"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Password"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtPassword"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtPassword"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Password"
                                                        runat="server"
                                                        ID="rfvbinPassword"
                                                        ValidationGroup="LoginSection"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Confirm_Password" runat="server">
                                                    <div class="glyphicon glyphicon-certificate alert-danger" id="iconPassConfirm" runat="server"></div>
                                                    <asp:Label
                                                        AssociatedControlID="txtPasswordConfirm"
                                                        CssClass="control-label"
                                                        meta:resourcekey="Lbl_Confirm_Password"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtPasswordConfirm"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtPasswordConfirm"
                                                        CssClass="alert-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Confirm_Password"
                                                        runat="server"
                                                        ID="rfvPasswordConfirm"
                                                        ValidationGroup="LoginSection"></asp:RequiredFieldValidator>

                                                </div>
                                                <div class="form-group">
                                                    <!-- this form group on purspose left blank -->
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                            </div>
                                        </div>
                                    </section>

                                    <section id="GroupsSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Hdg_Groups" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(2)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="col-md-12">
                                                        <asp:UpdatePanel runat="server">
                                                            <ContentTemplate>
                                                                <asp:GridView
                                                                    AllowPaging="false"
                                                                    AllowSorting="true"
                                                                    AutoGenerateColumns="false"
                                                                    CaptionAlign="Top"
                                                                    CssClass="table table-striped table-hover"
                                                                    DataKeyNames="idfEmployeeGroup,idfsEmployeeGroupName,strName,strDescription"
                                                                    ID="gvEmployeeDetailsGroup"
                                                                    meta:ResourceKey="Grd_Groups"
                                                                    GridLines="None"
                                                                    runat="server"
                                                                    ShowFooter="false"
                                                                    ShowHeader="true"
                                                                    UseAccessibleHeader="true">
                                                                    <Columns>
                                                                        <%--Fields to display--%>

                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                                <asp:Label
                                                                                    ID="lblObjectGroupNameLabel"
                                                                                    meta:ResourceKey="Grd_Name_Heading"
                                                                                    runat="server" />
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblObjectGroupName" runat="server" Text='<%# Eval("strName") %>' />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>

                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                                <asp:Label
                                                                                    ID="lblCreate"
                                                                                    meta:ResourceKey="Lbl_Create"
                                                                                    runat="server" />
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:CheckBox ID="chkCreate" runat="server" Checked='<%# Eval("chkExists") %>' onclick="gvCheckBoxClick(this,'GRP');" />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                                <asp:HiddenField runat="server" Value="" ID="fldGrpCheckList" />
                                            </div>
                                        </div>
                                    </section>

                                    <section id="SystemFunctionsSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-md-9">
                                                        <h3 class="heading" meta:resourcekey="Hdg_System_Functions" runat="server"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(3)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="col-md-12">
                                                    <asp:GridView
                                                        AllowPaging="false"
                                                        AllowSorting="true"
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped table-hover"
                                                        DataKeyNames="idfsObjectType,idfsObjectTypeName,idfsObjectId,CidfObjectAccess,CidfsObjectOperation,CFlag,RidfObjectAccess,RidfsObjectOperation,RFlag,WidfObjectAccess,WidfsObjectOperation,WFlag,DidfObjectAccess,DidfsObjectOperation,DFlag,EidfObjectAccess,EidfsObjectOperation,EFlag,AidfObjectAccess,AidfsObjectOperation,AFlag"
                                                        GridLines="None"
                                                        ID="gvSystemFunctions"
                                                        meta:resourcekey="Grd_System_Functions"
                                                        runat="server"
                                                        ShowFooter="false"
                                                        ShowHeader="true"
                                                        UseAccessibleHeader="true">
                                                        <PagerStyle CssClass="table-footer" />
                                                        <Columns>

                                                            <%--Fields to display--%>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblObjectOperationNameLabel"
                                                                        meta:ResourceKey="Lbl_Operation_Name"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblObjectOperationName" runat="server" Text='<%# Eval("idfsObjectTypeName") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblCreate"
                                                                        meta:ResourceKey="Lbl_Create"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkCreate" runat="server" Checked='<%#IIf(Eval("CFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("CidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblRead"
                                                                        meta:ResourceKey="Lbl_Read"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkRead" runat="server" Checked='<%#IIf(Eval("RFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("RidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblWrite"
                                                                        meta:ResourceKey="Lbl_Write"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkWrite" runat="server" Checked='<%#IIf(Eval("WFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("WidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblDelete"
                                                                        meta:ResourceKey="Lbl_Delete"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkDelete" runat="server" Checked='<%#IIf(Eval("DFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("DidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblExecute"
                                                                        meta:ResourceKey="Lbl_Execute"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkExecute" runat="server" Checked='<%#IIf(Eval("EFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("EidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <asp:Label
                                                                        ID="lblAccessToPersonalData"
                                                                        meta:ResourceKey="Lbl_Access_To_Personal_Data"
                                                                        runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkAccessToPersonalData" runat="server" Checked='<%#IIf(Eval("AFlag") & "" = "2", True, False)%>' Visible='<%#IIf(Eval("AidfsObjectOperation") & "" = "", False, True)%>' onclick="gvCheckBoxClick(this,'OA');" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>

                                                    </asp:GridView>
                                                </div>
                                            </div>
                                            <div class="panel-footer">
                                                <asp:HiddenField runat="server" Value="" ID="fldOAChkList" />
                                            </div>
                                        </div>
                                    </section>
                                </div>
                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            ID="sideBarItemEmployee"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Personal_Info"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="1"
                                            ID="sideBarItemLogin"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Login"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="2"
                                            ID="sideBarItemGroups"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_Groups"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="3"
                                            ID="sideBarItemFunctions"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="Tab_System_Functions"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-file"
                                            GoToTab="4"
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
                                        onclick="location.replace('EmployeeAdmin.aspx')"
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
                            <eidss:PopUpDialog ID="employeePopUpDialog" runat="server" ShowModalHeader="true" ModalTitle="test" ShowModalFooter="true" />

                            <script type="text/javascript">
                                $(document).ready(function () {
                                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                                    setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
                                });

                                function callBackHandler() {
                                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                                };

                                function gvCheckBoxClick(chk, _for) {

                                    var chkList
                                    if (_for == "OA") {
                                        chkList = document.getElementById('<%= fldOAchkList.ClientID %>');
                                    }
                                    else {
                                        chkList = document.getElementById('<%= fldGrpCheckList.ClientID %>');
                                    };

                                    var stringToAdd = chk.id + ";" + chk.checked;

                                    if (chkList != undefined) {
                                        var chkListArray = chkList.value.split("|");
                                        var i = chkListArray.indexOf(chk.id + ";" + !chk.checked);
                                        if (i != -1) {
                                            chkListArray.splice(i, 1);
                                        }
                                        else {
                                            chkListArray.push(stringToAdd);
                                        }
                                        chkList.value = chkListArray.join('|');
                                    }
                                };
                            </script>

                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>