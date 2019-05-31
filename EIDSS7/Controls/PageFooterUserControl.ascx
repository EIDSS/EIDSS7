<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PageFooterUserControl.ascx.vb" Inherits="EIDSS.PageFooterUserControl" %>

<footer class="text-center">
    <div class="row vert-offset-top-2">
        <div class="text-center col-centered loginscreen">
            <span><a href="Disclaimer.aspx">Disclaimer</a></span> |
                <span>&copy; 2016 - <%=CStr(Year(Now)) %><asp:Label ID="lblOrganization" runat="server"></asp:Label>&nbsp;All Rights Reserved.</span>
        </div>
        <div class="text-center col-centered loginscreen">
            <span>Build:
                <asp:Label ID="lblBuild" runat="server"></asp:Label></span> | <span>Environment: <%= ConfigurationManager.AppSettings("Environment") %></span>
        </div>
    </div>
</footer>
