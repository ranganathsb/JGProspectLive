app.controller('TaskSequenceController', function PostsController($scope, taskSequenceFactory) {
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

app.controller('TaskSequenceSearchController', function PostsController($scope, taskSequenceFactory) {
    $scope.Tasks = [];

    
    $scope.loading = false;
    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.Currentpage = 0;
    $scope.TotalRecords = 0;
    $scope.HighLightTaskId = 0;

    $scope.getTasks = function (page,DesignationIds,IsTechTask,HighLightTaskId) {
        page = page || 0;
        $scope.Currentpage = page;
        $scope.HighLightTaskId = HighLightTaskId;
        $scope.loading = true;
       

        //get all Customers
        taskSequenceFactory.getTasksWithSearchandPaging("GetAllTasksWithPaging", { page: page, pageSize: 8, DesignationIDs: DesignationIds, IsTechTask: IsTechTask, HighlightedTaskID: HighLightTaskId }).then(function (data) {
            var results = JSON.parse(data.data.d);            
            console.log(results.Tasks);
            
            $scope.page = $scope.Currentpage;
            $scope.TotalRecords = results.RecordCount[0].TotalRecords;
            $scope.pagesCount = results.RecordCount[0].TotalPages;
            $scope.Tasks = results.Tasks;

            $scope.TaskSelected = $scope.Tasks[0];
            $scope.loading = false;
            
        });

    };

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