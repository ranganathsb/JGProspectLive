app.controller('SalesUserController', function ($scope, $compile, $http, $timeout, $filter) {
    _applyFunctions($scope, $compile, $http, $timeout, $filter);
});
function callWebServiceMethod($http, methodName, filters, sender) {
    $("#MainThrobberImage").show().position({ my: "left center", at: "right center", of: $(sender), offset: "5 0" });
    return $http.post(url + methodName, filters);
};
function _applyFunctions($scope, $compile, $http, $timeout, $filter) {
    //var list = '[{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},]';

    $scope.UserList = [];
    $scope.UserEmailList = [];
    $scope.UserPhoneList = [];
    $scope.Test = { 'Id': 100 };

    $scope.Paging = function (sender) {
        $('#PageIndex').val(paging.currentPage);
        var keyword = $('.userKeyword').val().trim();
        var status = $('div.user-status select').find('option:selected').val();
        var designationId = $('div.designationId select').find('option:selected').val();
        var source = $('div.source select').find('option:selected').val();
        var from = $('input.fromDate').val();
        var to = $('input.toDate').val();
        var addedBy = $('div.addedBy select').find('option:selected').val();
        var sortBY = 'CreatedDateTime DESC';
        if (from == '' || from == null)
            from = '01/01/1999';
        if (to == '' || to == null)
            to = '01/01/2080';

        callWebServiceMethod($http, 'GetSalesUsers', { startIndex: $('#PageIndex').val(), pageSize: paging.pageSize, keyword: keyword, status: status, designationId: designationId, source: source, from: from, to: to, addedByUserId: addedBy, sortBY: sortBY }, sender)
            .then(function (data) {
                RemoveThrobber();
                $scope.UserList = JSON.parse(data.data.d);
                PageNumbering($scope.UserList.TotalResults);
                //userDesignations

                var str = '', options = '';
                setTimeout(function () {
                    options = $('.userlist-grid .header-table .user-designations').find('select').html();
                    str = '<select class="" onchange="ChangeDesignation(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.userDesignations').each(function (i) {
                        var did = $(this).attr('did');
                        $(this).html(str);
                        $(this).find('option:nth-child(1)').remove();
                        $(this).find('select').val(did);
                    });

                    options = $('.userlist-grid .header-table .user-status').find('select').html();
                    str = '<select class="" onchange="ChangeUserStatus(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.status').each(function (i) {
                        var stid = $(this).attr('stid');
                        $(this).html(str);
                        $(this).find('option:nth-child(1)').remove();
                        $(this).find('select').val(stid);
                    });

                    options = $('.userlist-grid .header-table .employmentTypes').find('select').html();
                    str = '<select class="" onchange="updateEmpType(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.employmentTypes').each(function (i) {
                        var empType = $(this).attr('empType');
                        $(this).html(str);
                        $(this).find('select').val(empType);
                    });

                    options = $('.userlist-grid .header-table .phoneTypes').find('select').html();
                    str = '<select class="" onchange="setWatermark(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.phoneTypes').each(function (i) {
                        // var empType = $(this).attr('empType');
                        $(this).html(str);
                        //$(this).find('select').val(empType);
                    });
                    $('#SalesUserGrid').find('select').find('option').removeAttr('data-ng-repeat');
                    $('#SalesUserGrid').find('select').find('option').removeAttr('class');
                    $('#SalesUserGrid').find('select').chosen({ width: '100%' });

                    // Loading Notes
                    ReLoadNotes();
                }, 100);
            });
    }

    sequenceScopePhone = $scope;
}