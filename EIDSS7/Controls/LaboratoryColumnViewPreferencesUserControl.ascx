<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LaboratoryColumnViewPreferencesUserControl.ascx.vb" Inherits="EIDSS.LaboratoryColumnViewPreferencesUserControl" %>
<div class="row">
    <div class="col-md-12">
        <p><%= GetLocalResourceObject("Lbl_Instructions_Text") %></p>
    </div>
</div>
<div class="row">
    <div class="col-md-12">&nbsp;</div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="checkbox checkboxlist col-lg-9">
            <asp:CheckBoxList ID="cbxColumnViewPreferences" runat="server" RepeatDirection="Vertical" RepeatLayout="OrderedList">
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Report_Session_ID_Text %>" Value="1" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Patient_Farm_Owner_Text %>" Value="2" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Region_Text %>" Value="3" Selected="False"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Rayon_Text %>" Value="4" Selected="False"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>" Value="5" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Sample_Status_Text %>" Value="6" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Lab_Sample_ID_Text %>" Value="7" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Sample_Type_Text %>" Value="8" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Accession_Date_Text %>" Value="9" Selected="True" Enabled="false"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Sample_Condition_Received_Text %>" Value="10" Selected="True" Enabled="false"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Accession_In_Comment_Text %>" Value="11" Selected="True" Enabled="false"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Test_Disease_Text %>" Value="12" Selected="True"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Test_Name_Text %>" Value="13" Selected="True" Enabled="false"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Functional_Area_Text %>" Value="14" Selected="True" Enabled="false"></asp:ListItem>
                <asp:ListItem Text="<%$ Resources: Labels, Lbl_Animal_ID_Text %>" Value="15" Selected="True"></asp:ListItem>
            </asp:CheckBoxList>
        </div>
    </div>
</div>
