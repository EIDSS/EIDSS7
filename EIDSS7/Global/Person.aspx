<%@ Page Title="Person" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Person.aspx.vb" Inherits="EIDSS.Person" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPersonUserControl" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePersonUserControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upPerson" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnWarningModalYes" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><%= GetGlobalResourceObject("Labels", "Lbl_Person_Text") %></h2>
                </div>
                <div class="panel-body">
                    <eidss:SearchPersonUserControl ID="ucSearchPerson" runat="server" />
                    <eidss:AddUpdatePersonUserControl ID="ucAddUpdatePerson" runat="server" />
                    <asp:HiddenField ID="hdfPersonHumanMasterID" runat="server" />
                    <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                </div>
            </div>
            <div id="divSuccessModal" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Person_Text") %></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-ok-sign modal-icon"></span></div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p id="lblSuccessMessage" runat="server" meta:resourcekey="Lbl_Success"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnAddDiseaseReport" runat="server" meta:resourcekey="Btn_Add_Disease_Report" CssClass="btn btn-default" />
                            <a href="../Dashboard.aspx" class="btn btn-default" runat="server" title="<%$ Resources: Labels, Lbl_Return_to_Dashboard_ToolTip %>"><%= GetGlobalResourceObject("Labels", "Lbl_Return_to_Dashboard_Text") %></a>
                            <asp:Button ID="btnReturnToPersonRecord" runat="server" Text="<%$ Resources: Buttons, Btn_Ok_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Ok_ToolTip %>" CssClass="btn btn-primary" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="divWarningModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-warning">
                        <div class="panel-heading">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="warningHeading" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="warningSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="warningBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <div id="divWarningYesNoContainer" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <button id="btnWarningModalNo" type="button" class="btn btn-warning alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                            </div>
                            <div id="divWarningOKContainer" runat="server">
                                <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divErrorModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-danger">
                        <div class="panel-heading">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="hdgError" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="errorSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divErrorBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <button id="btnErrorModalOK" type="button" class="btn btn-danger alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                    var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");
                    if (personSection != undefined) {
                        initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
                    }
                });

                function callBackHandler() {
                    var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");
                    if (personSection != undefined) {
                        initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
                    }
                }

                function hideWarningModal() {
                    $('#divWarningModal').modal('hide');
                    $('body').removeClass('modal-open');
                    $('.modal-backdrop').remove();
                }

                function showDiseaseSubGrid(e, f) {
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom') {
                        e.target.className = "glyphicon glyphicon-triangle-top";
                        $('#' + f).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom";
                        $('#' + f).hide();
                    }
                }

                function showAge() {
                    var txtDateOfBirth = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtDateOfBirth");

                    if (txtDateOfBirth.value != '') {
                        var today = new Date();
                        var dob = txtDateOfBirth.value;
                        var BD = new Date(dob);

                        var dateDiff = Math.abs((today.getTime() - BD.getTime()) / (1000 * 3600 * 24));
                        dateDiff = Math.floor(dateDiff);

                        if (dateDiff <= 30)
                            document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042001';
                        else if (dateDiff > 30 && dateDiff < 365) {
                            document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042002';
                            dateDiff = Math.floor(dateDiff / 30);
                        }
                        else {
                            document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").value = '10042003';
                            dateDiff = Math.floor(dateDiff / 365);
                        }

                        document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").value = dateDiff;

                        document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").disabled = true;
                        document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").disabled = true;
                    }
                    else {
                        document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_txtReportedAge").disabled = false;
                        document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_ddlReportedAgeUOMID").disabled = false;
                    }
                }

                function showBaseReferenceEditorModal() {
                    $('#divBaseReferenceEditorModal').modal({ show: true, backdrop: 'static' });
                };

                function hideBaseReferenceEditorModal() {
                    $('#divBaseReferenceEditorModal').modal('hide');

                    $('body').removeClass('modal-open');
                    $('.modal-backdrop').remove();
                };
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
