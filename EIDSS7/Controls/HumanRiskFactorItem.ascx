<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HumanRiskFactorItem.ascx.vb" Inherits="EIDSS.HumanRiskFactorItem" %>
<div class="form-group">
        <fieldset>
        <legend>
            <span class="glyphicon glyphicon-asterisk"></span>
            <span id="RiskFactorQuestion" runat="server"></span>
        </legend>
        <asp:RadioButton ID="rdoYes" runat="server" />
        <asp:Label
            runat="server"
            AssociatedControlID="rdoYes"
            CssClass="control-label"
            Text="<%$ Resources:Labels, Lbl_Yes_Text %>"
            ToolTip="<%$ Resources:Labels, Lbl_Yes_ToolTip %>"></asp:Label>
        <asp:RadioButton ID="rdoNo" runat="server"  />
        <asp:Label
            runat="server"
            AssociatedControlID="rdoNo"
            CssClass="control-label"
            Text="<%$ Resources:Labels, Lbl_No_Text %>"
            ToolTip="<%$ Resources:Labels, Lbl_No_ToolTip %>"></asp:Label>
        <asp:RadioButton ID="rdoUnknown" runat="server" />
        <asp:Label
            runat="server"
            AssociatedControlID="rdoUnknown"
            CssClass="control-label"
            Text="<%$ Resources:Labels, Lbl_Unknown_Text %>"
            ToolTip="<%$ Resources:Labels, Lbl_Unknown_ToolTip %>"></asp:Label>
    </fieldset>
</div>
<div class="form-group" id="typeDropDownContainer" runat="server" visible="false">
    <div class="glyphicon glyphicon-asterisk"></div>
    <asp:Label ID="LblSpecifyDdl"
        runat="server"
        AssociatedControlID="ddlSpecify"
        CssClass="control-label"></asp:Label>
    <asp:DropDownList ID="ddlSpecify" runat="server" CssClass="form-control"></asp:DropDownList>
</div>
<div class="form-group" id="typeTextBoxContainer" runat="server" visible="false">
    <div class="glyphicon glyphicon-asterisk"></div>
    <asp:Label ID="LblSpecifyTxt"
        runat="server"
        AssociatedControlID="txtSpecify"
        CssClass="control-label"></asp:Label>
    <asp:TextBox ID="txtSpecify" runat="server" CssClass="form-control"></asp:TextBox>
</div>
<div class="form-group">
    <div class="glyphicon glyphicon-asterisk"></div>
    <asp:Label ID="LblDate"
        runat="server"
        AssociatedControlID="txtDate"
        CssClass="control-label"
        Text="<%$ Resources:Labels, Lbl_Date_Text %>"
        ToolTip="<%$ Resources:Labels, Lbl_Date_ToolTip %>"></asp:Label>
    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
</div>
