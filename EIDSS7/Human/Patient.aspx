<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Patient.aspx.vb" Inherits="EIDSS.Patient" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="uc1" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../Includes/CSS/bootstrap-datetimepicker.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="row" id="search">
        <div class="page-heading">
            <h2>Person Record Search</h2>
        </div>
        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div id="searchForm" class="personSearch">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="heading">Search by Person Information</h3>
                    </div>
                    <div class="panel-body">
                        <p>Use the following fields to search for existing person. Please fill in all known fields.</p>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-4">
                                    <asp:Label ID="lblEIDSSIDNumber" runat="server" AssociatedControlID="txtEIDSSIDNumber" Text="EIDSS ID Number"></asp:Label>
                                    <asp:TextBox ID="txtEIDSSIDNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-2 text-center">
                                    <label></label>
                                    <label class="form-control">-OR-</label>
                                </div>
                                <div class="col-md-3">
                                    <asp:Label ID="lblPersonalIDType" runat="server" AssociatedControlID="ddlPersonalIDType" Text="Personal ID Type"></asp:Label>
                                    <asp:DropDownList ID="ddlPersonalIDType" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <asp:Label ID="lblPersonalID" runat="server" AssociatedControlID="txtPersonalID" Text="Personal ID"></asp:Label>
                                    <asp:TextBox ID="txtPersonalID" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblName" runat="server" AssociatedControlID="hdfName" Text="Name"></asp:Label>
                            <div class="row">
                                <div class="col-md-4">
                                    <asp:Label ID="lblFirstName" runat="server" AssociatedControlID="txtFirstName" Text="First Name"></asp:Label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-2">
                                    <asp:Label ID="lblMiddleInit" runat="server" AssociatedControlID="txtMiddleInit" Text="Middle Init"></asp:Label>
                                    <asp:TextBox ID="txtMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <asp:Label ID="lblLastName" runat="server" AssociatedControlID="txtLastName" Text="Last Name"></asp:Label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-2">
                                    <asp:Label ID="lblSuffix" runat="server" AssociatedControlID="txtSuffix" Text="Suffix"></asp:Label>
                                    <asp:TextBox ID="txtSuffix" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfName" runat="server" />
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-3 col-md-3 col-sm-5 col-xs-5">
                                    <asp:Label ID="lblDoB" runat="server" AssociatedControlID="txtBirthdate" Text="Date of Birth"></asp:Label>
                                    <div class="input-group datetimepicker">
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                        <asp:TextBox ID="txtBirthdate" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-3 col-md-3 col-sm-5 col-xs-5">
                                    <asp:Label ID="lblGender" runat="server" AssociatedControlID="ddlGender" Text="Gender"></asp:Label>
                                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-3 col-md-3 col-sm-5 col-xs-5">
                                    <asp:Label ID="lblCitizenship" runat="server" AssociatedControlID="ddlCitizenship" Text="Citizenship"></asp:Label>
                                    <asp:DropDownList ID="ddlCitizenship" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row text-center">
                    <input type="button" class="btn btn-primary" value="Search" onclick="searchPerson();" />
                    <input type="button" class="btn btn-default" value="Clear" onclick="clearSearch();" />
                    <a href="../Dashboard.aspx" class="btn btn-default">Return to Dashboard</a>
                </div>
            </div>
            <div id="searchResults" class="personSearch">
                <p>Please select a person below to view and edit record.</p>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                <h3 class="heading">Search Parameters</h3>
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                <a href="#" class="btn btn-default" onclick="editSearch();">Edit</a>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label id="lblSearchCritIDType" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">ID Type</label>
                                <label id="lblSearchCritIDValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                            <div class="form-group">
                                <label id="lblSearchCritPersonalID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Personal ID</label>
                                <label id="lblSearchCritPersonalIDValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                                <label id="lblSearchCritLastEIDSSID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">EIDSS ID</label>
                                <label id="lblSearchCritEIDSSIDValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                            <div class="form-group">
                                <label id="lblSearchCritFirstName" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">First Name</label>
                                <label id="lblSearchCritFirstNameValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                                <label id="lblSearchCritMiddleInit" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Middle Init</label>
                                <label id="lblSearchCritMiddleInitValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                            <div class="form-group">
                                <label id="lblSearchCritLastName" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Last Name</label>
                                <label id="lblSearchCritLastNameValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                                <label id="lblSearchCritSuffix" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Suffix</label>
                                <label id="lblSearchCritSuffixValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                            <div class="form-group">
                                <label id="lblSearchCritDoB" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">DOB</label>
                                <label id="lblSearchCritDoBValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                            <div class="form-group">
                                <label id="lblSearchCritGender" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Gender</label>
                                <label id="lblSearchCritGenderValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                                <label id="lblSearchCritCitizenship" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label">Citizenship</label>
                                <label id="lblSearchCritCitizenshipValue" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="heading">Search Results</h3>
                    </div>
                    <div class="panel-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-condensed" style="border-collapse: collapse;">
                                <thead>
                                    <tr class="table-striped-header">
                                        <td></td>
                                        <td>
                                            <label>First Name</label>
                                        </td>
                                        <td>
                                            <label>Last Name</label>
                                        </td>
                                        <td>
                                            <label>Date of Birth</label>
                                        </td>
                                        <td>
                                            <label>Gender</label>
                                        </td>
                                        <td>
                                            <label>Citizenship</label>
                                        </td>
                                        <td></td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span data-toggle="collapse" data-target="#record1" class="accordion-toggle"><span class="glyphicon glyphicon-plus-sign"></span></span></td>
                                        <td>
                                            <label>John</label></td>
                                        <td>
                                            <label>Doe</label></td>
                                        <td>
                                            <label>12/1/1980</label></td>
                                        <td>
                                            <label>Male</label></td>
                                        <td>
                                            <label>Georgian</label></td>
                                        <td><span class="glyphicon glyphicon-edit"></span></td>
                                    </tr>
                                    <tr>
                                        <td colspan="7" class="hiddenRow">
                                            <div id="record1" class="accordian-body collapse">123 Main Street, Tbilisi, Georgia</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span data-toggle="collapse" data-target="#record2" class="accordion-toggle"><span class="glyphicon glyphicon-plus-sign"></span></span></td>
                                        <td>
                                            <label>Jane</label></td>
                                        <td>
                                            <label>Doe</label></td>
                                        <td>
                                            <label>6/2/1982</label></td>
                                        <td>
                                            <label>Female</label></td>
                                        <td>
                                            <label>Georgian</label></td>
                                        <td><span class="glyphicon glyphicon-edit"></span></td>
                                    </tr>
                                    <tr>
                                        <td colspan="7" class="hiddenRow">
                                            <div id="record2" class="accordian-body collapse">123 Main Street, Tbilisi, Georgia</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="row text-center">
                    <input type="button" class="btn btn-primary" value="New Search" onclick="newSearch();" />
                    <input type="button" class="btn btn-default" value="Create New Patient" onclick="createNewPatient();" />
                    <a href="../Dashboard.aspx" class="btn btn-default">Return to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row" id="patient">
        <div class="page-heading">
            <h2>Create New Patient</h2>
        </div>
        <div class="col-lg-8 col-md-8 col-sm-7 col-xs-7">
            <section id="personInformation" runat="server" class="col-md-12 hidden">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <h3>Person Information</h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-6">
                                    <asp:Label ID="lblNewPersonalIDType" runat="server" AssociatedControlID="ddlNewPersonalIDType" Text="Personal ID Type"></asp:Label>
                                    <asp:DropDownList ID="ddlNewPersonalIDType" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <asp:Label ID="lblNewPersonalIDNumber" runat="server" AssociatedControlID="txtNewPersonalIDNumber" Text="Personal ID Number"></asp:Label>
                                    <asp:TextBox ID="txtNewPersonalIDNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewFirstName" runat="server" AssociatedControlID="txtNewFirstName" Text="First"></asp:Label>
                                    <asp:TextBox ID="txtNewFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-2 col-md-2 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewMiddleInit" runat="server" AssociatedControlID="txtNewMiddleInit" Text="M.I."></asp:Label>
                                    <asp:TextBox ID="txtNewMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewLastName" runat="server" AssociatedControlID="txtNewLastName" Text="Last"></asp:Label>
                                    <asp:TextBox ID="txtNewLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-2 col-md-2 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewSuffix" runat="server" AssociatedControlID="ddlNewSuffix" Text="Suffix"></asp:Label>
                                    <asp:DropDownList ID="ddlNewSuffix" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewDoB" runat="server" AssociatedControlID="txtNewDoB" Text="Date of Birth"></asp:Label>
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                        <asp:TextBox ID="txtNewDoB" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewAge" runat="server" AssociatedControlID="txtNewAge" Text="Age"></asp:Label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtNewAge" runat="server" CssClass="form-control" onblur="clearDoB();"></asp:TextBox>
                                        <div class="input-group-addon">
                                            <asp:DropDownList ID="ddlNewAgeType" runat="server" onchange="clearDoB();" AutoPostBack="false">
                                                <asp:ListItem></asp:ListItem>
                                                <asp:ListItem Value="days" Text="Day(s)"></asp:ListItem>
                                                <asp:ListItem Value="months" Text="Month(s)"></asp:ListItem>
                                                <asp:ListItem Value="years" Text="Year(s)"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewGender" runat="server" Text="Gender" AssociatedControlID="ddlNewGender"></asp:Label>
                                    <asp:DropDownList ID="ddlNewGender" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewCitizenship" runat="server" Text="Citizenship" AssociatedControlID="ddlNewCitizenship"></asp:Label>
                                    <asp:DropDownList ID="ddlNewCitizenship" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                    <asp:Label ID="lblNewPassportNumber" runat="server" Text="Passport Number" AssociatedControlID="txtNewPassportNumber"></asp:Label>
                                    <asp:TextBox ID="txtNewPassportNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <h3 class="heading">Person Employment</h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="form-group">
                            <asp:Label ID="lblNewCurrentlyEmployed" runat="server" AssociatedControlID="hdfNewCurrentlyEmployed" Text="Is this person currently employed?"></asp:Label>
                            <div class="input-group">
                                <div class="btn-group">
                                    <div class="radio-inline">
                                        <input type="radio" name="Employed" value="Yes" id="employedYes" /><label>Yes</label></div>
                                    <div class="radio-inline">
                                        <input type="radio" name="Employed" value="No" id="employedNo" /><label>No</label></div>
                                    <div class="radio-inline">
                                        <input type="radio" name="Employed" value="Unknown" id="employedUnknown" /><label>Unknown</label></div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfNewCurrentlyEmployed" runat="server" />
                        </div>
                        <div id="employmentInformation">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12">
                                        <asp:Label ID="lblNewEmployerName" runat="server" AssociatedControlID="txtNewEmployerName" Text="Employer Name"></asp:Label>
                                        <asp:TextBox ID="txtNewEmployerName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                        <asp:Label ID="lblNewEmployerLastDateAppeared" runat="server" AssociatedControlID="txtNewEmployerLastDateAppeared" Text="Date of Last Appearence"></asp:Label>
                                        <div class="input-group">
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtNewEmployerLastDateAppeared" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lblNewEmployerPhone" runat="server" Text="Employer's Phone Number" AssociatedControlID="hdfNewEmployerPhone"></asp:Label>
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                        <asp:Label ID="lblNewEmployerCountryCodeandNumber" runat="server" AssociatedControlID="txtNewEmployerCountryCodeandNumber" Text="Country Code and Number"></asp:Label>
                                        <asp:TextBox ID="txtNewEmployerCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                        <asp:Label ID="lblNewEmployerPhoneType" runat="server" AssociatedControlID="ddlNewEmployerPhoneType" Text="Type"></asp:Label>
                                        <asp:DropDownList ID="ddlNewEmployerPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hdfNewEmployerPhone" runat="server" />
                            </div>
                            <uc1:LocationUserControl ID="lucNewEmployerAddress" runat="server" EnableAutoPostback="false" ShowApartment="false" ShowBuilding="false" ShowBuildingHouseApartmentGroup="false" ShowHouse="false" ShowCountry="false" ShowElevation="false" ShowStreet="true" />
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblNewCurrentlyInSchool" runat="server" AssociatedControlID="hdfNewCurrentlyInSchool" Text="Is this person currently in school?"></asp:Label>
                            <div class="input-group">
                                <div class="btn-group">
                                    <div class="radio-inline">
                                        <input type="radio" name="InSchool" value="Yes" id="inSchoolYes" /><label>Yes</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input type="radio" name="InSchool" value="No" id="inSchoolNo" /><label>No</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input type="radio" name="InSchool" value="Unknown" id="inSchoolUnknown" /><label>Unknown</label>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfNewCurrentlyInSchool" runat="server" />
                        </div>
                        <div id="schoolInformation">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12">
                                        <asp:Label ID="lblNewSchoolName" runat="server" AssociatedControlID="txtNewSchoolName" Text="School's Name"></asp:Label>
                                        <asp:TextBox ID="txtNewSchoolName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                        <asp:Label ID="lblNewSchoolLastDateAppeared" runat="server" AssociatedControlID="txtNewSchoolLastDateAppeared" Text="Date of Last Appearence"></asp:Label>
                                        <div class="input-group">
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                            <asp:TextBox ID="txtNewSchoolLastDateAppeared" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <uc1:LocationUserControl ID="lucNewSchool" runat="server" ShowElevation="false" ShowMap="false" ShowLatitude="false" ShowLongitude="false" EnableAutoPostback="false" ShowCoordinates="false" />
                        </div>
                    </div>
                </div>
            </section>
            <section id="personalAddress" runat="server" class="col-md-12 hidden">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <h3>Person Address and Phone</h3>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        
                        <uc1:LocationUserControl ID="locAddress" runat="server" ShowCountry="false" ShowGoogleMapsLink="true" />
                        <div class="form-group">
                            <asp:Label ID="lblAnotherAddress" runat="server" AssociatedControlID="hdfAnotherAddress" Text="Is there another address where this person can reside"></asp:Label>
                            <div class="input-group">
                                <div class="btn-group">
                                    <div class="radio-inline">
                                        <input type="radio" id="anotherAddressYes" name="AnotherAddress" value="Yes" />
                                        <label>Yes</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input type="radio" id="anotherAddressNo" name="AnotherAddress" value="No" />
                                        <label>No</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input type="radio" id="anotherAddressUnknown" name="AnotherAddress" value="Unknown" /><label>Unknown</label>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfAnotherAddress" runat="server" />
                        </div>
                        <div id="otherAddress">
                            <uc1:LocationUserControl ID="lucOtherAddress" runat="server" ShowElevation="false" ShowCountry="false" />
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblNewPhone" runat="server" Text="Person's Phone Number" AssociatedControlID="hdfNewPhone"></asp:Label>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                    <asp:Label ID="lblNewCountryCodeandNumber" runat="server" AssociatedControlID="txtNewCountryCodeandNumber" Text="Country Code and Number"></asp:Label>
                                    <asp:TextBox ID="txtNewCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                    <asp:Label ID="lblNewPhoneType" runat="server" AssociatedControlID="ddlNewPhoneType" Text="Type"></asp:Label>
                                    <asp:DropDownList ID="ddlNewPhoneType" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfNewPhone" runat="server" />
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblNewAnotherPhone" runat="server" AssociatedControlID="hdfNewAnotherPhone" Text="Is there another phone number for this person?"></asp:Label>
                            <div class="input-group">
                                <div class="btn-group">
                                    <div class="radio-inline">
                                        <input id="anotherPhoneYes" type="radio" name="AnotherPhone" value="Yes" /><label>Yes</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input id="anotherPhoneNo" type="radio" name="AnotherPhone" value="No" /><label>No</label>
                                    </div>
                                    <div class="radio-inline">
                                        <input id="anotherPhoneUnknown" type="radio" name="AnotherPhone" value="Unknown" /><label>Unknown</label>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfNewAnotherPhone" runat="server" />
                        </div>
                        <div class="form-group" id="otherPhone">
                            <asp:Label ID="lblNewOtherPhone" runat="server" Text="Person's Other Phone Number" AssociatedControlID="hdfNewOtherPhone"></asp:Label>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                    <asp:Label ID="lblNewOtherCountryCodeandNumber" runat="server" AssociatedControlID="txtNewOtherCountryCodeandNumber" Text="Country Code and Number"></asp:Label>
                                    <asp:TextBox ID="txtNewOtherCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                    <asp:Label ID="lblNewOtherPhoneType" runat="server" AssociatedControlID="ddlNewOtherPhoneType" Text="Type"></asp:Label>
                                    <asp:DropDownList ID="ddlNewOtherPhoneType" runat="server" CssClass="form-control" AutoPostBack="false"></asp:DropDownList>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdfNewOtherPhone" runat="server" />
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-5 col-xs-5">
            <div class="row">
                <aside class="sidepanel">
                    <ul id="panelList">
                        <li><a href="#" onclick="goToTab(0)">Person Information</a>
                            <div></div>
                        </li>
                        <li><a href="#" onclick="goToTab(1)">Person Address</a>
                            <div></div>
                        </li>
                        <li><a href="#" onclick="goToTab(2)">Person Review</a>
                            <div></div>
                        </li>
                    </ul>
                </aside>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-7 col-xs-7 text-center">
                <input type="button" id="btnReturntoSearch" class="btn btn-primary" value="Return to Search" onclick="returntoSearch();" />
                <input type="button" id="btnCancel" class="btn btn-default" value="Cancel" onclick="location.replace('../Dashboard.aspx')" />
                <input type="button" id="btnPreviousSection" value="Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                <input type="button" id="btnNextSection" value="Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                <input type="button" id="btnAddNew" value="Add New Person" class="btn btn-primary" onclick="addNewPerson();" />
            </div>
        </div>
    </div>
    <div class="row" id="patientReview">
        <div class="page-heading">
            <h2>Person Record Review</h2>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7"></div>
                    <div class="col-lg-4 col-md-4 col-sm-3 col-xs-3">
                        <label class="label"></label>
                    </div>
                    <div class="col-lg-1 col-md-1 col-sm-2 col-xs-2 text-right">
                        <input type="button" class="btn btn-default" value="Edit" />
                    </div>
                </div>
                <h3>Person Information</h3>
            </div>
            <div class="panel-body">
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%= lblPatientDateCreated.ClientID %>">Date Created</label>
                            <asp:Label ID="lblPatientDateCreated" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%= lblPatientDateUpdated.ClientID %>">Date Updated</label>
                            <asp:Label ID="lblPatientDateUpdated" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= lblPatientName.ClientID %>">Name</label>
                    <asp:Label ID="lblPatientName" runat="server" CssClass="form-control"></asp:Label>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%= lblPatientPersonalID.ClientID %>">Patient ID</label>
                            <asp:Label ID="lblPatientPersonalID" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%=  lblPatientPersonalIDType.ClientID %>">Personal ID Type</label>
                            <asp:Label ID="lblPatientPersonalIDType" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= lblPatientPassport.ClientID %>">Passport Number</label>
                    <asp:Label ID="lblPatientPassport" runat="server" CssClass="form-control"></asp:Label>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%=  lblPatientDoB.ClientID %>">Date of Birth</label>
                            <asp:Label ID="lblPatientDoB" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%=  lblPatientAge.ClientID %>">Age</label>
                            <asp:Label ID="lblPatientAge" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%=  lblPatientGender.ClientID %>">Gender</label>
                            <asp:Label ID="lblPatientGender" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <label for="<%=  lblPatientCitizenship.ClientID %>">Citizenship</label>
                            <asp:Label ID="lblPatientCitizenship" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                            <label for="<%= lblPatientAddress.ClientID %>">Patient's Current Address</label>
                            <asp:Label ID="lblPatientAddress" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                            <label for="<%= lblPatientPhone.ClientID %>">Patient's Phone Number</label>
                            <asp:Label ID="lblPatientPhone" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                            <label for="<%= lblPatientOtherAddress.ClientID %>">Patient's Other Address</label>
                            <asp:Label ID="lblPatientOtherAddress" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                            <label for="<%= lblPatientOtherPhone.ClientID %>">Patient's Other Phone Number</label>
                            <asp:Label ID="lblPatientOtherPhone" runat="server" CssClass="form-control"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="heading">Past Disease Reports</h3>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table id="tblDiseaseReport" class="table table-condensed" style="border-collapse: collapse;">
                        <thead>
                            <tr class="heading">
                                <td></td>
                                <td>
                                    <label>Date of Diagnosis</label></td>
                                <td>
                                    <label>Disease</label></td>
                                <td>
                                    <label>Disease Report ID</label></td>
                                <td>
                                    <label>Date Report Created</label></td>
                                <td>
                                    <label>Case Classification</label></td>
                                <td>
                                    <label>Case Status</label></td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span data-toggle="collapse" data-target="#diseaserecord1" class="accordion-toggle"><span class="glyphicon glyphicon-plus-sign"></span></span></td>
                                <td>
                                    <label>03/04/2016</label></td>
                                <td>
                                    <label>
                                        Report Type 1</label></td>
                                <td>
                                    <label>
                                        Report #1111</label></td>
                                <td>
                                    <label>
                                        03/02/2016</label></td>
                                <td>
                                    <label>Confirmed</label></td>
                                <td>
                                    <label>Active</label></td>
                            </tr>
                            <tr>
                                <td colspan="6" class="hiddenRow">
                                    <div id="diseaserecord1" class="accordian-body collapse">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label class="col-lg-2 col-md-2 col-sm-3 col-xs-3 control-label">Sample 1:</label>
                                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                                    <label class="form-control">Blood, Tested 3/5/2016. XYZ Test. Results: Positive.</label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-lg-2 col-md-2 col-sm-3 col-xs-3 control-label">Sample 2:</label>
                                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                                    <label class="form-control">Blood, Tested 3/5/2016. XYZ Test. Results: Negative.</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><span data-toggle="collapse" data-target="#diseaserecord2" class="accordion-toggle"><span class="glyphicon glyphicon-plus-sign"></span></span></td>
                                <td>
                                    <label>05/18/2009</label></td>
                                <td>
                                    <label>Report Type 2</label></td>
                                <td>
                                    <label>Report #1112</label></td>
                                <td>
                                    <label>05/10/2009</label></td>
                                <td>
                                    <label>Suspect</label></td>
                                <td>
                                    <label>Closed</label></td>
                            </tr>
                            <tr>
                                <td colspan="6" class="hiddenRow">
                                    <div id="diseaserecord2" class="accordian-body collapse">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label class="col-lg-2 col-md-2 col-sm-3 col-xs-3 control-label">Sample 1:</label>
                                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                                    <label class="form-control">Blood, Tested 05/14/2009. ABC Test. Results: Positive.</label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-lg-2 col-md-2 col-sm-3 col-xs-3 control-label">Sample 2:</label>
                                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                                    <label class="form-control">Blood, Tested 05/16/2009. ABC Test. Results: Negative.</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <input type="button" class="btn btn-primary" value="Add New Report" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <input type="button" class="btn btn-default" value="Return to Search Results" onclick="returntoSearch();" />&nbsp;
                <input type="button" class="btn btn-default" value="New Search" onclick="newSearch()" />&nbsp;
                <a href="../Dashboard.aspx" class="btn btn-default">Return to Dashboard</a>
            </div>
        </div>
    </div>
    <div class="row" id="disease">
        <div class="page-heading">
            <h2>Disease Report</h2>
        </div>
    </div>
    <!-- Successful Person -->
    <div class="modal fade" id="successPerson" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">New Person Record</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-success" role="alert">
                        <div class="row">
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                <span class="glyphicon glyphicon-ok-sign"></span>
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <h5>You successfully created a new person in the EIDSS System.</h5>
                                <h5>EIDSS ID#:</h5>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary">Add Disease Report</button>
                    <button type="button" class="btn btn-default" onclick="returntoPerson();" data-dismiss="modal">Return to Person Record</button>
                    <a href="../Dashboard.aspx" class="btn btn-default">Return to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
    <script src="../Includes/Scripts/moment-with-locales.js"></script>
    <script src="../Includes/Scripts/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript">
        var phone;
        var address;
        var minDate = new Date('01/01/1900');
        var today = new Date();

        $(document).ready()
        {
            $('#otherPhone').hide();
            $('#patient').hide();
            $('#patientReview').hide();
            $('#searchResults').hide();
            $('#schoolInformation, #employmentInformation').hide();
            $('#disease').hide();
            $('#searchForm').show();
            $("#successPerson").modal({ show: false });

            otherAddress();
            otherPhone();
            currentlyEmployed();
            currentlyInSchool();

            $("#<%= txtBirthdate.ClientID %>, #<%= txtNewSchoolLastDateAppeared.ClientID %>, #<%= txtNewEmployerLastDateAppeared.ClientID %>").datetimepicker({
                format: 'MM/DD/YYYY',
                minDate: minDate,
                maxDate: today
            });

            $("#<%= txtNewDoB.ClientID %>").datetimepicker({
                format: 'MM/DD/YYYY',
                minDate: minDate,
                maxDate: today
            }).on("dp.change", function (e) {
                var t = new Date();
                var selectedDate = new Date($("#<%= txtNewDoB.ClientID %>").val());

                var years = t.getFullYear() - selectedDate.getFullYear();
                var months = t.getMonth() - selectedDate.getMonth();
                var days = t.getDate() - selectedDate.getDate();

                if (months == 0) {
                    if (days < 0 && years > 0) {
                        years--;
                        months = 11;
                        days += new Date(t.getFullYear(), t.getMonth(), 0).getDate();
                    }
                }
                else if (months < 0) {
                    years--;
                    months += 12;
                }

                if (days < 0) {
                    months--;
                    days += new Date(t.getFullYear(), t.getMonth(), 0).getDate();
                }

                if (years > 0) {

                    $("#<%= txtNewAge.ClientID %>").val(years);
                    $("#<%= ddlNewAgeType.ClientID %>").val("years");
                }
                else if (months > 0) {
                    $("#<%= txtNewAge.ClientID %>").val(months);
                    $("#<%= ddlNewAgeType.ClientID %>").val("months");
                }
                else {
                    $("#<%= txtNewAge.ClientID %>").val(days);
                    $("#<%= ddlNewAgeType.ClientID %>").val("days");
                }

                $("#<%= txtNewSchoolLastDateAppeared.ClientID %>").datetimepicker({ minDate: selectedDate });
            });

            $('.accordion-toggle .glyphicon').click(function () { $(this).toggleClass('glyphicon-plus-sign glyphicon-minus-sign'); });
        }

        function searchPerson() {
            $('#searchForm').hide();
            $('#searchResults').show();

        $('#lblSearchCritLastEIDSSIDValue').text($("#<%= txtEIDSSIDNumber.ClientID %>").val());
        $('#lblSearchCritPersonalIDTypeValue').text($("#<%= ddlPersonalIDType.ClientID %>").val());
        $('#lblSearchCritPersonalIDValue').text($("#<%= txtPersonalID.ClientID %>").val());
        $('#lblSearchCritGenderValue').text($("#<%= ddlGender.ClientID%>").val());
        $('#lblSearchCritCitizenshipValue').text($("#<%= ddlCitizenship.ClientID%>").val());
        $('#lblSearchCritDoBValue').text($("#<%= txtBirthdate.ClientID %>").val());
        $('#lblSearchCritFirstNameValue').text($("#<%= txtFirstName.ClientID %>").val());
        $('#lblSearchCritMiddleInitValue').text($("#<%= txtMiddleInit.ClientID %>").val());
        $('#lblSearchCritLastNameValue').text($("#<%= txtLastName.ClientID %>").val());
        $('#lblSearchCritSuffixValue').text($("#<%= txtSuffix.ClientID %>").val());
    }

    function clearDoB() {
            $("#<%= txtNewDoB.ClientID %>").val("");
}

