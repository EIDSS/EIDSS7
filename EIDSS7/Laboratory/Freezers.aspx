<%@ Page Title="Freezers" Language="vb" AutoEventWireup="false" MasterPageFile="~/FullView.Master" CodeBehind="Freezers.aspx.vb" Inherits="EIDSS.Freezers" %>

<%@ Register Src="~/Controls/SearchFreezerUserControl.ascx" TagPrefix="eidss" TagName="SearchFreezer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upFreezers" runat="server" UpdateMode="Conditional">
        <Triggers>
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="hdfFreezersCount" runat="server" Value="0"></asp:HiddenField>
            <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserID" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserName" runat="server" Value="" />
            <asp:HiddenField ID="hdfUserOrganization" runat="server" Value="" />
            <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
            <asp:HiddenField ID="hdfCurrentModuleAction" runat="server" Value="" />
            <asp:HiddenField runat="server" ID="hdfIdentity" Value="0" />
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="Hdg_Freezer_List"></h2>
                </div>
                <div class="panel-body">
                    <div class="row pull-right">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-right">
                            <asp:UpdatePanel ID="upFreezerSearch" runat="server" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="samples-save-panel">
                                    </div>
                                    <div class="row pull-right">
                                        <div class="flex-container freezer-header-panel">
                                            <asp:Button ID="btnAddFreezer" runat="server" CssClass="btn btn-primary" Height="35" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                            <asp:Button ID="btnCopyFreezer" runat="server" CssClass="btn btn-default" Height="35" Text="<%$ Resources: Buttons, Btn_Copy_Freezer_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Copy_Freezer_ToolTip %>" CausesValidation="false" />
                                            <div class="form-group has-feedback has-clear">
                                                <asp:TextBox ID="txtSearchString" runat="server" CssClass="form-control" Height="35" MaxLength="2000" autofocus="true" AutoCompleteType="Disabled"></asp:TextBox>
                                                <span class="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden"></span>
                                            </div>
                                            <span>
                                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-default btn-md" CausesValidation="false"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="advanced-search pull-right">
                                            <a href="#divSearchFreezerModal" onclick="<%= AdvancedSearchPostBackItem %>" data-target="#divSearchFreezerModal" data-toggle="modal">
                                                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Advanced_Search_Text %>"></asp:Literal></a>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <asp:UpdatePanel ID="upSearchResults" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvFreezers" EventName="RowCommand" />
                            <asp:AsyncPostBackTrigger ControlID="gvFreezers" EventName="PageIndexChanging" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView ID="gvFreezers" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="FreezerID" ShowHeaderWhenEmpty="true" ShowHeader="true" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="True" GridLines="None" PagerSettings-Visible="false">
                                    <HeaderStyle CssClass="lab-table-striped-header" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="FreezerName" ReadOnly="true" SortExpression="FreezerName" HeaderText="<%$ Resources: Labels, Lbl_Freezer_Name_Text %>" />
                                        <asp:BoundField DataField="FreezerNote" ReadOnly="true" SortExpression="Note" HeaderText="<%$ Resources: Labels, Lbl_Note_Text %>" />
                                        <asp:BoundField DataField="StorageTypeName" ReadOnly="true" SortExpression="StorageTypeName" HeaderText="<%$ Resources: Labels, Lbl_Storage_Type_Text %>" />
                                        <asp:BoundField DataField="Building" ReadOnly="true" SortExpression="Building" HeaderText="<%$ Resources: Labels, Lbl_Building_Text %>" />
                                        <asp:BoundField DataField="Room" ReadOnly="true" SortExpression="Room" HeaderText="<%$ Resources: Labels, Lbl_Room_Text %>" />
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" meta:resourceKey="Btn_Edit" CommandArgument='<% #Bind("FreezerID") %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" meta:resourceKey="Btn_Delete" CommandArgument='<% #Bind("FreezerID") %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div id="divPager" runat="server" class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblFreezersPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptFreezersPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkFreezersPage" runat="server" CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="FreezersPage_Changed" Height="25" Font-Bold="True"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:UpdatePanel ID="upStorageSchema" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="treSubdivisions" EventName="SelectedNodeChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlSubdivisionTypeID" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlBoxSizeTypeID" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <asp:HiddenField ID="hdfFreezerSubdivisionIdentity" runat="server" Value="0" />
                    <asp:HiddenField ID="hdfFreezerSubdivisionID" runat="server" Value="" />
                    <asp:HiddenField ID="hdfAddSubdivisionTypeID" runat="server" Value="" />
                    <asp:HiddenField ID="hdfRows" runat="server" Value="" />
                    <asp:HiddenField ID="hdfColumns" runat="server" Value="" />

                    <div id="divStorageSchema" runat="server" class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <h3><% =GetGlobalResourceObject("Labels", "Lbl_Freezer_Details_Text") %></h3>
                                    <asp:TreeView ID="treSubdivisions" runat="server" ExpandDepth="4" ImageSet="Arrows">
                                        <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
                                        <NodeStyle HorizontalPadding="5px" NodeSpacing="0px" VerticalPadding="0px" />
                                        <ParentNodeStyle Font-Bold="False" />
                                        <SelectedNodeStyle Font-Underline="True" ForeColor="#5555DD" HorizontalPadding="0px" VerticalPadding="0px" />
                                    </asp:TreeView>
                                    <asp:Table ID="tblBoxConfiguration" runat="server" Visible="false" CssClass="boxConfigurationTable" Enabled="false"></asp:Table>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div id="divFreezerAttributes" runat="server">
                                        <asp:HiddenField ID="hdfFreezerID" runat="server" Value="" />
                                        <h3><% =GetGlobalResourceObject("Labels", "Lbl_Freezer_Attributes_Text") %></h3>
                                        <div class="row">&nbsp;</div>
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1" meta:resourcekey="Dis_Building">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Building" runat="server"></div>
                                                <label for="txtBuilding" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Building_Text") %></label>
                                            </div>
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                <asp:TextBox ID="txtBuilding" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtBuilding" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Building" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1" meta:resourcekey="Dis_Room">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Building" runat="server"></div>
                                                <label for="txtRoom" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Room_Text") %></label>
                                            </div>
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                <asp:TextBox ID="txtRoom" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtRoom" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Room" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Freezer_Name">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Freezer_Name" runat="server"></div>
                                                <label for="txtFreezerName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Freezer_Name_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="txtFreezerName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtFreezerName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Freezer_Name" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Storage_Type">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Storage_Type" runat="server"></div>
                                                <label for="ddlStorageTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Storage_Type_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <eidss:DropDownList CssClass="form-control" ID="ddlStorageTypeID" runat="server"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlStorageTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Storage_Type" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Freezer_Barcode">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Freezer_Barcode" runat="server"></div>
                                                <label for="txtEIDSSFreezerID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Barcode_Text") %></label>
                                            </div>
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                <asp:TextBox ID="txtEIDSSFreezerID" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtEIDSSFreezerID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Freezer_Barcode" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                <asp:LinkButton ID="btnPrintFreezerBarcode" runat="server" CssClass="btn btn-default btn-sm pull-right" CausesValidation="false"><span class="glyphicon glyphicon-print" aria-hidden="true"></span></asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Freezer_Note">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Freezer_Note" runat="server"></div>
                                                <label for="txtFreezerNote" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Note_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="txtFreezerNote" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtFreezerNote" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Freezer_Note" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="divSubdivisionAttributes" runat="server">
                                        <h3><% =GetGlobalResourceObject("Labels", "Lbl_Subdivision_Attributes_Text") %></h3>
                                        <div class="row">&nbsp;</div>
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right" meta:resourcekey="Dis_Subdivision_Name">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Subdivision_Name" runat="server"></div>
                                                <label for="txtSubdivisionName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Subdivision_Name_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="txtSubdivisionName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtSubdivisionName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Subdivision_Name" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Subdivision_Type">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Subdivision_Type" runat="server"></div>
                                                <label for="ddlSubdivisionTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Subdivision_Type_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <eidss:DropDownList CssClass="form-control" ID="ddlSubdivisionTypeID" runat="server" Enabled="false" AutoPostBack="true"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlSubdivisionTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Subdivision_Type" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Number_Of_Locations">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Number_Of_Locations" runat="server"></div>
                                                <label for="txtNumberOfLocations" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Number_Of_Locations_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <eidss:NumericSpinner ID="txtNumberOfLocations" runat="server" CssClass="form-control" MinValue="0"></eidss:NumericSpinner>
                                                <asp:RequiredFieldValidator ControlToValidate="txtNumberOfLocations" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Number_Of_Locations" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div id="divBoxSize" class="row" runat="server" meta:resourcekey="Dis_Box_Size">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Box_Size" runat="server"></div>
                                                <label for="ddlBoxSizeTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Box_Size_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <div class="input-group">
                                                    <eidss:DropDownList CssClass="form-control" ID="ddlBoxSizeTypeID" AutoPostBack="true" runat="server"></eidss:DropDownList>
                                                    <asp:LinkButton ID="btnAddBoxSize" runat="server" CssClass="input-group-addon" CausesValidation="false"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                                                </div>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlBoxSizeTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Box_Size" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Subdivision_Barcode">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Subdivision_Barcode" runat="server"></div>
                                                <label for="txtEIDSSSubdivisionID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Barcode_Text") %></label>
                                            </div>
                                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                <asp:TextBox ID="txtEIDSSSubdivisionID" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtEIDSSSubdivisionID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Subdivision_Barcode" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                <asp:LinkButton ID="btnPrintSubdivisionBarcode" runat="server" CssClass="btn btn-default btn-sm pull-right" CausesValidation="false"><span class="glyphicon glyphicon-print" aria-hidden="true"></span></asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="row">&nbsp;</div>
                                        <div class="row" runat="server" meta:resourcekey="Dis_Subdivision_Note">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Subdivision_Note" runat="server"></div>
                                                <label for="txtSubdivisionNote" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Note_Text") %></label>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="txtSubdivisionNote" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ControlToValidate="txtSubdivisionNote" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Subdivision_Note" runat="server" ValidationGroup="AddUpdateFreezer"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">&nbsp;</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div id="divBoxConfigurationActions" runat="server" class="modal-footer text-center" style="padding-left: 0px; padding-right: 0px;">
                                        <asp:Button ID="btnAddSubdivision" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                        <asp:Button ID="btnCopySubdivision" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Copy_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Copy_ToolTip %>" CausesValidation="false" />
                                        <asp:Button ID="btnDeleteSubdivision" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" CausesValidation="false" />
                                    </div>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div id="divFreezerActions" runat="server" class="text-center" style="padding-left: 0px; padding-right: 0px;">
                                        <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" ValidationGroup="AddUpdateFreezer" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="divSearchFreezerModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSearchFreezerModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSearchFreezerModal')">&times;</button>
                <h4 id="hdgAdvancedSearch" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Advanced_Search_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchFreezer ID="ucAdvancedSearch" runat="server" />
            </div>
        </div>
    </div>
    <div id="divBaseReferenceEditorModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divBaseReferenceEditorModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" onclick="hideModal('#divBaseReferenceEditorModal')" aria-hidden="true">&times;</button>
                <h4 id="hdgBaseReferenceEditor" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_Base_Reference_Editor_Text") %></h4>
            </div>
            <div class="modal-body modal-wrapper">
            </div>
            <div class="modal-footer text-center">
                <button id="btnBaseReferenceEditorCancel" type="button" class="btn btn-default" title="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_ToolTip") %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                <asp:Button ID="btnBaseReferenceEditorOK" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" ValidationGroup="BaseReferenceEditor" />
            </div>
        </div>
    </div>
    <div id="divWarningModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
        <div class="modal-dialog" role="document">
            <div class="panel-warning alert alert-warning">
                <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="panel-heading">
                            <button type="button" class="close" onclick="hideModal('#divWarningModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="hdgWarning" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="warningSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divWarningBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <div id="divWarningYesNo" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <button id="btnWarningModalNo" type="button" class="btn btn-warning alert-link" onclick="hideModal('#divWarningModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                            </div>
                            <div id="divWarningOK" runat="server">
                                <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" onclick="hideModal('#divWarningModal')" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="divSuccessModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divSuccessModal">
        <asp:UpdatePanel ID="upSuccessModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 id="hdgSuccess" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_EIDSS_Success_Message_Text") %></h4>
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
                            <asp:Button ID="btnModalSuccessOK" runat="server" CssClass="btn btn-primary" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script lang="javascript" type="text/javascript">
        $(function () {
            $(document).ready(function () {
                Sys.WebForms.PageRequestManager.getInstance();
                Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
            });
        });

        function beginRequestHandler() {
            showLoading();
        };

        function endRequestHandler() {
            hideLoading();
        };

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0)
                showModal(modalID);
            else
                showModalOnModal(modalID);
        };

        function showModal(modalID) {
            $('body').addClass('labModal');
            var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            bd.appendTo(document.body);
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');
        }

        function setBackdrop() {
            $('body').addClass('labModal');
            var bd = $('<div class="modal-backdrop show"></div>');
            bd.appendTo(document.body);
        };

        function hideModal(modalID) {
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };
    </script>
</asp:Content>
