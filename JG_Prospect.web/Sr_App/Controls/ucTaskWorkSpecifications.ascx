<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskWorkSpecifications.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskWorkSpecifications" %>

<div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0">
</div>

<script data-id="tmpWorkSpecificationSection" type="text/template" class="hide">
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
</script>
<script data-id="tmpWorkSpecificationRow" type="text/template" class="hide">
    <tr data-work-specification-id="0">
        <td valign="top">
            <small>
                <label data-id="lblCustomId" />
            </small>
        </td>
        <td>
            <div style="margin-bottom: 10px;">
                <textarea data-id="txtWorkSpecification" rows="4" style="width: 95%;"></textarea>
                <br />
                <button data-id="btnSave" data-work-specification-id="0" onclick="javascript:return OnSaveClick(this);">Save</button>&nbsp;
                <button data-id="btnAddSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnAddSubSectionClick(this);">Add Sub Section</button>&nbsp;
                <button data-id="btnViewSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnViewSubSectionClick(this);">View Sub Section</button>&nbsp;
                <button data-id="btnHideSubSection" data-work-specification-id="0" data-parent-work-specification-id="0" onclick="javascript:return OnHideSubSectionClick(this);">Hide Sub Section</button>
            </div>
            <br />
            <div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0"></div>
        </td>
    </tr>
</script>

<script type="text/javascript">

    var strWorkSpecificationSectionTemplate = $('script[data-id="tmpWorkSpecificationSection"]').html().toString();
    var strWorkSpecificationRowTemplate = $('script[data-id="tmpWorkSpecificationRow"]').html().toString();

    var TaskId = <%=this.TaskId%>;
    var blIsAdmin= <%=this.IsAdminAndItLeadMode.ToString().ToLower()%>;

    $(document).ready(function() {
    
        Initialize_WorkSpecifications();

    });

    function Initialize_WorkSpecifications() {
        console.log('Initialize_WorkSpecifications');
        
        var intParentTaskWorkSpecificationId = 0;

        GetWorkSpecifications(intParentTaskWorkSpecificationId, OnWorkSpecificationsResponseReceived);
    }

    function OnWorkSpecificationsResponseReceived(result,intParentWorkSpecificationId){

        var $WorkSpecificationSectionTemplate = $(strWorkSpecificationSectionTemplate);
        
        $WorkSpecificationSectionTemplate.attr('data-parent-work-specification-id', intParentWorkSpecificationId);
        $WorkSpecificationSectionTemplate.find('button[data-id="btnAddWorkSpecification"]').attr('data-parent-work-specification-id', intParentWorkSpecificationId);
        $WorkSpecificationSectionTemplate.find('tfoot').find('label[data-id="lblCustomId"]').html(result.NextCustomId);

        if(result.TotalRecordCount > 0) {

            var arrData = result.Records;

            for (var i = 0; i < arrData.length; i++) {
                var $WorkSpecificationRowTemplate = $(strWorkSpecificationRowTemplate);

                if(i % 2 == 0) {
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

                $WorkSpecificationRowTemplate.find('button[data-id="btnHideSubSection"]').hide();

                if(arrData[i].TaskWorkSpecificationsCount == 0) {
                    $WorkSpecificationRowTemplate.find('button[data-id="btnViewSubSection"]').hide();
                }
                else {
                    $WorkSpecificationRowTemplate.find('button[data-id="btnAddSubSection"]').hide();
                }

                $WorkSpecificationSectionTemplate.find('tbody').append($WorkSpecificationRowTemplate);
            }
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
        var strCustomId = $.trim($table.find('tfoot').find('label[data-id="lblCustomId"]').text());
        var strDescription = $.trim($table.find('tfoot').find('textarea[data-id="txtWorkSpecification"]').val());
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
                    if(data.d) {
                        $table.remove();
                        GetWorkSpecifications(intParentTaskWorkSpecificationId, OnWorkSpecificationsResponseReceived);
                        alert('Specification updated successfully.');
                    }
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
        var strCustomId = $.trim($tr.find('label[data-id="lblCustomId"]').text());
        var strDescription = $.trim($tr.find('textarea[data-id="txtWorkSpecification"]').val());
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
                    if(data.d) {
                        alert('Specification updated successfully.');
                    }
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

        $sender.hide();

        return false;
    }

    function OnHideSubSectionClick(sender) {
        $sender = $(sender);

        $('table[data-parent-work-specification-id="' + $sender.attr('data-work-specification-id') + '"]').remove();

        $('button[data-id="btnViewSubSection",data-work-specification-id="' + $sender.attr('data-work-specification-id') + '"]').show();

        $sender.hide();

        return false;
    }
</script>
