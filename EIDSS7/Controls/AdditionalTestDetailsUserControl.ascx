<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AdditionalTestDetailsUserControl.ascx.vb" Inherits="EIDSS.AdditionalTestDetailsUserControl" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>
<div id="divHiddenFieldsSection" runat="server" visible="false">
    <asp:HiddenField ID="hdfBatchTestTestTypeID" runat="server" Value="" />
    <asp:HiddenField ID="hdfFormTypeID" runat="server" Value="10034019" />
    <asp:HiddenField ID="hdfDiagnosisID" runat="server" Value="null" />
    <asp:HiddenField ID="hdfCountryID" runat="server" Value="null" />
</div>
<asp:UpdatePanel ID="upAdditionalTestDetails" runat="server">
    <ContentTemplate>
        <asp:HiddenField ID="hdfObservationID" runat="server" Value="null" />
        <asp:HiddenField ID="hdfFormTemplateID" runat="server" Value="null" />

        <div id="divAdditionalTestDetails" runat="server" class="accordion-body">
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Notes">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtNotes.ClientID %>" runat="server" meta:resourcekey="Lbl_Notes" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" Rows="5" TextMode="MultiLine"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div id="divBatchID" class="row" runat="server" meta:resourcekey="Dis_Batch_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtBatchID.ClientID %>" runat="server" meta:resourcekey="Lbl_Batch_ID" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtBatchID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div id="divBatchStatus" class="row" runat="server" meta:resourcekey="Dis_Batch_Status">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtBatchStatus.ClientID %>" runat="server" meta:resourcekey="Lbl_Batch_Status" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtBatchStatus" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div id="divQualityControlValues" class="row" runat="server">
                <asp:UpdatePanel runat="server" ID="LUC08FlexFormTemplate">
                    <ContentTemplate>
                        <fieldset>
                            <legend runat="server" meta:resourcekey="Lbl_Quality_Control_Values"></legend>
                                <asp:Panel runat="server" ID="pnlLUC08" Width="100%"></asp:Panel>
                        </fieldset>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>