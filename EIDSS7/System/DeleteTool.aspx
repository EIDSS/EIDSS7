<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="DeleteTool.aspx.vb" Inherits="EIDSS.DeleteTool" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="page-heading">
        <h2 meta:resourcekey="Hdg_Page" runat="server"></h2>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="sectionContainer">
                    <asp:Panel ID="pnlStatus" runat="server" CssClass="alert" Visible="false">
                        <asp:Literal ID="litStatus" runat="server"></asp:Literal>
                    </asp:Panel>
                    <section id="SearchSection" runat="server" class="hidden">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-9">
                                        <h3 class="heading" meta:resourcekey="Hdg_Search" runat="server"></h3>
                                    </div>
                                    <div class="col-md-3 heading text-right">
                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="form-group" meta:resourcekey="Dis_Search" runat="server">
                                    <asp:Label
                                        AssociatedControlID="ddlSearch"
                                        ID="lblSearch"
                                        meta:ResourceKey="Lbl_Search"
                                        runat="server"></asp:Label>
                                    <asp:DropDownList
                                        AppendDataBoundItems="true"
                                        CssClass="form-control"
                                        ID="ddlSearch"
                                        onchange="changeSearchType(); return false;"
                                        runat="server">
                                        <asp:ListItem Value="" Text="-Select-"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator
                                        ControlToValidate="ddlSearch"
                                        CssClass=""
                                        Display="Dynamic"
                                        meta:resourcekey="Val_Search"
                                        runat="server"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" meta:resourcekey="Dis_Search_ID" runat="server">
                                    <asp:Label
                                        AssociatedControlID="txtSearchID"
                                        ID="lblSearchID"
                                        meta:ResourceKey="Lbl_Search_ID"
                                        runat="server"></asp:Label>
                                    <asp:TextBox
                                        CssClass="form-control"
                                        ID="txtSearchID"
                                        runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ControlToValidate="txtSearchID"
                                        CssClass=""
                                        Display="Dynamic"
                                        meta:resourcekey="Val_Search_ID"
                                        runat="server"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group text-center" meta:resourcekey="Dis_Search_Button" runat="server">
                                    <input
                                        class="btn btn-default"
                                        id="btnSearch"
                                        meta:resourcekey="Btn_Search"
                                        onclick="searchTree();"
                                        runat="server"
                                        type="button" />
                                </div>
                            </div>
                        </div>
                    </section>
                    <section id="ListSection" runat="server" class="hidden">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-9">
                                        <h3 class="heading" meta:resourcekey="Hdg_List" runat="server"></h3>
                                    </div>
                                    <div class="col-md-3 heading text-right">
                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)"></a>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                            </div>
                        </div>
                    </section>
                </div>
                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                    <MenuItems>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab="0"
                            ID="sideBarItemSearch"
                            IsActive="true"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_Search"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-ok"
                            GoToTab="1"
                            ID="sideBarItemList"
                            IsActive="true"
                            ItemStatus="IsNormal"
                            meta:resourcekey="Tab_List"
                            runat="server">
                        </eidss:SideBarItem>
                        <eidss:SideBarItem
                            CssClass="glyphicon glyphicon-file"
                            GoToTab="2"
                            ID="sideBarItemReview"
                            IsActive="true"
                            ItemStatus="IsReview"
                            meta:resourcekey="Tab_Review"
                            runat="server">
                        </eidss:SideBarItem>
                    </MenuItems>
                </eidss:SideBarNavigation>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <input
                        class="btn btn-default"
                        id="btnCancel"
                        meta:resourcekey="Btn_Cancel"
                        onclick="location.replace('../Dashboard.aspx')"
                        runat="server"
                        type="button" />
                    <input
                        class="btn btn-default"
                        id="btnPreviousSection"
                        meta:resourcekey="Btn_Back"
                        onclick="goBackToPreviousPanel(); return false;"
                        runat="server"
                        type="button" />
                    <input
                        class="btn btn-default"
                        id="btnNextSection"
                        meta:resourcekey="Btn_Continue"
                        onclick="goForwardToNextPanel(); return false;"
                        runat="server"
                        type="button" />
                    <asp:Button
                        ID="btnSubmit"
                        CssClass="btn btn-primary hidden"
                        meta:ResourceKey="Btn_Delete"
                        runat="server" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
    <script type="text/javascript">

        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
            setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
        });

        function callBackHandler() {
            setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
        };
        function changeSearchType() {
            var search = $("#<%= ddlSearch.ClientID %>").val()
            $("#<%= lblSearchID.ClientID %>").text(search)
        };

        function searchTree() {
            var searchLabel = $("#<%= lblSearchID.ClientID %>").text();
            var searchValue = $("#<%= txtSearchID.ClientID %>").val();
            $.ajax({
                type: "POST",
                url: "DeleteTool.aspx/GetSearchResults",
                data: JSON.stringify({ "searchLabel": searchLabel, "searchVal": searchValue }),
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                success: function (data) {
                    var listResults = $("#<%= ListSection.ClientID %>").find(".panel-body");
                    if (listResults.length >= 0) {
                        listResults.empty();
                        goToTab(1);
                        listResults.append(data.d);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        };
    </script>
</asp:Content>
