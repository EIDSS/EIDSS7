<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateFarmUserControl.ascx.vb" Inherits="EIDSS.AddUpdateFarmUserControl" %>
<%@ Register Src="HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:UpdatePanel ID="upAddUpdateFarm" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnPersonSearch" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfFarmAddressID" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmAddressidfsCountry" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmOwnerID" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmOwnerFirstName" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmOwnerLastName" runat="server" Value="" />
        <asp:HiddenField ID="hdfVeterinaryDiseaseReportID" runat="server" Value="" />
        <asp:HiddenField ID="hdfDiseaseReportTypeID" runat="server" Value="" />
        <asp:HiddenField ID="hdfMonitoringSessionID" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmID" runat="server" Value="" />
        <asp:HiddenField ID="hdfRecordID" runat="server" Value="0" />
        <asp:HiddenField ID="hdfRowAction" runat="server" Value="" />
        <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
        <asp:HiddenField ID="hdfRecordType" runat="server" Value="" />
        <asp:HiddenField ID="hdfFarmMasterID" runat="server" Value="-1" />
        <asp:HiddenField ID="hdfTotalAnimalQuantity" runat="server" Value="0" />
        <asp:HiddenField ID="hdfShowFarmInventory" runat="server" Value="False" />
        <div class="panel panel-default">
            <div class="row">
                <div class="col-md-12">
                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                    <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
                </div>
            </div>
            <div class="panel-body">
                <div id="divFarmForm" runat="server" class="row embed-panel">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="sectionContainer expanded">
                                <div class="embed-fieldset">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Date_Entered">
                                            <label for="txtEnteredDate"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Entered_Text") %></label>
                                            <asp:TextBox ID="txtEnteredDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Date_Last_Saved">
                                            <label for="txtModifiedDate"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Last_Updated_Text") %></label>
                                            <asp:TextBox ID="txtModifiedDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <section id="FarmInformation" runat="server" class="col-md-12">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" class="heading" meta:resourcekey="Hdg_Farm_Information"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="divFarmID" runat="server" class="form-group">
                                                <div class="row">
                                                    <div class="col-md-6" runat="server" meta:resourcekey="Dis_Farm_ID">
                                                        <label for="txtEIDSSFarmID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                                        <asp:TextBox ID="txtEIDSSFarmID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" meta:resourcekey="Dis_Farm_Type">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="Req_Farm_Type"></span>
                                                        <label for="rblFarmTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Type_Text") %></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblFarmTypeID" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="radio-inline formatRadioButtonList"></asp:RadioButtonList>
                                                            <asp:CustomValidator ID="cvFarmTypeID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Farm_Type" ValidationGroup="FarmInformation" ControlToValidate="rblFarmTypeID" ValidateEmptyText="true" ClientValidationFunction="validateFarmType" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" runat="server" meta:resourcekey="Dis_Farm_Name">
                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Farm_Name"></span>
                                                <label for="txtFarmName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Name_Text") %></label>
                                                <asp:TextBox ID="txtFarmName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtFarmName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Farm_Name" runat="server" ValidationGroup="FarmInformation"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group" runat="server" meta:resourcekey="Dis_Farm_Owner">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Farm_Owner"></span>
                                                        <label for="txtFarmOwner" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_Text") %></label>
                                                        <div id="divSearchFarmOwnerContainer" class="input-group" runat="server">
                                                            <asp:TextBox CssClass="form-control" ID="txtFarmOwner" runat="server" Enabled="false"></asp:TextBox>
                                                            <asp:LinkButton ID="btnPersonSearch" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                                                        </div>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtFarmOwner" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Farm_Owner_Name" runat="server" ValidationGroup="FarmInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Phone">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Phone"></span>
                                                        <label for="txtPhone" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Phone_Text") %></label>
                                                        <div class="input-group">
                                                            <span class="input-group-addon">
                                                                <span class="glyphicon glyphicon-earphone"></span>
                                                            </span>
                                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtPhone" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Phone" runat="server" ValidationGroup="FarmInformation"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtPhone" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Phone_Invalid" ValidationGroup="FarmInformation" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Fax">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Fax"></span>
                                                        <label for="txtFax" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Fax_Text") %></label>
                                                        <div class="input-group">
                                                            <span class="input-group-addon">
                                                                <span class="glyphicon glyphicon-print"></span>
                                                            </span>
                                                            <asp:TextBox ID="txtFax" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtFax" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Fax" runat="server" ValidationGroup="FarmInformation"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtFax" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Fax_Invalid" ValidationGroup="FarmInformation" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Email">
                                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Email"></span>
                                                        <label for="txtEmail" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Email_Text") %></label>
                                                        <div class="input-group">
                                                            <span class="input-group-addon">
                                                                <span class="glyphicon glyphicon-envelope"></span>
                                                            </span>
                                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmail" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Email" runat="server" ValidationGroup="FarmInformation"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtEmail" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Email_Invalid" runat="server" ValidationGroup="FarmInformation" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="FarmAddressInformation" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" class="heading" meta:resourcekey="Hdg_Farm_Address"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <eidss:Location ID="FarmAddress" runat="server" ValidationGroup="FarmAddressInformation" IsHorizontalLayout="true" ShowCountry="true" IsDbRequiredCountry="true" ShowRegion="true" IsDbRequiredRegion="true" ShowRayon="true" IsDbRequiredRayon="true" ShowSettlement="true" ShowStreet="true" ShowBuildingHouseApartmentGroup="true" ShowPostalCode="true" ShowMap="true" ShowCoordinates="true" ShowElevation="false" />
                                        </div>
                                    </div>
                                </section>
                                <section id="HerdSpeciesInformation" class="col-md-12 hidden" runat="server" visible="False">
                                    <asp:UpdatePanel ID="upFarmHerdSpecies" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="btnAddFlock" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="btnAddHerd" EventName="Click" />
                                            <asp:AsyncPostBackTrigger ControlID="txtFarmName" EventName="TextChanged" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <h3 id="hdgFlocksHerdsSpecies" runat="server"></h3>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
                                                            <asp:Button ID="btnAddFlock" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: Buttons, Btn_Add_Flock_ToolTip %>" Text="<%$ Resources: Buttons, Btn_Add_Flock_Text %>" />
                                                            <asp:Button ID="btnAddHerd" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: Buttons, Btn_Add_Herd_ToolTip %>" Text="<%$ Resources: Buttons, Btn_Add_Herd_Text %>" />
                                                        </div>
                                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'));"></a>
                                                        </div>
                                                    </div>
                                                    <div class="row">&nbsp;</div>
                                                </div>
                                                <div class="panel-body">
                                                    <div class="table-responsive">
                                                        <eidss:GridView ID="gvFlocksHerds" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped"
                                                        DataKeyNames="HerdMasterID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" GridLines="None" PagerSettings-Visible="false"
                                                        ShowFooter="true" UseAccessibleHeader="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="100%">
                                                                <HeaderTemplate>
                                                                    <div class="col-lg-3">
                                                                        <asp:Label ID="lblHdrSpecies" runat="server" Text="<%$ Resources: Labels, Lbl_Species_Text %>"></asp:Label>
                                                                    </div>
                                                                    <div class="col-lg-3">
                                                                        <asp:Label ID="lblHdrTotalAnimalQty" runat="server" Text="<%$ Resources: Labels, Lbl_Total_Animal_Quantity_Text %>"></asp:Label>
                                                                    </div>
                                                                    <div class="col-lg-2"></div>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <div class="row">
                                                                        <div class="col-lg-3">
                                                                            <asp:Label runat="server" ID="lblEIDSSHerdID" CssClass="form-control"></asp:Label>
                                                                            <asp:HiddenField ID="hdfHerdMasterID" runat="server" Value='<% #Eval("HerdMasterID") %>' />
                                                                        </div>
                                                                        <div class="col-lg-3">
                                                                            <asp:Label runat="server" ID="lblFarmTotalAnimalQuantity" Text='<% #Eval("TotalAnimalQuantity") %>' CssClass="form-control"></asp:Label>
                                                                        </div>
                                                                        <div class="col-lg-2">
                                                                            <asp:LinkButton ID="btnAddSpecies" runat="server" CssClass="btn btn-default btn-sm" CommandName="Update" CommandArgument='<% #Eval("HerdMasterID") %>' CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>"></asp:LinkButton>
                                                                        </div>
                                                                    </div>
                                                                    <div class="row">
                                                                        <eidss:GridView ID="gvSpecies" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="SpeciesMasterID"
                                                                            EmptyDataText="" GridLines="None" ShowFooter="False" UseAccessibleHeader="False" OnRowDataBound="Species_RowDataBound">
                                                                            <Columns>
                                                                                <asp:TemplateField>
                                                                                    <ItemTemplate>
                                                                                        <asp:UpdatePanel ID="upSpecies" runat="server" UpdateMode="Conditional">
                                                                                            <Triggers>
                                                                                                <asp:AsyncPostBackTrigger ControlID="ddlFarmSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                                                                <asp:AsyncPostBackTrigger ControlID="txtFarmTotalAnimalQuantity" EventName="TextChanged" />
                                                                                            </Triggers>
                                                                                            <ContentTemplate>
                                                                                                <div class="row">
                                                                                                    <div class="col-lg-3">
                                                                                                        <asp:HiddenField ID="hdfSpeciesMasterID" runat="server" Value='<%# Bind("SpeciesMasterID") %>' />
                                                                                                        <eidss:DropDownList ID="ddlFarmSpeciesTypeID" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="FarmSpeciesTypeID_SelectedIndexChanged"></eidss:DropDownList>
                                                                                                    </div>
                                                                                                    <div class="col-lg-3">
                                                                                                        <eidss:NumericSpinner ID="txtFarmTotalAnimalQuantity" runat="server" CssClass="form-control" Text='<% #Bind("TotalAnimalQuantity") %>' MinValue="0" AutoPostBack="true" OnTextChanged="FarmTotalAnimalQuantity_TextChanged"></eidss:NumericSpinner>
                                                                                                        <asp:RequiredFieldValidator ControlToValidate="txtFarmTotalAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Total_Animal_Qty" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                    </div>
                                                                                                    <div class="col-lg-2">
                                                                                                        <asp:LinkButton ID="btnDeleteSpecies" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("SpeciesMasterID") %>' CausesValidation="false"></asp:LinkButton>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </asp:UpdatePanel>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </eidss:GridView>
                                                                    </div>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </section>
                                <div class="col-md-12">
                                    <div id="divSelectablePreviewVeterinaryDiseaseReportList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Disease_Reports"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                                                    <asp:Button ID="btnAddVeterinaryDiseaseReport" runat="server" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false"></asp:Button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <eidss:GridView ID="gvVeterinaryDiseaseReports" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" DataKeyNames="VeterinaryDiseaseReportID" ShowHeaderWhenEmpty="true" ShowFooter="true" GridLines="None" PagerSettings-Visible="false">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                    <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Report_ID_Text %>">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnViewSelectablePreview" runat="server" CssClass="btn btn-link" role="link" BorderStyle="None" CommandName="Select Report" CommandArgument='<% #Eval("VeterinaryDiseaseReportID").ToString() %>' Text='<% #Bind("EIDSSReportID") %>'></asp:Button>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                        <asp:BoundField DataField="SpeciesList" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                        <asp:BoundField DataField="EnteredDate" ReadOnly="true" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Data_Entry_Date_Text %>" />
                                                        <asp:BoundField DataField="InvestigationDate" ReadOnly="true" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Investigation_Date_Text %>" />
                                                        <asp:BoundField DataField="DiseaseName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                        <asp:BoundField DataField="ReportTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Report_Type_Text %>" />
                                                        <asp:BoundField DataField="ClassificationTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                                        <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Report_Status_Text %>" />
                                                        <asp:BoundField DataField="FormattedFarmAddressString" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Address_Text %>" />
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <div style="white-space: nowrap; vertical-align: top;">
                                                                    <a id="expandCollapseVeterinaryDiseaseReportDetails" style="vertical-align: bottom"><span class="glyphicon glyphicon-plus-sign" onclick="showVeterinaryDiseaseReportSubGrid(event,'div<%# Eval("VeterinaryDiseaseReportID") %>');"></span></a>
                                                                    <asp:LinkButton ID="btnSelectSelectablePreviewVeterinaryDiseaseReport" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Select" CommandArgument='<% #Bind("VeterinaryDiseaseReportID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <tr id="div<%# Eval("VeterinaryDiseaseReportID") %>" style="display: none;">
                                                                    <td colspan="8">
                                                                        <div style="position: relative; left: 100px; overflow: auto; overflow-x: hidden; width: 80%;">
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtReportDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Date_Text") %></label>
                                                                                        <asp:TextBox ID="txtReportDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("ReportDate", "{0:d}") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                        <label for="txtPersonReportedByName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Reported_By_Name_Text") %></label>
                                                                                        <asp:TextBox ID="txtPersonReportedByName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonReportedByName") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtInvestigationDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Investigation_Date_Text") %></label>
                                                                                        <asp:TextBox ID="txtInvestigationDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("InvestigationDate", "{0:d}") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                        <label for="txtPersonInvestigatedBy" class="control-label"><% =GetGlobalResourceObject("Labels", "LblInvestigated_By_Name_Text") %></label>
                                                                                        <asp:TextBox ID="txtPersonInvestigatedBy" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonInvestigatedByName") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                                        <label for="txtSpeciesList" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                                                        <asp:TextBox ID="txtSpeciesList" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("SpeciesList") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtTotalAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtTotalAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalAnimalQuantity") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtTotalSickAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Sick_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtTotalSickAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalSickAnimalQuantity") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtTotalDeadAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Dead_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtTotalDeadAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalDeadAnimalQuantity") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                            <div id="divVeterinaryDiseaseReportPager" class="row grid footer" runat="server">
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblVeterinaryDiseaseReportNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblVeterinaryDiseaseReportPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                    <asp:Repeater ID="rptVeterinaryDiseaseReportPager" runat="server">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnViewSelectablePreviewPage" runat="server" CssClass="btn btn-primary btn-xs" role="link" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="VeterinaryDiseaseReportPage_Changed" Height="20" CausesValidation="false"></asp:Button>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divSelectablePreviewOutbreakCaseList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Outbreak_Cases"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                                                    <asp:Button ID="btnAddOutbreakCase" runat="server" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <eidss:GridView ID="gvOutbreakCases" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" DataKeyNames="VeterinaryDiseaseReportID" ShowHeaderWhenEmpty="true" ShowFooter="true" GridLines="None" PageSize="10">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:BoundField DataField="EIDSSOutbreakID" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Outbreak_ID_Text %>" />
                                                        <asp:BoundField DataField="SpeciesList" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Species_Text %>" />
                                                        <asp:BoundField DataField="EnteredDate" ReadOnly="true" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Data_Entry_Date_Text %>" />
                                                        <asp:BoundField DataField="DiseaseName" ReadOnly="true" SortExpression="DiseaseName" HeaderText="<%$ Resources: Labels, Lbl_Disease_Text %>" />
                                                        <asp:BoundField DataField="ReportTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Report_Type_Text %>" />
                                                        <asp:BoundField DataField="ClassificationTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                                        <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Report_Status_Text %>" />
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <div style="white-space: nowrap; vertical-align: top;">
                                                                    <a id="expandCollapseOutbreakCaseDetails" style="vertical-align: bottom"><span class="glyphicon glyphicon-plus-sign" onclick="showOutbreakCaseSubGrid(event,'div<%# Eval("VeterinaryDiseaseReportID") %>');"></span></a>
                                                                    <asp:Button ID="btnSelectOutbreakCase" runat="server" CssClass="btn glyphicon glyphicon-edit" role="link" CommandName="Select" CommandArgument='<% #Bind("OutbreakCaseID") %>' CausesValidation="false"></asp:Button>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <tr id="div<%# Eval("VeterinaryDiseaseReportID") %>" style="display: none;">
                                                                    <td colspan="8">
                                                                        <div style="position: relative; left: 100px; overflow: auto; overflow-x: hidden; width: 80%;">
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtOMMReportDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Report_Date_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMReportDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("ReportDate", "{0:d}") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                        <label for="txtOMMPersonReportedByName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Reported_By_Name_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMPersonReportedByName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonReportedByName") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtOMMInvestigationDate" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Investigation_Date_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMInvestigationDate" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("InvestigationDate", "{0:d}") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                                        <label for="txtOMMPersonInvestigatedBy" class="control-label"><% =GetGlobalResourceObject("Labels", "LblInvestigated_By_Name_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMPersonInvestigatedBy" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("PersonInvestigatedByName") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                                        <label for="txtOMMSpeciesList" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMSpeciesList" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("SpeciesList") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtOMMTotalAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMTotalAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalAnimalQuantity") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtOMMTotalSickAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Sick_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMTotalSickAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalSickAnimalQuantity") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                                        <label for="txtOMMTotalDeadAnimalQuantity" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Total_Dead_Animal_Quantity_Text") %></label>
                                                                                        <asp:TextBox ID="txtOMMTotalDeadAnimalQuantity" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("TotalDeadAnimalQuantity") %>' />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                            <div id="divOutbreakCasePager" class="row grid footer" runat="server">
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblOutbreakCaseNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblOutbreakCasePageNumber" runat="server" CssClass="control-label"></asp:Label>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                                    <asp:Repeater ID="rptOutbreakCasePager" runat="server">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnOutbreakCasePage" runat="server" CssClass="btn btn-primary btn-xs" role="link" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="OutbreakCasePage_Changed" Height="20" CausesValidation="false"></asp:Button>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <eidss:SideBarNavigation ID="FarmSideBar" runat="server">
                                <MenuItems>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')" ID="sbiFarmInformation" ItemStatus="IsNormal" Text="<%$ Resources: Tabs, Tab_Farm_Information_Text %>" runat="server"></eidss:SideBarItem>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="1, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')" ID="sbiFarmAddress" ItemStatus="IsNormal" Text="<%$ Resources: Tabs, Tab_Farm_Address_Text %>" runat="server"></eidss:SideBarItem>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" ID="sbiFlocksHerdsSpecies" ItemStatus="IsNormal" runat="server"></eidss:SideBarItem>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-file" ID="sbiFarmReview" ItemStatus="IsReview" Text="<%$ Resources: Tabs, Tab_Farm_Review_Text %>" runat="server"></eidss:SideBarItem>
                                </MenuItems>
                            </eidss:SideBarNavigation>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                            <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')); return false;" UseSubmitBehavior="False" />
                            <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')); return false;" UseSubmitBehavior="False" />
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" CausesValidation="true" />
                            <asp:Button ID="btnDelete" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" runat="server" CausesValidation="false" Visible="false" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hdfFarmPanelController" runat="server" Value="0" />
    </ContentTemplate>
