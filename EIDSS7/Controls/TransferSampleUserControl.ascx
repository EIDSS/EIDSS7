<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TransferSampleUserControl.ascx.vb" Inherits="EIDSS.TransferSampleUserControl" %>

<asp:UpdatePanel ID="upTransferSample" runat="server" UpdateMode="Conditional">
    <Triggers>
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
        <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
        <asp:HiddenField ID="hdfFirstName" runat="server" Value="" />
        <asp:HiddenField ID="hdfLastName" runat="server" Value="" />
        <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
        <asp:HiddenField ID="hdfOrganizationName" runat="server" Value="" />
        <asp:HiddenField ID="hdfOldTransferredToOrganizationID" runat="server" Value="" />

        <div class="panel panel-default">
            <div class="panel-body">
                <div id="divEIDSSTransferID" runat="server">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                            <label for="<%= txtEIDSSTransferID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Transfer_ID_Text") %></label>
                        </div>
                        <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                            <asp:TextBox ID="txtEIDSSTransferID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">&nbsp;</div>
                </div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <label for="<%= txtPurposeOfTransfer.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Purpose_Of_Transfer_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <asp:TextBox ID="txtPurposeOfTransfer" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Requested" runat="server"></div>
                        <label for="<%= txtTestRequested.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Requested_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <asp:TextBox ID="txtTestRequested" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTestRequested" ControlToValidate="txtTestRequested" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Requested" runat="server"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Transferred_To" runat="server"></div>
                        <label for="<%= ddlTransferredToOrganizationID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Transferred_To_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <eidss:DropDownList CssClass="form-control" ID="ddlTransferredToOrganizationID" runat="server"></eidss:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTransferredToOrganization" ControlToValidate="ddlTransferredToOrganizationID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Transferred_To" runat="server"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Date_Sent" runat="server"></div>
                        <label for="<%= txtTransferDate.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Sent_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <eidss:CalendarInput ID="txtTransferDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                        <asp:RequiredFieldValidator ID="rfvTransferDate" ControlToValidate="txtTransferDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Sent" runat="server"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <label for="<%= txtTransferredFromOrganizationName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Transferred_From_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <asp:TextBox ID="txtTransferredFromOrganizationName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <label for="<%= txtSentByPersonName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sent_By_Text") %></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <asp:TextBox ID="txtSentByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
