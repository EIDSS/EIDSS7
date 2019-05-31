<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="TemplateEditor.aspx.vb" Inherits="EIDSS.TemplateEditor" %>

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
            /*border-style: solid;
            border-color: black;*/
            padding-top: 10px;
            padding-left: 10px;
            width: 70%;
        }

        .sectioncenter {
            text-align: center;
            white-space: pre;
        }

        .Diagnosis {
            white-space: pre;
        }
    </style>

    <script type="text/javascript">
        function OpenPopUp() {
            $find('programmaticModalPopup').show();
        }
    </script>
    <script>
        function getcustomcheckboxvalue() {
            var chk = $('.customcheckbox').find('input[type="checkbox"]');
            var idfparamter = [];
            chk.each(function () {
                if ($(this).prop("checked") == true) {
                    var abc = $(this).parent().attr('name');
                    idfparamter.push(abc);
                    idfparamter.join();
                }
            });
            document.getElementById('<%= hdnidfparamter.ClientID %>').value = idfparamter;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="hdg_Template_Editor"></h2>
                </div>
                <div id="TemplateEditorForm" class="panel-body" runat="server">
                    <div class="formContainer">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <div class="panel-footer">
                                    <%--Begin: Hidden fields--%>
                                    <asp:UpdatePanel runat="server" ID="UpdatePanelChild" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
                                                <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                                                <asp:HiddenField runat="server" ID="hdfFormType" />
                                                <asp:HiddenField runat="server" ID="hdfFormTemplate" />
                                            </div>
                                            <%-- End: Hidden Fields --%>
                                            <asp:UpdatePanel ID="Up3" runat="server">
                                                <ContentTemplate>
                                                    <div class="row" id="divCrudButtonPanel" runat="server">
                                                        <div class="col-md-4" style="border: solid; border-left: none; border-right: none; border-width: 2px;">
                                                            <asp:Button ID="hButton" runat="server" Style="display: none;" />
                                                            <asp:LinkButton ID="btnaddTemplate" CausesValidation="true" CssClass="btn glyphicon glyphicon-plus" Text="" runat="server" ToolTip="Add Template" OnClick="btnaddTemplate_Click" />

                                                            <asp:LinkButton ID="btnEditTemplate" CssClass="btn glyphicon glyphicon-edit" runat="server" Text="" ToolTip="Edit Template" OnClick="btnEditTemplate_Click" />

                                                            <ajaxToolkit:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlPopup1" Enabled="true" TargetControlID="hButton"
                                                                BackgroundCssClass="modalBackground">
                                                            </ajaxToolkit:ModalPopupExtender>
                                                            <asp:LinkButton ID="btnDeleteTemplate" CssClass="btn glyphicon glyphicon-floppy-remove" runat="server" Text="" ToolTip="Delete Template" OnClick="btnDeleteTemplate_Click" />
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>

                                            <div class="row">
                                                <div class="col-md-4" style="padding-left: 0px; padding-right: 0px;">
                                                    <div class="table-responsive" style="margin-top: 10px; margin-left: 0px;">
                                                        <div id="gridRef">
                                                            <asp:TreeView ID="TvTempleteEditor" runat="server" Height="300px" ImageSet="XPFileExplorer" NodeIndent="15" ShowLines="True" OnSelectedNodeChanged="TvTempleteEditor_SelectedNodeChanged">
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

                                                <div class="col-md-8" runat="server" id="divTemplete" visible="false">
                                                    <div class="row">
                                                        <div class="col-md-12" style="text-align: right;">
                                                            <asp:HiddenField runat="server" ID="hdnidfparamter" />
                                                            <asp:Button runat="server" ID="btnDeleteparameter" Text="Delete Paramter" Visible="false" CssClass="btn btn-primary" OnClientClick="getcustomcheckboxvalue();" OnClick="btnDeleteparameter_Click" />
                                                        </div>
                                                    </div>
                                                    <fieldset style="overflow: auto;">
                                                        <legend>
                                                            <asp:Label runat="server" ID="lbl_legend_title"></asp:Label></legend>
                                                        <asp:Panel runat="server" ID="pnlCaseClassification" Width="100%">
                                                        </asp:Panel>
                                                    </fieldset>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Panel ID="pnlPopup1" runat="server" CssClass="modalPopup" Style="display: none">
                                                <div class="header">
                                                    <h2 runat="server" visible="false" id="hdgEditTemplate" meta:resourcekey="hdg_Edit_Template"></h2>
                                                    <h2 runat="server" visible="false" id="hdgAddTemplate" meta:resourcekey="hdg_Add_Template"></h2>

                                                </div>
                                                <hr />

                                                <div class="body col-md-12">
                                                    <div class="row" style="margin-bottom: 10px;">
                                                        <div class="col-md-2"></div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" meta:resourcekey="Default_Name"></asp:Label>&nbsp<span style="color: red">*</span>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <asp:TextBox runat="server" ID="txtDefaultName" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ID="rfvstrDefaultName" ForeColor="Red" runat="server" ErrorMessage="You must Enter Default Name." ControlToValidate="txtDefaultName" ValidationGroup="SaveTemplateValidation"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-md-2"></div>
                                                    </div>
                                                    <div class="row" style="margin-bottom: 10px;">
                                                        <div class="col-md-2"></div>
                                                        <div class="col-md-3">

                                                            <asp:Label runat="server" meta:resourcekey="Is_Uni_Template"></asp:Label>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <asp:CheckBox runat="server" ID="chkIsUniTemplate"></asp:CheckBox>
                                                        </div>
                                                        <div class="col-md-2"></div>
                                                    </div>
                                                    <div class="row" style="margin-bottom: 10px;">
                                                        <div class="col-md-2"></div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" meta:resourcekey="National_Name"></asp:Label>&nbsp<span style="color: red">*</span>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <asp:TextBox runat="server" ID="txtNationalName" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ID="rfvstrNationalName" ForeColor="Red" runat="server" ErrorMessage="You must Enter National Name." ControlToValidate="txtNationalName" ValidationGroup="SaveTemplateValidation"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-md-2"></div>
                                                    </div>
                                                    <div class="row" style="margin-bottom: 10px;">
                                                        <div class="col-md-2"></div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" meta:resourcekey="Note"></asp:Label>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <asp:TextBox TextMode="MultiLine" runat="server" ID="txtNote" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="col-md-2"></div>
                                                    </div>
                                                </div>
                                                <hr />
                                                <div class="footer" align="right" style="padding-bottom: 15px !important; margin-right: 15px !important;">
                                                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" ValidationGroup="SaveTemplateValidation" OnClick="btnSave_Click" />
                                                    <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-danger" OnClick="btnClose_Click" />
                                                </div>
                                            </asp:Panel>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnEditTemplate" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnaddTemplate" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnDeleteTemplate" EventName="Click" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
