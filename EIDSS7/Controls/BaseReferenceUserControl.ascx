<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="BaseReferenceUserControl.ascx.vb" Inherits="EIDSS.BaseReferenceUserControl" %>
<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

    <asp:View runat="server" ID="GridView">
        <div class="panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="hdg_Base_Reference_List"></h2>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-8">
                                <label id="lblReferenceType" for="<%= ddlReferenceType.ClientID %>" runat="server" meta:resourcekey="lbl_Reference_Type"></label>
                                <asp:DropDownList ID="ddlReferenceType" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-4 text-right">
                                <br />
                                <input type="submit" id="btnAddItem" runat="server" class="btn btn-default" meta:resourcekey="btn_Add" />
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <eidss:GridView runat="server"
                            ID="gvBaseReference"
                            GridLines="None"
                            AutoGenerateColumns="false"
                            CssClass="table table-striped table-hover"
                            CaptionAlign="Top"
                            PageSize="20"
                            DataKeyNames="idfsBaseReference,idfsReferenceType,strHACode,intHACode"
                            ShowHeader="true"
                            ShowHeaderWhenEmpty="true"
                            AllowPaging="true"
                            AllowSorting="false"
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
                                        <asp:Label ID="txtstrDefault" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrDefault" CssClass="form-control" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="name">
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
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Order.InnerText") %>
                                    </HeaderTemplate>
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtOrder" runat="server" Text='<%# Bind("intOrder") %>' MinValue="0" CssClass="form-control" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrder" runat="server" Text='<%# Bind("intOrder") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_HA_Code.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblHACode" runat="server" Text='<%# Bind("strHACodeNames") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ListBox ID="lstHACode" runat="server" SelectionMode="Multiple" CssClass="form-control" />
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
          
    </asp:View>
    <asp:View runat="server" ID="AddView">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Base_Reference"></h4>
            </div>
            <div class="panel-body" runat="server" id="divSaveReference">
                <p runat="server" meta:resourcekey="lbl_Complete"></p>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                            <asp:TextBox ID="txtstrDefault" CssClass="form-control" runat="server" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                            <asp:TextBox ID="txtstrName" CssClass="form-control" runat="server" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_HA_Code"></label>
                            <asp:ListBox ID="lstHACode" CssClass="form-control" SelectionMode="Multiple" runat="server" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_Order"></label>
                            <eidss:NumericSpinner ID="txtOrder" CssClass="form-control" runat="server" MinValue="0" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                    </div>
                </div>
                <asp:HiddenField runat="server" ID="hdfidfBaseReference" Value="NULL" />
                <asp:HiddenField ID="hdfBRValidationError" runat="server" Value="False" />
                <asp:HiddenField ID="hdfstrName" runat="server" Value="NULL" />
                <asp:HiddenField ID="hdfReferenceType" runat="server" Value="NULL" />
            </div>
            <div class="modal-footer text-center">
                <asp:Button ID="btnSaveBaseReference" runat="server" meta:resourcekey="btn_Submit" CssClass="btn btn-primary" />
                <button type="submit" runat="server" meta:resourcekey="btn_Cancel" data-dismiss="modal" class="btn btn-default" id="btnCancelBaseReference" />
            </div>
        </div>
           
    </asp:View>
  
</asp:MultiView>
  <div id="errorReference" class="modal" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Base_Reference"></h4>
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
                    <button type="submit" id="btnErrorOK" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                </div>
            </div>
        </div>
    </div>
            
    <div id="successModal" class="modal" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Base_Reference"></h4>
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
    
    <div id="deleteBaseReference" class="modal" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Base_Reference"></h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                <p id="lbl_Delete" runat="server"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnDeleteYes" type="submit"></button>
                    <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No"></button>
                </div>
            </div>
        </div>
    </div>