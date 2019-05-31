<%@ Page
    Language="vb"
    AutoEventWireup="false"
    MasterPageFile="~/NormalView.Master"
    CodeBehind="ResourceEditor.aspx.vb" ValidateRequest="true"
    Inherits="EIDSS.ResourceEditor" meta:ResourceKey="HTML_Page_Title" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_Form_Title.InnerText") %></h2>
                </div>
                <div class="panel-body">
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
                    <asp:UpdatePanel runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLanguages" />
                            <asp:AsyncPostBackTrigger ControlID="ddlModule" />
                            <asp:AsyncPostBackTrigger ControlID="ddlResources" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-md-2">
                                    <fieldset>
                                        <legend class="legend"><%=GetLocalResourceObject("Rdo_Options_Title") %></legend>
                                        <div class="form-group optionsGroup">
                                            <asp:RadioButton
                                                AutoPostBack="true"
                                                ID="rdoText"
                                                CssClass="options"
                                                GroupName="editOptions"
                                                OnCheckedChanged="EditOptionsChanged"
                                                runat="server" />
                                            <asp:Label
                                                AssociatedControlID="rdoText"
                                                meta:ResourceKey="Rdo_Text"
                                                runat="server"></asp:Label>
                                            <br />
                                            <asp:RadioButton
                                                AutoPostBack="true"
                                                ID="rdoVisibility"
                                                CssClass="options"
                                                GroupName="editOptions"
                                                OnCheckedChanged="EditOptionsChanged"
                                                runat="server" />
                                            <asp:Label
                                                AssociatedControlID="rdoVisibility"
                                                meta:ResourceKey="Rdo_Visibillity"
                                                runat="server"></asp:Label>
                                            <br />
                                            <asp:RadioButton
                                                AutoPostBack="true"
                                                ID="rdoValidation"
                                                CssClass="options"
                                                GroupName="editOptions"
                                                OnCheckedChanged="EditOptionsChanged"
                                                runat="server" />
                                            <asp:Label
                                                AssociatedControlID="rdoValidation"
                                                meta:ResourceKey="Rdo_Validation"
                                                runat="server"></asp:Label>

                                        </div>
                                    </fieldset>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group" id="ddlLanguagesContainer" meta:resourcekey="Dis_Languages" runat="server">
                                        <asp:Label
                                            AssociatedControlID="ddlLanguages"
                                            meta:resourcekey="Lbl_Languages"
                                            runat="server"></asp:Label>
                                        <asp:DropDownList
                                            AutoPostBack="true"
                                            CssClass="form-control"
                                            ID="ddlLanguages"
                                            runat="server" />
                                        <asp:RequiredFieldValidator
                                            ControlToValidate="ddlLanguages"
                                            CssClass=""
                                            Display="Dynamic"
                                            meta:resourcekey="Val_Languages_Drop_Down"
                                            runat="server"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group" id="ddlModuleContainer" meta:resourcekey="Dis_Module" runat="server">
                                        <asp:Label
                                            AssociatedControlID="ddlModule"
                                            meta:resourcekey="Lbl_Module"
                                            runat="server"></asp:Label>
                                        <asp:DropDownList
                                            AutoPostBack="true"
                                            CssClass="form-control"
                                            ID="ddlModule"
                                            runat="server" />
                                        <asp:RequiredFieldValidator
                                            ControlToValidate="ddlModule"
                                            CssClass=""
                                            Display="Dynamic"
                                            meta:resourcekey="Val_Module_Drop_Down"
                                            runat="server"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group" id="ddlResourcesContainer" meta:resourcekey="Dis_Resource" runat="server">
                                        <asp:Label
                                            AssociatedControlID="ddlResources"
                                            meta:resourcekey="Lbl_Resource"
                                            runat="server"></asp:Label>
                                        <asp:DropDownList
                                            AutoPostBack="true"
                                            CssClass="form-control"
                                            ID="ddlResources"
                                            runat="server" />
                                        <asp:RequiredFieldValidator
                                            ControlToValidate="ddlResources"
                                            CssClass=""
                                            Display="Dynamic"
                                            meta:resourcekey="Val_Resource_Drop_Down"
                                            runat="server"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="col-md-1">
                                    <div class="form-group addLang" id="btnContainer" runat="server" meta:resourcekey="Dis_Btn_New">
                                        <asp:Label
                                            AssociatedControlID="btnNew"
                                            CssClass="label-control"
                                            meta:resourcekey="Lbl_Btn_New"
                                            runat="server"></asp:Label>
                                        <button
                                            class="btn btn-primary btn-sm"
                                            data-toggle="modal"
                                            data-target="#languageModalContainer"
                                            disabled="disabled"
                                            id="btnNew"
                                            runat="server"
                                            type="button">
                                            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="table-responsive">
                        <asp:UpdatePanel runat="server" ID="upResourceList">
                            <ContentTemplate>
                                <eidss:GridView
                                    AllowPaging="true"
                                    AllowSorting="true"
                                    AutoGenerateColumns="false"
                                    CaptionAlign="Top"
                                    CssClass="table table-striped table-hover"
                                    DataKeyNames="ResourceKey,ResourceValue"
                                    GridLines="None"
                                    ID="gvResourceList"
                                    meta:resourcekey="Grd_Resources"
                                    OnSorting="gvResourceList_Sorting"
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
                                        <asp:BoundField DataField="ResourceKey" Visible="false" />

                                        <asp:TemplateField HeaderText="<%$ Resources:Grd_Row_Header %>">
                                            <ItemTemplate>
                                                <asp:Label ID="rowCounter" runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="ElementName" HeaderText="<%$ Resources:Grd_Resource_Key_Header %>" ReadOnly="true" SortExpression="ResourceKey" />

                                        <asp:BoundField DataField="EnglishReadOnly" HeaderText="<%$ Resources:Grd_English_Value_Header %>" ReadOnly="true" SortExpression="EnglishhReadOnly" />

                                        <asp:TemplateField HeaderText="<%$ Resources:Grd_Editable_Value_Header %>" SortExpression="ResourceValue">
                                            <ItemTemplate>
                                                <asp:Label ID="roTextValue" runat="server" Text='<%# Eval("ResourceValue") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="editText" runat="server" Text='<%# Eval("ResourceValue")%>'></asp:TextBox>
                                                <asp:CheckBox ID="chkTrueFalseValue" runat="server" />
                                            </EditItemTemplate>
                                        </asp:TemplateField>
                                        <asp:CommandField ShowEditButton="true" ControlStyle-CssClass="btn glyphicon glyphicon-edit" EditText="" AccessibleHeaderText="<%$ Resources:Btn_Edit_Text %>" />
                                    </Columns>
                                </eidss:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="languageModalContainer" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" meta:resoucekey="Hdg_Modal_Window" runat="server"></h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <asp:Label
                            AssociatedControlID="ddlNewLanguageSelector"
                            meta:resourcekey="Lbl_New_Language_Selector"
                            runat="server"></asp:Label>
                        <asp:DropDownList ID="ddlNewLanguageSelector" runat="server"></asp:DropDownList>
                        <asp:LinkButton
                            CssClass="btn btn-primary"
                            ID="btnSelectLanguage"
                            OnClick="btnSelectLanguageClick"
                            OnClientClick="$('#languageModalContainer').modal('toggle');"
                            runat="server">
                                        <span class="glyphicon glyphicon-send"></span>
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="modal-footer"></div>
            </div>
        </div>
    </div>



</asp:Content>