function newSearch() {
    $('#patientReview').find('label.form-control').text('');
    /*$('#patientReview').find('table tbody').empty();*/
    $('#patientReview').hide();
    $('#disease').hide();
    $('#search').show();
    $('#searchResults').hide();
    $('#searchForm').show();

    $('#searchForm').find('input[type="text"]').val('');
    $('#searchForm').find('select').prop('selectedIndex', 0);
}

function editSearch() {
    $('#searchResults').hide();
    $('#searchForm').show();
}

function clearSearch() {
    $('#searchForm').find('input[type="text"]').val('');
    $('#searchForm').find('select').prop('selectedIndex', 0);

}

function returntoSearch() {
    $('#patient').find('input[type="text"]').val('');
    $('#patient').find('select').prop('selectedIndex', 0);
    $('#patient').hide();
    $('#patientReview').hide();
    $('#search').show();
}

function createNewPatient() {
    setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
    $('#patient').show();
    $('#patient').find('input[type="text"]').val('');
    $('#patient').find('input[type="radio"]').prop('checked', false);
    $('#patient').find('select').prop('selectedIndex', 0);
    $('#search').hide();
    goToTab(0);
}

function returntoPerson() {
    $('#patient').hide();
    $('#patientReview').show();

    showButtons();
}

function addNewPerson() {
    $("#successPerson").modal({
        show: true,
        backdrop: 'static'
    });
}

        // shows or hide the 
