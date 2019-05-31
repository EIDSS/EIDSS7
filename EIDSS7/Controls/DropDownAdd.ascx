<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DropDownAdd.ascx.vb" Inherits="EIDSS.DropDownAdd" %>
<asp:UpdatePanel ID="upAdd" runat="server">
            <Triggers>
                <asp:PostBackTrigger ControlID="btnAddReference" />
            </Triggers>
            <ContentTemplate>

<div class="input-group">
    <span class="input-group-addon"><span role="button" data-toggle="modal" data-target="#<%= divAddModalContainer.ClientID %>" class="glyphicon glyphicon-plus"></span></span>
    <asp:DropDownList ID="ddlAllItems" runat="server" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
    <asp:RequiredFieldValidator ID="rfvAllItems" ControlToValidate="ddlAllItems" CssClass="alert-danger" Display="Dynamic" runat="server"></asp:RequiredFieldValidator>
</div>

<div class="modal" id="divAddModalContainer" runat="server" tabindex="-1" role="dialog" aria-labelledby="addModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" runat="server">
                <h4 class="modal-title" id="addModalLabel" runat="server" meta:resourcekey="Hdg_Add"></h4>
            </div>
            <asp:Panel ID="pnlBaseReferenceEditor" runat="server" Visible="false">
                <div class="modal-body">
                    <h4 runat="server" meta:resourcekey="Hdg_Reference"></h4>
                    
                    <asp:HiddenField runat="server" ID="hdfReferenceID" Value="0" />

                    <div class="form-group">
                        <label for="<%= ddlReferenceType.ClientID %>" meta:resourcekey="Lbl_Reference_Type" runat="server"></label>
                        <asp:DropDownList ID="ddlReferenceType" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtDefaultName.ClientID %>" meta:resourcekey="Lbl_Default" runat="server"></label>
                        <asp:TextBox CssClass="form-control" ID="txtDefaultName" runat="server" />
                        <asp:RequiredFieldValidator ControlToValidate="txtDefaultName" CssClass="" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Default" runat="server"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtNationalName.ClientID %>" meta:resourcekey="Lbl_Name" runat="server"></label>
                        <asp:TextBox CssClass="form-control" ID="txtNationalName" runat="server" />
                        <asp:RequiredFieldValidator ControlToValidate="txtNationalName" CssClass="" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Name" runat="server"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtHaCode.ClientID %>" meta:resourcekey="Lbl_HA_Code" runat="server"></label>
                       <asp:DropDownList ID="ddlAccessoryType" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlAccessoryType" CssClass="" Display="Dynamic" InitialValue="" meta:resourcekey="Val_HA_Code" runat="server"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtOrder.ClienID %>" meta:resourcekey="Lbl_Order" runat="server"></label>
                        <eidss:NumericSpinner ID="txtOrder" runat="server" MinValue="0"  CssClass="form-control" Enabled="false" />
                        <asp:RequiredFieldValidator ControlToValidate="txtOrder" CssClass="" Display="Dynamic" meta:resourcekey="Val_Order" runat="server"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="Btn_Close"></button>
                    <asp:Button ID="btnAddReference" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:Btn_OK.InnerText %>" OnClick="btnAddReference_Click" />
                </div>
            </asp:Panel>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('#<%= divAddModalContainer.ClientID %>').modal({ show: false });

        //  This registers a call back handler that is triggered after every
        //  successful postback (sync or async)
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
    });

    function callBackHandler() {
        
    }

    function hideModal() {
        $('#<%= divAddModalContainer.ClientID %>').modal('hide');
    }

    function openModal() {
        $('#<%= divAddModalContainer.ClientID %>').modal('show');
    }
</script>
                </ContentTemplate>
        </asp:UpdatePanel>