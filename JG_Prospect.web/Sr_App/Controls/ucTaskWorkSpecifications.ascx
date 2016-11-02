<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskWorkSpecifications.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskWorkSpecifications" %>

<div>
    <table class="table" width="100%" cellspacing="0" cellpadding="0">
        <thead>
            <tr class="trHeader">
                <th style="width: 10%;">ID
                </th>
                <th>Description
                </th>
            </tr>
        </thead>
    </table>
</div>
<div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0">
</div>

<script data-id="tmpWorkSpecificationSection" type="text/template" class="hide">
    <table data-id="tblWorkSpecification" data-parent-work-specification-id="{parent-id}" class="table" width="100%" cellspacing="0" cellpadding="0">
        <thead>
            <tr class="trHeader">
            </tr>
        </thead>
        <tbody>
        </tbody>
        <tfoot>
            <tr class="FirstRow">
                <td>
                    <small>
                        <label data-id="lblCustomId{parent-id}_Footer" />
                    </small>
                </td>
                <td>
                    <textarea data-id="txtWorkSpecification{parent-id}_Footer" rows="4" style="width: 95%;"></textarea>
                    <br />
                    <button data-id="btnAdd{parent-id}_Footer" data-parent-work-specification-id="{parent-id}" onclick="javascript:return OnAddClick(this);">Add</button>
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
    <tr data-work-specification-id="{id}">
        <td valign="top">
            <small>
                <label data-id="lblCustomId{id}" />
            </small>
        </td>
        <td>
            <div style="margin-bottom: 10px;">
                <div data-id="divViewWorkSpecification{id}">
                    <div style="float:left;width:75%;">
                        <label data-id="lblWorkSpecification{id}" style="width: 90%; padding: 3px; display:block; line-height:15px; background-color: white;"></label>
                    </div>
                    <div style="float:left;width:20%;">
                        <a href="javascript:void(0);" data-work-specification-id="{id}" onclick="javascript:return OnEditClick(this);" >Edit</a>&nbsp;
                        <a href="javascript:void(0);" data-work-specification-id="{id}" onclick="javascript:return OnDeleteClick(this);" >Delete</a>
                    </div>
                    <div style="float:none; clear:both;"></div>
                </div>
                <div data-id="divEditWorkSpecification{id}">
                    <div style="float:left;width:75%;">
                        <textarea data-id="txtWorkSpecification{id}" rows="4" style="width: 95%;"></textarea>
                    </div>
                    <div style="float:left;width:20%;">
                        <a href="javascript:void(0);" data-id="btnSave{id}" data-work-specification-id="{id}" data-parent-work-specification-id="{parent-id}" onclick="javascript:return OnSaveClick(this);">Save</a>&nbsp;
                        <a href="javascript:void(0);" data-work-specification-id="{id}" onclick="javascript:return OnCancelEditClick(this);" >Cancel</a>
                    </div>
                    <div style="float:none; clear:both;"></div>
                </div>
                <a href="javascript:void(0);" data-id="btnViewSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnViewSubSectionClick(this);">View More(+)</a>
                <a href="javascript:void(0);" data-id="btnHideSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnHideSubSectionClick(this);">View Less(-)</a>&nbsp;
                <a href="javascript:void(0);" data-id="btnAddSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnAddSubSectionClick(this);">View More(+)</a>&nbsp;
            </div>
            <br />
            <div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="{id}"></div>
        </td>
    </tr>
</script>

