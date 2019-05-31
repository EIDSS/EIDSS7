<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="GeneralError.aspx.vb" Inherits="EIDSS.GeneralError" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <h2>Error:</h2>
    <p></p>
    <asp:Label ID="lblFriendlyErrorMsg" runat="server" Text="Label" Font-Size="Large" style="color: red"></asp:Label>
    
    <asp:Panel ID="pnlDetailedErrorPanel" runat="server" Visible="false">
        <p>&nbsp;</p>
        <h3>Detailed Error:</h3>
        <p>
            <asp:Label ID="lblErrorDetailedMsg" runat="server" Font-Size="Small" /><br />
        </p>

        <h3>Error Handler:</h3>
        <p>
            <asp:Label ID="lblErrorHandler" runat="server" Font-Size="Small" /><br />
        </p>

        <h3>Detailed Error Message:</h3>
        <p>
            <asp:Label ID="lblInnerMessage" runat="server" Font-Size="Small" /><br />
        </p>
        <p>
            <asp:Label ID="lblInnerTrace" runat="server"  />
        </p>

    </asp:Panel>

</asp:Content>
