
function initializeAngular() {
    //var elem = angular.element(document.getElementById("taskSequence"));
    //$compile(elem.children())($scope);
    //$scope.$apply();
    //console.log(angular.element(document.getElementById('taskSequence')).scope());
    //angular.element(document.getElementById('taskSequence')).scope().updateonAjaxRequest();
}

function SetLatestSequenceForAddNewSubTask() {

    var sequencetextbox = $('#divNewAddSeq');
    getLastAvailableSequence(sequencetextbox);


}

function ShowTaskSequence(editlink, designationDropdownId) {
       

    var edithyperlink = $(editlink);

    var TaskID = edithyperlink.attr('data-taskid');
    var TechTask = edithyperlink.attr('data-task-TechTask');
    var DesignationIds = edithyperlink.attr('data-task-designationids');
    //console.log("Task designation is: " + DesignationIds);
    if (DesignationIds) {

        var DesignationToSelect =  DesignationIds.split(",")[0];
        
       // console.log("Splited designation ids are:", $.trim(DesignationToSelect));

        // sequenceScope.UserSelectedDesigIds = DesignationIds.split(",");
            $(ddlDesigSeqClientID).val($.trim(DesignationToSelect));
        //    $.each(DesignationIds.split(","), function (index, value) {

        //        var checkbox = $(designationDropdownId).children("input[value='" + $.trim(value) + "']");
        //        if (checkbox) {
        //            $(checkbox).attr('checked', true);
        //        }
        //    });
    }


   // console.log("Master Dropdown selected designation is: " + $(ddlDesigSeqClientID).val());

    //Set if tech task than load tech task related sequencing.
    sequenceScope.IsTechTask = TechTask;

    //search initially all tasks with sequencing.
    sequenceScope.HighLightTaskId = TaskID;
    sequenceScope.BlinkTaskId = TaskID;


    // set designation id to be search by default
    sequenceScope.SetDesignForSearch($(ddlDesigSeqClientID).val());

    // Bind Assign user master dropdown for selected designation.
    sequenceScope.getAssignUsers();

    $('#taskSequence').removeClass("hide");

    var dlg = $('#taskSequence').dialog({
        width: 1100,
        height: 700,
        show: 'slide',
        hide: 'slide',
        autoOpen: true,
        modal: false,
        beforeClose: function (event, ui) {
            $('#taskSequence').addClass("hide");
        }
    });

    setParentTaskDesignationToJqueryArray(ddlDesigSeqClientID);

     //console.log(TechTask);

    if (TechTask === 'True') {
        //console.log("calling search tech task after popup initialized....");
        sequenceScope.IsTechTask = true;
        sequenceScope.getTechTasks();
        applyTaskSequenceTabs(1);
        //sequenceUIGridScope.getUITechTasks();
    }
    else {
        //console.log("calling search staff task after popup initialized....");
        sequenceScope.IsTechTask = false;
        sequenceScope.getTasks();
        applyTaskSequenceTabs(0);
    }



}

function showEditTaskSequence(element) {

    
    //console.log("show edit task sequence function called");
    // var edithyperlink = $($('a [data-data-taskid="'+ tasksid +'"]'));
    var TaskID = $(element).attr('data-taskid');
    
    var sequenceDiv = $('#divSeqDesg' + TaskID);

    //console.log("Sequence div is:");
    //console.log(sequenceDiv);
    //console.log("TASKID is:"+TaskID);
    
    //var TaskID = taskid;
    var desiDropDown = sequenceDiv.children('select');
    //console.log(desiDropDown);
    $('#divSeq' + TaskID).removeClass('hide');
    $('#divSeqDesg' + TaskID).removeClass('hide');
    

    if (sequenceDiv) {

        
        DesignationID = $(desiDropDown).val();// get user selected designation designation value.

        //console.log("Designation ID is: ");
        //console.log(DesignationID);
        //console.log(desiDropDown);

        // Designation id is null or it is not selected properly.
        if (!DesignationID || DesignationID === "?") {

            $(desiDropDown).children("option[value='?']").remove();
            

            DesignationID = $(element).attr('data-seqdesgid');// use previously assigned seq to task.
            
            // if task has no sequence assigned than designation id will be null.in that case select designation from parent designation dropdown.
            if (!DesignationID) {
                
                DesignationID = $(ddlDesigSeqClientID).val();

                //console.log("Designation ID for non assigned sequence: " + DesignationID);

                $(desiDropDown).val(DesignationID); // set task dropdown value to parent designation dropdown.
                getLastAvailableSequence(TaskID, DesignationID);
            }
            else {
                $(desiDropDown).val(DesignationID);
            }

        }
        else {
            getLastAvailableSequence(TaskID, DesignationID);
        }

        //console.log("New designation Id is:" + DesignationID);

     
       
     

        // if it is new sequence to assign, load latest sequence based on designation.


        ////check if already sequence assigned or not.
        //var currentVal = parseInt(sequencetextbox.children('input[type="text"]').val());

        //if (!isNaN(currentVal) || currentVal > 0) {// if already sequence assigned than set its value in textbox.
        //    sequencetextbox.children('input[type="text"]').val(currentVal);
        //    DisplySequenceBox(sequencetextbox, currentVal);
        //}
        //else {


        //}

    }

}

