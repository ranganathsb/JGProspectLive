<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TouchPointLog.aspx.cs" Inherits="JG_Prospect.Sr_App.TouchPointLog" %>

<%--<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .notes-section {
            float: left;
    width: 80%;
    margin: 0 0 0 10px;
        }

        .notes-popup {
            width: 100%;
            background: #fff;
            border-radius: 5px;
            margin: 10px 0px;
        }

        .notes-popup-background {
            display: none;
            height: 100%;
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 10;
            background: #000;
            opacity: 0.5;
        }

        .notes-popup .heading {
            width: 100%;
            display: inline-block;
            background: #A33E3F;
            color: #fff;
            padding: 5px 0;
            border-radius: 5px 5px 0 0;
        }

            .notes-popup .heading .title {
                padding: 0 5px;
                float: left;
            }

        .notes-popup .content {
            padding: 5px;
        }

        .notes-popup .heading .close {
            float: right;
            top: -11px;
            font-size: 14px;
            right: -8px;
            background: #ccc;
            border-radius: 19px;
            cursor: pointer;
        }

        .notes-popup .content table {
            width: 100%;
        }

            .notes-popup .content table th {
                border: 1px solid #ccc;
                text-align: left;
                padding: 3px;
                font-size: 13px;
                color: #ddd;
                background: #000;
            }

            .notes-popup .content table td {
                padding: 3px;
                font-size: 12px;
                border: 1px solid #ccc;
            }

            .notes-popup .content table tr:nth-child(even) {
                background: #ba4f50;
                color: #fff;
            }

            .notes-popup .content table tr:nth-child(odd) {
                background: #FFF;
                color: #000;
            }

            .notes-popup .content table tr th:nth-child(1), .notes-popup .content table tr td:nth-child(1) {
                width: 210px;
            }

        .notes-popup .add-notes-container {
            display: inline-block;
            width: 98%;
            padding: 5px;
            POSITION: relative;
        }

            .notes-popup .add-notes-container textarea {
                width: 80% !important;
                height: 50px !important;
                padding: 5px !important;
                float: left;
                margin-right: 10px;
            }

        .notes-popup .notes-container .note-desc {
            width: 194px;
            height: 29px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .notes-table tr:nth-child(odd) a {
        }

        .notes-table tr:nth-child(even) a, .notes-popup tr:nth-child(even) a {
            color: #fff;
        }

        .notes-table tr th:nth-child(1), .notes-table tr td:nth-child(1) {
            width: 5%;
        }

        .notes-table tr th:nth-child(2), .notes-table tr td:nth-child(2) {
            width: 27%;
        }

        .notes-table tr th:nth-child(3), .notes-table tr td:nth-child(3) {
            width: 90px;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }

        .GrdBtnAdd {
            margin-top: 12px;
            height: 30px;
            background: url(img/main-header-bg.png) repeat-x;
            color: #fff;
            cursor: pointer;
            border-radius: 5px;
        }
    </style>
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
                                        '<td><a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UserID + '">' + data.Data[i].SourceUser + '<br/>' + data.Data[i].ChangeDateTimeFormatted + '</a></td>' +
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
                    data: '{ id: ' + uid + ', note: "' + note + '" }',
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
