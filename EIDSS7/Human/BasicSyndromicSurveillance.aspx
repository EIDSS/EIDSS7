<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="BasicSyndromicSurveillance.aspx.vb" MaintainScrollPositionOnPostback="true" Inherits="EIDSS.BasicSyndromicSurveillance" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../Includes/CSS/bootstrap-datetimepicker.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Basic_Syndromic_Surveillance"></h2>
                        </div>
                        <div class="panel-body">
                            <!-- This is the "REQUIRED ONLY ALERT at top of panels -->
                            <div class="form-group">
                                <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                <label runat="server" meta:resourcekey="lbl_Required"></label>
                            </div>
                            <div class="row">
                                <div class="col-lg-8 col-md-8 col-sm-7 col-xs-7 embed-panel">
                                    <section id="personalInformationSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Personal_Information"></h3>
                                                    </div>
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label runat="server" for="<%= ddlNotificationOf.ClientID %>" meta:resourcekey="lbl_Notification_Of"></label>
                                                            <asp:DropDownList ID="ddlNotificationOf" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label runat="server" for="<%= ddlNameofHospital.ClientID %>" meta:resourcekey="lbl_Name_of_Hospital"></label>
                                                            <asp:DropDownList ID="ddlNameofHospital" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label runat="server" for="<%= txtReport.ClientID %>" meta:resourcekey="lbl_Report_Date"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon">
                                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                                </span>
                                                                <asp:TextBox ID="txtReport" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label runat="server" for="<% txtFirstName.ClientID %>" meta:resourcekey="lbl_First_Name" tooltip="<%$ Resources: Labels, Lbl_First_Name_ToolTip %>"></label>
                                                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <label runat="server" for="<%= txtMiddleName.ClientID %>" meta:resourcekey="lbl_Middle_Name"></label>
                                                            <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                            <label runat="server" for="txtLastName" meta:resourcekey="lbl_Last_Name"></label>
                                                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6s col-xs-6">
                                                            <label runat="server" for="<%= txtDoB.ClientID %>" meta:resourcekey="lbl_Date_Of_Birth"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon">
                                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                                </span>
                                                                <asp:TextBox ID="txtDoB" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= ddlGender.ClientID %>" meta:resourcekey="lbl_Gender"></label>
                                                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control" onchange="changeGender(); return false;">
                                                                <asp:ListItem Value=""></asp:ListItem>
                                                                <asp:ListItem Value="Male" meta:resourceKey="lbl_Male"></asp:ListItem>
                                                                <asp:ListItem Value="Female" meta:resourceKey="lbl_Female"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <eidss:LocationUserControl ID="lucBasic" runat="server" ShowCountry="false" ShowElevation="false" ShowCoordinates="false" />
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= txtPhone.ClientID %>" meta:resourcekey="lbl_Phone"></label>
                                                            <div class="input-group">
                                                                <span class="input-group-addon"><span class="glyphicon glyphicon-earphone"></span></span>
                                                                <asp:TextBox runat="server" ID="txtPhone" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                    <section id="symptomsSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Symptoms"></h3>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <label runat="server" for="<%= txtDateofSymptomOnset.ClientID %>" meta:resourcekey="lbl_Date_of_Symptom_Onset"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon">
                                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                                </span>
                                                                <asp:TextBox ID="txtDateofSymptomOnset" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <label for="<%= hdfPregnant.ClientID %>" runat="server" meta:resourcekey="lbl_Pregnant"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="pregnantYes" class="woman" name="Pregnant" disabled="disabled" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="pregnantNo" class="woman" name="Pregnant" disabled="disabled" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="pregnantUnknown" class="woman" name="Pregnant" disabled="disabled" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only Exists for bolden the label -->
                                                            <asp:HiddenField ID="hdfPregnant" runat="server" />
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                            <label associatedcontrolid="hdfPostpartum" runat="server" meta:resourcekey="lbl_Postpartum"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="postpartumYes" class="postpartum" disabled="disabled" name="Postpartum" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="postpartumNo" class="postpartum" disabled="disabled" name="Postpartum" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="postpartumUnknown" class="postpartum" disabled="disabled" name="Postpartum" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only Exists for bolden the label -->
                                                            <asp:HiddenField ID="hdfPostPartum" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label for="hdfFever38" runat="server" meta:resourcekey="lbl_Fever38"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="fever38Yes" name="Fever38" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="fever38No" name="Fever38" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="fever38Unknown" name="Fever38" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only Exists for bolden the label -->
                                                            <asp:HiddenField ID="hdfFever38" runat="server" />
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" for="<%= ddlMethodofMeasurement.ClientID %>" meta:resourcekey="lbl_Method_of_Measurement"></label>
                                                            <asp:DropDownList ID="ddlMethodofMeasurement" runat="server" CssClass="form-control" Enabled="false" onchange="showOtherMethod(); return false;">
                                                                <asp:ListItem Value=""></asp:ListItem>
                                                                <asp:ListItem Value="oral" meta:resourceKey="lbl_Oral"></asp:ListItem>
                                                                <asp:ListItem Value="auxiliary" meta:resourceKey="lbl_Auxiliary"></asp:ListItem>
                                                                <asp:ListItem Value="other" meta:resourceKey="lbl_Other"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label for="<%= txtOtherMethod.ClientID %>" runat="server" meta:resourcekey="lbl_Other_Method"></label>
                                                            <asp:TextBox ID="txtOtherMethod" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label for="<%= hdfCough.ClientID %>" runat="server" meta:resourcekey="lbl_Cough"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="coughYes" runat="server" name="Cough" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="coughNo" runat="server" name="Cough" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="coughUnknown" runat="server" name="Cough" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only exists to bolden label -->
                                                            <asp:HiddenField ID="hdfCough" runat="server" />
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label for="<%= hdfShortnessofBreath.ClientID %>" runat="server" meta:resourcekey="lbl_Shortness_of_Breath"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="shortnessofBreathYes" runat="server" name="shortnessofBreath" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="shortnessofBreathNo" runat="server" name="shortnessofBreath" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="shortnessofBreathUnknown" runat="server" name="shortnessofBreath" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only exists to bolden label -->
                                                            <asp:HiddenField ID="hdfShortnessofBreath" runat="server" />
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label associatedcontrolid="hdfSeasonalFluVaccine" runat="server" meta:resourcekey="lbl_Seasonal_Flu_Vaccine"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="seasonalFluVaccineYes" runat="server" name="SeasonalFluVaccine" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="seasonalFluVaccineNo" runat="server" name="SeasonalFluVaccine" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                    </div>
                                                                    <div class="radio-inline">
                                                                        <input type="radio" id="seasonalFluVaccineUnknown" runat="server" name="SeasonalFluVaccine" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only exists to bolden label -->
                                                            <asp:HiddenField ID="hdfSeasonalFluVaccine" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" for="<%= hdfAntiviralMedication %>" meta:resourcekey="lbl_Antiviral_Medication"></label>
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="btn-group">
                                                                        <div class="radio-inline">
                                                                            <input type="radio" id="antiviralMedicationYes" name="AntiviralMedication" value="Yes" /><label runat="server" meta:resourcekey="lbl_Yes"></label>
                                                                        </div>
                                                                        <div class="radio-inline">
                                                                            <input type="radio" id="antiviralMedicationNo" name="AntiviralMedication" value="No" /><label runat="server" meta:resourcekey="lbl_No"></label>
                                                                        </div>
                                                                        <div class="radio-inline">
                                                                            <input type="radio" id="antiviralMedicationUnknown" name="AntiviralMedication" value="Unknown" /><label runat="server" meta:resourcekey="lbl_Unknown"></label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Only exists to bolden label -->
                                                            <asp:HiddenField ID="hdfAntiviralMedication" runat="server" />
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" for="<%= txtNameofMedication.ClientID %>" meta:resourcekey="lbl_Name_of_Medication"></label>
                                                            <asp:TextBox ID="txtNameofMedication" runat="server" CssClass="form-control medication" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" for="<%= txtDateReceived.ClientID %>" meta:resourcekey="lbl_Date_Received"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon">
                                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                                </span>
                                                                <asp:TextBox ID="txtDateReceived" runat="server" CssClass="form-control datetimepicker medication" Enabled="false" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <asp:Label ID="lblConcurrentConditions" runat="server" for="<%= cblConcurrent.ClientID %>" meta:resourceKey="lbl_Concurrent_Conditions"></asp:Label>
                                                    <asp:CheckBoxList ID="cblConcurrent" runat="server" RepeatColumns="3" RepeatDirection="Horizontal"></asp:CheckBoxList>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                    <section id="samplesSection" runat="server" class="col-md-12 hidden">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Samples"></h3>
                                                    </div>
                                                    <div class="col-md-3 heading text-right">
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(2)"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= txtSampleCollection.ClientID %>" meta:resourcekey="lbl_Sample_Collection_Date"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                                <asp:TextBox ID="txtSampleCollection" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= txtSampleID %>" meta:resourcekey="lbl_Sample_ID"></label>
                                                            <asp:TextBox ID="txtSampleID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= ddlTestResults.ClientID %>" meta:resourcekey="lbl_Test_Results"></label>
                                                            <asp:DropDownList ID="ddlTestResults" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                            <label runat="server" for="<%= txtResultDate %>" meta:resourcekey="lbl_Result_Date"></label>
                                                            <div class="input-group dates">
                                                                <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                                <asp:TextBox ID="txtResult" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-5 col-xs-5">
                                    <div class="row">
                                        <eidss:SideBarNavigation ID="sbnPanelList" runat="server">
                                            <MenuItems>
                                                <eidss:SideBarItem ID="sbiPersonalInformation" runat="server" GoToTab="0" CssClass="glyphicon glyphicon-ok" IsActive="true" ItemStatus="IsNormal" meta:resourceKey="tab_Personal_Information"></eidss:SideBarItem>
                                                <eidss:SideBarItem ID="sbiSymptoms" runat="server" GoToTab="1" CssClass="glyphicon glyphicon-ok" IsActive="true" ItemStatus="IsNormal" meta:resourceKey="tab_Symptoms"></eidss:SideBarItem>
                                                <eidss:SideBarItem ID="sbiSamples" runat="server" GoToTab="2" CssClass="glyphicon glyphicon-ok" IsActive="true" ItemStatus="IsNormal" meta:resourceKey="tab_Samples"></eidss:SideBarItem>
                                                <eidss:SideBarItem ID="sbiReview" runat="server" GoToTab="3" CssClass="glyphicon glyphicon-ok" IsActive="true" ItemStatus="IsReview" meta:resourceKey="tab_Review"></eidss:SideBarItem>
                                            </MenuItems>
                                        </eidss:SideBarNavigation>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 col-md-offset-1 text-center">
                                    <input type="button" class="btn btn-default" runat="server" onclick="location.replace('../Dashboard.aspx')" meta:resourcekey="btn_Cancel" />
                                    <input type="button" runat="server" meta:resourcekey="btn_Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                    <input type="button" runat="server" meta:resourcekey="btn_Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                    <asp:Button runat="server" meta:resourceKey="btn_Submit" ID="btnSubmit" CssClass="btn btn-primary hidden" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
    <script src="../Includes/Scripts/moment.js"></script>
    <script src="../Includes/Scripts/moment-with-locales.js"></script>
    <script src="../Includes/Scripts/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript">
        var minDate = new Date('01/01/1900');
        var today = new Date();

        $(document).ready(function () {
            setViewOnPageLoad("<% =hdnPanelController.ClientID %>");

            $(".dates").datetimepicker({
                minDate: minDate,
                maxDate: today,
                useCurrent: false,
                format: 'MM/DD/YYYY'
            });
            receivedMedication();
            isPregnant();
            isFever();
            shortnessofbreath();
            cough();
            showOtherMethod();
            seasonalFluVaccine();
        });

        function changeGender() {
            var gender = $("#<%= ddlGender.ClientID %>").val();
            if (gender == 'Female')
                $('.woman').removeAttr('disabled');
            else
                $('.woman').attr('disabled', 'disabled');
        }

        function receivedMedication() {
            $('input:radio[name="AntiviralMedication"]').click(function () {
                var antiviralMedication = $('input:radio[name="AntiviralMedication"]:checked').val();
                if (antiviralMedication == "Yes")
                    $('.medication').removeAttr('disabled');
                else
                    $('.medication').attr('disabled', 'disabled');

                $("#<%= hdfAntiviralMedication.ClientID%>").val(antiviralMedication);
            });
        }

        function isPregnant() {
            $('input:radio[name="Pregnant"]').click(function () {
                var pregnant = $('input:radio[name="Pregnant"]:checked').val();
                if (pregnant == "No")
                    $('.postpartum').removeAttr('disabled');
                else
                    $('.postpartum').attr('disabled', 'disabled');

                $("#<%= hdfPregnant.ClientID %>").val(pregnant);
            });
        }

        function isFever() {
            $('input:radio[name="Fever38"]').click(function () {
                var isFever = $('input:radio[name="Fever38"]:checked').val();
                if (isFever == "Yes")
                    $("#<%= ddlMethodofMeasurement.ClientID %>").removeAttr('disabled');
                else
                    $("#<%= ddlMethodofMeasurement.ClientID %>").attr('disabled', 'disabled');

                $("#<%= hdfFever38.ClientID %>").val(isFever);
            });
        }

        function showOtherMethod() {
            var method = $("#<%= ddlMethodofMeasurement.ClientID %>").val();
            if (method == "other")
                $("#<%= txtOtherMethod.ClientID %>").removeAttr('disabled');
            else
                $("#<%= txtOtherMethod.ClientID%>").attr('disabled', 'disabled');
        }

        function cough() {
            $('input:radio[name="Cough"]').click(function () {
                var Cough = $('input:radio[name="Cough"]:checked').val();
                $("#<%= hdfCough.ClientID %>").val(Cough);
            });
        }

        function shortnessofbreath() {
            $('input:radio[name="ShortnessofBreath"]').click(function () {
                var ShortnessofBreath = $('input:radio[name="ShortnessofBreath"]:checked').val();
                $("#<%= hdfShortnessofBreath.ClientID %>").val(ShortnessofBreath);
            });
        }

        function seasonalFluVaccine() {
            $('input:radio[name="SeasonalFluVaccine"]').click(function () {
                var SeasonalFluVaccine = $('input:radio[name="SeasonalFluVaccine"]:checked').val();
                $("#<%= hdfSeasonalFluVaccine.ClientID %>").val(SeasonalFluVaccine);
            });
        }
    </script>
</asp:Content>
