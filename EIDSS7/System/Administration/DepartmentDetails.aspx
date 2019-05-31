<%@ Page AutoEventWireup="false" CodeBehind="DepartmentDetails.aspx.vb" EnableEventValidation="false" Inherits="EIDSS.DepartmentDetails" MasterPageFile="~/NormalView.Master" Language="vb" Title="Department Details"%>
<%@ MasterType VirtualPath="~/NormalView.Master" %>

<asp:Content ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div>
            <asp:Table runat="server">

                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">
                        <asp:Label runat="server" Text="Organization" ></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell runat="server">
                        <asp:DropDownList runat="server" ID="ddlOrganization" Width="200px" />
                        <asp:Button runat="server" ID="btnAddOrg" Text="+" ToolTip="Add a new Organization" />
                        <asp:Button runat="server" ID="btnSearchOrg" Text="?" ToolTip="Search for an Organization" />
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">
                        <asp:Label runat="server" Text="Name (English)" ID="lblNamewithParen"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell runat="server">
                        <asp:TextBox runat="server" ID="txtNamewithParen"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">
                        <asp:Label runat="server" Text="Name (English)" ID="Label1"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell runat="server">
                        <asp:TextBox runat="server" ID="txtName"></asp:TextBox>
                    </asp:TableCell>

                </asp:TableRow>
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">
                        <asp:Button runat="server" Text="Delete" ID="btnDelete" />
                        <asp:Button runat="server" Text="Save" ID="btnSave" />
                        <asp:Button runat="server" Text="OK" ID="btnOK" />
                        <asp:Button runat="server" Text="Cancel" ID="btnCancel" />
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </div>
</asp:Content>


        
