<%@ Page Title="ILIAggregate" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ILIAggregate.aspx.vb" Inherits="EIDSS.ILIAggregate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
 
    <asp:UpdatePanel ID="upILIAgg" runat="server" UpdateMode="Conditional">
        <Triggers></Triggers>
        <ContentTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="Hdg_ILIAgg"></h2>
                </div>
 <%--               <div class="panel-body">--%>

<asp:UpdatePanel ID="upDateSearchILIAgg" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:PostBackTrigger ControlID="btnAddILIAgg" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="gvILIAggs" EventName="RowCommand" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" visible="false">
            <asp:HiddenField ID="hdfidfsCountry" runat="server" />
            <asp:HiddenField ID="hdfidfAggregateHeader" runat="server" Value="0"/>
            <asp:HiddenField ID="hdfFormID" runat="server" />
            <asp:HiddenField ID="hdfSiteID" runat="server" />
            <asp:HiddenField ID="hdfLangID" runat="server"  />

            <asp:HiddenField ID="hdfidfEnteredByPerson" runat="server"  Value=" NULL" />
            <asp:HiddenField ID="hdfDisplaySelect" runat="server" Value="" />
            <asp:HiddenField ID="hdfDisplayLabel" runat="server" Value="" />
            <asp:HiddenField ID="hdfDisplayView" runat="server" Value="" />
            <asp:HiddenField runat="server" ID="hdfdatStartDate" />
            <asp:HiddenField runat="server" ID="hdfdatFinishDate" />
            <asp:HiddenField ID="hdfSearchFormID" runat="server" />
            <asp:HiddenField ID="hdfidfSearchHospital" runat="server" />
            <asp:HiddenField ID="hdfstrHospitalName" runat="server" />

            <asp:HiddenField ID="hdfidfSearchSite" runat="server" />
            <asp:HiddenField runat="server" ID="hdfILITableTypeIndex" Value="NULL" />

               <asp:HiddenField ID="hdfint0to4" runat="server" Value=""/>
            <asp:HiddenField ID="hdfint5to14" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint15to29" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint30to64" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint65toUp" runat="server" Value=""/>
           <asp:HiddenField ID="hdfintILITotal" runat="server" Value=""/>
          <asp:HiddenField ID="hdfintILITotalAdmiss" runat="server" Value=""/>
          <asp:HiddenField ID="hdfintILITotalSamples" runat="server" Value=""/>
            <asp:HiddenField ID="hdfstrFormIDEdit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfstrHospitalEdit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfidfHospitalEdit" runat="server" Value=""/>
         <asp:HiddenField ID="hdfintYearEdit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfintWeekEdit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfUserNameEdit" runat="server" Value=""/>
             <asp:HiddenField ID="hdfOrganizationEdit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfdatEntered" runat="server" Value=""/>
             <asp:HiddenField ID="hdfdatLastSaved" runat="server" Value=""/>
            <asp:HiddenField ID="hdfint0to4Edit" runat="server" Value=""/>
            <asp:HiddenField ID="hdfint5to14Edit" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint15to29Edit" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint30to64Edit" runat="server" Value=""/>
             <asp:HiddenField ID="hdfint65toUpEdit" runat="server" Value=""/>
           <asp:HiddenField ID="hdfintILITotalEdit" runat="server" Value=""/>
          <asp:HiddenField ID="hdfintILITotalAdmissEdit" runat="server" Value=""/>
          <asp:HiddenField ID="hdfintILITotalSamplesEdit" runat="server" Value=""/>
          <asp:HiddenField ID="hdfAggregateHeaderId" runat="server" Value=""/>
          <asp:HiddenField ID="hdfAggregateDetailId" runat="server" Value=""/>
                      <asp:HiddenField ID="hdfDeleteIndex" runat="server" Value=""/>
            

        </div>
        <div class="panel panel-default">
            <div class="panel-body">
                <div id="divILIAggSearchCriteria" runat="server" class="row embed-panel">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">

                                     <h3 id="hdgSearchCriteria" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                </div>
       <%--                         <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                    <span class="pull-right">
                                        <a href="#divILIAggSearchCriteriaForm" data-toggle="collapse" data-parent="#divILIAggSearchCriteria" onclick="toggleILIAggSearchCriteria(event);">
                                            <span id="btnShowSearchCriteria" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                        </a>
                                    </span>
                                </div>--%>


                            </div>
                        </div>

                        <div id="divILIAggSearchCriteriaForm" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                            <label for="<% =txtSearchformstrILIAggCode.ClientID %>" runat="server" meta:resourcekey="Lbl_ILIAggform_ID"></label>
                                            <asp:TextBox ID="txtSearchformILIAggCode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                            <div class="form-group">
                                                <div class="row">

                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_search_weeksfrom_Date">
                                                        <label runat="server" meta:resourcekey="lbl_weeksfrom_Date"></label>
                                                        <eidss:CalendarInput ID="txtdatSearchWeeksFromDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true"></eidss:CalendarInput>
                                                        <asp:CompareValidator ID="Val_Entered_Date_Compare" runat="server" CssClass="text-danger" ControlToCompare="txtdatSearchWeeksFromDate" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtdatSearchWeeksToDate" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Entered_Date_Compare" ValidationGroup="Search"></asp:CompareValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_search_weeksto_Date">
                                                        <label runat="server" meta:resourcekey="lbl_weeksto_Date"></label>
                                                        <eidss:CalendarInput ID="txtdatSearchWeeksToDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>


                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="ddlILIAggHospitalName" runat="server" meta:resourcekey="Lbl_Hospital"></label>
                                                 <asp:DropDownList ID="ddlidfILIAggHospitalName" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfILIAggHospitalName_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="txtstrILIAggDataSite" runat="server" meta:resourcekey="Lbl_DataSite_Name"></label>
                                                 <asp:DropDownList ID="ddlidfILIAggDataSite" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfILIAggDataSite_SelectedIndexChanged"></asp:DropDownList>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                            <div class="modal-footer text-center">
                                <button id="btnCancelAgg" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-toggle="modal" data-target="#divSearchCancelModal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                                <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" OnClick="btnClear_Click" />
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" CausesValidation="true" OnClick="btnSearch_Click" />
                                <asp:Button ID="btnAddILIAgg" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add_ILIAgg" CausesValidation="true" OnClick="btnNewILI_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                </div>
    <%--            Ends Search Criteria--%>

                <div id="divILIAggSearchResults" class="row embed-panel" runat="server" visible="false">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <h3 id="hdrSearchResults" class="heading" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">

                                            <div class="table-responsive">
                                                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Diseases">
                                                    <label id="searchResultsQty" runat="server"></label>
                                                </div>
                                                <eidss:GridView ID="gvILIAggs"
                                                    runat="server"
                                                    AllowPaging="True"
                                                    PagerSettings-Visible="false"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped table-hover"
                                                    DataKeyNames="strFormID"
                                                    EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" 
                                                    ShowFooter="True"
                                                    ShowHeaderWhenEmpty="True"
                                                    Onselectedindexchanged ="gvILITable_SelectedIndexChanged"
                                                    OnRowDataBound="gvILIAggs_RowDataBound"
                                                    OnRowEditing="gvILIAggs_RowEditing"
                                                    OnRowCancelingEdit="gvILIAggs_RowCancelingEdit"
                                                    OnRowUpdating="gvILIAggs_RowUpdating"
                                                    OnRowCommand="gvILIAggs_RowCommand"
                                                    OnRowDeleting="gvILIAggs_RowDeleting"
                                                    UseAccessibleHeader="true"
                                                    GridLines="None">
                                                    <EmptyDataTemplate>
                                                        <label runat="server" meta:resourcekey="lbl_No_Record"></label>
                                                    </EmptyDataTemplate>
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
<%--                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />--%>
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_FormId.InnerText %>">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblstrFormID" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                                                                <asp:LinkButton ID="lnbstrFormID" runat="server" Text='<%# Eval("strFormID") %>' Visible="false"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:TemplateField ShowHeader="False" Visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label ID="AggregateHeaderId" runat="server" Text='<%# Eval("idfAggregateHeader") %>' Visible="false"></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>


                                                        <asp:BoundField DataField="datStartDate" HeaderText="<%$ Resources:lbl_Start_Date.InnerText %>" DataFormatString="{0:d}" ReadOnly="True" SortExpression="datStartDate" />
                                                        <asp:BoundField DataField="datFinishDate" HeaderText="<%$ Resources:lbl_End_Date.InnerText %>" DataFormatString="{0:d}" ReadOnly="True" SortExpression="datFinishDate" />
                                                        <asp:BoundField DataField="HospitalName" HeaderText="<%$ Resources:lbl_HospitalName.InnerText %>"  ReadOnly="True" SortExpression="HospitalName" />

                                                   <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit"  ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowEditButton="true"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                 <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>

                                                                 <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_ILIAggregate"

                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

