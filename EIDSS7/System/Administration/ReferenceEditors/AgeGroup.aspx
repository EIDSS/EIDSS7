<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="AgeGroup.aspx.vb" Inherits="EIDSS.AgeGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../../Includes/CSS/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server" ID="upReferenceList">
        <ContentTemplate>
            <div class="panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h2 runat="server" meta:resourcekey="hdg_Age_Group_List"></h2>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                <asp:Button ID="btnAddReference" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add" />
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <eidss:GridView runat="server"
                            ID="gvAgeGroups"
                            AutoGenerateColumns="False"
                            EmptyDataText="No data available."
                            CssClass="table table-striped"
                            ShowHeaderWhenEmpty="true"
                            ShowHeader="true"
                            ShowFooter="True"
                            DataKeyNames="idfsAgeGroup,idfsAgeType"
                            GridLines="None"
                            AllowSorting="false"
                            AllowPaging="true"
                            PageSize="20">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <%# GetLocalResourceObject("lbl_Row.InnerText") %>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemNumber" runat="server" Text='<%# (Container.DataItemIndex + 1).ToString() %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_English_Value.InnerText %>' SortExpression="strDefault">
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrDefault" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrDefault" CssClass="form-control" runat="server" Text='<%# Bind("strDefault") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Translated_Value.InnerText %>' SortExpression="strName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrName" runat="server" Text='<%# Bind("strName") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtstrName" CssClass="form-control" runat="server" Text='<%# Bind("strName") %>' />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Order.InnerText %>' SortExpression="intOrder">
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtOrder" runat="server" Text='<%# Bind("intOrder") %>' MinValue="0" CssClass="form-control" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrder" runat="server" Text='<%# Bind("intOrder") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Lower_Bound.InnerText %>' SortExpression="intLowerBoundary">
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtintLowerBoundary" runat="server" Text='<%# Bind("intLowerBoundary") %>' MinValue="0" CssClass="form-control" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblintLowerBoundary" runat="server" Text='<%# Bind("intLowerBoundary") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Upper_Bound.InnerText %>' SortExpression="intUpperBoundary">
                                    <EditItemTemplate>
                                        <eidss:NumericSpinner ID="txtintUpperBoundary" runat="server" Text='<%# Bind("intUpperBoundary") %>' MinValue="0" CssClass="form-control" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lbintUpperBoundary" runat="server" Text='<%# Bind("intUpperBoundary") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Interval_Type.InnerText %>' SortExpression="AgeTypeName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrAgeType" runat="server" Text='<%# Bind("AgeTypeName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlidsfAgeType" runat="server" CssClass="form-control" />
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
            <div id="addAgeGroup" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group"></h4>
                        </div>
                        <div class="modal-body" id="ageGroup" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Age_Group_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtAGstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtAGstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Lower_Bound"></label>
                                        <eidss:NumericSpinner ID="txtAGintLowerBoundary" CssClass="form-control" runat="server" MinValue="0" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Upper_Bound"></label>
                                        <eidss:NumericSpinner ID="txtAGintUpperBoundary" CssClass="form-control" runat="server" MinValue="0" />
                                    </div>
                                </div>
                                <small runat="server" meta:resourceKey="lbl_Blank_Boundaries"></small>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Interval_Type"></label>
                                        <asp:DropDownList ID="ddlAGidfsAgeType" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtAGintOrder" CssClass="form-control" runat="server" MinValue="0" />                                        
                                        <small runat="server" meta:resourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfAGValidationError" runat="server" Value="False" />
                            <asp:HiddenField ID="hdfAGidfsAgeGroup" runat="server" Value="NULL" />
                            <asp:HiddenField ID="hdfAGstrName" runat="server" Value="NULL" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Submit" id="btnSaveAgeGroup" />
                            <button type="submit" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_Cancel" id="btnCancelAgeGroup" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="errorReference" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group"></h4>
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
            <div id="deleteModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group"></h4>
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
            <div id="currentlyInUseModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group"></h4>
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
            <script type="text/javascript" src="../../Includes/Scripts/bootstrap-multiselect.js"></script>
            <script type="text/javascript">
                $(function () {
                    $('[id*=lstAGHACode]]').multiselect({
                        includeSelectAllOption: true
                    });
                    $('.modal').modal({ show: false, backdrop: 'static' });
                });

                function hideModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal('hide');
                };

                function showModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal({ show: true, backdrop: 'static' });
                };
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
