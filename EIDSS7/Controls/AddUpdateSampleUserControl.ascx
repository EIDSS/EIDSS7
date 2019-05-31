<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateSampleUserControl.ascx.vb" Inherits="EIDSS.AddUpdateSampleUserControl" %>
<div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
    <asp:HiddenField ID="hdfRowStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
    <asp:HiddenField ID="hdfUserID" runat="server" Value="" />
    <asp:HiddenField ID="hdfUserName" runat="server" Value="" />
    <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
    <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
    <asp:HiddenField ID="hdfMonitoringSessionID" runat="server" Value="" />
    <asp:HiddenField ID="hdfSessionCategoryTypeID" runat="server" Value="" />
    <asp:HiddenField ID="hdfHumanDiseaseReportID" runat="server" Value="" />
    <asp:HiddenField ID="hdfVeterinaryDiseaseReportID" runat="server" Value="" />
    <asp:HiddenField ID="hdfReportSessionTypeID" runat="server" Value="" />
    <asp:HiddenField ID="hdfVectorSurveillanceSessionID" runat="server" Value="" />
    <asp:HiddenField ID="hdfFreezerSubdivisionID" runat="server" Value="" />
    <asp:HiddenField ID="hdfRows" runat="server" Value="" />
    <asp:HiddenField ID="hdfColumns" runat="server" Value="" />
