<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DropDownSearch.ascx.vb" Inherits="EIDSS.DropDownSearch" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<div class="input-group">
    <span class="input-group-addon"><span role="button" data-toggle="modal" data-target="#<%= searchModal.ClientID %>" class="glyphicon glyphicon-search"></span></span>
    <asp:DropDownList ID="ddlAllItems" runat="server" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
</div>

<div class="modal" id="searchModal" runat="server" tabindex="-1" role="dialog" aria-labelledby="searchModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="searchModalLabel" runat="server" meta:resourcekey="hdg_Search"></h4>
            </div>
            <asp:Panel ID="pnlOrganization" runat="server" Visible="false">
                        <div class="modal-body">
                            <h4 runat="server" meta:resourcekey="hdg_Organization"></h4>
                            <div class="form-group" meta:resourcekey="Dis_Organization_Unique_Id" runat="server">
                                <label for="<%= txtUniqueOrgID.ClientID %>" meta:resourcekey="Lbl_Organization_Unique_Id" runat="server"></label>
                                <asp:TextBox CssClass="form-control" ID="txtUniqueOrgID" runat="server" />
                                <%--                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtUniqueOrgID"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Organization_Unique_Id"
                                                runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" meta:resourcekey="Dis_Abbreviation" runat="server">
                                <label for="<%= txtAbbrevation.ClientID %>" meta:resourcekey="Lbl_Abbreviation" runat="server"></label>
                                <asp:TextBox CssClass="form-control" ID="txtAbbrevation" runat="server" />
                                <%--                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtAbbrevation"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Abbreviation"
                                                runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" meta:resourcekey="Dis_Organization_Full_Name" runat="server">
                                <label for="<%= txtOrginazationFullName.ClientID %>" meta:resourcekey="Lbl_Organization_Full_Name" runat="server"></label>
                                <asp:TextBox CssClass="form-control" ID="txtOrginazationFullName" runat="server" />
                                <%--                                            <asp:RequiredFieldValidator
                                                ControlToValidate="txtOrginazationFullName"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Organization_Full_Name"
                                                runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" meta:resourcekey="Dis_Specialization" runat="server">
                                <label for="<%= ddlSpecialization.ClienID %>" meta:resourcekey="Lbl_Specialization" runat="server"></label>
                                <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" ID="ddlSpecialization" runat="server"></asp:DropDownList>
                                <%--                                            <asp:RequiredFieldValidator
                                                ControlToValidate="ddlSpecialization"
                                                CssClass=""
                                                Display="Dynamic"
                                                meta:resourcekey="Val_Specialization"
                                                runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" meta:resourcekey="Dis_Show_Foreign_Organizations" runat="server">
                                <asp:CheckBox runat="server" ID="chkShowForeignOrganizations" />
                                <label for="chkShowForeignOrganizations" meta:resourcekey="Lbl_Show_Foreign_Organizations" runat="server"></label>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOrganizationSearchRegion.ClientID  %>" runat="server" meta:resourcekey="lbl_Region"></label>
                                        <asp:DropDownList ID="ddlOrganizationSearchRegion" runat="server" CssClass="form-control" onchange="hideModal();" AutoPostBack="true" OnSelectedIndexChanged="ddlOrganizationSearchRegion_SelectedIndexChanged" ></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOrganizationRayon.ClientID  %>" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                        <asp:DropDownList ID="ddlOrganizationSearchRayon" runat="server" class="form-control" onchange="hideModal();" AutoPostBack="true"  OnSelectedIndexChanged="ddlOrganizationSearchRayon_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOrganizationSettlement.ClientID  %>" runat="server" meta:resourcekey="lbl_Settlement"></label>
                                        <asp:DropDownList ID="ddlOrganizationSearchSettlement" runat="server" CssClass="form-control" Enabled="false" ></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Close"></button>
                            <asp:Button ID="btnSearchOrganization" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:hdg_Search.InnerText %>" OnClientClick="hideModal();" OnClick="btnSearchOrganization_Click" />
                        </div>
            </asp:Panel>
            <asp:Panel ID="pnlEmployee" runat="server" Visible="false">
                <asp:UpdatePanel ID="uppEmployee" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h4 runat="server" meta:resourcekey="hdg_Employee"></h4>
                            <div class="form-group" id="PositionContainer" meta:resourcekey="Dis_Position" runat="server">
                                <label for="<%= ddlPosition.ClientID %>" meta:resourcekey="Lbl_Position" runat="server"></label>
                                <asp:DropDownList runat="server" ID="ddlPosition" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="ddlPosition"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_Position"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" id="FamilyNameContainer" meta:resourcekey="Dis_Family_Name" runat="server">
                                <label for="<%= txtLastName.ClientID %>" meta:resourcekey="Lbl_Family_Name" runat="server"></label>
                                <asp:TextBox runat="server" ID="txtLastName" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="txtLastName"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_FamilyName"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" id="FirstNameContainer" meta:resourcekey="Dis_First_Name" runat="server">
                                <label for="<%= txtFirstName.ClientID %>" meta:resourcekey="Lbl_First_Name" runat="server"></label>
                                <asp:TextBox runat="server" ID="txtFirstName" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="txtFirstName"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_First_Name"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" id="MiddleNameContainer" meta:resourcekey="Dis_Middle_Name" runat="server">
                                <label for="<%= txtMiddleName.ClientID %>" meta:resourcekey="Lbl_Second_Name" runat="server"></label>
                                <asp:TextBox runat="server" ID="txtMiddleName" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="txtMiddleName"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_Second_Name"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" id="OrganizationContainer" meta:resourcekey="Dis_Organization" runat="server">
                                <label for="<%= ddlOrganization.ClientID %>" meta:resourcekey="Lbl_Organization" runat="server"></label>
                                <asp:DropDownList ID="ddlOrganization" runat="server" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="ddlOrganization"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_Organization"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                            <div class="form-group" id="UniqueIdContainer" meta:resourcekey="Dis_Unique_Organization_ID" runat="server">
                                <label for="<%= txtUniqueOrgID.ClientID %>" meta:resourcekey="Lbl_Organization_Unique_Id" runat="server"></label>
                                <asp:TextBox runat="server" ID="txt_Person_Organization_Unique_Id" CssClass="form-control" />
                                <%--                    <asp:RequiredFieldValidator
                        ControlToValidate="txtUniqueOrgID"
                        CssClass=""
                        Display="Dynamic"
                        meta:resourcekey="Val_Unique_Organization_ID"
                        runat="server"></asp:RequiredFieldValidator>--%>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Close"></button>
                            <asp:Button ID="btnSearchEmployee" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:hdg_Search.InnerText %>" OnClick="btnSearchEmployee_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="pnlPerson" runat="server" Visible="false">
                <asp:UpdatePanel ID="uppPerson" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h4 runat="server" meta:resourcekey="hdg_Person"></h4>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label runat="server" for="<%= txtEIDSSIDNumber.ClientID %>" meta:resourcekey="lbl_EIDSS_ID"></label>
                                        <asp:TextBox ID="txtPersonSearchEIDSSIDNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <label></label>
                                        <label class="form-control">-OR-</label>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="<%= ddlPersonSearchPersonalIDType.ClientID %>" runat="server" meta:resourcekey="lbl_Personal_ID_Type"></label>
                                        <asp:DropDownList ID="ddlPersonSearchPersonalIDType" runat="server" CssClass="form-control" onchange="personalIDTypeChange();"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="<%= txtPersonalID.ClientID %>" runat="server" meta:resourcekey="lbl_Personal_ID"></label>
                                        <asp:TextBox ID="txtPersonalID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label runat="server" for="hdfName" meta:resourcekey="lbl_Name"></label>
                                <div class="row">
                                    <div class="col-md-5">
                                        <label for="<%= txtPersonSearchFirstName.ClientID %>" runat="server" meta:resourcekey="lbl_First_Name"></label>
                                        <asp:TextBox ID="txtPersonSearchFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-md-2">
                                        <label for="<%= txtPersonSearchMiddleInit.ClientID %>" runat="server" meta:resourcekey="lbl_Middle_Init"></label>
                                        <asp:TextBox ID="txtPersonSearchMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-md-5">
                                        <label for="<%= txtPersonSearchLastName.ClientID %>" runat="server" meta:resourcekey="lbl_Last_Name"></label>
                                        <asp:TextBox ID="txtPersonSearchLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hdfName" runat="server" />
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="txtPersonSearchBirthdate" runat="server" meta:resourcekey="lbl_DOB"></label>
                                        <div class="input-group dates">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtPersonSearchBirthDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlPersonSearchGender.ClientID %>" runat="server" meta:resourcekey="lbl_Gender"></label>
                                        <asp:DropDownList ID="ddlPersonSearchGender" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlPersonSearchRegion.ClientID  %>" runat="server" meta:resourcekey="lbl_Region"></label>
                                        <asp:DropDownList ID="ddlPersonSearchRegion" runat="server" CssClass="form-control" onchange="hideModal();" AutoPostBack="true" OnSelectedIndexChanged="ddlPersonSearchRegion_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlPersonSearchRayon.ClientID  %>" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                        <asp:DropDownList ID="ddlPersonSearchRayon" runat="server" CssClass="form-control" onchange="hideModal();" AutoPostBack="true" OnSelectedIndexChanged="ddlPersonSearchRayon_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <label for="<%= ddlPersonSearchSettlement.ClientID  %>" runat="server" meta:resourcekey="lbl_Settlement"></label>
                                        <asp:DropDownList ID="ddlPersonSearchSettlement" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <%--<eidss:LocationUserControl ID="lucSearch" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowApartment="false" ShowPostalCode="false" ShowStreet="false" ShowElevation="false" ShowMap="false" />--%>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Close"></button>
                            <asp:Button ID="btnSearchPerson" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:hdg_Search.InnerText %>" OnClientClick="hideModal();" OnClick="btnSearchPerson_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="pnlOutbreak" runat="server" Visible="false">
                <asp:UpdatePanel ID="uppOutbreak" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h4 runat="server" meta:resourcekey="hdg_Outbreak"></h4>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOutbreakSearchDisease.ClientID  %>" runat="server" meta:resourcekey="lbl_Disease"></label>
                                        <asp:DropDownList ID="ddlOutbreakSearchDisease" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlSearchDiagnosesGroup.ClientID  %>" runat="server" meta:resourcekey="lbl_Diagnoses_Group"></label>
                                        <asp:DropDownList ID="ddlOutbreakSearchDiagnosesGroup" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="<%= hdfSearchStartDate.ClientID %>" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtOutbreakSearchStartDateFrom.ClientID  %>" runat="server" meta:resourcekey="lbl_From"></label>
                                        <div id="outbreaksSearchStartDateFrom" runat="server" class="input-group dates">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtOutbreakStartDateFrom" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtOutbreakSearchStartDateTo.ClientID  %>" runat="server" meta:resourcekey="lbl_To"></label>
                                        <div id="outbreaksSearchStartDateTo" runat="server" class="input-group dates">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtOutbreakStartDateTo" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="<%= hdfSearchEndDate.ClientID %>" runat="server" meta:resourcekey="lbl_End_Date"></label>
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtOutbreakSearchEndDateFrom.ClientID  %>" runat="server" meta:resourcekey="lbl_From"></label>
                                        <div id="outbreaksSearchEndDateFrom" runat="server" class="input-group dates">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtOutbreakSearchEndDateFrom" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtOutbreakSearchEndDateTo.ClientID  %>" runat="server" meta:resourcekey="lbl_To"></label>
                                        <div id="outbreaksSearchEndDateTo" runat="server" class="input-group dates">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                            <asp:TextBox ID="txtOutbreakSearchEndDateTo" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOutbreakSearchRegion.ClientID  %>" runat="server" meta:resourcekey="lbl_Region"></label>
                                        <asp:DropDownList ID="ddlOutbreakSearchRegion" runat="server" CssClass="form-control" onchange="hideModal();" AutoPostBack="true" OnSelectedIndexChanged="ddlOutbreakSearchRegion_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlOutbreakSearchRayon.ClientID  %>" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                        <asp:DropDownList ID="ddlOutbreakSearchRayon" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtPatient.ClientID %>" runat="server" meta:resourcekey="lbl_Patient"></label>
                                        <asp:TextBox ID="txtPatient" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= txtFarmOwner.ClientID %>" runat="server" meta:resourcekey="lbl_Farm_Owner"></label>
                                        <asp:TextBox ID="txtFarmOwner" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                        <label for="<%= ddlSearchOutbreakStatus.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                        <asp:DropDownList ID="ddlSearchOutbreakStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="btn_Close"></button>
                            <asp:Button ID="btnSearchOutbreak" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:hdg_Search.InnerText %>" OnClientClick="hideModal();" OnClick="btnSearchOutbreak_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
        </div>
    </div>
