<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ParameterTypeEditor.aspx.vb" Inherits="EIDSS.ParameterTypeEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../../Includes/CSS/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
      <style type="text/css">
        .container {
            margin-top: 20px;
        }

        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 70%;
        }
          </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="hdg_ParameterType_Editor"></h2>
                </div>
                <div id="ageGroupEditorForm" class="panel-body" runat="server">
                    <div class="row">
                        <div class="formContainer">
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    <%--Begin: Hidden fields--%>
                                    <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                                        <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                                    </div>
                                    <%-- End: Hidden Fields --%>
                                    <div class="table-responsive">
                                        <div id="gridRef">
                                            <asp:UpdatePanel runat="server" ID="UpdatePanelParent">
                                                <ContentTemplate>
                                          
                                                <asp:TextBox runat="server" ID="txtSearchBox"></asp:TextBox>
                                                <asp:LinkButton ID="btnSearch" CssClass="btn glyphicon glyphicon-search" Text="" runat="server" ToolTip="Search" />
                                                <asp:LinkButton ID="btnClearSearch" CssClass="btn glyphicon glyphicon-refresh" Text="" runat="server" ToolTip="Clear Search" />                                                
                                                <br />
                                                    
                                              <eidss:GridView runat="server"
                                                ID="gvAgeGroup"
                                                GridLines="None"
                                                meta:Resourcekey="Grd_AgeGroup_List"
                                                AutoGenerateColumns="false"
                                                CssClass="table table-striped table-hover"
                                                CaptionAlign="Top"
                                                PageSize="8"
                                                DataKeyNames="idfsParameterType"
                                                ShowFooter="false"
                                                ShowHeader="true"
                                                ShowHeaderWhenEmpty="true"
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                UseAccessibleHeader="false">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateField SortExpression="DefaultName">
                                                        <HeaderTemplate>
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Name" runat="server">
                                                                <asp:Label runat="server" meta:resourcekey="Default_Text" />
                                                            </div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDef" runat="server" Text='<%# Bind("DefaultName") %>' />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtstrAgeGroupName" runat="server" Text='<%# Bind("DefaultName") %>' />
                                                            <asp:RequiredFieldValidator ID="rfvstrAgeGroupName" runat="server" ErrorMessage="You must provide a English Name." ControlToValidate="txtstrAgeGroupName" ValidationGroup="EditParamterTypeValidation"  >*</asp:RequiredFieldValidator>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:TextBox ID="txtstrAgeGroupName_new" runat="server" />
                                                            <asp:RequiredFieldValidator ID="rfvstrAgeGroupName" runat="server" ErrorMessage="You must provide a English Name." ControlToValidate="txtstrAgeGroupName_new" ValidationGroup="AddNewParamterTypeValidation">*</asp:RequiredFieldValidator>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField SortExpression="NationalName">
                                                        <HeaderTemplate>
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Name" runat="server">
                                                                <asp:Label runat="server" meta:resourcekey="National_Text" />
                                                            </div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblName" runat="server" Text='<%# Bind("NationalName") %>' />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtstrAgeGroupNameTranslated" runat="server" Text='<%# Bind("NationalName") %>' />
                                                            <asp:RequiredFieldValidator ID="rfvAgeGroupTranslated" runat="server" ErrorMessage="You must provide a Local Name." ControlToValidate="txtstrAgeGroupNameTranslated" ValidationGroup="EditParamterTypeValidation"  >*</asp:RequiredFieldValidator>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:TextBox ID="txtstrAgeGroupNameTranslated_new" runat="server" />
                                                            <asp:RequiredFieldValidator ID="rfvAgeGroupTranslated" runat="server" ErrorMessage="You must provide a Local Name." ControlToValidate="txtstrAgeGroupNameTranslated_new" ValidationGroup="AddNewParamterTypeValidation">*</asp:RequiredFieldValidator>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Name" runat="server">
                                                                <asp:Label runat="server" meta:resourcekey="Dropdown_Type" />
                                                            </div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlSelectionType" runat="server" SelectedValue='<%# Bind("System") %>' OnSelectedIndexChanged="ddlSelectionType_SelectedIndexChanged" AutoPostBack="true">
                                                                <asp:ListItem Text="Fixed Value" Value="0"></asp:ListItem>
                                                                <asp:ListItem Text="Reference Table" Value="1"></asp:ListItem>
                                                            </asp:DropDownList>
                                                            &nbsp;
                                                            <asp:LinkButton ID="lnkShowCurrentSelectionPopup" runat="server" OnClick="lnkShowCurrentSelectionPopup_Click" CssClass="btn glyphicon glyphicon-new-window" Text="" ToolTip="Show Current Selection"></asp:LinkButton>
                                                            <asp:HiddenField ID="hfidfsReferenceType" runat="server" Value='<%# Bind("idfsReferenceType") %>' />
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:DropDownList ID="ddlSelectionType_new" runat="server" Enabled="false">
                                                                <asp:ListItem Text="Fixed Value" Value="0"></asp:ListItem>
                                                                <asp:ListItem Text="Reference Table" Value="1"></asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:LinkButton ID="lnkShowCurrentSelectionDisabled" runat="server" OnClick="lnkShowCurrentSelectionDisabled_Click" CssClass="btn glyphicon glyphicon-new-window" Text="" ToolTip="Show Current Selection"></asp:LinkButton>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <asp:LinkButton ID="btnAddItem" CausesValidation="true" CommandArgument="" CommandName="NewParameterTypeRow" CssClass="btn glyphicon glyphicon-plus" Text="" runat="server" ToolTip="Add" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnEdit" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Edit" CssClass="btn glyphicon glyphicon-edit" runat="server" Text="" ToolTip="Edit" /> &nbsp;
                                                            <asp:LinkButton ID="btnDelete" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="DeleteParameterTypeRow" CssClass="btn glyphicon glyphicon-floppy-remove" runat="server" Text="" ToolTip="Delete" />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:LinkButton CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="UpdateParameterTypeRow" CssClass="btn glyphicon glyphicon-ok-circle" runat="server" ToolTip="Update" Text=""  ValidationGroup="EditParamterTypeValidation"  />
                                                            <asp:LinkButton CommandArgument="" CommandName="Cancel" CssClass="btn glyphicon glyphicon-remove-circle" runat="server" ToolTip="Cancel" Text="" CausesValidation="false" />
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:LinkButton ID="btnAddItem" CausesValidation="true" CommandArgument="" CommandName="AddParameterTypeRow" CssClass="btn glyphicon glyphicon-plus" Text="" runat="server" ToolTip="Add"  ValidationGroup="AddNewParamterTypeValidation"  />
                                                            <asp:LinkButton CssClass="btn glyphicon glyphicon-remove-circle" runat="server" ToolTip="Cancel" ID="btnCancelAdd" Text="" OnClick="btnCancelAdd_Click" CausesValidation="false" />
                                                        </FooterTemplate>
                                                    </asp:TemplateField>

                                                    <asp:BoundField DataField="blnSystem" Visible="false" ReadOnly="true" />
                                                    <%--  E if record is edit, I if record is insert, D if record is delete, N if record is existing and none --%>
                                                    <asp:BoundField DataField="recordStatus" Visible="false" ReadOnly="true" />

                                                </Columns>
                                            </eidss:GridView>
                                            <asp:LinkButton Text="" ID="lnkFake" runat="server" />
                                            <ajaxToolkit:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlPopup" TargetControlID="lnkFake"
                                                CancelControlID="btnClose" BackgroundCssClass="modalBackground">
                                            </ajaxToolkit:ModalPopupExtender>

                                             <asp:LinkButton Text="" ID="lnkFake1" runat="server" />
                                            <ajaxToolkit:ModalPopupExtender ID="mpe1" runat="server" PopupControlID="pnlPopup1" TargetControlID="lnkFake1"
                                                CancelControlID="btnClose2" BackgroundCssClass="modalBackground" OkControlID="btnSaveReferenceSelection">
                                            </ajaxToolkit:ModalPopupExtender>

                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                            <asp:UpdatePanel runat="server" ID="UpdatePanelChild">
                                                <ContentTemplate>
                                            <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopup" Style="display: none">
                                                <div class="header">
                                                    <h2 runat="server" meta:resourcekey="hdg_FixedValueTable_Selector"></h2>
                                                </div>
                                                <hr />
                                                <div class="body col-md-12">
                                            <eidss:GridView runat="server"
                                                ID="grdChild"
                                                GridLines="None"
                                                meta:Resourcekey="Grd_AgeGroup_List"
                                                AutoGenerateColumns="false"
                                                CssClass="table table-striped table-hover"
                                                CaptionAlign="Top"
                                                PageSize="5"
                                                DataKeyNames="idfsParameterType"
                                                ShowFooter="false"
                                                ShowHeader="true"
                                                ShowHeaderWhenEmpty="true"
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                UseAccessibleHeader="false">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Default Text" ItemStyle-CssClass="col-md-3">
                                                                <EditItemTemplate>
                                                                    <asp:HiddenField ID="hfEditidfsParameterFixedPresetValue" runat="server" Value='<%# Bind("idfsParameterFixedPresetValue") %>'></asp:HiddenField>
                                                                    <asp:TextBox ID="txtDefaultName" CssClass="form-control" runat="server" Text='<%# Bind("DefaultName") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:HiddenField ID="hfidfsParameterFixedPresetValue" runat="server" Value='<%# Bind("idfsParameterFixedPresetValue") %>'></asp:HiddenField>
                                                                    <asp:Label ID="lblDefaultName" runat="server" Text='<%# Bind("DefaultName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    <asp:TextBox ID="txtNewDefaultName" CssClass="form-control" runat="server"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvDefaultName" runat="server" Text="*"
                                                                        ControlToValidate="txtNewDefaultName" ForeColor="Red" ValidationGroup="AddNewFixedPresetValueValidation" />
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="National Name" ItemStyle-CssClass="col-md-3">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtNationalName" CssClass="form-control" runat="server" Text='<%# Bind("NationalName") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblNationalName" runat="server" Text='<%# Bind("NationalName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    <asp:TextBox ID="txtNewNationalName" CssClass="form-control" runat="server"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvNationalName" runat="server" Text="*"
                                                                        ControlToValidate="txtNewNationalName" ForeColor="Red" ValidationGroup="AddNewFixedPresetValueValidation" />
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Order" ItemStyle-CssClass="col-md-3">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtOrder" CssClass="form-control" runat="server" Text='<%# Bind("intOrder") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblOrder" runat="server" Text='<%# Bind("intOrder") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <FooterTemplate>
                                                                    <asp:TextBox ID="txtNewOrder" CssClass="form-control" runat="server"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvOrder" runat="server" Text="*"
                                                                        ControlToValidate="txtNewOrder" ForeColor="Red" ValidationGroup="AddNewFixedPresetValueValidation" />
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-CssClass="col-md-3" HeaderText="Action">
                                                                <HeaderTemplate>
                                                                    <asp:LinkButton ID="btnAddNewChild" runat="server" CssClass="glyphicon glyphicon-plus" CommandName="ShowNewFixedPresetValueRow"></asp:LinkButton>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btn_EditChild" runat="server" CssClass="glyphicon glyphicon-pencil" CommandName="Edit"></asp:LinkButton>
                                                                    <asp:LinkButton ID="btn_DeleteChild" runat="server" CssClass="glyphicon glyphicon-trash" CommandName="DeleteFixedPresetValueRow"></asp:LinkButton>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:LinkButton ID="btn_UpdateChild" runat="server" CssClass="glyphicon glyphicon-ok" CommandName="UpdateFixedPresetValueRow"></asp:LinkButton>
                                                                    <asp:LinkButton ID="btn_CancelChild" runat="server" CssClass="glyphicon glyphicon-remove" CommandName="Cancel"></asp:LinkButton>
                                                                </EditItemTemplate>
                                                                <FooterTemplate>
                                                                    <asp:LinkButton ID="btn_AddChild" runat="server" CausesValidation="true" CssClass="glyphicon glyphicon-plus" CommandName="AddFixedPresetValueRow" ToolTip="Add"  ValidationGroup="AddNewFixedPresetValueValidation" ></asp:LinkButton>
                                                                    <asp:LinkButton CssClass="btn glyphicon glyphicon-remove-circle" runat="server" ToolTip="Cancel" ID="btnCancelAddFixedPreset" Text="" OnClick="btnCancelAddFixedPreset_Click" CausesValidation="false" />
                                                                </FooterTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                                <hr />
                                                <div class="footer" align="right" style="padding-bottom: 15px !important; margin-right: 15px !important;">
                                                    <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-danger" />
                                                </div>
                                            </asp:Panel>

                                            <asp:Panel ID="pnlPopup1" runat="server" CssClass="modalPopup" Style="display: none">
                                                <div class="header">
                                                    <h2 runat="server" meta:resourcekey="hdg_ReferenceTable_Selector"></h2>
                                                </div>
                                                <hr />
                                                <div class="body col-md-12">
                                                    <asp:DropDownList runat="server" ID="ddlReferenceList" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:Button runat="server" ID="btnSaveReferenceSelection" Text="Save Selection" UseSubmitBehavior="false" OnClick="btnSaveReferenceSelection_Click"/>
                                                    <hr />
                                                    <eidss:GridView runat="server"
                                                        ID="gvReferenceList"
                                                        GridLines="None"
                                                        meta:Resourcekey="Grd_ReferenceEditor_List"
                                                        AutoGenerateColumns="false"
                                                        CssClass="table table-striped table-hover"
                                                        CaptionAlign="Top"
                                                        PageSize="10"
                                                        DataKeyNames="idfsBaseReference"
                                                        ShowFooter="false"
                                                        ShowHeader="true"
                                                        ShowHeaderWhenEmpty="true"
                                                        AllowPaging="true"
                                                        AllowSorting="true"
                                                        UseAccessibleHeader="false">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:TemplateField SortExpression="DefaultName">
                                                                <HeaderTemplate>
                                                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Name" runat="server">
                                                                        <asp:Label runat="server" meta:resourcekey="Default_Text" />
                                                                    </div>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblDef" runat="server" Text='<%# Bind("DefaultName") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField SortExpression="NationalName">
                                                                <HeaderTemplate>
                                                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Name" runat="server">
                                                                        <asp:Label runat="server" meta:resourcekey="National_Text" />
                                                                    </div>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblName" runat="server" Text='<%# Bind("NationalName") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                        </Columns>
                                                    </eidss:GridView>

                                                </div>
                                                <hr />
                                                <div class="footer" align="right" style="padding-bottom: 15px !important; margin-right: 15px !important;">
                                                    <asp:Button ID="btnClose2" runat="server" Text="Close" CssClass="btn btn-danger" />
                                                </div>
                                            </asp:Panel>

                                                </ContentTemplate>
                                            </asp:UpdatePanel>                                                                 
                                        </div>
                                    </div>
                                    <div class="panel-footer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    
   
</asp:Content>
