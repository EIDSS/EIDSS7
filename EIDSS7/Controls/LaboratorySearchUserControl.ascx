<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LaboratorySearchUserControl.ascx.vb" Inherits="EIDSS.LaboratorySearchUserControl" %>

<asp:UpdatePanel ID="upLaboratorySearch" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <div id="divHiddenFieldsSection" runat="server" class="row embed-panel" visible="false">
            <asp:HiddenField runat="server" ID="hdfUserID" Value="NULL" />
            <asp:HiddenField runat="server" ID="hdfDiseaseID" Value="" />
        </div>
        <div id="divBatchAddSampleToBatch" runat="server" class="row">
            <label class="addSampleToBatchLabel"><%= GetGlobalResourceObject("Labels", "Lbl_Add_Sample_To_Batch_Text") %></label>
        </div>
        <div class="row">
            <div class="flex-container search-group">
                <div class="form-group has-feedback has-clear">
                    <asp:TextBox ID="txtSearchString" runat="server" CssClass="form-control" Height="35" MaxLength="2000" autofocus="true" AutoCompleteType="Disabled"></asp:TextBox>
                    <span class="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden" onclick="clearSearch();"></span>
                </div>
                <span>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-default btn-md" CausesValidation="false"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>
                </span>
            </div>
        </div>
        <div class="row">
            <div class="advanced-search pull-right">
                <a href="#divSearchSampleModal" onclick="<%= AdvancedSearchPostBackItem %>" data-target="#divSearchSampleModal" data-toggle="modal">
                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Advanced_Search_Text %>"></asp:Literal></a>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<script type="text/javascript">
    $(document).scannerDetection({
        timeBeforeScanTest: 200, // wait for the next character for upto 200ms
        endChar: [13], // be sure the scan is complete if key 13 (enter) is detected
        avgTimeByChar: 100, // it's not a barcode if a character takes longer than 100ms
        ignoreIfFocusOn: 'input', // turn off scanner detection if an input has focus
        onComplete: function (data) {
            $("#<%= btnSearch.ClientID %>").focus();
            $("#<%= txtSearchString.ClientID %>").text(data);
        }, 
        scanButtonKeyCode: 116, // the hardware scan button acts as key 116 (F5)
	    scanButtonLongPressThreshold: 5, // assume a long press if 5 or more events come in sequence
        onError: function (string) {
            $("#<%= btnSearch.ClientID %>").focus();
            $("#<%= txtSearchString.ClientID %>").text(string);
        }
    });

    function clearSearch() {
        showLoading();
        __doPostBack("", "Clear Search");
    }
</script>