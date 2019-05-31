<%@ Page Title="Human Disease Report" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="HumanDiseaseReport.aspx.vb" Inherits="EIDSS.HumanDiseaseReport" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>
<%@ Register Src="~/Controls/AddUpdateOrganizationUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateOrganization" %>
<%@ Register Src="~/Controls/SearchOrganizationUserControl.ascx" TagPrefix="eidss" TagName="SearchOrganization" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPerson" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePerson" %>
<%@ Register Src="~/Controls/SearchEmployeeUserControl.ascx" TagPrefix="eidss" TagName="SearchEmployee" %>
<%@ Register Src="~/Controls/AddUpdateEmployeeUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdateProgress runat="server">
        <ProgressTemplate>
            <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                <div class="modal-content">
                    <div class="modal-body">
                        <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div class="modal container fade" id="modalAddContact" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="modalAddContact">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" runat="server" meta:resourcekey="hdg_Contact_Information"></h5>
                                    </div>
                                    <div class="modal-body">
                                        <asp:UpdatePanel ID="upContactModal" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_First_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_First_Name"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactFirstName"
                                                                meta:resourcekey="Lbl_Contact_Information_First_Name"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactFirstName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_First_Name"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_Middle_Initial"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_Middle_Initial"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactMiddleInit"
                                                                meta:resourcekey="Lbl_Contact_Information_Middle_Initial"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactMiddleInit"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_Middle_Initial"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_Last_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_Last_Name"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactLastName"
                                                                meta:resourcekey="Lbl_Contact_Information_Last_Name"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactLastName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_Last_Name"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Relation"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Relation"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlContactRelation"
                                                        meta:resourcekey="Lbl_Contact_Information_Relation"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList ID="ddlContactRelation" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlContactRelation"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Relation"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div> 
                                        <hr />
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Date_of_Last_Contact"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Date_of_Last_Contact"
                                                        runat="server">
                                                    </div>
                                                    <label for="txtdatLastContactDate" runat="server" meta:resourcekey="Lbl_Contact_Information_Date_of_Last_Contact"></label>
                                                    <eidss:CalendarInput ID="txtdatLastContactDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtdatLastContactDate"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Date_of_Last_Contact"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Place_of_Last_Contact"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Place_of_Last_Contact"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtPlaceofLastContact"
                                                        meta:resourcekey="Lbl_Contact_Information_Place_of_Last_Contact"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox ID="txtPlaceofLastContact" runat="server" CssClass="form-control"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtPlaceofLastContact"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Place_of_Last_Contact"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>   
                                                 <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label for="txtstrComments" runat="server" meta:resourcekey="lbl_Comments"></label>
                                                    <asp:TextBox ID="txtstrComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                                    ControlToValidate="txtstrComments"
                                                                    CssClass="text-danger"
                                                                    Display="Dynamic"
                                                                    meta:resourcekey="Val_Antibiotic_Vaccine_History_Comments"
                                                                    runat="server"
                                                                    ValidationGroup="addContact"></asp:RequiredFieldValidator>     
                                                    </div>                     
                                            </div>
                                            </div>
                                        </div>                                       

                                        </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <div class="modal-footer text-center">
                                         <button id="Button1" class="btn btn-default" runat="server" data-dismiss="modal" meta:resourcekey="btn_Contact_Modal_Save"></button>       
                                        <button id="btnContactCancel" type="button" class="btn btn-default" onclick="javascript:hideSearchPersonModal()" runat="server" meta:resourcekey="btn_Cancel" data-dismiss="modal"></button>
                                    </div>
                                    </div>                                    
                                </div>
                            </div>                      
                        </div>
    <div class="modal" id="deleteHDR" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                         <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Reports"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                <span class="glyphicon glyphicon-alert modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <p runat="server" meta:resourcekey="lbl_Remove_HDR"></p>
                                            </div>  
                                       </div>                          
                                    </div>
                                    <div class="modal-footer text-center">
                                          <button type="submit" id="btnDeleteHDR" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                          <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                                    </div>
                                </div>
                            </div>
                        </div> 
    <div id="divSearchPersonModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchPersonModal">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 id="hdgSearchPerson" class="modal-title">
                                        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Person_Text %>"></asp:Literal></h4>
                                </div>
                                <div class="modal-body modal-wrapper">
                                    <eidss:SearchPerson ID="ucSearchPerson" runat="server" RecordMode="Select" />
                                </div>
                            </div>
                        </div>
    <div id="divSearchOrganizationModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchOrganizationModal">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModalOnModal('#divSearchOrganizationModal')">&times;</button>
                                    <h4 id="hdgSearchOrganization" class="modal-title">
                                        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Organization_Text %>"></asp:Literal></h4>
                                </div>
                                <div class="modal-body modal-wrapper">
                                    <eidss:SearchOrganization ID="ucSearchOrganization" runat="server" RecordMode="Select" />
                                </div>
                            </div>
                    </div>
    <%--<div id="divAddUpdateOrganizationModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divAddUpdateOrganizationModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModalOnModal('#divAddUpdateOrganizationModal')">&times;</button>
                                <h4 id="hdgAddUpdateOrganization" class="modal-title">
                                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Add_Update_Organization_Text %>"></asp:Literal></h4>
                            </div>
                            <div class="modal-body modal-wrapper">
                                <asp:UpdatePanel ID="upAddUpdateOrganization" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <eidss:AddUpdateOrganization ID="ucAddUpdateOrganization" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>--%>
    <div id="divSearchEmployeeModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchEmployeeModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModalOnModal('#divSearchEmployeeModal')">&times;</button>
                                <h4 id="hdgSearchEmployee" class="modal-title">
                                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Employee_Text %>"></asp:Literal></h4>
                            </div>
                            <div class="modal-body modal-wrapper">
                                  <%--<eidss:SearchEmployee ID="ucSearchEmployee" runat="server" RecordMode="Select" />--%>
                            </div>
                        </div>
                     </div>
    <%-- <div id="divAddUpdateEmployeeModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divAddUpdateEmployeeModal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModalOnModal('#divAddUpdateEmployeeModal')">&times;</button>
                                <h4 id="hdgAddUpdateEmployee" class="modal-title">
                                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Add_Update_Employee_Text %>"></asp:Literal></h4>
                            </div>
                            <div class="modal-body modal-wrapper">
                                <asp:UpdatePanel ID="upAddUpdateEmployee" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                       <eidss:AddUpdateEmployee ID="ucAddUpdateEmployee" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>--%>
    <asp:UpdatePanel ID="uppPersonSearch" runat="server">
        <Triggers></Triggers>
        <ContentTemplate>
            <div class="container">
                <div class="row">
                <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h2>
                    <p><%= GetLocalResourceObject("Page_Text_7") %></p>
                </div>
                <div class="panel-body">
                    
                    <div id="divHiddenFieldsSection" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfCaller" Value="DASHBOARD" />
                        <%--     <asp:HiddenField runat="server" ID="hdfLangID" Value="EN" />--%>
                        <asp:HiddenField runat="server" ID="hdfidfHumanActual" Value="null" />
                        <%--  hdfidfHumanActual--%>
                        <asp:HiddenField runat="server" ID="hdfName" />
                        <asp:HiddenField runat="server" ID="hdfstrEIDSSPersonID" Value="(new)" />
                        <asp:HiddenField runat="server" ID="hdfEIDSSPersonID" Value="" />
                        <asp:HiddenField runat="server" ID="hdfCurrentDate" />
                        <asp:HiddenField runat="server" ID="txtdatDateOfDeath" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfblnCurrentlyEmployed" />
                        <asp:HiddenField runat="server" ID="hdfidfsOccupationType" Value="null" />
                        <asp:HiddenField runat="server" ID="dhfIsEmployedID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrEmployerPhone" />
                        <asp:HiddenField runat="server" ID="hdfidfEmployerGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfblnCurrentlyInSchool" />
                        <asp:HiddenField runat="server" ID="hdfIsStudentID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfSchoolPhoneNbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfSchoolGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfAnotherAddress" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanAltGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrPhone" />
                        <asp:HiddenField runat="server" ID="hdfstrAnotherPhone" />
                        <asp:HiddenField runat="server" ID="hdfstrOtherPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrRegistrationPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrHomePhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrWorkPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneCountryCode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneNbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneNbrTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2CountryCode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2Nbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2NbrTypeID" Value="null" />
                        <asp:HiddenField ID="hdfCurrentlyEmployed" runat="server" />

                        <asp:HiddenField ID="hdfIsEmployedTypeID" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfEmployerGeoLocationID" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfCurrentlyInSchool" runat="server" />
                        <asp:HiddenField ID="hdfIsStudentTypeID" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfSchoolGeoLocationID" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfHumanAltGeoLocationID" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfPhone" runat="server" />
                        <asp:HiddenField ID="hdfAnotherPhone" runat="server" />
                        <asp:HiddenField ID="hdfOtherPhone" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfRegistrationPhone" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfHomePhone" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfWorkPhone" runat="server" Value="null" />
                        <asp:HiddenField ID="hdfSearchPatientID" runat="server" Value="null" />
                        <asp:HiddenField ID="HiddenField5" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfEmployeridfsCountry" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfHumanAltidfsCountry" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSchoolidfsCountry" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfAltAddressID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfEmployerForeignAddressIndicator" runat="server" Value="False" />
                        <asp:HiddenField ID="hdfSchoolForeignAddressIndicator" runat="server" Value="False" />
                        <asp:HiddenField ID="hdfHumanAltForeignAddressIndicator" runat="server" Value="False" />

                        <asp:HiddenField runat="server" ID="hdfSuccessPopUpFlag" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanCase" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanCaseCopy" />

                        <asp:HiddenField runat="server" ID="hdfNewNotifiableDiseaseFlag" Value="0"/>
        
                        <%--hdfidfHumanCase--%>
                        <asp:HiddenField runat="server" ID="hdfSearchHumanModalDate" Value=""  />
                        <asp:HiddenField runat="server" ID="hdfAddContactModalStatus" Value = "" />

                        <asp:HiddenField runat="server" ID="hdfstrHumanCaseId" />

                        <asp:HiddenField runat="server" ID="hdfidfHuman" Value="" />
                        <asp:HiddenField runat="server" ID="hdfHumanMasterID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfFirstOrGivenName" Value="" />
                        <asp:HiddenField runat="server" ID="hdfSecondName" Value="" />
                        <asp:HiddenField runat="server" ID="hdfLastOrSurname" Value="" />
                        <asp:HiddenField runat="server" ID="hdfDateOfBirth" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfCitizenshipTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfGenderTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfGenderTypeName" Value="" />
                        <asp:HiddenField runat="server" ID="hdfHumanGeoLocationID" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanRayon" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanRegion" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanSettlement" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanidfsCountry" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanidfsRayon" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanidfsRegion" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfHumanidfsSettlement" Value="null" />
                        <asp:HiddenField runat="server" ID="HiddenField1" Value="null" />                        
		                <asp:HiddenField runat="server" ID="hdfHumanstrApartment" Value="" />
		                <asp:HiddenField runat="server" ID="hdfHumanstrBuilding" Value="" />
                        <asp:HiddenField runat="server" ID="hdfHumanstrHouse" Value="" />
                        <asp:HiddenField runat="server" ID="hdfHumanstrPostalCode" Value="" />
                        <asp:HiddenField runat="server" ID="hdfHumanstrtreetName" Value="" />


                        <asp:HiddenField runat="server" ID="hdfidfsGeoLocationID" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfidfsRayon" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfidfsRegion" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfidfsSettlement" Value="null" />
		                <asp:HiddenField runat="server" ID="hdfidfsCountry" Value="null" />		                            
		                <asp:HiddenField runat="server" ID="hdfstrApartment" Value="" />
		                <asp:HiddenField runat="server" ID="hdftrBuilding" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrHouse" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrPostalCode" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrtreetName" Value="" />

		
                        <asp:HiddenField runat="server" ID="hdfPatientPreviouslySought" />
                        <asp:HiddenField runat="server" ID="hdfidfSougtCareFacility" />
                        <asp:HiddenField runat="server" ID="hdfhospitalization" />
                        <asp:HiddenField runat="server" ID="hdfYNAntimicrobialTherapy" />
                        <asp:HiddenField runat="server" ID="hdfidfsYNSpecificVaccinationAdministered" />
                        <asp:HiddenField runat="server" ID="hdfRelatedToOutbreak" />
                        <asp:HiddenField runat="server" ID="hdfidfsYNExposureLocationKnown" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfExposureAddressType" />
                        <asp:HiddenField runat="server" ID="hdfRiskFactor" />
                        <asp:HiddenField runat="server" ID="hdfstrContactPhone" />
                        <asp:HiddenField runat="server" ID="hdfblnClinicalDiagBasis" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfblnLabDiagBasis" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfblnEpiDiagBasis" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfidfsOutcome" Value="" />
                        <asp:HiddenField runat="server" ID="hdfdatFinalDiagnosisDate" Value="" />
                        <asp:HiddenField runat="server" ID="hdfdatExposureDate" Value="" />
                        <asp:HiddenField runat="server" ID="hdfidfsHumanGender" Value="" />
                        <asp:HiddenField runat="server" ID="hdfdatDateofLastContact" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrPlaceInfo" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrComments" Value="" />
                        <asp:HiddenField runat="server" ID="hdfidfsYNPreviouslySoughtCare" Value="" />       
                        <asp:HiddenField runat="server" ID="hdfidfsYNHospitalization" Value="" />  
                        <asp:HiddenField runat="server" ID="hdfparentHumanDiseaseReportID" Value="" /> 
                        <asp:HiddenField runat="server" ID="hdfrelatedHumanDiseaseReportIdList" Value="" />
                        <asp:HiddenField runat="server" ID="hdfidfsFinalDiagnosisCopy" Value="" />
                        <asp:HiddenField runat="server" ID="hdfstrHospitalizationPlace" Value="" />
                        <asp:HiddenField runat="server" ID="hdfNotificationSentBySelected" Value="0" />
                        <asp:HiddenField runat="server" ID="IsControlsByUsersRolesandPermissionsSet" Value="0" />
                        

                        <%-- Human disease report list search fields --%>
                        <asp:HiddenField runat="server" ID="hdfSearchHumanCaseId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrCaseId" Value="null" />
                        <asp:HiddenField runat="server" ID="rldstrCaseId" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfRegion" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfRayon" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfPointGeoLocation" Value="null" />

                        <asp:HiddenField runat="server" ID="idfSentByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="idfSentByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="SentByOffice" Value="null" />

                        <asp:HiddenField runat="server" ID="idfReceivedByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="idfReceivedByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="ReceivedByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfInvestigatedByOffice" Value="null" />
                        
                        <asp:HiddenField runat="server" ID="hdfidfCSObservation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfEpiObservation" Value="null" />


                        <%-- Hum Disease Report Summary --%>
                        <asp:HiddenField runat="server" ID="hdfSummaryIdfsFinalDiagnosis" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrPersonId" Value="null" /> 
                        <asp:HiddenField runat="server" ID="hdfstrPersonName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfFinalCaseStatus" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfdatEnteredDate" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfdatModificationDate" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfSummaryCaseClassification" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfidfPersonEnteredBy" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEnteredByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfOrganizationFullName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrAccountName" Value="null" />                        

                        <asp:HiddenField runat="server" ID="hdfPageMode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfCallerPage" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfCallerKey" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfidfSentByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfSentByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfReceivedByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfReceivedByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfSoughtCareFacility" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfNextAddSampleInteger" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfModalAddSampleGuid" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfNextAddTestInteger" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfModalAddTestGuid" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfModalAddTestNewIndicator" Value="" />

                        <asp:HiddenField runat="server" ID="hdfSamples" Value="" />
                        <asp:HiddenField runat="server" ID="hdfTests" Value="" />

                        
                         <%-- Organization Admin to HDR Response --%>
                        <asp:HiddenField runat="server" ID="hdfUniqueOrgID" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfOrgName" Value ="NULL" />
                        <asp:HiddenField runat="server" ID="hdfOfficeID" Value="NULL" />
                    </div>
                    <asp:HiddenField runat="server" ID="hdfSessionInformationDisplay" Value="none" />
                    <div id="divHiddenFieldsEAtoHDRInitCache" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfEAidfHuman" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAidfHumanActual" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAHumanCase" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAstrHumanCaseId" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEACallerPage" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAInitiatingCallerPage" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAPageMode" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEACallerKey" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEALastControlFocus" Value="null" />
                    </div>
                    <div id="divHiddenFieldsEAtoHDRResponse" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfEAEmployeeId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAEmployeeFullName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEALastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAInstitutionId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAInstitutionFullName" Value="null" />
                    </div>                  
                   
                    <%-- Removed per bug 1810 - The Person Information section is not in the use case and should be removed.
                    <div id="patientReview" class="row embed-panel" runat="server">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                                        <h3 runat="server" meta:resourcekey="hdg_Person_Information"></h3>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                        <label id="lblPersonID" class="label"></label>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                    </div>
                                </div>
                            </div>

                            <%--Begin: Display Search Criteria at top of detail view - removed per bug 1810
                            <div class="panel-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lbldatEnteredDate.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Date_Created"></label>
                                            <asp:TextBox ID="disdatEnteredDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lbldatModificationDate.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Date_Updated"></label>
                                            <asp:TextBox ID="disdatModificationDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientName.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Name"></label>
                                            <asp:TextBox ID="disPatientName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                    <%-- Begin: Human Disease Report --%>
                            <div id="disease" class="row embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_ID" class="col-md-6">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_ID" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryidfHumanCase" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div id="divDiseaseHumanDetail" runat="server" meta:resourcekey="Dis_Disease_Diagnosis" class="col-md-6" visible="false" >
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Diagnosis" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryDiagnosis" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                         <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Report_Status" class="col-md-6">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Report_Status"></label>
                                                <eidss:DropDownList ID="ddlidfsCaseProgressStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                             <div runat="server" meta:resourcekey="Dis_Disease_Report_EIDSS_ID" class="col-md-6">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_EIDSS_ID"></label>
                                                <asp:TextBox ID="txtSummaryEidsId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                         </div>
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 runat="server" meta:resourcekey="hdg_Disease_Report_Summary"></h3>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                <!-- jquery usage of hyperlink data-toggle and data-parent to show hide the summary section, operates on div: diseasedHumanDetail -->
                                                <%--<a id="diseaseReportSummaryCollapsible"
                                                    data-toggle="collapse"
                                                    data-parent="#diseaseReportSummary"
                                                    href="#diseasedHumanDetail"
                                                    role="button"
                                                    aria-expanded="false"
                                                    aria-controls="diseasedHumanDetail">
                                                    <span class="glyphicon glyphicon-triangle-bottom"></span>
                                                </a>--%>

                                                <asp:LinkButton ID="btnShowDiseaseReportSummary" runat="server" CssClass="btn" meta:resourceKey="btn_Show_Disease_Report_Summary"><span id="diseaseReportSummaryStatus" runat="server" class="glyphicon glyphicon-triangle-bottom header-button"></span></asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="diseasedHumanDetail" runat="server" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                <div class="panel-body">
                                    
                                    <div class="form-group">
                                        <div class="row">
                                            <div id="divDiseaseLegacyCaseID" class="col-md-6" runat="server" meta:resourcekey="Dis_Disease_Eidss_Legacy_ID">
                                                <label runat="server" for="txtLegacyCaseID" meta:resourcekey="Lbl_Eidss_Legacy_ID"></label>
                                                <asp:TextBox ID="txtLegacyCaseID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Type" class="col-md-6">
                                                <label runat="server" meta:resourcekey="lbl_Report_Type"></label>
                                                <eidss:DropDownList ID="ddlDiseaseReportTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div id="RelatedSessionID" runat="server" meta:resourcekey="Dis_Disease_Related_Session_ID" class="col-md-6" visible="False">
                                                <label runat="server" meta:resourcekey="lbl_Related_Session_ID"></label>
                                                <asp:TextBox ID="txtSummaryRelatedSessionID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>                                    
                                    <div class="form-group">
                                        <div class="row">
                                            <div id="divRelatedTo" runat="server" meta:resourcekey="Dis_Disease_Report_Type" class="col-md-6" visible="False">
                                                <label id=lblRelatedTo runat="server" meta:resourcekey="lbl_Related_To" visible="false"></label>                                                 
                                                   <asp:HyperLink ID="hlParentHumanDiseaseReport" runat="server"></asp:HyperLink>
                                                   <div id="divRelatedToChildren" runat="server">   
                                                        <literal id="lrlRelatedToChildren" runat="server"></literal>
                                                   </div>
                                            </div>
                                        </div>
                                    </div>                                    
                                    <div class="form-group">
                                        <div class="row">   
                                             <div runat="server" meta:resourcekey="Dis_Disease_Report_Name" class="col-md-6">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Name"></label>
                                                <asp:TextBox ID="txtSummarystrPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-md-6">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Case_Classification"></label>
                                                <asp:TextBox ID="txtSummaryCaseClassification" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" class="col-md-6">
                                                <label runat="server" meta:resourcekey="lbl_Date_Entered"></label>
                                                <asp:TextBox ID="txtSummaryDateEntered" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" class="col-md-6">
                                                <label runat="server" meta:resourcekey="lbl_Date_Last_Updated"></label>
                                                <asp:TextBox ID="txtSummarydatModificationDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>                                    
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" class="col-md-6">
                                                <label runat="server" meta:resourcekey="lbl_Person_Entered_By" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryEnteredByPerson" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" class="col-md-6">
                                                <label runat="server" meta:resourcekey="lbl_Entered_By_Organization_Full_Name" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryOrganizationFullName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>                                
                            </div>
                                </div>

                            <div class="sectionContainer expanded">
                                <section id="PersonInformation" runat="server" class="col-md-12">
                                    <div id="divPersonInformation" runat="server" class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Person_Information"></h3>
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
                                                        <label for="ddlPersonalIDType" runat="server" meta:resourcekey="Lbl_Personal_ID_Type"></label>
                                                        <eidss:DropDownList ID="ddlPersonalIDType" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>                                                       
                                                    </div>
                                                    <div class="col-md-6" meta:resourcekey="Dis_Personal_ID_Number">
                                                        <label for="txtPersonalID" runat="server" meta:resourcekey="Lbl_Personal_ID"></label>
                                                        <asp:TextBox ID="txtPersonalID" runat="server" CssClass="form-control" MaxLength="100" ></asp:TextBox>                                                       
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Last_Name">
                                                        <div class="glyphicon glyphicon-certificate text-danger" meta:resourcekey="Req_Last_Name" runat="server"></div>
                                                        <label for="txtLastOrSurname" runat="server" meta:resourcekey="Lbl_Last_Name"></label>
                                                        <asp:TextBox ID="txtLastOrSurname" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_Middle_Name">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Middle_Name" runat="server"></div>
                                                        <label for="txtSecondName" runat="server" meta:resourcekey="Lbl_Middle_Name"></label>
                                                        <asp:TextBox ID="txtSecondName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>                                                        
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" meta:resourcekey="Dis_First_Name">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_First_Name" runat="server"></div>
                                                        <label for="txtFirstOrGivenName" runat="server" meta:resourcekey="Lbl_First_Name"></label>
                                                        <asp:TextBox ID="txtFirstOrGivenName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_DOB">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_DOB" runat="server"></div>
                                                        <label for="txtDateOfBirth" runat="server" meta:resourcekey="Lbl_DOB"></label>
                                                        <eidss:CalendarInput ID="txtDateOfBirth" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" onblur="showAge();"></eidss:CalendarInput>                                                        
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
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Gender">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Gender" runat="server"></div>
                                                        <label for="ddlGenderTypeID" runat="server" meta:resourcekey="Lbl_Gender"></label>
                                                        <eidss:DropDownList ID="ddlGenderTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>                                                       
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Citizenship">
                                                        <label for="ddlCitizenshipTypeID" runat="server" meta:resourcekey="Lbl_Citizenship"></label>
                                                        <eidss:DropDownList ID="ddlCitizenshipTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    </div>
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" meta:resourcekey="Dis_Passport_Number">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Passport_Number" runat="server"></div>
                                                        <label for="txtPassportNumber" runat="server" meta:resourcekey="Lbl_Passport_Number"></label>
                                                        <asp:TextBox ID="txtPassportNumber" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>                                                       
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Person_Address_and_Phone"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        </div>
                                        <div id="divPersonInformationAddress" runat="server" class="panel-body">
                                            <eidss:LocationUserControl ID="Human" runat="server" IsHorizontalLayout="true" ValidationGroup="PersonAddress" ShowCountry="false" ShowStreet="true" ShowElevation="false" IsDbRequiredCountry="false" IsDbRequiredRegion="false" IsDbRequiredRayon="false" />
                                            <div class="form-group" meta:resourcekey="Dis_Another_Address">
                                                <label runat="server" meta:resourcekey="Lbl_Another_Address"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbAnotherAddressYes" runat="server" GroupName="AnotherAddress" CssClass="radio-inline" AutoPostBack="true" CausesValidation="false" meta:resourceKey="Lbl_Yes" />
                                                        <asp:RadioButton ID="rdbAnotherAddressNo" runat="server" GroupName="AnotherAddress" CssClass="radio-inline" AutoPostBack="true" CausesValidation="false" meta:resourceKey="Lbl_No" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlAnotherAddress" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="form-check">
                                                        <asp:CheckBox ID="chkHumanAltForeignAddressIndicator" runat="server" CssClass="form-check-input" AutoPostBack="true" />
                                                        <label for="chkHumanAltForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                    </div>
                                                </div>
                                                <eidss:LocationUserControl ID="HumanAlt" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" IsDbRequiredCountry="false" ShowMap="false" />
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
                                                            <asp:Label AssociatedControlID="txtHumanAltForeignAddressString" meta:resourcekey="Lbl_Human_Alt_Foreign_Address" runat="server"></asp:Label>
                                                            <asp:TextBox CssClass="form-control" ID="txtHumanAltForeignAddressString" runat="server" MaxLength="200"></asp:TextBox>                                                           
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <fieldset>
                                            <legend for="hdftxtContactPhone" runat="server" meta:resourcekey="Lbl_Persons_Phone_Number"></legend>
                                            <div class="form-group" meta:resourcekey="Dis_Persons_Phone_Number">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                        <label for="txtContactPhone" runat="server" meta:resourcekey="Lbl_Persons_Country_Code_and_Number"></label>
                                                    </div>
                                                    <div class="col-lg-3-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Persons_Phone_Type">
                                                        <label for="ddlContactPhoneTypeID" runat="server" meta:resourcekey="Lbl_Persons_Phone_Type"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Persons_Country_Code_and_Number">
                                                        <asp:TextBox ID="txtContactPhone" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ControlToValidate="txtContactPhone" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Persons_Country_Code_and_Number" runat="server" ValidationGroup="PersonAddress"></asp:RequiredFieldValidator>                                                        
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" meta:resourcekey="Dis_Persons_Phone_Type">
                                                        <asp:DropDownList ID="ddlContactPhoneTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            </fieldset>
                                            <div class="form-group" meta:resourcekey="Dis_Person_Another_Phone">
                                                <label for="hdftxtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Another_Phone"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbAnotherPhoneYes" runat="server" GroupName="AnotherPhone" CssClass="radio-inline" AutoPostBack="true" meta:resourceKey="Lbl_Yes" />
                                                        <asp:RadioButton ID="rdbAnotherPhoneNo" runat="server" GroupName="AnotherPhone" CssClass="radio-inline" AutoPostBack="true"  meta:resourceKey="Lbl_No" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel CssClass="form-group" ID="pnlAnotherPhone" runat="server" meta:resourcekey="Dis_Person_Other_Phone">
                                                <label for="txtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Other_Phone"></label>
                                                <div class="row">
                                                    <div class="col-lg-6-md-6 col-sm-6 col-xs-6">
                                                        <label for="txtContactPhone2" runat="server" meta:resourcekey="Lbl_Person_Country_Code_and_Number"></label>
                                                    </div>
                                                    <div class="col-lg-3-md-3 col-sm-3 col-xs-3">
                                                        <label for="ddlContactPhone2TypeID" runat="server" meta:resourcekey="Lbl_Persons_Phone_Type"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6-md-6 col-sm-6 col-xs-6">
                                                        <asp:TextBox ID="txtContactPhone2" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>                                                        
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                        <asp:DropDownList ID="ddlContactPhone2TypeID" runat="server" CssClass="form-control"></asp:DropDownList>                                                        
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 class="heading" runat="server" meta:resourcekey="Hdg_Person_Employment_School_Information"></h3>
                                                </div>                                                
                                            </div>
                                        </div>
                                        <div id="divPersonInformationEmploymentSchool" runat="server" class="panel-body">
                                            <div class="form-group" meta:resourcekey="Dis_Currently_Employed">
                                                <label for="lblCurrentlyEmployed" runat="server" meta:resourcekey="Lbl_Currently_Employed"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedYes" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_Yes" AutoPostBack="true" />
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedNo" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_No" AutoPostBack="true" />
                                                        <asp:RadioButton ID="rdbCurrentlyEmployedUnknown" runat="server" GroupName="CurrentlyEmployed" CssClass="radio-inline" meta:resourceKey="lbl_Unknown" AutoPostBack="true" />
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
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12" meta:resourcekey="Dis_Employer_Name">
                                                            <label for="txtEmployerName" runat="server" meta:resourcekey="Lbl_Employer_Name"></label>
                                                            <asp:TextBox ID="txtEmployerName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ControlToValidate="txtEmployerName" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Employer_Name" runat="server" ValidationGroup="PersonEmploymentSchoolInformation"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12" meta:resourcekey="Dis_Date_of_Last_Presence_At_Work">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Date_of_Last_Presence_At_Work" runat="server"></div>
                                                            <label for="txtEmployedDateLastPresent" runat="server" meta:resourcekey="Lbl_Date_of_Last_Presence_At_work"></label>
                                                            <eidss:CalendarInput ID="txtEmployedDateLastPresent" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>                                                           
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
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_Employer_Address">
                                                    <label runat="server" meta:resourcekey="Lbl_Employer_Address"></label>
                                                    <div class="form-group">
                                                        <div class="form-check">
                                                            <asp:CheckBox ID="chkEmployerForeignAddressIndicator" runat="server" CssClass="form-check-input" AutoPostBack="true" />
                                                            <label for="chkEmployerForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <eidss:LocationUserControl ID="Employer" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" IsDbRequiredCountry="true" ShowMap="false" />
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
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <div class="form-group" meta:resourcekey="Dis_Currently_In_School">
                                                <label for="hdfCurrentlyInSchool" runat="server" meta:resourcekey="Lbl_Currently_In_School"></label>
                                                <div class="input-group">
                                                    <div class="btn-group">
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolYes" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_Yes" AutoPostBack="true" />
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolNo" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_No" AutoPostBack="true" />
                                                        <asp:RadioButton ID="rdbCurrentlyInSchoolUnknown" runat="server" GroupName="InSchool" CssClass="radio-inline" meta:resourceKey="Lbl_Unknown" AutoPostBack="true" />
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlSchoolInformation" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12" meta:resourcekey="Dis_Schools_Name">
                                                            <label for="txtSchoolName" runat="server" meta:resourcekey="Lbl_Schools_Name"></label>
                                                            <asp:TextBox ID="txtSchoolName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>                                                           
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12" meta:resourcekey="Dis_Date_of_Last_Presence_At_School">
                                                            <label for="txtSchoolDateLastAttended" runat="server" meta:resourcekey="Lbl_Date_of_Last_Presence_At_School"></label>
                                                            <eidss:CalendarInput ID="txtSchoolDateLastAttended" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="txtSchoolPhone" runat="server" meta:resourcekey="Lbl_Schools_Phone_Number"></label>
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12" meta:resourcekey="Dis_School_Country_Code_and_Number">
                                                            <label for="txtSchoolPhone" runat="server" meta:resourcekey="Lbl_School_Country_Code_and_Number"></label>
                                                            <asp:TextBox ID="txtSchoolPhone" runat="server" CssClass="form-control" MaxLength="15"></asp:TextBox>                                                           
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" meta:resourcekey="Dis_School_Address">
                                                    <label runat="server" meta:resourcekey="Lbl_School_Address"></label>
                                                    <div class="form-group">
                                                        <div class="form-check">
                                                            <asp:CheckBox ID="chkSchoolForeignAddressIndicator" runat="server" CssClass="form-check-input" AutoPostBack="true" />
                                                            <label for="chkSchoolForeignAddressIndicator"><% =GetGlobalResourceObject("Labels", "Lbl_Foreign_Address_Text") %></label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <eidss:LocationUserControl ID="School" runat="server" IsHorizontalLayout="true" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" ShowMap="false" IsDbRequiredCountry="true" ShowCountry="false" ValidationGroup="PersonEmploymentSchoolInformation" />
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
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>                            
                                <section id="diseaseNotification" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Disease_Notification_Sub_Title"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)" runat="server" meta:resourcekey="lbl_Disease_Notification_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                                        <%= GetLocalResourceObject("Page_Text_1") %>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Diagnosis"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Diagnosis"
                                                            runat="server">
                                                        </div>
                                                        <label
                                                            meta:resourcekey="Lbl_Disease_Diagnosis"
                                                            runat="server">
                                                        </label>
                                                        <eidss:DropDownList runat="server" ID="ddlidfsFinalDiagnosis" CssClass="form-control" OnSelectedIndexChanged="ddlidfsFinalDiagnosis_SelectedIndexChanged" AutoPostBack="True" />
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalDiagnosis"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Diagnosis"
                                                            runat="server"
                                                            InitialValue="null"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                        meta:resourcekey="Dis_Date_of_Diagnosis"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Diagnosis"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Diagnosis"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatDateOfDiagnosis" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Diagnosis"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                            <asp:CustomValidator
                                                           ID="CustomValidatorNotFutureDiagDate"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Disease_Notification_Not_Future_Diagnostic_Date %>"
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateNotFutureDate"
                                                            ClientValidationFunction="ValidateNotFutureDateClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                         <asp:CustomValidator
                                                            ID="CustomValidator3DateOrderDiagDate"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Disease_Notification_Diagnostic_Date_Prior_Or_Same_Notification_Date %>"
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="Validate3DateOrder"
                                                            ClientValidationFunction="Validate3DateOrderClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div>                                          
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                        meta:resourcekey="Dis_Date_of_Notification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Notification"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Notification"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatNotificationDate"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Notification"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                          <asp:CustomValidator
                                                            ID="CustomValidatorDateOfNotification"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Disease_Notification_Prior_Or_Same_Diagnosis_Date %>"
                                                            ControlToValidate="txtdatNotificationDate"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateDateOfNotification"
                                                            ClientValidationFunction="ValidateDateOfNotificationClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div>   
                                                            
                                                    </div>
                                                </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Status_of_Patient"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Status_of_Patient"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Status_of_Patient"></label>
                                                        <eidss:DropDownList ID="ddlidfsFinalState" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalState"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Status_of_Patient"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Notification_Sent_by"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Sent_by"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Notification_Sent_by"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtstrNotificationSentby" Visible ="false" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <eidss:DropDownList ID="ddlNotificationSentBy" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlNotificationSentBy"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Sent_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                            ID="CustomValidatorSentByReqIfDiagIsSyndromic"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Disease_Notification_Syndromic Surveillance_Sent_By %>"
                                                            ControlToValidate="ddlNotificationSentBy"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateSentByReqIfDiagIsSyndromic"
                                                            ClientValidationFunction="ValidateSentByReqIfDiagIsSyndromicClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            ValidateEmptyText="True"
                                                            EnableClientScript="True"></asp:CustomValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Status_of_Patient"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Sent_by"
                                                            runat="server">
                                                        </div>
                                                       <label runat="server" meta:resourcekey="lbl_Notification_Sent_by_Name"></label>
                                                        <eidss:DropDownList ID="ddlNotificationSentByName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlNotificationSentbyName"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Sent_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator> 
                                                        <asp:CustomValidator
                                                            ID="CustomValidatorSentByNameReqIfDiagIsSyndromic"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Disease_Notification_Syndromic Surveillance_Sent_By %>"
                                                            ControlToValidate="ddlNotificationSentByName"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateSentByNameReqIfDiagIsSyndromic"
                                                            ClientValidationFunction="ValidateSentByNameReqIfDiagIsSyndromicClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            ValidateEmptyText="True"
                                                            EnableClientScript="True"></asp:CustomValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Notification_Received_by"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Received_by"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Notification_Received_by"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtstrNotificationReceivedby" visible="false" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                         <eidss:DropDownList ID="ddlNotificationReceivedBy" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlNotificationReceivedBy"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Received_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                    </div>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Status_of_Patient"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Sent_by"
                                                            runat="server">
                                                        </div>
                                                       <label runat="server" meta:resourcekey="lbl_Notification_Received_by_Name"></label>
                                                        <eidss:DropDownList ID="ddlNotificationReceivedByName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlNotificationReceivedByName"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Received_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                    </div>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Persons_Current_Location"
                                                        runat="server">
                                                        <label for="ddlidfsHospitalizationStatus" runat="server" meta:resourcekey="lbl_Persons_Current_Location"></label>
                                                        <eidss:DropDownList ID="ddlidfsHospitalizationStatus" runat="server" CssClass="form-control hStatus" autopostback="true" onchange="checkCurrentLocation();" />
                                                    </div>
                                                    <div id="hospital" runat="server" class="currentLocation hStatusHospital">
                                                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Hospital_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Hospital_Name" runat="server"></div>
                                                            <label for="ddlidfHospital" runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                            <eidss:DropDownList ID="ddlidfHospital" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlidfHospital"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                InitialValue="null"
                                                                meta:resourcekey="Val_Hospital_Name"
                                                                runat="server"
                                                                ValidationGroup="diseaseNotification">
                                                            </asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div id="otherLocation" runat="server" class="currentLocation hStatusOtherLocation">
                                                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Other_Location"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Other_Location"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtstrCurrentLocation" runat="server" meta:resourcekey="lbl_Other_Location"></label>
                                                            <asp:TextBox ID="txtstrCurrentLocation" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrCurrentLocation"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Other_Location"
                                                                runat="server"
                                                                ValidationGroup="diseaseNotification">
                                                            </asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>                           
                                    </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="symptoms" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Clinical_Information_Symptoms"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)" runat="server" meta:resourcekey="lbl_Clinical_Information_Symptoms_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Symptom_Onset"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Symptom_Onset"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Symptom_Onset"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatOnSetDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatOnSetDate"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Symptom_Onset"
                                                            runat="server"
                                                            ValidationGroup="symptoms"></asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                            ID="CustomValidateDateOfSymptoms"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Symptom_On_Set_Date %>"
                                                            ControlToValidate="txtdatOnSetDate"
                                                            ValidationGroup="symptoms"
                                                            OnServerValidate="ValidateDateOfSymptoms"
                                                            ClientValidationFunction="ValidateDateOfSymptomsClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div> 
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                    meta:resourcekey="Dis_Initial_Case_Classification"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Initial_Case_Classification"
                                                        runat="server">
                                                    </div>
                                                    <label runat="server" meta:resourcekey="lbl_Initial_Case_Classification"></label>
                                                    <eidss:DropDownList ID="ddlidfsInitialCaseStatus" autopostback="true" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfsInitialCaseStatus"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Initial_Case_Classification"
                                                        runat="server"
                                                        ValidationGroup="symptoms"></asp:RequiredFieldValidator>
                                               </div>
                                             </div>
                                            </div>
                                            <div class="form-group">

                                                <label for="hdfSymptoms" runat="server" meta:resourcekey="lbl_List_of_Symptoms"></label>
                                                <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="FlexFormSymptoms" 
                                                                            LegendHeader="Human Case : Symptoms" 
                                                                            FormType="10034010"/>