function getLastAvailableSequence(TaskID, DesignationID) {
    ShowAjaxLoader();

    var postData = {
        DesignationId: DesignationID,
        IsTechTask: sequenceScope.IsTechTask
    };

    CallJGWebServiceCommon('GetLatestTaskSequence', postData, function (data) { OnGetLatestSeqSuccess(data, TaskID) }, function (data) { OnGetLatestSeqError(data, TaskID) });

    function OnGetLatestSeqSuccess(data, TaskID) {

        HideAjaxLoader();

        if (data.d) {

            //console.log("Retrieved new designation seq.");
            //console.log(data.d);

            var sequence = JSON.parse(data.d);

            var valExisting = parseInt($('#txtSeq' + TaskID).val());


            if (isNaN(valExisting) || valExisting == 0 || valExisting + 1 >= parseInt(sequence.Table[0].Sequence)) {
                $('#txtSeq' + TaskID).val(parseInt(sequence.Table[0].Sequence));
            }

            DisplySequenceBox(TaskID, sequence.Table[0].Sequence);


        }

    }
    function OnGetLatestSeqError(data, TaskID) {
        HideAjaxLoader();
        DisplySequenceBox(TaskID, 1);
    }
}

var isWarnedForSequenceChange = false;

function DisplySequenceBox(TaskID, maxValueforSeq) {

    
    var instance = $('#txtSeq' + TaskID);

    var DesignationId = $('#divSeqDesg' + TaskID).find('select').val();
    var OriginalDesignationId = instance.attr("data-original-desgid");

    //console.log("Original designation was: " + OriginalDesignationId);
    //console.log("Changed designation was: " + DesignationId);

    instance.addClass("hide");
    instance.prop('disabled', true);

    // If task has never been assigned with any sequence, show default available seq.
    if ((!instance.attr("data-original-val")) || DesignationId != OriginalDesignationId) {

        var divMaster = $('#divMasterTask'+TaskID);
        var linkLabel = divMaster.children('div.seq-number').find('a.autoclickSeqEdit').find('label');

        //console.log("Link label is: ");
        //console.log(linkLabel);

        var TaskPrefix;

        if (linkLabel.html()) {
            TaskPrefix = linkLabel.html().split(":").pop();
        }

        linkLabel.html(sequenceScope.getSequenceDisplayText(maxValueforSeq, parseInt(DesignationId), TaskPrefix));

    }
    else if (DesignationId === OriginalDesignationId && instance.attr("data-original-val")) {// if designation selected to same it was, change it to original sequence.


        var divMaster = $('#divMasterTask' + TaskID);
        var linkLabel = divMaster.children('div.seq-number').find('a.autoclickSeqEdit').find('label');

        var TaskPrefix;

        if (linkLabel.html()) {
            TaskPrefix = linkLabel.html().split(":").pop();
        }

        linkLabel.html(sequenceScope.getSequenceDisplayText(instance.attr("data-original-val"), parseInt(DesignationId), TaskPrefix));
    }
    //if (instance.spinner("instance")) {
    //    instance.spinner("destroy");
    //}
    //instance.spinner(
    //    {
    //        min: 1,
    //        max: parseInt(maxValueforSeq)
    //    }
    // );

}

