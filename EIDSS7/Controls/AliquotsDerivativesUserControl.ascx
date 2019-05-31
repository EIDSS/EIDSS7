<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AliquotsDerivativesUserControl.ascx.vb" Inherits="EIDSS.AliquotsDerivativesUserControl" %>
<div id="divAliquotDerivative">
    <div class="aliquoutDerivativeBox">
        <div class="aliquotDerivativeSamplesBox">
            <div class="table-responsive">
                <asp:UpdatePanel ID="upCreateAliquotDerivativeSelectedSamples" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:GridView ID="gvSelectedSamples" runat="server" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="SampleID" ShowHeaderWhenEmpty="true" ShowHeader="true" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="False" GridLines="None">
                            <HeaderStyle CssClass="table-striped-header" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnToggleSamples" runat="server" CommandName="Toggle Select" CommandArgument='<% #Bind("SampleID") %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="EIDSSLaboratorySampleID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                                <asp:BoundField DataField="SampleTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
        <div class="aliquotDerivativeSetupBox">
            <div class="form-group">
                <div class="row vertical-align-middle">
                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-5">
                        <asp:UpdatePanel ID="upCreateAliquotDerivative" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:RadioButtonList ID="rblCreateAliquotDerivative" runat="server" CssClass="radiobuttonlist" RepeatDirection="Vertical" RepeatLayout="Flow" AutoPostBack="True"></asp:RadioButtonList>
                                <asp:RequiredFieldValidator ControlToValidate="rblCreateAliquotDerivative" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Aliquot_Derivative" runat="server" ValidationGroup="AliquotDerivatives"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                        <span class="glyphicon glyphicon-asterisk text-danger"></span>
                        <label><%= GetLocalResourceObject("Lbl_New_Samples_Text") %></label>
                        <eidss:NumericSpinner ID="txtNumberOfSamples" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                        <asp:RequiredFieldValidator ControlToValidate="txtNumberOfSamples" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Number_of_Samples" runat="server" ValidationGroup="AliquotDerivatives"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-5">
                        <asp:UpdatePanel ID="upTypeOfAliquotDerivative" runat="server" UpdateMode="Conditional">
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="rblCreateAliquotDerivative" EventName="SelectedIndexChanged" />
                            </Triggers>
                            <ContentTemplate>
                                <span id="reqTypeOfDerivative" runat="server" class="glyphicon glyphicon-asterisk text-danger"></span>
                                <label><%= GetLocalResourceObject("Lbl_Type_Of_Derivative_Text") %></label>
                                <asp:DropDownList ID="ddlTypeOfDerivative" runat="server" CssClass="form-control"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvDerivativeType" ControlToValidate="ddlTypeOfDerivative" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Derivative_Type" runat="server" ValidationGroup="AliquotDerivatives"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                        <asp:Button ID="btnOK" runat="server" CssClass="btn btn-primary" CausesValidation="True" ValidationGroup="AliquotDerivatives" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">&nbsp;</div>
    <asp:UpdatePanel ID="upAliquotsDerivatives" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnOK" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
            <asp:HiddenField ID="hdfSiteID" runat="server" />
            <asp:HiddenField ID="hdfPersonID" runat="server" />
            <asp:HiddenField ID="hdfFreezerSubdivisionID" runat="server" Value="" />
            <asp:HiddenField ID="hdfRows" runat="server" Value="" />
            <asp:HiddenField ID="hdfColumns" runat="server" Value="" />
            <asp:HiddenField ID="hdfCurrentModuleAction" runat="server" Value="" />
            <asp:HiddenField ID="hdfCurrentRecord" runat="server" Value="" />
            <div class="table-responsive">
                <asp:GridView ID="gvAliqoutsDerivatives" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="SampleID" ShowHeaderWhenEmpty="true" ShowHeader="true" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="False" GridLines="None" AllowPaging="true" PagerSettings-Visible="false">
                    <HeaderStyle CssClass="table-striped-header" />
                    <Columns>
                        <asp:BoundField DataField="ParentEIDSSLaboratorySampleID" SortExpression="ParentEIDSSLaboratorySampleID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" />
                        <asp:BoundField DataField="EIDSSLaboratorySampleID" SortExpression="EIDSSLaboratorySampleID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_New_Lab_Sample_ID_Text %>" />
                        <asp:BoundField DataField="SampleTypeName" SortExpression="SampleTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" />
                        <asp:BoundField DataField="FunctionalAreaName" SortExpression="FunctionalAreaName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Functional_Area_Text %>" />
                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Storage_Location_Text %>">
                            <ItemTemplate>
                                <div>
                                    <div style="width: 19px; float: left">
                                        <img src="../Includes/Images/freezer.png" width="18" height="25" />
                                    </div>
                                    <asp:TreeView ID="treSubdivisions" runat="server" ExpandDepth="4" ImageSet="Arrows" OnSelectedNodeChanged="Subdivisions_SelectedNodeChanged" NodeIndent="20">
                                        <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
                                        <NodeStyle HorizontalPadding="5px" NodeSpacing="0px" VerticalPadding="0px" />
                                        <ParentNodeStyle Font-Bold="False" />
                                        <SelectedNodeStyle Font-Underline="True" ForeColor="#5555DD" HorizontalPadding="0px" VerticalPadding="0px" />
                                    </asp:TreeView>

                                    <asp:Table ID="tblBoxConfiguration" runat="server" Visible="false" CssClass="boxConfigurationTable"></asp:Table>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField SortExpression="Note" HeaderText="<%$ Resources: Labels, Lbl_Comment_Text %>">
                            <ItemTemplate>
                                <div class="flex-container">
                                    <asp:TextBox ID="txtNote" runat="server" CssClass="form-control" MaxLength="500" Text='<% #Bind("Note") %>' ToolTip='<% #Bind("SampleID") %>' Width="225" AutoPostBack="True" OnTextChanged="Note_TextChanged"></asp:TextBox>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" meta:resourceKey="Btn_Delete" CommandArgument='<% #Bind("SampleID") %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<div id="divAliquotDerivativeWarningModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
    <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="modal-dialog" role="document">
                <div class="panel-warning alert alert-warning">
                    <div class="panel-heading">
                        <button type="button" class="close" onclick="hideModal('#divWarningModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="alert-link" id="hdgWarning" runat="server"></h4>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <strong id="warningSubTitle" runat="server"></strong>
                                <br />
                                <div id="divWarningBody" runat="server"></div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group text-center">
                        <div id="divWarningYesNo" runat="server">
                            <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                            <button id="btnWarningModalNo" type="button" class="btn btn-warning alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>" onclick="useHideModalOrModalOnModal('#divCreateAliquotDerivativeModal', '#divWarningModal');"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                        </div>
                        <div id="divWarningOK" runat="server">
                            <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" onclick="hideModal('#divWarningModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<script lang="javascript" type="text/javascript">
    function boxLocationChanged(obj) {

        __doPostBack(obj, 'BoxLocationChanged');
    }

    function showModalOnModal(div) {
        $(div).modal({ show: true });
    }
</script>
