<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="RegisterNewSampleUserControl.ascx.vb" Inherits="EIDSS.RegisterNewSampleUserControl" %>

<asp:UpdatePanel ID="upRegisterNewSample" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ddlReportSessionTypeID" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="btnLookupReportSession" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCreatePatientFarmOwner" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="txtReportSessionID" EventName="TextChanged" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField runat="server" ID="hdfRowStatus" Value="0" />
        <asp:HiddenField runat="server" ID="hdfMonitoringSessionID" Value="" />
        <asp:HiddenField runat="server" ID="hdfVeterinaryDiseaseReportID" Value="" />
        <asp:HiddenField runat="server" ID="hdfHumanDiseaseReportID" Value="" />
        <asp:HiddenField runat="server" ID="hdfVectorSurveillanceSessionID" Value="" />
        <asp:HiddenField runat="server" ID="hdfSampleID" Value="" />
        <asp:HiddenField runat="server" ID="hdfSiteID" Value="" />
        <asp:HiddenField runat="server" ID="hdfPersonID" Value="" />
        <asp:HiddenField runat="server" ID="hdfInstitutionID" Value="" />
        <asp:HiddenField runat="server" ID="hdfHumanID" Value="" />
        <asp:HiddenField runat="server" ID="hdfRecordID" Value="0" />
        <asp:HiddenField runat="server" ID="hdfRecordAction" Value="" />
        <asp:HiddenField runat="server" ID="hdfIdentity" Value="0" />
        <div id="divRegisterNewSample" runat="server">
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Session_Type">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Report_Session_Type" runat="server"></div>
                    <label for="<% =ddlReportSessionTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Session_Type_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:DropDownList ID="ddlReportSessionTypeID" runat="server" CssClass="form-control" onchange="showSearchReportSessionLoading();" AutoPostBack="true">
                        <asp:ListItem Text="" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Human Disease Report" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Human Active Surveillance Session" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Vector Surveillance Session" Value="3"></asp:ListItem>
                        <asp:ListItem Text="Veterinary Disease Report" Value="4"></asp:ListItem>
                        <asp:ListItem Text="Veterinary Active Surveillance Session" Value="5"></asp:ListItem>
                    </eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlReportSessionTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Report_Session_Type" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Session_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Report_Session_ID" runat="server"></div>
                    <label for="<% =txtReportSessionID.ClientID %>" runat="server" meta:resourcekey="Lbl_Report_Session_ID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Session_ID_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtReportSessionID" runat="server" CssClass="form-control" Enabled="false" AutoPostBack="True"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtReportSessionID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Report_Session_ID" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                </div>
                <div class="col-md-2">
                    <asp:LinkButton ID="btnLookupReportSession" runat="server" CssClass="btn btn-default btn-sm" Enabled="false" CausesValidation="false" data-loading-text="..."><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Patient_Farm_Owner">
                <div class="col-md-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Patient_Farm_Owner" runat="server"></div>
                    <label for="<% =txtPatientFarmOwner.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Patient_Farm_Owner_Text") %></label>
                </div>
                <div class="col-md-7">
                    <asp:TextBox ID="txtPatientFarmOwner" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtPatientFarmOwner" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Patient_Farm_Owner" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                </div>
                <div class="col-md-2">
                    <asp:LinkButton ID="btnLookupPatientFarmOwner" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                    <asp:LinkButton ID="btnCreatePatientFarmOwner" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Collection_Date">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collection_Date" runat="server"></div>
                    <label for="<% =txtCollectionDate.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Collection_Date_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:CalendarInput ID="txtCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                    <asp:RequiredFieldValidator ControlToValidate="txtCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Collection_Date" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvCollectionDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtCollectionDate" meta:resourcekey="Val_Future_Collection_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="RegisterNewSample"></asp:CompareValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Sample_Type">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Type" runat="server"></div>
                    <label for="<% =ddlSampleTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Sample_Type_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleTypeID" runat="server"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Number_of_Samples">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Number_of_Samples" runat="server"></div>
                    <label for="<% =txtNumberOfSamples.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Number_Of_Samples_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:NumericSpinner ID="txtNumberOfSamples" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                    <asp:RequiredFieldValidator ControlToValidate="txtNumberOfSamples" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Number_of_Samples" runat="server" ValidationGroup="RegisterNewSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Disease">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Disease"></div>
                    <label for="<% =ddlDiseaseID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDiseaseID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="RegisterNewSample" meta:resourceKey="Val_Disease"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function showSearchReportSessionLoading() {
                var btn = $("#EIDSSBodyCPH_ucRegisterNewSample_btnLookupReportSession")
                btn.button('loading')
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>