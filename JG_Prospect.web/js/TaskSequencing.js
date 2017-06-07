
function initializeAngular() {
    var elem = angular.element(document.getElementById("divSeqForAddNewTask"));
    var elem1 = angular.element(document.getElementById("taskSequence"));

    elem.replaceWith($compile(elem)($scope));
    elem1.replaceWith($compile(elem1)($scope));

    $scope.$apply();
}

function SetLatestSequenceForAddNewSubTask() {

    var sequencetextbox = $('#divNewAddSeq');
    getLastAvailableSequence(sequencetextbox);
    angular.element(document.getElementById('divSeqForAddNewTask')).scope().getTasks();

}

function ShowTaskSequence(editlink) {

    var edithyperlink = $(editlink);

    var TaskID = edithyperlink.attr('data-taskid');

    //search initially all tasks with sequencing.
    angular.element(document.getElementById('taskSequence')).scope().HighLightTaskId = TaskID;
    angular.element(document.getElementById('taskSequence')).scope().getTasks();


    var dlg = $('#taskSequence').dialog({
        width: 800,
        height: 300,
        show: 'slide',
        hide: 'slide',
        autoOpen: true,
        modal: false
    });
}

function showEditTaskSequence(element) {

    // var edithyperlink = $($('a [data-data-taskid="'+ tasksid +'"]'));

    var TaskID = $(element).attr('data-taskid');
    //var TaskID = taskid;

    var sequenceDiv = $('#divSeq' + TaskID);

    if (sequenceDiv) {

        DesignationID = sequenceDiv .children('select').val();

        if (DesignationID) {
            getLastAvailableSequence(TaskID, DesignationID);
        }

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
        IsTechTask: angular.element(document.getElementById('taskSequence')).scope().IsTechTask
    };
    console.log(postData);
    CallJGWebServiceCommon('GetLatestTaskSequence', postData, function (data) { OnGetLatestSeqSuccess(data, TaskID) }, function (data) { OnGetLatestSeqError(data, TaskID) });

    function OnGetLatestSeqSuccess(data, TaskID) {
        HideAjaxLoader();
        if (data.d) {
            var sequence = JSON.parse(data.d);

            var valExisting = parseInt($('#txtSeq'+TaskID).val());
            

            if (isNaN(valExisting) || valExisting == 0 || valExisting + 1 >= parseInt(sequence.Table[0].Sequence)) {
                $('#txtSeq' + TaskID).val(parseInt(sequence.Table[0].Sequence));
                }

            DisplySequenceBox(TaskID, sequence.Table[0].Sequence);
        }

    }
    function OnGetLatestSeqError(data, TaskID) {
        HideAjaxLoader();
        DisplySequenceBox(TaskID,1);
    }
}

var isWarnedForSequenceChange = false;

function DisplySequenceBox(TaskID, maxValueforSeq) {

    $('#divSeq' + TaskID).removeClass('hide');
    //var divSequence = $(sequencebox).handleCounter({
    //    minimum: 1,
    //    maximize: parseInt(maxValueforSeq),
    //    onMaximize: function () { console.log(this);}
    //});
    var instance = $('#txtSeq' + TaskID);
        
    if (instance.spinner("instance")) {
        instance.spinner("destroy");
    }
    instance.spinner(
        {
            min: 1,
            max: parseInt(maxValueforSeq)
        }
     );
}

function UpdateTaskSequence(savebutton) {
    var button = $(savebutton);
    var TaskID = button.attr('data-taskid');
    var sequence = parseInt($('#txtSeq' + TaskID).val());
    var DesignationID = $('#divSeq' + TaskID).children('select').val();

    if (!isNaN(sequence) && sequence > 0) {
        // if original sequence is changed than it will warn user.
        var originalSequence = parseInt($('#txtSeq' + TaskID).attr('data-original-val'));

        // if user has changes original sequence than he/she will be prompted to confirm save.
        if (!isNaN(originalSequence) && sequence != originalSequence) {

            var userDecision = confirm('Are you sure you want to change sequence of task which is assigned to some other task already?');
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
        IsTechTask: angular.element(document.getElementById('taskSequence')).scope().IsTechTask
    };

    ShowAjaxLoader();

    CallJGWebServiceCommon('UpdateTaskSequence', postData, function (data) { OnSaveSeqSuccess(data, TaskID, Sequence) }, function (data) { OnSaveSeqError(data, TaskID) });

    function OnSaveSeqSuccess(data, TaskID, Sequence) {
        HideAjaxLoader();
        alert('Sequence updated successfully');
        $('#TaskSeque' + TaskID).html(Sequence);
        $('#divSeq' + TaskID).addClass('hide');

        angular.element(document.getElementById('taskSequence')).scope().getTasks(0, '', false, TaskID);

        return false;
    }

    function OnSaveSeqError(data, TaskID) {
        HideAjaxLoader();
        alert('Could not update Sequence this time, Please try again later.');
        return false;
    }

}

function BindSeqDesignationChange(ControlID) {
    $(ControlID + ' input').bind('change', function () {
        //if user selected designation than add it for search.        
        //search initially all tasks with sequencing.
        // remove it from search.
        angular.element(document.getElementById('taskSequence')).scope().SetDesignForSearch($(this).val(), !this.checked);

    });
}