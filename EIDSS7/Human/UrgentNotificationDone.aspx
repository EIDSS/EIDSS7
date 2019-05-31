<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="UrgentNotificationDone.aspx.vb" Inherits="EIDSS.UrgentNotification" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="row">
        <header>
            <div class="row">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-left">
                    <h2>Urgent Notification</h2>
                </div>
            </div>
        </header>
        <div class="panel-body">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-6 col-md-offset-1 backpanel">
                                <section id="Success" class="col-md-12 hidden">   
                                    <div class="alert alert-success" role="alert">
                                        <div class="row">
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                <span class="glyphicon glyphicon-info-sign text-success"></span>
                                            </div>
                                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                <h5>You have successfully submitted the urgent notification on <asp:Label ID="lblSubmitDate" runat="server"></asp:Label> at <asp:Label ID="lblSubmitTime" runat="server"></asp:Label>. </h5>
                                                <p>You can print the form now or later from the case list.</p>
                                                <p><asp:Button ID="btnPrintForm" runat="server" CssClass="btn btn-primary" OnClick="btnPrintForm_Click" Text="<%$ Resources:btnPrintInvestigationForm %>" /></p>
                                            </div>
                                        </div>
                                    </div> 
                                </section>
                            </div>
                            <div class="col-md-3 col-md-offset-1 media-left">
                                <div class="row">&nbsp;</div>
                                <div class="row">&nbsp;</div>
                                <div class="row">
                                    <aside class="sidepanel">
                                        <ul>                                            
                                            <li><a href="#"><%= GetLocalResourceObject("UrgentNotification") %></a>
                                                <div class="glyphicon glyphicon-ok-sign"></div>
                                            </li>
                                            <li class="disabled"><%= GetGlobalResourceObject("GlobalTabResources", "tabCaseInvestigation") %></li>
                                            <li class="disabled"><%= GetGlobalResourceObject("GlobalTabResources", "tabCaseOutcome") %></li>
                                            <li class="disabled"><%= GetGlobalResourceObject("GlobalTabResources", "tabCaseClosed") %></li>
                                        </ul>
                                    </aside>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 text-center">
                                <asp:Button ID="btnDone" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:btnDone %>" onclick="btnDone_Click" />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
