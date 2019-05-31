<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ReferenceUserControl.ascx.vb" Inherits="EIDSS.ReferenceUserControl" %>

<asp:UpdatePanel ID="upReference" runat="server">
    <Triggers>
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
            <asp:HiddenField runat="server" ID="hdfReferenceID" Value="0" />
        </div>
        <div id="divReferenceContainer" runat="server">
            <div class="form-group">
                <label for="<%= ddlReferenceType.ClientID %>" meta:resourcekey="Lbl_Reference_Type" runat="server"></label>
                <asp:DropDownList ID="ddlReferenceType" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label for="<%= txtDefaultName.ClientID %>" meta:resourcekey="Lbl_Default" runat="server"></label>
                <asp:TextBox CssClass="form-control" ID="txtDefaultName" runat="server" />
                <asp:RequiredFieldValidator ControlToValidate="txtDefaultName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Default" runat="server"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="<%= txtNationalName.ClientID %>" meta:resourcekey="Lbl_Name" runat="server"></label>
                <asp:TextBox CssClass="form-control" ID="txtNationalName" runat="server" />
                <asp:RequiredFieldValidator ControlToValidate="txtNationalName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Name" runat="server"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="<%= ddlHACode.ClientID %>" meta:resourcekey="Lbl_HA_Code" runat="server"></label>
                <asp:DropDownList ID="ddlHACode" runat="server" CssClass="form-control"></asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="ddlHACode" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_HA_Code" runat="server"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="<%= txtOrder.ClienID %>" meta:resourcekey="Lbl_Order" runat="server"></label>
                <eidss:NumericSpinner ID="txtOrder" runat="server" MinValue="0" CssClass="form-control" Enabled="false" />
                <asp:RequiredFieldValidator ControlToValidate="txtOrder" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Order" runat="server"></asp:RequiredFieldValidator>
            </div>
        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                //  This registers a call back handler that is triggered after every
                //  successful postback (sync or async)
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
            });

            function callBackHandler() {

            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
