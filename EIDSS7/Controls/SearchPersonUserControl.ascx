<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchPersonUserControl.ascx.vb" Inherits="EIDSS.SearchPersonUserControl" %>
<%@ Register Src="HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
    <asp:UpdatePanel ID="upSearchPerson" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlPersonalIDType" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
            <asp:HiddenField ID="hdfUseHumanMasterIndicator" runat="server" Value="" />
            <div id="divPersonSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Criteria_Text") %></h3>
                            </div>
                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                <a href="#divPersonSearchCriteriaForm" data-toggle="collapse" data-parent="#divPersonSearchUserControlCriteria" onclick="togglePersonSearchCriteria(event);">
                                    <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div id="divPersonSearchCriteriaForm" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="form-group">
                                <p><%= GetLocalResourceObject("Page_Text_1") %></p>
                                <div class="row vertical-align-middle">
                                    <div class="col-lg-4 col-md-4 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Person_ID">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Person_ID"></span>
                                        <label runat="server" for="txtEIDSSPersonID" meta:resourcekey="Lbl_Person_ID"></label>
                                        <asp:TextBox ID="txtEIDSSPersonID" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-center" meta:resourcekey="Dis_Search_Text_OR">
                                        <%= GetLocalResourceObject("Page_Text_3") %>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4" runat="server" meta:resourcekey="Dis_Personal_ID_Type">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Personal_ID_Type"></span>
                                        <label for="ddlPersonalIDType" runat="server" meta:resourcekey="Lbl_Personal_ID_Type"></label>
                                        <asp:DropDownList ID="ddlPersonalIDType" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlPersonalIDType" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Personal_ID_Type" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Personal_ID">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Personal_ID"></span>
                                        <label for="txtPersonalID" runat="server" meta:resourcekey="Lbl_Personal_ID"></label>
                                        <asp:TextBox ID="txtPersonalID" runat="server" CssClass="form-control" Enabled="false" MaxLength="100"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtPersonalID" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Personal_ID" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label runat="server" for="hdfName" meta:resourcekey="Lbl_Name"></label>
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-5 col-xs-5" runat="server" meta:resourcekey="Dis_Last_Name">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Last_Name"></span>
                                        <label for="txtLastOrSurname" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                        <asp:TextBox ID="txtLastOrSurname" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtLastOrSurname" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Last_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="Dis_First_Name">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_First_Name"></span>
                                        <label for="txtFirstOrGivenName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                        <asp:TextBox ID="txtFirstOrGivenName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtFirstOrGivenName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_First_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Middle_Name">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Middle_Name"></span>
                                        <label id="lblSecondName" for="txtSecondName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Middle_Name_Text") %></label>
                                        <asp:TextBox ID="txtSecondName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtSecondName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Second_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <fieldset>
                                <legend runat="server" meta:resourcekey="Lbl_Date_Of_Birth_Range_Text"></legend>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4" runat="server" meta:resourcekey="Dis_Date_Of_Birth_From">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Date_Of_Birth_From"></span>
                                            <label for="<% =txtDateOfBirthFrom.ClientID %>"><% =GetGlobalResourceObject("Labels", "Lbl_From_Text") %></label>
                                            <eidss:CalendarInput ID="txtDateOfBirthFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" LinkedPickerID="EIDSSBodyCPH_ucSearchPerson_txtDateOfBirthTo" />
                                            <asp:RequiredFieldValidator ControlToValidate="txtDateOfBirthFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Of_Birth_From" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="cvFutureBirthDateFrom" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtDateOfBirthFrom" meta:resourcekey="Val_Future_Birth_Date_From" Operator="LessThanEqual" Type="Date" ValidationGroup="SearchPerson" SetFocusOnError="True"></asp:CompareValidator>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4" runat="server" meta:resourcekey="Dis_Date_Of_Birth_To">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Date_Of_Birth_To"></span>
                                            <label for="<% =txtDateOfBirthTo.ClientID %>"><% =GetGlobalResourceObject("Labels", "Lbl_To_Text") %></label>
                                            <eidss:CalendarInput ID="txtDateOfBirthTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ControlToValidate="txtDateOfBirthTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Of_Birth_To" runat="server" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="cvDateOfBirthRange" runat="server" CssClass="text-danger" ControlToCompare="txtDateOfBirthTo" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtDateOfBirthFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Date_Of_Birth_Compare" ValidationGroup="SearchPerson"></asp:CompareValidator>
                                            <asp:CompareValidator ID="cvFutureBirthDateTo" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtDateOfBirthTo" meta:resourcekey="Val_Future_Birth_Date_To" Operator="LessThanEqual" Type="Date" ValidationGroup="SearchPerson" SetFocusOnError="True"></asp:CompareValidator>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Gender">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Gender"></span>
                                        <label runat="server" for="ddlGenderTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Gender_Text") %></label>
                                        <asp:DropDownList ID="ddlGenderTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlGenderTypeID" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Gender" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <eidss:Location ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowSettlementType="false" ShowSettlement="false" IsHorizontalLayout="true" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
