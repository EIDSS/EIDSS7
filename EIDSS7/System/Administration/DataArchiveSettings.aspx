<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataArchiveSettings.aspx.vb" Inherits="EIDSS.DataArchiveSettings" MasterPageFile="~/NormalView.Master"  EnableSessionState="True"%>

<asp:content id="Content2" contentplaceholderid="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:MultiView ID="ArchiveSettingState" runat="server" ActiveViewIndex="0">
                <asp:View ID="AddDescriptionView" runat="server">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Data Archiving Settings</h2>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <label for="TextSummaryDescriptionSet">Schedule Summary Description</label>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="TextSummaryDescriptionSet" runat="server" Width="589px" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            <br />

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="txtIntervalUndefined">Interval of data relevance (in years)</label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtIntervalSet" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="panel-footer">
                            <asp:Button ID="AddArchiveDescription" runat="server" Text="Add" CssClass="btn btn-primary pull-right" />

                            <div class="clearfix"></div>
                        </div>

                    </div>
                </asp:View>
                <asp:View ID="SaveDescriptionView" runat="server">

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Schedule</h2>
                           
                        </div>

                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <label>Start Date</label>
                                </div>
                                <div class="col-md-3">
                                
                                      <eidss:CalendarInput ID="TxtDate" runat="server" ContainerCssClass="input-group datepicker"  CssClass="form-control"  ></eidss:CalendarInput>
                                    <asp:Literal ID="Literal1" runat="server" Visible="false"></asp:Literal>
                                </div>

                                <div class="col-md-2">
                                    <label>Start Time</label>
                                </div>
                                <div class="col-md-3">
                                 
                                  <%--  <asp:TextBox ID="HourId" runat="server" TextMode="Number" Width="50" Columns="2" MaxLength="2"></asp:TextBox> :<asp:TextBox ID="MinId"  runat="server" TextMode="Number" Width="50" Columns="2" MaxLength="2"></asp:TextBox> :<asp:TextBox ID="SecId" runat="server" TextMode="Number" Width="50" Columns="2" MaxLength="2"></asp:TextBox> --%>
                                    <asp:TextBox ID="TxtStartTime" runat="server" TextMode="Time" CssClass="form-control" CausesValidation="false"></asp:TextBox> 
                                </div>

                            </div>
                            <br />
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="txtIntervalDefined">Interval of data relevance (in years)</label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <eidss:NumericSpinner ID="txtIntervalYearsDefined" runat="server" CssClass="form-control" CausesValidation="True" TextMode="Number" ValidationGroup="YearInt" MinValue="0"></eidss:NumericSpinner>
                                    
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-md-3">
                                    <label for="txtDescriptionDefined">Schedule Summary Description</label>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtDescriptionDefined" runat="server" Width="555px" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="panel-footer">
                            <asp:HiddenField ID="hiddenArchiveSettingUID" runat="server" />
                            <asp:Button ID="SubmitBtn" runat="server" Text="Submit" CssClass="btn btn-primary pull-right" />

                            <asp:Button ID="CancelBtn" runat="server" Text="Cancel" CssClass="btn btn-primary pull-right" />
                            <asp:Button ID="EditBtn" runat="server" Text="Edit" CssClass="btn btn-primary pull-right " />
                            <div class="clearfix"></div>
                        </div>

                    </div>


                    </div>




                </asp:View>
            </asp:MultiView>

            <div class="modal fade" id="resultsModal" tabindex="-1" role="dialog">
                <div class="modal-dialog " role="document">
                    <div class="modal-content">
                        <div class="modal-header danger">
                            <h5 class="modal-title">EIDSS</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>
                                <asp:Literal ID="resultsLiteral" runat="server"></asp:Literal></p>
                        </div>
                     
                    </div>
                </div>
            </div>
             <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog">
                <div class="modal-dialog " role="document">
                    <div class="modal-content">
                        <div class="modal-header danger">
                            <h5 class="modal-title">EIDSS</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>
                                Are you sure you want to cancel?
                        </div>
                        <div class="modal-footer">
                           <asp:Button ID="ModalCancelBtn" runat="server" Text="Yes" CssClass="btn btn-primary" />
                            <asp:Button ID="ModalContinueBtn" runat="server" Text="No" CssClass="btn btn-primary"  />
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:content>


  


