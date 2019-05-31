<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdatePersonUserControl.ascx.vb" Inherits="EIDSS.AddUpdatePersonUserControl" %>
<%@ Register Src="HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>
<%@ Register Src="~/Controls/ReferenceUserControl.ascx" TagPrefix="eidss" TagName="BaseReference" %>

<asp:UpdatePanel ID="upAddUpdatePerson" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="txtDateOfBirth" EventName="TextChanged" />
        <asp:AsyncPostBackTrigger ControlID="chkEmployerForeignAddressIndicator" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="chkSchoolForeignAddressIndicator" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="chkHumanAltForeignAddressIndicator" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyEmployedNo" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyEmployedYes" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyEmployedUnknown" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyInSchoolNo" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyInSchoolYes" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbCurrentlyInSchoolUnknown" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbAnotherPhoneNo" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="rdbAnotherPhoneYes" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="txtPersonalID" EventName="TextChanged" />
        <asp:PostBackTrigger ControlID="gvHumanDiseaseReports" />
        <asp:PostBackTrigger ControlID="btnAddSelectablePreviewHumanDiseaseReport" />
        <asp:AsyncPostBackTrigger ControlID="btnAddOccupation" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" visible="false">
            <asp:HiddenField ID="hdfHumanMasterID" runat="server" Value="" />
            <asp:HiddenField ID="hdfCopyToHumanIndicator" runat="server" Value="False" />
            <asp:HiddenField ID="hdfName" runat="server" />
            <asp:HiddenField ID="hdfCurrentDate" runat="server" />
            <asp:HiddenField ID="txtDateOfDeath" runat="server" Value="null" />
            <asp:HiddenField ID="hdfCurrentlyEmployed" runat="server" />
            <asp:HiddenField ID="hdfIsEmployedTypeID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfEmployerGeoLocationID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfCurrentlyInSchool" runat="server" />
            <asp:HiddenField ID="hdfIsStudentTypeID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfSchoolGeoLocationID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfHumanGeoLocationID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfHumanAltGeoLocationID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfPhone" runat="server" />
            <asp:HiddenField ID="hdfAnotherPhone" runat="server" />
            <asp:HiddenField ID="hdfOtherPhone" runat="server" Value="null" />
            <asp:HiddenField ID="hdfRegistrationPhone" runat="server" Value="null" />
            <asp:HiddenField ID="hdfHomePhone" runat="server" Value="null" />
            <asp:HiddenField ID="hdfWorkPhone" runat="server" Value="null" />
            <asp:HiddenField ID="hdfContactPhoneCountryCode" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfContactPhone2CountryCode" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfSearchPatientID" runat="server" Value="null" />
            <asp:HiddenField ID="hdfHumanidfsCountry" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfEmployeridfsCountry" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfHumanAltidfsCountry" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfSchoolidfsCountry" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfAltAddressID" runat="server" Value="NULL" />
            <asp:HiddenField ID="hdfEmployerForeignAddressIndicator" runat="server" Value="False" />
            <asp:HiddenField ID="hdfSchoolForeignAddressIndicator" runat="server" Value="False" />
            <asp:HiddenField ID="hdfHumanAltForeignAddressIndicator" runat="server" Value="False" />
        </div>
        <div id="divGridViewSortFields" visible="false">
            <asp:HiddenField ID="hdfHumanDiseaseReportsSortExpression" runat="server" Value="EIDSSReportID" />
            <asp:HiddenField ID="hdfHumanDiseaseReportsSortDirection" runat="server" Value="DESC" />
            <asp:HiddenField ID="hdfFarmsSortExpression" runat="server" Value="strFarmCode" />
            <asp:HiddenField ID="hdfFarmsSortDirection" runat="server" Value="DESC" />
        </div>
        <div class="panel panel-default">
            <div class="row">
                <div class="col-md-12">
                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                    <% =GetGlobalResourceObject("OtherText", "Pln_Required_Text") %>
                </div>
            </div>
            <div class="panel-body">
                <div id="divPersonForm" runat="server" class="row embed-panel">
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
                                            <label for="txtModificationDate"><% =GetGlobalResourceObject("Labels", "Lbl_Date_Last_Updated_Text") %></label>
                                            <asp:TextBox ID="txtModificationDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <section id="PersonInformation" runat="server" class="col-md-12">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Person_Information"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="divPersonID" runat="server" class="form-group">
                                                <div class="row">
                                                    <div class="col-md-6" runat="server" meta:resourcekey="Dis_Person_ID">
                                                        <label for="txtEIDSSPersonID" runat="server" meta:resourcekey="Lbl_Person_ID"></label>
                                                        <asp:TextBox ID="txtEIDSSPersonID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-md-6" runat="server" meta:resourcekey="Dis_Personal_ID_Type">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Personal_ID_Type" runat="server"></div>
                                                        <label for="ddlPersonalIDType" runat="server" meta:resourcekey="Lbl_Personal_ID_Type"></label>
                                                        <eidss:DropDownList ID="ddlPersonalIDType" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlPersonalIDType" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Personal_ID_Type" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-md-6" meta:resourcekey="Dis_Personal_ID_Number">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Personal_ID_Number" runat="server"></div>
                                                        <label for="txtPersonalID" runat="server" meta:resourcekey="Lbl_Personal_ID"></label>
                                                        <asp:TextBox ID="txtPersonalID" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtPersonalID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Personal_ID" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                        <asp:Button ID="btnFindInPINSystem" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Find_In_PIN_System_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Find_In_PIN_System_ToolTip %>" Enabled="false" Visible="false" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Last_Name">
                                                        <div class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="Req_Last_Name" runat="server"></div>
                                                        <label for="txtLastOrSurname" runat="server" meta:resourcekey="Lbl_Last_Name"></label>
                                                        <asp:TextBox ID="txtLastOrSurname" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtLastOrSurname" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Last_Name" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Middle_Name">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Middle_Name" runat="server"></div>
                                                        <label for="txtSecondName" runat="server" meta:resourcekey="Lbl_Middle_Name"></label>
                                                        <asp:TextBox ID="txtSecondName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtSecondName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Middle_Name" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_First_Name">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_First_Name" runat="server"></div>
                                                        <label for="txtFirstOrGivenName" runat="server" meta:resourcekey="Lbl_First_Name"></label>
                                                        <asp:TextBox ID="txtFirstOrGivenName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtFirstOrGivenName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_First_Name" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_DOB">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_DOB" runat="server"></div>
                                                        <label for="txtDateOfBirth" runat="server" meta:resourcekey="Lbl_DOB"></label>
                                                        <eidss:CalendarInput ID="txtDateOfBirth" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" onblur="showAge();"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtDateOfBirth" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_DOB" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Age">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Age" runat="server"></div>
                                                        <label for="txtReportedAge" runat="server" meta:resourcekey="Lbl_Age"></label>
                                                        <div class="input-group age">
                                                            <asp:TextBox ID="txtReportedAge" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <div class="input-group-addon">
                                                                <asp:DropDownList ID="ddlReportedAgeUOMID" runat="server" CssClass="form-control" />
                                                            </div>
                                                        </div>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtReportedAge" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Age" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Gender">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Gender" runat="server"></div>
                                                        <label for="ddlGenderTypeID" runat="server" meta:resourcekey="Lbl_Gender"></label>
                                                        <eidss:DropDownList ID="ddlGenderTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlGenderTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Gender" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Citizenship">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Citizenship" runat="server"></div>
                                                        <label for="ddlCitizenshipTypeID" runat="server" meta:resourcekey="Lbl_Citizenship"></label>
                                                        <eidss:DropDownList ID="ddlCitizenshipTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlCitizenshipTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Citizenship" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Passport_Number">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Passport_Number" runat="server"></div>
                                                        <label for="txtPassportNumber" runat="server" meta:resourcekey="Lbl_Passport_Number"></label>
                                                        <asp:TextBox ID="txtPassportNumber" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtPassportNumber" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Passport_Number" runat="server" ValidationGroup="PersonInformation"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="PersonAddress" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Person_Address_and_Phone"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <eidss:Location ID="Human" runat="server" IsHorizontalLayout="true" ValidationGroup="PersonAddress" ShowCountry="false" ShowStreet="true" ShowElevation="false" IsDbRequiredCountry="true" IsDbRequiredRegion="true" IsDbRequiredRayon="true" />
                                            <div class="form-group" meta:resourcekey="Dis_Another_Address">
                                                <label runat="server" meta:resourcekey="Lbl_Another_Address"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbAnotherAddressYes" runat="server" GroupName="AnotherAddress" CssClass="radio-inline" OnCheckedChanged="AnotherAddress_CheckedChanged" CausesValidation="false" meta:resourceKey="Lbl_Yes" />
                                                        <asp:RadioButton ID="rdbAnotherAddressNo" runat="server" GroupName="AnotherAddress" CssClass="radio-inline" OnCheckedChanged="AnotherAddress_CheckedChanged" CausesValidation="false" meta:resourceKey="Lbl_No" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlAnotherAddress" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="form-check">
                                                        <asp:CheckBox ID="chkHumanAltForeignAddressIndicator" runat="server" CssClass="form-check-input" />
                                                        <label for="chkHumanAltForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                    </div>
                                                </div>
                                                <eidss:Location ID="HumanAlt" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" IsDbRequiredCountry="true" ShowMap="false" />
                                                <div id="divHumanAltForeignAddress" class="form-group" runat="server" meta:resourcekey="Dis_Human_Alt_Foreign_Address" visible="false">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:Label AssociatedControlID="ddlHumanAltidfsCountry" meta:resourcekey="Lbl_Country" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:DropDownList ID="ddlHumanAltidfsCountry" runat="server" CssClass="form-control eidss-dropdown"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Human_Alt_Foreign_Address" runat="server"></div>
                                                            <asp:Label AssociatedControlID="txtHumanAltForeignAddressString" meta:resourcekey="Lbl_Human_Alt_Foreign_Address" runat="server"></asp:Label>
                                                            <asp:TextBox CssClass="form-control" ID="txtHumanAltForeignAddressString" runat="server" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtHumanAltForeignAddressString" CssClass="text-danger" InitialValue="" Display="Dynamic" meta:resourcekey="Val_Human_Alt_Foreign_Address" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <fieldset>
                                                <legend for="hdftxtContactPhone" runat="server" meta:resourcekey="Lbl_Persons_Phone_Number"></legend>
                                                <div class="form-group" meta:resourcekey="Dis_Persons_Phone_Number">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Persons_Country_Code_and_Number" runat="server"></div>
                                                            <label for="txtContactPhone" runat="server" meta:resourcekey="Lbl_Persons_Country_Code_and_Number"></label>
                                                        </div>
                                                        <div class="col-lg-3-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Persons_Phone_Type">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Persons_Phone_Type" runat="server"></div>
                                                            <label for="ddlContactPhoneTypeID" runat="server" meta:resourcekey="Lbl_Persons_Phone_Type"></label>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Persons_Country_Code_and_Number">
                                                            <asp:TextBox ID="txtContactPhone" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtContactPhone" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Persons_Country_Code_and_Number" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtContactPhone" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Phone_Number_Invalid" ValidationGroup="PersonAddress" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Persons_Phone_Type">
                                                            <asp:DropDownList ID="ddlContactPhoneTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator ControlToValidate="ddlContactPhoneTypeID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Persons_Phone_Type" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                            <div class="form-group" meta:resourcekey="Dis_Person_Another_Phone">
                                                <label for="hdftxtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Another_Phone"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbAnotherPhoneYes" runat="server" GroupName="AnotherPhone" CssClass="radio-inline" OnCheckedChanged="AnotherPhone_CheckedChanged" meta:resourceKey="Lbl_Yes" CausesValidation="false" />
                                                        <asp:RadioButton ID="rdbAnotherPhoneNo" runat="server" GroupName="AnotherPhone" CssClass="radio-inline" OnCheckedChanged="AnotherPhone_CheckedChanged" meta:resourceKey="Lbl_No" CausesValidation="false" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel CssClass="form-group" ID="pnlAnotherPhone" runat="server" meta:resourcekey="Dis_Person_Other_Phone">
                                                <label for="txtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Other_Phone"></label>
                                                <div class="row">
                                                    <div class="col-lg-6-md-6 col-sm-6 col-xs-6">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Person_Other_Country_Code_and_Number" runat="server"></div>
                                                        <label for="txtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Country_Code_and_Number"></label>
                                                    </div>
                                                    <div class="col-lg-3-md-3 col-sm-3 col-xs-3">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Person_Other_Phone_Type" runat="server"></div>
                                                        <label for="ddlContactPhone2TypeID" runat="server" meta:resourcekey="Lbl_Persons_Phone_Type"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6-md-6 col-sm-6 col-xs-6">
                                                        <asp:TextBox ID="txtContactPhone2" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtContactPhone2" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Person_Other_Country_Code_and_Number" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>
                                                        <asp:RegularExpressionValidator ControlToValidate="txtContactPhone2" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Phone_Number_Invalid" ValidationGroup="PersonAddress" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                        <asp:DropDownList ID="ddlContactPhone2TypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlContactPhone2TypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Person_Other_Phone_Type" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="PersonEmploymentSchoolInformation" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 class="heading" runat="server" meta:resourcekey="Hdg_Person_Employment_School_Information"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group" meta:resourcekey="Dis_Currently_Employed">
                                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Currently_employed" runat="server"></div>
                                                <label for="lblCurrentlyEmployed" runat="server" meta:resourcekey="Lbl_Currently_Employed"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedYes" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_Yes" />
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedNo" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_No" />
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedUnknown" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_Unknown" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlEmploymentInformation" runat="server" Visible="false">
                                                <div class="form-group" runat="server" meta:resourcekey="Dis_Occupation">
                                                    <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Occupation" runat="server"></div>
                                                    <asp:Label AssociatedControlID="ddlOccupationTypeID" meta:resourcekey="Lbl_Occupation" runat="server"></asp:Label>
                                                    <div class="input-group">
                                                        <eidss:DropDownList ID="ddlOccupationTypeID" runat="server" CssClass="form-control eidss-dropdown"></eidss:DropDownList>
                                                        <asp:LinkButton ID="btnAddOccupation" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                                                    </div>
                                                    <asp:RequiredFieldValidator ControlToValidate="ddlOccupationTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Occupation" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12" meta:resourcekey="Dis_Employer_Name">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Employer_Name" runat="server"></div>
                                                            <label for="txtEmployerName" runat="server" meta:resourcekey="Lbl_Employer_Name"></label>
                                                            <asp:TextBox ID="txtEmployerName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmployerName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Employer_Name" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12" meta:resourcekey="Dis_Date_of_Last_Presence_At_Work">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date_of_Last_Presence_At_Work" runat="server"></div>
                                                            <label for="txtEmployedDateLastPresent" runat="server" meta:resourcekey="Lbl_Date_of_Last_Presence_At_work"></label>
                                                            <eidss:CalendarInput ID="txtEmployedDateLastPresent" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmployedDateLastPresent" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Date_of_Last_Presence_At_Work" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Employers_Phone_Number">
                                                    <label for="hdfstrEmployerPhone" runat="server" meta:resourcekey="Lbl_Employers_Phone_Number"></label>
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12" meta:resourcekey="Dis_Employers_Country_Code_and_Number">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Employers_Country_Code_and_Number" runat="server"></div>
                                                            <label for="txtEmployerPhone" runat="server" meta:resourcekey="Lbl_Employers_Country_Code_and_Number"></label>
                                                            <asp:TextBox ID="txtEmployerPhone" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmployerPhone" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Employers_Country_Code_and_Number" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtEmployerPhone" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Phone_Number_Invalid" ValidationGroup="PersonEmploymentSchoolInformation" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Employer_Address">
                                                    <label runat="server" meta:resourcekey="Lbl_Employer_Address"></label>
                                                    <div class="form-group">
                                                        <div class="form-check">
                                                            <asp:CheckBox ID="chkEmployerForeignAddressIndicator" runat="server" CssClass="form-check-input" />
                                                            <label for="chkEmployerForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <eidss:Location ID="Employer" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" IsDbRequiredCountry="true" ShowMap="false" />
                                                </div>
                                                <div id="divEmployerForeignAddress" class="form-group" runat="server" meta:resourcekey="Dis_Employer_Foreign_Address" visible="false">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:Label AssociatedControlID="ddlEmployeridfsCountry" meta:resourcekey="Lbl_Country" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:DropDownList ID="ddlEmployeridfsCountry" runat="server" CssClass="form-control eidss-dropdown"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Employer_Foreign_Address" runat="server"></div>
                                                            <asp:Label AssociatedControlID="txtEmployerForeignAddressString" meta:resourcekey="Lbl_Employer_Foreign_Address" runat="server"></asp:Label>
                                                            <asp:TextBox CssClass="form-control" ID="txtEmployerForeignAddressString" runat="server" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmployerForeignAddressString" CssClass="text-danger" InitialValue="" Display="Dynamic" meta:resourcekey="Val_Employer_Foreign_Address" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <div class="form-group" meta:resourcekey="Dis_Currently_In_School">
                                                <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Currently_In_School" runat="server"></div>
                                                <label for="hdfCurrentlyInSchool" runat="server" meta:resourcekey="Lbl_Currently_In_School"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolYes" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_Yes" />
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolNo" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_No" />
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolUnknown" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_Unknown" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlSchoolInformation" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12" meta:resourcekey="Dis_Schools_Name">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Schools_Name" runat="server"></div>
                                                            <label for="txtSchoolName" runat="server" meta:resourcekey="Lbl_Schools_Name"></label>
                                                            <asp:TextBox ID="txtSchoolName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtSchoolName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_School_Name" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12" meta:resourcekey="Dis_Date_of_Last_Presence_At_School">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date_of_Last_Presence_At_School" runat="server"></div>
                                                            <label for="txtSchoolDateLastAttended" runat="server" meta:resourcekey="Lbl_Date_of_Last_Presence_At_School"></label>
                                                            <eidss:CalendarInput ID="txtSchoolDateLastAttended" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtSchoolDateLastAttended" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Date_of_Last_Presence_At_School" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="txtSchoolPhone" runat="server" meta:resourcekey="Lbl_Schools_Phone_Number"></label>
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12" meta:resourcekey="Dis_School_Country_Code_and_Number">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_School_Country_Code_and_Number" runat="server"></div>
                                                            <label for="txtSchoolPhone" runat="server" meta:resourcekey="Lbl_School_Country_Code_and_Number"></label>
                                                            <asp:TextBox ID="txtSchoolPhone" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtSchoolPhone" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_School_Country_Code_and_Number" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ControlToValidate="txtSchoolPhone" runat="server" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Phone_Number_Invalid" ValidationGroup="PersonEmploymentSchoolInformation" ValidationExpression="([0-9\s\-]{7,})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_School_Address">
                                                    <label runat="server" meta:resourcekey="Lbl_School_Address"></label>
                                                    <div class="form-group">
                                                        <div class="form-check">
                                                            <asp:CheckBox ID="chkSchoolForeignAddressIndicator" runat="server" CssClass="form-check-input" />
                                                            <label for="chkSchoolForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <eidss:Location ID="School" runat="server" IsHorizontalLayout="true" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" ShowMap="false" IsDbRequiredCountry="true" ShowCountry="false" ValidationGroup="PersonEmploymentSchoolInformation" />
                                                </div>
                                                <div id="divSchoolForeignAddress" class="form-group" runat="server" meta:resourcekey="Dis_School_Foreign_Address" visible="false">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:Label AssociatedControlID="ddlSchoolidfsCountry" meta:resourcekey="Lbl_Country" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <asp:DropDownList ID="ddlSchoolidfsCountry" runat="server" CssClass="form-control eidss-dropdown"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_School_Foreign_Address" runat="server"></div>
                                                            <asp:Label AssociatedControlID="txtSchoolForeignAddressString" meta:resourcekey="Lbl_School_Foreign_Address" runat="server"></asp:Label>
                                                            <asp:TextBox CssClass="form-control" ID="txtSchoolForeignAddressString" runat="server" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtSchoolForeignAddressString" CssClass="text-danger" InitialValue="" Display="Dynamic" meta:resourcekey="Val_School_Foreign_Address" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <div class="col-md-12">
                                    <div id="divSelectablePreviewHumanDiseaseReportList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 id="hdgHumanDiseaseReports" runat="server" meta:resourcekey="Hdg_Disease_Reports"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnAddSelectablePreviewHumanDiseaseReport" runat="server" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvHumanDiseaseReports" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false" CssClass="table table-striped" ShowHeaderWhenEmpty="true" DataKeyNames="HumanDiseaseReportID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" meta:Resourcekey="Grd_Disease_List" ShowFooter="true" GridLines="None" OnRowCommand="HumanDiseaseReports_RowCommand">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Report_ID_Text %>">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnViewSelectablePreview" runat="server" CssClass="btn btn-link" role="link" Text='<%# Eval("EIDSSReportID") %>' CommandName="View" CommandArgument='<%# Eval("HumanDiseaseReportID").ToString() %>' CausesValidation="false" BorderStyle="None"></asp:Button>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="DiseaseName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Clinical_Diagnosis_Text %>" />
                                                        <asp:BoundField DataField="TentativeDiagnosisDate" ReadOnly="true" DataFormatString="{0:d}" HeaderText="<%$ Resources: Labels, Lbl_Date_of_Diagnosis_Text %>" />
                                                        <asp:BoundField DataField="ClassificationTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                                        <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Report_Status_Text %>" />
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divSelectablePreviewOutbreakCaseList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 id="hdgOutbreakCaseReports" runat="server" meta:resourcekey="Hdg_Outbreak_Case_Reports"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnAddSelectablePreviewOutbreakCaseReport" runat="server" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvOutbreakCases" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false" DataKeyNames="idfOutbreak" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" meta:Resourcekey="Grd_Farm_List" CssClass="table table-striped" ShowHeaderWhenEmpty="true" ShowFooter="true" GridLines="None">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Outbreak_Case_ID_Text %>">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnViewSelectablePreview" runat="server" CssClass="btn btn-link" role="link" Text='<%# Eval("strOutbreakCaseID") %>' CommandName="View" CommandArgument='<%# Eval("idfOutbreak").ToString() %>' CausesValidation="false" BorderStyle="None"></asp:Button>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="CaseType" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Outbreak_Type_Text %>" />
                                                        <asp:BoundField DataField="CaseClassification" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Classification_Text %>" />
                                                        <asp:BoundField DataField="CaseFarmStatus" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Case_Status_Text %>" />
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divSelectablePreviewFarmList" class="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                                                    <h3 id="hdgFarms" runat="server" meta:resourcekey="Hdg_Farms"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <asp:GridView ID="gvFarms" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false" DataKeyNames="idfFarmActual" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" meta:Resourcekey="Grd_Farm_List" CssClass="table table-striped" ShowHeaderWhenEmpty="true" ShowFooter="true" GridLines="None">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Farm_ID_Text %>">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnViewSelectablePreview" runat="server" CssClass="btn btn-link" role="link" Text='<%# Eval("strFarmCode") %>' CommandName="View" CommandArgument='<%# Eval("idfFarmActual").ToString() %>' CausesValidation="false" BorderStyle="None"></asp:Button>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="strInternationalName" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Name_Text %>" />
                                                        <asp:BoundField DataField="FormattedFarmAddressString" ReadOnly="true" HeaderText="<%$ Resources: Labels, Lbl_Farm_Address_Text %>" />
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <eidss:SideBarNavigation ID="PersonSideBar" runat="server">
                                <MenuItems>
                                    <eidss:SideBarItem ID="sbiPersonInformation" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsNormal" meta:resourcekey="Tab_Person_Information" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')" />
                                    <eidss:SideBarItem ID="sbiPersonAddress" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsNormal" meta:resourcekey="Tab_Person_Address" GoToSideBarSection="1, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')" />
                                    <eidss:SideBarItem ID="sbiPersonEmploymentSchoolInformation" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsNormal" meta:resourcekey="Tab_Person_Employment_School_Information" GoToSideBarSection="2, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')" />
                                    <eidss:SideBarItem ID="sbiPersonReview" runat="server" CssClass="glyphicon glyphicon-ok" ItemStatus="IsReview" meta:resourcekey="Tab_Person_Review" GoToSideBarSection="3, document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')" />
                                </MenuItems>
                            </eidss:SideBarNavigation>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                            <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')); return false;" UseSubmitBehavior="False" />
                            <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit')); return false;" UseSubmitBehavior="False" />
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divBaseReferenceEditorModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divBaseReferenceEditorModal">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 id="hdgBaseReferenceEditor" class="modal-title">
                        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Base_Reference_Editor_Text %>"></asp:Literal></h4>
                </div>
                <div class="modal-body modal-wrapper">
                    Place holder for base reference editor.  Needs re-factoring to new API.
                </div>
                <div class="modal-footer text-center">
                    <asp:Button ID="btnBaseReferenceCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                    <asp:Button ID="btnBaseReferenceEditorOK" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" ValidationGroup="BaseReferenceEditor" />
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hdfPersonPanelController" runat="server" Value="0" />
    </ContentTemplate>
</asp:UpdatePanel>