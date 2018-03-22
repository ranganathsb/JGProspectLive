<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="_UserGridPhonePopup.ascx.cs" Inherits="JG_Prospect.Controls._UserGridPhonePopup" %>
<%
    string baseUrl = HttpContext.Current.Request.Url.Scheme +
                        "://" + HttpContext.Current.Request.Url.Authority +
                        HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
%>

<div class="userlist-grid">
    <input type="hidden" id="PageIndex" value="0" />
    <table class="header-table">
        <thead>
            <tr>
                <th>
                    <span>User Status</span><span style="color: red">*</span></th>
                <th>
                    <span>Designation</span></th>
                <th>
                    <span>Added By</span></th>
                <th>
                    <span>Source</span></th>
                <th>
                    <span>Select Period</span></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="phoneTypes" style="display: none;">
                        <select>
                            <option value="0">--Select--</option>
                            <%
                                foreach (var item in dsPhoneType)
                                {
                            %><option value="<%=item.Key %>"><%=item.Value %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="employmentTypes" style="display: none;">
                        <select>
                            <option value="0">--Select--</option>
                            <%
                                foreach (var item in employmentTypes)
                                {
                            %><option value="<%=item.Key %>"><%=item.Value %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="user-status">
                        <select>
                            <option value="0">--All--</option>
                            <%
                                foreach (var item in userStatuses)
                                {
                            %><option value="<%=item.StatusValue %>"><%=item.Status %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="designationId">
                        <select>
                            <option value="0">--All--</option>
                            <%
                                foreach (var item in userDesignations)
                                {
                            %><option value="<%=item.Id %>"><%=item.DesignationName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="addedBy">
                        <select>
                            <option value="0">--All--</option>
                            <%
                                foreach (var item in userAddedBy)
                                {
                            %><option value="<%=item.UserId %>"><%=item.FormattedName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="source">
                        <select>
                            <option value="0">--All--</option>
                            <%
                                foreach (var item in sources)
                                {
                            %><option value="<%=item.Id %>"><%=item.Source %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td>
                    <input type="checkbox" value="all" name="period" /><span>All</span>
                    <input type="checkbox" value="all" name="period" /><span>1 Year</span>
                    <input type="checkbox" value="all" name="period" /><span>Quarter (3 months)</span>
                    <span>From :<span>*</span><input type="text" class="fromDate" />
                    </span>
                    <span>To :<span>*</span><input type="text" class="toDate" />
                    </span>
                    <input type="checkbox" value="all" name="period" /><span>1 Month</span>
                    <input type="checkbox" value="all" name="period" /><span>Two Weeks (Pay Period)</span>
                    <span>
                        <input type="text" />
                    </span>
                </td>
            </tr>
            <tr>
                <td colspan="4"></td>
                <td>
                    <input type="text" class="userKeyword" />
                    <input type="button" value="Search" class="search-user" onclick="searchUsers(this)" />
                </td>
            </tr>
        </tbody>
    </table>
    <table class="user-table">
        <thead>
            <tr>
                <td><span>Action<br />
                    Picture</span></td>
                <td><span>ID#<br />
                    Designation<br />
                    Fullname</span></td>
                <td><span>Status</span></td>
                <td><span>Source<br />
                    Added By<br />
                    Added On</span></td>
                <td><span>Email<br />
                    Phone Type - Phone</span></td>
                <td><span>Country-City-Zip<br />
                    Type-Apptitude Test %<br />
                    Resume</span></td>
                <td>
                    <div class="row">
                        <div>
                            UserID<br />
                            Date & Time
                        </div>
                        <div>
                            Note<br />
                            Status
                        </div>
                    </div>
                </td>
            </tr>
        </thead>
        <tbody id="SalesUserGrid" ng-app="JGApp" ng-controller="SalesUserController">
            <tr ng-repeat="User in UserList.Data">
                <td>
                    <div>
                        <img src="<%=baseUrl %>Employee/ProfilePictures/{{User.ProfilePic}}" />
                    </div>
                    <div><a href="" target="_blank">Edit</a></div>
                </td>
                <td>
                    <div><a target="_blank" href="<%=baseUrl %>Sr_App/ViewSalesUser.aspx?id={{User.Id}}">{{User.Id}}</a></div>
                    <div class="userDesignations" did="{{User.DesignationId}}" uid="{{User.Id}}"></div>
                    <div>{{User.FirstName}} {{User.LastName}}</div>
                </td>
                <td>
                    <div class="status" stid="{{User.Status}}" uid="{{User.Id}}"></div>
                </td>
                <td>{{User.Source}}
                    <br />
                    {{User.AddedBy}}-<a href="<%=baseUrl %>Sr_App/ViewSalesUser.aspx?id={{User.Id}}">{{User.AddedByInstallId}}</a>
                    <br />
                    {{User.AddedOnFormatted}} (EST)
                </td>
                <td>
                    <div class="userEmails">
                        <select>
                            <option data-ng-repeat="UserEmail in UserList.QData | filter: {UserId:User.Id}" value="{{UserEmail.Email}}">{{UserEmail.Email}}
                            </option>
                        </select>
                    </div>
                    <div class="small userPhones">
                        <select>
                            <option data-ng-repeat="UserPhone in UserList.RData | filter: {UserId:User.Id}" value="{{UserPhone.Phone}}">{{UserPhone.Phone}}
                            </option>
                        </select>
                    </div>
                    <div class="social" uid="{{User.Id}}">
                        <div class="small phoneTypes"></div>
                        <input type="text" class="phone" placeholder="Select Type" />
                        <input type="checkbox" />
                        <input type="button" value="Add" onclick="AddSocial(this)" />
                    </div>
                </td>
                <td>
                    <div>{{User.Country}}-{{User.City}}-{{Zip}}</div>
                    <div emptype="{{User.JobType}}" class="employmentTypes"></div>
                    <div class="resume">
                        <a title="{{User.ResumeFileSavedName}}" href="<%=baseUrl %>Employee/Resume/{{User.ResumeFileSavedName}}">{{User.ResumeFileSavedName}}</a>
                    </div>
                </td>
                <td>
                    <div class="notes-container" uid="7241" id="user-7241">
                        <table class="notes-table" cellspacing="0" cellpadding="0">
                            <tr uid="7241">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr uid="7241">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr uid="7241">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <div class="notes-inputs">
                        <div class="first-col">
                            <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this, '7241', '7241')">
                        </div>
                        <div class="second-col">
                            <textarea class="note-text textbox" id="txt-7241" data-tribute="true"></textarea>
                        </div>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="pagingWrapper">
        <div class="total-results">Total <span class="total-results-count"></span>Results</div>
        <div class="pager">
            <span class="first">« First</span> <span class="previous">Previous</span> <span class="numeric"></span><span class="next">Next</span> <span class="last">Last »</span>
        </div>
        <div class="pageInfo">
        </div>
    </div>
</div>
<div id="DivOfferMade" class="white_content" style="height: auto;">
    <div class="title">Offer Made Details</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Name:</div>
            <div class="fullname"></div>
        </div>
        <div class="row">
            <div>Designation:</div>
            <div class="designation"></div>
        </div>
        <div class="row">
            <div>Email<span class="mandatory">*</span>:</div>
            <div class="email">
                <input type="text" /></div>
        </div>
        <div class="row">
            <div>Password<span class="mandatory">*</span>:</div>
            <div class="password">
                <input type="password" /></div>
        </div>
        <div class="row">
            <div>Confirm Password<span class="mandatory">*</span>:</div>
            <div class="cnf-password">
                <input type="password" /></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save"  onclick="saveOfferMade(this)"/>&nbsp;<input type="button" value="Cancel" class="grey" onclick="closePopup()" />
            </div>
        </div>
    </div>
</div>
<div id="interviewDatelite" class="white_content" style="height: auto;">
    <div class="title">Interview Details</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Name:</div>
            <div class="fullname"></div>
        </div>
        <div class="row">
            <div>Date:</div>
            <div class="date">
                <input type="text" /></div>
        </div>
        <div class="row">
            <div>Time:</div>
            <div class="time">
                <select>
                    <option value="12:00 AM">12:00 AM</option>
                    <option value="12:30 AM">12:30 AM</option>
                    <option value="1:00 AM">1:00 AM</option>
                    <option value="1:30 AM">1:30 AM</option>
                    <option value="2:00 AM">2:00 AM</option>
                    <option value="2:30 AM">2:30 AM</option>
                    <option value="3:00 AM">3:00 AM</option>
                    <option value="3:30 AM">3:30 AM</option>
                    <option value="4:00 AM">4:00 AM</option>
                    <option value="4:30 AM">4:30 AM</option>
                    <option value="5:00 AM">5:00 AM</option>
                    <option value="5:30 AM">5:30 AM</option>
                    <option value="6:00 AM">6:00 AM</option>
                    <option value="6:30 AM">6:30 AM</option>
                    <option value="7:00 AM">7:00 AM</option>
                    <option value="7:30 AM">7:30 AM</option>
                    <option value="8:00 AM">8:00 AM</option>
                    <option value="8:30 AM">8:30 AM</option>
                    <option value="9:00 AM">9:00 AM</option>
                    <option value="9:30 AM">9:30 AM</option>
                    <option selected="selected" value="10:00 AM">10:00 AM</option>
                    <option value="10:30 AM">10:30 AM</option>
                    <option value="11:00 AM">11:00 AM</option>
                    <option value="11:30 AM">11:30 AM</option>
                    <option value="12:00 PM">12:00 PM</option>
                    <option value="12:30 PM">12:30 PM</option>
                    <option value="1:00 PM">1:00 PM</option>
                    <option value="1:30 PM">1:30 PM</option>
                    <option value="2:00 PM">2:00 PM</option>
                    <option value="2:30 PM">2:30 PM</option>
                    <option value="3:00 PM">3:00 PM</option>
                    <option value="3:30 PM">3:30 PM</option>
                    <option value="4:00 PM">4:00 PM</option>
                    <option value="4:30 PM">4:30 PM</option>
                    <option value="5:00 PM">5:00 PM</option>
                    <option value="5:30 PM">5:30 PM</option>
                    <option value="6:00 PM">6:00 PM</option>
                    <option value="6:30 PM">6:30 PM</option>
                    <option value="7:00 PM">7:00 PM</option>
                    <option value="7:30 PM">7:30 PM</option>
                    <option value="8:00 PM">8:00 PM</option>
                    <option value="8:30 PM">8:30 PM</option>
                    <option value="9:00 PM">9:00 PM</option>
                    <option value="9:30 PM">9:30 PM</option>
                    <option value="10:00 PM">10:00 PM</option>
                    <option value="10:30 PM">10:30 PM</option>
                    <option value="11:00 PM">11:00 PM</option>
                    <option value="11:30 PM">11:30 PM</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div>Recruiter:</div>
            <div class="recruiter"></div>
        </div>
        <div class="row">
            <div>Designation:</div>
            <div class="designation"></div>
        </div>
        <div class="row">
            <div>Task:</div>
            <div class="task"></div>
        </div>
        <div class="row">
            <div>Sub Task:</div>
            <div class="sub-task"></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="closePopup()" />
            </div>
        </div>
    </div>
</div>
<div id="light" class="white_content">
    <div class="title">Reason</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Reason:</div>
            <div class="reason">
                <textarea></textarea></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save" onclick="saveWithReason(this)" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="    closePopup()" />
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $('.userlist-grid .header-table select').chosen();
    paging.currentPage = 0;
    var Users;
    function searchUsers(sender) {
        Paging(sender);
    }

    function Paging(sender) {
        sequenceScopePhone.Paging(sender);
    }
    function AddSocial(sender) {
        var type = $(sender).parents('.social').find('select').val();
        var phone = $(sender).parents('.social').find('input.phone').val().trim();
        var primary = $(sender).parents('.social').find('input[type="checkbox"]').is(':checked');
        var uid = $(sender).parents('.social').attr('uid');
        if (type == '' || type == '0')
            return false;
        if (phone == '')
            return false;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/AddSocial',
            type: 'POST',
            data: '{userId:' + uid + ',type:' + type + ',phone:"' + phone + '",primary:' + primary + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('.search-user').trigger('click');
            }
        })
    }
    function setWatermark(sender) {
        var text = $(sender).find('option:selected').text();
        var value = $(sender).find('option:selected').val();
        if (value == '0')
            $(sender).parents('.social').find('input.phone').attr('placeholder', 'Select Type');
        else
            $(sender).parents('.social').find('input.phone').attr('placeholder', text);
    }
    function ChangeDesignation(sender) {
        var uid = $(sender).parents('.userDesignations').attr('uid');
        var did = $(sender).find('option:selected').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserDesignation',
            type: 'POST',
            data: '{userId:' + uid + ',designationId:' + did + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.userDesignations').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                $('.search-user').trigger('click');
            }
        })
    }
    function ChangeUserStatus(sender) {
        var oldStatus = $(sender).parents('.status').attr('stid');
        var uid = $(sender).parents('.status').attr('uid');
        var newStatus = $(sender).find('option:selected').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatus',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + newStatus + ',oldStatus:' + oldStatus + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.status').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                if (data.Object != '' && data.Object != undefined) {
                    window[data.Object](data.Message);
                } else {
                    $('.search-user').trigger('click');
                }
            }
        });
    }
    function RecenterPopup() {
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.white_content').width();
        var sH = $(window).height();
        var pH = $('.white_content').height();
        $('.white_content').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
    }
    function OverlayPopupOfferMade(str) {
        var items = str.split(',');
        $('#DivOfferMade').show();
        $('.overlay').show();
        RecenterPopup();
        $('#DivOfferMade').find('.userId').val(items[0]);
        $('#DivOfferMade').find('.status').val(items[1]);
        $('#DivOfferMade').find('.fullname').html(items[3]);
        $('#DivOfferMade').find('.designation').html(items[4]);
        $('#DivOfferMade').find('.email input').val(items[5]);
        $('#DivOfferMade').find('.password input').val(items[6]);
        $('#DivOfferMade').find('.cnf-password input').val(items[6]);
    }
    function overlayInterviewDate(str) {
        var items = str.split(',');
        $('#interviewDatelite').find('.userId').val(items[0]);
        $('#interviewDatelite').find('.status').val(items[1]);
        $('#interviewDatelite').find('.fullname').html(items[3]);
        $('#interviewDatelite').find('.designation').html(items[4]);
        $('#interviewDatelite').show();
        $('.overlay').show();
        RecenterPopup();
        $('#interviewDatelite').find('.date input').datepicker({ minDate: 0, maxDate: "+1M +10D" });
        //$('#interviewDatelite').find('.time select').chosen({ width: '100%' });
    }
    function overlay(str) {
        var items = str.split(',');
        $('#light').find('.userId').val(items[0]);
        $('#light').find('.status').val(items[1]);
        $('#light').show();
        $('.overlay').show();
        RecenterPopup();
    }
    function closePopup() {
        $('.search-user').trigger('click');
        $('.white_content').hide();
        $('.overlay').hide();
    }
    function saveOfferMade(sender) {
        var uid = $(sender).parents('.white_content').find('.userId').val();
        var status = $(sender).parents('.white_content').find('.status').val();
        var email = $(sender).parents('.white_content').find('.email input').val();
        var password = $(sender).parents('.white_content').find('.password input').val();
        var cnfPassword = $(sender).parents('.white_content').find('.cnf-password input').val();
        if (email.trim() == '' || password == '')
            return false;
        if (password != cnfPassword)
            return false;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatusOfferMade',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + status + ',newEmail:"' + email + '",password:"' + password + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('.search-user').trigger('click');
                closePopup();
            }
        })
    }

    function saveWithReason(sender) {
        var uid = $(sender).parents('.white_content').find('.userId').val();
        var status = $(sender).parents('.white_content').find('.status').val();
        var reason = $(sender).parents('.white_content').find('.reason textarea').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatusWithReason',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + status + ',reason:"' + reason + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('.search-user').trigger('click');
                closePopup();
            }
        })
    }
</script>
