<%@ Page Title="Change Password (C02)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ChangePassword.aspx.vb" Inherits="EIDSS.ChangePassword" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <div style="width: 100%; text-align: center; padding: 0px 0px">
        <asp:Table ID="canvasChangePassword" runat="server" Width="600px">

            <asp:TableHeaderRow runat="server">
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Left">
                    <%= GetLocalResourceObject("Hdg_Change_Password_Text") %>
                </asp:TableHeaderCell>
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Right">
                    C02
                </asp:TableHeaderCell>
            </asp:TableHeaderRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">&nbsp;</asp:TableCell></asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:ValidationSummary ID="vsChangePassword" runat="server" ShowMessageBox="False" />
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:Table ID="tblPasswordPolicy" runat="server" Width="100%" BorderStyle="None">
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Right" Width="40%">
                                <asp:Label
                                    AssociatedControlID="txtOrganization"
                                    ID="lblOrganization"
                                    runat="server"
                                    Text="<%$ Resources:Labels, Lbl_Organization_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Organization_ToolTip %>" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" HorizontalAlign="Left" Width="60%">
                                <asp:TextBox ID="txtOrganization" runat="server" />
                            </asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Right" Width="40%">
                                <asp:Label
                                    AssociatedControlID="txtUserName"
                                    ID="lblUserName" runat="server"
                                    Text="<%$ Resources:Lbl_User_Name_Text %>"
                                    ToolTip="<%$ Resources:Lbl_User_Name_ToolTip %>" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" HorizontalAlign="Left" Width="60%">
                                <asp:TextBox ID="txtUserName" runat="server" />
                            </asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Right" Width="40%">
                                <asp:Label
                                    AssociatedControlID="txtCurrentPassword"
                                    ID="lblCurrentPassword"
                                    runat="server"
                                    Text="<%$ Resources:Lbl_Current_Password_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Current_Password_ToolTip %>" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" HorizontalAlign="Left" Width="60%">
                                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword" ErrorMessage="Current Password is Required." />
                            </asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Right" Width="40%">
                                <asp:Label
                                    AssociatedControlID="txtNewPassword"
                                    ID="lblNewPassword"
                                    runat="server"
                                    Text="<%$ Resources: Lbl_New_Password_Text %>"
                                    ToolTip="<%$ Resources: Lbl_New_Password_ToolTip %>" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" HorizontalAlign="Left" Width="60%">
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="New Password is Required." />
                            </asp:TableCell>
                        </asp:TableRow>

                    </asp:Table>
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">&nbsp;</asp:TableCell></asp:TableRow>
            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:Button 
                        ID="btnSave" 
                        runat="server" 
                        Text="<%$ Resources:Btn_Change_Password_Text %>" 
                        ToolTip="<%$ Resources:Btn_Change_Password_ToolTip %>"/>
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">&nbsp;</asp:TableCell></asp:TableRow>

        </asp:Table>
    </div>

</asp:Content>
