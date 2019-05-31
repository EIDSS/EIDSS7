<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PersonRecordDeduplication.aspx.vb" Inherits="EIDSS.PersonRecordDeduplication" MasterPageFile="~/NormalView.Master" %>
<%@ Register Src="~/Controls/SearchPersonInformationUserControl.ascx" TagPrefix="eidss" TagName="SearchPersonInformationUserControl" %>

<asp:content id="Content2" contentplaceholderid="EIDSSBodyCPH" runat="server">
         <asp:UpdatePanel ID="upPerson" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnWarningModalYes" EventName="Click" />
<%--            <asp:AsyncPostBackTrigger ControlID="btnReturnToPersonRecord" EventName="Click" />--%>
        </Triggers>
        <ContentTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="Hdg_Person_Record_Deduplication"></h2>
                </div>
                <div class="panel-body">
                    <eidss:SearchPersonInformationUserControl ID="ucSearchPersonInformation" runat="server" />
                    <%--<asp:HiddenField ID="hdfPersonHumanMasterID" runat="server" />--%>
                    <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                    <asp:HiddenField ID="hdfCurrentTab" runat="server" Value="" />
                </div>
            </div>

            <div id="divDeduplicationDetails" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" id="myTab">
                            <li id="liPersonInfo"><a id="lnkInfo" href="#EIDSSBodyCPH_PersonInfo" data-toggle="tab" onclick="tabChanged(this, 'Info');">
                                <asp:Label ID="lblInfo" runat="server" meta:resourcekey="Lbl_Person_Information"/></a></li>
                            <li id="liPersonAddress"><a id="lnkAddress" href="#EIDSSBodyCPH_PersonAddress" data-toggle="tab" onclick="tabChanged(this, 'Address');">
                                <asp:Label ID="lblAddres" runat="server" meta:resourcekey="Lbl_Person_Current_Residence"/></a></li>
                            <li id="liPersonEmp"><a id="lnkEmp" href="#EIDSSBodyCPH_PersonEmp" data-toggle="tab" onclick="tabChanged(this, 'Emp');">
                                <asp:Label ID="lblEmp" runat="server" meta:resourcekey="Lbl_Employment_Information"/></a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div class="tab-pane" id="PersonInfo" runat="server">           
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="panel panel-primary">                       
                                            <div class="panel-heading">
                                                <asp:RadioButton ID="rdbSurvivor" runat="server" GroupName="RecordType" CssClass="radio-inline" meta:resourceKey="Lbl_Survivor" AutoPostBack="true" OnCheckedChanged="Record_CheckedChanged" />
                                                <asp:RadioButton ID="rdbSuperceded" runat="server"  GroupName="RecordType" CssClass="radio-inline" meta:resourceKey="Lbl_Superceded" AutoPostBack="true" OnCheckedChanged="Record_CheckedChanged"/>
                                            </div>
                                            <div class="panel-body duplication_checkbox">
                                                <asp:HiddenField ID="hdfPersonHumanMasterID" runat="server" />
                                                <asp:CheckBoxList ID="CheckBoxList1" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="panel">
                                            <div class="panel-heading">
                                                <asp:RadioButton ID="rdbSurvivor2" runat="server"  GroupName="RecordType2" CssClass="radio-inline" meta:resourceKey="Lbl_Survivor" AutoPostBack="true" OnCheckedChanged="Record2_CheckedChanged"/>
                                                <asp:RadioButton ID="rdbSuperceded2" runat="server" GroupName="RecordType2" CssClass="radio-inline" meta:resourceKey="Lbl_Superceded" AutoPostBack="true" OnCheckedChanged="Record2_CheckedChanged"/>
                                            </div>
                                            <div class="panel-body duplication_checkbox">
                                                <asp:HiddenField ID="hdfPersonHumanMasterID2" runat="server" />
                                                <asp:CheckBoxList ID="CheckBoxList2" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                            </div>
                                        </div>
                                    </div>
                                </div>                        
                            </div>
                            <div class="tab-pane" id="PersonAddress" runat="server">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="panel panel-primary">                       
                                            <div class="panel-body duplication_checkbox">
                                                <asp:CheckBoxList ID="CheckBoxList3" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxListAddress_SelectedIndexChanged" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="panel">
                                            <div class="panel-body duplication_checkbox">
                                                <asp:CheckBoxList ID="CheckBoxList4" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxListAddress_SelectedIndexChanged" />
                                                </div>
                                            </div>
                                        </div>
                                </div> 
                            </div>
                            <div class="tab-pane" id="PersonEmp" runat="server">
                                 <div class="row">
                                     <div class="col-md-6">
                                         <div class="panel panel-primary">                       
                                             <div class="panel-body duplication_checkbox">
                                                 <asp:CheckBoxList ID="CheckBoxList5" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxListEmp_SelectedIndexChanged" />
                                             </div>
                                         </div>
                                     </div>
                                     <div class="col-md-6">
                                         <div class="panel">
                                             <div class="panel-body duplication_checkbox">
                                                 <asp:CheckBoxList ID="CheckBoxList6" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxListEmp_SelectedIndexChanged" />
                                             </div>
                                         </div>
                                     </div>
                                 </div> 
                             </div>
                         </div>

                        <div class="modal-footer text-center">
                            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                            <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" UseSubmitBehavior="False" />
                            <asp:Button ID="btnMerge" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Merge_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Merge_ToolTip %>" CausesValidation="false" UseSubmitBehavior="False" />
                        </div>
                    </div>
                </div>
            </div>

            <div id="divSurvivorReview" runat="server" class="row embed-panel">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <asp:HiddenField ID="hdfPersonHumanMasterIDMain" runat="server" />
                                <%--<div class="panel">--%>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Person_Information"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList7" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                <%--</div>--%>
                                <%--<div class="panel">--%>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Person_Current_Residence"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList8" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                <%--</div>--%>
                                <%--<div class="panel">--%>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Employment_Information"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList9" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                <%--</div>--%>
                            <div class="modal-footer text-center">
                                <asp:Button ID="btnCancelSubmit" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" />
                            </div>
                        </div>
                </div>
            </div>

            <div id="divSuccessModal" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Person"></h4>
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
                            <%--<asp:Button ID="btnAddDiseaseReport" runat="server" meta:resourcekey="Btn_Add_Disease_Report" CssClass="btn btn-default" />--%>
                            <a href="../../../Dashboard.aspx" class="btn btn-default" runat="server" title="<%$ Resources: Labels, Lbl_Return_to_Dashboard_ToolTip %>"><%= GetGlobalResourceObject("Labels", "Lbl_Return_to_Dashboard_Text") %></a>
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
                function hideWarningModal() {
                    $('#divWarningModal').modal('hide');
                    $('body').removeClass('modal-open');
                    $('.modal-backdrop').remove();
                }

                function SetFocus(Id)
                {
                    document.getElementById(Id).focus();
                }

                function tabChanged(obj, tab) {
                    var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");
                    hdfCurrentTab.value = tab;

                    __doPostBack(obj.id, 'TabChanged');
                }

                function setActiveTabItem() {
                    var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");

                    switch (hdfCurrentTab.value) {
                        case 'Info':
                            document.getElementById('liPersonInfo').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_PersonInfo').setAttribute('class', 'tab-pane active');
                            break;
                        case 'Address':
                            document.getElementById('liPersonAddress').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_PersonAddress').setAttribute('class', 'tab-pane active');
                            break;
                        case 'Emp':
                            document.getElementById('liPersonEmp').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_PersonEmp').setAttribute('class', 'tab-pane active');
                            break;
                    }
                };
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:content>

 
<asp:Content ID="Content3" runat="server" contentplaceholderid="EIDSSHeadCPH">
</asp:Content>


 
