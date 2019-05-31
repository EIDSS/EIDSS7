<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="TemplateForNewForms.aspx.vb" Inherits="EIDSS.TemplateForNewForms" %>

<%--*******************************************************************************************************************************
    **********  note:  This is only a template.  This will need to be tweaked and modified to meet the requirements of the UX design and the BA's requirements,
    **********  however; it should provide you with a strong starting point or at least good insight into how things should be laid out.
    **********  Provided as many notes as I could think of.  Please reach out to me with any questions - Evander
    *******************************************************************************************************************************
    <asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">

   <!-- This content Place holder should not be used -->

</asp:Content>--%>


<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <!--  There is ONE panel sorrounding the entire contents of the page.  This is so that we can have a uniform look and a single page title regardless of what 
        we may be displaying at any given time -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2 runat="server" meta:resourcekey="hdg_Page_Name"></h2>
            <!--  DON'T forget to add the meta keys to resource file-->
        </div>
        <div class="panel-body">
            <asp:UpdateProgress runat="server">
                <ProgressTemplate>
                    <!-- this meta tag allows admin to hide the modal-->
                    <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                        <div class="modal-content">
                            <div class="modal-body">
                                <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                            </div>
                        </div>
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <!--  <Triggers> below: here you need to define buttons that should trigger full postbacks; Especially important when displaying 
                        section tags that have a location control where the map is displaying.  Notice that both events that trigger the display
                        of the detail section are marked as Synchronous Post Backs -->
            
            <asp:UpdatePanel runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="gvSearchResults" />
                    <asp:PostBackTrigger ControlID="addNewRecord" />
                </Triggers>
                <ContentTemplate>
                    <div id="searchForm" runat="server" class="row embed-panel" visible="false">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                    <!-- resource key  should start with HDG_; e.g. hdg_panel_... -->
                                    <h3 class="heading" runat="server" meta:resourcekey="Hdg_Search_Form"></h3>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 text-right">
                                    <!-- This button's visibility is false and must be managed on server-side events to be displayed when
                                        the search results are visible-->
                                    <asp:LinkButton ID="btnEditSearch" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Edit_Search" Visible="false" />
                                </div>
                            </div>
                            <div class="panel-body">
                                <!--  The structure of the contents of this panel should be made of bootstrap rows with columns
                                    The columns that sorround the label/input pairs must have a meta tag that begins with the 
                                    prefix DIS-->
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_search_input">
                                        <asp:Label runat="server" AssociatedControlID="samplesearchInput" meta:resourcekey="Lbl_search_input"></asp:Label>
                                        <asp:TextBox ID="samplesearchInput" runat="server"></asp:TextBox>
                                        <!-- These inputs should be enabled or disabled based on the visibility of the results-->
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                        <!-- add rows and columns as necessary;  modify col class as needed to achieve required look -->
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                        <a href="../Dashboard.aspx" class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard"></a>
                                        <!-- Events for button clicks are handled on code behind -->
                                        <asp:Button ID="btnClear" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Clear" />
                                        <asp:Button ID="btnSearchList" CssClass="btn btn-primary" runat="server" meta:resourcekey="btn_Search" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="searchresults" class="row embed-panel" runat="server" visible="false">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 text-right">
                                        <asp:Button ID="addNewRecord" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_add_New_Record"></asp:Button>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <!--EmptyDataText attribute: Manage with Resource Key: grd_search_results.EmptyDataText
                                Caption for Grid is also managed by Resource Key -->
                                    <!-- Various column types exist; however the command buttons to edit/delete records appear 
                                        always at the end-->
                                    <eidss:GridView
                                        AutoGenerateColumns="false"
                                        AllowPaging="true"
                                        AllowSorting="true"
                                        CssClass="table table-striped table-hover"
                                        GridLines="None"
                                        ID="gvSearchResults"
                                        meta:resourcekey="grd_search_results"
                                        PageSize="10"
                                        RowStyle-CssClass="table"
                                        runat="server"
                                        ShowHeaderWhenEmpty="true"
                                        ShowFooter="True">
                                        <HeaderStyle CssClass="table-striped-header" />
                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />

                                        <Columns>
                                            <asp:CommandField
                                                AccessibleHeaderText="<%$ Resources:Grd_Edit_Button_Text %>"
                                                ControlStyle-CssClass="btn glyphicon glyphicon-edit"
                                                EditText=""
                                                ShowEditButton="true" />
                                            <asp:CommandField
                                                AccessibleHeaderText="<%$ Resources:Grd_Delete_Button_Text %>"
                                                ControlStyle-CssClass="btn glyphicon glyphicon-trash"
                                                DeleteText=""
                                                ShowDeleteButton="true" />
                                        </Columns>
                                    </eidss:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="idrelevantTothis" class="row embed-panel" runat="server" visible="false">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 runat="server" meta:resourcekey="pnl_Detail_Panel"></h3>
                            </div>
                            <div class="panel-body">
                                <!--Notice one panel for all the sections, but the headings and bodies 
                            are defined inside the sections-->

                                <div class="sectionContainer expanded">
                                    <section id="sectionid" runat="server" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-10 col-xs-10">
                                                    <!-- Please do update/change the meta tag with some relevant name -->
                                                    <h3 runat="server" meta:resourcekey="hdg_some_heading_name"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-2 col-xs-2"></div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <!--Notice that the following input groups have containers that manage visibility as well as 
                                        required icons and validators.  The container meta key starts with the abbreviation DIS_ and 
                                        uses a .Visible attribute (e.g. Dis_Some_ID_Key.Visible)-->
                                            <div class="form-group">
                                                <div class="row">
                                                    <!-- This is a regular data entry field column-->
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12"
                                                        runat="server"
                                                        meta:resourcekey="dis_input_field">
                                                        <!-- THIS DIV is only to show an asterisk when a field is required.  its Resource 
                                                         Key should start with the abbreviation REQ_ and the attribute Visible.  (e.g.
                                                         Req_Some_ID_Key.Visible).  The default value in the resource file should be false.  It is
                                                         up to the system admin to make something required.-->
                                                        <div class="glyphicon glyphicon-asterisk alert-danger"
                                                            meta:resourcekey="Req_Outbreak_ID"
                                                            runat="server">
                                                        </div>
                                                        <!-- the label should have the .Text and .ToolTip attributes populated by the meta tag -->
                                                        <asp:Label AssociatedControlID="someID" runat="server" meta:resourcekey="lbl_input_field"></asp:Label>
                                                        <asp:TextBox ID="someID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <!-- Note that the validation control could be a REGEX validator or even a Custom Validator
                                                    based on requirements; however, current requirements only call for required validator.
                                                    The Resource key should start with the prefix VAL_ and the validation group should be 
                                                    the ID of the section; in addition the meta tag should  have the following attributes managed
                                                        by the resource file:  .Enabled = false; .ErrorMessage = error; .Text = error -->
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="someID"
                                                            CssClass="alert-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_input_field"
                                                            runat="server"
                                                            ValidationGroup="sectionid"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <!-- This is a column that is required by the DB -->
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                        <!-- DB Required fields can't be edited by the Admin, so no meta tag is required-->
                                                        <div class="glyphicon glyphicon-certificate alert-danger"></div>
                                                        <asp:Label AssociatedControlID="dbRequiredTextField" runat="server" meta:resourcekey="lbl_db_field"></asp:Label>
                                                        <asp:TextBox ID="dbRequiredTextField" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <!-- as above; however the DB required field DOES NOT use the .Enabled attribute. so the Admin can't change
                                                        it's behavior -->
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="someID"
                                                            CssClass="alert-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_db_field"
                                                            runat="server"
                                                            ValidationGroup="sectionid"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                        </div>
                                    </section>
                                    <section id="section2id" runat="server" class="">
                                        <!--  Some other Section can be added here -->
                                    </section>
                                </div>
                                <!-- GoToTab: used to identify the section that this tab navigates to zero based -->
                                <!-- Href:   Only used if you need to take user to another page -->
                                <!-- IsActive:  True or False; it indicates if the tab will have functionality on the client or is just there for looks -->
                                <!-- ItemStatus:  IsNormal(is default value),IsInvalid (if server validation fails), IsValid (if validation passes), IsReview for Review Tab -->
                                <!-- Meta key manages Text and ToolTip attributes-->
                                <!-- the tab id for review is always one number greater than the count of section tabs; zero based -->
                                <eidss:SideBarNavigation runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="0"
                                            Href=""
                                            IsActive="True"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="pnl_something"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-ok"
                                            GoToTab="1"
                                            Href=""
                                            IsActive="True"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="pnl_something_2"
                                            runat="server">
                                        </eidss:SideBarItem>
                                        <eidss:SideBarItem
                                            CssClass="glyphicon glyphicon-file"
                                            GoToTab="2"
                                            IsActive="true"
                                            ItemStatus="IsNormal"
                                            meta:resourcekey="pnl_review_tab"
                                            runat="server">
                                        </eidss:SideBarItem>
                                    </MenuItems>
                                </eidss:SideBarNavigation>

                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                        <!-- Where the cancel button takes you Is dependent of the use case/UX design -->
                                        <asp:Button ID="btnCancel" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel" />
                                        <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                        <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                        <!-- Client redirect after successful submit is handled in the server -->
                                        <asp:Button ID="btnSubmit" runat="server" meta:resourcekey="btn_Submit" class="btn btn-primary" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>


</asp:Content>
