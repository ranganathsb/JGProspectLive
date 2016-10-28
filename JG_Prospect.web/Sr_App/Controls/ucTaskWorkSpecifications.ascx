<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskWorkSpecifications.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskWorkSpecifications" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Src="~/Controls/CustomPager.ascx" TagPrefix="uc1" TagName="CustomPager" %>

<asp:UpdatePanel ID="upWorkSpecifications" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <table width="100%" cellspacing="0" cellpadding="0" class="table" style="display: none;">
            <thead>
                <tr class="trHeader">
                    <th>Id</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <asp:HiddenField ID="repWorkSpecifications_EditIndex" runat="server" Value="-1" />
                <asp:Repeater ID="repWorkSpecifications" runat="server"
                    OnItemDataBound="repWorkSpecifications_ItemDataBound"
                    OnItemCommand="repWorkSpecifications_ItemCommand">
                    <ItemTemplate>
                        <tr id="trWorkSpecification" runat="server" class="">
                            <td>
                                <asp:HiddenField ID="hdnId" runat="server" Value='<%#Eval("Id")%>' />
                                <small>
                                    <asp:LinkButton ID="lbtnEditWorkSpecification" runat="server" ForeColor="Blue" ClientIDMode="AutoID"
                                        CommandName="edit-work-specification" Text='<%#Eval("CustomId")%>' CommandArgument='<%# Container.ItemIndex%>' />
                                    <asp:Literal ID="ltrlCustomId" runat="server" Text='<%#Eval("CustomId") %>' />
                                </small>
                            </td>
                            <td>
                                <div id="divViewDescription" runat="server" style="background-color: white; min-height: 20px; margin: 3px; padding: 3px;">
                                    <div style="margin-bottom: 10px;">
                                        <asp:Literal ID="ltrlDescription" runat="server" />
                                    </div>
                                    <asp:LinkButton ID="lbtnAddSubWorkSpecification" runat="server" ClientIDMode="AutoID" Text="Add Sub Section"
                                        CommandName="add-sub-work-specification" CommandArgument='<%# Container.ItemIndex %>' />&nbsp;&nbsp;<asp:LinkButton
                                            ID="lbtnToggleSubWorkSpecification" runat="server" ClientIDMode="AutoID" Text="View Sub Section"
                                            CommandName="show-sub-work-specification" CommandArgument='<%# Container.ItemIndex %>' />
                                    <asp:PlaceHolder ID="phSubWorkSpecification" runat="server" />
                                </div>
                                <div id="divEditDescription" runat="server">
                                    <CKEditor:CKEditorControl ID="ckeWorkSpecification" runat="server" Height="200" BasePath="~/ckeditor" />
                                    <br />
                                    <asp:LinkButton ID="lbtnSaveWorkSpecification" runat="server" ClientIDMode="AutoID" Text="Save"
                                        CommandName="save-work-specification" CommandArgument='<%# Container.ItemIndex %>' />&nbsp;&nbsp;<asp:LinkButton
                                            ID="lbtnCancelEditing" runat="server" ClientIDMode="AutoID" Text="Cancel" CommandName="cancel-edit-work-specification" />
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
            <tfoot>
                <tr class="FirstRow">
                    <td>
                        <small>
                            <asp:Literal ID="ltrlCustomId" runat="server" Text='<%#Eval("CustomId") %>' />
                        </small>
                    </td>
                    <td>
                        <CKEditor:CKEditorControl ID="ckeWorkSpecification" runat="server" Height="200" BasePath="~/ckeditor" Visible="true" />
                        <br />
                        <asp:LinkButton ID="lbtnInsertWorkSpecification" runat="server" Text="Add" ClientIDMode="AutoID" CausesValidation="false"
                            OnClick="lbtnInsertWorkSpecification_Click" />
                    </td>
                </tr>
                <tr class="pager">
                    <td colspan="2">
                        <uc1:CustomPager ID="repWorkSpecificationsPager" runat="server" PageSize="5" PagerSize="10" />
                    </td>
                </tr>
            </tfoot>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>

<div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0">
</div>