</asp:UpdatePanel>
<div id="divSpeciesModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divSpeciesModal">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSpeciesModal');">&times;</button>
            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Species"></h4>
        </div>
        <div class="modal-body modal-wrapper">
            <asp:UpdatePanel ID="upSpecies" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Herd" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Herd" runat="server"></div>
                                <asp:Label ID="lblHerdFlock" AssociatedControlID="ddlHerdID" CssClass="control-label" runat="server"></asp:Label>
                                <eidss:DropDownList CssClass="form-control" ID="ddlHerdID" runat="server"></eidss:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvHerd" ControlToValidate="ddlHerdID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Herd" runat="server" ValidationGroup="FarmHerdSpecies"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Species_Type" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Species_Type" runat="server"></div>
                                <asp:Label AssociatedControlID="ddlSpeciesTypeID" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Species_Type_Text %>" runat="server"></asp:Label>
                                <eidss:DropDownList ID="ddlSpeciesTypeID" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="rfvSpeciesType" ControlToValidate="ddlSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Species_Type" runat="server" ValidationGroup="FarmHerdSpecies"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Total_Animal_Quantity" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Total_Animal_Quantity" runat="server"></div>
                                <asp:Label AssociatedControlID="txtTotalAnimalQuantity" CssClass="control-label" Text="<%$ Resources: Labels, Lbl_Total_Text %>" runat="server"></asp:Label>
                                <eidss:NumericSpinner ID="txtTotalAnimalQuantity" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                <asp:RequiredFieldValidator ID="rfvTotalAnimalQuantity" ControlToValidate="txtTotalAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Total_Animal_Quantity" runat="server" ValidationGroup="FarmHerdSpecies"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div class="modal-footer text-center">
                <asp:Button ID="btnSpeciesOK" runat="server" Text="<%$ Resources: Buttons, Btn_Ok_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Ok_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="FarmHerdSpecies" />
                <button type="button" class="btn btn-default" runat="server" data-dismiss="modal" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
            </div>
        </div>
    </div>
</div>
