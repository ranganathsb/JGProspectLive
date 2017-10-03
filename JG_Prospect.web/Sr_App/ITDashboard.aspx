﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="ITDashboard.aspx.cs" Inherits="JG_Prospect.Sr_App.ITDashboard" %>

<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .clsTestMail {
            padding: 20px;
            font-size: 14px;
        }

            .clsTestMail input[type='text'] {
                padding: 5px;
            }

            .clsTestMail input[type='submit'] {
                background: #000;
                color: #fff;
                padding: 5px 7px;
                border: 1px solid #808080;
            }

                .clsTestMail input[type='submit']:hover {
                    background: #fff;
                    color: #000;
                    cursor: pointer;
                }

        .table tr {
            border: solid 1px #fff;
        }

        .modalBackground {
            background-color: #333333;
            filter: alpha(opacity=70);
            opacity: 0.7;
            z-index: 100 !important;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 1px;
            border-style: solid;
            border-color: #CCCCCC;
            padding: 1px;
            width: 900px;
            Height: 550px;
            overflow-y: auto;
        }

        .badge1 {
            padding: 1px 5px 2px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            color: #ffffff;
            background-color: #e55456;
            -webkit-border-radius: 9px;
            -moz-border-radius: 9px;
            border-radius: 8px;
            display: inline;
        }

        .ui-autocomplete {
            z-index: 999999999 !important;
            max-height: 250px;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .pagination-ys {
            padding-left: 0;
            margin: 5px 0;
            border-radius: 4px;
            align-content: flex-end;
            line-height: none !important;
        }

            .pagination-ys td {
                border: none !important;
            }

            .pagination-ys table > tbody {
                height: unset !important;
            }

                .pagination-ys table > tbody > tr > td {
                    display: inline !important;
                    background: none;
                    border: none !important;
                }

                    .pagination-ys table > tbody > tr > td > a,
                    .pagination-ys table > tbody > tr > td > span {
                        position: relative;
                        float: left;
                        padding: 8px 12px;
                        line-height: 1.42857143;
                        text-decoration: none;
                        color: #dd4814;
                        background-color: #ffffff;
                        border: 1px solid #dddddd;
                        margin-left: -1px;
                    }

                    .pagination-ys table > tbody > tr > td > span {
                        position: relative;
                        float: left;
                        padding: 8px 12px;
                        line-height: 1.42857143;
                        text-decoration: none;
                        margin-left: -1px;
                        z-index: 2;
                        color: #aea79f;
                        background-color: #f5f5f5;
                        border-color: #dddddd;
                        cursor: default;
                    }

                    .pagination-ys table > tbody > tr > td:first-child > a,
                    .pagination-ys table > tbody > tr > td:first-child > span {
                        margin-left: 0;
                        border-bottom-left-radius: 4px;
                        border-top-left-radius: 4px;
                    }

                    .pagination-ys table > tbody > tr > td:last-child > a,
                    .pagination-ys table > tbody > tr > td:last-child > span {
                        border-bottom-right-radius: 4px;
                        border-top-right-radius: 4px;
                    }

                    .pagination-ys table > tbody > tr > td > a:hover,
                    .pagination-ys table > tbody > tr > td > span:hover,
                    .pagination-ys table > tbody > tr > td > a:focus,
                    .pagination-ys table > tbody > tr > td > span:focus {
                        color: #97310e;
                        background-color: #eeeeee;
                        border-color: #dddddd;
                    }

        /*.dashboard tr {
        display: flex;
    }

   .pagination-ys td {
        border-spacing: 0px !important;
        flex: 1 auto;
        word-wrap: break-word;
        background: none !important;
        line-height: none !important;
    }

    .dashboard thead tr:after {
        content:'';
        overflow-y: scroll;
        visibility: hidden;
        height: 0;
    }
 
    .dashboard thead th {
        flex: 1 auto;
        display: block;
        background-color: #000 !important;
    }

    .dashboard tbody {
        display: block;
        width: 100%;
        overflow-y: auto;
        height: 370px;
    }*/

        table.table tr.trHeader {
            background: none !important;
        }

        table.table th {
            border: none;
        }

        .dashboard tr {
            display: flex;
        }

        .dashboard td {
            border-spacing: 0px !important;
            padding: 3px !important;
            flex: 1 auto;
            word-wrap: break-word;
            background: none !important;
            padding: 3px 0 0 0 !important;
            line-height: none !important;
        }

        .dashboard thead tr:after {
            content: '';
            overflow-y: scroll;
            visibility: hidden;
            height: 0;
        }

        .dashboard thead th {
            flex: 1 auto;
            display: block;
            padding: 0px;
            background-color: #000;
        }


            .dashboard thead th:first-child {
                border-top-left-radius: 4px;
            }

            .dashboard thead th:last-child {
                border-top-right-radius: 4px;
            }


        .dashboard tbody {
            display: block;
            width: 100%;
            overflow-y: auto;
            height: 370px;
        }

        .itdashtitle {
            margin-left: 7px;
        }

        .gray {
            background-color: Gray;
        }

        .lightgray {
            background-color: lightgray;
        }

        .green {
            background-color: green;
        }

        .defaultColor {
            background-color: #F6F1F3;
        }
    </style>
    <link href="../css/chosen.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel" ng-app="JGApp">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="home.aspx">Sales Calendar</a></li>
            <li><a href="GoogleCalendarView.aspx">Master  Calendar</a></li>
            <li><a class="active" href="ITDashboard.aspx">Operations Calendar</a></li>
            <li><a href="CallSheet.aspx">Call Sheet</a></li>
            <li id="li_AnnualCalender" visible="false" runat="server"><a href="#" runat="server">Annual Event Calendar</a> </li>
        </ul>
        <!-- appointment tabs section end -->
        <h1><b>IT Dashboard</b></h1>
        <%--     <asp:Panel ID="pnlTestEmail" Visible="false" GroupingText="Test E-Mail" runat="server" CssClass="clsTestMail">
            <asp:TextBox ID="txtTestEmail" runat="server"></asp:TextBox>
            <asp:Button ID="btnTestMail" runat="server" Text="Send Mail" OnClick="btnTestMail_Click" />
            <br />
            <asp:Label runat="server" ID="lblMessage"></asp:Label>
        </asp:Panel>--%>

        <%--<asp:UpdatePanel runat="server" ID="upAlerts"><ContentTemplate>--%>
        <h2 runat="server" id="lblalertpopup">Alerts:
            <a ID="lblNonFrozenTaskCounter" runat="server" style="cursor:pointer">NA</a>
            <a ID="lblFrozenTaskCounter" runat="server" style="cursor:pointer">NA</a>            
        </h2>
        
        <!--  ------- Start DP new/frozen tasks popup ------  -->
        <div id="pnlNewFrozenTask" class="modal hide">
            <button id="btnFake" style="display: none" runat="server"></button>
            <div id="taskFrozen" ng-controller="FrozenTaskController">
                
                <table class="table" runat="server" id="table1" style="width: 100%">
                    <tr>
                        <td width="30%"><h2 class="itdashtitle">Partial Frozen Tasks</h2></td>
                        <td>Designation</td>
                        <td>Users</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:DropDownList ID="ddlDesigIdsFrozenTasks" CssClass="textbox" runat="server" AutoPostBack="false"></asp:DropDownList>
                        </td>
                        <td>
                            <select id="ddlSelectFrozenTask" data-placeholder="Select Users" multiple style="width: 350px; padding: 0 10px;" class="chosen-select-frozen">
                                <option selected value="">All</option>
                            </select><span id="lblLoadingFrozen" style="display: none">Loading...</span>
                        </td>
                        <td>
                            <input id="txtSearchUserFrozen" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" style="margin-top: 14px" />
                        </td>
                    </tr>
                </table>
                
                <div id="taskSequenceTabsFrozen">
                    <ul>
                        <li><a href="#StaffTaskFrozen">Staff Tasks</a></li>
                        <li><a href="#TechTaskFrozen">Tech Tasks</a></li>
                    </ul>
                    <div id="StaffTaskFrozen">
                        <div id="tblStaffSeqFrozen" class="div-table tableSeqTask">
                            <div class="div-table-row-header">
                                <div class="div-table-col seq-number">Sequence#</div>
                                <div class="div-table-col seq-taskid">
                                    ID#<div>Designation</div>
                                </div>
                                <div class="div-table-col seq-tasktitle">
                                    Parent Task
                                        <div>SubTask Title</div>
                                </div>
                                <div class="div-table-col seq-taskstatus">
                                    Status<div>Assigned To</div>
                                </div>
                                <div class="div-table-col seq-taskduedate">Due Date</div>
                                <div class="div-table-col seq-notes">Notes</div>
                            </div>
                            <!-- NG Repeat Div starts -->
                            <div ng-attr-id="divMasterTaskFrozen{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in FrozenTask" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onStaffEnd()">
                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClickFrozen{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabelFrozen{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                    <a id="A1" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                    <a id="A2" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}                                        
                                </div>
                                <!-- ID# and Designation ends -->

                                <!-- Parent Task & SubTask Title starts -->
                                <div class="div-table-col seq-tasktitle">
                                    {{ Task.ParentTaskTitle }}
                                        <br />
                                    {{ Task.Title }}
                                </div>
                                <!-- Parent Task & SubTask Title ends -->

                                <!-- Status & Assigned To starts -->
                                <div class="div-table-col seq-taskstatus">
                                    <select id="drpStatusSubsequence2" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                    <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>

                                    <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        <option
                                            ng-repeat="item in DesignationAssignUsers"
                                            value="{{item.Id}}"
                                            label="{{item.FristName}}"
                                            class="{{item.CssClass}}">{{item.FristName}}
                                                
                                        </option>
                                    </select>

                                    <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                                </div>
                                <!-- Status & Assigned To ends -->

                                <!-- DueDate starts -->
                                <div class="div-table-col seq-taskduedate">
                                    <div class="seqapprovalBoxes">
                                        <div style="width: 65%; float: left;">
                                            <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup" style="display: none">

                                        <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">Admin: </div>
                                            <div style="width: 30%;" class="display_inline"></div>
                                            <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                            </div>
                                            <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                        </div>
                                        <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">ITLead: </div>
                                            <!-- ITLead Hours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <span>
                                                    <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                </span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- ITLead password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>

                                        </div>
                                        <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">User: </div>
                                            <!-- UserHours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <span>
                                                    <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- User password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- DueDate ends -->

                                <!-- Notes starts -->
                                <div class="div-table-col seq-notes">
                                    Notes
                                </div>
                                <!-- Notes ends -->

                                <!-- Nested row starts -->

                                <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                    <!-- Body section starts -->
                                    <div class="div-table-row" ng-repeat="TechTask in correctDataforAngularFrozenTaks(Task.SubSeqTasks)" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: TechTask.TaskId == BlinkTaskId, 'faded-row': !TechTask.AdminStatus || !TechTask.TechLeadStatus}" ng-class-even="'AlternateRow'">
                                        <!-- Sequence# starts -->
                                        <div class="div-table-col seq-number">
                                            <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                            <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                                <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                            <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                                <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                            </div>
                                        </div>
                                        <!-- Sequence# ends -->

                                        <!-- ID# and Designation starts -->
                                        <div class="div-table-col seq-taskid">
                                            <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                            {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                        </div>
                                        <!-- ID# and Designation ends -->

                                        <!-- Parent Task & SubTask Title starts -->
                                        <div class="div-table-col seq-tasktitle">
                                            {{ TechTask.ParentTaskTitle }}
                                        <br />
                                            {{ TechTask.Title }}
                                        </div>
                                        <!-- Parent Task & SubTask Title ends -->

                                        <!-- Status & Assigned To starts -->
                                        <div class="div-table-col seq-taskstatus">
                                            <select id="drpStatusSubsequence" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                                <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                                <option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>
                                                <option ng-selected="{{TechTask.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                                <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>
                                                <option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>
                                                <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                                <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                                <%} %>
                                                <option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>
                                                <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live</option>
                                                <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                                <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                                <%} %>
                                            </select>
                                        </div>
                                        <!-- Status & Assigned To ends -->


                                    </div>
                                    <!-- Body section ends -->

                                </div>

                                <!-- Nested row ends -->

                            </div>
                        </div>

                        <div class="text-center">
                            <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
                        </div>
                        <div ng-show="loader.loading" style="position: absolute; left: 50%; bottom: 10%">
                            Loading...
                <img src="../img/ajax-loader.gif" />
                        </div>

                    </div>

                    <div id="TechTaskFrozen">

                        <div id="tblTechSeqFrozen" class="div-table tableSeqTask">
                            <div class="div-table-row-header">
                                <div class="div-table-col seq-number">Sequence#</div>
                                <div class="div-table-col seq-taskid">
                                    ID#<div>Designation</div>
                                </div>
                                <div class="div-table-col seq-tasktitle">
                                    Parent Task
                                        <div>SubTask Title</div>
                                </div>
                                <div class="div-table-col seq-taskstatus">
                                    Status<div>Assigned To</div>
                                </div>
                                <div class="div-table-col seq-taskduedate">Due Date</div>
                                <div class="div-table-col seq-notes">Notes</div>
                            </div>

                            <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in FrozenTask" ng-class-odd="'FirstRow'" ng-class="{'yellowthickborder': Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onTechEnd()">

                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                    <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                        <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />


                                    </div>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{Task.TaskId}}" ng-class="{hide: Task.TaskId != HighLightTaskId}">
                                            <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" onchange="setDropDownChangedData(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                </div>
                                <!-- ID# and Designation ends -->

                                <!-- Parent Task & SubTask Title starts -->
                                <div class="div-table-col seq-tasktitle">
                                    {{ Task.ParentTaskTitle }}
                                        <br />
                                    {{ Task.Title }}
                                </div>
                                <!-- Parent Task & SubTask Title ends -->

                                <!-- Status & Assigned To starts -->
                                <div class="div-table-col seq-taskstatus">
                                    <select id="drpStatusSubsequence3" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        <option
                                            ng-repeat="item in DesignationAssignUsers"
                                            value="{{item.Id}}"
                                            label="{{item.FristName}}"
                                            class="{{item.CssClass}}">{{item.FristName}}
                                                
                                        </option>
                                    </select>

                                    <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                                </div>
                                <!-- Status & Assigned To ends -->

                                <!-- DueDate starts -->
                                <div class="div-table-col seq-taskduedate">
                                    <div class="seqapprovalBoxes">
                                        <div style="width: 65%; float: left;">
                                            <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                        <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">Admin: </div>
                                            <div style="width: 30%;" class="display_inline"></div>
                                            <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                            </div>
                                            <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                        </div>
                                        <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">ITLead: </div>
                                            <!-- ITLead Hours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <span>
                                                    <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                </span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- ITLead password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>

                                        </div>
                                        <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">User: </div>
                                            <!-- UserHours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <span>
                                                    <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- User password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- DueDate ends -->

                                <!-- Notes starts -->
                                <div class="div-table-col seq-notes">
                                    Notes
                                </div>
                                <!-- Notes ends -->

                            </div>

                        </div>






                        <div class="text-center">
                            <jgpager page="{{Techpage}}" pages-count="{{TechpagesCount}}" total-count="{{TechTotalRecords}}" search-func="getTechTasks(page)"></jgpager>
                        </div>


                        <%--  <!-- UI-Grid Starts Here -->

                            <div id="divUIGrid" ng-controller="UiGridController">
                                <div ui-grid="gridOptions" ui-grid-expandable class="grid"></div>
                            </div>

                            <!-- UI-Grid Ends here -->--%>
                    </div>

                </div>


            </div>

            <div id="taskNonFrozen" ng-controller="NonFrozenTaskController">
                <h2 class="itdashtitle">Non Frozen Tasks</h2>


                <div id="taskSequenceTabsNonFrozen">
                    <ul>
                        <li><a href="#StaffTaskNonFrozen">Staff Tasks</a></li>
                        <li><a href="#TechTaskNonFrozen">Tech Tasks</a></li>
                    </ul>
                    <div id="StaffTaskNonFrozen">
                        <div id="tblStaffSeqNonFrozen" class="div-table tableSeqTask">
                            <div class="div-table-row-header">
                                <div class="div-table-col seq-number">Sequence#</div>
                                <div class="div-table-col seq-taskid">
                                    ID#<div>Designation</div>
                                </div>
                                <div class="div-table-col seq-tasktitle">
                                    Parent Task
                                        <div>SubTask Title</div>
                                </div>
                                <div class="div-table-col seq-taskstatus">
                                    Status<div>Assigned To</div>
                                </div>
                                <div class="div-table-col seq-taskduedate">Due Date</div>
                                <div class="div-table-col seq-notes">Notes</div>
                            </div>
                            <!-- NG Repeat Div starts -->
                            <div ng-attr-id="divMasterTaskNonFrozen{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in NonFrozenTask" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onStaffEnd()">
                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClickNonFrozen{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabelNonFrozen{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                    <a id="A3" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                    <a id="A4" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}                                        
                                </div>
                                <!-- ID# and Designation ends -->

                                <!-- Parent Task & SubTask Title starts -->
                                <div class="div-table-col seq-tasktitle">
                                    {{ Task.ParentTaskTitle }}
                                        <br />
                                    {{ Task.Title }}
                                </div>
                                <!-- Parent Task & SubTask Title ends -->

                                <!-- Status & Assigned To starts -->
                                <div class="div-table-col seq-taskstatus">
                                    <select id="drpStatusSubsequence2" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                    <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>

                                    <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        <option
                                            ng-repeat="item in DesignationAssignUsers"
                                            value="{{item.Id}}"
                                            label="{{item.FristName}}"
                                            class="{{item.CssClass}}">{{item.FristName}}
                                                
                                        </option>
                                    </select>

                                    <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                                </div>
                                <!-- Status & Assigned To ends -->

                                <!-- DueDate starts -->
                                <div class="div-table-col seq-taskduedate">
                                    <div class="seqapprovalBoxes">
                                        <div style="width: 65%; float: left;">
                                            <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup" style="display: none">

                                        <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">Admin: </div>
                                            <div style="width: 30%;" class="display_inline"></div>
                                            <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                            </div>
                                            <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                        </div>
                                        <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">ITLead: </div>
                                            <!-- ITLead Hours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <span>
                                                    <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                </span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- ITLead password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>

                                        </div>
                                        <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">User: </div>
                                            <!-- UserHours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <span>
                                                    <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- User password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- DueDate ends -->

                                <!-- Notes starts -->
                                <div class="div-table-col seq-notes">
                                    Notes
                                </div>
                                <!-- Notes ends -->

                                <!-- Nested row starts -->

                                <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                    <!-- Body section starts -->
                                    <div class="div-table-row" ng-repeat="TechTask in correctDataforAngularFrozenTaks(Task.SubSeqTasks)" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: TechTask.TaskId == BlinkTaskId, 'faded-row': !TechTask.AdminStatus || !TechTask.TechLeadStatus}" ng-class-even="'AlternateRow'">
                                        <!-- Sequence# starts -->
                                        <div class="div-table-col seq-number">
                                            <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                            <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                                <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                            <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                                <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                            </div>
                                        </div>
                                        <!-- Sequence# ends -->

                                        <!-- ID# and Designation starts -->
                                        <div class="div-table-col seq-taskid">
                                            <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                            {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                        </div>
                                        <!-- ID# and Designation ends -->

                                        <!-- Parent Task & SubTask Title starts -->
                                        <div class="div-table-col seq-tasktitle">
                                            {{ TechTask.ParentTaskTitle }}
                                        <br />
                                            {{ TechTask.Title }}
                                        </div>
                                        <!-- Parent Task & SubTask Title ends -->

                                        <!-- Status & Assigned To starts -->
                                        <div class="div-table-col seq-taskstatus">
                                            <select id="drpStatusSubsequence" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                                <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                                <option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>
                                                <option ng-selected="{{TechTask.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                                <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>
                                                <option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>
                                                <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                                <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                                <%} %>
                                                <option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>
                                                <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live</option>
                                                <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                                <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                                <%} %>
                                            </select>
                                        </div>
                                        <!-- Status & Assigned To ends -->


                                    </div>
                                    <!-- Body section ends -->

                                </div>

                                <!-- Nested row ends -->

                            </div>
                        </div>

                        <div class="text-center">
                            <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
                        </div>
                        <div ng-show="loader.loading" style="position: absolute; left: 50%; bottom: 10%">
                            Loading...
                <img src="../img/ajax-loader.gif" />
                        </div>

                    </div>

                    <div id="TechTaskNonFrozen">

                        <div id="tblTechSeqNonFrozen" class="div-table tableSeqTask">
                            <div class="div-table-row-header">
                                <div class="div-table-col seq-number">Sequence#</div>
                                <div class="div-table-col seq-taskid">
                                    ID#<div>Designation</div>
                                </div>
                                <div class="div-table-col seq-tasktitle">
                                    Parent Task
                                        <div>SubTask Title</div>
                                </div>
                                <div class="div-table-col seq-taskstatus">
                                    Status<div>Assigned To</div>
                                </div>
                                <div class="div-table-col seq-taskduedate">Due Date</div>
                                <div class="div-table-col seq-notes">Notes</div>
                            </div>

                            <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in NonFrozenTask" ng-class-odd="'FirstRow'" ng-class="{'yellowthickborder': Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onTechEnd()">

                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                    <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                        <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />


                                    </div>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{Task.TaskId}}" ng-class="{hide: Task.TaskId != HighLightTaskId}">
                                            <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" onchange="setDropDownChangedData(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                </div>
                                <!-- ID# and Designation ends -->

                                <!-- Parent Task & SubTask Title starts -->
                                <div class="div-table-col seq-tasktitle">
                                    {{ Task.ParentTaskTitle }}
                                        <br />
                                    {{ Task.Title }}
                                </div>
                                <!-- Parent Task & SubTask Title ends -->

                                <!-- Status & Assigned To starts -->
                                <div class="div-table-col seq-taskstatus">
                                    <select id="drpStatusSubsequence3" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        <option
                                            ng-repeat="item in DesignationAssignUsers"
                                            value="{{item.Id}}"
                                            label="{{item.FristName}}"
                                            class="{{item.CssClass}}">{{item.FristName}}
                                                
                                        </option>
                                    </select>

                                    <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                                </div>
                                <!-- Status & Assigned To ends -->

                                <!-- DueDate starts -->
                                <div class="div-table-col seq-taskduedate">
                                    <div class="seqapprovalBoxes">
                                        <div style="width: 65%; float: left;">
                                            <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                        <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">Admin: </div>
                                            <div style="width: 30%;" class="display_inline"></div>
                                            <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                            </div>
                                            <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                        </div>
                                        <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">ITLead: </div>
                                            <!-- ITLead Hours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <span>
                                                    <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                </span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- ITLead password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>

                                        </div>
                                        <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                            <div style="width: 10%;" class="display_inline">User: </div>
                                            <!-- UserHours section -->
                                            <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <span>
                                                    <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                            </div>
                                            <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                            </div>
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                    data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                            </div>
                                            <!-- User password section -->
                                            <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                </a>
                                                <br />
                                                <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- DueDate ends -->

                                <!-- Notes starts -->
                                <div class="div-table-col seq-notes">
                                    Notes
                                </div>
                                <!-- Notes ends -->

                            </div>

                        </div>






                        <div class="text-center">
                            <jgpager page="{{Techpage}}" pages-count="{{TechpagesCount}}" total-count="{{TechTotalRecords}}" search-func="getTechTasks(page)"></jgpager>
                        </div>


                        <%--  <!-- UI-Grid Starts Here -->

                            <div id="divUIGrid" ng-controller="UiGridController">
                                <div ui-grid="gridOptions" ui-grid-expandable class="grid"></div>
                            </div>

                            <!-- UI-Grid Ends here -->--%>
                    </div>

                </div>


            </div>
        </div>
        
        <!-- -------------------- End DP -------------------  -->

        <%--</ContentTemplate>
        </asp:UpdatePanel>--%>
        <div id="taskSequence" ng-controller="TaskSequenceSearchController">
            <div class="loading" ng-show="loading === true"></div>
            
            <table class="table" runat="server" id="tableFilter">
                <tr>
                    <td width="300px"><h2 class="itdashtitle">In Progress, Assigned-Requested</h2></td>
                    <td>Designation</td>
                    <td>Users</td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:DropDownList ID="ddlDesigSeq" CssClass="textbox" runat="server" AutoPostBack="false"></asp:DropDownList>
                    </td>
                    <td>
                        <select id="ddlSelectUserInProTask" data-placeholder="Select Users" multiple style="width: 200px;" class="chosen-select-users">
                            <option selected value="">All</option>
                        </select><span id="lblLoading" style="display: none">Loading...</span>
                    </td>
                    <td>
                        <input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" style="margin-top: 14px" />
                    </td>

                </tr>
            </table>

            <div id="taskSequenceTabs">
                <ul>
                    <li><a href="#StaffTask">Staff Tasks</a></li>
                    <li><a href="#TechTask">Tech Tasks</a></li>
                </ul>
                <div id="StaffTask">
                    <div id="tblStaffSeq" class="div-table tableSeqTask">

                        <!-- NG Repeat Div starts -->
                        <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in Tasks" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onStaffEnd()">
                            <!-- Sequence# starts -->
                            <div class="div-table-col seq-number">
                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                    <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                <a id="seqArrowUp" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                <a id="seqArrowDown" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                            </div>
                            <!-- Sequence# ends -->

                            <!-- ID# and Designation starts -->
                            <div class="div-table-col seq-taskid">
                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                {{getDesignationString(Task.TaskDesignation)}}                                        
                            </div>
                            <!-- ID# and Designation ends -->

                            <!-- Parent Task & SubTask Title starts -->
                            <div class="div-table-col seq-tasktitle">
                                {{ Task.ParentTaskTitle }}
                                        <br />
                                {{ Task.Title }}
                            </div>
                            <!-- Parent Task & SubTask Title ends -->

                            <!-- Status & Assigned To starts -->
                            <div class="div-table-col seq-taskstatus">
                                <select id="drpStatusSubsequence2" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                    <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                    <option ng-selected="{{Task.Status == '2'}}" style="color:red"       value="2">Requested</option>
                                    <option ng-selected="{{Task.Status == '3'}}" style="color:lawngreen" value="3">Assigned</option>
                                    <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                    <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                    <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                    <%} %>
                                    <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                    <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                    <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                    <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                    <%} %>
                                </select>
                                <br />
                                <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>

                                <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                    <option
                                        ng-repeat="item in DesignationAssignUsers"
                                        value="{{item.Id}}"
                                        label="{{item.FristName}}"
                                        class="{{item.CssClass}}">{{item.FristName}}
                                                
                                    </option>
                                </select>

                                <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                            </div>
                            <!-- Status & Assigned To ends -->

                            <!-- DueDate starts -->
                            <div class="div-table-col seq-taskduedate">
                                <div class="seqapprovalBoxes">
                                    <div style="width: 65%; float: left;">
                                        <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                        <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                        <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                        <br />
                                        <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                        <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                        <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                    </div>
                                    <div style="width: 30%; float: right;">
                                        <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                        <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                    </div>
                                </div>

                                <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup" style="display: none">

                                    <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">Admin: </div>
                                        <div style="width: 30%;" class="display_inline"></div>
                                        <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                        </div>
                                        <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                            <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                    </div>
                                    <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">ITLead: </div>
                                        <!-- ITLead Hours section -->
                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <span>
                                                <label>{{Task.ITLeadHours}}</label>Hour(s)
                                            </span>
                                        </div>
                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                        </div>
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                        <!-- ITLead password section -->
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                        </div>

                                    </div>
                                    <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">User: </div>
                                        <!-- UserHours section -->
                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                            <span>
                                                <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                        </div>
                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                        </div>
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                            <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                        <!-- User password section -->
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- DueDate ends -->

                            <!-- Notes starts -->
                            <div class="div-table-col seq-notes">
                                Notes
                            </div>
                            <!-- Notes ends -->

                            <!-- Nested row starts -->

                            <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                <!-- Body section starts -->
                                <div class="div-table-row" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: TechTask.TaskId == BlinkTaskId, 'faded-row': !TechTask.AdminStatus || !TechTask.TechLeadStatus}" ng-class-even="'AlternateRow'">
                                    <!-- Sequence# starts -->
                                    <div class="div-table-col seq-number">
                                        <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                        <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                            <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                        <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                            <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                        </div>
                                    </div>
                                    <!-- Sequence# ends -->

                                    <!-- ID# and Designation starts -->
                                    <div class="div-table-col seq-taskid">
                                        <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                        {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                    </div>
                                    <!-- ID# and Designation ends -->

                                    <!-- Parent Task & SubTask Title starts -->
                                    <div class="div-table-col seq-tasktitle">
                                        {{ TechTask.ParentTaskTitle }}
                                        <br />
                                        {{ TechTask.Title }}
                                    </div>
                                    <!-- Parent Task & SubTask Title ends -->

                                    <!-- Status & Assigned To starts -->
                                    <div class="div-table-col seq-taskstatus">
                                        <select id="drpStatusSubsequence" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                            <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                            <option ng-selected="{{TechTask.Status == '2'}}" style="color:red"       value="2">Requested</option>
                                            <option ng-selected="{{TechTask.Status == '3'}}" style="color:lawngreen" value="3">Assigned</option>
                                            <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>
                                            <option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>
                                            <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                            <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                            <%} %>
                                            <option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>
                                            <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live</option>
                                            <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                            <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                            <%} %>
                                        </select>
                                    </div>
                                    <!-- Status & Assigned To ends -->


                                </div>
                                <!-- Body section ends -->

                            </div>

                            <!-- Nested row ends -->

                        </div>
                    </div>

                    <div class="text-center">
                        <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
                    </div>
                    <div ng-show="loader.loading" style="position: absolute; left: 50%; bottom: 10%">
                        Loading...
                <img src="../img/ajax-loader.gif" />
                    </div>

                </div>

                <div id="TechTask">

                    <div id="tblTechSeq" class="div-table tableSeqTask">
                        <div class="div-table-row-header">
                            <div class="div-table-col seq-number">Sequence#</div>
                            <div class="div-table-col seq-taskid">
                                ID#<div>Designation</div>
                            </div>
                            <div class="div-table-col seq-tasktitle">
                                Parent Task
                                        <div>SubTask Title</div>
                            </div>
                            <div class="div-table-col seq-taskstatus">
                                Status<div>Assigned To</div>
                            </div>
                            <div class="div-table-col seq-taskduedate">Due Date</div>
                            <div class="div-table-col seq-notes">Notes</div>
                        </div>

                        <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in TechTasks" ng-class-odd="'FirstRow'" ng-class="{'yellowthickborder': Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onTechEnd()">

                            <!-- Sequence# starts -->
                            <div class="div-table-col seq-number">
                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                    <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                    <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />


                                </div>
                            </div>
                            <!-- Sequence# ends -->

                            <!-- ID# and Designation starts -->
                            <div class="div-table-col seq-taskid">
                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                {{getDesignationString(Task.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{Task.TaskId}}" ng-class="{hide: Task.TaskId != HighLightTaskId}">
                                            <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" onchange="setDropDownChangedData(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                            </div>
                            <!-- ID# and Designation ends -->

                            <!-- Parent Task & SubTask Title starts -->
                            <div class="div-table-col seq-tasktitle">
                                {{ Task.ParentTaskTitle }}
                                        <br />
                                {{ Task.Title }}
                            </div>
                            <!-- Parent Task & SubTask Title ends -->

                            <!-- Status & Assigned To starts -->
                            <div class="div-table-col seq-taskstatus">
                                <select id="drpStatusSubsequence3" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                    <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                    <option ng-selected="{{Task.Status == '2'}}" style="color:red"      value="2">Requested</option>
                                    <option ng-selected="{{Task.Status == '3'}}" style="color:lawngreen" value="3">Assigned</option>
                                    <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                    <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                    <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                    <%} %>
                                    <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                    <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                    <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                    <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                    <%} %>
                                </select>
                                <br />
                                <select <%=!IsSuperUser?"disabled":""%> id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                    <option
                                        ng-repeat="item in DesignationAssignUsers"
                                        value="{{item.Id}}"
                                        label="{{item.FristName}}"
                                        class="{{item.CssClass}}">{{item.FristName}}
                                                
                                    </option>
                                </select>

                                <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                            </div>
                            <!-- Status & Assigned To ends -->

                            <!-- DueDate starts -->
                            <div class="div-table-col seq-taskduedate">
                                <div class="seqapprovalBoxes">
                                    <div style="width: 65%; float: left;">
                                        <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                        <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                        <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                        <br />
                                        <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                        <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                        <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                    </div>
                                    <div style="width: 30%; float: right;">
                                        <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                        <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                    </div>
                                </div>

                                <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                    <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">Admin: </div>
                                        <div style="width: 30%;" class="display_inline"></div>
                                        <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                        </div>
                                        <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                            <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                    </div>
                                    <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">ITLead: </div>
                                        <!-- ITLead Hours section -->
                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <span>
                                                <label>{{Task.ITLeadHours}}</label>Hour(s)
                                            </span>
                                        </div>
                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                        </div>
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                        <!-- ITLead password section -->
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                        </div>

                                    </div>
                                    <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                        <div style="width: 10%;" class="display_inline">User: </div>
                                        <!-- UserHours section -->
                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                            <span>
                                                <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                        </div>
                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                        </div>
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                            <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                        </div>
                                        <!-- User password section -->
                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                            </a>
                                            <br />
                                            <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- DueDate ends -->

                            <!-- Notes starts -->
                            <div class="div-table-col seq-notes">
                                Notes
                            </div>
                            <!-- Notes ends -->

                        </div>

                    </div>






                    <div class="text-center">
                        <jgpager page="{{Techpage}}" pages-count="{{TechpagesCount}}" total-count="{{TechTotalRecords}}" search-func="getTechTasks(page)"></jgpager>
                    </div>


                    <%--  <!-- UI-Grid Starts Here -->

                            <div id="divUIGrid" ng-controller="UiGridController">
                                <div ui-grid="gridOptions" ui-grid-expandable class="grid"></div>
                            </div>

                            <!-- UI-Grid Ends here -->--%>
                </div>

            </div>


        </div>

        <h2></h2>
        <div id="ContentPlaceHolder1_upClosedTask" >


            <table width="100%">
                <tbody>
                    <tr>
                        <td width="300px" align="left">
                            <h2 class="itdashtitle">Commits, Closed-Billed</h2>
                        </td>
                        <td>Designation</td>
                        <td>Users</td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>

                            <select data-placeholder="Select Designation" class="chosen-select-multi" multiple style="width: 200px;" id="ddlDesigClosedTask" runat="server">
                                <option selected value="">All</option>
                                <option value="1">Admin</option>
                                <option value="2">Jr. Sales</option>
                                <option value="3">Jr Project Manager</option>
                                <option value="4">Office Manager</option>
                                <option value="5">Recruiter</option>
                                <option value="6">Sales Manager</option>
                                <option value="7">Sr. Sales</option>
                                <option value="8">IT - Network Admin</option>
                                <option value="9">IT - Jr .Net Developer</option>
                                <option value="10">IT - Sr .Net Developer</option>
                                <option value="11">IT - Android Developer</option>
                                <option value="12">IT - Sr. PHP Developer</option>
                                <option value="13">IT – JR SEO/Backlinking/Content</option>
                                <option value="14">Installer - Helper</option>
                                <option value="15">Installer - Journeyman</option>
                                <option value="16">Installer - Mechanic</option>
                                <option value="17">Installer - Lead mechanic</option>
                                <option value="18">Installer - Foreman</option>
                                <option value="19">Commercial Only</option>
                                <option value="20">SubContractor</option>
                                <option value="22">Admin-Sales</option>
                                <option value="23">Admin Recruiter</option>
                                <option value="24">IT - Senior QA</option>
                                <option value="25">IT - Junior QA</option>
                                <option value="26">IT - Jr. PHP Developer</option>
                                <option value="27">IT – Sr SEO Developer</option>
                            </select>
                        </td>
                        <td>
                            <select id="ddlSelectUserClosedTask" data-placeholder="Select Users" multiple style="width: 250px;">
                                <option selected value="">All</option>
                            </select><span id="lblLoadingClosedTask" style="display: none">Loading...</span>
                        </td>
                        <td><input runat="server" id="txtSearchClosedTasks" maxlength="15" class="textbox ui-autocomplete-input" placeholder="search users" autocomplete="off" type="text"></td>
                        <td>
                            Number of Records: 
                                <select id="drpPageSizeClosedTasks">
                                    <option value="10">10</option>
                                    <option selected="selected" value="20">20</option>
                                    <option value="30">30</option>
                                    <option value="40">40</option>
                                    <option value="50">50</option>

                                </select>
                        </td>
                    </tr>
                </tbody>
            </table>

            <span id="ContentPlaceHolder1_Label1"></span>
            <div id="dibClosedTask" ng-controller="ClosedTaskController">
                <table class="table dashboard" rules="all" enablesorting="true" id="ContentPlaceHolder1_grdTaskClosed" style="background-color: White; width: 100%; border-collapse: collapse;" cellspacing="0" cellpadding="0" border="1">
                    <thead>
                        <tr class="trHeader " style="color: White;">
                            <th scope="col" style="width: 100px;" align="center">Assigned To</th>
                            <th scope="col" style="width: 100px;" align="center">Sub Task ID#</th>
                            <th scope="col" style="width: 300px;" align="center">Sub Task</th>
                            <th scope="col" style="width: 120px;" align="center">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-class="{lightgray : item.Status==='7', green: item.Status==='13', gray: item.Status==='9'}" data-ng-repeat="item in ClosedTask">
                            <td style="width: 100px;" valign="middle" align="center">
                                <span id="ContentPlaceHolder1_grdTaskClosed_lblAssignedUser_0">{{item.Assigneduser}}</span>
                            </td>
                            <td style="width: 100px;" valign="middle" align="center">
                                <a id="ContentPlaceHolder1_grdTaskClosed_lnkInstallId_0" class="context-menu" data-highlighter="{{item.TaskId}}" parentdata-highlighter="{{item.MainParentId}}" href="<%=System.Configuration.ConfigurationManager.AppSettings["UrlToReplaceForTemplates"]%>Sr_App/TaskGenerator.aspx?TaskId={{item.MainParentId}}&hstid={{item.TaskId}}" target="_blank" style="color: Blue;">{{item.InstallId}}</a>
                            </td>
                            <td style="width: 300px;" valign="middle" align="justify">
                                <span id="ContentPlaceHolder1_grdTaskClosed_lblDesc_0">{{item.Title}}</span>
                            </td>
                            <td style="width: 120px;" valign="middle" align="center">
                                <select id="drpStatusClosed" onchange="changeTaskStatusClosed(this);" data-highlighter="{{item.TaskId}}">
                                    <option ng-selected="{{item.Status == '0'}}" value="0">--All--</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{item.Status == '1'}}" value="1">Open</option>
                                    <option ng-selected="{{item.Status == '2'}}"style="color:red"       value="2">Requested</option>
                                    <option ng-selected="{{item.Status == '3'}}"style="color:lawngreen" value="3">Assigned</option>
                                    <option ng-selected="{{item.Status == '4'}}" value="4">InProgress</option>
                                    <option ng-selected="{{item.Status == '5'}}" value="5">Pending</option>
                                    <option ng-selected="{{item.Status == '6'}}" value="6">ReOpened</option>
                                    <option ng-selected="{{item.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{item.Status == '8'}}" value="8">SpecsInProgress</option>
                                    <option ng-selected="{{item.Status == '10'}}" value="10">Finished</option>
                                    <%} %>
                                    <option ng-selected="{{item.Status == '11'}}" value="11">Test</option>
                                    <option ng-selected="{{item.Status == '12'}}" value="12">Live</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{item.Status == '14'}}" value="14">Billed</option>
                                    <option ng-selected="{{item.Status == '9'}}" value="9">Deleted</option>
                                    <%} %>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div ng-show="loaderClosedTask.loading">
                    Loading...
                    <img src="../img/ajax-loader.gif" />
                </div>
                <div class="text-center" style="float: right">
                    <jgpager page="{{pageClosedTask}}" pages-count="{{pagesCountClosedTask}}" total-count="{{TotalRecordsClosedTask}}" search-func="getClosedTasks(page)"></jgpager>
                </div>
            </div>
        </div>

    </div>
    <div id="HighLightedTask" class="modal">
        <iframe id="ifrmTask" style="height: 100%; width: 100%; overflow: auto;"></iframe>
    </div>

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../Scripts/angular.min.js"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>    
    <script src="../js/angular/scripts/TaskSequence.js"></script>    
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    
    <script src="../js/angular/scripts/ClosedTasls.js"></script>    
    <script type="text/javascript">
        var ddlDesigSeqClientIDFrozenTasks = "";
        function changeTaskStatusClosed(Task) {
            var StatusId = Task.value;
            var TaskId = Task.getAttribute('data-highlighter');
            var data = { intTaskId: TaskId, TaskStatus: StatusId };
            $.ajax({
                type: "POST",
                url: url + "SetTaskStatus",
                data: data,
                success: function (result) {
                    alert("Task Status Changed.");
                    ShowAllClosedTasksDashBoard("", 0, pageSize);
                    ShowTaskSequenceDashBoard($('#' + ddlDesigSeqClientID).find('option:selected').val(), 0);
                },
                error: function (errorThrown) {
                    alert("Failed!!!");
                }
            });
        }

        function pageLoad(sender, args) {
            $(".gv_drp_Task_Status").each(function (index) {
                //$(this).unbind('click').click(function () {
                //});
                $(this).bind("change", function () {
                    var taskId = $(this).attr("data-task-id");
                    var ddlValue = $(this).val();
                    updateTaskStatus(taskId, ddlValue);
                    return false;
                });
            });
            //debugger;
            ddlDesigSeqClientID = '<%=ddlDesigSeq.ClientID%>'
            ddlDesigSeqClientIDFrozenTasks = '<%=ddlDesigIdsFrozenTasks.ClientID%>'
            ChosenDropDown();
        }
        var desIds = "";
        var pageSize = 20;
        $(document).ready(function () {
            $(".chosen-select-multi").chosen();
            $(".chosen-select-users").chosen({ no_results_text: "No users found!" });
            $("#ddlSelectUserClosedTask").chosen({ no_results_text: "No users found!" });
            $("#ddlSelectFrozenTask").chosen();
            
            //ddlSelectFrozenTask,lblLoadingFrozen

            //InProAssigned
            $(".chosen-select-users").change(function () {
                ShowTaskSequenceDashBoard($('#' + ddlDesigSeqClientID).val(), $(".chosen-select-users").val().join());
            });

            //Frozen/NonFrozen
            $("#ddlSelectFrozenTask").change(function () {
                ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).val(), $("#ddlSelectFrozenTask").val().join());
                ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), $("#ddlSelectFrozenTask").val().join());
            });

            //Closed Tasks
            $("#ddlSelectUserClosedTask").change(function () {                

                desIds = $(".chosen-select-multi").val();
                if (desIds == undefined) { desIds = ''; }
                ShowAllClosedTasksDashBoard(desIds.join(), $('#ddlSelectUserClosedTask').val().join(), pageSize);
            });

            $(".chosen-select-multi").change(function () {
                debugger;
                fillUsersClosedTasks('<%=ddlDesigClosedTask.ClientID%>', 'ddlSelectUserClosedTask', 'lblLoadingClosedTask');
                desIds = $(".chosen-select-multi").val();
                if (desIds == undefined) { desIds = ''; }
                ShowAllClosedTasksDashBoard(desIds.join(), $('#ddlSelectUserClosedTask').val().join(), pageSize);
            });

            //set page size
            $('#drpPageSizeClosedTasks').change(function () {
                desIds = $(".chosen-select-multi").val();
                if (desIds == undefined) { desIds = ''; }
                pageSize = $('#drpPageSizeClosedTasks').val();
                ShowAllClosedTasksDashBoard(desIds.join(), $('#ddlSelectUserClosedTask').val().join(), pageSize)
            });

            //fill users
            fillUsers(ddlDesigSeqClientID, 'ddlSelectUserInProTask', 'lblLoading');
            fillUsersClosedTasks('<%=ddlDesigClosedTask.ClientID%>', 'ddlSelectUserClosedTask', 'lblLoadingClosedTask');
            fillUsers('<%=ddlDesigIdsFrozenTasks.ClientID%>', 'ddlSelectFrozenTask', 'lblLoadingFrozen');
        });

        $(window).load(function () {
            sequenceScope.ForDashboard = true;
            ShowTaskSequenceDashBoard($('#' + ddlDesigSeqClientID).find('option:selected').val(), 0);
            $('#' + ddlDesigSeqClientID).change(function (e) {
                ShowTaskSequenceDashBoard($('#' + ddlDesigSeqClientID).find('option:selected').val(), 0);
                fillUsers(ddlDesigSeqClientID, 'ddlSelectUserInProTask', 'lblLoading');
            });

            // And now fire change event when the DOM is ready
            $('#' + ddlDesigSeqClientID).trigger('change');


            //Load Closed Tasks
            desIds = $(".chosen-select-multi").val();
            if (desIds == undefined) { desIds = ''; }
            ShowAllClosedTasksDashBoard("", 0, pageSize);

            //load Frozen/Non Tasks
            //ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
            //ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);

            $('#' + ddlDesigSeqClientIDFrozenTasks).change(function (e) {
                fillUsers(ddlDesigSeqClientIDFrozenTasks, 'ddlSelectFrozenTask', 'lblLoadingFrozen');
                ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
            });

        });

        function fillUsers(selector, fillDDL, loader) {
            debugger;
            var did = $('#' + selector).val();
            var options = $('#' + fillDDL);
            $('#ddlSelectFrozenTask_chosen').css({ "width": "300px" });

            $('.chzn-drop').css({ "width": "300px" });

            //$("#" + fillDDL).prop('disabled', true);
            $('#' + loader).show();
            $.ajax({
                type: "POST",
                url: "ajaxcalls.aspx/GetUsersByDesignationId",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ designationId: did }),
                success: function (data) {
                    options.empty();
                    options.append($("<option selected='selected' />").val('0').text('All'));
                    // Handle 'no match' indicated by [ "" ] response
                    if (data.d) {
                        debugger;
                        var result = [];
                        result = JSON.parse(data.d);                        
                        $.each(result, function () {                            
                            options.append($("<option />").val(this.Id).text(this.FristName));
                        });
                        //$("#" + fillDDL).prop('disabled', false);
                    }
                    options.trigger("chosen:updated");
                    $('#' + loader).hide();
                    $('#ddlSelectFrozenTask_chosen').css({ "width": "300px" });
                    // remove loading spinner image.                                
                }
            });
        }

        function fillUsersClosedTasks(selector, fillDDL, loader) {
            debugger;
            var did = $('#' + selector).val().join();
            var options = $('#' + fillDDL);

            //$("#" + fillDDL).prop('disabled', true);
            $('#' + loader).show();
            $.ajax({
                type: "POST",
                url: "ajaxcalls.aspx/GetUsersByDesignationId",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ designationId: did }),
                success: function (data) {
                    options.empty();
                    options.append($("<option selected='selected' />").val('0').text('All'));
                    // Handle 'no match' indicated by [ "" ] response
                    if (data.d) {
                        debugger;
                        var result = [];
                        result = JSON.parse(data.d);
                        $.each(result, function () {
                            options.append($("<option />").val(this.Id).text(this.FristName));
                        });
                        //$("#" + fillDDL).prop('disabled', false);
                    }
                    options.trigger("chosen:updated");
                    $('#' + loader).hide();
                    // remove loading spinner image.                                
                }
            });
        }

        function updateTaskStatus(id, value) {
            ShowAjaxLoader();
            var postData = {
                intTaskId: id,
                TaskStatus: value
            };

            $.ajax
                (
                {
                    url: '../WebServices/JGWebService.asmx/SetTaskStatus',
                    contentType: 'application/json; charset=utf-8;',
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(postData),
                    asynch: false,
                    success: function (data) {
                        HideAjaxLoader();
                        alert('Task Status Updated successfully.');
                    },
                    error: function (a, b, c) {
                        HideAjaxLoader();
                    }
                }
                );
        }

       <%-- function checkFrozenDesignations(oSrc, args) {
            args.IsValid = ($("#<%= ddlFrozenUserDesignation.ClientID%> input:checked").length > 0);
        }--%>

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Initialize();
        });

        function _updateQStringParam(uri, key, value, Mainkey, MainValue) {
            var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
            var separator = uri.indexOf('?') !== -1 ? "&" : "?";

            if (uri.match(re)) {
                return uri.replace(re, '$1' + key + "=" + value + '$2');
            }
            else {
                uri = uri.replace("ITDashboard", "TaskGenerator");
                return uri + separator + Mainkey + "=" + MainValue + '&' + key + "=" + value;
            }
        }

        $(document).ready(function () {
            checkNShowTaskPopup();
            Initialize();
        });


        function Initialize() {
            SetInProTaskAutoSuggestion();
            SetInProTaskAutoSuggestionUI();

            SetClosedTaskAutoSuggestion();
            SetClosedTaskAutoSuggestionUI();

            SetFrozenTaskAutoSuggestionUI();

            SetFrozenTaskAutoSuggestion();

            SetApprovalUI();
            SetTaskCounterPopup();
            checkDropdown();

            ChosenDropDown();
            setSelectedUsersLink();

            $(".context-menu").bind("contextmenu", function () {
                var urltoCopy = _updateQStringParam(window.location.href, "hstid", $(this).attr('data-highlighter'), "TaskId", $(this).attr('parentdata-highlighter'));
                copyToClipboard(urltoCopy);
                return false;
            });
        }

        //$(".context-menu").bind("contextmenu", function () {
        //    debugger;
        //    var urltoCopy = updateQueryStringParameter(window.location.href, "hstid", $(this).attr('data-highlighter'), "TaskId", $(this).attr('parentdata-highlighter'));
        //    copyToClipboard(urltoCopy);
        //    return false;
        //});
        function checkNShowTaskPopup() {

            var TaskId = getUrlVars()["TaskId"];
            if (TaskId) {
                var iframeURL = '<%=JG_Prospect.Common.JGApplicationInfo.GetSiteURL()%>' + '/Sr_App/TaskGenerator.aspx?' + window.location.href.slice(window.location.href.indexOf('?') + 1);
                console.log(iframeURL);
                $('#ifrmTask').attr("Src", iframeURL);

                var $dialog = $('#HighLightedTask').dialog({
                    autoOpen: true,
                    modal: false,
                    height: 500,
                    width: 800
                });

            }
        }

        // Read a page's GET URL variables and return them as an associative array.
        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        }

        function setSelectedUsersLink() {
            //debugger;
            $('.search-choice').each(function () {
                var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
                //console.log(itemIndex);
                if (itemIndex) {
                    //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                    var selectoptionid = '#' + $(this).parent('.chosen-choices').parent('.chosen-container').attr('id').replace("_chosen", "") + ' option';
                    var chspan = $(this).children('span');
                    if (chspan) {
                        chspan.html('<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + chspan.text() + '</a>');
                        chspan.bind("click", "a", function () {
                            window.open($(this).children("a").attr("href"), "_blank", "", false);
                        });
                    }
                }
            });

            $('.chosen-select').bind('change', function (evt, params) {
                console.log(evt);
                console.log(params);


            });
        }

        function SetSeqApprovalUI() {
            //alert("called");
            $('.seqapprovalBoxes').each(function () {
                var approvaldialog = $($(this).next('div.seqapprovepopup'));

                //console.log(approvaldialog);

                approvaldialog.addClass("hide");

                approvaldialog.dialog({
                    width: 400,
                    show: 'slide',
                    hide: 'slide',
                    autoOpen: false
                });

                $(this).click(function () {
                    approvaldialog.removeClass("hide");
                    approvaldialog.dialog('open');
                });
            });
        }

        function SetApprovalUI() {
            //debugger;
            $('.approvalBoxes').each(function () {
                var approvaldialog = $($(this).next('.approvepopup'));
                approvaldialog.dialog({
                    width: 400,
                    show: 'slide',
                    hide: 'slide',
                    autoOpen: false
                });

                $(this).click(function () {
                    approvaldialog.dialog('open');
                });
            });
        }

        function SetFrozenTaskAutoSuggestionUI() {
            //debugger;
            console.log("SetFrozenTaskAutoSuggestionUI called");
            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                        currentCategory = "";
                    $.each(items, function (index, item) {
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });

                }
            });
        }


        function SetClosedTaskAutoSuggestion() {
            //debugger;
            console.log("SetClosedTaskAutoSuggestion called");
            $('#<%= txtSearchClosedTasks.ClientID %>').catcomplete({
                 delay: 500,
                 source: function (request, response) {

                     if (request.term == "") {
                         desIds = $(".chosen-select-multi").val();
                         if (desIds == undefined) { desIds = ''; }

                         ShowAllClosedTasksDashBoard(desIds.join(), 0, pageSize);
                         $('#<%= txtSearchClosedTasks.ClientID %>').removeClass("ui-autocomplete-loading");
                        return false;
                    }


                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetTaskUsersForDashBoard",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ searchterm: request.term }),
                        success: function (data) {
                            //debugger;
                            // Handle 'no match' indicated by [ "" ] response
                            if (data.d) {
                                ////debugger;
                                response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                            }
                            // remove loading spinner image.                                
                            $('#<%= txtSearchClosedTasks.ClientID %>').removeClass("ui-autocomplete-loading");
                        }
                    });
                },
                minLength: 0,
                select: function (event, ui) {
                    debugger;
                    //alert(ui.item.value);
                    //alert(ui.item.id);
                    $('#<%= txtSearchClosedTasks.ClientID %>').val(ui.item.value);
                    //TriggerSearch();
                    desIds = $(".chosen-select-multi").val();
                    if (desIds == undefined) { desIds = ''; }
                    ShowAllClosedTasksDashBoard("", ui.item.id, pageSize);
                }
             });
        }

        function SetClosedTaskAutoSuggestionUI() {
            //debugger;
            console.log("SetClosedTaskAutoSuggestionUI called");
            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    //debugger;
                    var that = this,
                        currentCategory = "";
                    $.each(items, function (index, item) {
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });

                }
            });
        }


        function SetFrozenTaskAutoSuggestion () {

            $("#txtSearchUserFrozen").catcomplete({
                delay: 500,
                source: function (request, response) {

                    if (request.term == "") {
                        ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                        ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                        $("#txtSearchUserFrozen").removeClass("ui-autocomplete-loading");
                        return false;
                    }

                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetTaskUsersForDashBoard",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ searchterm: request.term }),
                        success: function (data) {
                            // Handle 'no match' indicated by [ "" ] response
                            if (data.d) {
                                ////debugger;
                                response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                            }
                            // remove loading spinner image.                                
                            $("#txtSearchUserFrozen").removeClass("ui-autocomplete-loading");
                        }
                    });
                },
                minLength: 0,
                select: function (event, ui) {
                    //debugger;
                    //alert(ui.item.value);
                    //alert(ui.item.id);
                    $("#txtSearchUserFrozen").val(ui.item.value);
                    //TriggerSearch();
                    ShowFrozenTaskSequenceDashBoard(0, ui.item.id);
                    ShowNonFrozenTaskSequenceDashBoard(0, ui.item.id);
                }
            });
        }

        function SetInProTaskAutoSuggestion() {

            $("#txtSearchUser").catcomplete({
                delay: 500,
                source: function (request, response) {

                    if (request.term == "") {
                        ShowTaskSequenceDashBoard($('#' + ddlDesigSeqClientID).find('option:selected').val(), 0);
                        $("#txtSearchUser").removeClass("ui-autocomplete-loading");
                        return false;
                    }

                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetTaskUsersForDashBoard",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ searchterm: request.term }),
                        success: function (data) {
                            // Handle 'no match' indicated by [ "" ] response
                            if (data.d) {
                                ////debugger;
                                response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                            }
                            // remove loading spinner image.                                
                            $("#txtSearchUser").removeClass("ui-autocomplete-loading");
                        }
                    });
                },
                minLength: 0,
                select: function (event, ui) {
                    //debugger;
                    //alert(ui.item.value);
                    //alert(ui.item.id);
                    $("#txtSearchUser").val(ui.item.value);
                    //TriggerSearch();
                    ShowTaskSequenceDashBoard(0, ui.item.id);
                }
            });
        }

        function SetInProTaskAutoSuggestionUI() {
            //debugger;
            console.log("SetInProTaskAutoSuggestionUI called");
            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                        currentCategory = "";
                    $.each(items, function (index, item) {
                        //debugger;
                        var li;
                        if (item.Category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                            currentCategory = item.Category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.Category) {
                            li.attr("aria-label", item.Category + " : " + item.label);
                        }
                    });
                }
            });
        }


        function SetTaskCounterPopup() {

            $('#'+'<%=lblNonFrozenTaskCounter.ClientID%>').click(function () {
                debugger;
                ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
            });
            $('#'+'<%=lblFrozenTaskCounter.ClientID%>').click(function () {
                debugger;
                ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
            });
        }

        function checkDropdown() {
         <%--   $('#<%=ddlDesigFrozen.ClientID %> [type="checkbox"]').each(function () {
                $(this).click(function () { console.log($(this).prop('checked')); })
            });--%>
        }

        function FreezeTask(sender) {

            var $sender = $(sender);

            var adminCheckBox = $sender.attr('data-id');

            var strTaskId = $sender.attr('data-taskid');
            var strHoursId = $sender.attr('data-hours-id');
            var strPasswordId = $sender.attr('data-id');

            var $tr = $('div.approvepopup[data-taskid="' + strTaskId + '"]');
            var postData;
            var MethodToCall;

            if (adminCheckBox && adminCheckBox.includes("txtAdminPassword")) {
                postData = {
                    strTaskApprovalId: $tr.find('input[id*="hdnTaskApprovalId"]').val(),
                    strTaskId: strTaskId,
                    strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
                };
                MethodToCall = "AdminFreezeTask";
            }
            else {
                postData = {
                    strEstimatedHours: $tr.find('input[data-id="' + strHoursId + '"]').val(),
                    strTaskApprovalId: $tr.find('input[id*="hdnTaskApprovalId"]').val(),
                    strTaskId: strTaskId,
                    strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
                };
                MethodToCall = "FreezeTask";
            }


            CallJGWebService(MethodToCall, postData, OnFreezeTaskSuccess);

            function OnFreezeTaskSuccess(data) {
                if (data.d.Success) {
                    alert(data.d.Message);
                    HidePopup('.approvepopup')
                }
                else {
                    alert(data.d.Message);
                }
            }
        }

        function FreezeSeqTask(sender) {

            var $sender = $(sender);
            console.log(sender);
            var adminCheckBox = $sender.attr('data-id');
            console.log(adminCheckBox);
            var strTaskId = $sender.attr('data-taskid');
            var strHoursId = $sender.attr('data-hours-id');
            var strPasswordId = $sender.attr('data-id');

            var $tr = $('div.seqapprovepopup[data-taskid="' + strTaskId + '"]');
            var postData;
            var MethodToCall;

            if (adminCheckBox && adminCheckBox.includes("txtngstaffAdminPassword")) {
                alert('AdminFreezeTask');
                postData = {
                    strTaskApprovalId: '',
                    strTaskId: strTaskId,
                    strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
                };
                MethodToCall = "AdminFreezeTask";
            }
            else {
                postData = {
                    strEstimatedHours: $tr.find('input[data-id="' + strHoursId + '"]').val(),
                    strTaskApprovalId: '',
                    strTaskId: strTaskId,
                    strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
                };
                MethodToCall = "FreezeTask";
            }


            CallJGWebService(MethodToCall, postData, OnFreezeTaskSuccess);

            function OnFreezeTaskSuccess(data) {
                if (data.d.Success) {
                    alert(data.d.Message);
                    HidePopup('.seqapprovepopup');
                    sequenceScope.refreshTasks();
                }
                else {
                    alert(data.d.Message);
                }
            }
        }
    </script>
</asp:Content>