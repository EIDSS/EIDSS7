<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MeasureReferenceEditorUserControl.ascx.vb" Inherits="EIDSS.MeasureReferenceEditorUserControl" %>
<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

    <asp:View ID="DiseaseGridView" runat="server">

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
                                <asp:DropDownList ID="ddlMeasures" runat="server" CssClass="form-control" AutoPostBack="True" meta:resourcekey="ddlMeasuresResource1"></asp:DropDownList>
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
                            AutoGenerateColumns="False"
                            CssClass="table table-striped"
                            CaptionAlign="Top"
                            PageSize="20"
                            DataKeyNames="idfsAction"
                            ShowFooter="True"
                            ShowHeaderWhenEmpty="True"
                            AllowPaging="True"
                            AllowSorting="True"
                            UseAccessibleHeader="False">
                            <Columns>
                                <asp:TemplateField HeaderText="Select Items" meta:resourcekey="TemplateFieldResource1">
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Row.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemNumber" runat="server" meta:resourcekey="lblItemNumberResource1" Text="<%# (Container.DataItemIndex + 1).ToString() %>"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource2" SortExpression="strDefault">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrDefault" runat="server" CssClass="form-control" meta:resourcekey="txtstrDefaultResource1" Text='<%# Bind("strDefault") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_English_Value.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrDefault" runat="server" meta:resourcekey="lblstrDefaultResource1" Text='<%# Bind("strDefault") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource3">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrName" runat="server" CssClass="form-control" meta:resourcekey="txtstrNameResource1" Text='<%# Bind("strName") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Translated_Value.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrName" runat="server" meta:resourcekey="lblstrNameResource1" Text='<%# Bind("strName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource4" SortExpression="strActionCode">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrActionCode" runat="server" CssClass="form-control" meta:resourcekey="txtstrActionCodeResource1" Text='<%# Bind("strActionCode") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Code.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrActionCode" runat="server" meta:resourcekey="lblstrActionCodeResource1" Text='<%# Bind("strActionCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource5" SortExpression="intOrder">
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtintOrder" runat="server" CssClass="form-control" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtintOrderResource1" MinValue="-1.79769313486232E+308" Text='<%# Bind("intOrder") %>'></eidss:NumericSpinner>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Order.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblintOrder" runat="server" meta:resourcekey="lblintOrderResource1" Text='<%# Bind("intOrder") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource6">
                                    <EditItemTemplate>
                                        <asp:LinkButton runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Update" CssClass="btn glyphicon glyphicon-floppy-saved" meta:resourceKey="btn_Update"></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Edit" CssClass="btn glyphicon glyphicon-edit" meta:resourceKey="btn_Edit"></asp:LinkButton>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="icon" />
                                </asp:TemplateField>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource7">
                                    <EditItemTemplate>
                                        <asp:LinkButton runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Cancel" CssClass="btn glyphicon glyphicon-floppy-remove" meta:resourceKey="btn_Cancel"></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Delete" CssClass="btn glyphicon glyphicon-trash" meta:resourceKey="btn_Delete"></asp:LinkButton>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="icon" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                        </eidss:GridView>
                    </div>
                </div>
            </div>
        


    </asp:View>



    <asp:View ID="AddDiseaseView" runat="server">

           
                    <div class="panel">
                        <div class="panel-heading">
                            <h4  runat="server" meta:resourcekey="hdg_Measures"></h4>
                        </div>
                        <div class="panel-body" runat="server" id="divSaveReference">
                            <p runat="server" meta:resourcekey="lbl_Measure_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_English_Name"></label>
                                        <asp:TextBox ID="txtMEstrDefault" CssClass="form-control" runat="server" meta:resourcekey="txtMEstrDefaultResource1" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtMEstrName" CssClass="form-control" runat="server" meta:resourcekey="txtMEstrNameResource1" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Action_Code"></label>
                                        <asp:TextBox ID="txtMEstrActionCode" CssClass="form-control" runat="server" meta:resourcekey="txtMEstrActionCodeResource1" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtMEintOrder" CssClass="form-control" runat="server" MinValue="0" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtMEintOrderResource1" />
                                        <small runat="server" meta:ResourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfMEValidationError" runat="server" Value=False />
                            <asp:HiddenField ID="hdfMEstrName" runat="server" Value="NULL" />
                            <asp:HiddenField ID="hdfMEidfsBaseReference" runat="server" Value="NULL" />
                         </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnSaveMeasure" runat="server"  Text="Save" meta:resourcekey="btn_Submit" CssClass="btn btn-primary" />
                           <%-- <button type="submit" runat="server" meta:resourcekey="btn_Submit" id="btnSaveMeasure" class="btn btn-primary"  />--%>
                            <button type="submit" runat="server" data-dismiss="modal" meta:resourcekey="btn_Cancel" class="btn btn-default" id="btnCancelMeasures" />
                        </div>
                    </div>
           
         


    </asp:View>




</asp:MultiView>
<div id="errorReference2" class="modal" role="dialog">
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