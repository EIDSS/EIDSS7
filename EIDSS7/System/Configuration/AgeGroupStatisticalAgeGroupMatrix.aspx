<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="AgeGroupStatisticalAgeGroupMatrix.aspx.vb" Inherits="EIDSS.AgeGroupStatisticalAgeGroupMatrix" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
	<asp:UpdatePanel runat="server" ID="upAgeGroupStatisticalAgeGroupMatrix">
		<ContentTemplate>
			<div class="panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<h2 runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h2>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<div class="form-group">
						<div class="row">
							<div class="col-lg-6 col-md-6 col-sm-6 col-xs-7">
								<label runat="server" meta:resourcekey="lbl_Age_Group"></label>
								<div class="input-group">
									<asp:DropDownList ID="ddlidfsDiagnosisAgeGroup" runat="server" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true"></asp:DropDownList>
									<span class="input-group-btn">
										<button class="btn" type="button" onclick="showModal('addAgeGroup');" id="btnAgeGroup">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
									</span>
								</div>
							</div>
							<div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
								<br />
								<asp:Button ID="btnAgeGroupStatisticalAgeGroup" runat="server" CssClass="btn btn-default btn-sm" Enabled="False" meta:resourcekey="btn_Add" />
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<asp:GridView runat="server"
							ID="gvAgeGroupStatisticalAgeGroupMatrix"
							AutoGenerateColumns="False"
							EmptyDataText="No data available."
							CssClass="table table-striped"
							ShowHeaderWhenEmpty="true"
							ShowHeader="true"
							DataKeyNames="idfDiagnosisAgeGroupToStatisticalAgeGroup, idfsDiagnosisAgeGroup, idfsStatisticalAgeGroup"
							GridLines="None"
							AllowSorting="false"
							AllowPaging="true"
							PageSize="20"
							meta:resourceKey="gv_DiseaseGroupDiseaseMatrix">
							<HeaderStyle CssClass="table-striped-header" />
							<PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
							<Columns>
								<asp:TemplateField>
									<HeaderTemplate>
										<%# GetLocalResourceObject("lbl_Row.InnerText") %>
									</HeaderTemplate>
									<ItemTemplate>
										<asp:Label ID="lblItemNumber" runat="server" Text='<%# (Container.DataItemIndex + 1).ToString() %>' />
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText='<%$ Resources:lbl_Statistical_Age_Group.InnerText %>'>
									<ItemTemplate>
										<asp:Label ID="lblstrStatisticalAgeGroup" runat="server" Text='<%# Eval("strStatisticalAgeGroupName") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField ItemStyle-CssClass="icon">
									<ItemTemplate>
										<asp:LinkButton ID="btnDelete" CommandArgument="<%# CType(Container, GridViewRow).RowIndex %>" CommandName="Delete" CssClass="btn glyphicon glyphicon-trash" runat="server" meta:resourceKey="btn_Delete" />
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
						</asp:GridView>
					</div>
				</div>
			</div>			
			<div id="addAgeGroupStatisticalAgeGroup" class="modal">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
						</div>
						<div class="modal-body" id="sampleType" runat="server">
							<p runat="server" meta:resourcekey="lbl_Age_Group_Statistical_Age_Group_Instructions"></p>
							<div class="form-group">
								<div class="row">
									<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
										<span class="glyphicon glyphicon-certificate text-danger"></span>
										<label runat="server" meta:resourcekey="lbl_Statistical_Age_Group"></label>
										<div class="input-group">
											<asp:DropDownList ID="ddlidfsStatisticalAgeGroup" CssClass="form-control" runat="server" AppendDataBoundItems="true"></asp:DropDownList>
											<span class="input-group-btn">
												<button class="btn" type="submit" runat="server" data-dismiss="modal" id="btnAddStatisticalAgeGroup">
													<span class="glyphicon glyphicon-plus"></span>
												</button>
											</span>
										</div>
									</div>
								</div>
							</div>
							<asp:HiddenField ID="hdfAGSAGValidationError" runat="server" Value="False" />
							<asp:HiddenField ID="hdfAGSAGidfDiagnosisAgeGroupToStatisticalAgeGroup" runat="server" Value="NULL" />
						</div>
						<div class="modal-footer">
							<button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" id="btnSubmitAgeGroupStatisticalAgeGroupMatrix" data-dismiss="modal" />
							<button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelAgeGroupStatisticalAgeGroup" />
						</div>
					</div>
				</div>
			</div>
            <div id="addAgeGroup" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
                        </div>
                        <div class="modal-body" id="ageGroup" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Age_Group_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtAGstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtAGstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Lower_Bound"></label>
                                        <eidss:NumericSpinner ID="txtAGintLowerBoundary" CssClass="form-control" runat="server" MinValue="0" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Upper_Bound"></label>
                                        <eidss:NumericSpinner ID="txtAGintUpperBoundary" CssClass="form-control" runat="server" MinValue="0" />
                                    </div>
                                </div>
                                <small runat="server" meta:resourceKey="lbl_Blank_Boundaries"></small>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Interval_Type"></label>
                                        <asp:DropDownList ID="ddlAGidfsAgeType" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtAGintOrder" CssClass="form-control" runat="server" MinValue="0" />                                        
                                        <small runat="server" meta:resourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfAGValidationError" runat="server" Value="False" />
                            <asp:HiddenField ID="hdfAGidfsAgeGroup" runat="server" Value="NULL" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Submit" id="btnSubmitAgeGroup" />
                            <button type="submit" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_Cancel" id="btnCancelAgeGroup" />
                        </div>
                    </div>
                </div>
            </div>
			<div id="addStatisticalAgeGroup" class="modal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
                        </div>
                        <div class="modal-body" runat="server">
                            <p runat="server" meta:resourcekey="lbl_Statistical_Age_Group_Instructions"></p>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_English_Value"></label>
                                        <asp:TextBox ID="txtSAGstrDefault" CssClass="form-control" runat="server" />
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <span class="glyphicon glyphicon-certificate text-danger"></span>
                                        <label runat="server" meta:resourcekey="lbl_Translated_Value"></label>
                                        <asp:TextBox ID="txtSAGstrName" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                        <label runat="server" meta:resourcekey="lbl_Order"></label>
                                        <eidss:NumericSpinner ID="txtSAGintOrder" CssClass="form-control" runat="server" MinValue="0" />
                                        <small runat="server" meta:resourceKey="lbl_Blank_Order"></small>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfSAGValidationError" runat="server" Value="False" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" runat="server" class="btn btn-primary" meta:resourcekey="btn_Submit" data-dismiss="modal" id="btnSubmitStatisticalAgeGroup" />
                            <button type="submit" runat="server" class="btn btn-default" meta:resourcekey="btn_Cancel" data-dismiss="modal" id="btnCancelStatisticalAgeGroup" />
                        </div>
                    </div>
                </div>
            </div>
			<div id="errorModal" class="modal" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
						</div>
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
										<span class="glyphicon glyphicon-remove-sign modal-icon"></span>
									</div>
									<div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
										<p id="lbl_Error" runat="server"></p>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer text-center">
							<button type="submit" id="btnErrorOK" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
						</div>
					</div>
				</div>
			</div>
			<div id="successModal" class="modal" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
						</div>
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
										<span class="glyphicon glyphicon-ok-sign modal-icon"></span>
									</div>
									<div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
										<p id="lblSuccess" runat="server"></p>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer text-center">
							<button runat="server" type="submit" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" id="btnSuccessOK"></button>
						</div>
					</div>
				</div>
			</div>
			<div id="deleteModal" class="modal" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
						</div>
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
										<span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
									</div>
									<div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
										<p id="lbl_Delete" runat="server"></p>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer text-center">
							<button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnDeleteYes" type="submit"></button>
							<button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No"></button>
						</div>
					</div>
				</div>
			</div>
			<div id="cancelModal" class="modal" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
						</div>
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
										<span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
									</div>
									<div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
										<p id="lbl_Cancel" runat="server"></p>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer text-center">
							<button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnCancelYes" type="submit"></button>
							<button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnCancelNo" type="submit"></button>
						</div>
					</div>
				</div>
			</div>
            <div id="cancelReference" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Cancel_Reference" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnCancelReferenceYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnCancelReferenceNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="continueRequired" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Continue_Required" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnContinueRequiredYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnContinueRequiredNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="alreadyExists" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Age_Group_Statistical_Age_Group_Matrix"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-exclamation-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Already_Exists" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Yes" id="btnAlreadyExistsYes" type="submit"></button>
                            <button runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_No" id="btnAlreadyExistsNo" type="submit"></button>
                        </div>
                    </div>
                </div>
            </div>
			<script type="text/javascript">
				$(function () {
					$('.modal').modal({ show: false, backdrop: 'static' });
				});

				function hideModal(modalPopup) {
					var p = '#' + modalPopup;
					$(p).modal({ show: false, backdrop: 'static' });
				};

				function showModal(modalPopup) {
					var p = '#' + modalPopup;
					$(p).modal({ show: true, backdrop: 'static' });
				};
			</script>
		</ContentTemplate>
	</asp:UpdatePanel>
</asp:Content>