<%--
                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_FormId.InnerText %>"visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label ID="AggregateHeaderId" runat="server" Text='<%# Eval("idfAggregateHeader") %>'></asp:Label>
                                                                <asp:LinkButton ID="AggregateHeaderIdlnb" runat="server" Text='<%# Eval("idfAggregateHeader") %>' Visible="false"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>--%>

                                                    </Columns>
 
                                                </eidss:GridView>



                            <div class="row">
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Number_of_Records_Text") %></label>&nbsp;<asp:Label ID="lblNumberOfRecords" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>





                           </div>

                        </div>
                    </div>
 
                     <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                         <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" visible="false" meta:resourcekey="btn_Show_Search_Criteria" onclick="showSearchCriteria(event);"></span>
                       </div>
 

                </div>
         <%--       ENd Search Results--%>
                <div class="row text-center">
                     <asp:Button ID="btnNewILIAgg" runat="server" CssClass="btn btn-default" meta:resourceKey="Btn_Add_ILIAgg" CausesValidation="true" OnClick="btnNewILI_Click" visible="False"/>
                     <button id="btnCancelSearch" type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Cancel_Search" data-toggle="modal" data-target="#divSearchResultsCancelModal" visible="False"></button>
                </div>




               <%-- ILIAGG ADD or Update MOved Here--%>

                                          <div id="divILIAggregateAddEdit" class="embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="hdg_ILI_Aggregate_Case_Details" ></h3>
                                    </div>
                                    <div class="panel-body">

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"
                                                    meta:resourcekey="dis_FormId"
                                                    runat="server">
                                                     <label meta:resourcekey="lbl_FormId" runat="server"></label>
                                                  <asp:TextBox ID="txtstrFormId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                  </div>
                                              <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_Date_Entered_Date">
                                                    <label runat="server" meta:resourcekey="lbl_Date_Entered_Date"></label>
