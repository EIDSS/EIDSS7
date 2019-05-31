<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Person.aspx.vb" Inherits="EIDSS.PersonSearch" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="uc1" TagName="LocationUserControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../Includes/CSS/bootstrap-datetimepicker.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="uppPersonSearch" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hdfCurform" runat="server" />
            <div class="container-fluid">
                <div class="row">

                    <div id="searchForm" runat="server" class="panel panel-default" visible="false">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Search_by_Person_Information"></h2>
                        </div>
                        <div class="panel-body">
                            <div class="formContainer">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_by_Person_Information"></h3>
                                </div>
                                <div class="panel-body">
                                    <p>Use the following fields to search for existing person. Please fill in all known fields.</p>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label runat="server" for="ltxtEIDSSIDNumber" meta:resourcekey="lbl_EIDSS_ID"></label>
                                                <asp:TextBox ID="ltxtEIDSSIDNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-md-2 text-center">
                                                <label></label>
                                                <label class="form-control">-OR-</label>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="lddlidfsPersonIdType" runat="server" meta:resourcekey="lbl_Personal_ID_Type"></label>
                                                <asp:DropDownList ID="lddlidfsPersonIdType" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="ltxtstrPersonID" runat="server" meta:resourcekey="lbl_Personal_ID"></label>
                                                <asp:TextBox ID="ltxtstrPersonID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label runat="server" for="hdfName" meta:resourcekey="lbl_Name"></label>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="ltxtstrFirstName" runat="server" meta:resourcekey="Lbl_First_Name"></label>
                                                <asp:TextBox ID="ltxtstrFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-md-2">
                                                <label id="lblMiddleInit" for="ltxtstrSecondName" runat="server" meta:resourcekey="lbl_Middle_Init"></label>
                                                <asp:TextBox ID="ltxtstrSecondName" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="ltxtstrLastName" runat="server" meta:resourcekey="lbl_Last_Name"></label>
                                                <asp:TextBox ID="ltxtstrLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="txtSuffix" runat="server" meta:resourcekey="lbl_Suffix"></label>
                                                <asp:TextBox ID="txtSuffix" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <asp:HiddenField ID="hdfName" runat="server" />
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-5 col-xs-5">
                                                <label for="eciDateOfBirth" runat="server" meta:resourcekey="lbl_DOB"></label>
                                                    <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="ltxtdatDateOfBirth"
                                                        runat="server"></eidss:CalendarInput>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-5 col-xs-5">
                                                <label runat="server" for="lddlidfsHumanGender" meta:resourcekey="lbl_Gender"></label>
                                                <asp:DropDownList ID="lddlidfsHumanGender" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <uc1:LocationUserControl ID="lucSearch" runat="server" ShowCountry="false"
                                                ShowApartment="false"
                                                ShowBuilding="false"
                                                ShowBuildingHouseApartmentGroup="false"
                                                ShowCoordinates="false"
                                                ShowElevation="false"
                                                ShowHouse="false"
                                                ShowLatitude="false"
                                                ShowLongitude="false"
                                                ShowMap="false"
                                                ShowPostalCode="false"
                                                ShowStreet="false"
                                                ShowTownOrVillage="false"
                                                EnableAutoPostback="True" />
                                        </div>
                                    </div>
                                    <asp:TextBox ID="ltxtidfsRegion" runat="server" Visible="false" />
                                    <asp:TextBox ID="ltxtidfsRayon" runat="server" Visible="false" />
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                            </div>
                            <div class="row text-center">
                                <!--<input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Search" onclick="searchPerson();" />-->
                                <asp:Button runat="server" ID="btnSearch" CssClass="btn btn-primary" meta:resourcekey="btn_Search" OnClick="btnSearch_Click" />
                                <!--  <input type="button"  class="btn btn-default" runat="server" meta:resourcekey="btn_Clear"  onclick="btnClear()"/> -->
                                <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Clear" />
                                <a href="../Dashboard.aspx" class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard"></a>
                            </div>
                        </div>
                     </div>

                    <div class="modal" id="alertMessageVSS" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <<div class="modal-content">
                                    <div class="modal-header">
                                         <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                               <p id="lblAlertMessage" runat="server"></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button ID="btnalertMessage" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" ></button>
                                    </div>
                                </div>
                            </div>
                        </div> 

                    <div id="searchResults" runat="server" class="panel panel-default" visible="false">
                        <div class="panel-heading">
                            <h2 class="heading" runat="server" meta:resourcekey="hdg_Search_by_Person_Information"></h2>
                        </div>
                        <div class="panel-body">
                            <div class="formContainer">
                                <div class="panel panel-default">                            
                                    <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                            <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Parameters"></h3>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 heading text-right">
                                                <asp:LinkButton                                                     
                                                    CssClass="btn glyphicon glyphicon-edit" 
                                                    ID="btnEditSearch" 
                                                    meta:resourcekey="btn_Edit" 
                                                    OnClick="btnEditSearch_Click"
                                                    runat="server" ></asp:LinkButton>
                                        </div>
                                    </div>
                                    </div>
                                    <div class="panel-body">
                                      <div class="form-horizontal">
                                        <div class="form-group">
                                            <label for="<%= lblSearchCritIDType.ClientID %>" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_ID_Type"></label>
                                            <asp:Label ID="lblSearchCritIDType" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritPersonalID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Personal_ID"></label>
                                            <asp:Label ID="lblSearchCritPersonalID" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            <label for="lblSearchCritEIDSSID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_EIDSS_ID"></label>
                                            <asp:Label ID="lblSearchCritEIDSSID" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritFirstName" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_First_Name"></label>
                                            <asp:Label ID="lblSearchCritFirstName" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            <label for="lblSearchCritMiddleInit" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Middle_Init"></label>
                                            <asp:Label ID="lblSearchCritMiddleInit" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritLastName" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Last_Name"></label>
                                            <asp:Label ID="lblSearchCritLastName" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            <label for="lblSearchCritSuffix" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Suffix"></label>
                                            <asp:Label ID="lblSearchCritSuffixValue" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritDoB" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_DOB"></label>
                                            <asp:Label ID="lblSearchCritDoB" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            <label for="lblSearchCritGender" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" meta:resourcekey="lbl_Gender"></label>
                                            <asp:Label ID="lblSearchCritGender" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritCitizenship" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Citizenship"></label>
                                            <asp:Label ID="lblSearchCritCitizenship" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <label for="lblSearchCritRegion" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Region"></label>
                                            <asp:Label ID="lblSearchCritRegion" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            <label for="lblSearchCritRayon" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                            <asp:Label ID="lblSearchCritRayon" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                        </div>
                                      </div>
                                    </div>
                                </div>                       
                                <div class="panel panel-default">
                                   <div class="panel-heading">
                                    <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                </div>
                                   <div class="panel-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvPeople"
                                            runat="server"
                                            AllowPaging="True"
                                            AllowSorting="True"
                                            AutoGenerateColumns="False"
                                            CaptionAlign="Top"
                                            CssClass="table table-striped"
                                            DataKeyNames="strLastName"
                                            EmptyDataText="No data available."
                                            ShowFooter="True"
                                            GridLines="None"
                                            meta:Resourcekey="Grd_Employee_List">
                                            <HeaderStyle CssClass="table-striped-header" />
                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                            <Columns>
                                                <asp:CommandField SelectText="Select" ShowSelectButton="true" />
                                                <asp:BoundField DataField="strLastName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Last_Name.InnerText %>" />
                                                <asp:BoundField DataField="strFirstName" ReadOnly="true" SortExpression="strFirstName" HeaderText="<%$ Resources:lbl_First_Name.InnerText %>" />
                                                <asp:BoundField DataField="datDateofBirth" ReadOnly="true" SortExpression="datDateofBirth" DataFormatString="{0:d}" HeaderText="<%$ Resources:lbl_DOB.InnerText %>" />
                                                <asp:BoundField DataField="strPersonID" ReadOnly="true" SortExpression="strPersonID" HeaderText="<%$ Resources:lbl_Personal_ID.InnerText %>" />
                                                <asp:BoundField DataField="strPersonIDType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Personal_ID_Type.InnerText %>" />
                                                <asp:BoundField DataField="idfPerson" HeaderText="<%$ Resources:lbl_EIDSS_ID.InnerText %>" />
                                                <asp:BoundField DataField="humanGender" ReadOnly="true" HeaderText="<%$ Resources:lbl_Gender.InnerText %>" />
                                                <asp:BoundField DataField="humanRayon" ReadOnly="true" HeaderText="<%$ Resources:lbl_Rayon.InnerText %>" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <div class="details">
                                                            <span class="glyphicon glyphicon-collapse-down" onclick="showPersonSubGrid(event,'div<%#Eval("idfPerson") %>');"></span>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <tr id="div<%# Eval("idfPerson") %>" style="display: none;">
                                                            <td colspan="100">
                                                                <div style="position: relative; left: 125px; overflow: auto; width: 80%;">
                                                                    <asp:Label ID="lblPhone" runat="server" Text="<%$Resources:lbl_Persons_Phone_Number.InnerText %>" />
                                                                    <asp:Label ID="lblstrPhone" runat="server" Text='<%# Bind("strPhone") %>'></asp:Label><br />
                                                                    <asp:Label ID="lblCitiz" runat="server" Text="<%$Resources:lbl_Citizenship.InnerText %>" />
                                                                    <asp:Label ID="lblstrCitizen" runat="server" Text='<%# Bind("humanCountry") %>'></asp:Label><br />
                                                                    <asp:Label ID="lblRegion" runat="server" Text="<%$Resources:lbl_Region.InnerText %>" />
                                                                    <asp:Label ID="lblstrRegion" runat="server" Text='<%# Bind("humanRegion") %>' /><br />
                                                                    <asp:Label ID="lblCountry" runat="server" Text="<%$Resources:lbl_Region.InnerText %>" />
                                                                    <asp:Label ID="lblstrCountry" runat="server" Text='<%# Bind("humanCountry") %>' /><br />
                                                                    <asp:Label ID="lblAddr" runat="server" Text="<%$Resources:lbl_Patients_Current_Address.InnerText %>" />
                                                                    <asp:Label ID="lblstrAddress" runat="server" Text='<%# Bind("strStreetName") %>' /><br />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                   </div>
                                   <div class="panel-footer"></div>
                                </div>
                                <div class="row text-center">
                                    <!--<input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_New_Search" onclick="newSearch();" /> -->
                                    <asp:Button class="btn btn-primary" ID="btnNewPatient" runat="server" meta:resourcekey="btn_Create_New_Patient" />
                                    <asp:Button ID="btnNewSearch" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_New_Search" />
                                    <a href="../Dashboard.aspx" class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard"></a>
                                </div>                    
                           </div>
                        </div>
                    </div>

                    <div runat="server" id="patient" class="panel panel-default" visible="false">
                            <div class="panel-heading">
                                <h2 runat="server" meta:resourcekey="hdg_Create_New_Patient"></h2>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="sectionContainer expanded">
                                        <section id="personInformation" runat="server" class="col-md-12 hidden">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                            <h3 runat="server" meta:resourcekey="hdg_Person_Information"></h3>
                                                        </div>
                                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 heading text-right">
                                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="panel-body">
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <label for="ddlidfsPersonIDType" runat="server" meta:resourcekey="lbl_Personal_ID_Type"></label>
                                                                <asp:DropDownList ID="ddlidfsPersonIDType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label for="txtstrPersonalIDNumber" runat="server" meta:resourcekey="lbl_Personal_ID_Number"></label>
                                                                <asp:TextBox ID="txtstrPersonID" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                <label for="txtstrFirstName" runat="server" meta:resourcekey="lbl_First_Name"></label>
                                                                <asp:TextBox ID="txtstrFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-6 col-xs-12">
                                                                <label for="txtstrSecondName" runat="server" meta:resourcekey="lbl_Middle_Init"></label>
                                                                <asp:TextBox ID="txtstrSecondName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                <label for="txtstrLastName" runat="server" meta:resourcekey="lbl_Last_Name"></label>
                                                                <asp:TextBox ID="txtstrLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-6 col-xs-12">
                                                                <label for="ddlidfsSuffix" runat="server" meta:resourcekey="lbl_Suffix"></label>
                                                                <asp:DropDownList ID="ddlidfsSuffix" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label for="txtdatDateOfBirth" runat="server" meta:resourcekey="lbl_DOB"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtdatDateofBirth"
                                                                runat="server">
                                                            </eidss:CalendarInput>

                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                <label for="txtAge" runat="server" meta:resourcekey="lbl_Age"></label>
                                                                <div class="input-group age">
                                                                    <asp:TextBox ID="txtReportedAge" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    <div class="input-group-addon">
                                                                        <asp:DropDownList ID="ddlReportAgeUOMID" runat="server" CssClass="ageList" onchange="clearDoB(event);">
                                                                        </asp:DropDownList>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label for="ddlidfsHumanGender" runat="server" meta:resourcekey="lbl_Gender"></label>
                                                                <asp:DropDownList ID="ddlidfsHumanGender" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label for="ddlidfsNationality" runat="server" meta:resourcekey="lbl_Citizenship"></label>
                                                                <asp:DropDownList ID="ddlidfsNationality" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label for="txtstrPassportNbr" runat="server" meta:resourcekey="lbl_Passport_Number"></label>
                                                                <asp:TextBox ID="txtstrPassportNbr" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                            <h3 class="heading" runat="server" meta:resourcekey="hdg_Person_Employment"></h3>
                                                        </div>
                                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 heading text-right">
                                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="panel-body">
                                                    <div class="form-group">
                                                        <label for="hdfisEmployeeFla" runat="server" meta:resourcekey="lbl_Currently_employed"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="Employed" value="Yes" id="employedYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="Employed" value="No" id="employedNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="Employed" value="Unknown" id="employedUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfisEmployeeFlag" runat="server" />
                                                    </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12">
                                                                    <label for="txtstrEmployerName" runat="server" meta:resourcekey="lbl_Employer_Name"></label>
                                                                    <asp:TextBox ID="txtstrEmployerName" runat="server" CssClass="form-control"></asp:TextBox>
                                                                </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                                                <label for="txtdatEmployerLastDateAppeared" runat="server" meta:resourcekey="lbl_Date_of_Last_Appearence"></label>
                                                                <eidss:CalendarInput
                                                                    ContainerCssClass="input-group datepicker"
                                                                    CssClass="form-control"
                                                                    ID="txtdatEmployerLastDateAppeared"
                                                                    runat="server"></eidss:CalendarInput>
                                                            </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="hdfstrEmployerPhone" runat="server" meta:resourcekey="lbl_Employers_Phone_Number"></label>
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                                    <label for="txtstrEmployerCountryCodeandNumber" runat="server" meta:resourcekey="lbl_Country_Code_and_Number"></label>
                                                                    <asp:TextBox ID="txtstrEmployerCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                                                    <label for="ddlidfsEmployerPhoneType" runat="server" meta:resourcekey="lbl_Phone_Type"></label>
                                                                    <asp:DropDownList ID="ddlidfsEmployerPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                            <asp:HiddenField ID="hdfstrEmployerPhone" runat="server" />
                                                        </div>
                                                        <div class="form-group">
                                                            <label runat="server" meta:resourcekey="lbl_Employer_Address"></label>
                                                            <div class="input-group">
                                                                <div class="btn-group">
                                                                    <div class="checkbox-inline">
                                                                        <input id="foreignEmployerAddress" type="checkbox" value="EmployerForeignAddress" onchange="employerForeign()" />
                                                                        <label runat="server" meta:resourcekey="lbl_Foreign_Address"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <div id="employerAddress" runat="server">
                                                                <uc1:LocationUserControl ID="lucEmployer" runat="server" ShowCountry="false" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" ShowMap="false" EnableAutoPostback="True" />
                                                            </div>
                                                        </div>
                                                    <div class="form-group">
                                                        <label for="hdfblnCurrentlyInSchool" runat="server" meta:resourcekey="lbl_Currently_in_school"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="InSchool" value="Yes" id="inSchoolYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="InSchool" value="No" id="inSchoolNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" name="InSchool" value="Unknown" id="inSchoolUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfblnCurrentlyInSchool" runat="server" />
                                                    </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-7 col-xs-12">
                                                                    <label for="txtstrSchoolName" runat="server" meta:resourcekey="lbl_Schools_Name"></label>
                                                                    <asp:TextBox ID="txtstrSchoolName" runat="server" CssClass="form-control"></asp:TextBox>
                                                                </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12">
                                                                <label for="txtdatSchoolLastDateAppeared" runat="server" meta:resourcekey="lbl_Date_of_Last_Appearence"></label>
                                                                <eidss:CalendarInput
                                                                    ContainerCssClass="input-group datepicker"
                                                                    CssClass="form-control"
                                                                    ID="txtdatSchoolLastDateAppeared"
                                                                    runat="server"></eidss:CalendarInput>
                                                            </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="hdfstrSchoolPhone" runat="server" meta:resourcekey="lbl_Schools_Phone"></label>
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                                    <label for="txtstrSchoolCountryCodeandNumber" runat="server" meta:resourcekey="lbl_Country_Code_and_Number"></label>
                                                                    <asp:TextBox ID="txtstrSchoolCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                                                </div>
                                                                <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                                                    <label for="ddlidfsSchoolPhoneType" runat="server" meta:resourcekey="lbl_Phone_Type"></label>
                                                                    <asp:DropDownList ID="ddlidfsSchoolPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                            <asp:HiddenField ID="hdfstrSchoolPhone" runat="server" />
                                                        </div>
                                                        <uc1:LocationUserControl ID="lucSchool" runat="server" ShowElevation="false" ShowLatitude="false" ShowLongitude="false" ShowCoordinates="false" ShowMap="false" ShowCountry="false" EnableAutoPostback="True" />
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-12">
                                                                    <label for="txtstrSchoolBuilding" meta:resourcekey="lbl_Building"></label>
                                                                    <asp:TextBox runat="server" ID="txtstrSchoolBuilding" CssClass="form-control"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                </div>
                                                <div class="panel-footer"></div>
                                            </div>
                                            <div>
                                                <asp:HiddenField runat="server" ID="hdfidfEmployerAddress" />
                                                <asp:HiddenField runat="server" ID="hdfidfRegistrationAddress" />
                                                <asp:HiddenField runat="server" ID="hdfidfPatientAddress" />
                                                <asp:HiddenField runat="server" ID="hdfidfSchoolAddress" />
                                            </div>
                                        </section>
                                        <section id="personalAddress" runat="server" class="col-md-12 hidden">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <div class="row">
                                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                            <h3>Person Address and Phone</h3>
                                                        </div>
                                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 heading text-right">
                                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="panel-body">
                                                        <uc1:LocationUserControl ID="lucAddress" runat="server" ShowCountry="false" EnableAutoPostback="True" />
                                                    <div class="form-group">
                                                        <label for="hdfAnotherAddress" runat="server" meta:resourcekey="lbl_Another_Address"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <div class="radio-inline">
                                                                    <input type="radio" id="anotherAddressYes" name="AnotherAddress" value="Yes" />
                                                                    <label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" id="anotherAddressNo" name="AnotherAddress" value="No" />
                                                                    <label runat="server" meta:resourcekey="lbl_No"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input type="radio" id="anotherAddressUnknown" name="AnotherAddress" value="Unknown" />
                                                                    <label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfAnotherAddress" runat="server" />
                                                    </div>
                                                        <uc1:LocationUserControl ID="lucOtherAddress" runat="server" ShowCountry="false" EnableAutoPostback="True" />
                                                    <div class="form-group">
                                                        <label for="hdfstrPhone" runat="server" meta:resourcekey="lbl_Persons_Phone_Number"></label>
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                                <label for="txtstrCountryCodeandNumber" runat="server" meta:resourcekey="lbl_Country_Code_and_Number"></label>
                                                                <asp:TextBox ID="txtstrCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                                                <label for="ddlidfsPhoneType" runat="server" meta:resourcekey="lbl_Phone_Type"></label>
                                                                <asp:DropDownList ID="ddlidfsPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfstrPhone" runat="server" />
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="hdfstrAnotherPhone" runat="server" meta:resourcekey="lbl_Another_Phone"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <div class="radio-inline">
                                                                    <input id="anotherPhoneYes" type="radio" name="AnotherPhone" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input id="anotherPhoneNo" type="radio" name="AnotherPhone" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                </div>
                                                                <div class="radio-inline">
                                                                    <input id="anotherPhoneUnknown" type="radio" name="AnotherPhone" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfstrAnotherPhone" runat="server" />
                                                    </div>
                                                    <div class="form-group" id="otherPhone">
                                                        <label for="hdfstrOtherPhone" runat="server" meta:resourcekey="lbl_Persons_Other_Phone"></label>
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                                <label for="txtstrOtherCountryCodeandNumber" runat="server" meta:resourcekey="lbl_Country_Code_and_Number"></label>
                                                                <asp:TextBox ID="txtstrOtherCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-12">
                                                                <label for="ddlidfsOtherPhoneType" runat="server" meta:resourcekey="lbl_Phone_Type"></label>
                                                                <asp:DropDownList ID="ddlidfsOtherPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfstrOtherPhone" runat="server" />
                                                    </div>
                                                </div>
                                                <div class="panel-footer"></div>
                                            </div>
                                        </section>
                                    </div>
                                    <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                        <MenuItems>
                                            <eidss:SideBarItem
                                                CssClass="glyphicon glyphicon-ok"
                                                GoToTab="0"
                                                ID="sideBarItemPersonInfo"
                                                IsActive="true"
                                                ItemStatus="IsNormal"
                                                meta:resourcekey="tab_Person_Information"
                                                runat="server">
                                            </eidss:SideBarItem>
                                            <eidss:SideBarItem
                                                CssClass="glyphicon glyphicon-ok"
                                                GoToTab="1"
                                                ID="sideBarItemPersonAddress"
                                                IsActive="true"
                                                ItemStatus="IsNormal"
                                                meta:resourcekey="tab_Person_Address"
                                                runat="server">
                                            </eidss:SideBarItem>
                                            <eidss:SideBarItem
                                                CssClass="glyphicon glyphicon-ok"
                                                GoToTab="2"
                                                ID="sideBarItemPersonReview"
                                                IsActive="true"
                                                ItemStatus="IsNormal"
                                                meta:resourcekey="tab_Person_Review"
                                                runat="server">
                                            </eidss:SideBarItem>
                                        </MenuItems>
                                    </eidss:SideBarNavigation>
                                </div>
                                <div class="row">
                                    <div class="sectionContainer text-center">
                                        <input type="button" id="btnCancel" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel" onclick="location.replace('../Dashboard.aspx')" />
                                        <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                        <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                        <asp:Button ID="btnSubmit" runat="server" meta:resourcekey="btn_Add_New_Person" class="btn btn-primary" OnClick="btnAddNew_Click" />
                                    </div>
                                </div>
                            </div>
                    </div>

                    <div runat="server" id="patientReview" class="panel panel-default" visible="false">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Person_Record_Review"></h2>
                            </div>
                        <div class="panel-body">
                            <div class="formContainer">
                                <div class="panel panel-default">                            
                                    <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                                            <h3 runat="server" meta:resourcekey="hdg_Person_Information"></h3>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-3 col-xs-3">
                                            <label id="lblPersonID" class="label"></label>
                                        </div>
                                            <div class="col-lg-1 col-md-1 col-sm-2 col-xs-2 heading text-right">
                                                <asp:LinkButton CssClass="btn glyphicon glyphicon-edit" ID="lnkEditPerson" OnClick="lnkEditPerson_Click" runat="server"></asp:LinkButton>
                                            </div>
                                    </div>
                                    </div>
                                    <div class="panel-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%= lbldatEnteredDate.ClientID %>" runat="server" meta:resourcekey="lbl_Date_Created"></label>
                                            <asp:Label ID="lbldatEnteredDate" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%= lbldatModificationDate.ClientID %>" runat="server" meta:resourcekey="lbl_Date_Updated"></label>
                                            <asp:Label ID="lbldatModificationDate" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="<%= lblPatientName.ClientID %>" runat="server" meta:resourcekey="lbl_Name"></label>
                                    <asp:Label ID="lblPatientName" runat="server" CssClass="form-control"></asp:Label>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%= lblstrPersonID.ClientID %>" runat="server" meta:resourcekey="lbl_Patient_ID"></label>
                                            <asp:Label ID="lblstrPersonID" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%=  lblstrPersonIDType.ClientID %>" runat="server" meta:resourcekey="lbl_Personal_ID_Type"></label>
                                            <asp:Label ID="lblstrPersonIDType" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="<%= lblPassportNbr.ClientID %>" runat="server" meta:resourcekey="lbl_Passport_Number"></label>
                                    <asp:Label ID="lblPassportNbr" runat="server" CssClass="form-control"></asp:Label>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%=  lblPatientDoB.ClientID %>" runat="server" meta:resourcekey="lbl_DOB"></label>
                                            <asp:Label ID="lbldatDateofBirth" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%=  lblReportedAge.ClientID %>" runat="server" meta:resourcekey="lbl_Age"></label>
                                            <asp:Label ID="lblReportedAge" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%=  lblPatientGender.ClientID %>" runat="server" meta:resourcekey="lbl_Gender"></label>
                                            <asp:Label ID="lblGender" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                            <label for="<%=  lblPatientCitizenship.ClientID %>" runat="server" meta:resourcekey="lbl_Citizenship"></label>
                                            <asp:Label ID="lblCitizenship" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientAddress.ClientID %>" runat="server" meta:resourcekey="lbl_Patients_Current_Address"></label>
                                            <asp:Label ID="lblPatientAddress" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientPhone.ClientID %>" runat="server" meta:resourcekey="lbl_Patients_Phone_Number"></label>
                                            <asp:Label ID="lblPatientPhone" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientOtherAddress.ClientID %>" runat="server" meta:resourcekey="lbl_Patients_Other_Address"></label>
                                            <asp:Label ID="lblPatientOtherAddress" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientOtherPhone.ClientID %>" runat="server" meta:resourcekey="lbl_Patients_Other_Phone"></label>
                                            <asp:Label ID="lblstrHomePhone" runat="server" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                <h3 class="heading" runat="server" meta:resourcekey="hdg_Past_Disease_Reports"></h3>
                                </div>
                                    <div class="panel-body">
                                        <div class="col-lg-12 text-right">
                                            <input
                                                class="btn-sm btn-primary diseaseReport"
                                                id="btnNewDisease"
                                                meta:resourcekey="btn_Add_New_Report"
                                                onserverclick="btnNewDisease_ServerClick"
                                                runat="server"
                                                type="button" />
                                        </div>
                                        <div class="table-responsive">
                                        <asp:GridView runat="server" ID="gvDisease"
                                            AllowPaging="true"
                                            AllowSorting="true"
                                            AutoGenerateColumns="false"
                                            CssClass="table table-striped"
                                            GridLines="None"
                                            RowStyle-CssClass="table"
                                            EmptyDataText="No data available."
                                            ShowHeaderWhenEmpty="true"
                                            ShowFooter="true">
                                            <HeaderStyle CssClass="table-striped-header" />
                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Center" />
                                            <Columns>
                                                <asp:CommandField SelectText="Select" ShowSelectButton="true" />
                                                <asp:BoundField DataField="idfsDisease" ReadOnly="true" SortExpression="idfsDisease" HeaderText="<%$ Resources:lbl_Disease.InnerText %>" />
                                                <asp:BoundField DataField="datEnteredDate" ReadOnly="true" SortExpression="datEnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources:lbl_Date_Entered.InnerText %>" />
                                                <asp:BoundField DataField="strClinicalDiagnosis" ReadOnly="true" SortExpression="strClinicalDiagnosis" HeaderText="<%$ Resources:lbl_Diagnosis.InnerText %>" />
                                                <asp:BoundField DataField="datTentativeDiagnosisDate" ReadOnly="true" DataFormatString="{0:d}" HeaderText="<%$ Resources:lbl_Date_of_Diagnosis.InnerText %>" />
                                                <asp:BoundField DataField="strStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Status.InnerText %>" />
                                                <asp:BoundField DataField="strRegion" ReadOnly="true" HeaderText="<%$ Resources:lbl_Region.InnerText %>" />
                                                <asp:BoundField DataField="strRayon" ReadOnly="true" HeaderText="<%$ Resources:lbl_Rayon.InnerText %>" />
                                                <asp:BoundField DataField="strClassification" ReadOnly="true" HeaderText="<%$ Resources:lbl_Classification.InnerText %>" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <div class="details">
                                                            <span class="glyphicon glyphicon-collapse-down" onclick="showDiseaseSubGrid(event,'div<%#Eval("idfsDisease") %>');"></span>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <tr id="div<%# Eval("idfsDisease") %>" style="display: none;">
                                                            <td colspan="100">
                                                                <div style="position: relative; left: 125px; overflow: auto; width: 80%;">
                                                                    <asp:Label ID="lblPersonName" runat="server" Text="<%$Resources:lbl_Name.InnerText %>" />
                                                                    <asp:Label ID="lblstrPersonName" runat="server" Text='<%# Bind("strPersonName") %>'></asp:Label><br />
                                                                    <asp:Label ID="lblPersonID" runat="server" Text="<%$ Resources:lbl_Personal_ID.InnerText %>" />
                                                                    <asp:Label ID="lblidfPatientID" runat="server" Text='<%# Bind("idfHuman") %>'> /></asp:Label><br />
                                                                    <%--<asp:Label ID="llblEnteredByOrg" runat="server" Text="<%$Resources:lbl_Region.InnerText %>" />--%>
                                                                    <%--<asp:Label ID="lblstrEnteredByOrg" runat="server" Text='<%# Bind("") %>' /><br />--%>
                                                                    <asp:Label ID="lblEnteredByName" runat="server" Text="<%$Resources:lbl_Region.InnerText %>" />
                                                                    <asp:Label ID="lblstrEnteredByName" runat="server" Text='<%# Bind("strPersonEnteredBy") %>' /><br />
                                                                    <asp:Label ID="lblOnset" runat="server" Text="<%$Resources:lbl_Date_of_Symptom_Onset.InnerText %>" />
                                                                    <asp:Label ID="lbldatOnset" runat="server" Text='<%# Bind("datOnSetDate", "{0:d}") %>' /><br />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                    </div>
                                    <div class="panel-footer"></div>
                                </div>
                                <div class="row text-center">
                                    <input type="button" id="btnReturnToSearch2" class="btn btn-default" runat="server" meta:resourcekey="btn_Return_to_Search" onserverclick="btnReturnToSearch2_ServerClick" />
                                    <input type="button" id="btnNewSearch2" class="btn btn-default" runat="server" meta:resourcekey="btn_New_Search" onserverclick="btnNewSearch2_ServerClick" />
                                    <a href="../Dashboard.aspx" class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard"></a>
                                </div>
                            </div> 
                                                                                 
                               <div class="row" runat="server" id="disease" visible="false">
                               <h3 runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h3>
                               <div class="panel-group" id="diseaseReportSummary" runat="server" role="tablist">
                               <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                            <h4 runat="server" meta:resourcekey="hdg_Disease_Report_Summary"></h4>
                                        </div>
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#diseaseReportSummary" href="#diseasedHumanDetail" aria-expanded="true" aria-controls="collapseOne">
                                                <span class="glyphicon glyphicon-triangle-bottom"></span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div id="#diseasedHumanDetail" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <label for="lblReportID" runat="server" meta:resourcekey="lbl_Report_ID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblReportID" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                                <label for="lblDiagnosis" runat="server" meta:resourcekey="lbl_Diagnosis" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblDiagnosis" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label for="lblName" runat="server" meta:resourcekey="lbl_Name" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblName" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                                <label for="lblEIDSS_ID" runat="server" meta:resourcekey="lbl_EIDSS_ID" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblEIDSS_ID" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label for="lblReportStatus" runat="server" meta:resourcekey="lbl_Report_Status" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblReportStatus" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                                <label for="lblCaseClassification" runat="server" meta:resourcekey="lbl_Case_Classification" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblCaseClassification" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label for="lblDateEntered" runat="server" meta:resourcekey="lbl_Date_Entered" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblDateEntered" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                                <label for="lblDateLastUpdated" runat="server" meta:resourcekey="lbl_Date_Last_Updated" class="col-lg-3 col-md-3 col-sm-6 col-xs-6 control-label"></label>
                                                <asp:Label ID="lblDateLastUpdated" runat="server" CssClass="col-lg-3 col-md-3 col-sm-6 col-xs-6 form-label"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="sectionContainer">
                            <section id="diseaseNotification" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="tab_Disease_Notification"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group dates">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                    <label for="txtidfsDiagnosis" runat="server" meta:resourcekey="lbl_Diagnosis"></label>
                                                    <asp:TextBox ID="txtidfsDiagnosis" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label for="txtdatDateofDiagnosis" runat="server" meta:resourcekey="lbl_Date_of_Diagnosis"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtdatDateofDiagnosis"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label for="txtdatDateofNotification" runat="server" meta:resourcekey="lbl_Date_of_Notification"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtdatDateofNotification"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
                                                    <label for="ddlPatientStatus" runat="server" meta:resourcekey="lbl_Status_of_Patient"></label>
                                                    <asp:DropDownList ID="ddlPatientStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <hr />
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label for="txtNotificationSentby" runat="server" meta:resourcekey="lbl_Notification_Sent_by"></label>
                                                    <div class="input-group">
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                        <asp:TextBox ID="txtNotificationSentby" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label for="txtNotificationReceivedby" runat="server" meta:resourcekey="lbl_Notification_Received_by"></label>
                                                    <div class="input-group">
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                        <asp:TextBox ID="txtNotificationReceivedby" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <hr />
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="ddlPersonCurrentLocation" runat="server" meta:resourcekey="lbl_Persons_Current_Location"></label>
                                                    <asp:DropDownList ID="ddlPersonCurrentLocation" runat="server" CssClass="form-control" onchange="checkCurrentLocation();">
                                                        <asp:ListItem Value="current" Text="Current Address"></asp:ListItem>
                                                        <asp:ListItem Value="hospital" Text="Hospital"></asp:ListItem>
                                                        <asp:ListItem Value="other" Text="Other"></asp:ListItem>
                                                        <asp:ListItem Value="unknown" Text="Unknown"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="hospital" class="form-group currentLocation">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="ddlHospitalName" runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                    <asp:DropDownList ID="ddlHospitalName" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="otherLocation" runat="server" class="form-group currentLocation">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="txtOtherLocation" runat="server" meta:resourcekey="lbl_Other_Location"></label>
                                                    <asp:TextBox ID="txtOtherLocation" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="symptoms" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Symptoms"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label for="txtDateOfSymptomOnset" runat="server" meta:resourcekey="lbl_Date_of_Symptom_Onset"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtDateOfSymptomOnset"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="txtInitialCaseClassification" runat="server" meta:resourcekey="lbl_Initial_Case_Classification"></label>
                                                    <asp:DropDownList ID="ddlInitialCaseClassification" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="hdfListofSymptoms" runat="server" meta:resourcekey="lbl_List_of_Symptoms"></label>
                                            <asp:GridView ID="gvSymptoms" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false">
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
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                        <div class="form-group">
                                            <label for="txtComments" runat="server" meta:resourcekey="lbl_Comments"></label>
                                            <asp:TextBox ID="txtComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="facilityDetails" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Facility_Details"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Patient_Previously_Sought"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group">
                                                            <div class="radio-inline">
                                                                <input type="radio" name="PatientPreviouslySought" value="Yes" id="patientPreviouslySoughtYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="PatientPreviouslySought" value="No" id="patientPreviouslySoughtNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="PatientPreviouslySought" value="Unknown" id="patientPreviouslySoughtUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <asp:HiddenField ID="hdfPatientPreviouslySought" runat="server" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group previouslySought">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label for="txtDateFirstSoughtCare" runat="server" meta:resourcekey="lbl_Date_First_Sought_Care"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtDateFirstSoughtCare"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <div class="form-group previouslySought">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label for="txtFacilityFirstSoughtCare" runat="server" meta:resourcekey="lbl_Facility_First_Sought_Care"></label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtFacilityFirstSoughtCare" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group previouslySought">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="ddlNonNotifiableDiagnosis" runat="server" meta:resourcekey="lbl_NonNotifiable_Diagnosis"></label>
                                                    <asp:DropDownList ID="ddlNonNotifiableDiagnosis" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Hospitalization"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group">
                                                            <div class="radio-inline">
                                                                <input type="radio" name="Hospitalization" value="Yes" id="hospitalizationYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="Hospitalization" value="No" id="hospitalizationNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="Hospitalization" value="Unknown" id="hospitalizationUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                                <div class="form-group hospitalized">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label for="txtdatDateofHospitalization" runat="server" meta:resourcekey="lbl_Date_of_Hospitalization"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtdatDateofHospitalization"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label for="txtdatDateofDischarge" runat="server" meta:resourcekey="lbl_Date_of_Discharge"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtdatDateofDischarge"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                                    </div>
                                                </div>
                                        <div class="form-group hospitalized">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label for="txtHospitalName" runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtHospitalName" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:HiddenField ID="hdfhospitalization" runat="server" />
                                    </div>
                                </div>
                            </section>
                            <section id="antibioticVaccineHistory" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Antibiotics"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                    <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Therapy_Administered"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group">
                                                            <div class="radio-inline">
                                                                <input type="radio" name="AntibioticAntiviralTherapyAdministered" value="Yes" id="antibioticAntiviralTherapyAdministeredYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="AntibioticAntiviralTherapyAdministered" value="No" id="antibioticAntiviralTherapyAdministeredNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="AntibioticAntiviralTherapyAdministered" value="Unknown" id="antibioticAntiviralTherapyAdministeredUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <asp:HiddenField ID="hdfAntibioticAntiviral" runat="server" />
                                            </div>
                                        </div>
                                        <div class="form-group antibioticAdministered">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                    <label for="txtstrAntibioticName" runat="server" meta:resourcekey="lbl_Antibiotic_Name"></label>
                                                    <asp:TextBox ID="txtstrAntibioticName" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group antibioticAdministered">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Dose"></label>
                                                    <asp:TextBox ID="txtDose" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                    <label>&nbsp;</label>
                                                    <asp:DropDownList ID="ddlDoseMeasurements" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group antibioticAdministered">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label for="txtDateAntibioticFirstAdministered" runat="server" meta:resourcekey="lbl_Date_Antibiotic_First_Administered"></label>
                                                            <eidss:CalendarInput
                                                                ContainerCssClass="input-group datepicker"
                                                                CssClass="form-control"
                                                                ID="txtDateAntibioticFirstAdministered"
                                                                runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <hr />
                                        <div class="form-group">
                                            <label for="txtComments" runat="server" meta:resourcekey="lbl_Comments"></label>
                                            <asp:TextBox ID="txtAntibioticComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Vaccines"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                    <label runat="server" meta:resourcekey="lbl_Specific_Vaccination"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group">
                                                            <div class="radio-inline">
                                                                <input type="radio" name="SpecificVaccination" value="Yes" id="specificVaccinationdYes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="SpecificVaccination" value="No" id="specificVaccinationNo" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="SpecificVaccination" value="Unknown" id="specificVaccinationUnknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hdfVaccine" runat="server" />
                                        </div>
                                        <div class="form-group vaccinationAdministered">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                    <label for="txtstrVaccinationName" runat="server" meta:resourcekey="lbl_Vaccination_Name"></label>
                                                    <asp:TextBox ID="txtstrVaccinationName" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group vaccinationAdministered">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label for="txtDateofVaccination" runat="server" meta:resourcekey="lbl_Date_of_Vaccination"></label>
                                                            <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtDateofVaccination"
                                                        runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="samples" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Samples"></h4>
                                    </div>
                                    <div class="panel-body"></div>
                                </div>
                            </section>
                            <section id="caseDetails" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Details"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Investigator_Name_Organization"></label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtInvestigationNameOrganization" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="txtStartDateofInvestigation" runat="server" meta:resourcekey="lbl_Start_Date_of_Investigation"></label>
                                                    <div class="input-group dates">
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                        <asp:TextBox ID="txtStartDateofInvestigation" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                            <label for="hdfRelatedToOutbreak" runat="server" meta:resourcekey="lbl_Related_to_Outbreak"></label>
                                                            <div class="input-group">
                                                                <div class="btn-group">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" name="RelatedToOutbreak" value="Yes" id="relatedToOutbreakYes" />
                                                                        <label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" name="RelatedToOutbreak" value="No" id="relatedToOutbreakNo" />
                                                                        <label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" name="RelatedToOutbreak" value="Unknown" id="relatedToOutbreakUnknown" />
                                                                        <label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:HiddenField ID="hdfRelatedToOutbreak" runat="server" />
                                                    </div>
                                                </div>
                                                <div id="outbreakID" class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="txtCaseInvestigationOutbreakID" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtCaseInvestigationOutbreakID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <div class="input-group-addon">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <hr />
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Location_of_Exposure_Known"></label>
                                                    <div class="input-group">
                                                        <div class="btn-group">
                                                            <div class="radio-inline">
                                                                <input type="radio" name="LocationofExposureKnown" value="Yes" id="locationofExposureKnownYes" />
                                                                <label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                            </div>
                                                            <div class="radio-inline">
                                                                <input type="radio" name="LocationofExposureKnown" value="No" id="locationofExposureKnownNo" />
                                                                <label runat="server" meta:resourcekey="lbl_No"></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <asp:HiddenField ID="hdfLocationofExposureKnown" runat="server" />
                                            </div>
                                        </div>
                                        <div class="form-group locationOfExposure">
                                            <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label for="txtDateofPotentialExposure" runat="server" meta:resourcekey="lbl_Date_of_Potential_Exposure"></label>
                                                            <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtDateofPotentialExposure"
                                                        runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <div class="form-group locationOfExposure">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                    <label for="<%=  hdfExposureAddressType.ClientID %>" runat="server" meta:resourcekey="lbl_Exposure_Address_Type"></label>
                                                    <div class="input-group">
                                                        <div class="radio-inline">
                                                            <input id="rdbExposureAddressTypeExact" type="radio" name="ExposureAddressType" value="Exact" /><label runat="server" meta:resourcekey="lbl_Exact"></label>
                                                        </div>
                                                        <div class="radio-inline">
                                                            <input id="rdbExposureAddressTypeRelative" type="radio" name="ExposureAddressType" value="Relative" /><label runat="server" meta:resourcekey="lbl_Relative"></label>
                                                        </div>
                                                        <div class="radio-inline">
                                                            <input id="rdbExposureAddressTypeForeign" type="radio" name="ExposureAddressType" value="Foreign" /><label runat="server" meta:resourcekey="lbl_Foreign"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <asp:HiddenField ID="hdfExposureAddressType" runat="server" />
                                            </div>
                                        </div>
                                        <div class="form-group locationOfExposure">
                                            <uc1:LocationUserControl ID="lucExposure" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowStreet="false" ShowElevation="false" ShowPostalCode="false" />
                                        </div>
                                        <div class="form-group locationOfExposure">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                                    <label for="" runat="server" meta:resourcekey="lbl_Exposure_Location_Description"></label>
                                                    <asp:TextBox ID="txtExposureLocationDescription" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="riskFactors" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Risk_Factors"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <label for="hdfRiskFactor" runat="server" meta:resourcekey="lbl_List_of_Risks"></label>
                                            <asp:GridView ID="gvRisk" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false">
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
                                                </Columns>
                                            </asp:GridView>
                                            <asp:HiddenField ID="hdfRiskFactor" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="finalOutcome" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Final_Outcome"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                    <label for="ddlFinalClassification" runat="server" meta:resourcekey="lbl_Final_Case_Classification"></label>
                                                    <asp:DropDownList ID="ddlFinalClassification" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                            <label for="txtDateofClassification" runat="server" meta:resourcekey="lbl_Date_of_Classification"></label>
                                                            <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtDateofClassification"
                                                        runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                    <label for="ddlOutcome" runat="server" meta:resourcekey="lbl_Outcome"></label>
                                                    <asp:DropDownList ID="ddlOutcome" runat="server" CssClass="form-control" onchange="showOutcome();">
                                                        <asp:ListItem Value="" Text=""></asp:ListItem>
                                                        <asp:ListItem Value="recovered" Text="Recovered"></asp:ListItem>
                                                        <asp:ListItem Value="died" Text="Died"></asp:ListItem>
                                                        <asp:ListItem Value="unknown" Text="Unknown"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="outcomeDateofDeath" class="form-group">
                                            <div class="row">
                                                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                            <label for="txtDateofDeath" runat="server" meta:resourcekey="lbl_Date_of_Death"></label>
                                                            <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtDateofDeath"
                                                        runat="server"></eidss:CalendarInput>
                                                        </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="contactList" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Contact_List"></h4>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                <input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" data-toggle="modal" data-target="#modalAddContact" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>
                        <eidss:SideBarNavigation ID="SideBarNavigation1" runat="server">
                            <MenuItems>
                                <eidss:SideBarItem
                                    CssClass="glyphicon glyphicon-ok"
                                    GoToTab="0"
                                    ID="sideBarItemDiseaseNotification"
                                    IsActive="true"
                                    ItemStatus="IsNormal"
                                    meta:resourcekey="tab_Disease_Notification"
                                    runat="server">
                                </eidss:SideBarItem>
                                <%--tab_Clinical_Information
                                    <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="1" 
                                    ID="sideBarItemClinicalInfo" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="tab_Symptoms"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="2" 
                                    ID="sideBarItemFacilityDetails" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="tab_Facility_Details"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="3" 
                                    ID="sideBarItemVaccineHistory" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="tab_Antibiotic_Vaccine_History"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-file" 
                                    GoToTab="4" 
                                    ID="sideBarItemSamples" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="tab_Samples"
                                    runat="server"></eidss:SideBarItem>
                                   <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-file" 
                                    GoToTab="" 
                                    ID="sideBarItemSamples" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="tab_Case_Investigation"
                                    runat="server"></eidss:SideBarItem>
                                --%>
                                <eidss:SideBarItem
                                    CssClass="glyphicon glyphicon-ok"
                                    GoToTab="5"
                                    ID="sideBarItemCaseDetails"
                                    IsActive="true"
                                    ItemStatus="IsNormal"
                                    meta:resourcekey="tab_Case_Details"
                                    runat="server">
                                </eidss:SideBarItem>
                                <eidss:SideBarItem
                                    CssClass="glyphicon glyphicon-ok"
                                    GoToTab="6"
                                    ID="sideBarItemRiskFactors"
                                    IsActive="true"
                                    ItemStatus="IsNormal"
                                    meta:resourcekey="tab_Risk_Factors"
                                    runat="server">
                                </eidss:SideBarItem>
                                <eidss:SideBarItem
                                    CssClass="glyphicon glyphicon-ok"
                                    GoToTab="7"
                                    ID="sideBarItemFinalOutcome"
                                    IsActive="true"
                                    ItemStatus="IsNormal"
                                    meta:resourcekey="tab_Final_Outcome"
                                    runat="server">
                                </eidss:SideBarItem>
                                <eidss:SideBarItem
                                    CssClass="glyphicon glyphicon-ok"
                                    GoToTab="8"
                                    ID="sideBarItemContactList"
                                    IsActive="true"
                                    ItemStatus="IsNormal"
                                    meta:resourcekey="tab_Contact_List"
                                    runat="server">
                                </eidss:SideBarItem>
                                <%--   <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-file" 
                                    GoToTab="" 
                                    ID="sideBarItem5" 
                                    IsActive="true" 
                                    ItemStatus="IsReview" 
                                    meta:resourcekey="tab_Disease_Report_Review"
                                    runat="server"></eidss:SideBarItem>--%>
                            </MenuItems>
                        </eidss:SideBarNavigation>

                        <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8 text-center">
                            <asp:Button ID="btn_Submit_Disease_Report" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Ok" OnClick="btn_Submit_Disease_Report_Click" />
                            <asp:Button ID="btn_Return_to_Person_Record" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Return_to_Person_Record" OnClick="btn_Return_to_Person_Record_Click" />
                        </div>
                    </div>   
                                       
                           </div>
                        </div>
                  </div>
            </div>

            <!-- this is a modal pop up-->
            <div class="modal fade" id="modalAddContact" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Contact_Information"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                                        <div class="row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                <label for="txtstrContactFirstName" runat="server" meta:resourcekey="lbl_First_Name"></label>
                                                <asp:TextBox ID="txtstrContactFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
                                                <label for="txtstrContactMiddleInit" runat="server" meta:resourcekey="lbl_Middle_Init"></label>
                                                <asp:TextBox ID="txtstrContactMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
                                                <label for="txtstrContactLastName" runat="server" meta:resourcekey="lbl_Last_Name"></label>
                                                <asp:TextBox ID="txtstrContactLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
                                        <label for="ddlContactRelation" runat="server" meta:resourcekey="lbl_Relation"></label>
                                        <asp:DropDownList ID="ddlContactRelation" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="txtdatContactDoB" runat="server" meta:resourcekey="lbl_DOB"></label>
                                        <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtdatContactDoB"
                                                        runat="server"></eidss:CalendarInput>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="ddlContactGender" runat="server" meta:resourcekey="lbl_Gender"></label>
                                        <asp:DropDownList ID="ddlContactGender" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="ddlContactCitizenship" runat="server" meta:resourcekey="lbl_Citizenship"></label>
                                        <asp:DropDownList ID="ddlContactCitizenship" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="hdfstrContactPhone" runat="server" meta:resourcekey="lbl_Employers_Phone_Number"></label>
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12">
                                        <label for="txtstrContactCountryCodeandNumber" runat="server" meta:resourcekey="lbl_Country_Code_and_Number"></label>
                                        <asp:TextBox ID="txtstrContactCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="ddlstrContactPhoneType" runat="server" meta:resourcekey="lbl_Phone_Type"></label>
                                        <asp:DropDownList ID="ddlstrContactPhoneType" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hdfstrContactPhone" runat="server" />
                            </div>
                            <div class="form-group">
                                <label runat="server" meta:resourcekey="lbl_Current_Address"></label>
                                <div class="input-group">
                                    <div class="btn-group">
                                        <div class="checkbox-inline">
                                            <input id="foreignContactAddress" type="checkbox" value="ContactForeignAddress" onchange="contactForeign();" />
                                            <label runat="server" meta:resourcekey="lbl_Foreign_Address"></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <uc1:LocationUserControl ID="lucContact" runat="server" ShowCountry="false" ShowCoordinates="false" EnableAutoPostback="false" />
                            </div>
                            <hr />
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="txtdatLastContactDate" runat="server" meta:resourcekey="lbl_Date_of_Last_Contact"></label>
                                        <eidss:CalendarInput
                                                        ContainerCssClass="input-group datepicker"
                                                        CssClass="form-control"
                                                        ID="txtdatLastContactDate"
                                                        runat="server"></eidss:CalendarInput>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                        <label for="txtPlaceofLastContact" runat="server" meta:resourcekey="lbl_Place_of_Last_Contact"></label>
                                        <asp:TextBox ID="txtPlaceofLastContact" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" onclick="addContact();"></button>
                            &nbsp;
                            <button type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Successful Person -->
            <div class="modal fade" id="successPerson" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_New_Person_Record"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-success" role="alert">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-ok-sign"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <h5 runat="server" meta:resourcekey="hdg_Successful_Patient"></h5>
                                        <h5 runat="server" meta:resourcekey="hdg_EIDSS_ID"></h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Disease_Report"></button>
                            <button type="button" class="btn btn-default" runat="server" onclick="returntoPerson();" data-dismiss="modal" meta:resourcekey="btn_Return_to_Person_Record"></button>
                            <a href="../Dashboard.aspx" class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard"></a>
                        </div>
                    </div>
                </div>
            </div>

            <script src="../Includes/Scripts/moment-with-locales.js"></script>
            <script src="../Includes/Scripts/bootstrap-datetimepicker.js"></script>
            <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
            <script type="text/javascript">

                $(document).ready(function () {
                    //  This registers a call back handler that is triggered after every
                    //  successful postback (sync or async)
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);

                    //  this checks to see if the container that has <section> tabs is present
                    if (checkContainersExist()) {
                        setViewOnPageLoad("<% = hdnPanelController.ClientID %>");

                     $('#<%= alertMessageVSS.ClientID %>').modal({ show: false, backdrop: 'static' });    
                    }
                });

                //  this is the call back event handler that calls the setViewOnPageLoad after
                //  a successful postback
                function callBackHandler() {
                    //  this checks to see if the container that has <section> tabs is present
                    if (checkContainersExist()) {
                        setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                    }
                    $('#<%= alertMessageVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                };

                //  this function is unique for each page it checks to see if the container(s)
                //  that need the side navigation are currently being displayed
                function checkContainersExist() {
                    //  get instance of div containers with sections
                    var patient = document.getElementById("<%= patient.ClientID %>");
                    var disease = document.getElementById("<%= disease.ClientID %>");

                    // if instances are not null, return true
                    if (patient != null) {
                        return true;
                    }
                    if (disease != null) {
                        return true;
                    }
                    return false;
                };

                function showPersonSubGrid(e, f) {
                    var cl = e.target.className;

                    if (cl == 'glyphicon glyphicon-collapse-down') {
                        e.target.className = "glyphicon glyphicon-collapse-up";
                        $('#' + f).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-collapse-down";
                        $('#' + f).hide();
                    }
                };

                function showDiseaseSubGrid(e, f) {
                    var cl = e.target.className;

                    if (cl == 'glyphicon glyphicon-collapse-down') {
                        e.target.className = "glyphicon glyphicon-collapse-up";
                        $('#' + f).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-collapse-down";
                        $('#' + f).hide();
                    }
                };

            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
