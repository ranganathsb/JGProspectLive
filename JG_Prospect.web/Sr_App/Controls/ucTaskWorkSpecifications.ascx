<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucTaskWorkSpecifications.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucTaskWorkSpecifications" %>

<div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="0">
</div>

<script data-id="tmpWorkSpecificationSection" type="text/template" class="hide">
    <table data-id="tblWorkSpecification" data-parent-work-specification-id="{parent-id}" class="table" width="100%" cellspacing="0" cellpadding="0">
        <thead>
            <tr class="trHeader">
                <th style="width: 30px;">ID</th>
                <th>Description</th>
                <th style="width: 65px;">Sign Off</th>
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
                    <textarea data-id="txtWorkSpecification{parent-id}_Footer" id="txtWorkSpecification{parent-id}_Footer" rows="4" style="width: 95%;"></textarea>
                    <button data-id="btnAdd{parent-id}_Footer" data-parent-work-specification-id="{parent-id}" onclick="javascript:return OnAddClick(this);">Add</button>
                </td>
                <td>&nbsp;
                </td>
            </tr>
            <tr class="pager">
                <td colspan="3">&nbsp;
                </td>
            </tr>
        </tfoot>
    </table>
</script>
<script data-id="tmpWorkSpecificationRow" type="text/template" class="hide">
    <tr data-work-specification-id="{id}">
        <td valign="top" style="width: 30px;">
            <small>
                <label data-id="lblCustomId{id}" />
            </small>
        </td>
        <td>
            <div style="margin-bottom: 5px;">
                <div data-id="divViewWorkSpecification{id}">
                    <div data-id="divWorkSpecification{id}" style="padding: 3px; display: block; line-height: 15px; background-color: white;"></div>
                </div>
                <div data-id="divEditWorkSpecification{id}">
                    <textarea data-id="txtWorkSpecification{id}" id="txtWorkSpecification{id}"></textarea>
                </div>
                <div data-id="divViewWorkSpecificationButtons{id}" style="display: inline;">
                    <a href="javascript:void(0);" data-work-specification-id="{id}" onclick="javascript:return OnEditClick(this);">Edit</a>&nbsp;
                    <a href="javascript:void(0);" data-work-specification-id="{id}" data-parent-work-specification-id="{parent-id}" onclick="javascript:return OnDeleteClick(this);">Delete</a>&nbsp;
                </div>
                <div data-id="divEditWorkSpecificationButtons{id}" style="display: inline;">
                    <a href="javascript:void(0);" data-id="btnSave{id}" data-work-specification-id="{id}" data-parent-work-specification-id="{parent-id}" onclick="javascript:return OnSaveClick(this);">Save</a>&nbsp;
                    <a href="javascript:void(0);" data-work-specification-id="{id}" onclick="javascript:return OnCancelEditClick(this);">Cancel</a>&nbsp;
                </div>
                <a href="javascript:void(0);" data-id="btnAddSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnAddSubSectionClick(this);">View More(+)</a>
                <a href="javascript:void(0);" data-id="btnViewSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnViewSubSectionClick(this);">View More(+)</a>
                <a href="javascript:void(0);" data-id="btnHideSubSection{id}" data-work-specification-id="{id}" onclick="javascript:return OnHideSubSectionClick(this);">View Less(-)</a>
            </div>
            <div data-id="WorkSpecificationPlaceholder" data-parent-work-specification-id="{id}"></div>
        </td>
        <td valign="top" style="width: 65px;">
            <a href="javascript:void(0);" data-id="btnShowFeedbackPopup{id}" data-work-specification-id="{id}" onclick="javascript:return OnShowFeedbackPopupClick(this);">Comment</a>
            <div>
                <input data-id="chkAdminApproval{id}" class="fz fz-admin"  data-work-specification-id="{id}" type="checkbox" title="Admin" onchange='<%=GetPasswordCheckBoxChangeEvent(true,false,false)%>' />&nbsp;
                <input data-id="chkITLeadApproval{id}" class="fz fz-techlead"  data-work-specification-id="{id}" type="checkbox" title="IT Lead" onchange='<%=GetPasswordCheckBoxChangeEvent(false,true,false)%>' />&nbsp;
                <input data-id="chkUserApproval{id}" class="fz fz-user"  data-work-specification-id="{id}" type="checkbox" title="User" onchange='<%=GetPasswordCheckBoxChangeEvent(false,false,true)%>' />
            </div>
            <div data-id="divPassword{id}">
                <input data-id="txtPassword{id}" type="password" placeholder='<%=GetPasswordPlaceholder()%>' class="textbox" style="width:110px;"
                    data-parent-work-specification-id="{parent-id}" data-work-specification-id="{id}"
                    onchange="javascript:OnApprovalPasswordChanged(this);" />
            </div>
        </td>
    </tr>