<%--                                                    <eidss:CalendarInput ID="txtdatDateEnteredDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>--%>
                                                     <asp:TextBox ID="txtdatEnteredDate" runat="server" CssClass="form-control" Enabled="false" Text='<%# String.Format("{0:d}", DateTime.Today) %>'></asp:TextBox>

                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_Last_Save_Date">

                                                    <label runat="server" meta:resourcekey="lbl_Last_Save_Date"></label>
                                                    <eidss:CalendarInput ID="txtdatLastSaveDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtdatLastSaveDate_TextChanged"></eidss:CalendarInput>


                                                </div>

                                            </div>

                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                 <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_Entered_by">
                                                    <label runat="server" meta:resourcekey="lbl_Entered_By"></label>
                                                    <asp:TextBox ID="txtstrEnteredBy" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                               <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_Site">
                                                    <label runat="server" meta:resourcekey="lbl_Site"></label>
                                                    <asp:TextBox ID="txtstrSite" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
  
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                              <div id="year" class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_ILI_Year">
                                                    <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_ILI_Year"
                                                        runat="server"></span>
                                                    <label runat="server" meta:resourcekey="lbl_ILI_Year"></label>
                                                    <eidss:DropDownList ID="ddlintYear" CausesValidation="true" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlintYear_SelectedIndexChanged" Visible="True"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valILIYear" runat="server" ControlToValidate="ddlintYear" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="valsubmit" meta:resourceKey="val_ILI_Year"></asp:RequiredFieldValidator>

                                               </div>
                                                 <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_ILI_Week">
                                                    <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_ILI_Week"
                                                        runat="server"></span>
                                                    <label runat="server" meta:resourcekey="lbl_ILI_Week"></label>
                                                    <eidss:DropDownList ID="ddlintWeek" CausesValidation="true" runat="server" CssClass="form-control" OnSelectedIndexChanged="SaveDateRangeFromDDL" AutoPostBack=" true"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valILIWeek" runat="server" ControlToValidate="ddlintWeek" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="valsubmit" meta:resourceKey="val_ILI_Week"></asp:RequiredFieldValidator>

                                               </div>

                                               <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server" meta:resourcekey="dis_ILI_Hospital">
                                                    <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_ILI_Hospital"
                                                        runat="server"></span>
                                            <label for="ddlILIAddHospitalName" runat="server" meta:resourcekey="Lbl_Hospital"></label>
                                                 <eidss:DropDownList ID="ddlILIAddHospitalName" CausesValidation="true" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfILIAggHospitalName_SelectedIndexChanged"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator ID="valILIHospital" runat="server" ControlToValidate="ddlILIAddHospitalName" CssClass="text-danger" ValidationGroup="valsubmit" InitialValue="null" meta:resourceKey="val_ILI_Hospital"></asp:RequiredFieldValidator>

                                            </div>


                                            </div>





                                        </div>
                              <div class="panel-body">

                                   <div class="panel-heading">
                                        <h5 runat="server" meta:resourcekey="hdg_ILI_Aggregate_Case_Details_Tbl"></h5>
                                    </div>

                                        <div class="form-group">
                                            <div class="row">

                                               <eidss:GridView ID="gvILITable" runat="server"
                                                    AllowPaging="True"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    DataKeyNames="inTotalILI"
                                                    EmptyDataText=""
                                                    ShowFooter="True"
                                                    ShowHeader="True"
                                                    ShowHeaderWhenEmpty="true"
                                                    GridLines="None"
                                                    OnRowDataBound="gvILITable_RowDataBound"
                                                    OnRowEditing="gvILITable_RowEditing"
                                                    OnRowCancelingEdit="gvILITable_RowCancelingEdit"
                                                    OnRowUpdating="gvILITable_RowUpdating"
                                                    OnRowCommand="gvILITable_RowCommand"
                                                    OnRowDeleting="gvILITable_RowDeleting"
                                                    UseAccessibleHeader="true">

                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        

                                                  <asp:TemplateField >

                                                    <HeaderStyle VerticalAlign="Bottom"  />
                                                    <HeaderTemplate>
                                                        <%# GetLocalResourceObject("lbl_Details.InnerText") %><br /><br />
                                                         <span class="glyphicon glyphicon-certificate text-danger"
                                                        meta:resourcekey="req_ILI_Hospital" runat="server"></span>
                                                        <label for="ddlILIAddHospitalName1" runat="server" meta:resourcekey="Lbl_HospitalName"></label><br />
                                                        <asp:DropDownList ID="ddlILIAddHospitalName1" runat="server" CssClass="form-control" Width="250" AutoPostBack="true" OnSelectedIndexChanged="ddlidfILIAggHospitalName1_SelectedIndexChanged" />

                                                    </HeaderTemplate>
                                                     <ItemTemplate>
                                                         <asp:Label ID="ddlILIAddHospitalName1" runat="server" Text='<%# Bind("HospitalName") %>'></asp:Label>
                                                     </ItemTemplate>
										              <EditItemTemplate>
                                                         <asp:DropDownList ID="ddlILIAddHospitalName1" runat="server" CssClass="form-control" Text='<%# Bind("HospitalName") %>'></asp:DropDownList>
                                                      </EditItemTemplate>
                                                </asp:TemplateField>



                                                        <asp:TemplateField>
                                                            <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_0_to_4"></label><br />
                                                                <eidss:NumericSpinner ID="txtint0to4" runat="server" Text='<%# Bind("intAge0_4") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>                                                           <asp:Label ID="lbl_0_to_4" runat="server" Text='<%# Bind("intAge0_4") %>'></asp:Label>
                                                          </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_0_to_4" runat="server" Text='<%# Bind("intAge0_4") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint0to4" runat="server" Text='<%# Bind("intAge0_4") %>' MinValue="0" MaxValue="10000" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                      <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_5_to_14"></label><br />
                                                                <eidss:NumericSpinner ID="txtint5to14Rate" runat="server" Text='<%# Bind("intAge5_14") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_5_to_14" runat="server" Text='<%# Bind("intAge5_14") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint5to14Rate" runat="server" Text='<%# Bind("intAge5_14") %>' MinValue="0" MaxValue="10000" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                            
    

                                                         <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_15_to_29"></label><br />
                                                                <eidss:NumericSpinner ID="txtint15to29Rate" runat="server" Text='<%# Bind("intAge15_29") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_15_to_29" runat="server" Text='<%# Bind("intAge15_29") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint15to29Rate" runat="server" Text='<%# Bind("intAge15_29") %>' MinValue="0" MaxValue="10000" CssClass="form-control" Enabled="false"></eidss:NumericSpinner>
                                                            </EditItemTemplate>

                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                            <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_30_to_64"></label><br />
                                                                <eidss:NumericSpinner ID="txtint30to64Rate" runat="server" Text='<%# Bind("intAge30_64") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_30_to_64" runat="server" Text='<%# Bind("intAge30_64") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint30to64Rate" runat="server" Text='<%# Bind("intAge30_64") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                          <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_65_to_Up"></label><br />
                                                                <eidss:NumericSpinner ID="txtint65toUp" runat="server" Text='<%# Bind("intAge65") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_65_to_Up" runat="server" Text='<%# Bind("intAge65") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtint65toUp" runat="server" Text='<%# Bind("intAge65") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>

                                                        </asp:TemplateField>


                                                      <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                          <HeaderTemplate>
                                                              <span class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_ILINUm" runat="server"></span>
																<%# GetLocalResourceObject("ILINum_Text.InnerText") %>
                                                              <asp:label ID="label_TotalILI" runat="server" CssClass="form-control"  ></asp:label>

                                                       </HeaderTemplate>
                                                            <ItemTemplate>
 <%--                                                             <asp:label ID="label1_TotalILI" runat="server" CssClass="rightAlign" text='<%# Bind("TotalILIName") %>'  Font-Size="Large" Enabled="false"  ></asp:label>--%>
                                                              <asp:label ID="label_TotalILI" runat="server" CssClass="rightAlign" text='<%# Bind("inTotalILI") %>'  Font-Size="Large" Enabled="false"  ></asp:label>

                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                               <asp:label ID="label_TotalILI" datatextfield="totalnum" runat="server" CssClass="form-control" text='<%# Bind("inTotalILI") %>'  ></asp:label>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>





                                                        <asp:TemplateField>
                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                          <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Total_Admiss"></label><br />
                                                                <eidss:NumericSpinner ID="txtTotalAdmiss" runat="server" Text='<%# Bind("intTotalAdmissions") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                       </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_Total_Admiss" runat="server" Text='<%# Bind("intTotalAdmissions") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                               <eidss:NumericSpinner ID="txtTotalAdmiss" runat="server" Text='<%# Bind("intTotalAdmissions") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>

                                                           <HeaderStyle VerticalAlign="Bottom" />
                                                          <HeaderTemplate>
                                                                <label runat="server" meta:resourcekey="lbl_Total_Samples"></label><br />
                                                                <eidss:NumericSpinner ID="txtTotalSamples" runat="server" Text='<%# Bind("intILISamples") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lbl_Total_Samples" runat="server" Text='<%# Bind("intILISamples") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <eidss:NumericSpinner ID="txtTotalSamples" runat="server" Text='<%# Bind("intILISamples") %>' MinValue="0" MaxValue="10000" CssClass="form-control"></eidss:NumericSpinner>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>








                                                       <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                            <HeaderTemplate>
                                                                <asp:LinkButton ID="btnAdd" runat="server" CausesValidation="True"  CommandName="insert" meta:resourceKey="btn_Add_ILIAggregateTotals" 
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' ValidationGroup="AddILIValidation" ><span class="glyphicon glyphicon-plus-sign"></span></asp:LinkButton>
                                                            </HeaderTemplate>
                                                             <ItemTemplate>
                                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_ILIAggregateTotals"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span></span></asp:LinkButton>

                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Update_ILIAggregateTotals"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span ></span></asp:LinkButton>

                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
 
                                                    </Columns>
                                                </eidss:GridView>



                                        </div>
                                        </div>

                        </div>
                                        <div class="form-group text-center">
                                            <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />
                                            <asp:Button ID="btnCancelDelete" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Delete_ILIAggregate" OnClick="btnCancelDelete_Click" Visible="false"></asp:Button>
                                            <asp:Button ID="btnILICancel" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnILICancel_Click" />
                                            <asp:Button ID="btnRTClear" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Clear" OnClick="btnClearAdd_Click" Visible="false" />
