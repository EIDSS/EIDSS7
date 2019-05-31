<%@ Page Title="EIDSS: Home" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Welcome.aspx.vb" Inherits="EIDSS.Welcome" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <style>
        .red {
            color: red;
            font-size: xx-large;
            font-weight: bold;
            padding-right: 20px;
            float: left;
        }

        .modal-header {
            background-color: white !important;
        }
    </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-md-12">
                    <asp:RadioButtonList
                        AutoPostBack="true"
                        ID="rblListOfSamples"
                        runat="server">
                        <asp:ListItem Text="Calendar Control" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Drop Down List" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Spinner Control" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Location Control (Vertical)" Value="3"></asp:ListItem>
                        <asp:ListItem Text="Location Control (Horizontal)" Value="4"></asp:ListItem>
                        <asp:ListItem Text="Side Panel Control" Value="5"></asp:ListItem>
                        <asp:ListItem Text="Cancel Button" Value="6"></asp:ListItem>
                        <asp:ListItem Text="Dismissable Message" Value="7"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>

            <div class="container" id="calendarSample" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Calendar Control</h2>
                        </div>
                        <div class="panel-body">
                            <div class="control-group">
                                <eidss:CalendarInput 
                                    ID="calendarTest" 
                                    runat="server" 
                                    MinimumDate="01/01/2014"></eidss:CalendarInput>
                            </div>
                        </div>
                    </div>
                </div>
                <hr />
            </div>

            <div class="container" id="dropdownSample" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>DropDownList Control</h2>
                        </div>
                        <div class="panel-body">
                            <div class="control-group">
                                <eidss:DropDownList CssClass="form-control eidss-dropdown"
                                    ID="testddl"
                                    runat="server"
                                    PopUpWindowId="testpopup"
                                    SearchButtonCssClass="searchButton"
                                    SearchButtonText=""
                                    SearchPageUrl="System/Administration/OrganizationAdmin.aspx">
                                    <asp:ListItem Text="Select an Organization" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="full name test" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Ministry of Labour, Health and Social Affairs of Georgia" Value="2"></asp:ListItem>
                                </eidss:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
                <eidss:PopUpDialog ID="testpopup" runat="server" />
                <hr />
            </div>

            <div class="container" id="spinnerSample" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Spinner Control</h2>
                        </div>
                        <div class="panel-body">
                            <eidss:NumericSpinner CssClass="form-control" ID="NumericSpinner1" runat="server"></eidss:NumericSpinner>
                        </div>
                    </div>
                </div>
                <hr />
            </div>

            <div class="container" id="locSampleV" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Location Control (Vertical)</h2>
                        </div>
                        <div class="panel-body">
                            <asp:Button CssClass="btn btn-primary btn-sm" ID="btnLoadData" runat="server" Text="Load Data" />
                            <eidss:LocationUserControl IsHorizontalLayout="false" ID="verticalLocation" runat="server" controlPrefix="vert" />
                        </div>
                    </div>
                </div>
                <hr />
            </div>

            <div class="container" id="locSampleH" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Location Control (Horizontal)</h2>
                        </div>
                        <div class="panel-body">
                            <eidss:LocationUserControl IsHorizontalLayout="true" ID="horizontalLocation" runat="server" controlPrefix="hor" />
                        </div>
                    </div>
                </div>
                <hr />
            </div>

            <div class="container" id="sideBarSample" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Side Panel Control</h2>
                        </div>
                        <div class="panel-body">
                            <div class="sectionContainer expanded"></div>

                            <div class="control-group">
                                <eidss:SideBarNavigation ID="mynav" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem Href="Dashboard.aspx" ItemStatus="IsNormal" IsActive="false" runat="server" CssClass="glyphicon glyphicon-ok" Text="inactive item"></eidss:SideBarItem>
                                        <eidss:SideBarItem GoToTab="0" ItemStatus="IsNormal" IsActive="true" ToolTip="tooltip 1" runat="server" CssClass="glyphicon glyphicon-ok" Text="item 1"></eidss:SideBarItem>
                                        <eidss:SideBarItem GoToTab="1" ItemStatus="IsNormal" IsActive="true" ToolTip="toolTip 2" runat="server" CssClass="glyphicon glyphicon-ok" Text="item 2"></eidss:SideBarItem>
                                        <eidss:SideBarItem Href="Dashboard.aspx" ItemStatus="IsNormal" IsActive="false" runat="server" CssClass="glyphicon glyphicon-ok" Text="inactive item"></eidss:SideBarItem>
                                    </MenuItems>
                                </eidss:SideBarNavigation>
                            </div>
                            <asp:Button ID="testBtn" runat="server" OnClick="testBtn_Click" Text="Submit" />
                        </div>
                    </div>
                </div>
                <hr />
            </div>

            <div class="container" id="cancelBtnSample" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Confirmation Button</h2>
                        </div>
                        <div class="panel-body">
                            <eidss:ConfirmationButton
                                ButtonCss="btn btn-default"
                                ButtonConfirmMessage="Yes"
                                ButtonNotConfirmMessage="No"
                                HeaderGlyphicon="red glyphicon glyphicon-warning-sign"
                                ID="cancelBtn"
                                MessageConfirmation="Are you sure?"
                                MessageText="This will cancel what you were doing and send you back to the dashboard"
                                MessageTitle="Warning! Your changes will be lost!"
                                ModalHeading="Please Confirm"
                                ModalHeadingCss="red"
                                NavigateToUrl="dashboard.aspx"
                                runat="server"
                                ShowModalHeader="true"
                                Text="Cancel"></eidss:ConfirmationButton>
                        </div>
                    </div>
                    <hr />
                </div>
            </div>

            <div class="container" id="dismissableMessageDisplay" runat="server" visible="false">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Dismissible message</h2>
                        </div>
                        <div class="panel-body">
                            <div class="alert alert-danger" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <strong runat="server">Error</strong>
                            </div>
                            <div class="alert alert-warning" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <strong runat="server">Warning</strong>
                            </div>
                            <div class="alert alert-info" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <strong runat="server">Info</strong>
                            </div>
                            <div class="alert alert-success" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <strong runat="server">Success</strong>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
