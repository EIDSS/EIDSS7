<%@ Page Language="vb" AutoEventWireup="false"  CodeBehind="VetinaryDiagnosticInvestigationMatrix.aspx.vb"    MasterPageFile="~/NormalView.Master" Inherits="EIDSS.VetinaryDiagnosticInvestigationMatrix"  %>

<%@ Register Src="~/Controls/DiseaseEditorUserControl.ascx" TagPrefix="uc1" TagName="DiseaseEditorUserControl" %>
<%@ Register Src="~/Controls/SpeciesReferenceEditorUserControl.ascx" TagPrefix="uc1" TagName="SpeciesReferenceEditorUserControl" %>
<%@ Register Src="~/Controls/BaseReferenceUserControl.ascx" TagPrefix="uc1" TagName="BaseReferenceUserControl" %>




<asp:Content ID="Content3" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
<link href="<%=ResolveUrl("~/Includes/DataTables/select.bootstrap.css")%>" rel="stylesheet"  />
<link href="<%=ResolveUrl("~/Includes/DataTables/rowReorder.bootstrap.css")%>"  rel="stylesheet" />
<link href="<%=ResolveUrl("~/Includes/CSS/bootstrap-multiselect.css")%>"  rel="stylesheet" type="text/css" />
<link href="<%=ResolveUrl("~/Includes/CSS/jquery.gorilla-dropdown.min.css")%>"  rel="stylesheet" type="text/css" />
        <style>
        .ddlist{
            max-height:300px;
            overflow-y:scroll;
        }
        select {
            font-family: "Courier New", Courier, monospace;
        }

        .form-controlMatrixGrid {
            display: block;
            width: 80px;
            height: 55px;
            padding: 5px 5px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2>
                <asp:Label ID="Label4" runat="server" Text="Matrix Version" ></asp:Label></h2>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-3">
                    <asp:Label ID="Label1" runat="server" CssClass="form-control" Text="Version Name" ></asp:Label>
                    <br />
                    <asp:TextBox ID="VersionNameTxt" CssClass="form-control" ClientIDMode="Static" runat="server"> </asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="Label2" runat="server" CssClass="form-control"  Text="Activation Date"> </asp:Label>
                    <br />
                    <eidss:CalendarInput ID="ActivationDate" ContainerCssClass="input-group datepicker" CssClass="form-control" ClientIDMode="Static" runat="server" ></eidss:CalendarInput>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="Label3" runat="server" CssClass="form-control" Text="Select Verions" ></asp:Label>
                    <br />
                    <div id="VersionDDContainer">

                    </div>
                  <%--  <select id="VersionDropDown" class="form-control">
                        <option ></option>

                    </select>--%>
                </div>
            </div>
            <div class="row">
            </div>
            <br />
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-2"></div>
                <div class="col-md-2"></div>
                <div class="col-md-2">
                    <input type="button" id="ActivateVersionBtn" value="Activate Matrix Version" class="btn btn-primary" onclick="ActivateVersion();"  />
                </div>
                <div class="col-md-2">

                    <input type="button" class="btn btn-primary" value="New Matrix Version" onclick="SaveVersionConfirmation();" />
                </div>
                <div class="col-md-2">
                    <input type="button" id="DeleteVersionBtn" value="Delete Matrix Version" class="btn btn-primary" onclick="DisplayDeleteModal();" />

                </div>

            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading ">

            <h2>
                <asp:Label ID="Label5" runat="server" Text="Vet Diagnostic Investigation Matrix"></asp:Label></h2>


        </div>
        <div class="panel-body">
            <div id="btndiv" class="btndiv"></div>
            <asp:Table ID="HumanAggregateCaseTable" ClientIDMode="Static" runat="server" CssClass="table dataTable" >
                <asp:TableHeaderRow TableSection="TableHeader" VerticalAlign="Top" >
                    <asp:TableHeaderCell Width="10%" >Order</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >Investigation Type</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >Species</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >Diagnosis</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >OIE Code</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >inv</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >sp</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >diag</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="10%" >mtx</asp:TableHeaderCell>
                </asp:TableHeaderRow>

            </asp:Table>
        </div>
        <div class="panel-footer">
         <%--   <input type="button" class="btn btn-sm btn-default" value="Up" onclick="Decrease();" />
            <input type="button" class="btn btn-sm btn-default" value="Down" onclick="Increment();" />--%>
            <input id="addRow" type="button" class="btn btn-sm btn-default" value="Add" />
            <input type="button" id="DeleteMatrixRecordBtn" class="btn btn-sm btn-default" disabled="disabled" value="Delete Matrix Record" onclick="DeleteMatrixConfirmation();" />
            <input type="button" class="btn btn-sm btn-default" onclick="SaveMatrix()" value="Save" />
            <input type="button" class="btn btn-sm btn-default" value="Ok" />
            <input type="button" class="btn btn-sm btn-default" onclick="Cancel()" value="Cancel" />
        </div>
    </div>
    <!-- Messages -->
    <asp:HiddenField ID="hiddenSelectedVersion" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hiddenMessage" ClientIDMode="Static" runat="server" Value="Are you sure you want to cancel?" />
    <asp:HiddenField ID="DuplicateMessage" ClientIDMode="Static" runat="server" Value="Current record of Human Aggregate Case Matrix is not unique. Please change or delete it. Do you want to correct the value?" />
    <asp:HiddenField ID="VersionMessage" ClientIDMode="Static" runat="server" Value="The field “Version Name” is mandatory. You must enter data in this field before saving the form." />
    <asp:HiddenField ID="SaveConfirmationMessage" ClientIDMode="Static" runat="server" Value="Do you want to save changes?" />
    <asp:HiddenField ID="SuccessSaveMessage" ClientIDMode="Static" runat="server" Value="The record is saved successfully." />
    <asp:HiddenField ID="EmptyMessage" ClientIDMode="Static" runat="server" Value="Empty matrix can't be activated." />
    <asp:HiddenField ID="DeleteConfirmationMessage" ClientIDMode="Static" runat="server" Value="Are you sure you want to delete this record?" />
    <asp:HiddenField ID="RecordDeletedSuccessfullMessage" ClientIDMode="Static" runat="server" Value="Record Deleted Successfully." />
    <asp:HiddenField ID="hiddenBaseRoute" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="SaveMatrixMessageConfirmationMessage" ClientIDMode="Static" runat="server" Value="Do you want to save changes?" />
    <asp:HiddenField ID="ConfirmationModalHeader" ClientIDMode="Static" runat="server" Value="Confirmation" />
    <asp:HiddenField ID="InactiveMatrixMessage" ClientIDMode="Static" runat="server" Value="You can have only one inactive matrix. Please activate currently inactive matrix before creating a new one." />
    







    <div id="DiseasePanelModal" class="modal fade">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <uc1:DiseaseEditorUserControl runat="server" ID="DiseaseEditorUserControl"  />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>


     <div id="BaseReferencePanelModal" class="modal fade">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                          <uc1:BaseReferenceUserControl runat="server" id="BaseReferenceUserControl" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    
    <!-- Modal -->
    <div id="DeleteVersionModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="deleteVersionConfirmation"></h4>
                </div>
                <div class="modal-body">
                    <p id="deleteVersionModalText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="DeleteVersion();">Yes</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>
      <div id="DeleteMatrixRecordModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="deleteMatrixRecordConfirmation"></h4>
                </div>
                <div class="modal-body">
                    <p id="deleteMatrixRecordModalText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="DeleteMatrixRecord();">Yes</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div id="MatrixModal" class="modal fade">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <p id="matrixModelText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <div id="GeneralMessageModal" class="modal fade">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <p id="generalMessageModalText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                </div>
            </div>

        </div>
    </div>

    <div id="ConfirmationModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Modal Header</h4>
                </div>
                <div class="modal-body">
                    <p id="confirmationModalText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="DeleteVersion();">Yes</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>

    <div id="SaveVersionConfirmationModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="confirmationHeader"></h4>
                </div>
                <div class="modal-body">
                    <p id="saveVersionConfirmationText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="SaveVersion();">Yes</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>

    <div id="SaveMatrixConfirmationModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="matrixConfirmationHeader"></h4>
                </div>
                <div class="modal-body">
                    <p id="saveMatrixConfirmationText"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="SaveConfirmation();">Yes</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>
    
    <div id="SpeciesPanelModal" class="modal fade">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <uc1:SpeciesReferenceEditorUserControl runat="server" ID="SpeciesReferenceEditorUserControl1"  />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        /*Table Functions*/
        var baseRoute = $("#hiddenBaseRoute").val();
        /* ********************************************************************************
         * OBJECTS
         * ********************************************************************************/
        var controlId;//Selected DropDown Id in Table
        var isClicked = false
        var dupicateresults = []; // Stores Duplicates returned from duplicate check
        var Duplicates = [] //validates;
        var table;
        //Object saved to DB For Matrix
        var MatrixObjectList = [];
        var NewMatrixItem = {
            idfAggrDiagnosticActionMTX: '',
            idfVersion: '',
            idfsDiagnosis: '',
            idfsSpeciesType: '',
            idfsDiagnosticAction:'',
            intNumRow: ''
            
        }
        //Object saved to DB for Versioning
        var VersionHeader = {
         
            idfVersion: "",
            idfsMatrixType: 0,
            datStartDate: "",
            MatrixName: "",
            blnIsActive: false,
            blnIsDefault: false
        }
        var SavedMatrix = {
            matrix: []
        }
        var diseaseData;
        var speciesData;
        var humanDiseaseData;
        var deserializedHumanDiseaseObj;
        var diseaseForGridDropDown;
        var speciesForGridDropDown;
        var investigationDataForGridDropDown;
        var investigationData;
        var TableData = [];
        var item = [];
  

        var newRowId = 0;
        var versionId;
        var selectedRow; //For Deletion etc...
        var matrixVersion; //stores matrixVersionInformation
        /* ********************************************************************************
        * EVENTS
        * ********************************************************************************/
        /*Page Load Events*/
        //Make Calls to Service via PageMethods on Page Load
        $(document).ready(function () {
            PageMethods.GetInvestigationTypes(InvestigationTypes);
            PageMethods.GetVetDiagnosisList(LoadedDiseases);
            PageMethods.GetSpeciesList(LoadedSpecies);
            PageMethods.GetMatrixVersions(GetMatrixVersions);
            GetMatrixByVersion(00000000);
            CurrentDate();
            $("#ActivateVersionBtn").prop('disabled', true);
            $("#DeleteVersionBtn").prop('disabled', true);
            //Method Called when the table is paged
            $('#HumanAggregateCaseTable').on('page.dt', function () {
                //Do Something Here
            });

        });
        function CurrentDate() {
             $("#ActivationDate").val(moment().format('MM/DD/YYYY'));
        }
        //Callback to set object with matrix data.
        function LoadedDiseases(data) {
            diseaseData = data;
            diseaseForGridDropDown = JSON.parse(diseaseData);
        }
        function LoadedSpecies(data) {
            speciesData = data;
            speciesForGridDropDown = JSON.parse(speciesData);
        }
        function InvestigationTypes(data) {
            investigationData = data;
            investigationDataForGridDropDown = JSON.parse(investigationData);
        }

        /*Version Methods */
        $("#VersionNameTxt").keyup(function () {
            $("#hiddenSelectedVersion").val("");
            var enteredVersion = $("#VersionNameTxt").val();
            var selectedVersion = $("#VersionDropDown").gorillaDropdown("selected");
            var versionName = selectedVersion.text;
            if (enteredVersion == versionName ) {
                $("#VersionNameTxt").val(enteredVersion + " Copy");
            }
                
        });

    
        function SaveVersionConfirmation() {
            $("#confirmationHeader").html($("#ConfirmationModalHeader").val());
            $("#saveVersionConfirmationText").html($("#SaveConfirmationMessage").val());
            $("#SaveVersionConfirmationModal").modal('show');
        }
        //Saves The MatrixVersion to db
        function SaveVersion() {
            var selectedVersion = $("#VersionDropDown").gorillaDropdown("selected");
            VersionHeader = new Object();
            if (CheckForInactiveVersions()) {
                var versionName;
                if ($("#VersionNameTxt").val() != "" & selectedVersion.index == 0) {
                    versionName = $("#VersionNameTxt").val();
                }
                else if (selectedVersion.index != 0) {
                    var ddVersionName = selectedVersion.text;
                    if (ddVersionName == $("#VersionNameTxt").val()) {
                        versionName = $("#VersionNameTxt").val() + " Copy";
                    }
                    else {
                        versionName = $("#VersionNameTxt").val();
                    }

                }
                else {
                    $("#generalMessageModalText").html($("#VersionMessage").val());
                    $("#GeneralMessageModal").modal();
                    return false;
                }
                
                VersionHeader.blnIsActive = false;
                VersionHeader.blnIsDefault = false;
                VersionHeader.MatrixName = versionName;

                PageMethods.SaveVersion(VersionHeader, onSaveVersionSuccess, onSaveVersionFailed);
            }
        }


        function onActivateVersionSuccess(data) {

            var Results = data;
            $("#hiddenSelectedVersion").val(Results.idfVersion);
            $("#ActivationDate").val(moment(Results.datStartDate).format('MM/DD/YYYY'));
            $("#VersionNameTxt").val(Results.MatrixName);
            $("#generalMessageModalText").html($("#SuccessSaveMessage").val());
            $("#ActivateVersionBtn").prop('disabled', true);
            $("#DeleteVersionBtn").prop('disabled', true);
            $("#hiddenSelectedVersion").val(Results.idfVersion);
            PageMethods.GetMatrixVersions(GetMatrixVersions);
            $("#GeneralMessageModal").modal();
        }



        function onSaveVersionSuccess(data) {

            var Results = data;
          
                $("#hiddenSelectedVersion").val(Results.idfVersion);
                if (Results.datStartDate != undefined && Results.datStartDate != "" && Results.datStartDate != null) {
                    $("#ActivationDate").val(moment(Results.datStartDate).format('MM/DD/YYYY'));
                }
                $("#VersionNameTxt").val(Results.MatrixName);
                PageMethods.GetVetDiagnosisList(LoadedDiseases);
                PageMethods.GetMatrixVersions(GetMatrixVersions);
                $("#generalMessageModalText").html($("#SuccessSaveMessage").val());
                $("#GeneralMessageModal").modal();
            
        }
        function onSaveVersionFailed(err) {
            alert(Json.stringify(err));
        }

        //Activates a Version
        function ActivateVersion() {
            if (MatrixObjectList.length > 0) {
                var selected = $("#VersionDropDown").gorillaDropdown("selected");
                if (selected.index != 0) {

                    var versionName = selected.text;
                    VersionHeader.matrixName = versionName;
                    VersionHeader.idfVersion = selected.value
                    VersionHeader.blnIsActive = true;
                    VersionHeader.datStartDate = $("#ActivationDate").val();
                    PageMethods.SaveVersion(VersionHeader, onActivateVersionSuccess, onSaveVersionFailed);
                    MatrixObjectList = [];
                }
                else {
                    $("#generalMessageModalText").html($("#EmptyMessage").val());
                    $("#GeneralMessageModal").modal('show');
                }
            }
            else {
                $("#generalMessageModalText").html($("#EmptyMessage").val());
                $("#GeneralMessageModal").modal('show');
            }
        }

        //deletes a version
        function DisplayDeleteModal() {
            $("#deleteVersionConfirmationHeader").html($("#ConfirmationModalHeader").val());
            $("#deleteVersionModalText").html($("#DeleteConfirmationMessage").val());
            $("#DeleteVersionModal").modal();
        }
        function DeleteVersion() {
            var endpoint = baseRoute + '/api/Configuration/DeleteHumanCaseMatrixVersion?idfVersion=' + versionId;
            // console.log(baseRoute);
            $.ajax({
                url: endpoint,
                type: 'Delete',
                headers: {

                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Credentials': true,
                },
                dataType: 'json',
                success: function (data) {
                    var res = JSON.stringify(data);
                    if (res.search("SUCCESS") > -1) {
                        $("#generalMessageModalText").html($("#RecordDeletedSuccessfullMessage").val());
                        $("#GeneralMessageModal").modal();
                        $("#VersionDropDown").children('option:not(:first)').remove();
                        ClearSelections();
                        GetMatrixByVersion(00000000);
                        PageMethods.GetMatrixVersions(GetMatrixVersions);
                    }
                },
                error: function (request, error) {
                    alert("Request: " + JSON.stringify(request));
                }
            });
        }

        //Get Matrix Version Value when dropdown changes and load new matrix in grid
        $(document).on('change', '#VersionDropDown', function () {
            if ($("#VersionDropDown")[0].selectedIndex != 0) {
                var item = $(this);
                newRowId = 0;
                MatrixObjectList = [];
                GetMatrixByVersion(item.val());
                var versionIndex = $("#VersionDropDown")[0].selectedIndex;
                if (matrixVersion[versionIndex - 1].datStartDate != undefined & matrixVersion[versionIndex - 1].datStartDate != "" & matrixVersion[versionIndex - 1].datStartDate != null) {
                    $("#ActivationDate").val(moment(matrixVersion[versionIndex - 1].datStartDate).format('MM/DD/YYYY'));
                    $("#ActivateVersionBtn").prop('disabled', true);
                    $("#DeleteVersionBtn").prop('disabled', true);
                    $("#DeleteMatrixRecordBtn").prop('disabled', true);
                    
                }
                else {
                    CurrentDate();
                    $("#ActivateVersionBtn").prop('disabled', false);
                    $("#DeleteVersionBtn").prop('disabled', false);
                }
                
                $("#VersionNameTxt").val(item.find("option:selected").text());
                versionId = item.val();
            }
            else {
                CurrentDate();
                $("#VersionNameTxt").val("");
                GetMatrixByVersion(00000000);
            }
            $("#DeleteMatrixRecordBtn").prop('disabled', true);
        });

        //Callback to get Matrix Version and load into dropDownList
           function GetVersionValue() {
           var selected = $("#VersionDropDown").gorillaDropdown("selected");
            //alert(JSON.stringify(selected));
            var selectedIndex = selected.index;
            var selectedValue = selected.value;
             if (selectedIndex != 0) {
               
                newRowId = 0;
                MatrixObjectList = [];
                GetMatrixByVersion(selectedValue);
                 var versionIndex = selectedIndex;
                 if (matrixVersion[versionIndex - 1].datStartDate != undefined & matrixVersion[versionIndex - 1].datStartDate != "" & matrixVersion[versionIndex - 1].datStartDate != null) {
                     $("#ActivationDate").val(moment(matrixVersion[versionIndex - 1].datStartDate).format('MM/DD/YYYY'));
                     $("#ActivateVersionBtn").prop('disabled', true);
                     $("#DeleteVersionBtn").prop('disabled', true);
                     $("#DeleteMatrixRecordBtn").prop('disabled', true);
                 }
                else {
                    CurrentDate();
                    $("#ActivateVersionBtn").prop('disabled', false);
                    $("#DeleteVersionBtn").prop('disabled', false);
                }
                $("#VersionNameTxt").val(selected.text);
                versionId = selected.value
            }
            else {
                CurrentDate();
                $("#VersionNameTxt").val("");
                GetMatrixByVersion(00000000);
            }
            $("#DeleteMatrixRecordBtn").prop('disabled', true);
        }
        $(document).on('change', '#VersionDropDown', function () {
            if ($("#VersionDropDown")[0].selectedIndex != 0) {
                var item = $(this);
                newRowId = 0;
                MatrixObjectList = [];
                GetMatrixByVersion(item.val());
                var versionIndex = $("#VersionDropDown")[0].selectedIndex;
                if (matrixVersion[versionIndex - 1].datStartDate != undefined & matrixVersion[versionIndex - 1].datStartDate != "" & matrixVersion[versionIndex - 1].datStartDate != null) {
                    $("#ActivationDate").val(moment(matrixVersion[versionIndex - 1].datStartDate).format('MM/DD/YYYY'));
                    $("#ActivateVersionBtn").prop('disabled', true);
                    $("#DeleteVersionBtn").prop('disabled', true);
                    $("#DeleteMatrixRecordBtn").prop('disabled', true);
                    
                }
                else {
                    CurrentDate();
                    $("#ActivateVersionBtn").prop('disabled', false);
                    $("#DeleteVersionBtn").prop('disabled', false);
                }
                
                $("#VersionNameTxt").val(item.find("option:selected").text());
                versionId = item.val();
            }
            else {
                CurrentDate();
                $("#VersionNameTxt").val("");
                GetMatrixByVersion(00000000);
            }
            $("#DeleteMatrixRecordBtn").prop('disabled', true);
        });

        //Callback to get Matrix Version and load into dropDownList
        function GetMatrixVersions(data) {
            matrixVersion = JSON.parse(data);
            var items = $("#VersionDropDown option").length;
            try {
                if (items == 0) {
                    jQuery('#VersionDDContainer').empty();
                    jQuery('#VersionDDContainer').append('<select id="VersionDropDown"></select>');
                }

                $version = $("select[id='VersionDropDown']");
                //alert($version);
                $("<option value='00000000' data-description='SELECT MATRIX VERSION' Selected>SELECT</option>").appendTo($version);
                for (var i = 0; i < matrixVersion.length; i++) {
                   if ($("#hiddenSelectedVersion").val() == matrixVersion[i].idfVersion) {
                        if (matrixVersion[i].blnIsActive & matrixVersion[i].datStartDate != undefined & matrixVersion[i].datStartDate != null) {
                            $("<option value='" + matrixVersion[i].idfVersion + "' data-description='Activation Date: " + moment(matrixVersion[i].datStartDate).format('MM/DD/YYYY') + "' data-imgsrc='<%=ResolveUrl("~/includes/images/glyphicons-ok-neverActivated.png")%>' > " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                        else if (matrixVersion[i].blnIsActive == false & matrixVersion[i].datStartDate != undefined & matrixVersion[i].datStartDate != null) {

                            $("<option value='" + matrixVersion[i].idfVersion + "' data-description='Activation Date: " + moment(matrixVersion[i].datStartDate).format('MM/DD/YYYY') +  "' data-imgsrc='<%=ResolveUrl("~/includes/images/glyphicons-ok-activated.png")%>'> " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                        else {
                            $("<option value='" + matrixVersion[i].idfVersion + "'> " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                    }
                    else {
                        if (matrixVersion[i].blnIsActive & matrixVersion[i].datStartDate != undefined & matrixVersion[i].datStartDate != null) {
                            $("<option value='" + matrixVersion[i].idfVersion + "' data-description='Activation Date: " + moment(matrixVersion[i].datStartDate).format('MM/DD/YYYY') + "'  data-imgsrc='<%=ResolveUrl("~/includes/images/glyphicons-ok-neverActivated.png")%>' > " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                        else if (matrixVersion[i].blnIsActive == false & matrixVersion[i].datStartDate != undefined & matrixVersion[i].datStartDate != null) {

                            $("<option value='" + matrixVersion[i].idfVersion + "' data-description='Activation Date: " + moment(matrixVersion[i].datStartDate).format('MM/DD/YYYY') + "' data-imgsrc='<%=ResolveUrl("~/includes/images/glyphicons-ok-activated.png")%>'> " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                        else {
                            $("<option value='" + matrixVersion[i].idfVersion + "'> " + matrixVersion[i].MatrixName + "</option>").appendTo($version);
                        }
                    }


                }
             
                LoadGorillaDropDown();
               
            } catch (e) {
                alert(e);
            }

        }

        function LoadGorillaDropDown() {

            $("#VersionDropDown").gorillaDropdown({
                arrowColor: "#808080",
                arrowDown: "&#x25bc;",
                arrowSize: "14px",
                arrowUp: "&#x25b2;",
                backgroundColor: "#ffffff",
                borderColor: "#c0c0c0",
                borderWidth: 1,
                descriptionFontColor: "#000000",
                descriptionFontFamily: "Verdana",
                descriptionFontSize: "12px",
                descriptionFontStyle: "normal",
                descriptionFontVariant: "small-caps",
                descriptionFontWeight: "normal",
                displayArrow: "inline",
                dropdownHeight: "auto",
                hoverColor: "#f0f8ff",
                imageLocation: "left",
                onSelect: function () { GetVersionValue() },
                padding: 10,
                placeholder: "Select",
                placeholderFontColor: "#808080",
                placeholderFontFamily: "Verdana",
                placeholderFontSize: "14px",
                placeholderFontStyle: "italic",
                placeholderFontVariant: "normal",
                placeholderFontWeight: "bold",
                select: 0,
                textFontColor: "#000000",
                textFontFamily: "Verdana",
                textFontSize: "14px",
                textFontStyle: "normal",
                textFontVariant: "normal",
                textFontWeight: "bold",
                width: 500
            });
            if ($("#VersionNameTxt").val() != "") {
                $("#VersionDropDown").gorillaDropdown("select", { "value": $("#VersionNameTxt").val() });
            }
        }
          
        function CheckForInactiveVersions() {
            $("#ActivateVersionBtn").prop('disabled', false);
            $("#DeleteVersionBtn").prop('disabled', false);
            for (var i = 0; i < matrixVersion.length; i++) {
                if (matrixVersion[i].datStartDate == undefined | matrixVersion[i].datStartDate == null | matrixVersion[i].datStartDate == "" ) {
                    $("#generalMessageModalText").html($("#InactiveMatrixMessage").val());
                    $("#GeneralMessageModal").modal('show');
                    return false;
                }
            }
            return true;
        }
        ///* Matrix */
        ///*Table Methods */
     
        //Validation Looking for duplicates in the table
        function validateMatrixTable() {
            BuildArray();
        }

        /*Saves Matrix to Objects*/
        /*Saves  Matrix Records, Makes call to PageMethod that then calls the API? */
        function SaveMatrix() {
            MatrixObjectList = [];
            var RowColumn;
            var RowNumber;
            var table = $('#HumanAggregateCaseTable').DataTable();
            var tableData = table.data();
            table.rows().eq(0).each(function (index) {
                NewMatrixItem = new Object();
                var row = table.row(index);
                var data = row.data()[5];// ... do something with data(), or row.node(), etc
                var selectedVersion = $("#VersionDropDown").gorillaDropdown("selected");
                if (row.data()[5] != undefined & row.data()[5] != ""  & row.data()[6] != undefined & row.data()[6] != "" & row.data()[7] != undefined & row.data()[7] != "") {
                    NewMatrixItem.intNumRow = row.data()[0];
                    NewMatrixItem.idfVersion = selectedVersion.value;
                    NewMatrixItem.idfsDiagnosis = row.data()[7];
                    NewMatrixItem.idfAggrDiagnosticActionMTX = row.data()[5];
                    NewMatrixItem.idfsDiagnosticAction = row.data()[5];
                    NewMatrixItem.idfsSpeciesType = row.data()[6];
                    MatrixObjectList.push(NewMatrixItem);

                    Duplicates.push(row.data()[5].toString() +  row.data()[6].toString() + row.data()[7].toString());
                }
            });

            //Find Dupplicates
            var _duplicates = find_duplicate_in_array(Duplicates);
            if (_duplicates == true) {
                //We have Duplicates
                $("#generalMessageModalText").html($("#DuplicateMessage").val());
                $("#GeneralMessageModal").modal('show');
                _duplicates = [];
                Duplicates = [];
                return false;
        
            }
            else {
                 $("#saveMatrixConfirmationText").html($("#SaveConfirmationMessage").val());
                $("#matrixConfirmationHeader").html($("#ConfirmationModalHeader").val());
                $("#SaveMatrixConfirmationModal").modal('show');
            
            }
        }
        function SaveConfirmation() {
            if (MatrixObjectList.length > 0) {

                res = PageMethods.SaveMatrix(JSON.stringify(MatrixObjectList), onSaveMatrixSucess, onSaveMatrixError);
                _duplicates = [];
                Duplicates = [];
            }
            else {
                $("#generalMessageModalText").html($("#EmptyMessage").val());
                $("#GeneralMessageModal").modal('show');
            }
        }
        function onSaveMatrixSucess(data) {
            $("#generalMessageModalText").html($("#SuccessSaveMessage").val());
            $("#GeneralMessageModal").modal('show');
            GetMatrixByVersion(versionId);
        }
        function onSaveMatrixError(err) {
            alert(error);
        }

        //Load A New Matrix By it's Version ID
        function GetMatrixByVersion(versionId) {
            //alert(versionId);
            var endpoint = baseRoute + '/api/Configuration/ConfAdminVetDiagnosisInvesitgationMatrixReportGet?Version';
            // console.log(baseRoute);
            $.ajax({
                url: endpoint,
                type: 'GET',
                data: {
                    'idfVersion': versionId
                },
                dataType: 'json',
                success: function (data) {
                    var newMatrixData = JSON.parse(data.Results);
                    BuildTableWithData(JSON.stringify(newMatrixData));
                    table = $('#HumanAggregateCaseTable').DataTable();
                    //Get the last row id for incrementing the rowid when adding a new row
                    table.rows().eq(0).each(function (index) {
                        var row = table.row(index);
                        if (row.data()[0] != undefined & row.data()[0] != "") {
                            newRowId = row.data()[0];
                        }
                    });
                },
                error: function (request, error) {
                    alert("Request: " + JSON.stringify(request));
                }
            });
        }


        //Find Duplicates
        function find_duplicate_in_array(a) {
            var counts = [];
            for (var i = 0; i <= a.length; i++) {
                if (counts[a[i]] === undefined) {
                    counts[a[i]] = 1;
                } else {
                    return true;
                }
            }
            return false;
        }



        //Clears and resets values
        function ClearSelections() {
            Duplicates = [];
            controlId = null;
            isClicked = false;
            dupicateresults = [];
            newRowId = 0;
            $("#ActivateVersionBtn").prop('disabled', true);
            $("#DeleteVersionBtn").prop('disabled', true);
            $("#ActivationDate").val("");
            $("#VersionNameTxt").val("");
        }

        //Build Table Here
        //Callback to Load All Human Disease Data into Javascript Objects
        function BuildTableWithData(data) {
            humanDiseaseData = data;
            deserializedHumanDiseaseObj = JSON.parse(humanDiseaseData);
            TableData = [];
            newRowId = deserializedHumanDiseaseObj.length;
            for (var i = 0; i < deserializedHumanDiseaseObj.length; i++) {
                item = [];
                item.push(deserializedHumanDiseaseObj[i].intNumRow.toString());
                item.push(deserializedHumanDiseaseObj[i].idfsDiagnosticAction.toString());
                item.push(deserializedHumanDiseaseObj[i].idfsSpeciesType.toString());
                item.push(deserializedHumanDiseaseObj[i].idfsDiagnosis);
                item.push(deserializedHumanDiseaseObj[i].strOIECode);
                item.push(deserializedHumanDiseaseObj[i].idfsDiagnosticAction.toString());
                item.push(deserializedHumanDiseaseObj[i].idfsSpeciesType.toString());
                item.push(deserializedHumanDiseaseObj[i].idfsDiagnosis);
                item.push(deserializedHumanDiseaseObj[i].idfAggrDiagnosticActionMTX);
                
               
                item.push(deserializedHumanDiseaseObj[i].idfAggrDiagnosticActionMTX.toString());

                var diagnosis;
                if (deserializedHumanDiseaseObj[i].idfsBaseReference != undefined) {
                    diagnosis = deserializedHumanDiseaseObj[i].idfsBaseReference
                }
                if (deserializedHumanDiseaseObj[i].idfsDiagnosis != undefined) {
                    diagnosis = deserializedHumanDiseaseObj[i].idfsDiagnosis
                }
                MatrixObjectList.push(item);
                TableData.push(item);
            }

            if ($.fn.dataTable.isDataTable('#HumanAggregateCaseTable')) {
                table = $('#HumanAggregateCaseTable').DataTable();
                table.destroy();
            }

            table = $('#HumanAggregateCaseTable').DataTable({
                processing: true, 
                data: TableData,
                columns: [
                    { title: "Order" },
                    { title: "Investigation Type" },
                    { title: "Species" },
                    { title: "DiagNosis" },
                    { title: "OIE Code" },
                    { title: "inv" },
                    { title: "sp" },
                    { title: "diag" },
                    { title: "mtx" }
                ],
                columnDefs: [
                    {
                        //ICD10
                        targets: [0], type: "dom-text", render: function (data, type, row, meta) {
                            return data;
                        }
                    },
                    {

                        //Creates DropDown In Grid
                        targets: [1], render:
                            function (data, type, row, meta) { return createInvestigationDataSelect(data, type, row, meta); }
                    },
                    {

                        //Creates DropDown In Grid
                        targets: [2], render:
                            function (data, type, row, meta) { return createSpeciesDataSelect(data, type, row, meta); }
                    },
                    {

                        //Creates DropDown In Grid
                        targets: [3], render:
                            function (data, type, row, meta) { return createDiagnosisSelect(data, type, row, meta); }
                    },
                    {
                        //Id of Disease Selected
                        targets: [4], visible: true, type: "dom-text", render: function (data, type, row, meta) {
                            return data;
                        }
                    },
                    {
                        //INV ID
                        targets: [5],visible:false
                    }
                ,
                    {
                        //SPECIES ID
                        targets: [6],visible:false

                    }
                    ,
                    {
                        //DIAGNOSIS ID
                        targets: [7],visible:false

                    }
                ,
                    {
                        //Matrix ID
                        targets: [8],visible:false

                    }
                ]
                ,
                deferRender: true,
                order: [],
               // ordering: true,
                searching: false,
                bLengthChange: true,
                select: true,
                rowReorder: true
            });
        }

        //RowSelection, When a row is selected , store the Index
        var tableSel = $('#HumanAggregateCaseTable').DataTable();
        var selectedRowIndex;
        tableSel.on('select', function (e, dt, type, indexes) {
            selectedRowIndex = indexes;
            $("#DeleteMatrixRecordBtn").prop('disabled', false);
        });
        tableSel.on('deselect', function (e, dt, type, indexes) {
            if (type === 'row') {
                $("#DeleteMatrixRecordBtn").prop('disabled', true);
            }
        });

        //RowDeletion Get the index of the row, remove from the table, then resave the table on confirmation
        function DeleteMatrixConfirmation() {
            $("#deleteMatrixRecordModalText").html($("#DeleteConfirmationMessage").val());
            $("#DeleteMatrixRecordModal").modal('show');

        }

        function DeleteMatrixRecord() {
            NewMatrixItem = new Object();
            MatrixObjectList = [];
            var data = selectedRow;// ... do something with data(), or row.node(), etc
            var selectedVersion = $("#VersionDropDown").val();
            var table = $('#HumanAggregateCaseTable').DataTable();
            var row = table.row(selectedRowIndex);
            var data = row.data()[4];// ... do something with data(), or row.node(), etc
            var selectedVersion = $("#VersionDropDown").val();
            if (row.data()[8] != undefined & row.data()[8] != "") {
                NewMatrixItem.intNumRow = row.data()[0];
                NewMatrixItem.idfVersion = selectedVersion.value;
                NewMatrixItem.idfsDiagnosis = row.data()[4];
                NewMatrixItem.idfAggrDiagnosticActionMTX = row.data()[8];
            }
            PageMethods.DeleteMatrixRecord(NewMatrixItem.idfAggrDiagnosticActionMTX, onDeleteMatrixSucess, onDeleteMatrixError);
           
        }
      
        function onDeleteMatrixSucess(data) {
            $("#generalMessageModalText").html($("#RecordDeletedSuccessfullMessage").val());
            $("#GeneralMessageModal").modal('show');
            ClearSelections();
            GetMatrixByVersion(versionId);
        }
        function onDeleteMatrixError(err) {
            alert(err);
        }

     

        //Add new Row to table
        $('#addRow').on('click', function () {
            newRowId++;
            table.row.add([
                newRowId,
                '',
                '',
                '',
                '',
                '',
                '',
                '',
                ''
            ]).draw(false);
        });

        // the function creates a select drop down in table
        function createDiagnosisSelect(data, type, row, meta) {
            var rowId = meta.row;
            //console.log(meta);
            var sel = "<select class='tableDropDowndisease form-control' title='" + rowId + "'><option> </option>";
            for (var i = 0; i < diseaseForGridDropDown.length; i++) {
                if (data == diseaseForGridDropDown[i].idfsBaseReference ) {
                    sel += "<option   value = '" + diseaseForGridDropDown[i].idfsBaseReference + "' selected >" + diseaseForGridDropDown[i].strDefault + "</option>";
                }
                else {
                    sel += "<option   value = '" + diseaseForGridDropDown[i].idfsBaseReference + "' >" + diseaseForGridDropDown[i].strDefault + "</option>";
                }
                
            }
            sel += "</select>&nbsp;<a onclick='DisplayDiseaseEditor();' class='btn glyphicon glyphicon-plus'></a>";
            return sel;
        }
          function createInvestigationDataSelect(data, type, row, meta) {
            var rowId = meta.row;
            //console.log(meta);
            var sel = "<select class='tableDropDownInvestigation form-control' title='" + rowId + "'><option> </option>";
            for (var i = 0; i < investigationDataForGridDropDown.length; i++) {
                if (data == investigationDataForGridDropDown[i].idfsBaseReference) {
                     sel += "<option   value = '" + investigationDataForGridDropDown[i].idfsBaseReference + "' selected >" + investigationDataForGridDropDown[i].strDefault + "</option>";
                }
                else {
                     sel += "<option   value = '" + investigationDataForGridDropDown[i].idfsBaseReference + "' >" + investigationDataForGridDropDown[i].strDefault + "</option>";
                }
               
            }
            sel += "</select>&nbsp;<a onclick='DisplayBaseReferenceEditor();' class='btn glyphicon glyphicon-plus'></a>";
            return sel;
        }
        function createSpeciesDataSelect(data, type, row, meta) {
            var rowId = meta.row;
            //console.log(meta);
            var sel = "<select class='tableDropDownSpecies form-control' title='" + rowId + "'><option> </option>";
            for (var i = 0; i < speciesForGridDropDown.length; i++) {
                if (data == speciesForGridDropDown[i].idfsBaseReference) {
                      sel += "<option   value = '" + speciesForGridDropDown[i].idfsBaseReference + "' selected >" + speciesForGridDropDown[i].strDefault + "</option>";
                }
                else {
                    sel += "<option   value = '" + speciesForGridDropDown[i].idfsBaseReference + "' >" + speciesForGridDropDown[i].strDefault + "</option>";
                }
            
            }
            sel += "</select>&nbsp;<a onclick='DisplaySpeciesEditor();' class='btn glyphicon glyphicon-plus'></a>";
            return sel;
        }


        //Sets disease and attributes when dropdown  in Grid changes
        $(document).on('change', '.tableDropDowndisease', function () {
            var item = $(this);
            var selectedText = item.find("option:selected").text();
            var selectedValue = item.val();
            var rowId = item.attr("title");
            var table = $('#HumanAggregateCaseTable').DataTable();
            var cell7 = table.cell(rowId, 7);
            var cell4 = table.cell(rowId, 4);
            cell7.data(selectedValue);
            var selectedDiseaseIndex = item.get(0).selectedIndex - 1;
            var basereference;
            var OIE;
            if (diseaseForGridDropDown[selectedDiseaseIndex] == undefined) {
                basereference = "";
                cell7.data("");
            }
            else {
                basereference = diseaseForGridDropDown[selectedDiseaseIndex].idfsBaseReference;
                OIE = diseaseForGridDropDown[selectedDiseaseIndex].strOIECode;
                cell7.data(basereference);
                cell4.data(OIE);
            }
        });





         //Sets disease and attributes when dropdown  in Grid changes
        $(document).on('change', '.tableDropDownInvestigation', function () {
            var item = $(this);
            var selectedText = item.find("option:selected").text();
            var selectedValue = item.val();
            var rowId = item.attr("title");
            var table = $('#HumanAggregateCaseTable').DataTable();
            var cell5 = table.cell(rowId, 5);
            cell5.data(selectedValue);
            var selIndex = item.get(0).selectedIndex - 1;
            var basereference;
            if (investigationDataForGridDropDown[selIndex] == undefined) {
                basereference = "";
                cell5.data("");
            }
            else {
                if (investigationDataForGridDropDown[selIndex].strOIECode == "") {
                    basereference = "";
                }
                else {
                    basereference = investigationDataForGridDropDown[selIndex].idfsBaseReference;
                }
                cell5.data(basereference);
            }
        });



        //Sets disease and attributes when dropdown  in Grid changes
        $(document).on('change', '.tableDropDownSpecies', function () {
            var item = $(this);
            var selectedText = item.find("option:selected").text();
            var selectedValue = item.val();
            var rowId = item.attr("title");
            var table = $('#HumanAggregateCaseTable').DataTable();
            var cell6 = table.cell(rowId, 6);
            cell6.data(selectedValue);
            var selIndex = item.get(0).selectedIndex - 1;
            var basereference;
            if (speciesForGridDropDown[selIndex] == undefined) {
                basereference = "";
                cell6.data("");
            }
            else {
                basereference = speciesForGridDropDown[selIndex].idfsBaseReference;
                cell6.data(basereference);
            }
        });

        //Opens Base Reference Editor
        function DisplayBaseReferenceEditor() {
            $("#BaseReferencePanelModal").modal(
                {
                    show: true,
                    backdrop: false
                });
        }

        
        //Opens Species Editor
        function DisplaySpeciesEditor() {
            $("#SpeciesPanelModal").modal(
                {
                    show: true,
                    backdrop: false
                });
        }


        //Opens Disease Editor
        function DisplayDiseaseEditor() {
            $("#DiseasePanelModal").modal(
                {
                    show: true,
                    backdrop: false
                });
        }


        $('#BaseReferencePanelModal').on('hidden.bs.modal', function (e) {
            PageMethods.GetInvestigationTypes(InvestigationTypes);
            GetMatrixByVersion(versionId);
        });



        $('#DiseasePanelModal').on('hidden.bs.modal', function (e) {
            PageMethods.GetVetDiagnosisList(LoadedDiseases);
            GetMatrixByVersion(versionId);
        });

        $('#SpeciesPanelModal').on('hidden.bs.modal', function (e) {
            PageMethods.GetSpeciesList(LoadedSpecies);
            GetMatrixByVersion(versionId);
        });
   

        function Cancel() {
            ClearSelections();
            GetMatrixByVersion(00000000);
             $("#VersionDropDown").gorillaDropdown("select", { "index": 0 });
        }

        //Search objects
        function getObjects(obj, val) {
            // iterate over each element in the array
            for (var i = 0; i < obj.length; i++) {
                // look for the entry with a matching `code` value
                if (obj[i].value == val) {
                    return obj[i].text;
                }
            }
        }

        var highlightedRow = -1;
        function Increment() {
            highlightedRow++;
            console.log(highlightedRow);
        };
        function Decrease() {
            highlightedRow--;
            console.log(highlightedRow);
        };

        function hideModal(modalPopup) {
            var p = '#' + modalPopup;
            $(p).modal('hide');
        }
        function showModal(modalPopup) {
            var p = '#' + modalPopup;
            $(p).modal({ show: true, backdrop: false })
        }

        </script>
</asp:Content>