<script type="text/javascript">

    var strWorkSpecificationSectionTemplate = $('script[data-id="tmpWorkSpecificationSection"]').html().toString();
    var strWorkSpecificationRowTemplate = $('script[data-id="tmpWorkSpecificationRow"]').html().toString();

    var TaskId = <%=this.TaskId%>;
    var blIsAdmin= <%=this.IsAdminAndItLeadMode.ToString().ToLower()%>;

    $(document).ready(function() {
    
        //Initialize_WorkSpecifications();

    });

    function Initialize_WorkSpecifications() {
        GetWorkSpecifications(0, OnWorkSpecificationsResponseReceived);
    }

    function OnWorkSpecificationsResponseReceived(result,intParentId){

        var $WorkSpecificationSectionTemplate = $(strWorkSpecificationSectionTemplate.replace(/{parent-id}/gi,intParentId));
        
        $WorkSpecificationSectionTemplate.find('label[data-id="lblCustomId'+intParentId+'_Footer"]').html(result.NextCustomId);

        if(result.TotalRecordCount > 0) {

            var arrData = result.Records;

            for (var i = 0; i < arrData.length; i++) {
                var $WorkSpecificationRowTemplate = $(strWorkSpecificationRowTemplate.replace(/{parent-id}/gi,intParentId).replace(/{id}/gi,arrData[i].Id));

                if(i % 2 == 0) {
                    $WorkSpecificationRowTemplate.addClass('AlternateRow');
                }
                else {
                    $WorkSpecificationRowTemplate.addClass('FirstRow');
                }

                $WorkSpecificationRowTemplate.find('label[data-id="lblCustomId'+arrData[i].Id+'"]').html(arrData[i].CustomId);
                $WorkSpecificationRowTemplate.find('textarea[data-id="txtWorkSpecification'+arrData[i].Id+'"]').html(arrData[i].Description);
                $WorkSpecificationRowTemplate.find('label[data-id="lblWorkSpecification'+arrData[i].Id+'"]').html(arrData[i].Description);
                
                $WorkSpecificationRowTemplate.find('div[data-id="divEditWorkSpecification'+arrData[i].Id+'"]').hide();
                $WorkSpecificationRowTemplate.find('a[data-id="btnHideSubSection'+arrData[i].Id+'"]').hide();

                if(arrData[i].TaskWorkSpecificationsCount == 0) {
                    $WorkSpecificationRowTemplate.find('a[data-id="btnViewSubSection'+arrData[i].Id+'"]').hide();
                }
                else {
                    $WorkSpecificationRowTemplate.find('a[data-id="btnAddSubSection'+arrData[i].Id+'"]').hide();
                    //$WorkSpecificationRowTemplate.find('a[data-id="btnViewSubSection'+arrData[i].Id+'"]').text('View ' + arrData[i].TaskWorkSpecificationsCount + ' More(+)');
                }

                $WorkSpecificationSectionTemplate.find('tbody').append($WorkSpecificationRowTemplate);
            }
        }

        // clear div and append new result.
        $('div[data-parent-work-specification-id="'+intParentId+'"]').html('');
        $('div[data-parent-work-specification-id="'+intParentId+'"]').append($WorkSpecificationSectionTemplate);
    }

    function GetWorkSpecifications(intParentId,callback) {
        
        ShowAjaxLoader();

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/GetTaskWorkSpecifications',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ TaskId: ' +TaskId  + ', blIsAdmin: ' + blIsAdmin + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(typeof(callback)==="function"){
                        callback(data.d,intParentId);
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                    HideAjaxLoader();
                }
            }
        );
    }
    
    function OnEditClick(sender) {
        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');

        // show edit and hide view section.
        $('div[data-id="divEditWorkSpecification' + Id + '"]').show();
        $('div[data-id="divViewWorkSpecification' + Id + '"]').hide();

        return false;
    }

    function OnDeleteClick(sender) {

        ShowAjaxLoader();

        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/DeleteTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + Id + ' }',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d) {
                        GetWorkSpecifications(intParentId, OnWorkSpecificationsResponseReceived);
                        alert('Specification deleted successfully.');
                    }
                    else {
                        alert('Specification delete was not successfull, Please try again later.');
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                    HideAjaxLoader();
                }
            }
        );

        return false;
    }

    function OnCancelEditClick(sender) {
        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');

        // show view and hide edit section.
        $('div[data-id="divViewWorkSpecification' + Id + '"]').show();
        $('div[data-id="divEditWorkSpecification' + Id + '"]').hide();

        return false;
    }

    function OnAddClick(sender) { 
        
        ShowAjaxLoader();

        var Id= 0;
        var intParentId = $(sender).attr('data-parent-work-specification-id');
        var strCustomId = $.trim($('label[data-id="lblCustomId'+intParentId+'_Footer"]').text());
        var strDescription = $.trim($('textarea[data-id="txtWorkSpecification'+intParentId+'_Footer"]').val());
        
        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + Id + ', strCustomId: "' + strCustomId + '", strDescription: "' + strDescription + '", intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d) {
                        GetWorkSpecifications(intParentId, OnWorkSpecificationsResponseReceived);
                        alert('Specification saved successfully.');
                    }
                    else {
                        alert('Specification update was not successfull, Please try again later.');
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                    HideAjaxLoader();
                }
            }
        );

        return false;
    }

    function OnSaveClick(sender) {
    
        ShowAjaxLoader();

        var Id= $(sender).attr('data-work-specification-id');
        var intParentId = $(sender).attr('data-parent-work-specification-id');
        var strCustomId = $.trim($('label[data-id="lblCustomId'+Id+'"]').text());
        var strDescription = $.trim($('textarea[data-id="txtWorkSpecification'+Id+'"]').val());
        
        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + Id + ', strCustomId: "' + strCustomId + '", strDescription: "' + strDescription + '", intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d) {
                        alert('Specification saved successfully.');
                        OnCancelEditClick(sender);
                    }
                    else {
                        alert('Specification update was not successfull, Please try again later.');
                    }
                },
                error: function (a, b, c) {
                    console.log(a);
                    HideAjaxLoader();
                }
            }
        );

        return false;
    }

    function OnAddSubSectionClick(sender) {
        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');

        // load sub specifications section.
        GetWorkSpecifications(Id, OnWorkSpecificationsResponseReceived);
        
        // show view sub specifications section button.
        $('a[data-id="btnHideSubSection' + Id + '"]').show();

        $sender.hide();

        return false;
    }

    function OnViewSubSectionClick(sender) {
        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');

        // load sub specifications section.
        GetWorkSpecifications(Id, OnWorkSpecificationsResponseReceived);
        
        // show view sub specifications section button.
        $('a[data-id="btnHideSubSection' + Id + '"]').show();

        $sender.hide();

        return false;
    }

    function OnHideSubSectionClick(sender) {
        $sender = $(sender);

        var Id = $sender.attr('data-work-specification-id');

        // hide / remove sub specifications section.
        $('table[data-parent-work-specification-id="' + Id + '"]').remove();

        // show view sub specifications section button.
        $('a[data-id="btnViewSubSection' + Id + '"]').show();

        $sender.hide();

        return false;
    }

    function ShowAjaxLoader(){
        $('.loading').show();
    }

    function HideAjaxLoader(){
        $('.loading').hide();
    }
</script>