<%--                                                <label for="gvSymptoms" runat="server" meta:resourcekey="lbl_List_of_Symptoms"></label>
                                                <eidss:GridView
                                                    ID="gvSymptoms"
                                                    runat="server"
                                                    AllowPaging="true"
                                                    AllowSorting="true"
                                                    AutoGenerateColumns="false"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    EmptyDataText="No data available."
                                                    ShowHeaderWhenEmpty="true"
                                                    ShowFooter="true"
                                                    GridLines="None">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:BoundField DataField="idfSymptomName" ReadOnly="true" SortExpression="idfSymptomName" HeaderText="<%$ Resources:Grd_Symptoms_Column_Heading_idfSymptomName %>" />
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgYes"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_Yes"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgYes" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgNo"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_No"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgNo" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgUnknown"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_Unknown"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgUnknown" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>--%>
                                            </div>                                                       
                                    </div>
                                    </div>
                                </section>
                                <section id="facilityDetails" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Clinical_Information_Facility_Details"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(2)" runat="server" meta:resourcekey="lbl_Clinical_Information_Facility_Details_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="PatientPreviouslySoughtDiv" class="form-group">
                                                <div class="row">
                                                    <div id="PatientPreviouslySoughtRBPanel" class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Patient_Previously_Sought">
                                                        <label for="" runat="server" meta:resourcekey="lbl_Patient_Previously_Sought"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNPreviouslySoughtCare" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rdbPatientPreviouslySought_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlPatientPreviouslySought" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_First_Sought_Care"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_First_Sought_Care"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatFirstSoughtCareDate" runat="server" meta:resourcekey="lbl_Date_First_Sought_Care"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatFirstSoughtCareDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatFirstSoughtCareDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_First_Sought_Care"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                             <asp:CustomValidator
                                                                ID="CustomValidator_txtdatFirstSoughtCareDate"
                                                                runat="server"
                                                                Text="<%$ resources:Val_Facility_First_Sought_Care_Date %>"
                                                                ControlToValidate="txtdatFirstSoughtCareDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDoc"
                                                                ClientValidationFunction="ValidateDocClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                        <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Facility_First_Sought_Care"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Facility_First_Sought_Care"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtFacilityFirstSoughtCare" runat="server" meta:resourcekey="lbl_Facility_First_Sought_Care"></label>
                                                            <div class="input-group">
                                                                <asp:TextBox ID="txtFacilityFirstSoughtCare" Visible="false" runat="server" CssClass="form-control"></asp:TextBox>                                                                
                                                            </div>
                                                            <asp:DropDownList ID="ddlFacilityFirstSoughtCare" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlFacilityFirstSoughtCare"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Facility_First_Sought_Care"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                            meta:resourcekey="Dis_NonNotifiable_Diagnosis"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_NonNotifiable_Diagnosis"
                                                                runat="server">
                                                            </div>
                                                            <label for="ddlidfsNonNotifiableDiagnosis" runat="server" meta:resourcekey="lbl_NonNotifiable_Diagnosis"></label>
                                                            <eidss:DropDownList ID="ddlidfsNonNotifiableDiagnosis" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlidfsNonNotifiableDiagnosis"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                InitialValue="null"
                                                                meta:resourcekey="Val_NonNotifiable_Diagnosis"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                            </asp:Panel>                                            
                                            <div id="divYNHospitalization" runat="server" class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Hospitalization">
                                                        <label runat="server" meta:resourcekey="lbl_Hospitalization"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNHospitalization" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rblidfsYNHospitalization_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlHospitalization" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_of_Hospitalization"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Hospitalization"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatHospitalizationDate" runat="server" meta:resourcekey="lbl_Date_of_Hospitalization"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker"
                                                                ID="txtdatHospitalizationDate"
                                                                runat="server"
                                                                CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatHospitalizationDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Hospitalization"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>

                                                            <asp:CustomValidator
                                                                ID="CustomValidator_txtdatHospitalizationDate"
                                                                runat="server"
                                                                Text="<%$ resources:Val_Hospitalization_Date %>"
                                                                ControlToValidate="txtdatHospitalizationDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDoh"
                                                                ClientValidationFunction="ValidateDohClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_of_Discharge"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Discharge"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatDischargeDate" runat="server" meta:resourcekey="lbl_Date_of_Discharge"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatDischargeDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatDischargeDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Discharge"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                            <asp:CustomValidator
                                                                ID="CustomValidator_txtdatDischargeDate"
                                                                runat="server"
                                                                Text="<%$ resources:Val_Hospitalization_Discharge_Date_Date %>"
                                                                ControlToValidate="txtdatDischargeDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDod"
                                                                ClientValidationFunction="ValidateDodClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                            meta:resourcekey="Dis_Facility_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Facility_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="ddlidfFaciltyHospital" runat="server" meta:resourcekey="lbl_Facility_Name"></label>
                                                            <eidss:DropDownList ID="ddlidfFaciltyHospital" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlidfFaciltyHospital"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                InitialValue="null"
                                                                meta:resourcekey="Val_Facility_Name"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails">
                                                            </asp:RequiredFieldValidator>
                                                        </div>                                                            
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="antibioticVaccineHistory" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Clinical_Information_Antibiotics"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(3)" runat="server" meta:resourcekey="lbl_Clinical_Information_Antibiotics_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Antibiotic_Antiviral_Therapy_Administered">
                                                        <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Therapy_Administered"></label>
                                                        <div class="input-group">
                                                            <%--                                                            <div class="btn-group">
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredYes" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredNo" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredUnknown" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_Unknown" />
                                                            </div>--%>

                                                            <div class="btn-group">
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredYes" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredNo" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredUnknown" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_Unknown" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlAntiBioticAdministred" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                         <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Antibiotic_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Antibiotic_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="<%= txtstrAntibioticName.ClientID %>" runat="server" meta:resourcekey="lbl_Antibiotic_Name"></label>
                                                            <asp:TextBox ID="txtstrAntibioticName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrAntibioticName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Antibiotic_Name"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Dose"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Dose"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtstrDosage" runat="server" meta:resourcekey="lbl_Dose"></label>
                                                            <asp:TextBox ID="txtstrDosage" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrDosage"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Dose"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>                                                      
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_Antibiotic_First_Administered"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_Antibiotic_First_Administered"
                                                                runat="server">
                                                            </div>
                                                            <label for="txdatFirstAdministeredDate" runat="server" meta:resourcekey="lbl_Date_Antibiotic_First_Administered"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txdatFirstAdministeredDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txdatFirstAdministeredDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_Antibiotic_First_Administered"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                             <asp:CustomValidator
                                                                ID="CustomValidator_FirstAdministeredDate"
                                                                runat="server"
                                                                Text="<%$ resources:Val_AntibioticVaccineHistory_First_Administered_Date %>"
                                                                ControlToValidate="txdatFirstAdministeredDate"
                                                                ValidationGroup="antibioticVaccineHistory"
                                                                OnServerValidate="ValidateFAD"
                                                                ClientValidationFunction="ValidateFADClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>                                                   
                                                </div>
                                                <div class="row">&nbsp;</div>       
                                                <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
                                                            <asp:Button ID="btnAddAntiviralTherapy" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: btn_Add_New.ToolTip %>" Text="<%$ Resources: btn_Add_New.Text %>" />     
                                                            <asp:Button ID="btnAntiviralTherapySave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn__Save" Visible="false"/>
 
                                                 </div> 
                                                <div class="row">&nbsp;</div>       
                                                <div class="form-group">
                                                    <div class="table-responsive">
                                                        <eidss:GridView ID="gvAntiviralTherapies" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfAntimicrobialTherapy, idfHumanCase, strAntimicrobialTherapyName, strDosage, datFirstAdministeredDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" onrowediting="gvAntiviralTherapies_RowCommand" GridLines="None" >
                                                            <HeaderStyle CssClass="table-striped-header" />
                                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                            <Columns>                                                               
                                                                <asp:BoundField DataField="strAntimicrobialTherapyName" HeaderText="<%$ Resources: lbl_Antibiotic_Name %>" />
                                                                <asp:BoundField DataField="strDosage" HeaderText="<%$ Resources: lbl_Dose %>" />
                                                                <asp:BoundField DataField="datFirstAdministeredDate" HeaderText="<%$ Resources: lbl_Date_Antibiotic_First_Administered %>" DataFormatString="{0:d}" />
                                                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="AntiviralTherapy" runat="server" CommandName="Edit" CommandArgument='<% #Bind("idfAntimicrobialTherapy") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="btnAntiviralTherapy" runat="server" CommandName="Delete" CommandArgument='<% #Bind("idfAntimicrobialTherapy") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </eidss:GridView>
                                                    </div> 
                                                <hr />
                                                <div class="form-group"
                                                    meta:resourcekey="Dis_Antibiotic_Vaccine_History_Comments"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Antibiotic_Vaccine_History_Comments"
                                                        runat="server">
                                                    </div>
                                                    <label for="txtstrAntibioticComments" runat="server" meta:resourcekey="lbl_Antibiotic_Vaccine_History_Comments"></label>
                                                    <asp:TextBox ID="txtstrClinicalNotes" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrClinicalNotes"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Antibiotic_Vaccine_History_Comments"
                                                        runat="server"
                                                        ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <h3 runat="server" meta:resourcekey="hdg_Clinical_Information_Vaccines"></h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Specific_Vaccination">
                                                        <label runat="server" meta:resourcekey="lbl_Specific_Vaccination"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <%--  <asp:RadioButton ID="rdbSpecificVaccinationYes" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationNo" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationUnknown" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_Unknown" />--%>


                                                                <asp:RadioButton ID="rdbSpecificVaccinationYes" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationNo" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationUnknown" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_Unknown" />


                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlSpecialVaccination" runat="server" Visible="false">                                                  
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Vaccination_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Vaccination_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtVaccinationName" runat="server" meta:resourcekey="lbl_Vaccination_Name"></label>
                                                            <asp:TextBox ID="txtVaccinationName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtVaccinationName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Vaccination_Name"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_of_Vaccination"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Vaccination"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtVaccinationDate" runat="server" meta:resourcekey="lbl_Date_of_Vaccination"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtVaccinationDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtVaccinationDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Vaccination"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>                                                       
                                                    </div>
                                                </div>  
                                                 <div class="row">&nbsp;</div>
                                                         <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
                                                            <asp:Button ID="btnAddVaccination" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: btn_Add_New.ToolTip %>" Text="<%$ Resources: btn_Add_New.Text %>" />                                                            
                                                            <asp:Button ID="btnVaccinationSave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn__Save" visible="false"/>  
                                                         </div> 
                                                <div class="row">&nbsp;</div>       
                                                <div class="form-group">
                                                <div class="table-responsive">
                                                    <eidss:GridView ID="gvVaccinations" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="HumanDiseaseReportVaccinationUID, idfHumanCase, VaccinationName, VaccinationDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" onrowediting="gvVaccinations_RowCommand" GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                        <Columns>
                                                            <asp:BoundField DataField="vaccinationName" HeaderText="<%$ Resources: lbl_Vaccination_Name %>" />
                                                            <asp:BoundField DataField="vaccinationDate" HeaderText="<%$ Resources: lbl_Date_of_Vaccination %>" DataFormatString="{0:d}" />                                                                            
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditVaccination" runat="server" CommandName="Edit" CommandArgument='<% #Bind("humanDiseaseReportVaccinationUID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDeleteVaccination" runat="server" CommandName="Delete" CommandArgument='<% #Bind("humanDiseaseReportVaccinationUID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="samplesTab" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="hdg_Samples"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnSampleNewAdd" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Sample" OnClick="btnAddNewSampleClick" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(4)" runat="server" meta:resourcekey="lbl_Samples_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_idfsYNSpecimenCollected">
                                                        <label for="rblidfsYNSpecimenCollected" runat="server" meta:resourcekey="lbl_idfsYNSpecimenCollected"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNSpecimenCollected" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rblidfsYNSpecimenCollected_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <asp:Panel ID="samplesGridPanel" class="row embed-panel" runat="server" Visible="true">
                                                    <div class="panel-body">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvSamples"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, strBarcode, idfsSampleType, datFieldCollectionDate, strFieldBarcode, datFieldSentDate, idfSendToOffice, strSendToOffice, idfFieldCollectedByOffice, sampleGuid"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Date_Collected.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="datFieldSentDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_Date.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strSendToOffice" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_To.InnerText %>" />
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="testsTab" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="hdg_Tests_Tab"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnHdrAddNewTest" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Test" OnClick="btnAddNewTestClick" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(5)" runat="server" meta:resourcekey="lbl_Tests_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <asp:Panel ID="gvTestsPanel" class="row embed-panel" runat="server">
                                                    <div class="panel-body">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvTests"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid, strFieldBarCode, strSampleTypeName, idfsInterpretedStatus, strValidatedBy, strInterpretedBy"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" /> 
                                                               
                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestResult" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strInterpretedStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_InterpretedStatus_RulesInOut.InnerText %>" />
                                                                    <asp:BoundField DataField="blnValidateStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Validated.InnerText %>" />                                                                     
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="caseDetails" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Case_Investigation_Details"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(5)" runat="server" meta:resourcekey="lbl_Case_Details_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Investigator_Name_Organization"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Investigator_Name_Organization" runat="server"></div>
                                                        <label for="" runat="server" meta:resourcekey="lbl_Investigator_Name_Organization"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtInvestigationNameOrganization" visible="false" runat="server" CssClass="form-control"></asp:TextBox>  
                                                            <asp:DropDownList ID="ddlnvestigationNameOrganization" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlnvestigationNameOrganization"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Investigator_Name_Organization"
                                                                runat="server"
                                                                ValidationGroup="caseDetails"></asp:RequiredFieldValidator>
                                                        </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Start_Date_of_Investigation"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Start_Date_of_Investigation"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtStartDateofInvestigation" runat="server" meta:resourcekey="lbl_Start_Date_of_Investigation"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtStartDateofInvestigation" runat="server" CssClass="input-group datepicker"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtStartDateofInvestigation"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Start_Date_of_Investigation"
                                                            runat="server"
                                                            ValidationGroup="caseDetails"></asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                                ID="CustomValidator_txtStartDateofInvestigation"
                                                                runat="server"
                                                                Text="<%$ resources:Val_Case_Investigation_Start_Date_of_Investigation %>"
                                                                ControlToValidate="txtStartDateofInvestigation"
                                                                ValidationGroup="caseDetails"
                                                                OnServerValidate="ValidateDoi"
                                                                ClientValidationFunction="ValidateDoiClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"
                                                                Autopostback="true"></asp:CustomValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    
                                                    <asp:Panel ID="pnlOutbreakID" CssClass="col-lg-4 col-md-6 col-sm-6 col-xs-12"
                                                        runat="server" Visible="true">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Outbreak_ID"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtCaseInvestigationOutbreakID" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtstrOutbreakID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtstrOutbreakID"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Outbreak_ID"
                                                            runat="server"
                                                            ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                            <hr />
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        runat="server"
                                                        meta:resourcekey="Dis_Location_of_Exposure_Known">
                                                        <label for=""
                                                            runat="server"
                                                            meta:resourcekey="lbl_Location_of_Exposure_Known">
                                                        </label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <%--                                                                <asp:RadioButton ID="rdbLocationofExposureKnownYes" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" AutoPostBack="true" OnCheckedChanged="rdbLocationofExposureKnown_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbLocationofExposureKnownNo" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" AutoPostBack="true" OnCheckedChanged="rdbLocationofExposureKnown_CheckChanged" meta:resourcekey="lbl_No" />--%>

                                                                <asp:RadioButton ID="rdbLocationofExposureKnownYes" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbLocationofExposureKnownNo" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbLocationofExposureUnKnown" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_Unknown" />  

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlLocationofExposureKnown" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_of_Potential_Exposure"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Potential_Exposure"
                                                                runat="server">
                                                            </div>
                                                            <label for="" runat="server" meta:resourcekey="lbl_Date_of_Potential_Exposure"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofPotentialExposure" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtDateofPotentialExposure"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Potential_Exposure"
                                                                runat="server"
                                                                ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12"
                                                            runat="server"
                                                            meta:resourcekey="Dis_Exposure_Address_Type">
                                                            <label for="<%=  hdfExposureAddressType.ClientID %>"
                                                                runat="server"
                                                                meta:resourcekey="lbl_Exposure_Address_Type">
                                                            </label>
                                                            <div class="input-group">
                                                                <asp:RadioButton ID="rdbExposureAddressTypeExact" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Exact" />
                                                                <asp:RadioButton ID="rdbExposureAddressTypeRelative" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Relative" />
                                                                <asp:RadioButton ID="rdbExposureAddressTypeForeign" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Foreign" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>                                               
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Exposure_Location_Description"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Exposure_Location_Description"
                                                                runat="server">
                                                            </div>
                                                            <label for="" runat="server" meta:resourcekey="lbl_Exposure_Location_Description"></label>
                                                            <asp:TextBox ID="txtExposureLocationDescription" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtExposureLocationDescription"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Exposure_Location_Description"
                                                                runat="server"
                                                                ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>                                                
                                                 <div class="form-group">
                                                    <div id="lucExposure_country_required" class="glyphicon glyphicon-certificate text-danger" runat="server" visible="false"></div>
                                                    <eidss:LocationUserControl
                                                        ID="lucExposure"
                                                        IsHorizontalLayout="true"
                                                        runat="server"
                                                        ShowCountry="True"
                                                        ShowElevation="false" 
                                                        ShowPostalCode="false" ShowBuildingHouseApartmentGroup="false" ShowApartment="false" ShowBuilding="false" ShowHouse="false" ShowMap="false"/>

                                                </div>
                                                 <div id="foreignAddressType" class="form-group" runat="server" meta:resourcekey="dis_Foreign_Address_Type" visible="false">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Foreign_Address_Type" runat="server"></div>
                                                        <label runat="server" id="lbl_Address" meta:resourcekey="lbl_Address"></label>
                                                        <asp:TextBox ID="txtForeignAddressType" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtForeignAddressType" Display="Dynamic" meta:resourceKey="val_Foreign_Address_Type"></asp:RequiredFieldValidator>
                                                 </div>
                                                 <div id="relativeAddressType" runat="server" meta:resourcekey="dis_Ground_Type" visible="false">
                                                    <div class="form-group">
                                                        <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">                                                                   
                                                                    <label runat="server" meta:resourcekey="lbl_Groud_Type"></label>
                                                                    <asp:DropDownList ID="ddlGroundType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        <div class="row">
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Distance">
                                                                <label runat="server" meta:resourcekey="lbl_Distance"></label>
                                                                <eidss:NumericSpinner ID="txtDistance" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Direction">
                                                                <label runat="server" meta:resourcekey="lbl_Direction"></label>
                                                                <eidss:NumericSpinner ID="txtDirection" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </div>
                                                        </div>
                                                    </div>
                                                 </div>
                                                       
                                            </asp:Panel>
                                        </div>
                                    </div>
                                    </div>
                                </section>
                                <section id="riskFactors" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Case_Investigation_Risk_Factors"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(6)" runat="server" meta:resourcekey="lbl_Risk_Factors_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <label for="hdfRiskFactor" runat="server" meta:resourcekey="lbl_List_of_Risks"></label>
                                                <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="HumanDiseaseFlexFormRiskFactors" 
                                                                            LegendHeader="Human Case Classification Form" 
                                                                            FormType="10034011"/>

