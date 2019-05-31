<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="UrgentNotification.aspx.vb" Inherits="EIDSS.UrgentNotification" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="page-heading">
        <h2>Urgent Notification</h2>
    </div>
    <p><%= GetLocalResourceObject("UrgentNotificationDescription") %></p>
    <!-- This is the "REQUIRED ONLY ALERT at top of panels -->
    <div class="form-group">
        <div class="glyphicon glyphicon-asterisk text-danger"></div>
        <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="sectionContainer">
                    <section id="detailsSection" runat="server" class="col-md-12 hidden">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-9">
                                        <h3 class="heading"><% = GetGlobalResourceObject("Tabs", "Tab_Details_of_Urgent_Notification_Text") %></h3>
                                    </div>
                                    <div class="col-md-3 heading text-right">
                                        <a role="button" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="form-group">
                                    <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                    <asp:Label
                                        AssociatedControlID="ddlTentativeDiagnosis"
                                        ID="lblTentativeDiagnosis"
                                        runat="server"
                                        Text="<%$ Resources:LblTentativeDiagnosisText %>"
                                        ToolTip="<%$ Resources:LblTentativeDiagnosisToolTip  %>"></asp:Label>
                                    <asp:DropDownList ID="ddlTentativeDiagnosis" runat="server" CssClass="form-control"></asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                    <asp:Label
                                        AssociatedControlID="txtDateofDiagnosis"
                                        ID="lblDateofDiagnosis"
                                        runat="server"
                                        Text="<%$ Resources:Labels, Lbl_Date_of_Diagnosis_Text %>"
                                        ToolTip="<%$ Resources: Labels, Lbl_Date_of_Diagnosis_ToolTip %>"></asp:Label>
                                    <eidss:CalendarInput ID="txtDateofDiagnosis" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                </div>
                                <div class="form-group">
                                    <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                    <asp:Label
                                        AssociatedControlID="txtDateofSymptomOnset"
                                        ID="lblDateofSymptomOnset"
                                        runat="server"
                                        Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_Text %>"
                                        ToolTip="<%$ Resources: Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"></asp:Label>
                                    <eidss:CalendarInput ID="txtDateofSymptomOnset" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                </div>
                                <div class="form-group">
                                    <h4><%= GetLocalResourceObject("LblName") %></h4>
                                    <div class="row">
                                        <div class="col-md-5">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label
                                                AssociatedControlID="txtFirstName"
                                                ID="lblFirstName"
                                                runat="server"
                                                Text="<%$ Resources:Lbl_First_Name_Text %>"
                                                ToolTip="<%$ Resources: Labels, Lbl_First_Name_ToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="col-md-2">
                                            <asp:Label
                                                AssociatedControlID="txtMiddleName"
                                                ID="lblMiddleName"
                                                runat="server"
                                                Text="<%$ Resources:Labels, Lbl_Second_Name_Text %>"
                                                ToolTip="<%$ Resources: Labels, Lbl_Second_Name_ToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="col-md-5">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label
                                                AssociatedControlID="txtLastName"
                                                ID="lblLastName"
                                                runat="server"
                                                Text="<%$ Resources:Labels, Lbl_Family_Name_Text %>"
                                                ToolTip="<%$ Resources:Labels, Lbl_Family_Name_ToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <h4><%= GetGlobalResourceObject("Labels", "Lbl_Current_Address_Text") %> </h4>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label runat="server" ID="lbl" AssociatedControlID="ddlCurrentCountry" Text="<%$ Resources:Labels, Lbl_Country_Text %>"></asp:Label>
                                            <asp:DropDownList runat="server" ID="ddlCurrentCountry" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlCurrentCountry_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label runat="server" ID="lblCurrentRegion" AssociatedControlID="ddlCurrentRegion" Text="<%$ Resources:Labels, Lbl_Region_Text %>"></asp:Label>
                                            <asp:DropDownList runat="server" ID="ddlCurrentRegion" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlCurrentRegion_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label runat="server" ID="lblCurrentRayon" AssociatedControlID="ddlCurrentRayon" Text="<%$ Resources:LblRayonText %>"></asp:Label>
                                            <asp:DropDownList runat="server" ID="ddlCurrentRayon" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlCurrentRayon_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" ID="lblCurrenTownOrVillage" AssociatedControlID="ddlCurrentTownOrVillage" Text="<%$ Resources:LblTownOrVillageText %>"></asp:Label>
                                    <asp:DropDownList runat="server" ID="ddlCurrentTownOrVillage" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlCurrentTownOrVillage_SelectedIndexChanged"></asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblCurrentStreetAddress1" runat="server" AssociatedControlID="txtCurrentStreetAddress1" Text="<%$ Resources:lblStreetAddress1Text %>"></asp:Label>
                                    <asp:TextBox ID="txtCurrentStreetAddress1" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblCurrentStreetAddress2" runat="server" AssociatedControlID="txtCurrentStreetAddress2" Text="<%$ Resources:lblStreetAddress2Text %>"></asp:Label>
                                    <asp:TextBox ID="txtCurrentStreetAddress2" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label runat="server" ID="lblCurrentPostalCode" AssociatedControlID="ddlCurrentPostalCode" Text="<%$ Resources:LblPostalCodeText %>"></asp:Label>
                                            <asp:DropDownList runat="server" ID="ddlCurrentPostalCode" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label ID="lblCurrentLatitude" runat="server" AssociatedControlID="txtCurrentLatitude" Text="<%$ Resources:Labels, Lbl_Latitude_Text %>"></asp:Label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span></span>
                                                <eidss:NumericSpinner ID="txtCurrentLatitude" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                            <asp:Label ID="lblCurrentLongitude" runat="server" AssociatedControlID="txtCurrentLongitude" Text="<%$ Resources:Labels, Lbl_Longitude_Text %>"></asp:Label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span></span>
                                                <eidss:NumericSpinner ID="txtCurrentLongitude" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" Text="<%$ Resources:LblAnotherAddressText %>"></asp:Label>
                                    <div class="col-md-12">
                                        <div class="radio-inline">
                                            <input type="radio" id="rdbAnotherAddressYes" name="AnotherAddress" value="<%= GetGlobalResourceObject("Labels", "Lbl_Date_of_Symptom_Onset_ToolTip") %>" /><label><%= GetLocalResourceObject("LblYes") %></label>
                                        </div>
                                        &nbsp;
                                        <div class="radio-inline">
                                            <input type="radio" id="rdbAnotherAddressNo" name="AnotherAddress" value="<%= GetGlobalResourceObject("Labels", "Lbl_No_Text") %>" /><label><%= GetLocalResourceObject("LblNo")%></label>
                                        </div>
                                    </div>
                                </div>
                                <div id="otherAddress">
                                    <div class="form-group">
                                        <asp:Label runat="server" Text="<%$ Resources:LblOtherAddress %>"></asp:Label>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label runat="server" ID="lblOtherCountry" AssociatedControlID="ddlOtherCountry" Text="<%$ Resources:Labels, Lbl_Country_Text %>"></asp:Label>
                                                <asp:DropDownList runat="server" ID="ddlOtherCountry" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlOtherCountry_SelectedIndexChanged"></asp:DropDownList>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label runat="server" ID="lblOtherRegion" AssociatedControlID="ddlOtherRegion" Text="<%$ Resources:Labels, Lbl_Region_Text %>"></asp:Label>
                                                <asp:DropDownList runat="server" ID="ddlOtherRegion" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlOtherRegion_SelectedIndexChanged"></asp:DropDownList>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label runat="server" ID="lblOtherRayon" AssociatedControlID="ddlOtherRayon" Text="<%$ Resources:LblRayonText %>"></asp:Label>
                                                <asp:DropDownList runat="server" ID="ddlOtherRayon" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlOtherRayon_SelectedIndexChanged"></asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                        <asp:Label runat="server" ID="lblOtherTownOrVillage" AssociatedControlID="ddlOtherTownOrVillage" Text="<%$ Resources:LblTownOrVillageText %>"></asp:Label>
                                        <asp:DropDownList runat="server" ID="ddlOtherTownOrVillage" CssClass="form-control" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlOtherTownOrVillage_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="lblOtherStreetAddress1" runat="server" AssociatedControlID="txtOtherStreetAddress1" Text="<%$ Resources:LblStreetAddress1Text %>"></asp:Label>
                                        <asp:TextBox ID="txtOtherStreetAddress1" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="lblOtherStreetAddress2" runat="server" AssociatedControlID="txtOtherStreetAddress2" Text="<%$ Resources:LblStreetAddress2Text %>"></asp:Label>
                                        <asp:TextBox ID="txtOtherStreetAddress2" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label runat="server" ID="lblOtherPostalCode" AssociatedControlID="ddlOtherPostalCode" Text="<%$ Resources:LblPostalCodeText %>"></asp:Label>
                                                <asp:DropDownList runat="server" ID="ddlOtherPostalCode" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label ID="lblOtherLatitude" runat="server" AssociatedControlID="txtOtherLatitude" Text="<%$ Resources:Labels, Lbl_Latitude_Text %>"></asp:Label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span></span>
                                                    <eidss:NumericSpinner ID="txtOtherLatitude" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="glyphicon glyphicon-asterisk text-danger"></span>
                                                <asp:Label ID="lblOtherLongitude" runat="server" AssociatedControlID="txtOtherLongitude" Text="<%$ Resources:Labels, Lbl_Longitude_Text %>"></asp:Label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span></span>
                                                    <eidss:NumericSpinner ID="txtOtherLongitude" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="alert alert-warning">
                            <div class="row">
                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                    <div class="text-danger glyphicon glyphicon-circle"></div>
                                </div>
                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                    <h5><%= GetLocalResourceObject("Warning") %></h5>
                                    <p><%= GetLocalResourceObject("PleaseNote") %></p>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                    <MenuItems>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab="0"
                            ID="sideBarItemDetails"
                            IsActive="true"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_Details_of_Urgent_Notification"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-file"
                            GoToTab="1"
                            ID="sideBarItemReview"
                            IsActive="true"
                            ItemStatus="IsReview"
                            meta:resourcekey="Tab_Review"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab=""
                            Href="CaseInvestigation.aspx"
                            ID="sideBarItemCaseInvestigation"
                            IsActive="false"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_Case_Investigation"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab=""
                            Href=""
                            ID="sideBarItemCaseOutcome"
                            IsActive="false"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_Case_Outcome"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab=""
                            Href=""
                            ID="sideBarItemCaseClosed"
                            IsActive="false"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_Case_Closed"
                            runat="server">
                        </eidss:SideBarItem>
                    </MenuItems>
                </eidss:SideBarNavigation>
            </div>
            <div class="row">
                <div class="col-md-6 col-md-offset-1 text-center">
                    <input
                        class="btn btn-default"
                        id="btnCancel"
                        onclick="location.replace('Dashboard.aspx')"
                        value="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %>"
                        type="button" />
                    <input type="button" id="btnPreviousSection" value="<%= GetGlobalResourceObject("Buttons", "Btn_Back_Text") %>" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                    <input type="button" id="btnNextSection" value="<%= GetGlobalResourceObject("Buttons", "Btn_Next_Text") %>" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                    <asp:Button runat="server" Text="<%$ Resources:Buttons, Btn_Submit_Text %>" ID="btnSubmit" CssClass="btn btn-primary hidden" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />


    <script type="text/javascript">
        $(function () {
            setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
            $('#otherAddress').hide();
            $('input:radio[name="AnotherAddress"]').click(function () {
                var anotherAddress = $('input:radio[name="AnotherAddress"]:checked').val();
                if (anotherAddress == "Yes")
                    $('#otherAddress').show();
                else
                    $('#otherAddress').hide();
            });
        });
    </script>
</asp:Content>