<%--                                            <button id="btnRTClear" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Clear" OnClick="btnClear_Click" Visible="false"></button>--%>
                                            <button id="btnCancelAdd" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel_Add" data-toggle="modal" data-target="#addCancelModal" visible="false"></button>
 
                                             <asp:Button ID="btnAddNext" runat="server" CssClass="btn btn-primary" meta:resourcekey="Btn_Add_ILIAggNext" CausesValidation="true" OnClick="btnNewILI_Click" Visible="false" />
                                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" ValidationGroup="valsubmit" causesvalidation="true" OnClick="btnSubmit_Click" Visible="True" />
<%--                                            <button id="btnDelete" runat="server" class="btn btn-default" type="button" data-toggle="modal" data-target="#usrConfirmDelete" meta:resourcekey="btn_Delete_ILIAggregate" visible="True"></button>--%>
                                        </div>
                                    </div>
                                </div>  
                            </div>



















            </div>
        </div>


    </ContentTemplate>
</asp:UpdatePanel>



                            <%--ILI Aggregate Add or Edit--%>
  
                            <%-- End ILI Aggregate AddEdit Section --%>


                    
                </div>
            </div>


            <div class="modal" id="usrConfirmDelete" role="dialog">

                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_ILI_Aggregate"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="lbl_Delete_Aggregate"></p>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <asp:Label ID="lblCASEIDDel" runat="server"></asp:Label>
                                        <p id="lblDeleteCase" runat="server" meta:resourcekey="Lbl_Delete_FormID"></p>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button type="submit" data-dismiss="modal" class="btn btn-primary" id="delYes" meta:resourcekey="Btn_Yes" runat="server" />
