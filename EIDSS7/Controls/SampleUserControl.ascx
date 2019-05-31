<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SampleUserControl.ascx.vb" Inherits="EIDSS.SampleUserControl" %>
<div class="panel panel-default">
    <div class="panel-heading"><%= GetLocalResourceObject("Hdg_New_Sample_Text") %></div>
    <div class="panel-body">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <div class="glyphicon glyphicon-asterisk"></div>
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlSampleType"
                        CssClass="control-label"
                        Text="<%$ Resources:Labels, Lbl_Sample_Type_Text %>"
                        ToolTip="<%$ Resources:Labels, Lbl_Sample_Type_ToolTip %>"></asp:Label>
                    <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <div class="glyphicon glyphicon-asterisk"></div>
                    <asp:Label ID="Label1"
                        runat="server"
                        AssociatedControlID="txtLocalSampleID"
                        CssClass="control-label"
                        Text="<%$ Resources:Labels, Lbl_Local_Sample_Text %>"
                        ToolTip="<%$ Resources:Labels, Lbl_Local_Sample_Text %>"></asp:Label>
                    <asp:TextBox ID="txtLocalSampleID" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <div class="glyphicon glyphicon-asterisk"></div>
                    <asp:Label ID="Label2"
                        runat="server"
                        AssociatedControlID="txtCollectionDate"
                        CssClass="control-label"
                        Text="<%$ Resources:Labels, LblCollectionDateText %>"
                        ToolTip="<%$ Resources:Labels, LblCollectionDateToolTip %>"></asp:Label>
                    <asp:TextBox ID="txtCollectionDate" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <div class="glyphicon glyphicon-asterisk"></div>
                    <asp:Label ID="Label3"
                        runat="server"
                        AssociatedControlID="txtSentDate"
                        CssClass="control-label"
                        Text="<%$ Resources:Labels, Lbl_Sent_Date_Text %>"
                        ToolTip="<%$ Resources:Labels, Lbl_Sent_Date_ToolTip %>"></asp:Label>
                    <asp:TextBox ID="txtSentDate" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="glyphicon glyphicon-asterisk"></div>
            <asp:Label ID="Label4"
                runat="server"
                AssociatedControlID="ddlDestinationLab"
                CssClass="control-label"
                Text="<%$ Resources:Labels, Lbl.Destination.Lab.Text %>"
                ToolTip="<%$ Resources:Labels, Lbl_Destination_Lab_ToolTip %>"></asp:Label>
            <asp:DropDownList ID="ddlDestinationLab" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
        <div class="form-group">
            <div class="glyphicon glyphicon-asterisk"></div>
            <asp:Label ID="Label5"
                runat="server"
                AssociatedControlID="txtNotes"
                CssClass="control-label"
                Text="<%$ Resources:Labels, Lbl_Additional_Text %>"
                ToolTip="<%$ Resources:Labels, Lbl_Additional_ToolTip %>"></asp:Label>
            <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <button type="button" class="btn btn-default" data-dismiss="modal">
                <span><%= GetGlobalResourceObject("Buttons", "BtnCloseText") %></span>
            </button>
            <asp:LinkButton CssClass="btn btn-primary" ID="btnAddNewSample" runat="server" ToolTip="<%$ Resources: Buttons, Btn_Add_Sample_ToolTip %>">
                <span><%= GetGlobalResourceObject("Buttons", "Btn_Add_Sample_Text") %></span>
            </asp:LinkButton>
                        
        </div>
    </div>
</div>