<div class="modal-footer text-center">
    <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchPerson" />
</div>
<asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnAddPerson" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="gvHumanMaster" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvHuman" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvHumanMaster" EventName="Sorting" />
        <asp:AsyncPostBackTrigger ControlID="gvHuman" EventName="Sorting" />
    </Triggers>
    <ContentTemplate>
        <div id="divPersonSearchResults" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSearchResults" class="header"><% =GetGlobalResourceObject("Labels", "Lbl_Search_Results_Text") %></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <asp:GridView
                            ID="gvHumanMaster"
                            runat="server"
                            AllowSorting="True"
                            AutoGenerateColumns="False"
                            CssClass="table table-striped"
                            DataKeyNames="HumanMasterID"
                            ShowHeaderWhenEmpty="true"
                            ShowHeader="true"
                            EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>"
                            ShowFooter="true"
                            GridLines="None"
                            AllowPaging="true"
                            PagerSettings-Visible="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <PagerSettings Visible="False" />
                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Person_ID_Text %>" SortExpression="EIDSSPersonID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblHumanMasterEIDSSPersonID" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "9", True, False) %>'></asp:Label>
                                        <asp:LinkButton ID="btnSelectHumanMaster" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("HumanMasterID").ToString() + "|" + Eval("EIDSSPersonID") + "|" + Eval("FullName") + "|" + Eval("FirstOrGivenName") + "|" + Eval("LastOrSurname") %>' CausesValidation="false"></asp:LinkButton>
                                        <asp:LinkButton ID="btnViewHumanMaster" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("HumanMasterID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                        <br />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="LastOrSurname" ReadOnly="true" SortExpression="LastOrSurname" HeaderText="<%$ Resources: Labels, Lbl_Last_Name_Text %>" />
                                <asp:BoundField DataField="FirstOrGivenName" ReadOnly="true" SortExpression="FirstOrGivenName" HeaderText="<%$ Resources: Labels, Lbl_First_Name_Text %>" />
                                <asp:BoundField DataField="PersonalID" ReadOnly="true" SortExpression="PersonalID" HeaderText="<%$ Resources: Labels, Lbl_Personal_ID_Text %>" />
                                <asp:BoundField DataField="PersonIDTypeName" ReadOnly="true" SortExpression="PersonIDTypeName" HeaderText="<%$ Resources: Labels, Lbl_Personal_ID_Type_Text %>" />
                                <asp:BoundField DataField="DateOfBirth" ReadOnly="true" SortExpression="DateOfBirth" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources: Labels, Lbl_Date_Of_Birth_Text %>" />
                                <asp:BoundField DataField="GenderTypeName" ReadOnly="true" SortExpression="GenderTypeName" HeaderText="<%$ Resources: Labels, Lbl_Gender_Text %>" />
                                <asp:BoundField DataField="RayonName" ReadOnly="true" SortExpression="RayonName" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                    <ItemTemplate>
                                        <asp:UpdatePanel ID="upEditHumanMaster" runat="server">
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="btnEditHumanMaster" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <asp:LinkButton ID="btnEditHumanMaster" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("HumanMasterID") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="icon" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <span class="glyphicon glyphicon-triangle-bottom" onclick="showPersonSubGrid(event,'divPerson<%# Eval("HumanMasterID") %>');"></span>
                                        <tr id="divPerson<%# Eval("HumanMasterID") %>" style="display: none;">
                                            <td colspan="11" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                <div class="expand-grid-row">
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Citizenship_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridCitizenshipTypeName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("CitizenshipTypeName") %>' />
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Country_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridCountryName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("CountryName") %>' />
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Region_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridRegionName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("RegionName") %>'></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Rayon_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridRayonName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("RayonName") %>'></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-8 col-md-8 col-sm-6 col-xs-6">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Street_Address_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridFormattedAddressString" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("FormattedAddressString") %>' />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:GridView ID="gvHuman" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="HumanID" ShowHeaderWhenEmpty="true" ShowHeader="true" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="False" GridLines="None" AllowPaging="true" PagerSettings-Visible="false">
                            <HeaderStyle CssClass="table-striped-header" />
                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources: Labels, Lbl_Person_ID_Text %>" SortExpression="EIDSSPersonID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEIDSSPersonID" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "9", True, False) %>'></asp:Label>
                                        <asp:LinkButton ID="btnSelectHuman" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "7", True, False) %>' CommandName="Select" CommandArgument='<%# Eval("HumanID").ToString() + "|" + Eval("EIDSSPersonID") + "|" + Eval("FullName") + "|" + Eval("FirstOrGivenName") + "|" + Eval("LastOrSurname") %>' CausesValidation="false"></asp:LinkButton>
                                        <asp:LinkButton ID="btnViewHuman" runat="server" Text='<%# Eval("EIDSSPersonID") %>' Visible='<%# IIf(hdfSelectMode.Value = "8", True, False) %>' CommandName="View" CommandArgument='<%# Eval("HumanID").ToString() %>' CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="LastOrSurname" ReadOnly="true" SortExpression="LastOrSurname" HeaderText="<%$ Resources: Labels, Lbl_Last_Name_Text %>" />
                                <asp:BoundField DataField="FirstOrGivenName" ReadOnly="true" SortExpression="FirstOrGivenName" HeaderText="<%$ Resources: Labels, Lbl_First_Name_Text %>" />
                                <asp:BoundField DataField="PersonalID" ReadOnly="true" SortExpression="PersonalID" HeaderText="<%$ Resources: Labels, Lbl_Personal_ID_Text %>" />
                                <asp:BoundField DataField="PersonIDTypeName" ReadOnly="true" SortExpression="PersonIDTypeName" HeaderText="<%$ Resources: Labels, Lbl_Personal_ID_Type_Text %>" />
                                <asp:BoundField DataField="DateOfBirth" ReadOnly="true" SortExpression="DateOfBirth" DataFormatString="{0:MM/dd/yyyy}" HeaderText="<%$ Resources: Labels, Lbl_Date_Of_Birth_Text %>" />
                                <asp:BoundField DataField="GenderTypeName" ReadOnly="true" SortExpression="GenderTypeName" HeaderText="<%$ Resources: Labels, Lbl_Gender_Text %>" />
                                <asp:BoundField DataField="RayonName" ReadOnly="true" SortExpression="RayonName" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" />
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <span class="glyphicon glyphicon-triangle-bottom" onclick="showPersonSubGrid(event,'divPerson<%# Eval("HumanID") %>');"></span>
                                        <tr id="divPerson<%# Eval("HumanID") %>" style="display: none;">
                                            <td colspan="9" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                <div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Citizenship_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridCitizenshipTypeName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("CitizenshipTypeName") %>' />
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Age_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridAge" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("Age") %>'></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Phone_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridPhone" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("ContactPhoneNumber") %>'></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Country_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridCountryName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("CountryName") %>' />
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Region_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridRegionName" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("RegionName") %>'></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group form-group-sm">
                                                        <div class="row">
                                                            <div class="col-lg-8 col-md-8 col-sm-6 col-xs-6">
                                                                <label><% =GetGlobalResourceObject("Labels", "Lbl_Street_Address_Text") %></label>
                                                                <asp:TextBox ID="txtSubGridFormattedAddressString" CssClass="form-control" runat="server" Enabled="false" Text='<%# Bind("FormattedAddressString") %>' />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <div id="divPager" class="row grid-footer" runat="server">
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left">
                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblPageNumber" runat="server" CssClass="control-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                <asp:Repeater ID="rptPager" runat="server">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20" CausesValidation="false"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<div class="modal-footer text-center">
    <asp:UpdatePanel ID="upCancel" runat="server" UpdateMode="Conditional" RenderMode="Inline">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Button ID="btnAddPerson" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add_Person" CausesValidation="false" />
