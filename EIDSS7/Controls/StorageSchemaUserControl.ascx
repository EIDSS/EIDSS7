<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="StorageSchemaUserControl.ascx.vb" Inherits="EIDSS.StorageSchemaUserControl" %>
<div class="row">
    <asp:TreeView ID="tvFreezerDetails" runat="server">
        
    </asp:TreeView>
</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="txtSubdivisionName" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Subdivision_Name_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <asp:TextBox ID="txtSubdivisionName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
    </div>
</div>
<div class="row">&nbsp;</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="ddlSubdivisionTypeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Subdivision_Type_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <eidss:DropDownList ID="ddlSubdivisionTypeID" runat="server"></eidss:DropDownList>
    </div>
</div>
<div class="row">&nbsp;</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="txtNumberOfLocations" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Number_Of_Locations_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <eidss:NumericSpinner ID="txtNumberOfLocations" runat="server" MinValue="1"></eidss:NumericSpinner>
    </div>
</div>
<div class="row">&nbsp;</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="ddlBoxSizeID" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Box_Size_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <eidss:DropDownList ID="ddlBoxSizeID" runat="server"></eidss:DropDownList>
    </div>
</div>
<div class="row">&nbsp;</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="txtSubdivisionBarCode" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Barcode_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <asp:TextBox ID="txtSubdivisionBarCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
    </div>
</div>
<div class="row">&nbsp;</div>
<div class="row">
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
        <label for="txtNotes" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Notes_Text") %></label>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
    </div>
</div>