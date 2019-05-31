<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="EIDSS.Login" UICulture="auto" %>

<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Welcome to EIDSS 7.0 : Log In</title>

    <script lang="ja" type="text/javascript">

        //Disable browser back button 

        function _disableBackBtn() { window.history.forward(); }
        _disableBackBtn();
        window.onload = _disableBackBtn();
        window.onpageshow = function (evt) { if (evt.persisted) _disableBackBtn(); }
        window.onunload = function () { void (0); }

        function AddOnloadFunction(func) {

            if (window.onload) {
                var oldfunc = window.onload;
                window.onload = function () {
                    oldfunc();
                    func();
                };
            }
            else {
                window.onload = func;
            }
        }
    </script>

    <style media="screen" type="text/css">
            body {    
                margin-top: 50px !important;
                padding: 0 !important;
            }
    </style>

</head>
<body>
    <div class="container">
        <form id="frmLogin" runat="server">
            <div class="row">

                <%--Begin: Hidden fields--%>
                <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                    <asp:HiddenField runat="server" ID="hdfLangID" Value="EN" />
                    <asp:HiddenField runat="server" ID="hdfidfUserID" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfPerson" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrFirstName" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrSecondName" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrFamilyName" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfInstitution" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrUserName" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrLoginOrganization" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfstrOptions" Value="NULL" />
                    <asp:HiddenField runat="server" ID="hdfidfsSite" Value="NULL" />
                </div>
                <%-- End: Hidden Fields --%>

                <div class="col-centered loginscreen"><img src="Includes/Images/header_logo.png" alt="EIDSS" width="400"></div>

                <div class="col-centered loginscreen">
                    <asp:ValidationSummary ID="vsLogin" runat="server" ShowMessageBox="False" />
                </div>
                <div class="col-centered loginscreen" style="visibility:collapse">
                    <asp:Label 
                        AssociatedControlID="txtOrganization"
                        meta:resourcekey="Lbl_Organization"
                        runat="server" />
                    <asp:TextBox ID="txtOrganization" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-centered loginscreen">
                    <asp:Label 
                        AssociatedControlID="txtUserName"
                        meta:resourcekey="Lbl_Login" 
                        runat="server"></asp:Label>
                    <asp:TextBox ID="txtUserName" runat="server" MaxLength="25" CssClass="form-control" ></asp:TextBox>
                    <asp:RequiredFieldValidator 
                        ControlToValidate="txtUserName" 
                        CssClass="text-danger" ID="rfvUserName"
                        meta:resourcekey="Val_User_Name"
                        runat="server" />
                </div>
                <div class="col-centered loginscreen">
                    <asp:Label 
                        AssociatedControlID="txtPassword" 
                        meta:resourcekey="Lbl_Password"
                        runat="server"></asp:Label>
                    <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" MaxLength="25" CssClass="form-control" />
                    <asp:RequiredFieldValidator 
                        ControlToValidate="txtPassword" 
                        CssClass="text-danger" 
                        ID="rfvPassword"
                        meta:resourcekey="Val_Password" 
                        runat="server" 
                        ErrorMessage="Password is Required." />
                </div>
                <div class="text-center col-centered loginscreen">
                    <asp:Button 
                        CssClass="btn btn-primary" 
                        ID="btnLogin" 
                        meta:resourcekey="btn_Login"
                        runat="server"/>
                </div>
            </div>
        </form>
    </div>
    <footer class="text-center">
        <div class="row vert-offset-top-2">
            <div class="text-center col-centered loginscreen">
                <span><a href="">Disclaimer</a></span> |
                <span>&copy; 2016 - <%=CStr(Year(Now)) & " " & Session("Organization")%>.&nbsp;All Rights Reserved.</span>
            </div>
            <div class="text-center col-centered loginscreen">
                <span>Build: <asp:Label ID="lblBuild" runat="server"></asp:Label></span> | <span>Environment: <%= ConfigurationManager.AppSettings("Environment") %></span>
            </div>
        </div>            
    </footer>
</body>
</html>
