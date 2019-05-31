<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HumanCaseClassificationItem.ascx.vb" Inherits="EIDSS.HumanCaseClassificationItem" %>
<div class="form-group">
    <fieldset>
        <legend>
            <span id="suspectMainQuestion" runat="server"></span>
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


