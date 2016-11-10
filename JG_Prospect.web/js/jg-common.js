
function ShowPopupWithTitle(varControlID, strTitle) {
    var objDialog = ShowPopup(varControlID);
    // this will update title of current dialog.
    objDialog.parent().find('.ui-dialog-title').html(strTitle);
}

function HidePopup(varControlID) {
    $(varControlID).dialog("close");
}


function GetWorkFileDropzone(strDropzoneSelector, strPreviewSelector, strHiddenFieldIdSelector, strButtonIdSelector) {
    var strAcceptedFiles = '';
    if ($(strDropzoneSelector).attr("data-accepted-files")) {
        strAcceptedFiles = $(strDropzoneSelector).attr("data-accepted-files");
    }

    return new Dropzone(strDropzoneSelector,
        {
            maxFiles: 5,
            url: "taskattachmentupload.aspx",
            thumbnailWidth: 90,
            thumbnailHeight: 90,
            acceptedFiles: strAcceptedFiles,
            previewsContainer: strPreviewSelector,
            init: function () {
                this.on("maxfilesexceeded", function (data) {
                    //var res = eval('(' + data.xhr.responseText + ')');
                    alert('you are reached maximum attachment upload limit.');
                });

                // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                this.on("success", function (file, response) {
                    var filename = response.split("^");
                    $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');
                    AddAttachmenttoViewState(filename[0] + '@' + file.name, strHiddenFieldIdSelector);
                    if (typeof (strButtonIdSelector) != 'undefined' && strButtonIdSelector.length > 0) {
                        // saves attachment.
                        $(strButtonIdSelector).click();
                        //this.removeFile(file);
                    }
                });

                //when file is removed from dropzone element, remove its corresponding server side file.
                //this.on("removedfile", function (file) {
                //    var server_file = $(file.previewTemplate).children('.server_file').text();
                //    RemoveTaskAttachmentFromServer(server_file);
                //});

                // When is added to dropzone element, add its remove link.
                //this.on("addedfile", function (file) {

                //    // Create the remove button
                //    var removeButton = Dropzone.createElement("<a><small>Remove file</smalll></a>");

                //    // Capture the Dropzone instance as closure.
                //    var _this = this;

                //    // Listen to the click event
                //    removeButton.addEventListener("click", function (e) {
                //        // Make sure the button click doesn't submit the form:
                //        e.preventDefault();
                //        e.stopPropagation();
                //        // Remove the file preview.
                //        _this.removeFile(file);
                //    });

                //    // Add the button to the file preview element.
                //    file.previewElement.appendChild(removeButton);
                //});
            }

        });
}

function AddAttachmenttoViewState(serverfilename, hdnControlID) {

    var attachments;

    if ($(hdnControlID).val()) {
        attachments = $(hdnControlID).val() + serverfilename + "^";
    }
    else {
        attachments = serverfilename + "^";
    }

    $(hdnControlID).val(attachments);
}