app.controller('TaskSequenceSearchController', function PostsController($scope, taskSequenceFactory) {

    $scope.Tasks = [];
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationSelectModel = [];
    $scope.IsTechTask = true;

    $scope.loading = false;
    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.Currentpage = 0;
    $scope.TotalRecords = 0;
    $scope.HighLightTaskId = 0;

    $scope.getTasks = function (page) {

        $scope.loading = true;
        $scope.page = page || 0;

        //get all Customers
        taskSequenceFactory.getTasksWithSearchandPaging("GetAllTasksWithPaging", { page: $scope.page, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds.join(), IsTechTask: $scope.IsTechTask, HighlightedTaskID: $scope.HighLightTaskId }).then(function (data) {
            $scope.DesignationSelectModel = [];
            var results = JSON.parse(data.data.d);
            //console.log(results.Tasks);
            $scope.page = results.RecordCount[0].PageIndex;
            $scope.TotalRecords = results.RecordCount[0].TotalRecords;
            $scope.pagesCount = results.RecordCount[0].TotalPages;
            $scope.Tasks = results.Tasks;

            $scope.TaskSelected = $scope.Tasks[0];
            // $scope.loading = false;

        });
    };

    $scope.SetIsTechTask = function () {
        $scope.getTasks();
    }

    $scope.SetDesignForSearch = function (value, isRemove) {

        if (isRemove) {
            $scope.UserSelectedDesigIds.pop(value);
        }
        else { // if element is to be added
            if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
                $scope.UserSelectedDesigIds.push(value);
            }
        }
        $scope.getTasks();
    };

    $scope.getDesignationString = function (Designations) {

        var DesignationArray = JSON.parse("[" + Designations + "]");

        return DesignationArray.map(function (elem) {
            return elem.Name;
        }).join(",");
    };

    $scope.getDesignationsArray = function (Designations) {

        var DesignationArray = JSON.parse("[" + Designations + "]");

        $scope.DesignationSelectModel.push(DesignationArray[0]);

        return DesignationArray;

    };

    $scope.designationChanged = function () {
    };

    $scope.updateonAjaxRequest = function () {
        taskSequenceFactory.updateonAjaxRequest('taskSequence', $scope);
    }


});


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
