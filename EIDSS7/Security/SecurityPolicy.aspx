<%@ Page Title="Security Policy (C03)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="SecurityPolicy.aspx.vb" Inherits="EIDSS.SecurityPolicy" %>
<%@ MasterType VirtualPath="~/NormalView.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <div style="width:100%;text-align:center;padding: 0px 0px">
        <asp:Table ID="canvasSecurityPolicy" runat="server" Width="500px">

            <asp:TableHeaderRow runat="server">
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Left">
                    <%= GetLocalResourceObject("Hdg_Security_Policy_Text") %>
                </asp:TableHeaderCell>
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Right">
                    C03
                </asp:TableHeaderCell>
            </asp:TableHeaderRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:table ID="tblPasswordPolicy" runat="server" Width="100%">
                        <asp:TableHeaderRow runat="server">
                            <asp:TableHeaderCell runat="server" ColumnSpan="5">
                                <%= GetLocalResourceObject("Hdg_Password_Policy_Sub_Title__Text") %>
                            </asp:TableHeaderCell>
                        </asp:TableHeaderRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ColumnSpan="5">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintPasswordMinimalLength"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Minimum_Password_Length_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Minimum_Password_Length_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <asp:TextBox Id="idfSecurityConfiguration" runat="server" Visible="false" />
                                <eidss:NumericSpinner ID="txtintPasswordMinimalLength" runat="server" min="5" max="20"></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintPasswordHistoryLength"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Enforce_Password_History_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Enforce_Password_History_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <eidss:NumericSpinner id="txtintPasswordHistoryLength" runat="server" min="1" max="5"></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintPasswordAge" 
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Maximum_Password_Age_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Maximum_Password_Age_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <eidss:NumericSpinner ID="txtintPasswordAge" runat="server" min="1" max="1000"></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="chkintForcePasswordComplexity"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Force_Password_Complexity_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Force_Password_Complexity_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkintForcePasswordComplexity" runat="server" Text="" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="98%" ColumnSpan="3">
                                <asp:Table runat="server">
                                    <asp:TableRow runat="server">
                                        <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                                        <asp:TableCell runat="server" Width="90%" ColumnSpan="3" HorizontalAlign="Left">
                                            <p><%= GetLocalResourceObject("Par_Policy_Verbiage_1_Text") %></p>
                                            <p><%= GetLocalResourceObject("Par_Policy_Verbiage_2_Text") %></p>
                                            <ul>
                                                <li><%= GetLocalResourceObject("Itm_Password_Policy_1_Text") %></li>
                                                <li><%= GetLocalResourceObject("Itm_Password_Policy_2_Text") %></li>
                                                <li><%= GetLocalResourceObject("Itm_Password_Policy_3_Text") %></li>
                                            </ul>
                                        </asp:TableCell>
                                        <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                                    </asp:TableRow>
                                </asp:Table>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>
                    </asp:table>
                </asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:table ID="tblLockoutPolicy" runat="server" Width="100%">
                        <asp:TableHeaderRow runat="server">
                            <asp:TableHeaderCell runat="server" ColumnSpan="5">
                                <%= GetLocalResourceObject("Hdg_LockOut_Policy_Text") %>
                            </asp:TableHeaderCell>
                        </asp:TableHeaderRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ColumnSpan="5">&nbsp;</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintAccountTryCount"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Account_Lockout_Threshold_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Account_Lockout_Threshold_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <eidss:NumericSpinner ID="txtintAccountTryCount" runat="server" min="5" max="20"></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintAccountLockTimeout"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Account_Lockout_Duration_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Account_Lockout_Duration_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <eidss:NumericSpinner ID="txtintAccountLockTimeout" max="5" min="1" runat="server"></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="49%" HorizontalAlign="Right">
                                <asp:Label 
                                    AssociatedControlID="txtintInactivityTimeout"
                                    runat="server" 
                                    Text="<%$ Resources:Lbl_Session_Inactivity_Timeout_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Session_Inactivity_Timeout_ToolTip %>"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="48%" HorizontalAlign="Left">
                                <eidss:NumericSpinner ID="txtintInactivityTimeout" max="1000" min="1" runat="server" ></eidss:NumericSpinner>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                    </asp:table>
                </asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">&nbsp;</asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:Table ID="buttonCollection" runat="server" Width="100%">
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Center">
                                <asp:Button 
                                    ID="btnSave" 
                                    runat="server" 
                                    Text="<%$ Resources:Buttons, Btn_Save_Text %>" 
                                    ToolTip="<%$ Resources:Buttons, Btn_Save_ToolTip %>"/>
                                &nbsp;
                                <asp:Button 
                                    ID="btnOk" 
                                    runat="server" 
                                    Text="<%$ Resources:Buttons, Btn_Ok_Text %>"
                                    ToolTip="<%$ Resources:Buttons, Btn_Ok_ToolTip %>" />
                                &nbsp;
                                <asp:Button 
                                    ID="btnCancel" 
                                    runat="server" 
                                    Text="<%$ Resources:Buttons, Btn_Cancel_Text %>"
                                    ToolTip="<%$ Resources:Buttons, Btn_Cancel_ToolTip %>" />
                                &nbsp;
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </div>

</asp:Content>