function otherPhone() {
    $('input:radio[name="AnotherPhone"]').click(function () {
        phone = $('input:radio[name="AnotherPhone"]:checked').val();
        if (phone == "Yes")
            $('#otherPhone').show();
        else
            $('#otherPhone').hide();
    });
}

function otherAddress() {
    $('input:radio[name="AnotherAddress"]').click(function () {
        address = $('input:radio[name="AnotherAddress"]:checked').val();
        if (address == "Yes")
            $('#otherAddress').show();
        else
            $('#otherAddress').hide();
    });
}

function currentlyInSchool() {
    $('input:radio[name="InSchool"]').click(function () {
        var inSchool = $('input:radio[name="InSchool"]:checked').val();

        if (inSchool == "Yes")
            $("#schoolInformation").show();
        else
            $("#schoolInformation").hide();

        $("#<%= hdfNewCurrentlyInSchool.ClientID %>").val(inSchool);
    });
}

function currentlyEmployed() {
    $('input:radio[name="Employed"]').change(function () {
        var currentlyEmployed = $('input:radio[name="Employed"]:checked').val();

        if (currentlyEmployed == "Yes")
            $("#employmentInformation").show();
        else
            $("#employmentInformation").hide();
        $("#<%= hdfNewCurrentlyEmployed.ClientID %>").val(currentlyEmployed);
    });
}

        function showButtons() {
            $("input:text,select,textarea").attr("readOnly", false);
            $('input[type="button"]').show();
        }
    </script>
</asp:Content>