function UpdateTaskSequence(savebutton) {
    var button = $(savebutton);
    var TaskID = button.attr('data-taskid');
    var sequence = parseInt($('#txtSeq' + TaskID).val());
    var DesignationID = $('#divSeqDesg' + TaskID).children('select').val();
    var OriginalDesignationID = button.attr('data-orginal-seqdesg');

    if (DesignationID === OriginalDesignationID) {

        OriginalDesignationID = null;
    }

    if (!isNaN(sequence) && sequence > 0) {
        // if original sequence is changed than it will warn user.
        var originalSequence = parseInt($('#txtSeq' + TaskID).attr('data-original-val'));

        // if user has changes original sequence than he/she will be prompted to confirm save.
        if (!isNaN(originalSequence) && sequence != originalSequence) {

            var userDecision = confirm('Are you sure you want to change sequence of task, which might be assigned to some other task already?');
            if (!userDecision) {// user selected not to change sequence assigned to some other task.
                return false;
            }
        }

        SaveTaskSequence(TaskID, sequence, DesignationID);

    }
    else {
        alert('Please enter valid sequence');
    }


}

function SaveTaskSequence(TaskID, Sequence, DesigataionId) {

    var postData = {
        Sequence: Sequence,
        TaskID: TaskID,
        DesignationID: DesigataionId,
        IsTechTask: sequenceScope.IsTechTask
    };

    ShowAjaxLoader();

    CallJGWebServiceCommon('UpdateTaskSequence', postData, function (data) { OnSaveSeqSuccess(data, TaskID, Sequence) }, function (data) { OnSaveSeqError(data, TaskID) });

    function OnSaveSeqSuccess(data, TaskID, Sequence) {
        HideAjaxLoader();
        alert('Sequence updated successfully');
        $('#TaskSeque' + TaskID).html($("#SeqLabel"+TaskID).html());
        $('#divSeq' + TaskID).addClass('hide');

        //console.log("After saving task designation id is set to master dropdown: " + DesigataionId);

        $(ddlDesigSeqClientID).val(DesigataionId).trigger('change');

        sequenceScope.refreshTasks();

        return false;
    }

    function OnSaveSeqError(data, TaskID) {
        HideAjaxLoader();
        alert('Could not update Sequence this time, Please try again later.');
        return false;
    }

}

function BindSeqDesignationChange(ControlID) {
    //$(ControlID + ' input').bind('change', function () {
    //if user selected designation than add it for search.        
    //search initially all tasks with sequencing.
    // remove it from search.
    $(ControlID).bind('change', function () {        
        sequenceScope.SetDesignForSearch($(this).val(), false);
        sequenceScope.getAssignUsers();

    });
}

function swapSequence(hyperlink, isup) {

    var FirstTaskID = $(hyperlink).attr("data-taskid");
    var FirstSeq = $(hyperlink).attr("data-taskseq");
    var FirstTaskDesg = $(hyperlink).attr("data-taskdesg");
    var SecondTaskID, SecondSeq, SecondTaskDesg, otherlink;
    var row = $(hyperlink).closest('tr');

    if (row.hasClass("yellowthickborder")) {
        sequenceScope.HighLightTaskId = 0;
    }

    if (isup) {
        otherlink = row.prev().find('[data-taskdesg]').first();
    }
    else {
        otherlink = row.next().find('[data-taskdesg]').first();
    }

    SecondTaskID = otherlink.attr("data-taskid");
    SecondSeq = otherlink.attr("data-taskseq");
    SecondTaskDesg = otherlink.attr("data-taskdesg");

    if ((FirstTaskDesg === SecondTaskDesg) && FirstTaskID && SecondTaskID && FirstTaskDesg && SecondTaskDesg) {

        var postData = {
            FirstSequenceId: FirstSeq,
            SecondSequenceId: SecondSeq,
            FirstTaskId: FirstTaskID,
            SecondTaskId: SecondTaskID
        };

        CallJGWebService('TaskSwapSequence', postData, OnSwapTaskSeqSuccess, OnSwapTaskSeqError);

        function OnSwapTaskSeqSuccess(data) {

            if (data.d == true) {
                //alert('Sequences swaped successfully, Reloading Tasks....');
                sequenceScope.refreshTasks();
            }
            else {
                alert('Error in swaping sequences, Please try again.');
            }
        }

        function OnSwapTaskSeqError(err) {
            alert('Error in swaping sequences, Please try again.');
        }

    }
    else {
        alert("In order to swap sequence both Task should have same designation, Please filter designation from above designation dropdown and then try to swap sequence.");
    }

}