</script>
<div class="hide">
    <asp:UpdatePanel ID="upHidden" runat="server">
        <ContentTemplate>
            <asp:Button ID="btnUpdateTaskStatus" runat="server" CausesValidation="false" OnClick="btnUpdateTaskStatus_Click" />

            <asp:HiddenField ID="hdnFeedbackPopup" runat="server" />
            <asp:Button ID="btnShowFeedbackPopup" runat="server" CausesValidation="false" OnClick="btnShowFeedbackPopup_Click" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>

<%--Popup Stars--%>
<div class="hide">

    <%--Sub Task Feedback Popup--%>
    <div id="divTwsFeedbackPopup" runat="server" title="Task Work Specification Feedback">
        <asp:UpdatePanel ID="upTwsFeedbackPopup" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <fieldset>
                    <legend><asp:Literal ID="ltrlTwsFeedbackTitle" runat="server" /></legend>
                    <table id="tblAddEditTwsFeedback" runat="server" cellspacing="3" cellpadding="3" width="100%">
                        <tr>
                            <td colspan="2">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="90" align="right" valign="top">Description:
                            </td>
                            <td>
                                <asp:TextBox ID="txtTwsComment" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="4" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvComment" ValidationGroup="comment_tws"
                                    runat="server" ControlToValidate="txtTwsComment" ForeColor="Red" ErrorMessage="Please comment" Display="None" />
                                <asp:ValidationSummary ID="vsComment" runat="server" ValidationGroup="comment_tws" ShowSummary="False" ShowMessageBox="True" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">Files:
                            </td>
                            <td>
                                <input id="hdnTwsAttachments" runat="server" type="hidden" />
                                <input id="hdnTwsFileType" runat="server" type="hidden" />
                               <div id="divTwsDropzone" runat="server" class="dropzone ">
                                    <div class="fallback">
                                        <input name="file" type="file" multiple />
                                        <input type="submit" value="Upload" />
                                    </div>
                                </div>
                                <div id="divTwsDropzonePreview" runat="server" class="dropzone-previews ">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveTwsFeedback" runat="server"  ValidationGroup="comment_tws" OnClick="btnSaveTwsFeedback_Click" CssClass="ui-button" Text="Save"  />
                                    <asp:Button ID="btnSaveTwsAttachment" runat="server"   OnClick="btnSaveTwsAttachment_Click" style="display:none;" Text="Save Attachement"  />
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</div>
<%--Popup Ends--%>

