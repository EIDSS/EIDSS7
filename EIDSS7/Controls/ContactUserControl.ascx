<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ContactUserControl.ascx.vb" Inherits="EIDSS.ContactUserControl" %>
<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<div class="container-fluid">

    <div id="searchContainer">
        <div class="panel-group">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9 text-left">
                            Search Contacts in System
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                            <button type="button" class="close" data-dismiss="modal">x</button>

                        </div>
                    </div>
                </div>
                <div class="panel-body">                    
                    <div class="row">
                        <div class="col-md-5">
                            <asp:Label ID="Label1"
                                AssociatedControlID="txtFirstName"
                                CssClass="control-label"
                                runat="server"
                                Text="<%$ Resources: Labels, LblFirstNameText %>"
                                ToolTip="<%$ Resources: Labels, LblFirstNameToolTip %>"></asp:Label>
                            <asp:TextBox CssClass="form-control" ID="txtFirstName" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Label ID="Label2"
                                AssociatedControlID="txtSecondName"
                                CssClass="control-label"
                                runat="server"
                                Text="<%$ Resources:Labels, Lbl_Second_Name_Text %>"
                                ToolTip="<%$ Resources:Labels, LblSecondNameToolTip %>"></asp:Label>
                            <asp:TextBox CssClass="form-control" ID="txtSecondName" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <asp:Label
                                ID="Label3"
                                AssociatedControlID="txtLastName"
                                CssClass="control-label" runat="server"
                                Text="<%$ Resources:Labels, Lbl_Family_Name_Text %>"
                                ToolTip="<%$ Resources:Labels, Lbl_Family_Name_ToolTip %>"></asp:Label>
                            <asp:TextBox CssClass="form-control" ID="txtLastName" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label4"
                            runat="server"
                            AssociatedControlID="txtDateOfBirth"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, Lbl_Date_Of_Birth_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Date_Of_Birth_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtDateOfBirth" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label5"
                                    runat="server"
                                    AssociatedControlID="ddlRegion"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Region_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Region_ToolTip %>"></asp:Label>
                                <asp:DropDownList CssClass="form-control" ID="ddlRegion" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label6"
                                    runat="server"
                                    AssociatedControlID="ddlRayon"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Rayon_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Rayon_ToolTip %>"></asp:Label>
                                <asp:DropDownList CssClass="form-control" ID="ddlRayon" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label7"
                                    runat="server"
                                    AssociatedControlID="ddlPersonalIdType"
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Id_Type_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Id_Type_ToolTip %>"></asp:Label>
                                <asp:DropDownList CssClass="form-control" ID="ddlPersonalIdType" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <div class="glyphicon glyphicon-asterisk"></div>
                                <asp:Label ID="Label8"
                                    runat="server"
                                    AssociatedControlID=""
                                    CssClass="control-label"
                                    Text="<%$ Resources:Labels, Lbl_Personal_Id_Instruction_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Personal_Id_Instruction_ToolTip %>"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtPersonalID" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:LinkButton CssClass="btn btn-primary" ID="btnSearchContacts" runat="server" OnClick="btnSearchContacts_Click">
                        <span><%=GetGlobalResourceObject("Buttons", "Btn_Search_Text") %></span>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">Search Results</div>
                <div class="panel-body">
                    <div class="form-group">
                        <asp:UpdatePanel ID="contactGridUpdatePanel" runat="server">
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnSearchContacts" />
                            </Triggers>
                            <ContentTemplate>
                                <asp:GridView
                                    AllowPaging="true"
                                    AllowSorting="true"
                                    AutoGenerateColumns="false"
                                    Caption="Results"
                                    CaptionAlign="Left"
                                    CssClass="table table-striped table-hover"
                                    DataKeyNames=""
                                    ID="grdContacts"
                                    OnRowCommand="grdContacts_RowCommand"
                                    runat="server"
                                    ShowHeader="true">
                                    <Columns>
                                        <asp:CommandField ShowSelectButton="true" HeaderText="<%$ Resources:Grd_Select_Header %>" ControlStyle-CssClass="btn-sm btn-primary" />
                                        <asp:BoundField DataField="Name" HeaderText="<%$ Resources:Grd_Name_Header %>" />
                                        <asp:BoundField DataField="DateOfBirth" HeaderText="<%$ Resources:Grd_Date_of_Birth_Header %>" />
                                        <asp:BoundField DataField="PersonalId" HeaderText="<%$ Resources:Grd_Personal_Id_Header %>" />
                                        <asp:BoundField DataField="Rayon" HeaderText="<%$ Resources:Grd_Rayon_Header %>" />
                                        <asp:CommandField ShowEditButton="true" Visible="false" />
                                        <asp:CommandField ShowDeleteButton="true" Visible="false" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="panel panel-danger">
                                            <div class="panel-heading">
                                                <%= GetLocalResourceObject("Pnl_No_Match_Panel_Heading") %>
                                            </div>
                                            <div class="panel-body">
                                                <%= GetLocalResourceObject("Pnl_No_Match_Panel_Text") %>
                                            </div>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="form-group">
                        <asp:LinkButton CssClass="btn btn-info" ID="btnAddNewContact" runat="server" ToolTip="<%$ Resources: Buttons, Btn_Add_Contact_ToolTip %>">
                            <span><%=  GetGlobalResourceObject("Buttons", "Btn_Add_Contact_Text") %></span>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="NewContactContainer" class="hidden">
        <div class="panel-group">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h2><%= GetLocalResourceObject("Hdg_New_Contact_InnerText") %></h2>
                </div>
                <div class="panel-body">
                    <span><%= GetLocalResourceObject("Spn_New_Contact_InnerText") %></span>
                    <div class="form-group">
                        <asp:Label
                            AssociatedControlID="txtCreateDate"
                            CssClass="control-label"
                            ID="Label9"
                            runat="server"
                            Text="<%$ Resources:Lbl_Person_Create_Date_Text %>"
                            ToolTip="<%$ Resources: Lbl_Person_Create_Date_ToolTip %>"></asp:Label>
                        <asp:TextBox CssClass="form-control" ID="txtCreateDate" ReadOnly="true" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Label
                            AssociatedControlID="txtPersonLastUpdateDate"
                            CssClass="control-label"
                            ID="Label10"
                            runat="server"
                            Text="<%$ Resources:Lbl_Person_UpDate_Text %>"
                            ToolTip="<%$ Resources:Lbl_Person_UpDate_ToolTip %>"></asp:Label>
                        <asp:TextBox CssClass="form-control" ID="txtPersonLastUpdateDate" ReadOnly="true" runat="server"></asp:TextBox>
                    </div>

                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3><%= GetLocalResourceObject("Hdg_Personal_Information_InnerText") %></h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-5">
                                <asp:Label
                                    AssociatedControlID="txtNewFirstName"
                                    CssClass="control-label"
                                    runat="server"
                                    Text="<%$ Resources:Labels, LblFirstNameText %>"
                                    ToolTip="<%$ Resources:Labels, LblFirstNameToolTip %>"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtNewFirstName" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <asp:Label
                                    AssociatedControlID="txtNewSecondName"
                                    CssClass="control-label"
                                    runat="server"
                                    Text="<%$ Resources:Labels, Lbl_Second_Name_Text %>"
                                    ToolTip="<%$ Resources:Labels, LblSecondNameToolTip %>"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtNewSecondName" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-5">
                                <asp:Label
                                    AssociatedControlID="txtNewFamilyName"
                                    CssClass="control-label"
                                    runat="server"
                                    Text="<%$ Resources:Labels,Lbl_Family_Name_Text %>"
                                    ToolTip="<%$ Resources:Labels,Lbl_Family_Name_ToolTip %>"></asp:Label>
                                <asp:TextBox CssClass="form-control" ID="txtNewFamilyName" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <fieldset>
                            <legend>
                                <span aria-label="" class="control-label"><%= GetGlobalResourceObject("OtherText", "lgd_Sex_Text") %></span></legend>
                            <div class="form-group">
                                <asp:RadioButton ID="rdoFemale" runat="server" GroupName="gender" />
                                <asp:Label AssociatedControlID="rdoFemale"
                                    CssClass="control-label"
                                    runat="server"
                                    Text="<%$ Resources:Labels, Lbl_Female_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Female_ToolTip %>"></asp:Label>
                                <asp:RadioButton ID="rdonMale" runat="server" GroupName="gender" />
                                <asp:Label AssociatedControlID="rdonMale"
                                    CssClass="control-label"
                                    runat="server"
                                    Text="<%$ Resources:Labels, Lbl_Male_Text %>"
                                    ToolTip="<%$ Resources:Labels, Lbl_Male_ToolTip %>"></asp:Label>
                            </div>
                        </fieldset>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label AssociatedControlID="ddlNewIdType"
                            CssClass="control-label"
                            runat="server"
                            Text="<%$ Resources:Labels, Lbl_Id_Type_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Id_Type_ToolTip %>"></asp:Label>
                        <asp:DropDownList CssClass="form-control" ID="ddlNewIdType" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label AssociatedControlID="txtNewPersonalId"
                            CssClass="control-label"
                            runat="server"
                            Text="<%$ Resources:Labels, Lbl_Personal_Id_Instruction_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Personal_Id_Instruction_ToolTip %>"></asp:Label>
                        <asp:TextBox CssClass="form-control" ID="txtNewPersonalId" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label AssociatedControlID="txtNewDateOfBirth"
                            CssClass="control-label"
                            runat="server"
                            Text="<%$ Resources:Labels, Lbl_Date_Of_Birth_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Date_Of_Birth_ToolTip %>"></asp:Label>
                        <asp:TextBox CssClass="form-control" ID="txtNewDateOfBirth" runat="server" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3><%= GetLocalResourceObject("Hdg_Residence_Information_InnerText") %></h3>
                </div>
                <div class="panel-body">
                    <h4><%= GetLocalResourceObject("Hdg_Current_Residence_InnerText") %></h4>
                    <eidss:LocationUserControl runat="server" ID="NewContactLocation" />
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label16"
                            runat="server"
                            AssociatedControlID="ddlNewCitizenShip"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, Lbl_Citizenship_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Citizenship_ToolTip %>"></asp:Label>
                        <asp:DropDownList ID="ddlNewCitizenShip" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3><%= GetLocalResourceObject("Hdg_Employer_Information_InnerText") %></h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label11"
                            runat="server"
                            AssociatedControlID="txtNewEmployerName"
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, Lbl_Employer_Name_Text %>"
                            ToolTip="<%$ Resources:Labels, Lbl_Employer_Name_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtNewEmployerName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <eidss:LocationUserControl runat="server" ID="NewEmployerLocation" />
                </div>
                <div class="panel-footer"></div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3><%= GetLocalResourceObject("Hdg_Person_Details_InnerText") %></h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label12"
                            runat="server"
                            AssociatedControlID="txtNewContactRelation"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Relation_Text %>"
                            ToolTip="<%$ Resources:Lbl_Relation_ToolTip %>"></asp:Label>
                        <asp:DropDownList ID="txtNewContactRelation" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label13"
                            runat="server"
                            AssociatedControlID="txtDateOfLastContact"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Last_Contact_Text %>"
                            ToolTip="<%$ Resources:Lbl_Last_Contact_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtDateOfLastContact" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label14"
                            runat="server"
                            AssociatedControlID="txtPlaceOfLastContact"
                            CssClass="control-label"
                            Text="<%$ Resources:Lbl_Contact_Place_Text %>"
                            ToolTip="<%$ Resources:Lbl_Contact_Place_ToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtPlaceOfLastContact" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <div class="glyphicon glyphicon-asterisk"></div>
                        <asp:Label ID="Label15"
                            runat="server"
                            AssociatedControlID=""
                            CssClass="control-label"
                            Text="<%$ Resources:Labels, LblCommentsText %>"
                            ToolTip="<%$ Resources:Labels, LblCommentsToolTip %>"></asp:Label>
                        <asp:TextBox ID="txtNewComments" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" Columns="1"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:LinkButton ID="btnInsertNewContact" runat="server" CssClass="btn btn-primary" data-dismiss="modal">
                            <span><%= GetGlobalResourceObject("Buttons", "Btn_Submit_Text") %></span>
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="panel-footer"></div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(
        $("#<% = btnAddNewContact.ClientID %>").click(function () {
            $("#searchContainer").toggleClass("hidden");
            $("#NewContactContainer").toggleClass("hidden");

            return false;
        }));

</script>
