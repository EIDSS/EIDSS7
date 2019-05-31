<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PrintBarCodeUserControl.ascx.vb" Inherits="EIDSS.PrintBarCodeUserControl" %>
<asp:UpdatePanel ID="upPrintBarCode" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <style>
            @font-face {
                font-family: 'Code39Barcode.fog';
                src: url('../Includes/Fonts/Code39Barcode.fog.eot');
                src: url('../Includes/Fonts/Code39Barcode.fog.eot?#iefix') format('embedded-opentype'), url('../Includes/Fonts/Code39Barcode.fog.woff2') format('woff2'), url('../Includes/Fonts/Code39Barcode.fog.woff') format('woff'), url('../Includes/Fonts/Code39Barcode.fog.ttf') format('truetype'), url('../Includes/Fonts/Code39Barcode.fog.svg#Code 39-hoch-Logitogo') format('svg');
            }
        </style>
        <div id="printThis">
            <asp:DataList ID="dlBarCodes" runat="server" RepeatColumns="2" RepeatLayout="Table" RepeatDirection="Vertical" DataKeyField="SampleID">
                <ItemTemplate>
                    <div class="col-md-6">
                        <div class="barCode">
                            <div class="barCodePatientFarmOwnerName"><%# Eval("PatientFarmOwnerName") %></div>
                            <br />
                            <div class="barCodeText">*<%# Eval("EIDSSLaboratorySampleID") %>*</div>
                            <br />
                            <div>
                                <span class="barCodeLaboratorySampleID"><%# Eval("EIDSSLaboratorySampleID") %></span>
                                <span class="barCodeCurrentDate pull-right"><%= DateTime.Now.ToString("MM/dd/yyyy") %></span>
                            </div>
                        </div>
                        <div id="divSeparator" runat="server" class="barCodeRecordSeparator"></div>
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