</div>
<script type="text/javascript">
    function showPersonSubGrid(e, f) {
        var cl = e.target.className;
        if (cl == 'glyphicon glyphicon-triangle-bottom') {
            e.target.className = "glyphicon glyphicon-triangle-top";
            $('#' + f).show();
        }
        else {
            e.target.className = "glyphicon glyphicon-triangle-bottom";
            $('#' + f).hide();
        }
    };

    function togglePersonSearchCriteria(e) {
        var cl = e.target.className;
        if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
            $('#<%= btnClear.ClientID %>').show();
            $('#<%= btnSearch.ClientID %>').show();
            $("#divPersonSearchCriteriaForm").collapse('hide');
            $('#<%= btnCancel.ClientID %>').hide();
            $('#<%= btnAddPerson.ClientID %>').hide();
        }
        else {
            e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button"
            $('#<%= btnClear.ClientID %>').hide();
            $('#<%= btnSearch.ClientID %>').hide();
            $("#divPersonSearchCriteriaForm").collapse('show');
            $('#<%= btnCancel.ClientID %>').show();
            $('#<%= btnAddPerson.ClientID %>').show();
        }
    }

    function hidePersonSearchCriteria() {
        $('#<%= btnClear.ClientID %>').hide();
        $('#<%= btnSearch.ClientID %>').hide();
        $("#divPersonSearchCriteriaForm").collapse('hide');
        $('#<%= btnCancel.ClientID %>').show();
        $('#<%= btnAddPerson.ClientID %>').show();
    }

    function showPersonSearchCriteria() {
        $('#<%= btnClear.ClientID %>').show();
        $('#<%= btnSearch.ClientID %>').show();
        $("#divPersonSearchCriteriaForm").collapse('show');
        $('#<%= btnCancel.ClientID %>').hide();
        $('#<%= btnAddPerson.ClientID %>').hide();
    }

function hideCancelAndAddPersonButtons() {
        $('#<%= btnCancel.ClientID %>').hide();
        $('#<%= btnAddPerson.ClientID %>').hide();
    }

</script>
