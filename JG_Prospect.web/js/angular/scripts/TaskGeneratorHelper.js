function LoadDesignationUsers(DesigIds) {
    if (DesigIds == 0 || DesigIds == undefined) {
        DesigIds = "";
    }

    //Set Params
    sequenceScope.UserSelectedDesigIds = DesigIds;

    //Call Data Function
    sequenceScope.getUserByDesignation();
}

function LoadSubTasks() {

    //Set Params
    sequenceScope.UserSelectedDesigIds = "";

    //Get Page Size
    var pageSize = $('#ContentPlaceHolder1_objucSubTasks_Admin_drpPageSize').val();
    sequenceScope.pageSize = pageSize;

    sequenceScope.getSubTasks();
    sequenceScope.getAssignUser();
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