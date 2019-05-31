<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchFreezerUserControl.ascx.vb" Inherits="EIDSS.SearchFreezerUserControl" %>
<asp:UpdatePanel ID="upSearchFreezer" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfUserID" runat="server" />
        <asp:HiddenField ID="hdfSiteID" runat="server" />
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <div id="divSearchFreezerCriteria" runat="server" class="form-group">
                <div class="row" runat="server" meta:resourcekey="Dis_Freezer_Name">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Freezer_Name" runat="server"></div>
                        <label for="txtFreezerName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Freezer_Name_Text") %></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtFreezerName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtFreezerName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Freezer_Name" runat="server" ValidationGroup="SearchFreezer"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row" runat="server" meta:resourcekey="Dis_Note">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Note" runat="server"></div>
                        <label for="txtNote" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Note_Text") %></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtNote" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtNote" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Note" runat="server" ValidationGroup="SearchFreezer"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row" runat="server" meta:resourcekey="Dis_Storage_Type">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Storage_Type" runat="server"></div>
                        <label for="ddlStorageTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Storage_Type_Text") %></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <eidss:DropDownList CssClass="form-control" ID="ddlStorageTypeID" runat="server"></eidss:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlStorageTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Storage_Type" runat="server" ValidationGroup="SearchFreezer"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row" runat="server" meta:resourcekey="Dis_Building">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Building" runat="server"></div>
                        <label for="txtBuilding" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Building_Text") %></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtBuilding" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtBuilding" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Building" runat="server" ValidationGroup="SearchFreezer"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row" runat="server" meta:resourcekey="Dis_Room">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Room" runat="server"></div>
                        <label for="txtRoom" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Room_Text") %></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtRoom" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtRoom" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Room" runat="server" ValidationGroup="SearchFreezer"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="modal-footer text-center" style="padding-left: 0px; padding-right: 0px;">
                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchFreezer" />
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
