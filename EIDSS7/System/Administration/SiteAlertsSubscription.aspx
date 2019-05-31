<%@ Page Title="Site Alert Subscription"  Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="SiteAlertsSubscription.aspx.vb" Inherits="EIDSS.SiteAlertsSubscription" meta:resourcekey="PageResource1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:HiddenField ID="hiddenBaseRoute" ClientIDMode="Static" runat="server" />
    <div class="panel panel-default">
        <div class="panel-heading">
          <h2>  <asp:Label ID="Label1" runat="server" Text="Site Alerts Subscription"></asp:Label></h2>
        </div>

        <div class="panel-body">
            <table id="AlertsTable" class="display" style="width: 100%">
                <thead>
                    <tr>
                        <th><%GetLocalResourceObject("tblheaderRow") %></th>
                        <th><%GetLocalResourceObject("tblheaderEventName") %></th>
                        <th><%GetLocalResourceObject("tblheaderRecieveEventAlert") %></th>
                        <th><%GetLocalResourceObject("tblheaderRecipient") %></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <div id="panelFooter" class="panel-footer">
            <input type="button" id="btn_selectAll" class="btn btn-default"  value="Select All" />
            <input type="button" id="btn_unSelectAll" class="btn btn-default"  value="Unselect All" />
            <asp:Button ID="btn_submit" CssClass="btn btn-default" runat="server" Text="Submit" />
            <asp:Button ID="btn_cancel" runat="server" CssClass="btn btn-default" Text="Cancel" />
        </div>
    </div>
    


    <script type="text/javascript">
        var table;
        $(document).ready(function () {
            PageMethods.LoadSubscriptionAlertTypes("en",BuildTableWithData,onFailure);
        });

        function BuildTableWithData(data) {
            var subsriptionData = data;
            var deserializedHumanDiseaseObj = JSON.parse(subsriptionData);
            //alert(JSON.stringify(deserializedHumanDiseaseObj));
            TableData = [];
            //ReferenceData.data = [];
            newRowId = deserializedHumanDiseaseObj.length;


            for (var i = 0; i < deserializedHumanDiseaseObj.length; i++) {
                item = [];
                tableRow = new Object();
                item.push(i.toString());
                item.push(deserializedHumanDiseaseObj[i].strDefault);
                item.push("");
                item.push("");
                item.push(deserializedHumanDiseaseObj[i].idfsBaseReference);


                TableData.push(item);
            }





            if ($.fn.dataTable.isDataTable('#AlertsTable')) {
                table = $('#AlertsTable').DataTable();
                table.destroy();
            }

            table = $('#AlertsTable').DataTable({
                processing: true,
                data: TableData,
                columns: [
                    { title: "Row" },
                    { title: "Event Name" },
                    { title: "Receive Event Alert" },
                    { title: "Recipients" },
                    { title: "basereference" }
                ],
                columnDefs: [
                    {
                        //Index
                        targets: [0], type: "dom-text", render: function (data, type, row, meta) {
                            return data;
                        }
                    },
                    {

                        targets: [1], visible: true, type: "dom-text", render: function (data, type, row, meta) {
                            return data;
                        }
                    },
                    {


                        targets: [2], className: 'select-checkbox', 'render': function (data, type, full, meta) {
                            return '<input type="checkbox">';
                        }
                    },
                    {


                        targets: [3], render:
                            function (data, type, row, meta) { return createRecipients(data, type, row, meta); }
                    },
                    {

                        targets: [4],
                        visible: true
                    }

                ]
                ,
                deferRender: true,
                searching: false,
                bLengthChange: true,
                rowReorder: true
            });
        }
        function onFailure(data) {

        }        
        function GetData(versionId) {
            //alert(versionId);
            var endpoint = baseRoute + 'api/Configuration/GetEventSubriptionTypes?Version';
            // console.log(baseRoute);
            $.ajax({
                url: endpoint,
                type: 'GET',
                data: {
                    'idfVersion': versionId
                },
                dataType: 'json',
                success: function (data) {
                    var newMatrixData = JSON.parse(data.Results);
                    BuildTableWithData(JSON.stringify(newMatrixData));
                    table = $('#HumanAggregateCaseTable').DataTable();
                    //Get the last row id for incrementing the rowid when adding a new row
                    table.rows().eq(0).each(function (index) {
                        var row = table.row(index);
                        if (row.data()[0] != undefined & row.data()[0] != "") {
                            newRowId = row.data()[0];
                        }
                    });
                },
                error: function (request, error) {
                    alert("Request: " + JSON.stringify(request));
                }
            });
        }

        function createSelect(data) {

        }


         // Handle click on "Select all" control
      
        $('#btn_unSelectAll').on('click', function (e) {
          
                $('#AlertsTable tbody input[type="checkbox"]:checked').trigger('click');
            
            // Prevent click event from propagating to parent
            e.stopPropagation();
        });

        $('#btn_selectAll').on('click', function (e) {
          
                $('#AlertsTable tbody input[type="checkbox"]:not(checked)').trigger('click');
            
            // Prevent click event from propagating to parent
            e.stopPropagation();
        });




        function createRecipients(data, type, row, meta) {
            var rowId = meta.row;
            //console.log(meta);
            var sel = "<select class='tableDropDown form-control' title='" + rowId + "'><option> </option>";
            //for (var i = 0; i < diseaseForGridDropDown.length; i++) {
            //    if (data == diseaseForGridDropDown[i].idfsBaseReference) {
            //        sel += "<option   value = '" + diseaseForGridDropDown[i].idfsBaseReference + "' selected >" + diseaseForGridDropDown[i].strDefault + "</option>";
            //    }
            //    else {
                      sel += "<option   value = '' >Original</option>";
                      sel += "<option   value = '' >Sites</option>";
                      sel += "<option   value = '' >All Sites</option>";
              //  }

           // }
            sel += "</select>";
            return sel;
        }
        function createAlertAction(data, type, row, meta) {
            var rowId = meta.row;
            var sel = "<input type='checkbox' name='notify' value='1'>";
            return sel;
        }
    </script>
</asp:Content>
