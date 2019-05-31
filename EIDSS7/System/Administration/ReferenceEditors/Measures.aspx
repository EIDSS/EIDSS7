<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Measures.aspx.vb" Inherits="EIDSS.Measures" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="uppRefList" runat="server">
        <ContentTemplate>
            <div class="panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h2 runat="server" meta:resourcekey="hdg_Measures_List"></h2>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div runat="server" class="form-group" id="catList">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-8">
                                <label id="lblReferenceType" runat="server" meta:resourcekey="lbl_Measure_Type"></label>
                                <asp:DropDownList ID="ddlMeasures" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-4 text-right">
                                <br />
                                <asp:Button ID="btnAddReference" runat="server" class="btn btn-default" meta:resourcekey="btn_Add" />
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <eidss:GridView runat="server"
                            ID="gvMeasures"
                            GridLines="None"
                            meta:Resourcekey="Grd_Reference_List"
                            AutoGenerateColumns="false"
                            CssClass="table table-striped"
                            CaptionAlign="Top"
                            PageSize="20"
                            DataKeyNames="idfsAction"
                            ShowFooter="true"
                            ShowHeader="true"
                            ShowHeaderWhenEmpty="true"
                            AllowPaging="true"
                            AllowSorting="true"
                            UseAccessibleHeader="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <Columns>
                                <asp:TemplateField HeaderText="Select Items">
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Row.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemNumber" runat="server" Text='<%# (Container.DataItemIndex + 1).ToString() %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="strDefault">
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_English_Value.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrDefault" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrDefault" CssClass="form-control" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Translated_Value.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrName" runat="server" Text='<%# Bind("strName") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrName" CssClass="form-control" runat="server" Text='<%# Bind("strName") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="strActionCode">
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Code.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrActionCode" runat="server" Text='<%# Bind("strActionCode") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrActionCode" CssClass="form-control" runat="server" Text='<%# Bind("strActionCode") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="intOrder">
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Order.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblintOrder" runat="server" Text='<%# Bind("intOrder") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtintOrder" CssClass="form-control" runat="server" Text='<%# Bind("intOrder") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Edit" CssClass="btn glyphicon glyphicon-edit" runat="server" meta:resourceKey="btn_Edit" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Update" CssClass="btn glyphicon glyphicon-floppy-saved" runat="server" meta:resourceKey="btn_Update" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Delete" CssClass="btn glyphicon glyphicon-trash" runat="server" meta:resourceKey="btn_Delete" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Cancel" CssClass="btn glyphicon glyphicon-floppy-remove" runat="server" meta:resourceKey="btn_Cancel" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </eidss:GridView>
                    </div>
                </div>
            </div>
            <div id="addMeasure" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="modal-body" runat="server" id="divSaveReference">
                            <p runat="server" meta:resourcekey="lbl_Measure_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_English_Name"></label>
                                        <asp:TextBox ID="txtMEstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtMEstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Action_Code"></label>
                                        <asp:TextBox ID="txtMEstrActionCode" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtMEintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:ResourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfMEValidationError" runat="server" Value=False />
                            <asp:HiddenField ID="hdfMEstrName" runat="server" Value="NULL" />
                            <asp:HiddenField ID="hdfMEidfsBaseReference" runat="server" Value="NULL" />
                         </div>
                        <div class="modal-footer text-center">
                            <button type="submit" runat="server" meta:resourcekey="btn_Submit" id="btnSaveMeasure" data-dismiss="modal" class="btn btn-primary" />
                            <button type="submit" runat="server" data-dismiss="modal" meta:resourcekey="btn_Cancel" class="btn btn-default" id="btnCancelMeasures" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="errorReference" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-remove-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Error" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" runat="server" class="btn btn-primary" id="btnErrorOK" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="deleteReference" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblDeleteReference" runat="server" meta:resourcekey="lbl_Delete_Reference"></p>
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
            <div id="successModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lblSuccess" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="currentlyInUseModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Delete_Anyway" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnDeleteAnywayYes" type="submit"></button>
                            <button runat="server" class="btn btn-dismiss" data-dismiss="modal" meta:resourcekey="btn_No"></button>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
                $(function () {
                    $('.modal').modal({ show: false, backdrop: 'static' });
                });

                function showModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal({ show: true, backdrop: 'static' });
                };

                function hideModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal('hide');
                };
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
