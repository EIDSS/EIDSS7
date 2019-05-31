<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AggregateSettings.aspx.vb" Inherits="EIDSS.AggregateSettings" MasterPageFile="~/NormalView.Master" EnableViewState="true"  %>
<asp:content id="Content2" contentplaceholderid="EIDSSBodyCPH" runat="server">
          <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2> <asp:Label ID="Label1" runat="server" Text="Aggregate Settings"></asp:Label></h2>
        </div>
        <div class="panel-body">
            
            <asp:Table ID="Table1"  runat="server" CssClass="table">
                <asp:TableHeaderRow>
                    <asp:TableHeaderCell>Row Count</asp:TableHeaderCell>
                    <asp:TableHeaderCell>Aggregate Case Type</asp:TableHeaderCell>
                    <asp:TableHeaderCell>Administrative Level</asp:TableHeaderCell>
                    <asp:TableHeaderCell>Minimum Time Interval</asp:TableHeaderCell>
                </asp:TableHeaderRow>
               
            </asp:Table>
        </div>

        <div class="panel-footer">

            <asp:Button ID="submit" runat="server" Text="Submit" CssClass="btn btn-primary  pull-right" OnClick="submit_Click"  data-toggle="modal"  />
           <%-- <asp:Button ID="cancel" runat="server" Text="Cancel" CssClass="btn btn-default  pull-right" />--%>
            <div class="clearfix">
              
            </div>

       
        </div>
 
       
    </div>
         
  <div class="modal fade" id="resultsModal" tabindex="-1" role="dialog">
  <div class="modal-dialog " role="document">
    <div class="modal-content">
      <div class="modal-header danger">
        <h5 class="modal-title"><asp:Label ID="Label2" runat="server" Text="EIDSS"></asp:Label></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p><asp:Literal ID="resultsLiteral" runat="server"></asp:Literal></p>
      </div>
      <div class="modal-footer">
      <asp:Button ID="CloseSaveChangesMdlBtn" runat="server" Text="Close" CssClass="btn btn-primary" />
        <asp:Button ID="SaveChangesBtn" runat="server" Text="Save Changes" CssClass="btn btn-primary"  OnClick="SaveChangesBtn_Click"/>
      </div>
    </div>
  </div>
</div>
  <div class="modal fade" id="blankDropDownValuesModal" tabindex="-3" role="dialog">
  <div class="modal-dialog " role="document">
    <div class="modal-content">
      <div class="modal-header danger">
        <h5 class="modal-title"><asp:Label ID="Label3" runat="server" Text="EIDSS"></asp:Label></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p><asp:Literal ID="blankSelectionLiteral" runat="server"></asp:Literal></p>
      </div>
      <div class="modal-footer">
        <asp:Button ID="revertDataBtn" CssClass="btn btn-secondary" runat="server" Text="No"   OnClick="RevertData"/>
        <asp:Button ID="clearDataBtn" CssClass="btn btn-primary" runat="server" Text="Yes"  OnClick ="clearDataBtn_Click"/>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="VerificationModal" tabindex="-2" role="dialog">
  <div class="modal-dialog " role="document">
    <div class="modal-content">
      <div class="modal-header danger">
        <h5 class="modal-title"><asp:Label ID="Label4" runat="server" Text="EIDSS"></asp:Label></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p><asp:Literal ID="verificationLiteral" runat="server"></asp:Literal></p>
      </div>
      <div class="modal-footer">
        <asp:Button ID="Button1" CssClass="btn btn-secondary" runat="server" Text="Close" OnClick="CloseSaveChangesMdlBtn_Click"  />
        
      </div>
    </div>
  </div>
</div>
     </ContentTemplate>
            </asp:UpdatePanel>
</asp:content>
