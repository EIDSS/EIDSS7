<%@ Control Language="vb" AutoEventWireup="false"  CodeBehind="SpeciesReferenceEditorUserControl.ascx.vb" Inherits="EIDSS.SpeciesReferenceEditorUserControl" %>

<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

    <asp:View ID="DiseaseGridView" runat="server">

        <div class="panel-default">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                        <h2 runat="server" meta:resourcekey="hdg_Species_Types_List"></h2>
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
                    <asp:GridView runat="server"
                        ID="gvSpeciesType"
                        AutoGenerateColumns="False"
                        EmptyDataText="No data available."
                        CssClass="table table-striped"
                        ShowHeaderWhenEmpty="True"
                        ShowFooter="True"
                        DataKeyNames="idfsSpeciesType,intHACode"
                        GridLines="None"
                        AllowPaging="True"
                        PageSize="20" meta:resourcekey="gvSpeciesTypeResource1">
                        <Columns>
                            <asp:TemplateField HeaderText="Select Items" meta:resourcekey="TemplateFieldResource1">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Row.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblItemNumber" runat="server" meta:resourcekey="lblItemNumberResource1" Text="<%# (Container.DataItemIndex + 1).ToString() %>"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="<%$ Resources:lbl_English_Value.InnerText %>" meta:resourcekey="TemplateFieldResource2" SortExpression="strDefault">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrDefault" runat="server" CssClass="form-control" meta:resourcekey="txtstrDefaultResource1" Text='<%# Bind("strDefault") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrDefault" runat="server" meta:resourcekey="lblstrDefaultResource1" Text='<%# Bind("strDefault") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="<%$ Resources:lbl_Translated_Value.InnerText %>" meta:resourcekey="TemplateFieldResource3" SortExpression="strName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrName" runat="server" CssClass="form-control" meta:resourcekey="txtstrNameResource1" Text='<%# Bind("strName") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrName" runat="server" meta:resourcekey="lblstrNameResource1" Text='<%# Bind("strName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="<%$ Resources:lbl_Code.InnerText %>" meta:resourcekey="TemplateFieldResource4">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrCode" runat="server" CssClass="form-control" meta:resourcekey="txtstrCodeResource1" Text='<%# Bind("strCode") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrCode" runat="server" meta:resourcekey="lblstrCodeResource1" Text='<%# Bind("strCode") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="<%$ Resources:lbl_HA_Code.InnerText %>" meta:resourcekey="TemplateFieldResource5" SortExpression="strHACodeNames">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlintHACode" runat="server" CssClass="form-control" meta:resourcekey="ddlintHACodeResource1">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrHACodeNames" runat="server" meta:resourcekey="lblstrHACodeNamesResource1" Text='<%# Bind("strHACodeNames") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="<%$ Resources:lbl_Order.InnerText %>" meta:resourcekey="TemplateFieldResource6" SortExpression="intOrder">
                                <EditItemTemplate>
                                    <eidss:NumericSpinner ID="txtintOrder" runat="server" CssClass="form-control" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtintOrderResource1" MinValue="0" Text='<%# Bind("intOrder") %>'></eidss:NumericSpinner>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblintOrder" runat="server" meta:resourcekey="lblintOrderResource1" Text='<%# Bind("intOrder") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource7">
                                <EditItemTemplate>
                                    <asp:LinkButton runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Update" CssClass="btn glyphicon glyphicon-floppy-saved" meta:resourceKey="btn_Update"></asp:LinkButton>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Edit" CssClass="btn glyphicon glyphicon-edit" meta:resourceKey="btn_Edit"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle CssClass="icon" />
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource8">
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
                    </asp:GridView>
                </div>
            </div>
        </div>
        


    </asp:View>



    <asp:View ID="AddDiseaseView" runat="server">



            <div id="addSpeciesType" class="panel panel-default">
               
                    
                        <div class="panel-heading">
                            <h2 class="panel-title" runat="server" meta:resourcekey="hdg_Species_Types"></h2>
                        </div>
                        <div class="panel-body" id="speciesType" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Species_Type_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtSPstrDefault" CssClass="form-control" runat="server" meta:resourcekey="txtSPstrDefaultResource1" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtSPstrName" CssClass="form-control" runat="server" meta:resourcekey="txtSPstrNameResource1" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Code"></label>
                                        <asp:TextBox ID="txtSPstrCode" CssClass="form-control" runat="server" meta:resourcekey="txtSPstrCodeResource1" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_HA_Code"></label>
                                        <asp:DropDownList ID="ddlSPintHACode" CssClass="form-control" runat="server" meta:resourcekey="ddlSPintHACodeResource1" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtSPintOrder" CssClass="form-control" runat="server" MinValue="0" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtSPintOrderResource1" />
                                        <small runat="server" meta:resourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfSPValidationError" runat="server" Value="False" />
                            <asp:HiddenField ID="hdfSPidfsSpeciesType" runat="server" Value="NULL" />
                            <asp:HiddenField ID="hdfSPstrName" runat="server" Value="NULL" />
                        </div>
                        <div class="panel-footer">
                       
                            <asp:Button ID="btnSaveSpeciesType" runat="server" Text="Save" CssClass="btn btn-primary" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel2" id="btnCancelSpeciesType" data-dismiss="modal" />
                        </div>
               
             
            </div>
   



    </asp:View>




</asp:MultiView>
 
            
            <div id="speciesErrorReference" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Species_Types"></h4>
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
            <div id="speciesSuccessModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Species_Types"></h4>
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
            <div id="speciesDeleteModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Species_Types"></h4>
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
                            <asp:Button ID="btnDeleteYes" runat="server" CssClass="btn btn-primary"  meta:resourcekey="btnDeleteYes" />
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="speciesCurrentlyInUseModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Species_Types"></h4>
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
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No"></button>
                        </div>
                    </div>
                </div>
            </div>
      
            

           








