﻿app.controller('TaskSequenceSearchController', function ($scope, $compile, $http, $timeout, $filter) {
    applyFunctions($scope, $compile, $http, $timeout, $filter);
});

function getTasksWithSearchandPaging(methodName, $http) {
    return $http.get(url + methodName);
}

function getTasksWithSearchandPagingM($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function getDesignationAssignUsers($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function getTasksForSubSequencing($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};



function applyFunctions($scope, $compile, $http, $timeout, $filter) {

    $scope.Tasks = [];
    $scope.ClosedTask = [];
    $scope.dish = [];
    $scope.ParentTaskDesignations = [];
    $scope.DesignationAssignUsers = [];
    $scope.DesignationAssignUsersModel = [{ FristName: "Select", Id: 0, Status: "", CssClass: "" }];
    $scope.SelectedParentTaskDesignation;
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationSelectModel = [];
    $scope.UserStatus = 1;
    $scope.StartDate = '';
    $scope.EndDate = '';
    $scope.IsTechTask = true;
    $scope.ForDashboard = false;
    $scope.UserId = '';
    $scope.vSearch = "";
    $scope.pageFrom = "0";
    $scope.pageTo = "0";
    $scope.pageOf = "0";
    $scope.SeqSubsets = [];


    $scope.loader = {
        loading: false,
    };

    $scope.loaderClosedTask = {
        loading: false,
    };

    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.Currentpage = 0;
    $scope.TotalRecords = 0;
    $scope.HighLightTaskId = 0;
    $scope.BlinkTaskId = 0;


    $scope.TechTasks = [];
    $scope.Techpage = 0;
    $scope.TechpagesCount = 0;
    $scope.TechCurrentpage = 0;
    $scope.TechTotalRecords = 0;


    $scope.onStaffEnd = function () {
        $timeout(function () {
            setFirstRowAutoData();
            SetSeqApprovalUI();
            SetChosenAssignedUser();

            var flag = false;
            //Show only first assigned user, rest on mouseover
            $('#tblStaffSeq .chosen-container').each(function (i, obj) {
                //Hide User Selection
                $(obj).find('li:not(:first):not(:last)').css({ "display": "none" });

                //Add class to li                
                $(obj).addClass('popover__wrapper');
                //$(obj).find('li:not(:first)').addClass('popover__wrapper');
            });         

             //Build Hyperlinks ddcbSeqAssignedStaff
            $('#tblStaffSeq .chosen-container .search-choice').each(function (i, obj) {
                var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
                if (itemIndex) {
                    //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                    var selectoptionid = '#' + $(this).parent('.chosen-choices').parent('.chosen-container').attr('id').replace("_chosen", "") + ' option';
                    var chspan = $(this).children('span');
                    var text = chspan.text();
                    var name = text.split(' - ')[0]+ ' - ';
                    var code = text.split(' - ')[1];
                    if (chspan && code != undefined) {
                        chspan.html(name+ '<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + code + '</a>');
                        chspan.bind("click", "a", function () {
                            window.open($(this).children("a").attr("href"), "_blank", "", false);
                        });
                    }
                }
            });

            //Set MouseHover Popup
            $('.chosen-choices').mouseenter(function () {
                var parent = $(this).parent().parent().attr('class');
                if (parent.indexOf('chosen-div') >= 0) {
                    if ($(this).find('li').length > 1) {

                        $('#popoverCloseButton').click(function () {
                            $('.popover__content').fadeOut(200);
                        });
                        $('.popover__content').mouseleave(function () {
                            $('.popover__content').hide();
                        });

                        //Show Popover
                        var parentOffset = $(this).parent().offset();
                        var relX = parentOffset.left;
                        var relY = parentOffset.top + 40;

                        $('.popover__content').css({ "left": relX });
                        $('.popover__content').css({ "top": relY });
                        $('.popover__content').fadeIn(200);


                        var data = $(this).html();
                        data = data.replace('type="text"', 'type="hidden"');
                        //console.log(data);
                        $('.popover__content div:not(:first)').html(data.replace(/none/gi, 'block'));
                    }
                    //$(this).find('li:not(:first)').css({ "display": "block" });
                }
            });

        }, 1);
    };

    $scope.onTechEnd = function () {
        $timeout(function () {
            if ($scope.IsTechTask) {
                setFirstRowAutoData();
                SetSeqApprovalUI();
                SetChosenAssignedUser();
            }
        }, 1);
    };


    $scope.getTasks = function (page) {

        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        //if (!$scope.IsTechTask) {
        console.log("Url: " + url);
        console.log("Staff Task called....");
        $scope.loader.loading = true;
        $scope.page = page || 0;

        // make it blank so TechTask grid don't bind.
        $scope.TechTasks = [];
        //debugger;
        //get all Customers
        getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.page, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds.join(), IsTechTask: false, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, TaskUserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate }).then(function (data) {
            console.log(data);
            //debugger;
            $scope.loader.loading = false;
            $scope.IsTechTask = false;
            $scope.DesignationSelectModel = [];
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.TasksData;
            console.log(results);
            $scope.page = results.RecordCount.PageIndex;
            $scope.TotalRecords = results.RecordCount.TotalRecords;
            $scope.pagesCount = results.RecordCount.TotalPages;
            $scope.Tasks = $scope.correctDataforAngular(results.Tasks);
            if ($scope.Tasks != null)
                $scope.TaskSelected = $scope.Tasks[0];

            if ($scope.TotalRecords > 0) {
                $scope.pageFrom = ($scope.page * $scope.pageSize) + 1;
                if ($scope.TotalRecords <= $scope.pageSize) {
                    $scope.pageTo = $scope.TotalRecords;
                }
                else {
                    $scope.pageTo = ($scope.page + 1) * $scope.pageSize;
                }
                $scope.pageOf = $scope.TotalRecords;
            }
            else {
                $scope.pageFrom = $scope.pageOf = $scope.pageTo = 0;
            }
        });
        //}

    };

    $scope.getTechTasks = function (page) {

        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        if ($scope.IsTechTask) {
            //console.log("Tech Task called....");
            $scope.loader.loading = true;
            $scope.Techpage = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.Tasks = [];


            //get all Customers
            getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.Techpage, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds.join(), IsTechTask: true, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, UserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate }).then(function (data) {
                $scope.loader.loading = false;
                $scope.IsTechTask = true;
                $scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.Techpage = results.RecordCount.PageIndex;
                $scope.TechTotalRecords = results.RecordCount.TotalRecords;
                $scope.TechpagesCount = results.RecordCount.TotalPages;
                $scope.TechTasks = $scope.correctDataforAngular(results.Tasks);
                //console.log($scope.TechTasks);
                //$scope.TaskSelected = $scope.TechTasks[0];

            });

        }
    };

    $scope.toRoman = function (num) {

        if (!+num)
            return false;
        var digits = String(+num).split(""),
            key = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM",
                "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC",
                "", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
            roman = "",
            i = 3;
        while (i--)
            roman = (key[+digits.pop() + (i * 10)] || "") + roman;

        return Array(+digits.join("") + 1).join("M") + roman;
    };

    $scope.getTasksForSubset = function (DesignationCode, TaskID) {
        $scope.loader.loading = true;


        //get all Customers		
        getTasksForSubSequencing($http, "GetAllTasksforSubSequencing", { DesignationId: $scope.UserSelectedDesigIds.join(), DesiSeqCode: DesignationCode, IsTechTask: false, TaskId: TaskID }).then(function (data) {
            console.log(data);
            $scope.loader.loading = false;
            var resultArray = JSON.parse(data.data.d);

            var results = resultArray.Tasks;
            console.log(results);
            $scope.SeqSubsets = results;

            //console.log('Counting Data...');		
            //console.log(results.RecordCount.PageIndex);		
            //console.log(results.RecordCount.TotalRecords);		
            //console.log(results.RecordCount.TotalPages);		
        });
    };


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

    $scope.getAssignUsers = function () {
        //debugger;

        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIds.join() }).then(function (data) {

            var AssignedUsers = JSON.parse(data.data.d);

            ///console.log(AssignedUsers);
            //
            $scope.DesignationAssignUsers = AssignedUsers;

        });

    };

    $scope.SetIsTechTask = function () {
        console.log("callled $scope.SetIsTechTask");
        $scope.getTechTasks();

    };

    $scope.SetAssignedUsers = function (AssignedUsers) {
        //var selected = false;

        //if (AssignedUsers) {

        //   $scope.AssignedUsersArray = angular.fromJson("["+AssignedUsers+"]");

        //   angular.forEach($scope.AssignedUsersArray, function (value, key) {           
        //       if (parseInt(value.Id) === parseInt(UserId)) {
        //            selected = true;
        //           return selected;
        //       }
        //   });
        //}

        //return selected;
        if (AssignedUsers) {
            $scope.AssignedUsersArray = angular.fromJson("[" + AssignedUsers + "]");
        }
        else {
            $scope.AssignedUsersArray = [];
        }
        return $scope.AssignedUsersArray;
    };

    $scope.SetDesignForSearch = function (value, isReload) {
        $scope.UserSelectedDesigIds = [];
        $scope.UserSelectedDesigIds.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            if ($scope.IsTechTask) {
                console.log("called $scope.SetDesignForSearch");
                $scope.getTechTasks();
            }
            else {
                $scope.getTasks();
            }
        }

    };

    $scope.refreshTasks = function () {
        console.log("called $scope.refreshTasks");
        if ($scope.IsTechTask) {
            $scope.getTechTasks();
        }
        else {
            $scope.getTasks();
        }
    };

    $scope.getDesignationString = function (Designations) {

        if (!angular.isUndefinedOrNull(Designations)) {
            var DesignationArray = JSON.parse("[" + Designations + "]");

            return DesignationArray.map(function (elem) {
                return elem.Name;
            }).join(",");
        }
        else {
            return "";
        }
    };

    $scope.getDesignationsModel = function (SeqDesign) {

        var DesignModel;

        //console.log(SeqDesign);

        if (!angular.isUndefinedOrNull(SeqDesign)) {
            DesignModel = $scope.ParentTaskDesignations.filter(function (obj) {
                return obj.Id === SeqDesign.toString();
            })[0];
        }
        else {

            DesignModel = $scope.ParentTaskDesignations.filter(function (obj) {
                return obj.Id === $(ddlDesigSeqClientID).val();
            })[0];
        }

        //if (!DesignModel) {
        //    DesignModel = { 'Name': $(ddlDesigSeqClientID).text(), 'Id': $(ddlDesigSeqClientID).val() };
        //}

        // console.log("Assigning designation model value is.....");

        // console.log(DesignModel);

        return DesignModel;

    };

    $scope.designationChanged = function () {
    };

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.getSequenceDisplayText_ = function (strSequence, strDesigntionID, seqSuffix) {
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";

        if (strSequence == "N.A.") {
            sequenceText = strSequence;
        }
        else {
            //console.log(strSequence + strDesigntionID + seqSuffix);            
            sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        }
        return sequenceText;
    };

    $scope.GetInstallIDPrefixFromDesignationIDinJS = function (DesignID) {

        var prefix = "";
        switch (DesignID) {
            case 1:
                prefix = "ADM";
                break;
            case 2:
                prefix = "JSL";
                break;
            case 3:
                prefix = "JPM";
                break;
            case 4:
                prefix = "OFM";
                break;
            case 5:
                prefix = "REC";
                break;
            case 6:
                prefix = "SLM";
                break;
            case 7:
                prefix = "SSL";
                break;
            case 8:
                prefix = "ITNA";
                break;
            case 9:
                prefix = "ITJN";
                break;
            case 10:
                prefix = "ITSN";
                break;
            case 11:
                prefix = "ITAD";
                break;
            case 12:
                prefix = "ITSPH";
                break;
            case 13:
                prefix = "ITSB";
                break;
            case 14:
                prefix = "INH";
                break;
            case 15:
                prefix = "INJ";
                break;
            case 16:
                prefix = "INM";
                break;
            case 17:
                prefix = "INLM";
                break;
            case 18:
                prefix = "INF";
                break;
            case 19:
                prefix = "COM";
                break;
            case 20:
                prefix = "SBC";
                break;
            case 22:
                prefix = "ADS";
                break;
            case 23:
                prefix = "ADR";
                break;
            case 24:
                prefix = "ITSQA";
                break;
            case 25:
                prefix = "ITJQA";
                break;
            case 26:
                prefix = "ITJPH";
                break;
            case 27:
                prefix = "ITSSE";
                break;
            case 28:
                prefix = "ITSTE";
                break;
            case 29:
                prefix = "ITFRXD";
                break;
            default:
                prefix = "N.A.";
                break;
        }

        return prefix;
    };


    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

    initializeOnAjaxUpdate($scope, $compile, $http, $timeout, $filter);

    sequenceScope = $scope;

}

function initializeOnAjaxUpdate(scope, compile, http, timeout, filter) {


    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divTaskNG"));
        compile(elem.children())(scope);
        scope.$apply();

        applyFunctions(scope, compile, http, timeout, filter);
    });

    //Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
    //    var elem = angular.element(document.getElementById("divTaskNG"));

    //    elem.replaceWith(compile(elem)(scope));
    //    scope.$apply();

    //    console.log(scope);

    //    applyFunctions(scope, compile, http);

    //});
}


app.controller('AddNewTaskSequenceController', function PostsController($scope, taskSequenceFactory) {
    $scope.Tasks = [];
    $scope.getTasks = function () {
        $scope.loading = true;

        //get all Customers
        taskSequenceFactory.getTasksWithSequence("GetAllTaskWithSequence").then(function (data) {
            $scope.Tasks = data.data;
            $scope.TaskSelected = $scope.Tasks[0];
            $scope.loading = false;
        });

    };

});
