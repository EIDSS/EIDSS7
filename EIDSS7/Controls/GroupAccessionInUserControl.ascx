<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="GroupAccessionInUserControl.ascx.vb" Inherits="EIDSS.GroupAccessionInUserControl" %>

<asp:UpdatePanel ID="upGroupAccession" runat="server">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnNewSampleToAccession" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfSiteID" runat="server" />
        <asp:HiddenField ID="hdfPersonID" runat="server" />
        <div class="row">
            <div class="table-responsive">
                <asp:UpdatePanel runat="server" ID="upSamplesToAccessionList">
                    <ContentTemplate>
                        <eidss:GridView AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Bottom" CssClass="table table-striped" DataKeyNames="SampleID" GridLines="None" ID="gvSamplesToAccessionList" EmptyDataText="<%$ Resources: Grd_Samples_To_Accession_List_Empty_Data %>" runat="server" UseAccessibleHeader="true" ShowHeader="true" ShowHeaderWhenEmpty="true">
                            <HeaderStyle CssClass="table-striped-header" />
                            <FooterStyle HorizontalAlign="Right" />
                            <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                            <Columns>
                                <asp:TemplateField ItemStyle-Width="200" HeaderStyle-Width="205">
                                    <HeaderTemplate>
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Local_Field_Sample_ID" runat="server"></div>
                                        <asp:Label ID="lblLocalFieldSampleID" runat="server" Text="<%$ Resources: Labels, Lbl_Local_Field_Sample_ID_Text %>"></asp:Label>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtEIDSSLocalFieldSampleID" runat="server" CssClass="form-control" Text='<%# Bind("EIDSSLocalFieldSampleID") %>' Enabled="false" Width="200"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </eidss:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
        <div style="width: 200px; float: none !important; display: inline-block !important;">
            <asp:TextBox ID="txtEIDSSLocalFieldSampleID" runat="server" CssClass="form-control" Width="200"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLocalFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Local_Field_Sample_ID" runat="server" ValidationGroup="GroupAccession"></asp:RequiredFieldValidator>
        </div>
        <div style="width: 50px; float: none !important; display: inline-block !important;">
            <asp:LinkButton ID="btnNewSampleToAccession" runat="server" CssClass="btn btn-primary btn-sm" CausesValidation="true" ValidationGroup="GroupAccession" OnClientClick="showGroupAccessionInLoading" data-loading-text="..."><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></asp:LinkButton>
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
            $("#<%= btnNewSampleToAccession.ClientID %>").focus();
            $("#<%= txtEIDSSLocalFieldSampleID.ClientID %>").text(data);
        },
        scanButtonKeyCode: 116, // the hardware scan button acts as key 116 (F5)
        scanButtonLongPressThreshold: 5, // assume a long press if 5 or more events come in sequence
        onError: function (string) {
        }
    });

    function showGroupAccessionInLoading() {
        var btn = $("#EIDSSBodyCPH_ucGroupAccessionIn_btnNewSampleToAccession");
        btn.button('loading');
        $.ajax("").always(function () {
            btn.button('reset');
        });
    };
</script>
