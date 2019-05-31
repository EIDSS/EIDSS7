<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FlexFormLoadTemplate.ascx.vb" Inherits="EIDSS.FlexFormLoadTemplate" %>
    <%-- This will be loaded on the fly from the Database. --%>
    <%--    HumanCaseID - Property for Human Disease Report --%>
    <%--    DiseaseID - Property for HUman Disease Report, this is used to Parse and get the FormTemplate ID--%>
    <%--    LegendHeader - Property to load the Header for the Flex Form--%>

<%--'Please make sure all validationgroups are "FlexFormValidationGroup" that needs tobe validated. --%>

<%--                <asp:HiddenField runat="server" ID="hdfObservationID" Value="null" />  --%>
<%--This line is what holds the ObservationID and this is only one created, but FormTypeID and ObservationID are used to retrieve the FormTemplateID--%>



    <asp:UpdatePanel runat="server" ID="UpdatePanelFlexFormTemplate">
        <ContentTemplate>
            <div id="divHiddenFieldsSection" runat="server">
                <asp:HiddenField runat="server" ID="hdfDiagnosisID" Value="null" />
                <asp:HiddenField runat="server" ID="hdfFormTypeID" Value="null" />
                <asp:HiddenField runat="server" ID="hdfHumanCaseID" Value="null" />
                <asp:HiddenField runat="server" ID="hdfCountryID" Value="null" />
                <asp:HiddenField runat="server" ID="hdfObservationID" Value="null" />  
                <asp:HiddenField runat="server" ID="hdfFormTemplateID" Value="null" />
            </div>                  
            <fieldset>
                <legend><asp:Label runat="server" ID="lbl_legend_title"></asp:Label></legend>
                <asp:Panel runat="server" ID="pnlCaseClassification" Width="100%">
                </asp:Panel>
<%--                <asp:Button runat="server" ID="btnUpdate" Text="Update" CssClass="btn btn-default" />
                <asp:Button runat="server" ID="btnClear" Text="Clear" CausesValidation="false" CssClass="btn btn-default" />--%>
            </fieldset>
            
        </ContentTemplate>
    </asp:UpdatePanel>



