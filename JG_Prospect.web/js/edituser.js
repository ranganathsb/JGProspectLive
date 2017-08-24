function ChangeStatusForSelected() {

    var tableRows = $(UserGridId).find('> tbody > tr');
    editSalesUserScope.EditSalesUsers = [];

    // set seleted user's id for serch.
    if (tableRows) {
        $.each(tableRows, function (index, item) {
            var checkboxspan = $(item).find("span.useraction");// find span that contains action checkbox
            var checkbox = $(checkboxspan).find("input"); // find action checkbox

            if (checkbox && $(checkbox).is(':checked')) { // if checbox is checked.
                // set into angular function for users to be searched.
                editSalesUserScope.SetEditUsersForSearch($(checkboxspan).attr("data-userid"));
                editSalesUserScope.SearchDesignationId = parseInt($(checkboxspan).attr("data-designationid"));
            }
        });
    }

    //Call search function
    console.log(editSalesUserScope.EditSalesUsers);

    $('#EditUsersModal').removeClass("hide");

    var dlg = $('#EditUsersModal').dialog({
        width: 1100,
        height: 700,
        show: 'slide',
        hide: 'slide',
        autoOpen: true,
        modal: false,
        beforeClose: function (event, ui) {
            $('#EditUsersModal').addClass("hide");
        }
    });

    editSalesUserScope.getEditUsers();

}

function GetSequences() {

    console.log("End function of EditUser....");

    var postData = { DesignationId: editSalesUserScope.SearchDesignationId, UserCount: editSalesUserScope.EditSalesUsers.length };

    console.log(postData);

    CallJGWebService('GetInterviewDateSequences', postData, OnGetSequenceSuccess, OnGetSequenceError);

    function OnGetSequenceSuccess(data) {
        
        if (data.d) {            
            AllocatedUserWithSequences(JSON.parse(data.d));
        }
    }

    function OnGetSequenceError(err) {
        alert("Error occured while loading sequences automatically.");        
    }
}

function AllocatedUserWithSequences(AvailableSequences) {
    
    console.log(AvailableSequences);

    var SeqArray = AvailableSequences;

    //Get table rows for edit users.
    var tableRows = $('#tblEditUserPopup > tbody > tr');

    console.log(tableRows);

    $.each(tableRows, function (Index,Item) {

        var td = $(Item).find("td.SeqAssignment");// find td that contains assignment.
        var taskUrl = "/Sr_App/TaskGenerator.aspx?TaskId=#PTID#&hstid=#HTID#";
        console.log(SeqArray.length);
        console.log(Index);

        // Untill sequence is available assign it.
        if (SeqArray.length > Index) {
            
            var seqLabel = $(td).find("label.seqLable");
            $(seqLabel).html(angular.getSequenceDisplayText(SeqArray[Index].SequenceNo, editSalesUserScope.SearchDesignationId, "TT"));

            //console.log(seqLabel);

            var TaskURL = $(td).find("a.seqTaskURL");            
            $(TaskURL).html(SeqArray[Index].InstallId);
            $(TaskURL).attr("href", taskUrl.replace("#PTID#", SeqArray[Index].ParentTaskId).replace("#HTID#", SeqArray[Index].TaskId));
            
            //console.log(TaskURL);
        }
        

    });
}