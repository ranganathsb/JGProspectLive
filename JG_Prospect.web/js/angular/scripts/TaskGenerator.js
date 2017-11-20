app.controller('TaskGeneratorController', function ($scope, $compile, $http, $timeout, $filter) {
    _applyFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('trustAsHtml', function ($sce) { return $sce.trustAsHtml; });

function callWebServiceMethod($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function _applyFunctions($scope, $compile, $http, $timeout, $filter) {

    $scope.UsersByDesignation = [];
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationAssignUsers = [];
    $scope.SelectedUserId = 0;
    $scope.SubTasks = [];
    $scope.TaskFiles = [];
    $scope.pageSize = 5;
    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.TotalRecords = 0;
    //var isadded = false;

    $scope.loader = {
        loading: false,
    };

    $scope.getUserByDesignation = function () {

        callWebServiceMethod($http, "GetAssignUsers", { TaskDesignations: sequenceScope.UserSelectedDesigIds != "" ? sequenceScope.UserSelectedDesigIds.join() : sequenceScope.UserSelectedDesigIds }).then(function (data) {
            var AssignedUsers = JSON.parse(data.data.d);
            $scope.UsersByDesignation = AssignedUsers;
            $scope.SelectedUserId = $scope.UsersByDesignation[0].Id;         
        });        
    }

    $scope.getSubTasks = function (page) {
        var TaskId = getUrlVars()["TaskId"];
        $scope.page = page || 0;

        callWebServiceMethod($http, "GetSubTasks", { TaskId: TaskId, strSortExpression: "CreatedOn DESC", vsearch: "", intPageIndex: page != undefined ? page : 0, intPageSize: sequenceScope.pageSize, intHighlightTaskId: 0 }).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TaskData;

            //$scope.page = 0;
            $scope.TotalRecords = result.RecordCount.TotalRecords;
            $scope.pagesCount = 3;
            $scope.TaskFiles = $scope.correctDataforAngular(result.TaskFiles);
            $scope.SubTasks = $scope.correctDataforAngular(result.Tasks);
        });
    }


    //Helper Functions
    $scope.correctDataforAngular = function (ary) {
        var arr = null;
        if (ary) {
            if (!(ary instanceof Array)) {
                arr = [ary];
            }
            else {
                arr = ary;
            }
        }
        return arr;
    }

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.getAssignUser = function () {
        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIds }).then(function (data) {
            var AssignedUsers = JSON.parse(data.data.d);
            $scope.DesignationAssignUsers = AssignedUsers;
        });
    };

    $scope.onAssignEnd = function (object) {
        $('.chosen-input').trigger('chosen:updated');

        //Set Assigned Users
        SetChosenAssignedUsers();        
    }

    $scope.onAttachmentEnd = function (object) {
        LoadImageGallery('#lightSlider_' + object);
    }

    $scope.onEnd = function () {
        //Initialize Chosens
        $('.chosen-input').chosen();

        //Set Approval Dialog
        $('.approvalBoxes').each(function () {
            var approvaldialog = $($(this).next('.approvepopup'));
            approvaldialog.dialog({
                width: 400,
                show: 'slide',
                hide: 'slide',
                autoOpen: false
            });

            $(this).click(function () {
                approvaldialog.dialog('open');
            });
        });        

        ApplySubtaskLinkContextMenu();

        $timeout(function () {
            $('a[data-id="hypViewInitialComments"]').click();

            //Add Subtask Button
            $(".showsubtaskDIV").each(function (index) {
                // This section is available to admin only.

                $(this).bind("click", function () {
                    var commandName = $(this).attr("data-val-commandName");
                    var CommandArgument = $(this).attr("data-val-CommandArgument");
                    var TaskLevel = $(this).attr("data-val-taskLVL");
                    var strInstallId = $(this).attr('data-installid');
                    var parentTaskId = $(this).attr('data-parent-taskid');

                    $("#ContentPlaceHolder1_objucSubTasks_Admin_divAddSubTask").hide();
                    $("#ContentPlaceHolder1_objucSubTasks_Admin_pnlCalendar").hide();

                    var objAddSubTask = null;
                    if (TaskLevel == "1") {
                        objAddSubTask = $("#ContentPlaceHolder1_objucSubTasks_Admin_divAddSubTask");
                        shownewsubtask();
                        maintask = false;
                    }
                    else if (TaskLevel == "2") {
                        objAddSubTask = $("#ContentPlaceHolder1_objucSubTasks_Admin_pnlCalendar");

                        var $tr = $('<tr><td colspan="4"></td></tr>');
                        $tr.find('td').append(objAddSubTask);

                        var $appendAfter = $('tr[data-parent-taskid="' + parentTaskId + '"]:last');
                        if ($appendAfter.length == 0) {
                            $appendAfter = $('tr[data-taskid="' + parentTaskId + '"]:last');
                        }
                        $appendAfter.after($tr);
                    }

                    if (objAddSubTask != null) {
                        objAddSubTask.show();
                        ScrollTo(objAddSubTask);
                        SetTaskDetailsForNew(CommandArgument, commandName, TaskLevel, strInstallId);
                    }

                    return false;
                });
            });

            

        }, 1);           

        //For Title
        $(".TitleEdit").each(function (index) {
            // This section is available to admin only.

            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                    $(this).html(fName);
                    $('#txtedittitle').focus();

                    isadded = true;
                }
            }).bind('focusout', function () {
                var tid = $(this).attr("data-taskid");
                var tdetail = $('#txtedittitle').val();
                $(this).html(tdetail);
                EditTask(tid, tdetail)
                isadded = false;
            });
        });

        //For Url
        $(".UrlEdit").each(function (index) {
            // This section is available to admin only.

            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                    $(this).html(fName);
                    $('#txtedittitle').focus();

                    isadded = true;
                }
                return false;
            }).bind('focusout', function () {
                var tid = $(this).attr("data-taskid");
                var tdetail = $('#txtedittitle').val();

                $(this).html(tdetail);
                EditUrl(tid, tdetail);
                isadded = false;
                return false;
            });
        });

        //For Description
        $(".DescEdit").each(function (index) {
            // This section is available to admin only.

            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<textarea id=\"txtedittitle\" style=\"width:100%;\" class=\"editedTitle\" rows=\"10\" >" + titledetail + "</textarea>");
                    $(this).html(fName);
                    $('#ContentPlaceHolder1_objucSubTasks_Admin_hdDropZoneTaskId').val(tid);
                    SetCKEditorForSubTask('txtedittitle');
                    $('#txtedittitle').focus();
                    control = $(this);

                    isadded = true;

                    var otherInput = $(this).closest('.divtdetails').find('.btnsubtask');
                    $(otherInput).css({ 'display': "block" });
                    $(otherInput).bind("click", function () {
                        updateDesc(GetCKEditorContent('txtedittitle'));
                        $(this).css({ 'display': "none" });
                    });
                }
                return false;
            });
        });

        GridDropZone();
    };

    //Helper Functions
    $scope.trustedHtml = function (plainText) {
        return $sce.trustAsHtml(plainText);
    }


    //Create a Scope
    sequenceScope = $scope;
}

function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}