<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HorizontalLocationUserControl.ascx.vb" Inherits="EIDSS.HorizontalLocationUserControl" %>

<div id="divCountry" runat="server" class="form-group">
    <div class="row">
        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12" runat="server" meta:resourcekey="Dis_Country">
            <span id="reqCountry" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label runat="server" for="ddlidfsCountry" meta:resourcekey="Lbl_Country"></label>
            <eidss:DropDownList ID="ddlidfsCountry" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
            <asp:RequiredFieldValidator ID="valCountry" ControlToValidate="ddlidfsCountry" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Country" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
        </div>
    </div>
</div>
<div class="form-group">
    <div class="row">
        <div id="divRegion" class="col-lg-6 col-md-6 col-sm-8 col-xs-12" runat="server">
            <span id="reqRegion" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label runat="server" for="ddlidfsRegion" meta:resourcekey="Lbl_Region"></label>
            <asp:UpdatePanel ID="upRegion" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlidfsCountry" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <eidss:DropDownList ID="ddlidfsRegion" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ID="valRegion" ControlToValidate="ddlidfsRegion" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Region" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div id="divRayon" class="col-lg-6 col-md-6 col-sm-8 col-xs-12" runat="server">
            <span id="reqRayon" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label runat="server" for="ddlidfsRayon" meta:resourcekey="Lbl_Rayon"></label>
            <asp:UpdatePanel ID="upRayon" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlidfsRegion" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <eidss:DropDownList ID="ddlidfsRayon" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ID="valRayon" ControlToValidate="ddlidfsRayon" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Rayon" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</div>
<div id="divSettlementGroup" class="form-group" runat="server">
    <div class="row">
        <asp:UpdatePanel ID="upSettlementGroup" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlidfsRayon" EventName="SelectedIndexChanged" />
            </Triggers>
            <ContentTemplate>
                <div id="divSettlementType" class="col-lg-6 col-md-6 col-sm-8 col-xs-12" runat="server">
                    <label runat="server" for="ddlSettlementType" meta:resourcekey="Lbl_Settlement_Type"></label>
                    <eidss:DropDownList ID="ddlSettlementType" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                </div>
                <div id="divSettlement" class="col-lg-6 col-md-6 col-sm-8 col-xs-12" runat="server">
                    <span id="reqSettlement" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="ddlidfsSettlement" meta:resourcekey="Lbl_Settlement"></label>
                    <eidss:DropDownList ID="ddlidfsSettlement" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ID="valSettlement" ControlToValidate="ddlidfsSettlement" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Settlement" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
