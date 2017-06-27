var app = angular.module('JGApp', []);
var url = '/WebServices/JGWebService.asmx/';
var sequenceScope;

/*************************************************************************/
// DIRECTIVES

app.directive('jgpager', function () {
    return {
        scope: {
            page: '@',
            pagesCount: '@',
            TotalRecords: '@',
            searchFunc: '&'
        },
        replace: true,
        restrict: 'E',
        templateUrl: '../js/angular/templates/pager-template.html',
        controller: ['$scope', function ($scope) {
            $scope.search = function (i) {
                if ($scope.searchFunc) {
                    $scope.searchFunc({ page: i });
                }
            };

            $scope.range = function () {
                if (!$scope.pagesCount) { return []; }
                var step = 2;
                var doubleStep = step * 2;
                var start = Math.max(0, $scope.page - step);
                var end = start + 1 + doubleStep;
                if (end > $scope.pagesCount) { end = $scope.pagesCount; }

                var ret = [];
                for (var i = start; i != end; ++i) {
                    ret.push(i);
                }

                return ret;
            };
        }]
    }
});