<%--                            <button type="command" data-dismiss="modal" class="btn btn-primary" id="Button1" meta:resourcekey="Btn_Yes" runat="server" />--%>
                            <button type="button" data-dismiss="modal" class="btn btn-default" meta:resourcekey="Btn_No" runat="server"></button>
                        </div>
                    </div>
                </div>
            </div>

          <div id="divSearchResultsCancelModal" class="modal" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="panel-warning alert alert-warning">
                    <div class="panel-heading">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="alert-link" runat="server" meta:resourcekey="Hdg_Cancel_Search"></h4>
                    </div>
                    <div class="panel-body">
                        <p runat="server" meta:resourcekey="Lbl_Cancel_Search"></p>
                    </div>
                     <div class="modal-footer text-center">
                         <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>
                         <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                      </div>
<%--                    <div class="form-group text-center">
                        <a runat="server" class="btn btn-warning alert-link" href="~/Dashboard.aspx" title="<%$ Resources: Buttons, Btn_Yes_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_Yes_Text") %></a>
                        <button type="button" runat="server" class="btn btn-warning alert-link" data-dismiss="modal" title="<%$ Resources: Buttons, Btn_No_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                    </div>--%>
                </div>
            </div>
        </div>

            <div id="addCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Add"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="../Human/ILIAggregate.aspx"></a>
                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>

                        <div id="submitCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Submit"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" href="~/Dashboard.aspx" meta:resourcekey="Btn_Yes"></a>


                            <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                        </div>
                    </div>
                </div>
            </div>


            <div id="divSuccessModalContainer" class="modal" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <asp:Label ID="lblFORMID" runat="server"></asp:Label>
                                        <p id="lblSuccess" runat="server" meta:resourcekey="Lbl_Success"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a class="btn btn-primary" runat="server" meta:resourcekey="Hdg_Return_Dashboard" href="~/Dashboard.aspx"></a>
                            <asp:Button ID="btnReturnToILIAgg" runat="server" meta:resourcekey="Btn_Return_ILIAgg_Record" CssClass="btn btn-primary" OnClientClick="hideModal();" OnClick="btnReturnToAggrRecord_Click" />

                        </div>
                    </div>
                </div>
            </div>


            <div id="searchCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Search"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
