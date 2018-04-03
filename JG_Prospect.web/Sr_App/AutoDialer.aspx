<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="AutoDialer.aspx.cs" Inherits="JG_Prospect.Sr_App.AutoDialer" %>

<%@ Register Src="~/Controls/_UserGridPhonePopup.ascx" TagPrefix="uc1" TagName="_UserGridPhonePopup" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Controls/user-grid.css" rel="stylesheet" />
    <style>
        .dialer-container div#phone {
            width: 23%;
            float: left;
        }

        div#wrapper {
            text-align: left;
        }

        .dialer-right > div {
            z-index: 101;
            border: 1px solid #bbb;
            border-radius: 5px;
            background: #fff;
        }

        .dialer-right {
            float: left;
            width: 76.8%;
        }

            .dialer-right div.scrips {
                min-height: 539px;
                padding: 5px;
            }



        div.userlist-grid {
            float: left;
            width: 100%;
            background: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../css/chosen.css" rel="stylesheet" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>
    <script src="../js/angular/scripts/Phone.js"></script>
    <div class="dialer-container">
        <div id="wrapper">
            <div id="phone">
                <div class="col-md-4 phone">
                    <div class="row1">
                        <input type="hidden" id="appSettings" />
                        <div class="col-md-12 white-shadow">
                            <input type="text" name="name" onkeyup="trimSpace(this)" onblur="trimSpace(this)" id="toNumber" class="form-control tel" placeholder="+91801XXXXXXX" value="" />
                            <div class="num-pad">
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            1
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            2 <span class="small">
                                                <p>
                                                    ABC
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            3 <span class="small">
                                                <p>
                                                    DEF
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            4 <span class="small">
                                                <p>
                                                    GHI
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            5 <span class="small">
                                                <p>
                                                    JKL
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            6 <span class="small">
                                                <p>
                                                    MNO
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            7 <span class="small">
                                                <p>
                                                    PQRS
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            8 <span class="small">
                                                <p>
                                                    TUV
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            9 <span class="small">
                                                <p>
                                                    WXYZ
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            *
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            0 <span class="small">
                                                <p>
                                                    +
                                                </p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="span4">
                                    <div class="num">
                                        <div class="txt">
                                            #
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix">
                            </div>
                            <input type="button" id="makecall" class="btn btn-success btn-block flatbtn" value="CALL" />
                            <input type="button" class="hangup btn btn-danger btn-block flatbtn" value="HANGUP" />
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                </div>
                <div class="button-3">
                    <div class="callinfo">
                        <h4 id="boundType">Fetching...</h4>
                        <h4 id="callNum">Fetching...</h4>
                        <h2 id="callDuration">00:00</h2>
                    </div>
                </div>
                <div class="play-stop">
                    <div class="row">
                        <span title="Start" onclick="startAutoDiualer(this)"><i class="fas fa-play-circle"></i></span>
                        <span title="Stop" onclick="stopAutoDiualer(this)"><i class="fas fa-stop-circle"></i></span>
                    </div>
                </div>
                <div class="logger">
                    <div class="title">Recent Calls</div>
                    <div class="log-content">
                        <div class="user-row row bg1" title="Kapil Pancholi" uid="780">
                            <div class="user-image">
                                <div class="img">
                                    <img src="https://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/5d5cfdfe-228a-4cc9-b069-81a5afd425bb-WIN_20170531_20_47_37_Pro.jpg">
                                </div>
                            </div>
                            <div class="contents">
                                <div class="top">
                                    <div class="name">Kapil Pancholi</div>
                                </div>
                                <div class="msg-container">
                                    <div class="tick"><img src="../img/incoming-red.png"></div>
                                    <div class="msg">04/02/2018 12:24:34 PM</div>
                                </div>
                            </div>
                            <div class="caller">
                                <div class="video"><i class="fas fa-video" aria-hidden="true"></i></div>
                                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>                                
                                <div class="mic"><i class="fas fa-microphone" aria-hidden="true"></i></div>
                            </div>
                        </div>
                        <div class="user-row row bg1" title="Kapil Pancholi" uid="780">
                            <div class="user-image">
                                <div class="img">
                                    <img src="https://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/5d5cfdfe-228a-4cc9-b069-81a5afd425bb-WIN_20170531_20_47_37_Pro.jpg">
                                </div>
                            </div>
                            <div class="contents">
                                <div class="top">
                                    <div class="name">Kapil Pancholi</div>
                                </div>
                                <div class="msg-container">
                                    <div class="tick"><img src="../img/incoming-green.png"></div>
                                    <div class="msg">04/02/2018 12:24:34 PM</div>
                                </div>
                            </div>
                            <div class="caller">
                                <div class="video"><i class="fas fa-video" aria-hidden="true"></i></div>
                                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>                                
                                <div class="mic"><i class="fas fa-microphone" aria-hidden="true"></i></div>
                            </div>
                        </div>
                        <div class="user-row row bg1" title="Kapil Pancholi" uid="780">
                            <div class="user-image">
                                <div class="img">
                                    <img src="https://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/5d5cfdfe-228a-4cc9-b069-81a5afd425bb-WIN_20170531_20_47_37_Pro.jpg">
                                </div>
                            </div>
                            <div class="contents">
                                <div class="top">
                                    <div class="name">Kapil Pancholi</div>
                                </div>
                                <div class="msg-container">
                                    <div class="tick"><img src="../img/outgoing-red.png"></div>
                                    <div class="msg">04/02/2018 12:24:34 PM</div>
                                </div>
                            </div>
                            <div class="caller">
                                <div class="video"><i class="fas fa-video" aria-hidden="true"></i></div>
                                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>                                
                                <div class="mic"><i class="fas fa-microphone" aria-hidden="true"></i></div>
                            </div>
                        </div>
                        <div class="user-row row bg1" title="Kapil Pancholi" uid="780">
                            <div class="user-image">
                                <div class="img">
                                    <img src="https://web.jmgrovebuildingsupply.com/Employee/ProfilePictures/5d5cfdfe-228a-4cc9-b069-81a5afd425bb-WIN_20170531_20_47_37_Pro.jpg">
                                </div>
                            </div>
                            <div class="contents">
                                <div class="top">
                                    <div class="name">Kapil Pancholi</div>
                                </div>
                                <div class="msg-container">
                                    <div class="tick"><img src="../img/outgoing-green.png"></div>
                                    <div class="msg">04/02/2018 12:24:34 PM</div>
                                </div>
                            </div>
                            <div class="caller">
                                <div class="video"><i class="fas fa-video" aria-hidden="true"></i></div>
                                <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>                                
                                <div class="mic"><i class="fas fa-microphone" aria-hidden="true"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="dialer-right">
                <input type="hidden" class="script-data" value="" />
                <div class="scrips">
                    <div class="tabs">
                        <div onclick="showhideType(this, 1);">Inbound</div>
                        <div onclick="showhideType(this, 2);" class="active">Outbound</div>
                    </div>
                    <div class="script-data">
                        <div class="inner-tabs">
                        </div>
                        <div class="content">
                        </div>
                    </div>
                </div>
                <div class="phone-stats">
                    <div style="padding: 10px; font-size: 16px; font-weight: bold;">Phone Statistic - <a href="">Detailed Report</a></div>
                    <table class="stats">
                        <tr>
                            <td>Total Outbound</td>
                            <td>24</td>
                            <td>Total Duration</td>
                            <td>125:25:12 Hours</td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>Total Applicant Called</td>
                            <td>100</td>
                            <td>Total Referal Applicant Called</td>
                            <td>200</td>
                            <td>Total Interview Date Called</td>
                            <td>50</td>
                        </tr>
                        <tr>
                            <td>Total Applicant Duration</td>
                            <td>25:25:12 Hours</td>
                            <td>Total Referal Applicant Duration</td>
                            <td>55:25:12 Hours</td>
                            <td>Total Interview Date Duration</td>
                            <td>65:25:12 Hours</td>
                        </tr>
                    </table>
                </div>
                <div class="userlist-calling-grid" style="display: none">
                    <div>
                        <table class="header-table">
                            <thead>
                                <tr>
                                    <th>
                                        <span>Date</span></th>
                                    <th>
                                        <span>Phone</span></th>
                                    <th>
                                        <span>Candidate Status</span></th>
                                    <th>
                                        <span>Duration</span></th>
                                    <th>
                                        <span>Called by Designation</span></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>3/4/2018 1:45 PM (EST)</td>
                                    <td>91987654321</td>
                                    <td>Yogesh Grove - <a>ITSN-A0411</a></td>
                                    <td>00:00:14 Hours</td>
                                    <td>Justin Grove - <a>INS00092</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <uc1:_UserGridPhonePopup runat="server" ID="_UserGridPhonePopup" />

        </div>
    </div>
    <script type="text/javascript">
        
        $(document).ready(function () {
            GetPhoneScripts(this);
            $('.search-user').trigger('click');

            resetSettings();
            initPhone();
        });

        
    </script>
</asp:Content>