<%--                                                <asp:GridView ID="gvRisk" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false">
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                        <label runat="server" meta:resourcekey="lbl_Symptom"></label>
                                                                    </div>
                                                                </div>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                    <asp:Label ID="lblSymptom" runat="server"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                        <label runat="server" meta:resourcekey="lbl_YesNoUnknown"></label>
                                                                    </div>
                                                                </div>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <!-- display check boxes -->
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:CheckBoxList runat="server" ID="cblRisks">
                                                                    <asp:ListItem Value="ck1" />
                                                                    <asp:ListItem Value="ck2" />
                                                                    <asp:ListItem Value="ck3" />
                                                                </asp:CheckBoxList>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>--%>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="contactList" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="hdg_Case_Investigation_Contact_List"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnAddContact" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_Contact" OnClick="btnOpenPageFindPerson_Click" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(7)" runat="server" meta:resourcekey="lbl_Contact_List_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                    <%--<input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" data-toggle="modal" data-target="#modalAddContact" />--%>
                                                    <%--  <asp:Button ID="btnAddContact" CssClass="btn btn-primary"  runat="server" meta:resourceKey="btn_Add_Contact" data-toggle="modal" data-target="#modalAddContact" />--%>
                                                    <%--    <input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact"  />--%>
                                                    <%--                                                    <button type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" onclick="addContact();"></button>--%>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Panel ID="PanelContactsGrid" class="row embed-panel" runat="server">

                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <asp:GridView
                                                        ID="gvContacts"
                                                        runat="server"
                                                        AllowPaging="true"
                                                        AllowSorting="true"
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped"
                                                        EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                        ShowHeaderWhenEmpty="true"
                                                        DataKeyNames="idfHumanCase, strFirstName, strSecondName, strLastName, idfsPersonContactType, datDateOfBirth, idfsHumanGender, idfCitizenship, datDateOfLastContact, strPlaceInfo, idfsCountry, idfsRegion, idfsRayon, idfsSettlement, strStreetName, strBuilding, strHouse, strApartment, strPostCode, strContactPersonFullName, strContactPhone, idfContactPhoneType,idfHumanActual, idfContactedCasePerson, rowguid, strComments"
                                                        ShowFooter="true"
                                                        GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />

                                                        <Columns>
                                                            <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                            <asp:BoundField DataField="strContactPersonFullName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" />
                                                            <asp:BoundField DataField="strPersonContactType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Contact_Type %>" />
                                                            <asp:BoundField DataField="datDateOfLastContact" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Date_Of_Last_Contact %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="strPlaceInfo" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Place_Info %>" />
                                                            <asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" />
                                                            <%--<asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" DataFormatString="{0:d}" />--%>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </section>
                                <section id="finalOutcome" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="hdg_Case_Investigation_Final_Outcome"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(8)" runat="server" meta:resourcekey="lbl_Final_Outcome_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Final_Case_Classification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Final_Case_Classification"
                                                            runat="server">
                                                        </div>
                                                        <label for="ddlidfsFinalCaseStatus" runat="server" meta:resourcekey="lbl_Final_Case_Classification"></label>
                                                        <eidss:DropDownList ID="ddlidfsFinalCaseStatus" autopostback="true" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalCaseStatus"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Final_Case_Classification"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Classification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Classification"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtDateofClassification" runat="server" meta:resourcekey="lbl_Date_of_Classification"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofClassification" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtDateofClassification"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Classification"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <asp:CustomValidator
                                                            ID="CustomValidatorDateOfClassification"
                                                            runat="server"
                                                            Text="<%$ resources:Val_Final_Outcome_Date_Of_Classification %>"
                                                            ControlToValidate="txtDateofClassification"
                                                            ValidationGroup="finalOutcome"
                                                            OnServerValidate="ValidatorDateOfClassification"
                                                            ClientValidationFunction="ValidatorDateOfClassificationClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div>   
                                                </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Outcome"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Outcome"
                                                            runat="server">
                                                        </div>
                                                        <label for="ddlOutcome" runat="server" meta:resourcekey="lbl_Outcome" ></label>                                                       

                                                        <eidss:DropDownList ID="ddlOutcome" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlOutcome_SelectedIndexChanged">
                                                            <asp:ListItem Value="null" Text=""></asp:ListItem>
                                                            <asp:ListItem Value="10760000000" Text="Recovered"></asp:ListItem>
                                                            <asp:ListItem Value="10770000000" Text="Died"></asp:ListItem>
                                                            <asp:ListItem Value="10780000000" Text="Unknown"></asp:ListItem>
                                                        </eidss:DropDownList>

                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlOutcome"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Outcome"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlOutcomeDateofDeath" runat="server" CssClass="form-group" Visible="false">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Death"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Death"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtDateofDeath" runat="server" meta:resourcekey="lbl_Date_of_Death"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofDeath" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtDateofDeath"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Death"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>                                                    
                                                </div>
                                            </asp:Panel>
                                         <hr />
                                         <div class="form-group">
                                         <div class="row">
                                             <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                <label for="txtstrSummaryNotes" runat="server" meta:resourcekey="lbl_Comments"></label>
                                                <asp:TextBox ID="txtstrSummaryNotes" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrSummaryNotes"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Antibiotic_Vaccine_History_Comments"
                                                        runat="server"
                                                        ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>     
                                              </div>                                             
                                        </div> 
                                         </div>    
                                         <hr />
                                         <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Notification_Sent_by"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Sent_by"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Epidemiologist_Name"></label>
                                                        <div class="input-group">                                                           
                                                            <asp:TextBox ID="txtstrEpidemiologistName" runat="server" visible="false" CssClass="form-control"></asp:TextBox>
                                                            <eidss:DropDownList ID="ddlstrEpidemiologistName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        </div>                                                        
                                                    </div>
                                                </div>
                                        </div>
                                         <div class="form-group">
	                                            <fieldset>		                                                 
                                                <legend for="cblBasisofDiagnosis" runat="server" meta:resourcekey="lbl_Basis_of_Diagnosis" ></legend> 
		                                        <div class="checkbox checkbox-fieldset">
			                                        <asp:CheckBoxList ID="cblBasisofDiagnosis" runat="server" RepeatDirection="Vertical" RepeatLayout="Flow">
                                                            <asp:ListItem Value="clinical" Text="Clinical"></asp:ListItem>
                                                            <asp:ListItem Value="epidemiologicalLinks" Text="Epidemiological Links"></asp:ListItem>
                                                            <asp:ListItem Value="laboratoryTests" Text="Laboratory Tests"></asp:ListItem>
                                                        </asp:CheckBoxList>  
		                                        </div>
	                                            </fieldset>
                                            </div>
                                         </div>
                                     </div> 
                                </section>
                            </div>

                            <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                <MenuItems>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="0" ID="sidebaritem_PersonInformation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Person_Information" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="1" ID="sidebaritem_notification" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Notification" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="2" ID="sidebaritem_symptoms" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Symptoms" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="3" ID="sidebaritem_FacilityDetails" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Facility_Details" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="4" ID="sidebaritemAnti_Vaccine_History" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Antibiotic_Vaccine_History" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="5" ID="sidebaritem_Samples" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Samples" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="6" ID="sidebaritem_Tests" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Tests" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="7" ID="sidebaritem_CaseDetails" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Investigation" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="8" ID="sidebaritem_RiskFactors" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Risk_Factors" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="9" ID="sidebaritem_ContactList" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Contact_List" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="10" ID="sidebaritem_FinalOutcome" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Final_Outcome" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="11" ID="sidebaritem_Review" IsActive="true" ItemStatus="IsReview" meta:resourcekey="tab_Review" runat="server" />
                                </MenuItems>
                            </eidss:SideBarNavigation>
                            </div>
                                <div class="modal-footer text-center">
                                    <asp:Button ID="btn_Return_to_Person_Record" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btn_Return_to_Person_Record_Click" />
                                    <asp:Button ID="btnReturnToSearch" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btnReturnToSearch_Click" />
                                    <asp:Button ID="btnReturnToDiseaseSearchResultsList" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btnReturnToDiseaseSearchResultsList_Click" />
                                    <asp:Button ID="btnReturnToReportSearch" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btnReturnToReportSearch_Click" />
                                    <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                    <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                    <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Submit_Disease" OnClick="btn_Submit_Disease_Report_Click" />
                                    <asp:Button ID="btnDiseaseReportDelete" runat="server" Text="Delete" Visible="false" CssClass="btn btn-default" meta:resourcekey="btn_Disease_Report_Delete" /> 
                                </div>
                    <%-- End: Human Disease Report --%>
                        <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                        <asp:HiddenField runat="server" ID="hdfIsDiagnosisSyndromic" Value="0" />                      
                    </div>
                </div>
                        <div class="modal" id="errorVSS" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h3 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h3>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <p id="lblErr" runat="server"></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal" id="successVSS" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                         <h3 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h3>
                                    </div>
                                    <div class="modal-body">                                         
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-ok-sign modal-icon"></span></div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                               <p id="lblSuccessSave" runat="server"></p>
                                            </div>
                                        </div>                                    
                                        <div ID="divNewNotifiableDisease" runat="server" class="row" visible="false">
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"></div>
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                    <p id="lblNewNotifiableDisease" runat="server"></p>
                                                </div>
                                                 <div id="div1" class="modal-footer text-center" runat="server">
                                                    <button id="btnNewNotifiableDiseaseYes" runat="server" meta:resourcekey="Btn_Yes" class="btn btn-primary" data-dismiss="modal"></button>
                                                    <button ID="btnNewNotifiableDiseaseNo" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="Btn_No" ></button>
                                                </div>
                                        </div>
                                    </div>
                                    <div id="divDiseaseSave" class="modal-footer text-center" visible ="false" runat="server">
                                        <button id="btnRtD" runat="server" meta:resourcekey="Hpl_Return_to_Dashboard" class="btn btn-primary" data-dismiss="modal"></button>
                                        <button ID="btnSuccessSave" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="Btn_Return_To_Disease_Report_Record" ></button>
                                    </div>
                                    <div id="divDiseaseCancel" class="modal-footer text-center" Visible="false" runat="server">
                                        <button ID="btndDiseaseReportCancel" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="Btn_Yes" ></button>
                                        <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                                    </div>
                                </div>
                            </div>
                        </div> 
                        <div class="modal" id="diseaseReportCancelModal" runat="server" role="dialog">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                             <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                    <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                                </div>
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                   <p id="lblCancel" runat="server"></p>
                                                </div>
                                            </div>
                                        </div>                                     
                                    </div>
                                </div>
                            </div> 
                       
                        <%--Modals--%>
                        <div class="modal" id="modalAddSample" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="modalAddFieldTestLabel">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" id="H1" runat="server" meta:resourcekey="hdg_Sample_Detail_Modal"></h5>
                                    </div>
                                    <div id="ModalAddSampleForm" runat="server" class="modal-body">

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnFilterSampleTestNameByDisease" runat="server" meta:resourcekey="lbl_Test_Filter_Test_Name_By_Disease" checked="true" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" visible="false">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Lab_Sample_ID"></label>
                                                    <asp:TextBox ID="mastxtSampleId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    <%--<asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlAddFieldTestFieldSampleID_SelectedIndexChanged"></asp:DropDownList>--%>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Sample_Type"></label>
                                                    <eidss:DropDownList runat="server" ID="masddlSampleType" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Date_Collected"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="masAddSampleDateCollected" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Local_Sample_ID"></label>
                                                    <asp:TextBox ID="masAddSampleLocalSampleId" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                   
                                                    <label runat="server" meta:resourcekey="lbl_Sample_by_Institution"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtstrCollectedByInstitution" runat="server" CssClass="form-control" visible="false" Enabled="false"></asp:TextBox>
                                                            <asp:DropDownList ID="ddlstrCollectedByInstitution" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>                                                   
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                   <label runat="server" meta:resourcekey="lbl_Sample_by"></label>
                                                        <div class="input-group">                                                            
                                                            <asp:TextBox ID="txtstrCollectedByOfficer" runat="server" CssClass="form-control" Visible="false" Enabled="false"></asp:TextBox>
                                                            <asp:DropDownList ID="ddlstrCollectedByOfficer" runat="server" CssClass="form-control" ></asp:DropDownList>
                                                        </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Date_Sent"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="masAddSampleDateSent" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Sent_To"></label>
                                                    <%--<asp:TextBox ID="masAddSampleSentTo" runat="server" CssClass="form-control"></asp:TextBox>--%>
                                                    <%--ddlTestedByInstitution--%>

                                                    <eidss:DropDownList ID="ddlmasAddSampleSentTo" runat="server" AutoPostBack="true" CssClass="form-control"></eidss:DropDownList>

                                                </div>
                                            </div>
                                        </div>
                                   <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label runat="server" meta:resourcekey="lbl_Accession_Date"></label>
                                            <div class="input-group dates">
                                                <eidss:CalendarInput ID="txtAddSampleAccessionDate" runat="server" ContainerCssClass="input-group datepicker" Enabled="False" CssClass="form-control"></eidss:CalendarInput>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label runat="server" meta:resourcekey="lbl_Sample_Condition_Received"></label>
                                            <asp:TextBox ID="txtstrCondition" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                   </div>
                                  </div>
                                    <div class="modal-footer">
                                        <button id="btnMasAddSampleClose" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Modal_Add_Sample_Close"></button>
                                        <asp:Button ID="btnMasAddSampleSave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Sample_Save" />
                                        <asp:Button ID="btnMasAddSampleDelete" runat="server" Text="Delete" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Sample_Delete" />
                                    </div>
                                </div>
                            </div>
                        </div>                       
                        <div class="modal" id="modalAddFieldTest" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="modalAddFieldTestLabel">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" id="modalAddFieldTestLabel" runat="server" meta:resourcekey="hdg_Field_Test"></h5>
                                    </div>
                                    <div id="addFieldTestForm" runat="server" class="modal-body">   
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnFilterTestNameByDisease" runat="server" meta:resourcekey="lbl_Test_Filter_Test_Name_By_Disease" checked="true" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Local_Sample_ID"></label>
                                                    <eidss:DropDownList ID="ddlmatLocalSampleId" runat="server" CssClass="form-control">
                                                    </eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Diagnosis"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestDiagnosis" runat="server" AutoPostBack="true" CssClass="form-control"></eidss:DropDownList>
                                                </div>                                                                                       
                                            </div>
                                        </div>
                                         <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                                     <asp:TextBox runat="server" ID="txtidfsSampleType" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Lab_Sample_ID"></label>
                                                     <asp:TextBox ID="txtstrBarCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>     
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Category"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestCategory" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" visible="false">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Status" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestStatus" runat="server" AutoPostBack="true" CssClass="form-control" visible="false"></eidss:DropDownList>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Status" ></label>
                                                     <asp:TextBox ID="txtstrSampleTestStatus" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>     
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                 <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Result"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestResult" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Result_Date"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="txtAddFieldTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group" visible="false">
                                            <div class="row" visible="false">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Tested_by_Institution" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlAddFieldTestTestedByInstitution" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Tested_by" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlAddFieldTestTestedBy" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Result_Received_Date"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="datAddFieldTestResultReceived" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_InterpretedStatus_RulesInOut"></label>
                                                    <eidss:DropDownList ID="ddlidfsInterpretedStatus" runat="server" CssClass="form-control">
                                                         <asp:ListItem Text=""></asp:ListItem>
                                                         <asp:ListItem Value=10104001 Text="Rule In"></asp:ListItem>
                                                         <asp:ListItem value=10104002 Text="Rule Out"></asp:ListItem>
                                                    </eidss:DropDownList>                                                    
                                                </div>    
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Interpreted_RulesInOutComments"></label>
                                                    <asp:TextBox ID="txtstrInterpretedComment" runat="server" CssClass="form-control" ></asp:TextBox>
                                                </div>           
                                            </div>
                                        </div>                                  
                                   <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Date_Interpreted"></label>
                                                    <eidss:CalendarInput ID="txtdatInterpretedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Interpreted_By"></label>
                                                    <asp:TextBox ID="txtstrInterpretedBy" runat="server" CssClass="form-control" enable="false" ></asp:TextBox>
                                                </div>   
                                            </div>
                                    </div>
                                   <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnValidateStatus" runat="server" meta:resourcekey="lbl_Test_Validated" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_ValidatedComments"></label>
                                                    <asp:TextBox ID="txtstrValidateComment" runat="server" CssClass="form-control"  ></asp:TextBox>
                                                </div>   
                                            </div>
                                     </div>                                    
                                    <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Date_Validated"></label>
                                                    <eidss:CalendarInput ID="txtdatValidationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Validated_By"></label>
                                                    <asp:TextBox ID="txtstrValidatedBy" runat="server" CssClass="form-control" enable="false"></asp:TextBox>
                                                </div>   
                                            </div>   
                                   </div>
                                    <div class="modal-footer">
                                        <button id="btnModalAddTestClose" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Modal_Add_Test_Close"></button>
                                        <asp:Button ID="btnModalAddTestSave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Test_Save" />
                                        <asp:Button ID="btnModalAddTestDelete" runat="server" Text="Delete" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Test_Delete" />
                                    </div>
                                </div>
                            </div>
                        </div>                       
               </div>            
                        <%--<div id="divPersonModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divPersonModal">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 id="hdgAddUpdatePerson" class="modal-title">
                                        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Add_Update_Person_Text %>"></asp:Literal></h4>
                                </div>
                                <div class="modal-body modal-wrapper">
                                    <eidss:AddUpdatePerson ID="ucAddUpdatePerson" runat="server" />
                                </div>
                            </div>
                        </div>--%>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                               var diseasedHumanDetailSection = document.getElementById("<%= diseasedHumanDetail.ClientID %>");
                                 if (diseasedHumanDetailSection != null || diseasedHumanDetailSection != undefined) {
                                    setViewOnPageLoad("<%= hdnPanelController.ClientID %>");
                                }
                                $('.modal').modal({ show: false, backdrop: 'static' });
                                $('#<%= errorVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= successVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= diseaseReportCancelModal.ClientID %>').modal({ show: false, backdrop: 'static' });  
                                $('#<%= deleteHDR.ClientID %>').modal({ show: false, backdrop: 'static' });

                                //displayDiseaseSuccessPopUp();
                                checkCurrentLocation();
                                $(".samplesDetailRow").hide();

                                //rodney want to drag the modals around the page:
                                $("#modalAddFieldTest").draggable({
                                    handle: ".modal-header"
                                });

                                sidePanels();
                                //modalize();

                                //Get Url Querystring parameter for preview mode
                                let searchParams = new URLSearchParams(window.location.search);
                                var userAction = searchParams.get('action')    
                                if (userAction === "preview") {
                                    displayPageAsPreview();
                                }

                                userAction = searchParams.get('relatedToID')    
                                if (userAction.length > 1) {
                                    displayPageAsPreview();
                                }
    
                            });

                            function callBackHandler() {
                                var diseasedHumanDetailSection = document.getElementById("<%= diseasedHumanDetail.ClientID %>");
                                 if (diseasedHumanDetailSection != null || diseasedHumanDetailSection != undefined) {
                                    setViewOnPageLoad("<%= hdnPanelController.ClientID %>");
                                }
                                $('#<%= deleteHDR.ClientID %>').modal({ show: false, backdrop: 'static' });
                                checkCurrentLocation();
                                //displayDiseaseSuccessPopUp();
                                $(".samplesDetailRow").hide();

                                //(document.getElementById('#Radios1')).diabled = true;
                                $('#<%= errorVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= successVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= diseaseReportCancelModal.ClientID %>').modal({ show: false, backdrop: 'static' })                                

                                sidePanels();
                                //modalize();
                                
                                var sidePanelId = document.getElementById("<%= hdnPanelController.ClientID %>");
                                //alert (sidePanelId.value)
                                if (sidePanelId.value === "11") {
                                    displayPageAsPreview();
                                }

                            };

                            function checkCurrentLocation() {
                                var el = $(".hStatus");
                                if (el[0].value === "5360000000")  //other location
                                {
                                    //show other location
                                    $(".hStatusHospital").hide();
                                    $(".hStatusOtherLocation").show();
                                }
                                else if (el[0].value === "5350000000") {   //hospital
                                    //show hospital
                                    $(".hStatusHospital").show();
                                    $(".hStatusOtherLocation").hide();
                                }
                                else {
                                    //set both invisible: home was chosen 
                                    $(".hStatusHospital").hide();
                                    $(".hStatusOtherLocation").hide();
                                }
                            };

                            function modalize() {
                             $('.modal').modal({ show: false, backdrop: 'static', keyboard: false });
                            }

                            function sidePanels(){
                                var sessionInformation = document.getElementById("<% = disease.ClientID %>");

                                if (sessionInformation != undefined) {
                                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                                    $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click( function(){ headerTitle(); }); 
                                    $('.sidepanel ul li').click( function(){ headerTitle(); });
                                }
                            }


                            function ValidateNotFutureDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                 
                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };

                            function ValidateNotFutureNotificationDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };

                            function ValidateNotFutureSymptomOnsetDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };
                             
                            function Validate3DateOrderClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                var d3 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;

                              <%--   if (IsDate(d1) && IsDate(d2) && (!(IsDate(d3)))) {
                                    isValidOrder = new Date(d1) <= new Date(d2);
                                }
                                else if (!IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = new Date(d2) <= new Date(d3);
                                }
                                else if (IsDate(d1) && !IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = new Date(d1) <= new Date(d3);
                                }
                                else if (IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= new Date(d3));
                                }--%>

                                if (IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = new Date(d2) <= new Date(d3);
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };
                            
                             function ValidateDateOfNotificationClient(sender, args) {
                                var isValidOrder = true;  //'if none of the two set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;
                                 var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidOrder = new Date(d1) <= Date.now();
                                }
                                                             
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) >= new Date(d2)  && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };

                            function ValidatorDateOfClassificationClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtDateofClassification.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtAddFieldTestResultDate.ClientID %>")).value;
                                var d3 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;

                                if(IsDate(d1)) {
                                    isValidOrder = (new Date(d1) <= Date.now());
                                }
                                                             
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) >= new Date(d2) && new Date(d1) <= Date.now());
                                }

                                if (IsDate(d1) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) >= new Date(d3) && new Date(d1) <= Date.now());
                                }

                                if (!IsDate(d2) && IsDate(d1) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) >= new Date(d3) && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };                                                        

                            function ValidateDateOfSymptomsClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;

                                 if (IsDate(d1)) {
                                    isValidOrder = new Date(d1) <= Date.now();
                                }
                                
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)  && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };                                                            

                            function IsDate(str) {
                                return ((str.length > 0) && (Object.prototype.toString.call(new Date(str)) === "[object Date]"));
                            };

                            function ValidateSentByReqIfDiagIsSyndromicClient(sender, args) {
                                var isValidOrder = true;  
                                var d1 = (document.getElementById("<%= ddlidfsFinalDiagnosis.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= ddlNotificationSentBy.ClientID %>")).value;

                                if ((d1 = 10019001) || (d1 = 10019002)) {
                                     isValidOrder = (d2 != null);
                                }
                                
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };
                            function ValidateSentByNameReqIfDiagIsSyndromicClient(sender, args) {
                                var isValidOrder = true;  
                                var d1 = (document.getElementById("<%= ddlidfsFinalDiagnosis.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= ddlNotificationSentByName.ClientID %>")).value;

                               if ((d1 = 10019001) || (d1 = 10019002)) {
                                    isValidOrder = (d2 != null);
                                }
                                
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 1;
                            };
                            function ValidateDocClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatFirstSoughtCareDate.ClientID %>")).value;
                                var d3 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;

                                if (IsDate(d2)) {
                                    isValidOrder = (new Date(d2) <= Date.now());
                                }

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }

                                if (IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= new Date(d3)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 3;
                            };

                             function ValidateDoiClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtStartDateofInvestigation.ClientID %>")).value;
                               
                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d2) >= new Date(d1)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 7;
                            };

                            function ValidateDohClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatHospitalizationDate.ClientID %>")).value;

                                //if (IsDate(d1) && !IsDate(d2)) {
                                //    isValidOrder = true;
                                //}
                                //else if (!IsDate(d1) && IsDate(d2)) {
                                //    isValidOrder = new Date(d2) <= Date.now();
                               // }
                                if (IsDate(d2)) {
                                    isValidOrder = (new Date(d2) <= Date.now());
                                }

                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 3;
                            };

                            function ValidateDodClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatHospitalizationDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDischargeDate.ClientID %>")).value;

                                if (IsDate(d2)) {
                                    isValidOrder = (new Date(d2) <= Date.now());
                                }

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 3;
                            };

                            function ValidateFADClient(sender, args) {
                                var isValidOrder = true;  //'if none are set to dates, return "isValid = true" condition
                               
                                var d1 = (document.getElementById("<%= txdatFirstAdministeredDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;                                                      

                                if (IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= Date.now());
                                }

                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) >= new Date(d2));
                                }

                                if (isValidOrder) {
                                    document.getElementById('<%= btnAddAntiviralTherapy.ClientID %>').disabled = false;
                                }
                                else {
                                   document.getElementById('<%= btnAddAntiviralTherapy.ClientID %>').disabled = true;
                                }

                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 4;
                            };

                            function showSamplesSubGrid(e, f) {
                                var cl = e.target.className;
                                if (cl == 'glyphicon glyphicon-plus-sign') {
                                    e.target.className = "glyphicon glyphicon-minus-sign";
                                    $('#' + f).show();
                                }
                                else {
                                    e.target.className = "glyphicon glyphicon-plus-sign";
                                    $('#' + f).hide();
                                }
                            };

                            function openModalSampleTab() {
                                $('#modalAddSample').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };

                            function openModalTestTab() {
                                $('#modalAddFieldTest').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 6;
                            };

                            function continueWithModalTestTab() {
                                $('#modalAddFieldTest').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                $('#modalAddFieldTest').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 6;
                            };

                            function continueWithModalSampleTab() {
                                $('#modalAddSample').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                $('#modalAddSample').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };


                            //show modal for modalAddContact
                            function openModalContactEdit() {
                                $('#modalAddContact').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 9;
                            };

                            function continueWithModalContactsTab() {
                                $('#modalAddContact').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 9;
                            };
                            
                            function closeModalContactEdit() {
                                $('#modalAddContact').modal('hide');    
                                 $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 9;
                            };

                            function closeModalAddSample() {
                                $('#modalAddSample').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };

                            function closeModalAddTest() {
                                $('#modalAddTest').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 6;
                            };

                            function showSearchPersonModal() {
                                $('#divSearchPersonModal').modal({ show: true});
                            };

                            //$(#divSearchPersonModal).on('hidden.bs.modal', function() {
                            //  return false;
                            //});

                             function hideSearchPersonModal() {
                                 $('#divSearchPersonModal').modal('hide');
                                 //$('body').removeClass('modal-open');
                                 //$('.modal-backdrop').remove();
                              };                                                     

                            // $(#divPersonModal).on('hidden.bs.modal', function() {
                            //  return false;
                            //});

                            //function hideAddUpdatePersonModal() {
                            //    $('#divPersonModal').modal('hide');
                            //};

                            //function hideSearchPersonModalShowAddUpdatePersonModal() {

                            //    $('#divSearchPersonModal').modal('hide');

                            //    $('#divPersonModal').modal({ show: true });
                            //};

                            function showSearchOrganizationModal() {
                                $('#divSearchOrganizationModal').modal({ show: true });
                             };


                             function hideSearchOrganizationModal() {
                                 $('#divSearchOrganizationModal').modal('hide');
                                 //$('body').removeClass('modal-open');
                                 //$('.modal-backdrop').remove();
                              };

                             function showModalOnModal(div) {
                                        setActiveTabItem();
                                        $(div).modal({ show: true });
                            }


                              function showSearchEmployee() {
                                $('#divSearchEmployeeModal').modal({ show: true });
                             };


                             function hideSearchEmployeeModal() {
                                 $('#divSearchEmployeeModal').modal('hide');
                                 //$('body').removeClass('modal-open');
                                 //$('.modal-backdrop').remove();
                              };

                            function showReviewPanel() {                   
                                displayPageAsPreview();    
                              };

                            function useHideModalOrModalOnModal(divToCheck, div) {
                                if ($(divToCheck + '.modal.in').length > 0)
                                    hideModalOnModal(div);
                                else
                                    hideModal(div);
                            }
                            

                            function hideModal(div) {
                                setActiveTabItem()
                                $(div).modal('hide');

                                if ($('.modal.in').length == 0) {
                                    $('body').removeClass('modal-open');
                                    $('.modal-backdrop').remove();
                                }
                            };

                            function hideModalOnModal(div) {
                                setActiveTabItem();
                                $(div).modal('hide');
                            }

                            <%-- function continueModalAddTest() {
                            $('#modalAddTest').modal('hide');
                            $('body').removeClass('modal-open');
                            $('.modal-backdrop').remove();
                            (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;    
                             };--%>
                        </script>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