<asp:UpdatePanel ID="upStreetBuildingHouseApartmentPostalCode" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ddlidfsSettlement" EventName="SelectedIndexChanged" />
    </Triggers>
    <ContentTemplate>
        <div id="divStreet" runat="server" class="form-group" meta:resourcekey="Dis_Street">
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <span id="reqStreetName" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="txtstrStreetName" meta:resourcekey="Lbl_Street"></label>
                    <asp:TextBox ID="txtstrStreetName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valStreetName" ControlToValidate="txtstrStreetName" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Street" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
        <div id="divBuildingHouseApartment" runat="server" class="form-group" meta:resourcekey="Dis_Building_House_Apt">
            <div class="row">
                <div id="divHouse" class="col-lg-4 col-md-6 col-sm-8 col-xs-12" runat="server" meta:resourcekey="Dis_House">
                    <span id="reqHouse" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="txtstrHouse" meta:resourcekey="Lbl_House"></label>
                    <asp:TextBox ID="txtstrHouse" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valHouse" ControlToValidate="txtstrHouse" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_House" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
                <div id="divBuilding" class="col-lg-4 col-md-6 col-sm-8 col-xs-12" runat="server" meta:resourcekey="Dis_Building">
                    <span id="reqBuilding" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="txtstrBuilding" meta:resourcekey="Lbl_Building"></label>
                    <asp:TextBox ID="txtstrBuilding" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valBuilding" ControlToValidate="txtstrBuilding" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Building" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
                <div id="divApartment" class="col-lg-4 col-md-6 col-sm-8 col-xs-12" runat="server" meta:resourcekey="Dis_Apartment">
                    <span id="reqApartment" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="txtstrApartment" meta:resourcekey="Lbl_Apartment"></label>
                    <asp:TextBox ID="txtstrApartment" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valApartment" ControlToValidate="txtstrApartment" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Apartment" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
        <div id="divPostalCode" runat="server" class="form-group" meta:resourcekey="Dis_Postal_Code">
            <div class="row">
                <div class="col-lg-4 col-md-6 col-sm-8 col-xs-12">
                    <span id="reqPostalCode" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
                    <label runat="server" for="ddlidfsPostalCode" meta:resourcekey="Lbl_Postal_Code"></label>
                    <eidss:DropDownList ID="ddlidfsPostalCode" runat="server" CssClass="form-control"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ID="valPostalCode" ControlToValidate="ddlidfsPostalCode" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Postal_Code" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<div id="divCoordinates" runat="server" class="form-group" meta:resourcekey="Dis_Coordinates">
    <div class="row">
        <div id="divLatitude" class="col-lg-3 col-md-6 col-sm-8 col-xs-10" runat="server" meta:resourcekey="Dis_Latitude">
            <span id="reqLatitude" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label id="lblLatitude" runat="server" for="txtstrLatitude" meta:resourcekey="Lbl_Latitude"></label>
            <eidss:NumericSpinner ID="txtstrLatitude" runat="server" CssClass="form-control" MaxValue="85" MinValue="-85"></eidss:NumericSpinner>
            <asp:RequiredFieldValidator ID="valLatitude" ControlToValidate="txtstrLatitude" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Latitude" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
        </div>
        <div id="divLongitude" class="col-lg-3 col-md-6 col-sm-8 col-xs-10" runat="server" meta:resourcekey="Dis_Longitude">
            <span id="reqLongitude" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label id="lblLongitude" runat="server" for="txtstrLongitude" meta:resourcekey="Lbl_Longitude"></label>
            <eidss:NumericSpinner ID="txtstrLongitude" runat="server" CssClass="form-control" MaxValue="180" MinValue="-180"></eidss:NumericSpinner>
            <asp:RequiredFieldValidator ID="valLongitude" ControlToValidate="txtstrLongitude" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Longitude" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
        </div>
        <div id="divElevation" class="col-lg-3 col-md-6 col-sm-8 col-xs-10" runat="server" meta:resourcekey="Dis_Elevation">
            <span id="reqElevation" class="glyphicon glyphicon-asterisk text-danger" runat="server"></span>
            <label id="lblElevation" runat="server" for="txtstrElevation" meta:resourcekey="Lbl_Elevation"></label>
            <eidss:NumericSpinner ID="txtstrElevation" runat="server" CssClass="form-control" MaxValue="11000" MinValue="-1000"></eidss:NumericSpinner>
            <asp:RequiredFieldValidator ID="valElevation" ControlToValidate="txtstrElevation" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Elevation" runat="server" EnableClientScript="true"></asp:RequiredFieldValidator>
        </div>
        <div id="divMap" class="col-lg-1 col-md-1 col-sm-1 col-xs-1" runat="server" meta:resourcekey="Dis_Map">
            <label id="lblMap" runat="server" for="btnMap" meta:resourcekey="Lbl_Map"></label>
            <a id="btnMap" runat="server" class="btn btn-default glyphicon glyphicon-map-marker" data-toggle="modal"></a>
        </div>
    </div>
</div>
<div id="divMapModal" class="modal container fade" role="dialog" runat="server" data-backdrop="static" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button class="close" type="button" data-dismiss="modal">×</button><h4 class="modal-title">Select Location</h4>
            </div>
            <div class="modal-body" style="width: 600px; height: 600px;">
                <div id="divMapContainer" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="modal-footer">
                <button class="close" onclick="copyCoordinatesFromMap()" data-dismiss="modal">Get Coordinates</button>
            </div>
        </div>
    </div>
</div>