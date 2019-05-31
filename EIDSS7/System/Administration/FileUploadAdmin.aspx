<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="FileUploadAdmin.aspx.vb" Inherits="EIDSS.FileUploadAdmin" %>

<%@ Register Src="~/Controls/FileUploaderControl.ascx" TagPrefix="uc1" TagName="FileUploader" %>
<%@ Register TagPrefix="uc1" Namespace="EIDSS" Assembly="EIDSS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <!-- UC Ad -->
    <asp:TextBox runat="server" Text="Adm "></asp:TextBox>
    <uc1:FileUploaderControl runat="server" ID="ucFileUploader" />
    <asp:FileUpload runat="server" accept="image/*" />

</asp:Content>





