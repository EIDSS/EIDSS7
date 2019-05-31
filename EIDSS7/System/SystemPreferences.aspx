<%@ Page Title="System Preferences (C09)" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="SystemPreferences.aspx.vb" Inherits="EIDSS.SystemPreferences" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:ScriptManagerProxy runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/Includes/Scripts/jquery-3.1.1.min.js" />
            <asp:ScriptReference Path="~/Includes/Scripts/bootstrap.min.js" />
            <asp:ScriptReference Path="~/Includes/Scripts/search.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div style="width: 100%; text-align: center; padding: 0px 0px">
        <asp:Table runat="server" ID="canvasUpdatePreferences" Width="700px">

            <asp:TableHeaderRow runat="server">
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Left">
                    System Policy
                </asp:TableHeaderCell>
                <asp:TableHeaderCell runat="server" Width="50%" HorizontalAlign="Right">
                    C09
                </asp:TableHeaderCell>
            </asp:TableHeaderRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:table ID="tblMain" runat="server" Width="100%">
                        <asp:TableHeaderRow runat="server">
                            <asp:TableHeaderCell runat="server" ColumnSpan="5">
                                Main
                            </asp:TableHeaderCell>
                        </asp:TableHeaderRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ColumnSpan="5">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="Startup Language"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:DropDownList runat="server" ID="ddlStartupLanguage" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="Country"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:DropDownList runat="server" ID="ddlCountry" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="Barcode Printer"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:DropDownList runat="server" ID="ddlBarcodePrinter" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="Document Printer"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:DropDownList runat="server" ID="ddlDocumentPrinter" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="EPI Info Path"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:FileUpload ID="fuEPIInfoPath" runat="server" />
                                <br />
                                <asp:Label ID="lblEPIInfoPath" runat="server" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" Width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="25%" HorizontalAlign="Right">
                                <asp:Label runat="server" Text="Default Map Project"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                            <asp:TableCell runat="server" Width="68%" HorizontalAlign="Left">
                                <asp:DropDownList runat="server" ID="ddlDefaultMapProject" />
                            </asp:TableCell>
                            <asp:TableCell runat="server" Width="1%">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                    </asp:table>

                </asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="2">
                    <asp:table ID="tblAdditional" runat="server" Width="100%">
                        <asp:TableHeaderRow runat="server">
                            <asp:TableHeaderCell runat="server" ColumnSpan="5">
                                Additional
                            </asp:TableHeaderCell>
                        </asp:TableHeaderRow>

                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" ColumnSpan="5">&nbsp;</asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowTextInToolbar" runat="server" Text="Show text in Toolbar" />
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowWarning" runat="server" Text="Show warning when big layout loading" />
                            </asp:TableCell>
                        </asp:TableRow>

                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowSaveDataPrompt" runat="server" Text="Show save data prompt" />
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkPrintVetrinaryMap" runat="server" Text="Print map in Vetrenary Investigtion Forms" />
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowNavigatorInH02Form" runat="server" Text="Show navigator in H02 form" />
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowStarForBlank" runat="server" Text="Show * for blank values in AVR" />
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkLabModuleSimplifiedMode" runat="server" Text="Lab module simplified mode" />
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkFilterSamplesByDiag" runat="server" Text="Filter samples by diagnosis" />
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkDefaultRegionInSearchPanel" runat="server" Text="Default region in search panels" />
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <asp:CheckBox ID="chkShowWarningForFinalCase" runat="server" Text="Show warning for final case classification" />
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell runat="server" width="5%">&nbsp;</asp:TableCell>
                            <asp:TableCell Width="50%" HorizontalAlign="Left">
                                <asp:Label runat="server" Text="Number of days for which data is displayed by default"></asp:Label>
                            </asp:TableCell>
                            <asp:TableCell Width="45%" HorizontalAlign="Left">
                                <eidss:NumericSpinner  runat="server" id="uccDefualtNumberofDaysDisplayed" ></eidss:NumericSpinner>
                            </asp:TableCell>
                        </asp:TableRow>

                    </asp:table>
                </asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="3">&nbsp;</asp:TableCell>
            </asp:TableRow>

            <asp:TableRow runat="server">
                <asp:TableCell runat="server" ColumnSpan="3">
                    <asp:Table ID="buttonCollection" runat="server" Width="100%">
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Center">
                                <asp:Button ID="btnSave" runat="server" Text="Save" />
                                &nbsp;
                                <asp:Button ID="btnOk" runat="server" Text="Ok" />
                                &nbsp;
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" />
                                &nbsp;
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </asp:TableCell>
            </asp:TableRow>

        </asp:Table>

    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%= uccDefualtNumberofDaysDisplayed.ClientID %>").keyup(function () {
                var numberBox = $("#<%= uccDefualtNumberofDaysDisplayed.ClientID %>");
                if(numberBox.val() < 1 ||| numberBox.val() > 1000)
                {
                    return false;
                }
            })
        });
    </script>

</asp:Content>
