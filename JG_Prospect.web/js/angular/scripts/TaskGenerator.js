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
    $scope.MultiLevelChildren = [];
    $scope.CurrentLevel = 1;
    //var isadded = false;

    $scope.loader = {
        loading: false,
    };

    $scope.getUserByDesignation = function () {

        callWebServiceMethod($http, "GetAssignUsers", { TaskDesignations: sequenceScopeTG.UserSelectedDesigIds != "" ? sequenceScopeTG.UserSelectedDesigIds.join() : sequenceScopeTG.UserSelectedDesigIds }).then(function (data) {
            var AssignedUsers = JSON.parse(data.data.d);
            $scope.UsersByDesignation = AssignedUsers;
            $scope.SelectedUserId = $scope.UsersByDesignation[0].Id;         
        });        
    }

    $scope.getSubTasks = function (page) {
        var TaskId = getUrlVars()["TaskId"];
        TaskId = TaskId.replace('#/', '');
        $scope.page = page || 0;

        callWebServiceMethod($http, "GetSubTasks", { TaskId: TaskId, strSortExpression: "CreatedOn DESC", vsearch: "", intPageIndex: page != undefined ? page : 0, intPageSize: sequenceScopeTG.pageSize, intHighlightTaskId: 0 }).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TaskData;

            //$scope.page = 0;
            $scope.TotalRecords = result.RecordCount.TotalRecords;
            $scope.pagesCount = Math.round(result.RecordCount.TotalRecords / sequenceScopeTG.pageSize);
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

    $scope.onEnd = function (obj) {        
        var ParentIds = [];
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

            $('.MainTask').each(function () {
                //Load Multilevel Children
                var id = $(this).attr('data-taskid');
                ParentIds.push(id);
                //ParentIds = ParentIds.substring(0, ParentIds.length - 1);
            });


        }, 1);           

        $timeout(function () {            

            callWebServiceMethod($http, "GetMultilevelChildren", { ParentTaskId: ParentIds.join() }).then(function (data) {
                var result = JSON.parse(data.data.d);
                $scope.MultiLevelChildren = $scope.correctDataforAngular(result.ChildrenData.Children);

                $timeout(function () {
                    //Add Blink Class
                    var ChildId = getUrlVars()["mcid"];
                    
                    if (ChildId != undefined) {
                        $('#ChildEdit' + ChildId).addClass('yellowthickborder');
                    } else {
                        var hstid = getUrlVars()["hstid"];
                        $('#datarow' + hstid).addClass('yellowthickborder');
                    }

                    //Apply Context Menu
                    $(".context-menu-child").bind("contextmenu", function () {
                        var url = window.location.href;
                        url = url.split('&')[0];
                        var urltoCopy = url + '&hstid=' + $(this).attr('data-highlighter') + '&mcid=' + $(this).attr('data-childid');
                        //var urltoCopy = updateQueryStringParameterTP(window.location.href, "hstid", $(this).attr('data-highlighter'));
                        copyToClipboard(urltoCopy);
                        return false;
                    });

                    ScrollTo($('.yellowthickborder'));

                    $(".yellowthickborder").bind("click", function () {
                        $(this).removeClass("yellowthickborder");
                    });

                    $(".ChildEdit").each(function (index) {
                        // This section is available to admin only.

                        $(this).bind("click", function () {
                            if (!isadded) {
                                var tid = $(this).attr("data-taskid");
                                var titledetail = $(this).html();
                                var fName = $("<textarea id=\"txteditChild\" style=\"width:80%;\" class=\"editedTitle\" rows=\"10\" >" + titledetail + "</textarea><input id=\"btnSave\" type=\"button\" value=\"Save\" />");
                                $(this).html(fName);
                                $('#ContentPlaceHolder1_objucSubTasks_Admin_hdDropZoneTaskId').val(tid);
                                SetCKEditorForSubTask('txteditChild');
                                $('#txteditChild').focus();
                                control = $(this);

                                isadded = true;

                                $('#btnSave').bind("click", function () {
                                    var htmldata = GetCKEditorContent('txteditChild');
                                    ShowAjaxLoader();
                                    var postData = {
                                        tid: tid,
                                        Description: htmldata
                                    };

                                    $.ajax({
                                        url: '../../../WebServices/JGWebService.asmx/UpdateTaskDescriptionChildById',
                                        contentType: 'application/json; charset=utf-8;',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: JSON.stringify(postData),
                                        asynch: false,
                                        success: function (data) {
                                            alert('Child saved successfully.');
                                            HideAjaxLoader();
                                            $('#ChildEdit' + tid).html(htmldata);
                                            isadded = false;
                                        },
                                        error: function (a, b, c) {
                                            HideAjaxLoader();
                                        }
                                    });
                                    $(this).css({ 'display': "none" });                                    
                                });
                            }
                            return false;
                        });
                    });
                }, 1);
            });
        }, 2);
        

        

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

    $scope.LevelToRoman = function (levelChar, indent) {
        if (levelChar == '' || levelChar == undefined) {
            return "I";
        }
        else {
            if (indent == 1)
                return romanize(roman_to_Int(levelChar.toUpperCase()) + 1).toUpperCase();
            else if (indent == 2)
                return romanize(roman_to_Int(levelChar.toUpperCase()) + 1).toLowerCase();
            else if (indent == 3) {
                var s = idOf(((levelChar.charCodeAt(0) - 97) + 1));
                return s;
            }
            else
                return romanize(levelChar);
        }
    }

    //Create a Scope
    sequenceScopeTG = $scope;
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

function romanize(num) {
    var lookup = { M: 1000, CM: 900, D: 500, CD: 400, C: 100, XC: 90, L: 50, XL: 40, X: 10, IX: 9, V: 5, IV: 4, I: 1 }, roman = '', i;
    for (i in lookup) {
        while (num >= lookup[i]) {
            roman += i;
            num -= lookup[i];
        }
    }
    return roman;
}

function roman_to_Int(str1) {
    if (str1 == null) return -1;
    var num = char_to_int(str1.charAt(0));
    var pre, curr;

    for (var i = 1; i < str1.length; i++) {
        curr = char_to_int(str1.charAt(i));
        pre = char_to_int(str1.charAt(i - 1));
        if (curr <= pre) {
            num += curr;
        } else {
            num = num - pre * 2 + curr;
        }
    }

    return num;
}
function char_to_int(c) {
    switch (c) {
        case 'I': return 1;
        case 'V': return 5;
        case 'X': return 10;
        case 'L': return 50;
        case 'C': return 100;
        case 'D': return 500;
        case 'M': return 1000;
        default: return -1;
    }
}

function idOf(i) {
    return (i >= 26 ? idOf((i / 26 >> 0) - 1) : '') + 'abcdefghijklmnopqrstuvwxyz'[i % 26 >> 0];
}

function LetterToNumber(str) {
    var out = 0, len = str.length;
    for (pos = 0; pos < len; pos++) {
        out += (str.charCodeAt(pos) - 64) * Math.pow(26, len - pos - 1);
    }
    return out;
}