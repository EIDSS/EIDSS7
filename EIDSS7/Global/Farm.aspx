<%@ Page Title="Farm" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Farm.aspx.vb" Inherits="EIDSS.Farm" %>

<%@ Register Src="~/Controls/SearchFarmUserControl.ascx" TagPrefix="eidss" TagName="SearchFarm" %>
<%@ Register Src="~/Controls/AddUpdateFarmUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateFarm" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPerson" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePerson" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div>
        <asp:UpdatePanel ID="upFarm" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h2><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Text") %></h2>
                    </div>
                    <div class="panel-body">
                        <eidss:SearchFarm ID="ucSearchFarm" runat="server" />
                        <eidss:AddUpdateFarm ID="ucAddUpdateFarm" runat="server" />
                        <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divSearchPersonModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchPersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchPersonModal')">&times;</button>
                <h4 id="hdgSearchPerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Search_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchPerson ID="ucSearchPerson" runat="server" RecordMode="Select" />
            </div>
        </div>
    </div>
    <div id="divAddUpdatePersonModal" class="modal container fade" tabindex="-1" role="dialog" aria-labelledby="divAddUpdatePersonModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAddUpdatePersonModal')">&times;</button>
                <h4 id="hdgAddUpdatePerson" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Add_Update_Person_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <asp:UpdatePanel ID="upAddUpdatePerson" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <eidss:AddUpdatePerson ID="ucAddUpdatePerson" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSuccessModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divSuccessModal">
        <asp:UpdatePanel ID="upSuccessModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 id="hdgSuccess" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_EIDSS_Success_Message_Text") %></h4>
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
                            <a href="../Dashboard.aspx" class="btn btn-default" runat="server" title="<%$ Resources: Labels, Lbl_Return_to_Dashboard_ToolTip %>"><%= GetGlobalResourceObject("Labels", "Lbl_Return_to_Dashboard_Text") %></a>
                            <asp:Button ID="btnReturnToFarmRecord" runat="server" Text="<%$ Resources: Buttons, Btn_Ok_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Ok_ToolTip %>" CssClass="btn btn-primary" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divWarningModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
        <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnWarningModalYes" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnWarningModalNo" EventName="Click" />
            </Triggers>
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
                                <asp:Button ID="btnWarningModalNo" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_No_Text %>" ToolTip="<%$ Resources: Buttons, Btn_No_ToolTip %>" CausesValidation="false" />
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
    <script type="text/javascript">
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(farmCallBackHandler);
            var farmSection = document.getElementById("EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm");
            if (farmSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));
            }
        });

        function farmCallBackHandler() {
            var farmSection = document.getElementById("EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm");
            if (farmSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));
            }

            var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");
            if (personSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
            }
        };

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

        function showVeterinaryDiseaseReportSubGrid(e, f) {
            var cl = e.target.className;
            if (cl == 'glyphicon glyphicon-plus-sign') {
                e.target.className = "glyphicon glyphicon-triangle-top";
                $('#' + f).show();
            }
            else {
                e.target.className = "glyphicon glyphicon-triangle-bottom";
                $('#' + f).hide();
            }
        };

        function showOutbreakCaseSubGrid(e, f) {
            var cl = e.target.className;
            if (cl == 'glyphicon glyphicon-plus-sign') {
                e.target.className = "glyphicon glyphicon-triangle-top";
                $('#' + f).show();
            }
            else {
                e.target.className = "glyphicon glyphicon-triangle-bottom";
                $('#' + f).hide();
            }
        };

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0) 
                showModal(modalID);
            else
                showModalOnModal(modalID);
        };

        function showModal(modalID) {
           // var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            $("body").addClass("modal-open");
           // bd.appendTo(document.body);
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');
        }

        function hideModal(modalID) {
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };

        function hideModalAndWarningModal(modalID) {
            hideModal(modalID);
            $('#divWarningModal').modal('hide');
        }

        function hideModalShowModal(hideDiv, showDiv) {
            $(hideDiv).modal('hide');
            $(showDiv).modal({ show: true });
        };

        function validateFarmType(sender, args) {
            var radioButtonList = document.getElementById(sender.controltovalidate);
            var radioButtons = radioButtonList.getElementsByTagName("input");
            var isValid = false;
            for (var i = 0; i < radioButtons.length; i++) {
                if (radioButtons[i].checked) {
                    isValid = true;
                    break;
                }
            }
            args.IsValid = isValid;
        };

        function showBaseReferenceEditorModal() {
            $('#divBaseReferenceEditorModal').modal({ show: true });
        };

        function hideBaseReferenceEditorModal() {
            $('#divBaseReferenceEditorModal').modal('hide');
        };
    </script>
</asp:Content>
