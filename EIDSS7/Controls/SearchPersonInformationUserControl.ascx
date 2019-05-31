<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchPersonInformationUserControl.ascx.vb" Inherits="EIDSS.SearchPersonInformationUserControl" %>
<%@ Register Src="HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>

<asp:UpdatePanel ID="upSearchPerson" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnDeduplicate" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="ddlPersonalIDType" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfidfUserID" runat="server" />
        <asp:HiddenField ID="hdfidfInstitution" runat="server" />
        <asp:HiddenField ID="hdfSelectMode" runat="server" Value="" />
        <asp:HiddenField ID="hdfUseHumanMasterIndicator" runat="server" Value="" />
        <div id="divSelectedRecords" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSelectedRecords" class="header" runat="server" meta:resourcekey="Hdg_Deduplicate_Records"></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:UpdatePanel ID="upSelectedRecords" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvSelectedRecords" EventName="RowCommand" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView 
                                    ID="gvSelectedRecords" 
                                    runat="server" 
                                    AllowSorting="True" 
                                    AutoGenerateColumns="False" 
                                    CssClass="table table-striped" 
                                    DataKeyNames="EIDSSPersonID, HumanMasterID, LastOrSurname, FirstOrGivenName, PersonalID, PersonIDTypeName, DateOfBirth, GenderTypeName, RayonName" 
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
                                                <asp:LinkButton ID="btnSelectHumanMaster" runat="server" Text='<%# Eval("EIDSSPersonID") %>' CommandName="Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CausesValidation="false"></asp:LinkButton>
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
                                                <asp:UpdatePanel ID="upDelete" runat="server">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnDelete" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" meta:resourceKey="Btn_Delete" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="icon" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                            <asp:Button ID="btnCancelForm" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" visible="false" />
                            <asp:Button runat="server" ID="btnDeduplicate" CssClass="btn btn-default" meta:resourcekey="Btn_Deduplicate" visible="false" />
                        </div>
                    </div>
                </div>   
            </div>
        </div>
        <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
            <div id="divPersonSearchUserControlCriteria" runat="server" class="row embed-panel">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                <h3 id="hdgSearchCriteria" class="header" runat="server" meta:resourcekey="Hdg_Person_Search"></h3>
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
                                        <label for="txtLastOrSurname" runat="server" meta:resourcekey="Lbl_Last_Name"><% =GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                        <asp:TextBox ID="txtLastOrSurname" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtLastOrSurname" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Last_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-3 col-xs-3" runat="server" meta:resourcekey="Dis_Middle_Name">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Middle_Name"></span>
                                        <label id="lblSecondName" for="txtSecondName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Middle_Name_Text") %></label>
                                        <asp:TextBox ID="txtSecondName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtSecondName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Second_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="Dis_First_Name">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_First_Name"></span>
                                        <label for="txtFirstOrGivenName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                        <asp:TextBox ID="txtFirstOrGivenName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtFirstOrGivenName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_First_Name" runat="server" EnableClientScript="true" ValidationGroup="SearchPerson"></asp:RequiredFieldValidator>
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
        </asp:Panel>
        <div id="divPersonSearchResults" class="row embed-panel" runat="server">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <h3 id="hdrSearchResults" class="heading" runat="server" meta:resourcekey="Hdg_Person_Information_List"></h3>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <asp:UpdatePanel ID="upSearchResults" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvHumanMaster" EventName="RowCommand" />
                            <asp:AsyncPostBackTrigger ControlID="gvHumanMaster" EventName="Sorting" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView 
                                    ID="gvHumanMaster" 
                                    runat="server" 
                                    AllowSorting="True" 
                                    AutoGenerateColumns="False" 
                                    CssClass="table table-striped" 
                                    DataKeyNames="EIDSSPersonID, HumanMasterID" 
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
                                                <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSPersonID") %>' CommandName="Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CausesValidation="false"></asp:LinkButton>
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
                                                <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnToggleSelect" />
                                                    </Triggers>
                                                    <ContentTemplate>                                                        
                                                        <asp:LinkButton ID="btnToggleSelect" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="icon" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div id="divPager" class="row grid-footer" runat="server">
                                <div class="col col-lg-3 pull-left">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-md-auto text-center">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col col-lg-3 pull-right">
                                    <asp:Repeater ID="rptPager" runat="server">
                                        <ItemTemplate>
                                            <asp:UpdatePanel ID="upPersonPager" runat="server" RenderMode="Inline">
                                                <ContentTemplate>
                                                    <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20"></asp:LinkButton>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <div class="modal-footer text-center">
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchPerson" />
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
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $("#divPersonSearchCriteriaForm").collapse('show');
                }
            }

            function hidePersonSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $("#divPersonSearchCriteriaForm").collapse('hide');
            }

            function showPersonSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $("#divPersonSearchCriteriaForm").collapse('show');
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>