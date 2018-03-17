<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="_UserGridPhonePopup.ascx.cs" Inherits="JG_Prospect.Controls._UserGridPhonePopup" %>

<div class="userlist-grid">
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
                    <div class="dropdown">
                        <div><span>-- All --</span><span class="ddArrow"></span></div>
                        <ul>
                            <li></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <div class="dropdown">
                        <div><span>-- All --</span><span class="ddArrow"></span></div>
                        <ul>
                            <li></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <div class="dropdown">
                        <div><span>-- All --</span><span class="ddArrow"></span></div>
                        <ul>
                            <li></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <div class="dropdown">
                        <div><span>-- All --</span><span class="ddArrow"></span></div>
                        <ul>
                            <li></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <input type="checkbox" value="all" name="period" /><span>All</span>
                    <input type="checkbox" value="all" name="period" /><span>1 Year</span>
                    <input type="checkbox" value="all" name="period" /><span>Quarter (3 months)</span>
                    <span>From :<span>*</span><input type="text" />
                    </span>
                    <span>To :<span>*</span><input type="text" />
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
                    <input type="text" />
                    <input type="button" value="Search" />
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
        <tbody>
            <tr>
                <td>
                    <div>
                        <img src="https://web.jmgrovebuildingsupply.com/UploadeProfile/default.jpg" />
                    </div>
                    <div><a href="">Edit</a></div>
                </td>
                <td>
                    <div><a href="">7241</a></div>
                    <div>
                        <div class="dropdown">
                            <div><span>-- All --</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                    <div>Yogesh Kumar</div>
                </td>
                <td>
                    <div>
                        <div class="dropdown">
                            <div><span>-- All --</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                    <div>Yogesh Kumar</div>
                </td>
                <td>Naukri.com<br />
                    JMGC PC - <a href="">AREC-A0059</a>
                    3/12/2018 12:45:15 PM (EST)
                </td>
                <td>
                    <div>
                        <span>
                            <input type="checkbox" /></span>
                        <div class="dropdown">
                            <div><span>No Email</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <span>
                            <input type="checkbox" /></span>
                        <div class="dropdown small">
                            <div><span>No Phone</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                        <span>Cell Phone</span>
                    </div>
                    <div class="social">
                        <div class="dropdown small">
                            <div><span>Skype</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                        <span>
                            <input type="checkbox" /></span>
                        <input type="text" />
                        <input type="button" value="Add" />
                    </div>
                </td>
                <td>
                    <div>NA</div>
                    <div>
                        <div class="dropdown">
                            <div><span>-- Select --</span><span class="ddArrow"></span></div>
                            <ul>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>