﻿app.controller('TaskSequenceSearchController',function ($scope, $compile, $http, $timeout,$filter) {
    applyFunctions($scope, $compile, $http, $timeout,$filter);

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

function applyFunctions($scope, $compile, $http, $timeout , $filter) {

    $scope.Tasks = [];
    $scope.ParentTaskDesignations = [];
    $scope.DesignationAssignUsers = [];
    $scope.DesignationAssignUsersModel = [{ FristName: "Select", Id: 0, Status: "", CssClass: "" }];
    $scope.SelectedParentTaskDesignation;
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationSelectModel = [];
    $scope.IsTechTask = true;

    $scope.loading = false;
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
            setActiveTab(false);
            SetSeqApprovalUI();
            console.log("this is staff end");
            SetChosenAssignedUser();
        }, 1);
    };

    $scope.onTechEnd = function () {
        $timeout(function () {
            if ($scope.IsTechTask) {
                setActiveTab(true);
                SetSeqApprovalUI();
            }
        }, 1);
    };

   
    $scope.getTasks = function (page) {
       // console.log("Staff Task called....");
        $scope.loading = true;
        $scope.page = page || 0;

        //get all Customers
        getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.page, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds.join(), IsTechTask: false, HighlightedTaskID: $scope.HighLightTaskId }).then(function (data) {

            $scope.IsTechTask = false;
            $scope.DesignationSelectModel = [];
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.TasksData;
            console.log(results);
            $scope.page = results.RecordCount.PageIndex;
            $scope.TotalRecords = results.RecordCount.TotalRecords;
            $scope.pagesCount = results.RecordCount.TotalPages;
            $scope.Tasks = results.Tasks;
            $scope.TaskSelected = $scope.Tasks[0];
            //console.log('Counting Data...');
            //console.log(results.RecordCount.PageIndex);
            //console.log(results.RecordCount.TotalRecords);
            //console.log(results.RecordCount.TotalPages);

        });
    };

    $scope.getTechTasks = function (page) {
        //console.log("Tech Task called....");

        if ($scope.IsTechTask) {
            $scope.loading = true;
            $scope.Techpage = page || 0

            //get all Customers
            getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.Techpage, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds.join(), IsTechTask: true, HighlightedTaskID: $scope.HighLightTaskId }).then(function (data) {

                $scope.IsTechTask = true;
                $scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                $scope.Techpage = results.RecordCount.PageIndex;
                $scope.TechTotalRecords = results.RecordCount.TotalRecords;
                $scope.TechpagesCount = results.RecordCount.TotalPages;
                $scope.TechTasks = results.Tasks;
                $scope.TaskSelected = $scope.TechTasks[0];

            });

        }
    };

    $scope.getAssignUsers = function () {

        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIds.join() }).then(function (data) {

            var AssignedUsers = JSON.parse(data.data.d);

            ///console.log(AssignedUsers);

            $scope.DesignationAssignUsers = AssignedUsers;

        });

    };

    $scope.SetIsTechTask = function () {
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
    
    $scope.SetDesignForSearch = function (value, isRemove) {
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
        if ($scope.IsTechTask) {
            $scope.getTechTasks();
        }
        else {
            $scope.getTasks();
        }

    };

    $scope.refreshTasks = function () {
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
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
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
                prefix = "ITPH";
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
            case 24:
                prefix = "ITSQA";
                break;
            case 25:
                prefix = "ITJQA";
                break;
            case 26:
                prefix = "ITJPH";
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

function initializeOnAjaxUpdate(scope, compile, http, timeout,filter) {


    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divTaskNG"));
        compile(elem.children())(scope);
        scope.$apply();

        applyFunctions(scope, compile, http, timeout,filter);
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