function setActiveTab(isTechTask) {

    var activeTab = 0;

    var clickEditLinkDiv = "#tblStaffSeq";

    //console.log("Tech Task in active tab is:");
    //console.log(isTechTask);
    //console.log(sequenceScope.IsTechTask);

    if (isTechTask) {
        //  activeTab = 1;
        clickEditLinkDiv = "#tblTechSeq  tbody > tr.yellowthickborder";
    }

    //$("#taskSequenceTabs").tabs("option", "active", activeTab);

    var linkToClick = $(clickEditLinkDiv).find(".autoclickSeqEdit");

    //console.log(linkToClick);

    if (linkToClick) {
        showEditTaskSequence(linkToClick);
    }

}

function applyTaskSequenceTabs(activeTab) {
    $('#taskSequenceTabs').tabs({
        active: activeTab
    });

    if (activeTab == 0) {
        sequenceScope.IsTechTask = false;
    }
    else {
        sequenceScope.IsTechTask = true;
    }
     //console.log('Active tab is ' + $("#taskSequenceTabs").tabs("option", "active"));

    $("#taskSequenceTabs").bind("tabsactivate", function (event, ui) {
        
        if (ui.newPanel.attr('id') == "TechTask") {

            sequenceScope.IsTechTask = true;
            sequenceScope.getTechTasks();
        }
        else {
            sequenceScope.IsTechTask = false;
            sequenceScope.getTasks();
        }
    });

}


function setParentTaskDesignationToJqueryArray(DesignationDropdown) {

    var allDesignations = $(DesignationDropdown).find("option");
    sequenceScope.ParentTaskDesignations = [];

    $.each(allDesignations, function (index, item) {
        sequenceScope.ParentTaskDesignations.push({ "Name": $(item).text(), "Id": $(item).val() });
        //console.log(sequenceScope.ParentTaskDesignations);
    });

}

function DeleteTaskSequence(deleteLink) {

    if (confirm('are you sure you want to delete this task from sequence?')) {
        ShowAjaxLoader();

        var TaskID = parseInt($(deleteLink).attr("data-taskid"));

        var postData = {
            TaskId: TaskID
        };

        CallJGWebService('DeleteTaskSequence', postData, OnDeleteTaskSeqSuccess, OnDeleteTaskSeqError);

        function OnDeleteTaskSeqSuccess(data) {
            HideAjaxLoader();
            if (data.d == true) {
                //alert('Sequences swaped successfully, Reloading Tasks....');
                sequenceScope.refreshTasks();
            }
            else {
                alert('Error in deleting sequence, Please try again.');
            }
        }

        function OnDeleteTaskSeqError(err) {
            HideAjaxLoader();
            alert('Error in deleting sequence, Please try again.');
        }


    }
}

function SetChosenAssignedUser() {    
    $('*[data-chosen="1"]').each(function (index) {
        
        //var dropdown = $(this);

        //var assignedUsers = dropdown.attr("data-AssignedUsers");

        //console.log(assignedUsers);

        //if (assignedUsers) {
        //    dropdown.val([e]);

        //    // Set the value
        //    $.each(assignedUsers.split(","), function (i, e) {
        //        console.log("Assigned Users ..."+e);
        //        //console.log(dropdown.children().find("OPTION[value=\"" + e + "\"]"));
        //        //dropdown.children().find("OPTION[vsalue=\"" + e + "\"]").prop("selected", true);
        //    });

        //   // console.log(dropdown.val());
        //}

        // Then refresh

        //  $(this).multiselect("refresh");

        $(this).chosen();
    });
}