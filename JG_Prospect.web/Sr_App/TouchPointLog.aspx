<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TouchPointLog.aspx.cs" Inherits="JG_Prospect.Sr_App.TouchPointLog" %>

<%--<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/touchPointlogs.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notes-section" tuid="<%=loggedInUserId %>">
        <div class="notes-popup">
            <div class="heading">
                <div class="title">User Touch Point Logs</div>

                <input type="hidden" id="PageIndex" value="0" />
            </div>
            <div class="content">
                Loading Notes...
            </div>
            <div class="pagingWrapper">
                <div class="total-results">Total <span class="total-results-count"></span>Results</div>
                <div class="pager">
                    <span class="first">« First</span> <span class="previous">Previous</span> <span class="numeric"></span><span class="next">Next</span> <span class="last">Last »</span>
                </div>
                <div class="pageInfo">
                </div>
            </div>
            <div class="add-notes-container">
                <textarea id="note-text" class="note-text textbox"></textarea>
                <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addPopupNotes(this)" />
            </div>
        </div>
    </div>

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>

    <script type="text/javascript">
        function Paging(sender) {
            $('#PageIndex').val(paging.currentPage);
            ajaxExt({
                url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
                type: 'POST',
                data: '{ pageNumber: ' + $('#PageIndex').val() + ', pageSize: ' + paging.pageSize + ', userId: ' + <%=loggedInUserId%> + ' }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    if (data.Data.length > 0) {
                        PageNumbering(data.TotalResults);
                        var tbl = '<table cellspacing="0" cellpadding="0"><tr><th>Updated By<br/>Created On</th><th>Note</th></tr>';
                        $(data.Data).each(function (i) {
                            tbl += '<tr id="' + data.Data[i].UserTouchPointLogID + '">' +
                                        '<td><a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UpdatedByUserID + '">' + data.Data[i].SourceUser + '<br/>' + data.Data[i].ChangeDateTimeFormatted + '</a></td>' +
                                        '<td title="' + data.Data[i].LogDescription + '"><div class="note-desc">' + data.Data[i].LogDescription + '</div></td>' +
                                    '</tr>';
                        });
                        tbl += '</table>';
                        $('.notes-popup .content').html(tbl);
                        var tuid = getUrlVars()["TUID"];
                        var nid = getUrlVars()["NID"];
                        if (tuid != undefined && nid != undefined) {
                            $('.notes-popup tr#' + nid).addClass('blink-notes');
                            $('html, body').animate({
                                scrollTop: $(".notes-popup").offset().top
                            }, 2000);
                        }
                        $('.pagingWrapper').show();
                        tribute.attach(document.querySelectorAll('.note-text'));
                    } else {
                        $('.notes-popup .content').html('Notes not found');
                        $('.pagingWrapper').hide();
                    }
                }
            });
            return false;
        }
        function addPopupNotes(sender) {
            var userId = '<%=loggedInUserId%>';
            addNotes(sender, userId);
        }
        function addNotes(sender, uid) {
            var note = $(sender).parent().find('.note-text').val();
            if (note != '')
                ajaxExt({
                    url: '/Sr_App/edituser.aspx/AddNotes',
                    type: 'POST',
                    data: '{ id: ' + uid + ', note: "' + note + '", touchPointSource: ' + <%=(int)JG_Prospect.Common.TouchPointSource.TouchPointLogPage %> + ' }',
                    showThrobber: true,
                    throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                    success: function (data, msg) {
                        $(sender).parent().find('.note-text').val('');
                        Paging(sender);
                    }
                });
        }
        var pageSize = 20;
        $(document).ready(function () {
            Paging($(this));
        });
    </script>
</asp:Content>
