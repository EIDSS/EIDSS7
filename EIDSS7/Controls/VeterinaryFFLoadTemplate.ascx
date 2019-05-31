<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VeterinaryFFLoadTemplate.ascx.vb" Inherits="EIDSS.VeterinaryFFLoadTemplate" %>
<asp:UpdatePanel runat="server" ID="upFlexFormTemplate" UpdateMode="Conditional">
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server">
            <asp:HiddenField runat="server" ID="hdfDiseaseID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfFormTypeID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfCountryID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfObservationID" Value="null" />
            <asp:HiddenField runat="server" ID="hdfFormTemplateID" Value="null" />
        </div>
        <fieldset>
            <legend>
                <asp:Label runat="server" ID="lbl_legend_title"></asp:Label></legend>
            <asp:Panel runat="server" ID="pnlFlexForm" Width="100%">
            </asp:Panel>
        </fieldset>
    </ContentTemplate>
</asp:UpdatePanel>