<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AssignTestUserControl.ascx.vb" Inherits="EIDSS.AssignTestUserControl" %>
<asp:UpdatePanel ID="upAssignTest" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnNewTestAssignment" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" visible="false">
            <asp:HiddenField ID="hdfDiseaseIDList" runat="server" Value="" />
            <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
            <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
            <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
        </div>
        <div class="row">
            <div class="col-md-4">

                <asp:CheckBox ID="cbxFilterTestNameByDisease" runat="server" Checked="false" AutoPostBack="true" />&nbsp;<span class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Filter_Test_Name_By_Disease_Text") %></span>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">&nbsp;</div>
        </div>
        <div class="row">
            <div class="table-responsive">
                <eidss:GridView ID="gvTestAssignments" runat="server" CssClass="table table-striped" DataKeyNames="TestID" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CaptionAlign="Bottom" GridLines="None" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="false">
                    <HeaderStyle CssClass="table-striped-header" />
                    <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="400" HeaderStyle-Width="405">
                            <HeaderTemplate>
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Name" runat="server"></div>
                                <asp:Label ID="lblTestNameHeading" runat="server" Text="<%$ Resources: Labels, Lbl_Test_Name_Text %>"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:UpdatePanel ID="upEditTestNameTypeID" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlEditTestNameTypeID" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <eidss:DropDownList ID="ddlEditTestNameTypeID" runat="server" CssClass="form-control" Width="400" AutoPostBack="true" OnSelectedIndexChanged="EditTestNameTypeID_SelectedIndexChanged" />
                                        <asp:RequiredFieldValidator ControlToValidate="ddlEditTestNameTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Name" runat="server" ValidationGroup="AssignTest"></asp:RequiredFieldValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="400" HeaderStyle-Width="405">
                            <HeaderTemplate>
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result" runat="server"></div>
                                <asp:Label ID="lblTestResultHeading" runat="server" Text="<%$ Resources: Labels, Lbl_Test_Result_Text %>"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:UpdatePanel ID="upEditTestResultTypeID" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlEditTestResultTypeID" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <eidss:DropDownList ID="ddlEditTestResultTypeID" runat="server" CssClass="form-control" Width="400" AutoPostBack="true" OnSelectedIndexChanged="EditTestResultTypeID_SelectedIndexChanged" />
                                        <asp:RequiredFieldValidator ControlToValidate="ddlEditTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Result" runat="server" ValidationGroup="AssignTest"></asp:RequiredFieldValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField></asp:TemplateField>
                    </Columns>
                </eidss:GridView>
            </div>
        </div>
        <div style="width: 408px; float: none !important; display: inline-block !important;">
            <eidss:DropDownList ID="ddlInsertTestNameTypeID" runat="server" CssClass="form-control" Width="400" />
            <asp:RequiredFieldValidator ControlToValidate="ddlInsertTestNameTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Name" runat="server" ValidationGroup="AssignTest"></asp:RequiredFieldValidator>
        </div>
        <div style="width: 400px; float: none !important; display: inline-block !important;">
            <eidss:DropDownList ID="ddlInsertTestResultTypeID" runat="server" CssClass="form-control" Width="400" />
            <asp:RequiredFieldValidator ControlToValidate="ddlInsertTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Test_Result" runat="server" ValidationGroup="AssignTest"></asp:RequiredFieldValidator>
        </div>
        <div style="width: 50px; float: none !important; display: inline-block !important;">
            <asp:LinkButton ID="btnNewTestAssignment" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="true" ValidationGroup="AssignTest"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
