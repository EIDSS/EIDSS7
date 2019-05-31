<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="DiseaseLabTestMatrix.aspx.vb" Inherits="EIDSS.DiseaseLabTestMatrix" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server" ID="upDiseaseSampleType">
        <ContentTemplate>
            <div class="panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h2 runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h2>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                <asp:Button ID="btnAddDiseaseLabTestMatrix" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add" />
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView runat="server"
                            ID="gvDiseaseLabTestMatrix"
                            AutoGenerateColumns="False"
                            EmptyDataText="No data available."
                            CssClass="table table-striped"
                            ShowHeaderWhenEmpty="true"
                            ShowHeader="true"
                            DataKeyNames="idfTestForDisease, idfsDiagnosis, idfsSampleType, idfsTestName, idfsTestCategory"
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
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Disease.InnerText %>'>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrDisease" runat="server" Text='<%# Eval("strDisease") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Sample_Type.InnerText %>'>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrSampleType" runat="server" Text='<%# Eval("strSampleType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Name.InnerText %>'>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrTestName" runat="server" Text='<%# Eval("strTestName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Category.InnerText %>'>
                                    <ItemTemplate>
                                        <asp:Label ID="lblstrTestCategory" runat="server" Text='<%# Eval("strTestCategory") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Delete" CssClass="btn glyphicon glyphicon-trash" runat="server" meta:resourceKey="btn_Delete" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div id="addDiseaseLabTest" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Disease_Lab_Test_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                        <div class="input-group">
                                            <asp:DropDownList ID="ddlidfsDiagnosis" CssClass="form-control" runat="server" AppendDataBoundItems="true"></asp:DropDownList>
                                            <span class="input-group-btn">
                                                <button class="btn" type="submit" runat="server" data-dismiss="modal" id="btnAddDisease">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                        <div class="input-group">
                                            <asp:DropDownList ID="ddlidfsSampleType" CssClass="form-control" runat="server" AppendDataBoundItems="true"></asp:DropDownList>
                                            <span class="input-group-btn">
                                                <button class="btn" type="submit" runat="server" data-dismiss="modal" id="btnAddSampleType">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                        <div class="input-group">
                                            <asp:DropDownList ID="ddlidfsTestName" CssClass="form-control" runat="server" AppendDataBoundItems="true"></asp:DropDownList>
                                            <span class="input-group-btn">
                                                <button class="btn" type="submit" runat="server" data-dismiss="modal" id="btnAddTestName">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Test_Category"></label>
                                        <div class="input-group">
                                            <asp:DropDownList ID="ddlidfsTestCategory" CssClass="form-control" runat="server" AppendDataBoundItems="true"></asp:DropDownList>
                                            <span class="input-group-btn">
                                                <button class="btn" type="submit" runat="server" data-dismiss="modal" id="btnAddTestCategory">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfDLTValidationError" runat="server" Value="False" />
                            <asp:HiddenField ID="hdfDLTidfTestforDisease" runat="server" Value="NULL" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" data-dismiss="modal" id="btnSubmitDiseaseLabTest" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelDiseaseLabTest" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="addDisease" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server" id="disease">
                            <p runat="server" meta:resourcekey="lbl_Disease_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtCDstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtCDstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_IDC_10"></label>
                                        <asp:TextBox ID="txtCDstrIDC10" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_OIE_Code"></label>
                                        <asp:TextBox ID="txtCDstrOIECode" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Using_Type"></label>
                                        <asp:DropDownList ID="ddlCDidfsUsingType" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_HA_Code"></label>
                                        <asp:ListBox ID="lstCDHACode" CssClass="form-control multiselect" runat="server" SelectionMode="Multiple"></asp:ListBox>
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
                                        <br />
                                        <asp:CheckBox ID="chkCDblnZoonotic" CssClass="checkbox-inline" runat="server" meta:resourceKey="lbl_Zoonotic_Disease" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtCDintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:resourcekey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfCDidfsDiagnosis" runat="server" Value="NULL" />
                            <asp:HiddenField ID="hdfCDValidationError" runat="server" Value="False" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Submit" id="btnSubmitDisease" />
                            <button type="submit" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_Cancel" id="btnCancelDisease" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="addSampleType" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Sample_Type_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtSTstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtSTstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Code"></label>
                                        <asp:TextBox ID="txtSTstrSampleCode" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Accessory_Code"></label>
                                        <asp:ListBox ID="lstSTHACode" CssClass="form-control listbox" SelectionMode="Multiple" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtSTintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:resourcekey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfSTValidationError" runat="server" Value="False" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" data-dismiss="modal" id="btnSubmitSampleType" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelSampleType" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="addTestName" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Test_Name_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtTNstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtTNstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Accessory_Code"></label>
                                        <asp:ListBox ID="lstTNHACode" CssClass="form-control listbox" SelectionMode="Multiple" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtTNintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:resourcekey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfTNValidationError" runat="server" Value="False" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" data-dismiss="modal" id="btnSubmitTestName" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelTestName" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="addTestCategory" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Test_Category_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtTCstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtTCstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtTCintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:resourcekey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfTCValidationError" runat="server" Value="False" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" data-dismiss="modal" id="btnSubmitTestCategory" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelTestCategory" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="errorModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
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
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
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
                            <button runat="server" type="submit" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" id="btnSuccessOK"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="deleteModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
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
            <div id="cancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Cancel" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnCancelYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnCancelNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="cancelReference" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Cancel_Reference" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnCancelReferenceYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnCancelReferenceNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="continueRequired" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Continue_Required" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnContinueRequiredYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnContinueRequiredNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="alreadyExists" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Disease_Lab_Test_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Already_Exists" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnAlreadyExistsYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnAlreadyExistsNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
                $(function () {
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