</div>
<asp:UpdatePanel ID="upAddUpdateSample" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="txtAccessionDate" EventName="TextChanged" />
        <asp:PostBackTrigger ControlID="btnReportSession" />
    </Triggers>
    <ContentTemplate>
        <div id="divEditSample" runat="server" class="accordion-body">
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Session_Type">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="btnReportSession" runat="server" meta:resourcekey="Lbl_Report_Session_ID" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:LinkButton ID="btnReportSession" runat="server"></asp:LinkButton>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Local_Field_Sample_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Local_Field_Sample_ID" runat="server"></div>
                    <label for="txtEIDSSLocalFieldSampleID" runat="server" meta:resourcekey="Lbl_Local_Field_Sample_ID" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtEIDSSLocalFieldSampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLocalFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Local_Field_Sample_ID" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Sample_Status">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Status" runat="server"></div>
                    <label for="txtAccessionConditionOrSampleStatusTypeName" runat="server" meta:resourcekey="Lbl_Sample_Status" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtAccessionConditionOrSampleStatusTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div id="divReasonForDeletion" runat="server">
                <div class="row">&nbsp;</div>
                <div class="row" runat="server" meta:resourcekey="Dis_Reason_For_Deletion">
                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Reason_For_Deletion" runat="server"></div>
                        <label for="txtReasonForDeletion" runat="server" meta:resourcekey="Lbl_Reason_For_Deletion" class="control-label"></label>
                    </div>
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                        <asp:TextBox ID="txtReasonForDeletion" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtReasonForDeletion" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Sample_ID" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Lab_Sample_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Sample_ID" runat="server"></div>
                    <label for="txtEIDSSLaboratorySampleID" runat="server" meta:resourcekey="Lbl_Lab_Sample_ID" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Sample_ID" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Sample_Type">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Type" runat="server"></div>
                    <label for="txtSampleTypeName" runat="server" meta:resourcekey="Lbl_Sample_Type" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtSampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtSampleTypeName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Accession_Date">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Accession_Date" runat="server"></div>
                    <label for="txtAccessionDate" runat="server" meta:resourcekey="Lbl_Accession_Date" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:CalendarInput ID="txtAccessionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false" ValidationGroup="EditSampleTestDetails" ValidateRequestMode="Enabled"></eidss:CalendarInput>
                    <asp:RequiredFieldValidator ControlToValidate="txtAccessionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Accession_Date" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvAccessionDate" Operator="LessThanEqual" CssClass="alert-danger" Type="Date" Display="Dynamic" ControlToValidate="txtAccessionDate" meta:resourcekey="Val_Future_Accession_Date" runat="server" ValidationGroup="EditSampleTestDetails" />
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Accession_In_Comment">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Accession_In_Comment" runat="server"></div>
                    <label for="txtAccessionComment" class="control-label" meta:resourcekey="Lbl_Sample_Status_Comment" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtAccessionComment" runat="server" CssClass="form-control" MaxLength="200" Enabled="false" Rows="4" TextMode="MultiLine"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtAccessionComment" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Sample_Condition_Received" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Collection_Date">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collection_Date" runat="server"></div>
                    <label for="txtCollectionDate" runat="server" meta:resourcekey="Lbl_Collection_Date" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:CalendarInput ID="txtCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                    <asp:RequiredFieldValidator ControlToValidate="txtCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Collection_Date" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Storage_Location">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Storage_Location" runat="server"></div>
                    <label for="txtdFreezerID" runat="server" meta:resourcekey="Lbl_Storage_Location" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <div style="width: 19px; float: left">
                        <img src="../Includes/Images/freezer.png" width="18" height="25" />
                    </div>
                    <asp:TreeView ID="treSubdivisions" runat="server" ExpandDepth="4" ImageSet="Arrows">
                        <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
                        <NodeStyle HorizontalPadding="5px" NodeSpacing="0px" VerticalPadding="0px" />
                        <ParentNodeStyle Font-Bold="False" />
                        <SelectedNodeStyle Font-Underline="True" ForeColor="#5555DD" HorizontalPadding="0px" VerticalPadding="0px" />
                    </asp:TreeView>
                    <asp:Table ID="tblBoxConfiguration" runat="server" Visible="false" CssClass="boxConfigurationTable"></asp:Table>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Functional_Area">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Functional_Area"></div>
                    <label for="<%= ddlFunctionalAreaID.ClientID %>" runat="server" meta:resourcekey="Lbl_Functional_Area"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlFunctionalAreaID" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlFunctionalAreaID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="EditSampleTestDetails" meta:resourceKey="Val_Functional_Area"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Original_Sample_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Original_Sample_ID" runat="server"></div>
                    <label for="txtParentEIDSSLaboratorySampleID" class="control-label" meta:resourcekey="Lbl_Original_Sample_ID" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtParentEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtParentEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Original_Sample_ID" runat="server" ValidationGroup="EditSampleTestDetails"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Session_Type">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtReportSessionTypeName" class="control-label" meta:resourcekey="Lbl_Report_Session_Type" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtReportSessionTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Patient_Species_Vector_Info">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtPatientSpeciesVectorInformation" class="control-label" meta:resourcekey="Lbl_Patient_Species_Vector_Info" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtPatientSpeciesVectorInformation" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Tests_Count">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtTestAssignedCount" runat="server" meta:resourcekey="Lbl_Tests_Count" class="control-label"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtTestAssignedCount" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Organization_Sent_To">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtSentToOrganizationName" class="control-label" meta:resourcekey="Lbl_Organization_Sent_To" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtSentToOrganizationName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Collected_By_Institution">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtCollectedByOrganizationName" class="control-label" meta:resourcekey="Lbl_Collected_By_Institution" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtCollectedByOrganizationName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Collected_By_Officer">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtCollectedByPersonName" class="control-label" meta:resourcekey="Lbl_Collected_By_Officer" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtCollectedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Destruction_Method">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtDestructionMethodTypeName" class="control-label" meta:resourcekey="Lbl_Destruction_Method" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtDestructionMethodTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Note">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="txtNote" class="control-label" meta:resourcekey="Lbl_Note" runat="server"></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtNote" runat="server" CssClass="form-control" MaxLength="500" Rows="5" TextMode="MultiLine"></asp:TextBox>
                </div>
            </div>
        </div>
        <script lang="javascript" type="text/javascript">
            function boxLocationChanged(obj) {

                __doPostBack(obj, 'BoxLocationChanged');
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
