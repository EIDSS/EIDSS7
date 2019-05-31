<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DiseaseEditorUserControl.ascx.vb" Inherits="EIDSS.DiseaseEditorUserControl" %>
            



<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

    <asp:View ID="DiseaseGridView" runat="server">


        <div class="panel-default">
            <div class="panel-heading">
                <h2 runat="server" meta:resourcekey="hdg_Diseases_List"></h2>
            </div>
            <div class="panel-body">
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                            <asp:Button ID="ShowAddDiseaseBtn" CssClass="btn btn-default" runat="server" Text="Add Disease" OnClick="ShowAddDiseaseBtn_Click" />
                        </div>
                    </div>
                </div>
                <div id="dataTableTest" class="table-responsive">
                    <asp:GridView ID="gvDiseases" runat="server" Width="800"
                        AutoGenerateColumns="False"
                        EmptyDataText="No data available."
                        CssClass="table table-striped"
                        ShowHeaderWhenEmpty="True"
                        DataKeyNames="idfsDiagnosis,intHACode,strHACode,idfsUsingType,strPensideTest,strLabTest,strSampleType"
                        GridLines="None"
                        AllowSorting="True"
                        AllowPaging="True"
                        PageSize="5" meta:resourcekey="gvDiseasesResource1">
                        <HeaderStyle CssClass="table-striped-header" />
                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                        <Columns>
                            <asp:TemplateField HeaderText="Select Items" meta:resourcekey="TemplateFieldResource1">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Row.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblItemNumber" runat="server" Text='<%# (Container.DataItemIndex + 1).ToString() %>' meta:resourcekey="lblItemNumberResource1" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField SortExpression="strDefault" meta:resourcekey="TemplateFieldResource2">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_English_Value.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrDefault" runat="server" Text='<%# Bind("strDefault") %>' meta:resourcekey="lblstrDefaultResource1" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrDefault" CssClass="form-control" runat="server" Text='<%# Bind("strDefault") %>' meta:resourcekey="txtstrDefaultResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource3">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Translated_Value.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrName" runat="server" Text='<%# Bind("strName") %>' meta:resourcekey="lblstrNameResource1" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrName" CssClass="form-control" runat="server" Text='<%# Bind("strName") %>' meta:resourcekey="txtstrNameResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource4">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_IDC_10.InnerText") %>
                                </HeaderTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrIDC10" runat="server" Text='<%# Bind("strIDC10") %>' CssClass="form-control" meta:resourcekey="txtstrIDC10Resource1"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lbstrIDC10" runat="server" Text='<%# Bind("strIDC10") %>' meta:resourcekey="lbstrIDC10Resource1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource5">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_OIE_Code.InnerText") %>
                                </HeaderTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtstrOIECode" runat="server" Text='<%# Bind("strOIECode") %>' CssClass="form-control" meta:resourcekey="txtstrOIECodeResource1"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lbstrOIECode" runat="server" Text='<%# Bind("strOIECode") %>' meta:resourcekey="lbstrOIECodeResource1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource6">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Sample_Type.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrSampleTypeNames" runat="server" Text='<%# Bind("strSampleTypeNames") %>' meta:resourcekey="lblstrSampleTypeNamesResource1"></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:ListBox ID="lstSampleType" runat="server" SelectionMode="Multiple" CssClass="form-control multiselect" AppendDataBoundItems="True" meta:resourcekey="lstSampleTypeResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource7">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Lab_Test.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrLabTestNames" runat="server" Text='<%# Bind("strLabTestNames") %>' meta:resourcekey="lblstrLabTestNamesResource1"></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:ListBox ID="lstLabTest" runat="server" SelectionMode="Multiple" CssClass="form-control multiselect" AppendDataBoundItems="True" meta:resourcekey="lstLabTestResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource8">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Penside_Test.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrPensideTest" runat="server" Text='<%# Bind("strPensideTestNames") %>' meta:resourcekey="lblstrPensideTestResource1"></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:ListBox ID="lstPensideTest" runat="server" SelectionMode="Multiple" CssClass="form-control multiselect" AppendDataBoundItems="True" meta:resourcekey="lstPensideTestResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource9">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Using_Type.InnerText") %>
                                </HeaderTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlidfsUsingType" runat="server" CssClass="form-control" meta:resourcekey="ddlidfsUsingTypeResource1"></asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblidfsUsingType" runat="server" Text='<%# Bind("strUsingType") %>' meta:resourcekey="lblidfsUsingTypeResource1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource10">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_HA_Code.InnerText") %>
                                </HeaderTemplate>
                                <EditItemTemplate>
                                    <asp:ListBox ID="lstHACode" runat="server" SelectionMode="Multiple" CssClass="form-control multiselect" meta:resourcekey="lstHACodeResource1" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblstrHACode" runat="server" Text='<%# Bind("strHACodeNames") %>' meta:resourcekey="lblstrHACodeResource1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource11">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Zoonotic_Disease.Text") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblblnZoonotic" runat="server" Text='<%# Bind("blnZoonotic") %>' meta:resourcekey="lblblnZoonoticResource1"></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="chkblnZoonotic" runat="server" Checked='<%# Bind("blnZoonotic") %>' meta:resourcekey="chkblnZoonoticResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource12">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Syndrome_Surveillance.InnerText") %>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblblnSyndrome" runat="server" Text='<%# Bind("blnSyndrome") %>' meta:resourcekey="lblblnSyndromeResource1"></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="chkblnSyndrome" runat="server" Checked='<%# Bind("blnSyndrome") %>' meta:resourcekey="chkblnSyndromeResource1" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField meta:resourcekey="TemplateFieldResource13">
                                <HeaderTemplate>
                                    <%# GetLocalResourceObject("lbl_Order.InnerText") %>
                                </HeaderTemplate>
                                <EditItemTemplate>
                                    <eidss:NumericSpinner ID="txtOrder" runat="server" Text='<%# Bind("intOrder") %>' MinValue="0" CssClass="form-control" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtOrderResource1" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblOrder" runat="server" Text='<%# Bind("intOrder") %>' meta:resourcekey="lblOrderResource1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-CssClass="icon" meta:resourcekey="TemplateFieldResource14">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Edit" CssClass="btn glyphicon glyphicon-edit" runat="server" meta:resourceKey="btn_Edit" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Update" CssClass="btn glyphicon glyphicon-floppy-saved" runat="server" meta:resourceKey="btn_Update" />
                                </EditItemTemplate>

                                <ItemStyle CssClass="icon"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-CssClass="icon" meta:resourcekey="TemplateFieldResource15">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDelete" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Delete" CssClass="btn glyphicon glyphicon-trash" runat="server" meta:resourceKey="btn_Delete" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Cancel" CssClass="btn glyphicon glyphicon-floppy-remove" runat="server" meta:resourceKey="btn_Cancel" />
                                </EditItemTemplate>

                                <ItemStyle CssClass="icon"></ItemStyle>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>


    </asp:View>



    <asp:View ID="AddDiseaseView" runat="server">



        <div class="panel-default">
            <div class="panel-heading">
                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Diseases"></h4>
            </div>
            <div class="panel-body">
                <p runat="server" meta:resourcekey="lbl_Disease_Instructions"></p>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                            <asp:TextBox ID="txtCDstrDefault" CssClass="form-control" runat="server" meta:resourcekey="txtCDstrDefaultResource1" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                            <asp:TextBox ID="txtCDstrName" CssClass="form-control" runat="server" meta:resourcekey="txtCDstrNameResource1" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_IDC_10"></label>
                            <asp:TextBox ID="txtCDstrIDC10" CssClass="form-control" runat="server" meta:resourcekey="txtCDstrIDC10Resource1" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_OIE_Code"></label>
                            <asp:TextBox ID="txtCDstrOIECode" CssClass="form-control" runat="server" meta:resourcekey="txtCDstrOIECodeResource1" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_Using_Type"></label>
                            <asp:DropDownList ID="ddlCDidfsUsingType" CssClass="form-control" runat="server" meta:resourcekey="ddlCDidfsUsingTypeResource1" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_HA_Code"></label>
                            <asp:ListBox ID="lstCDHACode" CssClass="form-control multiselect" runat="server" SelectionMode="Multiple" meta:resourcekey="lstCDHACodeResource1"></asp:ListBox>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_Penside_Test"></label>
                            <asp:ListBox ID="lstCDPensideTest" CssClass="form-control multiselect" runat="server" SelectionMode="Multiple" AppendDataBoundItems="True" meta:resourcekey="lstCDPensideTestResource1"></asp:ListBox>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_Lab_Test"></label>
                            <asp:ListBox ID="lstCDLabTest" CssClass="form-control multiselect" runat="server" SelectionMode="Multiple" AppendDataBoundItems="True" meta:resourcekey="lstCDLabTestResource1"></asp:ListBox>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <span class="glyphicon glyphicon-certificate text-danger"></span>
                            <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                            <asp:ListBox ID="lstCDSampleType" CssClass="form-control multiselect" runat="server" SelectionMode="Multiple" AppendDataBoundItems="True" meta:resourcekey="lstCDSampleTypeResource1"></asp:ListBox>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <br />
                            <asp:CheckBox ID="chkCDblnZoonotic" CssClass="checkbox-inline" runat="server" meta:resourceKey="lbl_Zoonotic_Disease" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <br />
                            <asp:CheckBox ID="chkCDblnSyndrome" CssClass="checkbox-inline" runat="server" meta:resourceKey="lbl_Syndrome_Surveillance" />
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                            <label runat="server" meta:resourcekey="lbl_Order"></label>
                            <eidss:NumericSpinner ID="txtCDintOrder" CssClass="form-control" runat="server" MinValue="0" IntegerOnly="False" MaxValue="1.79769313486232E+308" meta:resourcekey="txtCDintOrderResource1" />
                            <small runat="server" meta:resourcekey="lbl_Blank_Order"></small>
                        </div>
                    </div>
                </div>
                <asp:HiddenField ID="hdfCDidfsDiagnosis" runat="server" Value="NULL" />
                <asp:HiddenField ID="hdfCDstrName" runat="server" Value="NULL" />
                <asp:HiddenField ID="hdfCDValidationError" runat="server" Value="false" />
            </div>
            <div class="panel-footer">
                <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveDiagnosis_ServerClick" meta:resourcekey="btn_Submit" />
                <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" id="btnCancelAdd" />
            </div>
        </div>



    </asp:View>




</asp:MultiView>
 
            


           









<div id="errorReference" class="modal" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Diseases"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Diseases"></h4>
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
                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Diseases"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Diseases"></h4>
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

<script src="<%=ResolveUrl("~/Includes/Scripts/bootstrap-multiselect.js")%>"></script>
            
<script type="text/javascript">
    $(function () {
        $('.multiselect, #<%= lstCDHACode.ClientID %>').multiselect({
            includeSelectAllOption: true
        });
        $('.modal').modal({ show: false, backdrop: 'static' });
    });
    //  function hideModal(modalPopup) {
    //    var p = '#' + modalPopup;
    //    $(p).modal('hide');
    //};
    //function showModal(modalPopup) {
    //    var p = '#' + modalPopup;
    //    $(p).modal({ show: true, backdrop: 'static' })
    //};

</script>