<%--Task Work Specifications Script--%>
<script type="text/javascript">

    var strWorkSpecificationSectionTemplate = $('script[data-id="tmpWorkSpecificationSection"]').html().toString();
    var strWorkSpecificationRowTemplate = $('script[data-id="tmpWorkSpecificationRow"]').html().toString();

    var TaskId = <%=this.TaskId%>;
    var AdminMode = <%=this.IsAdminMode.ToString().ToLower()%>;

    $(document).ready(function() {
    
        //Initialize_WorkSpecifications();

    });

    function Initialize_WorkSpecifications() {
        console.log('Initialize_WorkSpecifications');
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
                $WorkSpecificationRowTemplate.find('div[data-id="divWorkSpecification'+arrData[i].Id+'"]').html(arrData[i].Description);
                
                $WorkSpecificationRowTemplate.find('div[data-id="divEditWorkSpecification'+arrData[i].Id+'"]').hide();
                $WorkSpecificationRowTemplate.find('div[data-id="divEditWorkSpecificationButtons'+arrData[i].Id+'"]').hide();
                $WorkSpecificationRowTemplate.find('a[data-id="btnHideSubSection'+arrData[i].Id+'"]').hide();

                if(arrData[i].TaskWorkSpecificationsCount == 0) {
                    $WorkSpecificationRowTemplate.find('a[data-id="btnViewSubSection'+arrData[i].Id+'"]').hide();
                }
                else {
                    $WorkSpecificationRowTemplate.find('a[data-id="btnAddSubSection'+arrData[i].Id+'"]').hide();
                }

                if(arrData[i].AdminStatus) {
                    $WorkSpecificationRowTemplate.find('input[data-id="chkAdminApproval'+arrData[i].Id+'"]').attr('disabled','disabled');
                    $WorkSpecificationRowTemplate.find('input[data-id="chkAdminApproval'+arrData[i].Id+'"]').attr('checked',true);
                }
                if(arrData[i].TechLeadStatus) {
                    $WorkSpecificationRowTemplate.find('input[data-id="chkITLeadApproval'+arrData[i].Id+'"]').attr('disabled','disabled');
                    $WorkSpecificationRowTemplate.find('input[data-id="chkITLeadApproval'+arrData[i].Id+'"]').attr('checked',true);
                }
                if(arrData[i].OtherUserStatus) {
                    $WorkSpecificationRowTemplate.find('input[data-id="chkUserApproval'+arrData[i].Id+'"]').attr('disabled','disabled');
                    $WorkSpecificationRowTemplate.find('input[data-id="chkUserApproval'+arrData[i].Id+'"]').attr('checked',true);
                }

                $WorkSpecificationRowTemplate.find('div[data-id="divPassword'+arrData[i].Id+'"]').hide();
                if(arrData[i].AdminStatus && arrData[i].TechLeadStatus && arrData[i].OtherUserStatus) {
                    $WorkSpecificationRowTemplate.find('div[data-id="divPassword'+arrData[i].Id+'"]').remove();
                }
                          

                $WorkSpecificationSectionTemplate.find('tbody').append($WorkSpecificationRowTemplate);
            }
        }

        // do not show header for sub sections.
        if(intParentId != 0) {
            $WorkSpecificationSectionTemplate.find('thead').remove();
        }

        // clear div and append new result.
        $('div[data-parent-work-specification-id="'+intParentId+'"]').html('');
        $('div[data-parent-work-specification-id="'+intParentId+'"]').append($WorkSpecificationSectionTemplate);

        // show ck editor in footer row.
        SetCKEditor('txtWorkSpecification' + intParentId + '_Footer');
        
        if( !AdminMode || (result.TotalRecordCount > 0 && result.PendingCount == 0)) {
            $('div[data-parent-work-specification-id="0"]').find('tfoot').html('');
            $('div[data-parent-work-specification-id="0"]').find('div[data-id*="divViewWorkSpecificationButtons"]').remove();
            $('div[data-parent-work-specification-id="0"]').find('div[data-id*="divEditWorkSpecification"]').remove();
            $('div[data-parent-work-specification-id="0"]').find('div[data-id*="divEditWorkSpecificationButtons"]').remove();
            $('div[data-parent-work-specification-id="0"]').find('a[data-id*="btnAddSubSection"]').hide();
        }
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
                data: '{ TaskId: ' +TaskId + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }',
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
        $('div[data-id="divEditWorkSpecificationButtons' + Id + '"]').show();
        $('div[data-id="divViewWorkSpecification' + Id + '"]').hide();
        $('div[data-id="divViewWorkSpecificationButtons' + Id + '"]').hide();

        SetCKEditor('txtWorkSpecification'+Id);

        return false;
    }

    function OnDeleteClick(sender) {

        ShowAjaxLoader();

        $sender = $(sender);
        
        var Id = $sender.attr('data-work-specification-id');
        var intParentId = $sender.attr('data-parent-work-specification-id');

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
        $('div[data-id="divViewWorkSpecificationButtons' + Id + '"]').show();
        $('div[data-id="divEditWorkSpecification' + Id + '"]').hide();
        $('div[data-id="divEditWorkSpecificationButtons' + Id + '"]').hide();

        return false;
    }

    function OnAddClick(sender) { 
        
        ShowAjaxLoader();

        var Id= 0;
        var intParentId = $(sender).attr('data-parent-work-specification-id');
        var strCustomId = $.trim($('label[data-id="lblCustomId'+intParentId+'_Footer"]').text());
        var strDescription = GetCKEditorContent('txtWorkSpecification'+intParentId+'_Footer');

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: '{ intId:' + Id + ', strCustomId: \"' + strCustomId + '\", strDescription: \"' + strDescription + '\", intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d) {
                        // this will update task status from open to specs-in-progress and vice versa based on over all freezing status of work specifications.
                        $('#<%=btnUpdateTaskStatus.ClientID%>').click();
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
        var strDescription = GetCKEditorContent('txtWorkSpecification'+ Id);

        var datatoSend = '{ intId:' + Id + ', strCustomId: \'' + strCustomId + '\', strDescription: \'' + strDescription + '\', intTaskId: ' + TaskId  + ', intParentTaskWorkSpecificationId: ' + intParentId + ' }';

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SaveTaskWorkSpecification',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data:  datatoSend,
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d) {
                        // update div containing work specification content.
                        $('div[data-id="divWorkSpecification'+Id+'"]').html(strDescription);

                        alert('Specification saved successfully.');
                        // this will update task status from open to specs-in-progress and vice versa based on over all freezing status of work specifications.
                        $('#<%=btnUpdateTaskStatus.ClientID%>').click();
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

    function OnShowFeedbackPopupClick(sender) {
        var Id = $(sender).attr('data-work-specification-id');

        $('#<%=hdnFeedbackPopup.ClientID%>').val(Id);
        $('#<%=btnShowFeedbackPopup.ClientID%>').click();
    }

    function OnApprovalCheckBoxChanged(sender) {
        var Id= $(sender).attr('data-work-specification-id');
        
        if($(sender).prop('checked')) {
            $('div[data-id="divPassword' + Id + '"]').show();
        }
        else {
            $('div[data-id="divPassword' + Id + '"]').hide();
        }
    }

    function OnApprovalPasswordChanged(sender) {
    
        ShowAjaxLoader();

        var Id= $(sender).attr('data-work-specification-id');
        var intParentId = $(sender).attr('data-parent-work-specification-id');

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskWorkSpecificationStatusById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data:  '{ intId:' + Id + ', strPassword:"' + $(sender).val() + '"}',
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    if(data.d == -2) {
                        alert('Specification cannot be freezed as password is not valid.');
                    }
                    else if(data.d > 0) {
                        // this will update task status from open to specs-in-progress and vice versa based on over all freezing status of work specifications.
                        $('#<%=btnUpdateTaskStatus.ClientID%>').click();
                        GetWorkSpecifications(intParentId, OnWorkSpecificationsResponseReceived);
                        alert('Specification freezed successfully.');
                    }
                    else {
                        alert('Specification cannot be freezed, Please try again later.');
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

<%--Task Work Specifications Feedback Script--%>
<script type="text/javascript">
    Dropzone.autoDiscover = false;

    $(function () {
        ucTaskWorkSpecifications_Initialize();
    });

    var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    prmTaskGenerator.add_endRequest(function () {
        ucTaskWorkSpecifications_Initialize();
    });

    function ucTaskWorkSpecifications_Initialize() {
        ucTaskWorkSpecifications_ApplyDropZone();
    }

    var objTwsNoteDropzone;

    function ucTaskWorkSpecifications_ApplyDropZone() {
        //Apply dropzone for comment section.
        if (objTwsNoteDropzone) {
            objTwsNoteDropzone.destroy();
            objTwsNoteDropzone = null;
        }
        objTwsNoteDropzone = GetWorkFileDropzone("#<%=divTwsDropzone.ClientID%>", '#<%=divTwsDropzonePreview.ClientID%>', '#<%= hdnTwsAttachments.ClientID %>', '#<%=btnSaveTwsAttachment.ClientID%>');
    }

</script>