<div data-id="WorkSpecificationSectionTemplate" class="hide">
    <table data-id="tblWorkSpecification" data-parent-work-specification-id="0" class="table" width="100%" cellspacing="0" cellpadding="0">
        <thead>
            <tr class="trHeader">
                <th>Id</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
        <tfoot>
            <tr class="FirstRow">
                <td>
                    <small>
                        <label data-id="lblCustomId" />
                    </small>
                </td>
                <td>
                    <textarea data-id="txtWorkSpecification" rows="4" style="width: 95%;"></textarea>
                    <br />
                    <button data-id="btnAddWorkSpecification" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnAddClick(this);">Add</button>
                </td>
            </tr>
            <tr class="pager">
                <td colspan="2">&nbsp;
                </td>
            </tr>
        </tfoot>
    </table>
</div>

<script type="text/javascript">

    var strWorkSpecificationSectionTemplate = $('div[data-id="WorkSpecificationSectionTemplate"]').html().toString();
    //var strWorkSpecificationRowTemplate = $('div[data-id="WorkSpecificationRowTemplate"]').html().toString();
    var strWorkSpecificationRowTemplate =
    '    <tr data-work-specification-id="0">'+
    '        <td valign="top">'+
    '            <small>'+
    '                <label data-id="lblCustomId" />'+
    '            </small>'+
    '        </td>'+
    '        <td>'+
    '            <div style="margin-bottom: 10px;">'+
    '                <textarea data-id="txtWorkSpecification" rows="4" style="width: 95%;"></textarea>'+
    '                <br />'+
    '                <button data-id="btnSave" data-work-specification-id="0" onclick="javascript:return OnSaveClick(this);">Save</button>&nbsp;'+
    '            </div>'+
    '            <button data-id="btnAddSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnAddSubSectionClick(this);">Add Sub Section</button>&nbsp;'+
    '            <button data-id="btnViewSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnViewSubSectionClick(this);">View Sub Section</button>&nbsp;'+
    '            <button data-id="btnHideSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnHideSubSectionClick(this);">Hide Sub Section</button>'+
    '            <div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0"></div>'+
    '        </td>'+
    '    </tr>';

    var TaskId = <%=this.TaskId%>;
    var blIsAdmin= <%=this.IsAdminAndItLeadMode.ToString().ToLower()%>;

    $(document).ready(function() {
    
        Initialize_WorkSpecifications();

    });

    function Initialize_WorkSpecifications() {
        console.log('Initialize_WorkSpecifications');
        
        var intParentWorkSpecificationId = 0;

        GetWorkSpecifications(intParentWorkSpecificationId, OnWorkSpecificationsResponseReceived);
    }

    function OnWorkSpecificationsResponseReceived(arrData,intParentWorkSpecificationId){
    
        var $WorkSpecificationSectionTemplate = $(strWorkSpecificationSectionTemplate);
        
        $WorkSpecificationSectionTemplate.attr('data-parent-work-specification-id', intParentWorkSpecificationId);
        $WorkSpecificationSectionTemplate.find('button[data-id="btnAddWorkSpecification"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);

        for (var i = 0; i < arrData.length; i++) {
            var $WorkSpecificationRowTemplate = $(strWorkSpecificationRowTemplate);
            if(i%2==0){
                $WorkSpecificationRowTemplate.addClass('AlternateRow');
            }
            else {
                $WorkSpecificationRowTemplate.addClass('FirstRow');
            }

            $WorkSpecificationRowTemplate.attr('data-work-specification-id', arrData[i].Id);
            $WorkSpecificationRowTemplate.find('label[data-id="lblCustomId"]').html(arrData[i].CustomId);
            $WorkSpecificationRowTemplate.find('textarea[data-id="txtWorkSpecification"]').html(arrData[i].Description);
            $WorkSpecificationRowTemplate.find('button[data-id="btnSave"]').attr('data-work-specification-id', arrData[i].Id);
            $WorkSpecificationRowTemplate.find('button[data-id="btnSave"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);

            $WorkSpecificationRowTemplate.find('button[data-id="btnAddSubSection"]').attr('data-work-specification-id', arrData[i].Id);
            $WorkSpecificationRowTemplate.find('button[data-id="btnViewSubSection"]').attr('data-work-specification-id', arrData[i].Id);
            $WorkSpecificationRowTemplate.find('button[data-id="btnHideSubSection"]').attr('data-work-specification-id', arrData[i].Id);
            $WorkSpecificationRowTemplate.find('button[data-id="btnAddSubSection"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);
            $WorkSpecificationRowTemplate.find('button[data-id="btnViewSubSection"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);
            $WorkSpecificationRowTemplate.find('button[data-id="btnHideSubSection"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);

            $WorkSpecificationRowTemplate.find('div[data-id="WorkSpecificationPlaceholder"]').attr('data-parent-work-specification-id', arrData[i].Id);

            $WorkSpecificationSectionTemplate.find('tbody').append($WorkSpecificationRowTemplate);
        }

        $('div[data-parent-work-specification-id="'+intParentWorkSpecificationId+'"]').append($WorkSpecificationSectionTemplate);
    }

    function GetWorkSpecifications(intParentWorkSpecificationId,callback) {

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/GetTaskWorkSpecifications',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ TaskId: ' +TaskId  + ', blIsAdmin: ' + blIsAdmin + ', intParentTaskWorkSpecificationId: ' + intParentWorkSpecificationId + ' }',
                asynch: false,
                success: function (data) {
                    console.log(data.d);
                    console.log(intParentWorkSpecificationId);
                    if(typeof(callback)==="function"){
                        callback(data.d,intParentWorkSpecificationId);
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                }
            }
        );
    }
    
    function OnAddClick(sender) { 

        var $table = $('table[data-parent-work-specification-id="'+$(sender).attr('data-parent-work-specification-id')+'"]');
        var strCustomId = $table.find('tfoot').find('label[data-id="lblCustomId"]').text();
        var strDescription = $table.find('tfoot').find('textarea[data-id="txtWorkSpecification"]').text();
        var intParentTaskWorkSpecificationId = parseInt($table.attr('data-parent-work-specification-id'));

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + 0 + ', strCustomId: "' + strCustomId + '", strDescription: "' + strDescription + '", intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentTaskWorkSpecificationId + ' }',
                asynch: false,
                success: function (data) {
                    console.log(data.d);
                    console.log(intParentWorkSpecificationId);
                    if(typeof(callback)==="function"){
                        //callback(data.d,intParentWorkSpecificationId);
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                }
            }
        );

        return false;
    }

    function OnSaveClick(sender) {
    
        var $table = $('table[data-parent-work-specification-id="'+$(sender).attr('data-parent-work-specification-id')+'"]');
        var $tr = $('tr[data-work-specification-id="'+$(sender).attr('data-work-specification-id')+'"]');
        var strCustomId = $tr.find('label[data-id="lblCustomId"]').text();
        var strDescription = $tr.find('textarea[data-id="txtWorkSpecification"]').text();
        var intParentTaskWorkSpecificationId = parseInt($table.attr('data-parent-work-specification-id'));
        var intTaskWorkSpecificationId = parseInt($tr.attr('data-work-specification-id'));

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + intTaskWorkSpecificationId + ', strCustomId: "' + strCustomId + '", strDescription: "' + strDescription + '", intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentTaskWorkSpecificationId + ' }',
                asynch: false,
                success: function (data) {
                    console.log(data.d);
                    console.log(intParentWorkSpecificationId);
                    if(typeof(callback)==="function"){
                        //callback(data.d,intParentWorkSpecificationId);
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                }
            }
        );

        return false;
    }

    function OnAddSubSectionClick(sender) {
        $sender = $(sender);
        
        GetWorkSpecifications(parseInt($sender.attr('data-work-specification-id')), OnWorkSpecificationsResponseReceived);
        
        return false;
    }

    function OnViewSubSectionClick(sender) {
        $sender = $(sender);

        GetWorkSpecifications(parseInt($sender.attr('data-work-specification-id')), OnWorkSpecificationsResponseReceived);

        return false;
    }

    function OnHideSubSectionClick(sender) {
        $sender = $(sender);

        $('table[data-parent-work-specification-id="' + $sender.attr('data-work-specification-id') + '"]').remove();

        return false;
    }
</script>
