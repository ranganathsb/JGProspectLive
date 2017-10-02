app.controller('ClosedTaskController', function ($scope, $compile, $http, $timeout, $filter) {
    applyFunctionsClosedTask($scope, $compile, $http, $timeout, $filter);
});
function getAllClosedTasksWithSearchandPaging($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function applyFunctionsClosedTask($scope, $compile, $http, $timeout , $filter) {

    $scope.ClosedTask = [];
    $scope.vSearch = "";

    $scope.loaderClosedTask = {
        loading: false,
    };
    
    $scope.pageClosedTask = 0;
    $scope.pagesCountClosedTask = 0;
    $scope.CurrentpageClosedTask = 0;
    $scope.TotalRecordsClosedTask = 0;
    $scope.example1model = []; $scope.example1data = [{ id: 1, label: "David" }, { id: 2, label: "Jhon" }, { id: 3, label: "Danny" }];

    $scope.getClosedTasks = function (page) {
            console.log("Closed Task called....");
            $scope.loaderClosedTask.loading = true;
            $scope.pageClosedTask = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.Tasks = [];

            //debugger;
            //get all Customers
            getAllClosedTasksWithSearchandPaging($http, "GetAllClosedTasks", { page: $scope.pageClosedTask, pageSize: sequenceScope.pageSize, DesignationIDs: sequenceScope.UserSelectedDesigIdsClosedTaks, userid: sequenceScope.UserId, vSearch: $scope.vSearch }).then(function (data) {
                
                $scope.loaderClosedTask.loading = false;
                //$scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.pageClosedTask = results.RecordCount.PageIndex;
                $scope.TotalRecordsClosedTask = results.RecordCount.TotalRecords;
                $scope.pagesCountClosedTask = results.RecordCount.TotalPages;
                $scope.ClosedTask = $scope.correctDataforAngularClosedTaks(results.Tasks);
                //$scope.TaskSelected = $scope.TechTasks[0];                
            });
    };

    $scope.SetDesignForSearch = function (value, isReload) {
        $scope.UserSelectedDesigIdsClosedTaks = [];
        $scope.UserSelectedDesigIdsClosedTaks.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            $scope.getClosedTasks();
        }

    };

    $scope.refreshClosedTask = function () {
        $scope.getClosedTasks();
    };

    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

    sequenceScopeClosedTasks = $scope;

    $scope.correctDataforAngularClosedTaks = function (ary) {

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
}
