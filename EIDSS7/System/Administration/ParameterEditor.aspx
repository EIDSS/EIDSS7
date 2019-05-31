<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ParameterEditor.aspx.vb" Inherits="EIDSS.ParameterEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../../Includes/CSS/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .container {
            margin-top: 20px;
        }

        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 70%;
        }

        .loadersmall {
            position: absolute;
            left: 86%;
            margin-top: 17px;
            border: 5px solid #f3f3f3;
            border-top-color: rgb(243, 243, 243);
            border-top-style: solid;
            border-top-width: 5px;
            -webkit-animation: spin 1s linear infinite;
            animation: spin 1s linear infinite;
            border-top: 4px solid #555;
            border-radius: 50%;
            width: 40px;
            height: 40px;
        }
    </style>
    <script>
        function LoadinPanelshow() {
            $(".loadersmall").css("display", "block");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="hdg_Parameter_Editor"></h2>
                </div>
                <div id="parameterTypeQuestionEditorForm" class="panel-body" runat="server">
                    <asp:UpdatePanel runat="server" ID="UpdatePanelChild">
                        <ContentTemplate>
                            <div class="row">
                                <div class="formContainer">
                                    <div class="panel panel-default">
                                        <div class="panel-body">

                                            <div class="panel-footer">
                                                <div class="row" id="divCrudButtonPanel" runat="server">
                                                    <div class="col-md-4" style="border: solid; border-left: none; border-right: none; border-width: 2px;">
                                                        <asp:LinkButton ID="lnksearch" CausesValidation="true" CssClass="btn glyphicon glyphicon-search" Text="" runat="server" ToolTip="search" OnClick="lnksearch_Click" />
                                                        <ajaxToolkit:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlPopup1" Enabled="true" TargetControlID="lnksearch"
                                                            BackgroundCssClass="modalBackground">
                                                        </ajaxToolkit:ModalPopupExtender>
                                                        <asp:LinkButton Visible="false" ID="btnParameteradd" CausesValidation="true" CssClass="btn glyphicon glyphicon-plus-sign" Text="" runat="server" ToolTip="Add Parameter" ValidationGroup="AddParam" OnClick="btnParameteradd_Click" />
                                                        <asp:LinkButton Visible="false" CssClass="btn glyphicon glyphicon-ok-circle" runat="server" Text="" ID="btnsaveParameter" ToolTip="Save Parameter" OnClick="btnsaveParameter_Click" OnClientClick="return LoadinPanelshow();" />
                                                        <asp:LinkButton Visible="false" ID="btnEditParameter" CssClass="btn glyphicon glyphicon-edit" runat="server" Text="" ToolTip="Edit Parameter" OnClick="btnEditParameter_Click" />
                                                        <asp:LinkButton Visible="false" ID="btnParameterCancel" CssClass="btn glyphicon glyphicon-remove-circle" runat="server" ToolTip="Cancel" Text="" CausesValidation="false" OnClick="btnParameterCancel_Click" />
                                                        <asp:LinkButton Visible="false" ID="btnDeleteParameter" CssClass="btn glyphicon glyphicon-remove-sign" runat="server" Text="" ToolTip="Delete Parameter" />
                                                        <asp:LinkButton Visible="false" ID="btnAddItem" CausesValidation="true" CssClass="btn glyphicon glyphicon-plus" Text="" runat="server" ToolTip="Add section" ValidationGroup="AddNewParamterTypeValidation" OnClick="btnAddItem_Click" />
                                                        <asp:LinkButton Visible="false" CssClass="btn glyphicon glyphicon-ok-circle" runat="server" Text="" ID="btnsave" ToolTip="Save section" OnClick="btnsave_Click" />
                                                        <asp:LinkButton Visible="false" ID="btnEdit" CssClass="btn glyphicon glyphicon-edit" runat="server" Text="" ToolTip="Edit section" OnClick="btnEdit_Click" />
                                                        <asp:LinkButton Visible="false" ID="btnCancel" CssClass="btn glyphicon glyphicon-remove-circle" runat="server" ToolTip="Cancel" Text="" CausesValidation="false" OnClick="btnCancel_Click" />
                                                        <asp:LinkButton Visible="false" ID="btnDelete" CssClass="btn glyphicon glyphicon-floppy-remove" runat="server" Text="" ToolTip="Delete section" OnClick="btnDelete_Click" OnClientClick="return LoadinPanelshow();" />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <%--Begin: Hidden fields--%>
                                                    <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                                                        <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                                                    </div>
                                                    <%-- End: Hidden Fields --%>

                                                    <div class="col-md-4" style="padding-left: 0px; padding-right: 0px;">
                                                        <div class="table-responsive" style="margin-top: 10px; margin-left: 0px;">
                                                            <div id="gridRef">
                                                                <asp:TreeView ID="TreeView1" runat="server" Height="300px" ImageSet="XPFileExplorer" NodeIndent="15" ShowLines="True" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged">
                                                                    <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                                                                    <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
                                                                        NodeSpacing="0px" VerticalPadding="2px"></NodeStyle>
                                                                    <ParentNodeStyle Font-Bold="False" />
                                                                    <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
                                                                        VerticalPadding="0px" />

                                                                </asp:TreeView>

                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-8" runat="server">
                                                        <div class="row">
                                                            <asp:HiddenField ID="hdnSectionId" runat="server" />
                                                            <asp:HiddenField ID="hdfformType" runat="server" />
                                                            <asp:HiddenField ID="hdnidfsParentSection" runat="server" />
                                                            <div class="col-md-12">
                                                                <table border="1" runat="server" visible="true" id="tblcreatesection" style="width: 100%; margin-top: 20px;">
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_DefaultSectionName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtDefaultName" />
                                                                        </td>
                                                                    </tr>
                                                                    <%-- <tr>
                                                                <td style="text-align: left;">Full Path</td>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelFullPath" />
                                                                </td>
                                                            </tr>--%>
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_SectionNationalName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtNationalName" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_SectionType"></td>
                                                                        <td>
                                                                            <asp:DropDownList runat="server" Width="100%" BorderStyle="None" ID="ddlType">
                                                                                <asp:ListItem Text="Default" Value="0" Selected="True" />
                                                                                <asp:ListItem Text="Table" Value="1" />
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <asp:HiddenField ID="hdnidfsParameter" runat="server" />
                                                            <asp:HiddenField ID="hdnsectionidvalue" runat="server" />
                                                            <asp:HiddenField ID="hdnformTypeid" runat="server" />
                                                            <asp:HiddenField ID="hdnstrNote" runat="server" />
                                                            <div class="col-md-12">
                                                                <table border="1" runat="server" visible="false" id="tblParameterTypeQuestionEditor" style="width: 100%; margin-top: 20px;">
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_DefaultLongName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtDefaultLongName" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_ParametrDefaultName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtParametrDefaultName" />
                                                                        </td>
                                                                    </tr>
                                                                    <%-- <tr>
                                                                <td style="text-align: left;">Full Path</td>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelFullPath" />
                                                                </td>
                                                            </tr>--%>
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_NationalLongName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtParameterNationalName" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="lbl_ParameterNationalName"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" Width="100%" BorderStyle="None" ID="txtParametrNationalLongName" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="ParameterType"></td>
                                                                        <td>
                                                                            <asp:DropDownList runat="server" Width="100%" BorderStyle="None" ID="ddlParameterType">
                                                                                <%-- <asp:ListItem Text="Default" Value="0" Selected="True" />
                                                                        <asp:ListItem Text="Table" Value="1" />--%>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="Editor"></td>
                                                                        <td>
                                                                            <asp:DropDownList runat="server" Width="100%" BorderStyle="None" ID="ddlEditor">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="HACode"></td>
                                                                        <td>
                                                                            <asp:DropDownList runat="server" Width="100%" BorderStyle="None" ID="ddlHACode">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="LabelSize"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" TextMode="Number" Width="100%" BorderStyle="None" ID="txtLabelSize" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="Scheme"></td>
                                                                        <td>
                                                                            <asp:DropDownList runat="server" Width="100%" BorderStyle="None" ID="ddlScheme">
                                                                                <asp:ListItem Text="Left" Value="0" Selected="True" />
                                                                                <asp:ListItem Text="Top" Value="1" />
                                                                                <asp:ListItem Text="Right" Value="2" />
                                                                                <asp:ListItem Text="Bottom" Value="3" />
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="Height"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" TextMode="Number" Width="100%" BorderStyle="None" ID="txtHeight" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td meta:resourcekey="Width"></td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" TextMode="Number" Width="100%" BorderStyle="None" ID="txtWidth" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="row" id="divTemplatesUsedParameters" runat="server" visible="false">
                                                            <div class="col-md-12">
                                                                <table border="1" id="tblTemplatesUsedParameters" style="width: 100%; margin-top: 20px;">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>
                                                                                <asp:Label runat="server" meta:resourcekey="used_Template"></asp:Label>
                                                                                &nbsp; &nbsp;<label runat="server" id="lblTemplatesCount"></label>
                                                                            </th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <asp:Repeater runat="server" ID="RptTemplatesUsedParameter">
                                                                            <ItemTemplate>
                                                                                <tr>
                                                                                    <td>
                                                                                        <label style="padding-left: 10px;"><%# Eval("DefaultName") %></label>
                                                                                    </td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                        </asp:Repeater>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlPopup1" runat="server" CssClass="modalPopup" Style="display: none">
                                <div class="header">
                                    <h2>Search </h2>
                                </div>
                                <hr />

                                <div class="body col-md-12">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="row">
                                                <div class="col-md-12" style="margin-top: 5px;">
                                                    <asp:Label runat="server" meta:resourcekey="Search_Section"></asp:Label>
                                                    &nbsp; &nbsp;&nbsp;&nbsp;<asp:TextBox ID="txtsectionsearch" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                                <div class="col-md-12" style="margin-top: 5px;">
                                                    <asp:Label runat="server" meta:resourcekey="Search_Parameter"></asp:Label>
                                                    <asp:TextBox ID="txtParametersearch" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <hr />
                                <div class="footer" align="right" style="padding-bottom: 15px !important; margin-right: 15px !important;">
                                    <asp:Button ID="btnSearch" CssClass="btn btn-primary" meta:resourcekey="Btn_Search" runat="server" OnClick="btnSearch_Click" OnClientClick="return LoadinPanelshow();" />
                                    <asp:Button ID="btnReset" CssClass="btn btn-primary" meta:resourcekey="Btn_Reset" runat="server" OnClick="btnReset_Click" OnClientClick="return LoadinPanelshow();" />
                                    <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-danger" OnClick="btnClose_Click" />
                                </div>
                            </asp:Panel>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="lnksearch" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