</div>

<script type="text/javascript">
    var minDate = new Date('01/01/1900');
    var today = new Date();
    
    $(document).ready(function () {
        $('#<%= searchModal.ClientID %>').modal({ show: false });

        $(".dates").datetimepicker({
            format: 'MM/DD/YYYY',
            minDate: minDate,
            maxDate: today,
            useCurrent: false
        });
        
        $("#<%= btnSearchEmployee.ClientID %>, #<%= btnSearchOrganization.ClientID %>, #<%= btnSearchPerson.ClientID %>, #<%= btnSearchOutbreak.ClientID %>").click(function () {
            $('#<%= searchModal.ClientID %>').modal('hide');
        });

        outbreakDropDownSearchDates();

        //  This registers a call back handler that is triggered after every
        //  successful postback (sync or async)
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
    });

    function callBackHandler()
    {

        $(".dates").datetimepicker({
            format: 'MM/DD/YYYY',
            minDate: minDate,
            maxDate: today,
            useCurrent: false
        });

        $("#<%= btnSearchEmployee.ClientID %>, #<%= btnSearchOrganization.ClientID %>, #<%= btnSearchPerson.ClientID %>, #<%= btnSearchOutbreak.ClientID %>").click(function () {
            $('#<%= searchModal.ClientID %>').modal('hide');
        });

        outbreakDropDownSearchDates();
    }

    function hideModal() {
        $('#<%= searchModal.ClientID %>').modal('hide');
    }

    function openModal() {
        $('#<%= searchModal.ClientID %>').modal('show');
    }

    function personalIDTypeChange() {
        var personalIDType = $("#<%= ddlPersonSearchPersonalIDType.ClientID %> option:selected").text();
        if (personalIDType != "") {

            $("#<%= txtPersonalID.ClientID %>").removeAttr("disabled");
        }
        else {
            $("#<%= txtPersonalID.ClientID %>").attr("disabled", "disabled");
        }
    }

    function outbreakDropDownSearchDates() {
        $("#<%= outbreaksSearchStartDateFrom.ClientID %>").on("dp.change", function (e) {
            $("#<%= outbreaksSearchStartDateTo.ClientID %>").data("DateTimePicker").minDate(e.date);
        });
        $("#<%= outbreaksSearchStartDateTo.ClientID %>").on("dp.change", function (e) {
            $("#<%= outbreaksSearchStartDateFrom.ClientID %>").data("DateTimePicker").maxDate(e.date);
        });

        $("#<%= outbreaksSearchEndDateFrom.ClientID %>").on("dp.change", function (e) {
            $("#<%= outbreaksSearchEndDateTo.ClientID %>").data("DateTimePicker").minDate(e.date);
        });
        $("#<%= outbreaksSearchEndDateTo.ClientID %>").on("dp.change", function (e) {
            $("#<%= outbreaksSearchEndDateFrom.ClientID %>").data("DateTimePicker").maxDate(e.date);
        });
    }
</script>
