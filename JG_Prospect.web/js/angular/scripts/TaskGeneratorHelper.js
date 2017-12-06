function LoadDesignationUsers(DesigIds) {
    if (DesigIds == 0 || DesigIds == undefined) {
        DesigIds = "";
    }

    //Set Params
    sequenceScopeTG.UserSelectedDesigIds = DesigIds;

    //Call Data Function
    sequenceScopeTG.getUserByDesignation();
}

function LoadSubTasks() {

    //Set Params
    sequenceScopeTG.UserSelectedDesigIds = "";

    //Get Page Size
    var pageSize = $('#drpPageSize').val();
    if (pageSize == undefined)
        pageSize = 5;
    sequenceScopeTG.pageSize = pageSize;

    sequenceScopeTG.getSubTasks();
    sequenceScopeTG.getAssignUser();
}

function SetChosenAssignedUsers() {
    $('*[data-chosen="1"]').each(function (index) {

        var dropdown = $(this);

        if (dropdown.attr("data-assignedusers")) {
            var assignedUsers = JSON.parse("[" + dropdown.attr("data-assignedusers") + "]");
            $.each(assignedUsers, function (Index, Item) {
                dropdown.find("option[value='" + Item + "']").prop("selected", true);
            });
        }

        $(this).chosen();
        $(this).trigger('chosen:updated');

        setSelectedUsersLink();
    });
}

function EditAssignedSubTaskUsers(sender) {

    var $sender = $(sender);
    var intTaskID = parseInt($sender.attr('data-taskid'));
    var intTaskStatus = parseInt($sender.attr('data-taskstatus'));
    var arrAssignedUsers = [];
    var arrDesignationUsers = [];
    var options = $sender.find('option');

    $.each(options, function (index, item) {

        var intUserId = parseInt($(item).attr('value'));

        if (intUserId > 0) {
            arrDesignationUsers.push(intUserId);
            //if ($.inArray(intUserId.toString(), $(sender).val()) != -1) {                
            //    arrAssignedUsers.push(intUserId);
            //}
            if ($(sender).val() == intUserId.toString()) {
                arrAssignedUsers.push(intUserId);
            }
        }
    });

    SaveAssignedTaskUsers();


    function SaveAssignedTaskUsers() {
        ShowAjaxLoader();

        var postData = {
            intTaskId: intTaskID,
            intTaskStatus: intTaskStatus,
            arrAssignedUsers: arrAssignedUsers,
            arrDesignationUsers: arrDesignationUsers
        };

        CallJGWebService('SaveAssignedTaskUsers', postData, OnSaveAssignedTaskUsersSuccess, OnSaveAssignedTaskUsersError);

        function OnSaveAssignedTaskUsersSuccess(response) {
            HideAjaxLoader();
            if (response) {
                HideAjaxLoader();
                LoadSubTasks();
            }
            else {
                OnSaveAssignedTaskUsersError();
            }
        }

        function OnSaveAssignedTaskUsersError(err) {
            HideAjaxLoader();
            //alert(JSON.stringify(err));
            alert('Task assignment cannot be updated. Please try again.');
        }
    }
}

function OnSaveSubTask(obj) {

    ShowAjaxLoader();
    var taskid = $(obj).attr('data-taskid'); 
    var desc = GetCKEditorContent('subtaskDesc' + taskid);
    var installID = $('#listId' + taskid).attr('data-listid');
    var TaskLvl = $('#nestLevel' + taskid).val();
    var Class = $('#listId' + taskid).attr('data-label');

    if (TaskLvl == '') TaskLvl = 1;
    
    var postData = {
        ParentTaskId: taskid,
        InstallId: installID,
        Description: desc,
        IndentLevel: TaskLvl,
        Class: Class
    };

    CallJGWebService('SaveTaskMultiLevelChild', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

    function OnAddNewSubTaskSuccess(data) {
        if (data.d == true) {
            PreventScroll = 1;
            alert('Task saved successfully.');
            LoadSubTasks();
        }
        else {
            alert('Task cannot be saved. Please try again.');
        }
    }

    function OnAddNewSubTaskError(err) {
        alert('Task cannot be saved. Please try again.');
    }
    return false;

}