<%--                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>--%>

                            <a id="returnToILIAggReport" runat="server" class="btn btn-primary" href="../Human/ILIAggregate.aspx" meta:resourcekey="Btn_Yes" visible="false"></a>
                             <button id="btnReturnToILI" type="submit" runat="server" meta:resourcekey="Btn_Yes" class="btn btn-primary" Return="true" data-dismiss="modal" Click="btnReturnToILIAgg_Click"></button>

                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>

            
            <div id="errorILIAgg" class="modal" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_ILI_Aggregate_Case_Details"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                        <span class="glyphicon glyphicon-remove-sign modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                        <p id="lbl_Error" runat="server"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                        </div>
                    </div>
                </div>
            </div>




              <div id="AggCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p runat="server" meta:resourcekey="Lbl_Cancel_Agg"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" meta:resourcekey="Btn_Yes" href="~/Dashboard.aspx"></a>
                            <input type="button" runat="server" class="btn btn-default" meta:resourcekey="Btn_No" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>


            <asp:UpdatePanel ID="upSuccessModal" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divSuccessModal" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_ILIAgg"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-ok-sign modal-icon"></span></div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <p id="lblSuccessMessage" runat="server" meta:resourcekey="Lbl_Success"></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <a href="~/Dashboard.aspx" class="btn btn-default" runat="server" title="<%$ Resources: Labels, Lbl_Return_to_Dashboard_ToolTip %>"><%= GetGlobalResourceObject("Labels", "Lbl_Return_to_Dashboard_Text") %></a>
                                    <asp:Button ID="btnReturnToILIAggRecord" runat="server" Text="<%$ Resources: Buttons, Btn_Ok_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Ok_ToolTip %>" CssClass="btn btn-primary" data-dismiss="modal" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divWarningModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="warningHeading" runat="server"></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-alert modal-icon"></span></div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <strong id="warningSubTitle" runat="server"></strong>
                                                <br />
                                                <div id="warningBody" runat="server"></div>
                                                <br />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <div id="divWarningYesNoContainer" runat="server">
                                        <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                        <button id="btnWarningModalNo" type="button" class="btn btn-default" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                                    </div>
                                    <div id="divWarningOKContainer" runat="server">
                                        <button id="btnWarningModalOK" type="button" class="btn btn-primary" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        <script type="text/javascript">

                function showModal(modalPopup) {
                    var p = '#' + modalPopup;
                    $(p).modal({ show: true, backdrop: 'static' });
                }
                function showSubGrid(e, f) {
                    var divTag = '#' + f;
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom') {
                        e.target.className = "glyphicon glyphicon-triangle-top";
                        $(divTag).show();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom";
                        $(divTag).hide();
                    }
                };

            function showILIAggSubGrid(e, f) {
                var cl = e.target.className;
                if (cl == 'glyphicon glyphicon-triangle-bottom') {
                    e.target.className = "glyphicon glyphicon-triangle-top";
                    $('#' + f).show();
                }
                else {
                    e.target.className = "glyphicon glyphicon-triangle-bottom";
                    $('#' + f).hide();
                }
            }

            function toggleILIAggSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $('#divILIAggSearchCriteriaForm').collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $('#divILIAggSearchCriteriaForm').collapse('show');
                }
            }

            function hideILIAggSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $('#divILIAggSearchCriteriaForm').collapse('hide');
            }

            function showILIAggSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $('#divILIAggSearchCriteriaForm').collapse('show');
            }

                            function showSearchCriteria(e) {
                    var cl = e.target.className;
                    if (cl == 'glyphicon glyphicon-triangle-bottom header-button') {
                        e.target.className = "glyphicon glyphicon-triangle-top header-button";
                        $('#<%= divILIAggSearchCriteria.ClientID %>').show();
                        $('#<%= btnClear.ClientID %>').show();
                        $('#<%= btnSearch.ClientID %>').show();
                        $('#<%= btnPrint.ClientID %>').hide();
                    }
                    else {
                        e.target.className = "glyphicon glyphicon-triangle-bottom header-button";
                        $('#<%= divILIAggSearchCriteria.ClientID %>').hide();
                        $('#<%= btnClear.ClientID %>').hide();
                        $('#<%= btnSearch.ClientID %>').hide();
                        $('#<%= btnPrint.ClientID %>').show();
                    }
                };

        </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

