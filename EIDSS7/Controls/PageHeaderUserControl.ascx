<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PageHeaderUserControl.ascx.vb" Inherits="EIDSS.PageHeader" %>

<asp:SiteMapDataSource ID="SiteMapDataSource1" runat="server" ShowStartingNode="false" />
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Dashboard.aspx" CssClass="eidsslogo" Text="">
            </asp:HyperLink>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
                <li class="messages">
                    <a href="#">
                        <span class="glyphicon glyphicon-envelope" aria-hidden="true"></span>
                        <sup>
                            <span class="badge"><% = MessageCount %></span>
                        </sup>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;&nbsp;
                            <span class="user"><% = CurrentUser %>&nbsp;|&nbsp;<% = Organization %></span>
                    </a>
                    <ul>
                        <li><a href="<%=HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + VirtualPathUtility.ToAbsolute("~/") + "Logout.aspx"%>">Logout</a></li>
                        <li role="separator" class="divider"></li>
                        <li id="languageContainer" runat="server"></li>
                    </ul>
                </li>
                <li id="helpsection" runat="server">
                    <a href="#">
                        <span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span>
                    </a>
                    <ul style="width:50px">
                        <li style="text-align:center">
                            <asp:HyperLink ID="lnkHelpText" runat="server" NavigateUrl="~/Dashboard.aspx" Target="_blank" ToolTip="Help Text" Text="">
                                <span class="glyphicon glyphicon-book"></span>
                            </asp:HyperLink>
                        </li>
                        <li style="text-align:center">
                            <asp:HyperLink ID="lnkHelpAudio" runat="server" NavigateUrl="~/Dashboard.aspx" Target="_blank" ToolTip="Help Audio" Text="">
                                <span class="glyphicon glyphicon-headphones"></span>
                            </asp:HyperLink>
                        </li>
                        <li style="text-align:center">
                            <asp:HyperLink ID="lnkHelpVideo" runat="server" NavigateUrl="~/Dashboard.aspx" Target="_blank" ToolTip="Help Video" Text="">
                                <span class="glyphicon glyphicon-facetime-video"></span>
                            </asp:HyperLink>
                        </li>
                    </ul>
                </li>
            </ul>
            <br />
            <br />
            <br />
            <nav class="navbar navbar-default" style="margin-left: 250px; width:calc(100% - 250px);border:none">
                <div runat="server" id="divMenu" class="container-fluid">
                    <div class="navbar-header">
                    </div>
                </div>
            </nav>
        </div>
    </div>
</nav>

<style type="text/css">

    .dropdown-menu {
        min-width: 375px;
        width: 100%;
    }

    .dropdown-menu > li > a:hover,
    .dropdown-menu > li > a:focus {
        color: #262626;
        text-decoration: none;
        background-color: #2d5b83;
    }

</style>

<script type="text/javascript">
    function setStatusBarText(statusBarText)
	{
		window.status = statusBarText;
	}
</script>