<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NonDtraSampleUserControl.ascx.vb" Inherits="EIDSS.NonDtraSampleUserControl" %>
<%@ Register Assembly="EIDSSControlLibrary" Namespace="EIDSSControlLibrary" TagPrefix="eidss" %>
<asp:UpdatePanel ID="NonDTRASampleUpdatePanel" runat="server">
    <Triggers></Triggers>
    <ContentTemplate>
        <div class="panel-group">
            <h2><%= GetLocalResourceObject("Pnl_Non_Dtra_Sample_Heading") %></h2>
            <div><%= GetLocalResourceObject("Pnl_Non_Dtra_Sample_Text") %></div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-heading"><%= GetLocalResourceObject("Pnl_Registration_Heading") %></div>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="ddlSampleType"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Sample_Type_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Sample_Type_ToolTip %>"></asp:Label>
                                <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label1"
                                    runat="server"
                                    AssociatedControlID="txtLocalSampleID"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Local_Sample_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Local_Sample_Text %>"></asp:Label>
                                <asp:TextBox ID="txtLocalSampleID" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label2"
                                    runat="server"
                                    AssociatedControlID="txtCollectionDate"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, LblCollectionDateText %>"
                                    ToolTip="<%$ Resources:Labels, LblCollectionDateToolTip %>"></asp:Label>
                                <asp:TextBox ID="txtCollectionDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label3"
                                    runat="server"
                                    AssociatedControlID="txtSentDate"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Sent_Date_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Sent_Date_ToolTip %>"></asp:Label>
                                <asp:TextBox ID="txtSentDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label4"
                            runat="server"
                            AssociatedControlID="ddlDestinationLab"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, Lbl_Destination_Lab_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Destination_Lab_ToolTip %>"></asp:Label>
                        <asp:DropDownList ID="ddlDestinationLab" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label5"
                            runat="server"
                            AssociatedControlID="txtNotes"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, Lbl_Additional_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Additional_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                    </div>
                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <% = GetLocalResourceObject("Pnl_Accession_Heading") %>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label6"
                                    runat="server"
                                    AssociatedControlID="txtAccessionDate"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Lbl_Accession_Date_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Accession_Date_ToolTip %>"></asp:Label>
                                <asp:TextBox ID="txtAccessionDate" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label7"
                                    runat="server"
                                    AssociatedControlID="ddlSampleCondition"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Lbl_Sample_Condition_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Sample_Condition_ToolTip %>"></asp:Label>
                                <asp:DropDownList ID="ddlSampleCondition" runat="server" CssClass="form-control"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label8"
                            runat="server"
                            AssociatedControlID="txtAccessionComments"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, LblCommentsText %>"
                            ToolTip="<%$ Resources:Labels, LblCommentsToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtAccessionComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                    </div>

                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <%= GetLocalResourceObject("Pnl_Testing_Info_Heading") %>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label9"
                                    runat="server"
                                    AssociatedControlID="ddlTestName"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Lbl_Test_Name_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Test_Name_ToolTip %>"></asp:Label>
                                <asp:DropDownList ID="ddlTestName" runat="server" CssClass="form-control"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label10"
                                    runat="server"
                                    AssociatedControlID="ddlTestResult"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Lbl_Test_Result_Text %>"
                                    ToolTip="<%$ Resources:Lbl_Test_Result_ToolTip %>"></asp:Label>
                                <asp:DropDownList ID="ddlTestResult" runat="server" CssClass="form-control"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label11"
                            runat="server"
                            AssociatedControlID="txtResultDate"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Result_Date_Text %>"
                            ToolTip="<%$ Resources:Lbl_Result_Date_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtResultDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label12"
                            runat="server"
                            AssociatedControlID="ddlCollectedByInstitution"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Collected_Institution_Text %>"
                            ToolTip="<%$ Resources:Lbl_Collected_Institution_ToolTip %>"></asp:Label>
                        <eidss:DropDownList ID="ddlCollectedByInstitution" runat="server" AddPageUrl="" PopUpWindowId="" SearchPageUrl=""></eidss:DropDownList>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label13"
                            runat="server"
                            AssociatedControlID="ddlCollectedByInstitution"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Collected_Officer_Text %>"
                            ToolTip="<%$ Resources:Lbl_Collected_Officer_ToolTip %>"></asp:Label>
                        <eidss:DropDownList ID="ddlCollectedByOfficer" runat="server" AddPageUrl="" PopUpWindowId="" SearchPageUrl=""></eidss:DropDownList>
                    </div>
                </div>
                <div class="panel-footer">
                    <div class="form-group">
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            <span><%= GetGlobalResourceObject("Buttons", "Btn_Close_Text") %></span>
                        </button>
                        <asp:LinkButton CssClass="btn btn-primary" ID="btnAddNewSample" runat="server" ToolTip="<%$ Resources: Buttons, Btn_Add_Sample_ToolTip %>">
                            <span><%= GetGlobalResourceObject("Buttons", "Btn_Add_Sample_Text") %></span>
                        </asp:LinkButton>

                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
