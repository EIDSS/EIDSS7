<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MatrixUserControl.ascx.vb" Inherits="EIDSS.MatrixUserControl" %>


 <%@ Register src="DiseaseEditorUserControl.ascx" tagname="DiseaseEditorUserControl" tagprefix="uc1" %>

  <div class="panel panel-default">
        <div class="panel-heading">
            <h2>
                <asp:Label ID="Label4" runat="server" Text="Matrix Version" meta:resourcekey="Label4Resource1"></asp:Label></h2>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-3">
                    <asp:Label ID="Label1" runat="server" CssClass="form-control" meta:resourcekey="Label1Resource1"></asp:Label>
                    <br />
                    <asp:TextBox ID="VersionNameTxt" CssClass="form-control" ClientIDMode="Static" runat="server" meta:resourcekey="VersionNameTxtResource1"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="Label2" runat="server" CssClass="form-control" meta:resourcekey="Label2Resource1"></asp:Label>
                    <br />
                    <eidss:CalendarInput ID="ActivationDate" ContainerCssClass="input-group datepicker" CssClass="form-control" ClientIDMode="Static" runat="server" meta:resourcekey="ActivationDateResource1"></eidss:CalendarInput>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="Label3" runat="server" CssClass="form-control" meta:resourcekey="Label3Resource1"></asp:Label>
                    <br />
                    <select id="VersionDropDown" class="form-control">
                        <option ></option>

                    </select>
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
                <asp:Label ID="Label5" runat="server" Text="Human Aggregate Case Matrix" meta:resourcekey="Label5Resource1"></asp:Label></h2>


        </div>
        <div class="panel-body">
            <div id="btndiv" class="btndiv"></div>
            <asp:Table ID="HumanAggregateCaseTable" ClientIDMode="Static" runat="server" CssClass="table dataTable" meta:resourcekey="HumanAggregateCaseTableResource1">
                <asp:TableHeaderRow TableSection="TableHeader" VerticalAlign="Top" meta:resourcekey="TableHeaderRowResource1">
                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource1">Seq.</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource2">Diagnosis</asp:TableHeaderCell>

                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource3">IDC -10</asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource4"></asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource5"></asp:TableHeaderCell>
                    <asp:TableHeaderCell Width="20%" meta:resourcekey="TableHeaderCellResource6"></asp:TableHeaderCell>
                </asp:TableHeaderRow>

            </asp:Table>
        </div>
        <div class="panel-footer">
            <input type="button" class="btn btn-sm btn-default" value="Up" onclick="Decrease();" />
            <input type="button" class="btn btn-sm btn-default" value="Down" onclick="Increment();" />
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
    
    
    