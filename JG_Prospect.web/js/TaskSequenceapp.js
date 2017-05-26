/// <reference path="TaskSequenceapp.js" />
var app = angular.module('JGApp', []);
var url = '/WebServices/JGWebService.asmx/';
app.factory('taskSequenceFactory', function ($http) {
    return {
        getTasksWithSequence: function (methodName) {
            return $http.get(url + methodName);
        }
    };
});