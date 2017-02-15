﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="ViewSalesUser.aspx.cs" Inherits="JG_Prospect.Sr_App.ViewSalesUser" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>

<%@ Register Src="~/UserControl/ucAuditTrailByUser.ascx" TagPrefix="ucAudit" TagName="UserListing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/dropzone/css/basic.css" rel="stylesheet" />
    <link href="../css/dropzone/css/dropzone.css?v=1" rel="stylesheet" />
    <%----%>
    <link rel="stylesheet" href="../css/jquery-ui.css" />
    <link rel="stylesheet" href="../css/intTel/intlTelInput.css" />

    <link href="../datetime/css/jquery-ui-1.7.1.custom.css" rel="stylesheet" type="text/css" />
    <link href="../datetime/css/stylesheet.css" rel="stylesheet" type="text/css" />

    <link href="../Styles/dd.css" rel="stylesheet" />
    <link type="text/css" href="../css/flags24.css" rddlstatusel="Stylesheet"/>


    <%--<script src="../Scripts/jquery.MultiFile.js" type="text/javascript"></script>--%>

    <script type="text/javascript">
        function showAptTestPage(PageUrl) {
            var $dialog = $('<div class="Aptitude-popup"></div>')
                           .html('<iframe style="border: 0px; " src="' + PageUrl + '" width="100%" height="100%"></iframe>')
                           .dialog({
                               autoOpen: false,
                               modal: true,
                               height: 625,
                               width: 800,
                               title: "Aptitude Test"
                           });
            $dialog.dialog('open');
        }

        function changeFlag(countrolD) {            
            $("#dvFlag").attr('class', $(countrolD).val().toLowerCase());
        }

        function hidePnl() {
            $("#ContentPlaceHolder1_pnlpopup").hide();
            return true;
        }

        function ClosePopupOfferMade() {
            document.getElementById('DivOfferMade').style.display = 'none';
            document.getElementById('DivOfferMadefade').style.display = 'none';
        }

        function OverlayPopupOfferMade() {
            document.getElementById('DivOfferMade').style.display = 'block';
            document.getElementById('DivOfferMadefade').style.display = 'block';
        }

        function ClosePopupInterviewDate() {
            document.getElementById('interviewDatelite').style.display = 'none';
            document.getElementById('interviewDatefade').style.display = 'none';
        }

        function overlayInterviewDate() {
            document.getElementById('interviewDatelite').style.display = 'block';
            document.getElementById('interviewDatefade').style.display = 'block';
        }

        function GetSelectedValue(e) {
            //get selected value and check if subject is selected else show alert box
            var SelectedValue = e.options[e.selectedIndex].value;
            if (SelectedValue > 0) {
                //get selected text and set to label
                var SelectedText = e.options[e.selectedIndex].text;
                if (SelectedText == "Active") {
                    doOpen();
                }
                else {
                    doClose();
                }
                //set selected value to label
            }
        }

        function doOpen() { $find("cpe2")._doOpen(); }
        function doClose() { $find("cpe2")._doClose(); }


    </script>
    <script type="text/javascript">
        $(function () {
            $("#DOBdatepicker").datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: '1950:2050',
                maxDate: 'today'
            });
        });

        $(function () {
            $("#txtStartDate").datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: '1950:2050',
                maxDate: 'today'
            });
        });
    </script>

    <script type="text/javascript">
        
        function checkTextAreaMaxLength(textBox, e, length) {

            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;

            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE
                        e.returnValue = false;
                    else//Firefox
                        e.preventDefault();
                }
            }
        }
        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }

        function pageLoad() {
        $(document).ready(function () {

           changeFlag('#<%=ddlCountry.ClientID%>'); // Set Flag.

           $('#<%=ddlCountry.ClientID%>').bind('change keyup', function (e) {
                changeFlag('#<%=ddlCountry.ClientID%>');
            });

            <%--$('#<%=ddlCountry.ClientID%>').change(function (e) {
                changeFlag('#<%=ddlCountry.ClientID%>');
            });--%>
            
            $('#<%=lbtnAptTestLink.ClientID%>').click(function () {
                var url = window.location.href
                var arr = url.split("/");
                var currDomainName = arr[0] + "//" + arr[2];
                showAptTestPage(currDomainName + '/MCQTest/McqTestPage.aspx');
            });

            var text_max = 50;
            $('#textarea_CharCount').html(text_max + ' characters remaining');

            $('#<%=txtREasonChange.ClientID%>').keyup(function () {
                var text_length = $('#<%=txtREasonChange.ClientID%>').val().length;
                var text_remaining = text_max - text_length;

                $('#textarea_CharCount').html(text_remaining + '  / ' + text_max + ' characters remaining');
            });
        });

        }

        function ClosePassword() {
            document.getElementById('litePassword').style.display = 'none';
            document.getElementById('fadePassword').style.display = 'none';
        }

        function overlayPassword() {
            document.getElementById('litePassword').style.display = 'block';
            document.getElementById('fadePassword').style.display = 'block';
        }

        function ClosePopup() {
            document.getElementById('light').style.display = 'none';
            document.getElementById('fade').style.display = 'none';
        }

        function overlay() {
            document.getElementById('light').style.display = 'block';
            document.getElementById('fade').style.display = 'block';
        }

    </script>
    <script type="text/javascript">
        function sync() {
            var n1 = document.getElementById('txtMailingAddress');
            var n2 = document.getElementById('txtaddress');
            n1.value = n2.value;
        }
    </script>

    

    <script type="text/javascript">
        function ValidateCheckBox() {
            return true;
            <%--if (document.getElementById("<%=chkboxcondition.ClientID %>").checked == true) {
                return true
            } else {
                alert("Please Accept Term and Conditions")
                return false;
            }--%>
        }

        var validFilesTypes = ["doc", "docs", "pdf", "docx"];
        function ValidateFileOne() {
            var file = document.getElementById("<%=flpResume.ClientID%>");
            var path = file.value;
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.length; i++) {
                if (ext == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile) {
                alert('Select file of type doc,pdf or docx');
                //label.style.color = "red";
                //label.innerHTML = "Invalid File. Please upload a File with" +

                // " extension:\n\n" + validFilesTypes.join(", ");

            }
            return isValidFile;
        }
         
         
    </script>
    <script type="text/javascript">

        //http://preview.tinyurl.com/prugz6k

        function SetSectionShowHideOnReady() {
            $('#btnGeneralPlus').hide();

            $('.tblSkillAssessment td').hide();
            $('#btnSkillAssMinusNew').hide();

            $('.tblRecruiterAssMinusNew td').hide();
            $('#btnRecruiterAssMinusNew').hide();


            $('.tblSalesAssesment td').hide();
            $('#btnSalesAssMinusNew').hide();

            //$('.tblSalesAssesment td').hide();
            $('#btnBasicPlusNew').hide();

            $('#btnNewHirePluse').hide();



            $("#btnGeneralMinus").click(function () {
                $('.tblGeneral td').hide("slow");
                $('#btnGeneralPlus').show();
                $('#btnGeneralMinus').hide();
            });
            $("#btnGeneralPlus").click(function () {
                $(".tblGeneral td").show("slow");
                $('#btnGeneralPlus').hide();
                $('#btnGeneralMinus').show();
            });



            $("#btnSkillAssMinusNew").click(function () {
                $('.tblSkillAssessment td').hide("slow");
                $('#btnSkillAssPlusNew').show();
                $('#btnSkillAssMinusNew').hide();
                $('#tblBasicAssessment').hide();
            });
            $("#btnSkillAssPlusNew").click(function () {
                $(".tblSkillAssessment td").show("slow");
                $('#btnSkillAssPlusNew').hide();
                $('#btnSkillAssMinusNew').show();
                $('#tblBasicAssessment').show();
            });



            $("#btnRecruiterAssMinusNew").click(function () {
                $('.tblRecruiterAssMinusNew td').hide("slow");
                $('#btnRecruiterPlusNew').show();
                $('#btnRecruiterAssMinusNew').hide();
                $('#tblBasicAssessment').hide();
            });
            $("#btnRecruiterPlusNew").click(function () {
                $(".tblRecruiterAssMinusNew td").show("slow");
                $('#btnRecruiterPlusNew').hide();
                $('#btnRecruiterAssMinusNew').show();
                $('#tblBasicAssessment').show();
            });


            $("#btnSalesAssMinusNew").click(function () {
                $('.tblSalesAssesment td').hide("slow");
                $('#btnSalesPlusNew').show();
                $('#btnSalesAssMinusNew').hide();
                $('#tblBasicAssessment').hide();

            });
            $("#btnSalesPlusNew").click(function () {
                $(".tblSalesAssesment td").show("slow");
                $('#btnSalesPlusNew').hide();
                $('#btnSalesAssMinusNew').show();
                $('#tblBasicAssessment').show();

            });

             

            // Basic Skill Assessment section
            $("#btnBasicAssMinusNew").click(function () {
                $('.tblBasicAssessment td').hide("slow");
                $('#btnBasicPlusNew').show();
                $('#btnBasicAssMinusNew').hide();

            });
            $("#btnBasicPlusNew").click(function () {
                $(".tblBasicAssessment td").show("slow");
                $('#btnBasicPlusNew').hide();
                $('#btnBasicAssMinusNew').show();

            });






            $("#btnNewHireMinus").click(function () {
                $('.tblNewHire td').hide("slow");
                $('#btnNewHirePluse').show();
                $('#btnNewHireMinus').hide();

            });
            $("#btnNewHirePluse").click(function () {
                $(".tblNewHire td").show("slow");
                $('#btnNewHirePluse').hide();
                $('#btnNewHireMinus').show();

            });

            ShowHideRespectiveTableData('');
        }

        function ShowPhoneExtOnType(optionSelected, txtPhoneID, phoneExtID, PhoneISDCode) {
            
            if ((optionSelected.lastIndexOf('Other') < 0) && (optionSelected != 'skype') && (optionSelected != 'whatsapp')) {
                //Show Ext text box        
                
                $(phoneExtID).show("slow");
                $(txtPhoneID).intlTelInput();
                if (PhoneISDCode != '') {
                    $(txtPhoneID).intlTelInput("setCountry", PhoneISDCode);
                }
                //else {
                //    $(txtPhoneID).intlTelInput("setCountry", 'us');
                //}
                //$(txtPhoneID).intlTelInput("setCountry", 'in');
                //alert('set');
                //var countryData = $(txtPhoneID).intlTelInput("getSelectedCountryData");
                //alert(countryData.iso2);
            }
            else
            {
                //Hide Ext text box                
                $(phoneExtID).hide("slow");                
                $(txtPhoneID).intlTelInput("destroy");
            }
        }
        function pageLoad() {
            $(document).ready(function () {

                SetSectionShowHideOnReady();

                $('#<%= ddlPositionAppliedFor.ClientID %>').on('change', function (e) {

                    var optionSelected = $("option:selected", this).text();
                    ShowHideRespectiveTableData(optionSelected);
                });

                //============$ Formation for sarlary =======START======

                $('#<%=txtSalaryRequirments.ClientID%>').on('input', function (e) {
                    $(this).val(formatCurrency(this.value.replace(/[,$]/g, '')));
                }).on('keypress', function (e) {
                    if (!$.isNumeric(String.fromCharCode(e.which))) e.preventDefault();
                }).on('paste', function (e) {
                    var cb = e.originalEvent.clipboardData || window.clipboardData;
                    if (!$.isNumeric(cb.getData('text'))) e.preventDefault();
                });

                //============$ Formation for sarlary =======END======

                $('#<%= phoneTypeDropDownList.ClientID %>').on('change', function (e) {
                    var optionSelected = $("option:selected", this).text();
                    if (optionSelected == "Other") {
                        var newPhoeType = prompt("Please enter New Phone Type to Add ", "New Type");
                        AddNewPhoneType("Other : " + newPhoeType);
                    }
                    var phoneExtID = $('#<%= txtPhoneExt.ClientID %>');
                    var txtPhoneID = $('#<%=txtPhone.ClientID%>');

                    ShowPhoneExtOnType(optionSelected, txtPhoneID, phoneExtID, "");
                });


                //=== check default - old Phone on the base of value selected 

                var optionSelected = $("option:selected", $('#<%= phoneTypeDropDownList.ClientID %>')).text();
                var phoneExtID = $('#<%= txtPhoneExt.ClientID %>');
                var txtPhoneID = $('#<%=txtPhone.ClientID%>');
                var txtPhoneISDCode = $('#<%=hidPhoneISDCode.ClientID%>').val();

                ShowPhoneExtOnType(optionSelected, txtPhoneID, phoneExtID, txtPhoneISDCode);


                txtPhoneID.on("countrychange", function (e, countryData) {
                    $('#<%=hidPhoneISDCode.ClientID%>').val(countryData.iso2)
                });

                //$('<div/>', {'class': 'ExtAddPhone', html: GetHtml()
                //}).appendTo('#container'); //Get the html from template

                $('#AddExtPhone').click(function () {
                    AddPhoneTypDdl('');
                });

                $('#container').on('click', '.RemovePhoneBtn', function () {
                    var RemovItem = this;
                    TheConfirm('Do you want to delete this record ?', function () {
                        $(RemovItem).parent().remove();
                        SetPhoneValuefromCtlToHid();
                    },
                    function () {
                        //alert('You clicked Cancel');
                    },
                      'Confirm Delete'
                    );
                });

                /// Email  == START
                $('#AddExtEmail').click(function () {
                    $('<div/>', {
                        'class': 'ExtAddEmail', html: GetHtmlForEmail('')
                    }).hide().appendTo('#EmailContainer').slideDown('slow');//Get the html from template and hide and slideDown for transtion.
                });

                $('#EmailContainer').on('click', '.RemovePhoneBtn', function () {
                    var RemovItem = this;
                    TheConfirm('Do you want to delete this record ?', function () {
                        $(RemovItem).parent().remove();
                        SetEmailValuefromCtlToHid();
                    },
                    function () {
                        //alert('You clicked Cancel');
                    },
                      'Confirm Delete'
                    );
                });

                $('.ddlPhoneTypeExt').change(function () {
                    SetPhoneValuefromCtlToHid();

                    var optionSelected = $("option:selected", this).text();
                    if (optionSelected == "Other") {
                        var newPhoeType = prompt("Please enter New Phone Type to Add ", "New Type");
                        AddNewPhoneType(newPhoeType);
                    }

                    var PhoneExtID = '#' + this.getAttribute("AddtxtPhoneExtID");
                    var txtPhoneID = '#' + this.getAttribute("AddtxtPhoneID");
                    //var PhoneISDCode = '#' + this.getAttribute("PhoneISDCode");

                    ShowPhoneExtOnType(optionSelected, txtPhoneID, PhoneExtID, "");

                });

                ReadEmailValuesFromHidGenControls();
                ReadPhoneValuesFromHidGenControls();
                // Email  == END

                try {
                    $('#<%= phoneTypeDropDownList.ClientID %>').msDropDown();
                } catch (e) {
                    alert(e.message);
                }
            });

        }
        //===ready===END
        function ShowHideRespectiveTableData(optionSelected) {
            if (optionSelected == '') {
                optionSelected = $('#<%= ddlPositionAppliedFor.ClientID %>').val();
            }

            $('#btnGeneralPlus').hide();

            $('.tblSkillAssessment td').hide();
            $('#btnSkillAssMinusNew').hide();

            $('.tblRecruiterAssMinusNew td').hide();
            $('#btnRecruiterAssMinusNew').hide();
            
            $('.tblSalesAssesment td').hide();
            $('#btnSalesAssMinusNew').hide();


            $('.tblSaleMain td').hide();
            $('.tblRecruiterMain td').hide();
            $('.tblSkillMain td').hide();


            $('.tblSaleMain').hide();
            $('.tblRecruiterMain').hide();
            $('.tblSkillMain').hide();

            $('.tblBasicAssessmentMain').hide();

            //alert(optionSelected);

            //if ((optionSelected == "0") || (optionSelected == "--Select--")) {

            //    $('#div-AdminAssess').html("Select Skill Assessment")
            //    $('.tblSkillMain').show("slow");
            //    $('.tblSkillMain td').show("slow");

            //    $(".tblSkillAssessment td").show("slow");
            //    $('#btnSkillAssPlusNew').hide();
            //    $('#btnSkillAssMinusNew').show();

            //} else

            if (optionSelected == "Admin") {
                $('#div-AdminAssess').html(optionSelected + " Skill Assessment")
                $('.tblSkillMain').show("slow");
                $('.tblSkillMain td').show("slow");


                $(".tblSkillAssessment td").show("slow");
                $('#btnSkillAssPlusNew').hide();
                $('#btnSkillAssMinusNew').show();
            }
            else if ((optionSelected == "Jr. Sales") || (optionSelected == "Jr Project Manager") || (optionSelected == "Sr. Sales") || (optionSelected == "Sales Manager")) {
                $('#div-SalesAssess').html(optionSelected + " Skill Assessment")
                $('.tblSaleMain').show("slow");
                $('.tblSaleMain td').show("slow");


                $(".tblSalesAssesment td").show("slow");
                $('#btnSalesPlusNew').hide();
                $('#btnSalesAssMinusNew').show();



            }
            else if (optionSelected == "Recruiter") {
                $('#div-RecuiterAssess').html(optionSelected + " Skill Assessment")
                $('.tblRecruiterMain').show("slow");
                $('.tblRecruiterMain td').show("slow");


                $(".tblRecruiterAssMinusNew td").show("slow");
                $('#btnRecruiterPlusNew').hide();
                $('#btnRecruiterAssMinusNew').show();
            }
            else {
                // show for all user.
                // alert(optionSelected);

                if ((optionSelected == "0") || (optionSelected == "--Select--")) {
                    $('#div-BasicAssessment').html("Select Skill Assessment")
                }
                else {
                    $('#div-BasicAssessment').html(optionSelected + " Skill Assessment");
                }


                $('#tblBasicAssessmentMain').show();
                $('#tblBasicAssessment').show();
            }

        }

        function formatCurrency(number) {
            var n = number.split('').reverse().join("");
            var n2 = n.replace(/\d\d\d(?!$)/g, "$&,");
            return '$' + n2.split('').reverse().join('');
        }

        function SetEmailValuefromCtlToHid() {
            var delimeter = '|,|';
            var strEmailIds = '';

            var mailEmail = $('#<%= txtemail.ClientID %>').val();

            validateEmail(mailEmail);

            $('#EmailContainer .ExtEmailClass').each(function () {
                if (this.value != '') {

                    if (strEmailIds == '') {
                        strEmailIds = strEmailIds + this.value;
                    }
                    else {
                        strEmailIds = strEmailIds + delimeter + this.value;
                    }
                }
            });

            $('#<%= hidExtEmail.ClientID %>').val(strEmailIds);
        }

        function SetPhoneValuefromCtlToHid() {
            var delimeter = '|,|';
            var Subdelimeter = '|%|';
            var strPhoneValue = '';
            var len = $('.ExtAddPhone').length;
            var PhoneISDCode = [];
            var txtPhone = [];
            var txtPhoneExt = [];
            var ddlPhoneType = [];
            var chkPhoneProroty = [];
            var i = 0;

            if (len <= 0) {
                return;
            }
            var html = $('#container').clone();

            //== Getting value of Phone Type selected 
            $('#container .ddlPhoneTypeExt').each(function () {
                ddlPhoneType[i] = this.value;

                var optionSelected = $("option:selected", this).text();

                if ((optionSelected.lastIndexOf('Other') < 0) && (optionSelected != 'skype') && (optionSelected != 'whatsapp')) {
                    //IF not other or skyp then get the value of ext and country ISD

                    var PhoneExtID = '#' + this.getAttribute("AddtxtPhoneExtID");
                    var txtPhoneID = '#' + this.getAttribute("AddtxtPhoneID");
                    //ShowPhoneExtOnType(optionSelected, txtPhoneID, PhoneExtID);

                    //$(txtPhoneID).intlTelInput("setCountry", 'in');
                    //var countryData = $(txtPhoneID).intlTelInput("getSelectedCountryData");
                    //alert(countryData.iso2);
                    var countryData = $(txtPhoneID).intlTelInput("getSelectedCountryData");
                    PhoneISDCode[i] = countryData.iso2;
                    txtPhoneExt[i] = $(PhoneExtID).val();
                }
                else
                {
                    PhoneISDCode[i] = "";
                    txtPhoneExt[i] = "";
                }

                i++;
            });

            i = 0;
            //== Getting value of Phone Type Checkbox 
            $('#container .PrimaryPhonechk').each(function () {
                if (this.checked == true) {
                    chkPhoneProroty[i] = "1";
                }
                else {
                    chkPhoneProroty[i] = "0";
                }
                
                i++;
            });

            i = 0;
            //== Getting value of Phone Type textBox
            $('#container .ExtPhoneClass').each(function () {
                txtPhone[i] = this.value;
                i++;
            });


            for (i = 0; i < len; i++) {
                //var txtPhone = html.find('[name=AddedPhone' + i + ']');
                if (txtPhone[i] != '') {
                    var strPhoneCombainValue = chkPhoneProroty[i] + Subdelimeter + PhoneISDCode[i] + Subdelimeter + txtPhone[i] + Subdelimeter + txtPhoneExt[i] + Subdelimeter + ddlPhoneType[i];

                    if (strPhoneValue == '') {
                        strPhoneValue = strPhoneCombainValue;
                    }
                    else {
                        strPhoneValue = strPhoneValue + delimeter + strPhoneCombainValue;
                    }
                }
            }

            
            

            //chkPhoneProroty[i] + Subdelimeter + txtPhone[i] + Subdelimeter + ddlPhoneType[i];
            //So it will be like Eg.for 1 record =="1|%|9429822|%|WorkPhone
            //So it will be like Eg.for 2 record =="1|%|9429822|%|WorkPhone|,|0|%|937660|%|HomePhone
            
            $('#<%= hidExtPhone.ClientID %>').val(strPhoneValue);
        }

        function ReadPhoneValuesFromHidGenControls() {
            
            var PhoneValue = $('#<%= hidExtPhone.ClientID %>').val();
            var delimeter = '|,|';
            var Subdelimeter = '|%|';

            //PhoneValue = '0' + Subdelimeter + 'in' + Subdelimeter + 'Phone1' + Subdelimeter + '08' + Subdelimeter + '2';
            //PhoneValue = '0' + Subdelimeter + ISDCode + Subdelimeter + 'Phone1' + Subdelimeter + PhoneExt + Subdelimeter + 'skype' + delimeter + '1' + Subdelimeter + ISDCode2 +'Phone2' + Subdelimeter + PhoneExt2 + Subdelimeter + 'whatsapp';

            if (PhoneValue == '') {
                return;
            }

            if (PhoneValue.lastIndexOf(delimeter) < 0) {
                //if delimeter is not found then add it.
                PhoneValue = PhoneValue + delimeter;
            }

            var PhoneArray = PhoneValue.split(delimeter);
            var i = 0;

            $('#container').empty(); // clear div contails

            for (i = 0; i < PhoneArray.length; i++) {

                if (PhoneArray[i] != '') {

                    var PhoneCombainValue = PhoneArray[i].split(Subdelimeter)
                    var chkPhonePro = PhoneCombainValue[0];
                    var PhoneISDCode = PhoneCombainValue[1];
                    var PhoneTxt = PhoneCombainValue[2];
                    var PhoneExt = PhoneCombainValue[3];
                    var PhoneType = PhoneCombainValue[4];
                    
                    $('<div/>', {
                        'class': 'ExtAddPhone', html: GetHtml(chkPhonePro, PhoneISDCode, PhoneTxt, PhoneExt, PhoneType)
                    }).hide().appendTo('#container').slideDown('slow');

                    functionCallAfterPhonTypeAdded();
                }
            }

            //i = 0;
            //$('#EmailContainer .ExtEmailClass').each(function () {
            //    this.value = emaiArray[i];
            //    i++;
            //}); 
        }

        function validateEmail(mailEmail) {
            if (mailEmail == '') {
                alert('Kindly Enter Value for Primary Email Id');
                return false;
            }

            $('#EmailContainer .ExtEmailClass').each(function () {
                if (this.value == '') {
                    //alert('Kindly Enter Value for all Email-ID or delete it');
                }
            });
        }

        function ReadEmailValuesFromHidGenControls() {
            
            var emailValue = $('#<%= hidExtEmail.ClientID %>').val();
            
            var delimeter = '|,|';

            if (emailValue == '') {
                return;
            }

            if (emailValue.lastIndexOf(delimeter) < 0) {
                //only One emailID without 
                emailValue = emailValue + delimeter;
            }

            var emaiArray = emailValue.split(delimeter);
            var i = 0;


            $('#EmailContainer').empty(); // cear div contails

            for (i = 0; i < emaiArray.length; i++) {

                if (emaiArray[i] != '') {
                    $('<div/>', {
                        'class': 'ExtAddEmail', html: GetHtmlForEmail(emaiArray[i])
                    }).hide().appendTo('#EmailContainer').slideDown('slow');
                }
            }

            //i = 0;
            //$('#EmailContainer .ExtEmailClass').each(function () {
            //    this.value = emaiArray[i];
            //    i++;
            //}); 
        }

        function functionCallAfterPhonTypeAdded() {
            try {
                $('#container .ddlPhoneTypeExt').msDropDown();
            } catch (e) {
                alert(e.message);
            }

            $('.ddlPhoneTypeExt').change(function () {
                SetPhoneValuefromCtlToHid();
                var optionSelected = $("option:selected", this).text();
                if (optionSelected == "Other") {
                    var newPhoeType = prompt("Please enter New Phone Type to Add ", "New Type");
                    AddNewPhoneType(newPhoeType);
                }

                var PhoneExtID = '#' + this.getAttribute("AddtxtPhoneExtID");
                var txtPhoneID = '#' + this.getAttribute("AddtxtPhoneID");
                //var PhoneISDCode = '#' + this.getAttribute("PhoneISDCode");

                ShowPhoneExtOnType(optionSelected, txtPhoneID, PhoneExtID, "");
            });

            $('#container .ddlPhoneTypeExt').each(function () {
                var optionSelected = $("option:selected", this).text();
                var PhoneExtID = '#' + this.getAttribute("AddtxtPhoneExtID");
                var txtPhoneID = '#' + this.getAttribute("AddtxtPhoneID");
                var PhoneISDCode =  this.getAttribute("PhoneISDCode");

                ShowPhoneExtOnType(optionSelected, txtPhoneID, PhoneExtID, PhoneISDCode);
            });

            SetPhoneValuefromCtlToHid();
        }


        function AddPhoneTypDdl(newPhoneType) {

            $('<div/>', {
                'class': 'ExtAddPhone', html: GetHtml('', '', '', '',newPhoneType)
            }).hide().appendTo('#container').slideDown('slow');//Get the html from template and hide and slideDown for transtion.

            functionCallAfterPhonTypeAdded();
        }

        function GetHtml(chkPhonePro, PhoneISDCode, PhoneTxt, PhoneExt, PhoneType) //Get the template and update the input field names
        {
            var len = $('.ExtAddPhone').length;
            var $html = $('.ExtAddPhoneTemplate').clone();

            $html.find('[name=AddedPhone]')[0].name = "AddedPhone" + len;
            $html.find('[name=chkPrimaryPhone]')[0].name = "chkPrimaryPhone" + len;
            $html.find('[id=<%=ddlPhontType.ClientID %>]')[0].id = document.getElementById('<%=ddlPhontType.ClientID%>').id + len;

            //Set attr to get value on selected chagen for show hide of Ext textbox.
            $html.find('[id=<%=ddlPhontType.ClientID%>' + len + ']').attr("AddtxtPhoneExtID", "AddedPhoneExt" + len);
            $html.find('[id=<%=ddlPhontType.ClientID%>' + len + ']').attr("AddtxtPhoneID", "txtAddedPhone" + len);

            $html.find('[id=AddedPhoneExt]')[0].id = "AddedPhoneExt" + len;
            $html.find('[id=txtAddedPhone]')[0].id = "txtAddedPhone" + len;

            $html.find('[name=AddedPhone' + len + ']').attr("value", PhoneTxt);

            // set value for edit mode or page refresh.
            if (chkPhonePro == "1") {
                $html.find('[name=chkPrimaryPhone' + len + ']').attr("checked", true);
            }
            
            if (PhoneExt != '') {
                $html.find('[id=AddedPhoneExt' + len + ']').attr("value", PhoneExt);
            }

            // Setting ISD Code so later can fetch value from att
            
            if (PhoneISDCode) {
                $html.find('[id=<%=ddlPhontType.ClientID%>' + len + ']').attr("PhoneISDCode", PhoneISDCode);
            }
            else
            {
                //setting default value as US..
                $html.find('[id=<%=ddlPhontType.ClientID%>' + len + ']').attr("PhoneISDCode", "us");
            }

            if (PhoneType != '') {
                $html.find('[id=<%=ddlPhontType.ClientID%>' + len + ']').find("option[value = '" + PhoneType + "']").attr("selected", "selected");
            }

            return $html.html();
        }

        function GetHtmlForEmail(strEmailValue) {

            var len = $('.ExtAddEmail').length;

            var $html = $('.ExtAddEmailTemplate').clone();
            $html.find('[name=txtExtEmail]')[0].name = "txtExtEmail" + len;
            $html.find('[name=txtExtEmail' + len + ']').attr("value", strEmailValue);

            return $html.html();
        }





        function TheConfirm(dialogText, okFunc, cancelFunc, dialogTitle) {
            $('<div style="padding: 10px; max-width: 500px; word-wrap: break-word;">' + dialogText + '</div>').dialog({
                draggable: false,
                modal: true,
                resizable: false,
                width: 'auto',
                title: dialogTitle || 'Confirm',
                minHeight: 75,
                buttons: {
                    OK: function () {
                        if (typeof (okFunc) == 'function') {
                            setTimeout(okFunc, 50);
                        }
                        $(this).dialog('destroy');
                    },
                    Cancel: function () {
                        if (typeof (cancelFunc) == 'function') {
                            setTimeout(cancelFunc, 50);
                        }
                        $(this).dialog('destroy');
                    }
                }
            });
        }
         
        function CheckDuplicatePhone(obj) {
            if (obj.value != "") {
                CheckDuplicateCustomerCred(obj, 1);
                SetPhoneValuefromCtlToHid();
            }
        }

        function CheckDuplicateEmail(obj) {
            if (obj.value != "") {
                CheckDuplicateCustomerCred(obj, 2);
                SetEmailValuefromCtlToHid();
            }
        }
        
        // == Add New Phone Type in To DB..
        function AddNewPhoneType(newPhoneType) {

            newPhoneType = "Other : " + newPhoneType;
            alert(newPhoneType);
            var IsAlreadyExist = false;

            if (newPhoneType == null) {
                return false;
            }

            $("#<%= phoneTypeDropDownList.ClientID %> option").each(function () {
                ;
                if ($(this).text() == newPhoneType) {
                    alert("Phone Type already exists");                    
                    IsAlreadyExist = true;
                    return false;
                }
            });

            if (IsAlreadyExist == true) {
                return false;
            }
            $.ajax({
                type: "POST",
                url: "CreateSalesUser.aspx/AddNewPhoneTypeToDB",
                contentType: "application/json; charset=utf-8",
                dataType: "JSON",
                data: "{'strNewPhoneType':'" + newPhoneType + "'}",

                success: function (data) {
                    //;

                    var dataInput = (data.d.split('#'));
                    //myString.split('/')
                    if (dataInput != '') {
                        //;
                        var title = "";

                        $("#dialog")[0].innerHTML = "";

                        $("#dialog")[0].innerHTML = dataInput[0];
                        title = "Phone Type Infomation";

                        AppendItemToDropDown(newPhoneType);

                        $("#dialog").dialog({
                            modal: true,
                            autoOpen: false,
                            title: title,
                            width: 350,
                            height: 160,
                            buttons:
                                {
                                    OK: function () { $(this).dialog("close"); }
                                }
                        });

                        $('#dialog').dialog('open');
                    }
                }
            });
        }


        // Add New Item to dropDownList.
        function AppendItemToDropDown(newPhoneType) {

            $('#<%= phoneTypeDropDownList.ClientID %>').append($("<option></option>").attr("value", newPhoneType).text(newPhoneType))
            $('.ddlPhoneTypeExt').append($("<option></option>").attr("value", newPhoneType).text(newPhoneType));

            AddPhoneTypDdl(newPhoneType);
            
        }

        function CheckDuplicateCustomerCred(obj, type) {
            //;
            var valueForValid = "";
            if (type == 1) {
                var contact = obj.value
                valueForValid = contact.replace('-', '');
                valueForValid = valueForValid.replace('-', '');
            }
            else {
                valueForValid = obj.value;
            }
            $.ajax({
                type: "POST",
                url: "CreateSalesUser.aspx/CheckDuplicateUserContacts",
                contentType: "application/json; charset=utf-8",
                dataType: "JSON",
                data: "{'pValueForValidation':'" + valueForValid + "', 'strCurrentID':'" + $('#<%= hidID.ClientID %>').val() + "','pValidationType':" + type + "}",

                success: function (data) {
                    //;

                    var dataInput = (data.d.split('#'));
                    //myString.split('/')
                    if (dataInput != '') {
                        //;
                        var title = "";
                        var existsMessage = "";
                        $("#dialog")[0].innerHTML = "";
                        if (type == 1) {
                            existsMessage = "Contact " + obj.value;
                            $("#dialog")[0].innerHTML = existsMessage + " " + "already exists: would you like to redirect to this User page?";;
                            title = "Contact already exists";
                        }
                        else {
                            existsMessage = "Email " + obj.value;
                            $("#dialog")[0].innerHTML = existsMessage + " " + "already exists: would you like to redirect to this User page?";
                            title = "Email already exists";
                        }

                        $("#dialog").dialog({
                            modal: true,
                            autoOpen: false,
                            title: title,
                            width: 350,
                            height: 160,
                            buttons: [
                            {
                                id: "Yes",
                                text: "Yes",
                                click: function () {                                    
                                    window.location = "CreateSalesUser.aspx?id=" + dataInput[0];
                                }
                            },
                            {
                                id: "Cancel",
                                text: "Cancel",
                                click: function () {
                                    $(this).dialog('close');
                                }
                            }
                            ]
                        });

                        $('#dialog').dialog('open');
                        //alert(dataInput);
                        obj.value = '';
                    }
                }
            });
        }

    </script>
    <style type="text/css">
        #ui-dialog-title
        {
            background: #ccc;
        }
        .tblGen-Secon tr td {
            padding-left: 55px !important;
        }

        .formCtrl {
            padding: 5px;
            border-radius: 5px;
            border: #b5b4b4 1px solid;
            margin-left: 0;
            margin-right: 0;
            margin-bottom: 0;
        }

        .PrimaryPhonechk {
            display: inline-block;
            margin-left: -28px;
            padding-left: 28px;
            background: url('img/main-header-bg.png') no-repeat 0 0;
            line-height: 24px;
        }

        .PrimaryEmailchk{
            display: inline-block;
            margin-left: -28px;
            padding-left: 28px;
            background: url('img/main-header-bg.png') no-repeat 0 0;
            line-height: 24px;
        }

        .tr-RadioButton span label {
            padding-top: 0px !important;
            padding-left: 3px;
        }

        .tblUserData tr td {
            padding-right: 10px !important;
            padding-left: 1px !important;
        }

        .ExtAddPhoneTemplate {
            width: 260px;
            display: none;
        }

        .ExtAddEmailTemplate {
            display: none;
        }

        .RemovePhoneBtn {
            vertical-align: top;
            display: inline-block;
            font-size: 0.9em;
            font-weight: 400;
            border: 0; 
            margin: 0;
            margin-left: 45px !important;
        }

        .ddlPhoneTypeExt {
            min-width: 150px;
        }


        .modalBackground {
            background-color: Gray;
            filter: alpha(opacity=80);
            opacity: 0.8;
            z-index: 10000;
            display: none;
        }

        .myfont {
            font-family: 'barcode_fontregular';
            font-size: 37px;
        }

        .black_overlay {
            display: none;
            position: fixed;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            background-color: black;
            z-index: 1001;
            -moz-opacity: 0.8;
            opacity: .80;
            filter: alpha(opacity=80);
            overflow-y: hidden;
        }

        .white_content {
            display: none;
            position: absolute;
            top: 10%;
            left: 20%;
            width: 60%;
            height: 5%;
            padding: 16px;
            border: 10px solid #327FB5;
            background-color: white;
            z-index: 1002;
            overflow: auto;
        }

        @font-face {
            font-family: 'barcode_fontregular';
            src: url('../fonts/barcodefont-webfont.eot');
            src: url('../fonts//barcodefont-webfont.eot?#iefix') format('embedded-opentype'), url('../fonts/barcodefont-webfont.woff2') format('woff2'), url('../fonts/barcodefont-webfont.woff') format('woff'), url('../fonts/barcodefont-webfont.ttf') format('truetype'), url('../fonts/barcodebarcodefont-webfont.svg#barcode_fontregular') format('svg');
            font-weight: normal;
            font-style: normal;
        }

        .GridView1 {
            border-collapse: collapse;
        }

            .GridView1 > tbody > tr > td {
                border: 1px solid #CCCCCC;
                margin: 0;
                padding: 0px !important;
            }

        .grid td {
            padding: 0px !important;
        }


        .clsGrid {
            overflow: inherit !important;
        }

        .clsFixWidth > tbody tr td {
            word-break: break-all;
        }

        .clsOverFlow {
            overflow: auto;
            height: 150px;
        }
    </style>
    <script type="text/javascript">
        function uploadComplete2() {

            alert("File uploaded successfully");
            //location.href = "InstallCreateProspect.aspx?ImageUpload=Yes";
            var btnImageUploadClick = document.getElementById("btnUploadSkills");
            btnUploadSkills.click();

        }

        function PrintPanel() {
            var panel = document.getElementById("<%=pnlPrint.ClientID %>");
            var printWindow = window.open('', '', 'height=400,width=500');
            printWindow.document.write('<html><head><title></title>');
            printWindow.document.write('</head><body >');
            printWindow.document.write(panel.innerHTML);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            setTimeout(function () {
                printWindow.print();
            }, 500);
            return false;
        }
    </script>

    <style type="text/css">
        .Autocomplete {
            overflow: auto;
            height: 150px;
        }

        .style1 {
            width: 451px;
        }

        .style2 {
            width: 451px;
        }

        .auto-style10 {
            width: 58px;
        }

        .auto-style11 {
            width: 100%;
        }

        .auto-style13 {
        }

        .auto-style14 {
            height: 137px;
            width: 447px;
        }

        .auto-style15 {
            width: 447px;
        }
    </style>
    <script type="text/javascript">
        function Confirm() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("User with same Email or phone number already exists. Do you want to edit user?")) {
                confirm_value.value = "Yes";
            } else {
                confirm_value.value = "No";
            }
            document.forms[0].appendChild(confirm_value);
        }
    </script>
    <script type="text/javascript">
        function movetoNext(current, nextFieldID) {
            if (current.value.length >= current.maxLength) {
                document.getElementById(nextFieldID).focus();
            }
        }

        function uploadComplete2() {
            alert("File uploaded successfully");
            var btnImageUploadClick = document.getElementById("btnUploadSkills");
            btn_UploadFiles.click();
        }
    </script>
    <style>
        /* Absolute Center Spinner */
        .ddlstatus-per-text {
            float: right;
            padding-right: 25px;
        }

        .loading {
            position: fixed;
            z-index: 999;
            height: 2em;
            width: 2em;
            overflow: show;
            margin: auto;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
        }

            /* Transparent Overlay */
            .loading:before {
                content: '';
                display: block;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.1);
            }

            /* :not(:required) hides these rules from IE9 and below */
            .loading:not(:required) {
                /* hide "loading..." text */
                font: 0/0 a;
                color: transparent;
                text-shadow: none;
                background-color: transparent;
                border: 0;
            }

                .loading:not(:required):after {
                    content: '';
                    display: block;
                    font-size: 10px;
                    width: 1em;
                    height: 1em;
                    margin-top: -0.5em;
                    -webkit-animation: spinner 1500ms infinite linear;
                    -moz-animation: spinner 1500ms infinite linear;
                    -ms-animation: spinner 1500ms infinite linear;
                    -o-animation: spinner 1500ms infinite linear;
                    animation: spinner 1500ms infinite linear;
                    border-radius: 0.5em;
                    -webkit-box-shadow: rgba(0, 0, 0, 0.75) 1.5em 0 0 0, rgba(0, 0, 0, 0.75) 1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) 0 1.5em 0 0, rgba(0, 0, 0, 0.75) -1.1em 1.1em 0 0, rgba(0, 0, 0, 0.5) -1.5em 0 0 0, rgba(0, 0, 0, 0.5) -1.1em -1.1em 0 0, rgba(0, 0, 0, 0.75) 0 -1.5em 0 0, rgba(0, 0, 0, 0.75) 1.1em -1.1em 0 0;
                    box-shadow: rgba(0, 0, 0, 0.75) 1.5em 0 0 0, rgba(0, 0, 0, 0.75) 1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) 0 1.5em 0 0, rgba(0, 0, 0, 0.75) -1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) -1.5em 0 0 0, rgba(0, 0, 0, 0.75) -1.1em -1.1em 0 0, rgba(0, 0, 0, 0.75) 0 -1.5em 0 0, rgba(0, 0, 0, 0.75) 1.1em -1.1em 0 0;
                }

        /* Animation */

        @-webkit-keyframes spinner {
            0% {
                -webkit-transform: rotate(0deg);
                -moz-transform: rotate(0deg);
                -ms-transform: rotate(0deg);
                -o-transform: rotate(0deg);
                transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
                -moz-transform: rotate(360deg);
                -ms-transform: rotate(360deg);
                -o-transform: rotate(360deg);
                transform: rotate(360deg);
            }
        }

        @-moz-keyframes spinner {
            0% {
                -webkit-transform: rotate(0deg);
                -moz-transform: rotate(0deg);
                -ms-transform: rotate(0deg);
                -o-transform: rotate(0deg);
                transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
                -moz-transform: rotate(360deg);
                -ms-transform: rotate(360deg);
                -o-transform: rotate(360deg);
                transform: rotate(360deg);
            }
        }

        @-o-keyframes spinner {
            0% {
                -webkit-transform: rotate(0deg);
                -moz-transform: rotate(0deg);
                -ms-transform: rotate(0deg);
                -o-transform: rotate(0deg);
                transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
                -moz-transform: rotate(360deg);
                -ms-transform: rotate(360deg);
                -o-transform: rotate(360deg);
                transform: rotate(360deg);
            }
        }

        @keyframes spinner {
            0% {
                -webkit-transform: rotate(0deg);
                -moz-transform: rotate(0deg);
                -ms-transform: rotate(0deg);
                -o-transform: rotate(0deg);
                transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
                -moz-transform: rotate(360deg);
                -ms-transform: rotate(360deg);
                -o-transform: rotate(360deg);
                transform: rotate(360deg);
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hidID" runat="server" />
    <input type="hidden" id="hidDesignationBeforeChange" runat="server" />
    <input type="hidden" id="hidExtEmail" runat="server" />
    <input type="hidden" id="hidExtPhone" runat="server" />
    <input type="hidden" id="hidPhoneISDCode" runat="server" /> <%--for Default Phone no. old one--%>
    <input type="hidden" id="hidTouchPointGUID" runat="server" />

    <%--<div class="loading" style="display: none">Loading&#8230;</div>--%>
    <asp:UpdatePanel ID="UpdatePanel8" runat="server">
        <ContentTemplate>
            <input type="hidden" id="hdnWorkFiles" runat="server" />
            <div class="right_panel">
                <!-- appointment tabs section start -->
                <ul class="appointment_tab">
                    <li><a href="HRReports.aspx">HR Reports</a></li>
                    <li><a href="InstallCreateUser.aspx">Create Install User</a></li>
                    <li><a href="EditInstallUser.aspx">Edit Install User</a></li>
                    <li><a href="CreateSalesUser.aspx">Create Sales-Admin_IT User</a></li>
                    <li><a href="EditUser.aspx">Edit Sales-Admin_IT User</a></li>
                </ul>
                <h1>Create Admin Sales Users
                </h1>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" Style="padding: 5px" HeaderText="Following error occurs....." ShowMessageBox="true"
                    DisplayMode="BulletList" ShowSummary="true" ValidationGroup="submit" ShowModelStateErrors="true" ShowValidationErrors="true" 
                    BackColor="Snow" ForeColor="Red" Font-Size="X-Large" Font-Italic="true"  />
                <div class="form_panel_custom">
                    <span>
                        <%--<asp:Label ID="lblmsg" runat="server" Visible="false"></asp:Label>--%>
                    </span>


                    <%--</ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddldesignation" EventName="SelectedIndexChanged" />
                </Triggers>
            </asp:UpdatePanel>--%>

                    <%--<asp:UpdatePanel ID="UpdatePanel7" runat="server">
                <ContentTemplate>--%>

                    <%--  </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                </Triggers>
            </asp:UpdatePanel>--%>


                    <%-- New code change    --%>

                    <%--<p style="font-weight: bold; font-size: large;">Basic Info: </p>--%>
                    <ul style="margin-bottom: 10px;">
                        <li style="width: 99%;">
                            <table border="0" class="tblUserData" cellspacing="0" cellpadding="0" style="margin-left: 0;">
                                <tr>
                                    <td style="text-align: center">ID#:
                                        <asp:HyperLink Font-Bold="true" Text="AXXX-XXX" NavigateUrl="#" ID="hlnkUserID" runat="server"></asp:HyperLink>
                                    </td>
                                    <td colspan="3">
                                        <label>
                                            <asp:Label ID="lblUser" runat="server" ForeColor="Black" Text="User Status"></asp:Label>
                                            <asp:Label ID="lblReqDesig" ForeColor="Red" runat="server" Text="*"></asp:Label>></label>

                                            <asp:DropDownList ID="ddlstatus" runat="server" AutoPostBack="true" Width="349px" 
                                                OnSelectedIndexChanged="ddlstatus_SelectedIndexChanged" TabIndex="502" OnPreRender="ddlstatus_PreRender">
                                           <%-- <asp:ListItem Text="<span>Referral applicant</span>" Value="ReferralApplicant"></asp:ListItem>
                                            <asp:ListItem Text="<span>Applicant</span> <span class='ddlstatus-per-text' id='ddlstatusApplicant'><img src='../Sr_App/img/yellow-astrek.png' class='fnone'>Applicant Screened : 25%</span>" Value="Applicant"></asp:ListItem>
                                            <asp:ListItem Text="Interview Date <span class='ddlstatus-per-text' id='ddlstatusInterviewDate'><img src='../Sr_App/img/purple-astrek.png' class='fnone'>Applicant Screened : 20%</span>" Value="InterviewDate"></asp:ListItem>
                                            <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem> 
                                            <asp:ListItem Text="Offer Made <span class='ddlstatus-per-text' id='ddlstatusOfferMade'><img src='../Sr_App/img/black-astrek.png' class='fnone'>New Hire : 80%</span>" Value="OfferMade"></asp:ListItem>
                                                
                                            <asp:ListItem Text="Active" Value="Active"></asp:ListItem>

                                            <asp:ListItem Text="Deactive" Value="Deactive"></asp:ListItem>--%>
                                            
                                            <%--<asp:ListItem Text="Phone/Video Screened" Value="PhoneScreened"></asp:ListItem>--%>
                                            
                                        </asp:DropDownList>                                        
                                    </td>
                                    <td colspan="3">                                        
                                        <label>Date Sourced</label>
                                        <asp:TextBox ID="txtDateSourced" runat="server" Width="239px" TabIndex="505"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <table style="margin-left:0px;">
                                            <tr>
                                                <td style="vertical-align: top; width: 220px;padding-right: 0px !important;">First Name<span><asp:Label ID="lblReqFName" Text="*" ForeColor="Green" runat="server"></asp:Label></span>
                                        <br />
                                        <asp:RequiredFieldValidator ID="rqFirstName" Display="Dynamic" runat="server" ControlToValidate="txtfirstname"
                                            ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Name"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" Display="Dynamic" runat="server" ControlToValidate="txtfirstname"
                                            ForeColor="Red" ValidationGroup="Image" ErrorMessage="Enter First Name"></asp:RequiredFieldValidator>

                                        <asp:TextBox ID="txtfirstname" Placeholder="First Name" runat="server" MaxLength="40" autocomplete="off" onkeypress="return lettersOnly(event);"
                                            EnableViewState="false" AutoCompleteType="None" OnTextChanged="txtfirstname_TextChanged" Width="130px" TabIndex="503"></asp:TextBox>

                                    </td>

                                    <td style="margin:0px;padding-right:0px !important;">
                                        <br />
                                        <asp:TextBox ID="txtMiddleInitial" Placeholder="I." runat="server" MaxLength="3" Width="10px" TabIndex="504"></asp:TextBox>
                                    </td>
                    
                                    <td style="vertical-align: top; width: 220px;">Last Name<span><asp:Label ID="lblReqLastName" Text="*" runat="server" ForeColor="Green"></asp:Label></span>
                                        <asp:RequiredFieldValidator ID="rqLastName" runat="server" ControlToValidate="txtlastname"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit" ErrorMessage="Enter Last Name"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtlastname"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="Image">Enter Last Name</asp:RequiredFieldValidator>
                                        <asp:TextBox ID="txtlastname" Placeholder="Last Name" runat="server" MaxLength="40" onkeypress="return lettersOnly(event);" autocomplete="off"
                                            OnTextChanged="txtlastname_TextChanged" Width="150px" TabIndex="505"></asp:TextBox>

                                        <br />
                                    </td>
                                        <td style="display:none;">
                                            <asp:CheckBox class="PrimaryPhoneMain" id="chkPrimaryPhoneMain" runat="server" style="color: #fff;margin-top: 18px;" />
                                        </td>
                                    <td style="padding-right: 0px !important;">Phone#<asp:Label ID="lblPhoneReq" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rqPhone" runat="server" ControlToValidate="txtPhone"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit" ErrorMessage="Enter Phone No"></asp:RequiredFieldValidator>
                                        <asp:TextBox ID="txtPhone" runat="server" MaxLength="12" onblur="CheckDuplicatePhone(this)" TabIndex="505" OnTextChanged="txtPhone_TextChanged"
                                            onkeypress="return IsNumeric(event);" Width="150"></asp:TextBox>                                        
                                    </td>
                                    <td>&nbsp;&nbsp;Ext. <%--extension--%>
                                        <br /><asp:TextBox ID="txtPhoneExt" runat="server" MaxLength="8" Width="25"></asp:TextBox></td>
                                    <td style="padding-left: 0px !important; padding-right: 0px !important;">Phone Type
                                        <asp:DropDownList ID="phoneTypeDropDownList" TabIndex="506" OnPreRender="phoneTypeDropDownList_PreRender" runat="server">                                            
                                        </asp:DropDownList>
                                    </td>
                                                <td style="padding-left: 0px !important;">
                                                    <input id="AddExtPhone" value="Add Phone" style="margin-top: 12px; height: 30px; background: url(img/main-header-bg.png) repeat-x; color: #fff;" type="button">
                                                </td>
                                                <td style="padding-right: 0px !important;margin-top: 15px;">                                                    
                                                    <asp:CheckBox class="PrimaryEmailMain" id="chkPrimaryEmailMain" runat="server" style="color: #fff;margin-top: 18px;" />
                                                </td>
                                                <td style="vertical-align: top; padding-right: 0px !important;">Email<span><asp:Label ID="lblReqEmail" Text="*" runat="server" ForeColor="Red"></asp:Label></span><br />
                                                    <asp:TextBox ID="txtemail" runat="server" MaxLength="40" OnTextChanged="txtemail_TextChanged" onblur="CheckDuplicateEmail(this)" Width="150px" TabIndex="507"></asp:TextBox><%--TabIndex="117"--%>
                                                    <asp:RequiredFieldValidator ID="rqEmail" Display="Dynamic" runat="server" ControlToValidate="txtemail"
                                                        ValidationGroup="OfferMade" ForeColor="Red" ErrorMessage="Please Enter Email"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="reEmail" ControlToValidate="txtemail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                        Display="Dynamic" runat="server" ForeColor="Red" ErrorMessage="Please Enter a valid Email"
                                                        ValidationGroup="OfferMade">
                                                    </asp:RegularExpressionValidator>
                                                </td>
                                    <td style="padding-left: 0px !important;">
                                        <input name="AddExtEmail" id="AddExtEmail" value="Add Email" style="margin-top: 12px; height: 30px; background: url(img/main-header-bg.png) repeat-x; color: #fff;" type="button">
                                    </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>                                    
                                    <td colspan="4" class="style2" style="vertical-align: top">
                                        <div style="margin-top: 10px;" class="ExtAddPhoneTemplate">
                                            <div class="PhontType"></div>
                                            <input name="RemovePhone" class="RemovePhoneBtn" value="-" id="RemovePhone" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" type="button">
                                            <input name="chkPrimaryPhone" class="PrimaryPhonechk" id="chkPrimaryPhone" style="color: #fff;" type="checkbox" onclick="SetPhoneValuefromCtlToHid();">
                                            <input type="text" name="AddedPhone" id="txtAddedPhone" class="ExtPhoneClass" maxlength="256" onkeypress="return IsNumeric(event);" onblur="CheckDuplicatePhone(this);" style="width: 150px" />
                                            <input type="text" name="AddedPhoneExt" id="AddedPhoneExt" class="ExtPhoneClassExt" maxlength="256" onkeypress="return IsNumeric(event);"  style="width: 25px" />
                                            <asp:DropDownList CssClass="ddlPhoneTypeExt" ID="ddlPhontType" AddtxtPhoneExtID="AddedPhoneExt" AddtxtPhoneID="txtAddedPhone" PhoneISDCode="us" data-dopdorcout="ddlCount" OnPreRender="ddlPhontType_PreRender" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                        <div id="container">
                                        </div>
                                    </td>
                                    <td colspan="2" style="vertical-align: top">
                                        <div style="margin-top: 10px;" class="ExtAddEmailTemplate" id="ExtAddEmailTemplate">
                                            <%--<div class="EmailType"></div>--%>
                                            <input name="RemoveEmail" class="RemovePhoneBtn" value="-" id="RemoveEmail" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" type="button">
                                            <input name="chkPrimaryEmail" class="PrimaryEmailchk" id="chkEmailPhone" style="color: #fff;" type="checkbox" onclick="SetEmailValuefromCtlToHid();">
                                            <input type="text" name="txtExtEmail" class="ExtEmailClass" value="" onblur="CheckDuplicateEmail(this)" placeholder="Email" maxlength="256" style="width: 180px" />
                                        </div>

                                        <div id="EmailContainer">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td>
                                                    Contact Preference
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="ContactPreferenceChkEmail" runat="server" Text="Email" />
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="ContactPreferenceChkCall" runat="server" Text="Call" />
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="ContactPreferenceChkText" runat="server" Text="Text" />
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="ContactPreferenceChkMail" runat="server" Text="Mail" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="1" style="vertical-align: top; ">
                                        <label>Designation<span>*</span></label>
                                        <asp:DropDownList Width="160px" ID="ddldesignation" TabIndex="508"  runat="server" ClientIDMode="Static" AutoPostBack="True" OnSelectedIndexChanged="ddldesignation_SelectedIndexChanged1">
                                            
                                        </asp:DropDownList>

                                        <asp:RequiredFieldValidator ID="rqDesignition" runat="server" ControlToValidate="ddldesignation"
                                            ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Designation"
                                            InitialValue="-1"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddldesignation"
                                            ValidationGroup="Image" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Designation"
                                            InitialValue="-1"></asp:RequiredFieldValidator>

                                        <asp:CompareValidator ID="cmpElevel" runat="server" ControlToValidate="ddldesignation"
                                            Display="Dynamic" ErrorMessage="Please Select Designation" Operator="Equal" Style="position: static"
                                            ValueToCompare="0" Width="160"></asp:CompareValidator>

                                    </td>
                                    <td colspan="2" style="vertical-align: top;">Position Applied For
                                        <asp:DropDownList Width="160" ID="ddlPositionAppliedFor" TabIndex="509" runat="server" ClientIDMode="Static" AutoPostBack="false">
                                            
                                        </asp:DropDownList>
                                    </td>
                                    <td colspan="4">

                                        <label style="text-align: right;">
                                            Source<asp:Label ID="lblSourceReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                        <asp:DropDownList ID="ddlSource" runat="server" Width="249px" TabIndex="510">
                                        </asp:DropDownList>

                                        <%--<asp:TextBox ID="txtSource" runat="server" MaxLength="40" TabIndex="108" autocomplete="off" Width="250px"></asp:TextBox>--%>
                                        <br />
                                        <label></label>
                                        <asp:TextBox ID="txtSource" runat="server" Width="140px" TabIndex="512"></asp:TextBox>
                                        &nbsp;<asp:Button runat="server" ID="btnAddSource" Text="Add" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnAddSource_Click" Height="30px" />&nbsp;
                                <asp:Button runat="server" ID="btnDeleteSource" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Text="Delete" OnClick="btnDeleteSource_Click" Height="30px" />
                                        <br />
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqSource" runat="server" ControlToValidate="ddlSource" InitialValue="0"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit">Enter Source</asp:RequiredFieldValidator><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Employee Type                                        
                                        <span>
                                            <asp:Label ID="lblReqEmpType" Text="*" ForeColor="Blue" runat="server"></asp:Label></span>
                                        <br />
                                        <asp:DropDownList ID="ddlEmpType" runat="server" Width="170px" AutoPostBack="true" OnSelectedIndexChanged="ddlEmpType_SelectedIndexChanged">
                                            <%--TabIndex="155"--%>
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Temp" Value="Temp"></asp:ListItem>
                                            <asp:ListItem Text="Internship" Value="Internship"></asp:ListItem>
                                            <asp:ListItem Text="Part Time - Remote" Value="Part Time - Remote"></asp:ListItem>
                                            <asp:ListItem Text="Part Time - Onsite" Value="Part Time - Onsite"></asp:ListItem>
                                            <asp:ListItem Text="Full Time - Remote" Value="Full Time - Remote"></asp:ListItem>
                                            <asp:ListItem Text="Full Time - Onsite" Value="Full Time - Onsite"></asp:ListItem>
                                            <asp:ListItem Text="Full Time Hourly" Value="Full Time Hourly"></asp:ListItem>
                                            <asp:ListItem Text="Full Time Salary" Value="Full Time Salary"></asp:ListItem>
                                            <asp:ListItem Text="Part Time" Value="Part Time"></asp:ListItem>
                                            <asp:ListItem Text="Sub" Value="Sub"></asp:ListItem>
                                        </asp:DropDownList>

                                        <asp:RequiredFieldValidator ID="rqEmpType" runat="server" ControlToValidate="ddlEmpType"
                                            ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Employee Type"
                                            InitialValue="0"></asp:RequiredFieldValidator>

                                    </td>
                                    <td>Start date
                                        <br />
                                        <asp:TextBox ID="txtStartDate" ClientIDMode="Static" CssClass="date" onkeypress="return false" TabIndex="513" runat="server"></asp:TextBox>
                                    </td>
                                    <td colspan="2">Salary Requirments
                                        <br />
                                        <asp:TextBox ID="txtSalaryRequirments" TabIndex="514" runat="server"></asp:TextBox>
                                        / Year
                                    </td>
                                    <td colspan="3">Zip<span><asp:Label ID="lblReqZip" runat="server" Text="*" TabIndex="515" ForeColor="Blue"></asp:Label></span>
                                        <br />
                                        <asp:TextBox ID="txtZip" runat="server" MaxLength="5" onkeypress="return IsNumeric(event);" AutoPostBack="true"
                                            OnTextChanged="txtZip_TextChanged" Width="150px" TabIndex="506"></asp:TextBox>
                                        <%--TabIndex="119"--%>
                                        <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" CompletionListElementID="auto_complete"
                                            CompletionListCssClass="Autocomplete" UseContextKey="false" CompletionInterval="200"
                                            MinimumPrefixLength="2" ServiceMethod="GetZipcodes" TargetControlID="txtZip"
                                            EnableCaching="False">
                                        </ajaxToolkit:AutoCompleteExtender>
                                        <br />
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqZip" runat="server" ControlToValidate="txtZip"
                                            Display="Dynamic" ForeColor="Red" ValidationGroup="submit">Enter Zip</asp:RequiredFieldValidator>
                                    </td>

                                </tr>
                            </table>
                        </li>
                        <li style="width: 97%;"> 
                            <div>
                                <div class="grid">
                                    <div class="clsOverFlow">
                                        <asp:GridView ID="gvTouchPointLog" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                                            HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="Black" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                                            EmptyDataText="No Touch Point log available!" CssClass="table" Width="90%" CellSpacing="0" CellPadding="0"
                                            AutoGenerateColumns="False" GridLines="Vertical" DataKeyNames="UserTouchPointLogID">
                                            <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="trHeader" />
                                            <RowStyle CssClass="FirstRow" />
                                            <AlternatingRowStyle CssClass="AlternateRow " />
                                            <Columns>
                                                <asp:TemplateField HeaderText="User Id" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <asp:HyperLink runat="server" ForeColor="Blue"
                                                            NavigateUrl='<%# Eval("UpdatedByUserID", "CreateSalesUser.aspx?id={0}") %>'
                                                            Text='<%# Eval("UpdatedUserInstallID")%>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Date & Time" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%#Eval("ChangeDateTime")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Note / Status" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <%#Eval("LogDescription")%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView> 
                                    </div>
                                </div>
                            </div>
                            <table cellspacing="0" cellpadding="0" border="1" style="width: 100%; border-collapse: collapse;margin-left:0px;">
                                    <tr >
                                        <td style="background:none">
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background:none; padding-bottom:0px;">
                                            Notes:<br />
                                            <asp:TextBox ID="txtTouchPointLogNote" runat="server" TextMode="MultiLine" Width="100%" Height="50px" CssClass="textbox"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="2" style="background:none; padding-top:0px;">
                                            <div class="btn_sec">
                                                <asp:Button ID="btnAddNote" runat="server" Text="Add Note" CssClass="ui-button" OnClick="btnAddNote_Click" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            
                            
                            <div style="float:right; font-size:large;margin-top: 15px;margin-right: 12px;">
                                <asp:LinkButton ID="lbtnAptTestLink" OnClientClick="return false" runat="server"></asp:LinkButton>
                            </div>

                            <table cellspacing="0" cellpadding="0" width="950px" border="1" style="border-collapse: collapse; display: none">
                                <tr>
                                    <td>
                                        <div class="btn_sec">
                                            <asp:Button ID="btnAddNotes" runat="server" Text="Add Notes" OnClick="btnAddNotes_Click" />
                                        </div>
                                    </td>
                                    <td>
                                        <div class="">
                                            <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                                <ContentTemplate>
                                                    <asp:TextBox ID="txtAddNotes" runat="server" TextMode="MultiLine" Height="33px" Width="407px"></asp:TextBox>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnAddNotes" />
                                                </Triggers>

                                            </asp:UpdatePanel>

                                        </div>
                                        <%--  <asp:TextBox ID="txtAddNotes" runat="server" TextMode="MultiLine" Height="33px" Width="407px"></asp:TextBox>--%>
                                    </td>
                                    <td>
                                        <span id="spanS3">
                                            <%--<label>Status</label></span>--%>
                                            <%--<asp:DropDownList ID="ddlfollowup3" AutoPostBack="false" ClientIDMode="Static" runat="server" TabIndex="4">
                        </asp:DropDownList>--%>
                                    </td>
                                </tr>
                            </table>

                            <table width="100%" style="height: 50px;" class="tblSkillMain">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">
                                        <%--<asp:Button ID="btnPlusNew" runat="server" Text="+" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnPlusNew_Click" />
                                            <asp:Button ID="btnMinusNew" runat="server" Text="-" OnClick="btnMinusNew_Click" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />--%>
                                        <input type="button" id="btnSkillAssPlusNew" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input type="button" id="btnSkillAssMinusNew" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div id="div-AdminAssess">Skill Assessment</div>
                                    </td>
                                </tr>
                            </table>

                            <table id="tblSkillAssessment" class="tblSkillAssessment">

                                <tr>
                                    <td class="auto-style15">Are you computer literate?  
                                                        <br />
                                        <br />
                                        <asp:RadioButton ID="rdoCompLitYes" runat="server" Text="Yes" GroupName="CompLit" /><%--TabIndex="188"--%>
                                        <asp:RadioButton ID="rdoCompLitNo" runat="server" Text="No" GroupName="CompLit" /><%--TabIndex="189"--%> 
                                    </td>

                                    <td class="auto-style15">What is your short term availability
                                        <br />
                                        <br />
                                        <asp:TextBox ID="txtShortTermAvail" runat="server" Width="251px"></asp:TextBox>
                                        <%--TabIndex="197"--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">FELONY or DUI charges?  
                                                        <br />
                                        <br />
                                        <asp:RadioButton ID="rdoFELONYYes" runat="server" Text="Yes" GroupName="FELONY" /><%--TabIndex="188"--%>
                                        <asp:RadioButton ID="rdoFELONYNo" runat="server" Text="No" GroupName="FELONY" /><%--TabIndex="189" --%>
                                    </td>

                                    <td class="auto-style15">Why are you the best candidate for the job?
                                        <br />
                                        <br />
                                        <asp:TextBox ID="txtWhyBest" runat="server" Width="251px"></asp:TextBox><%-- TabIndex="197"--%>
                                    </td>
                                </tr>
                                <%--<tr>
                                            <td class="auto-style15">
                                                <label>Salary Requirements</label>
                                                &nbsp;&nbsp;
                                                        <asp:TextBox ID="txtSalRequirement" onkeypress="return isNumericKey(event);" runat="server" Width="194px"></asp:TextBox>
                                            </td>
                                        </tr>--%>
                            </table>

                            <table width="100%" style="height: 50px;" class="tblRecruiterMain">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">

                                        <input type="button" id="btnRecruiterPlusNew" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input type="button" id="btnRecruiterAssMinusNew" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />

                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div id="div-RecuiterAssess">Recruiter Assesment</div>
                                    </td>
                                </tr>
                            </table>

                            <table class="tblRecruiterAssMinusNew">

                                <tr>
                                    <td class="auto-style15">What venues have you used to find talent?
                                        <br />
                                        <br />
                                        <asp:TextBox ID="txtTalentVenues" runat="server" Width="251px" TextMode="MultiLine" Height="47px"></asp:TextBox><%-- TabIndex="197"--%>
                                    </td>
                                    <td>Do you have a license? 
                                        &nbsp;&nbsp;&nbsp;
                                        <asp:RadioButton ID="rdoLicenseYes" runat="server" Text="Yes" GroupName="License" /><%--TabIndex="190" --%>
                                        <asp:RadioButton ID="rdoLicenseNo" runat="server" Text="No" GroupName="License" /><%--TabIndex="191"--%>
                                        <br />
                                        <br />
                                        <br />
                                        How many full time positions have you had in the last 5 years?
                                        
                                        <asp:TextBox ID="txtFullTimePos" onkeypress="return IsNumeric(event);" MaxLength="2" runat="server" Width="222px"></asp:TextBox>
                                    </td>
                                </tr>

                            </table>

                            <table class="tblSaleMain" width="100%" style="height: 50px;">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">

                                        <input type="button" id="btnSalesPlusNew" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input type="button" id="btnSalesAssMinusNew" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />

                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div id="div-SalesAssess">Sr Sales Assesment</div>
                                    </td>
                                </tr>
                            </table>

                            <table class="tblSalesAssesment">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <%--<tr>
                                    <td style="height: 137px;">
                                        Assessment filled out online or skill assessment attached?
                                                            <br />
                                        <br />
                                        <asp:RadioButton ID="rdoAttchmentYes" runat="server" Text="Yes" GroupName="SkillAssessment" AutoPostBack="True" OnCheckedChanged="rdoAttchmentYes_CheckedChanged" TabIndex="173" />
                                        <asp:RadioButton ID="rdoAttchmentNo" runat="server" Text="No" GroupName="SkillAssessment" AutoPostBack="True" OnCheckedChanged="rdoAttchmentNo_CheckedChanged" TabIndex="174" />
                                        <br />
                                        <br />
                                        <%--<ajaxToolkit:AsyncFileUpload ID="AsyncFileUploadCustomerAttachment" runat="server" ClientIDMode="AutoID" ThrobberID="abc"
                                    OnUploadedComplete="AsyncFileUploadCustomerAttachment_UploadedComplete" CompleteBackColor="White"
                                    Style="width: 22% !important;" OnClientUploadComplete="uploadComplete2" />%>
                                        <asp:FileUpload ID="flpSkillAssessment" runat="server" Width="277px" TabIndex="175" />
                                        &nbsp;
                                                        <asp:Button ID="btnUploadSkills" runat="server" ClientIDMode="Static" CssClass="cancel" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Text="Upload" OnClick="btnUploadSkills_Click" Height="30px" TabIndex="176" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        List (3)  general contractors, builders &/or home owners for references<br />
                                        <br />
                                        <asp:TextBox ID="txtContractor1" runat="server" TabIndex="178"></asp:TextBox>&nbsp;<asp:TextBox ID="txtContractor2" runat="server" TabIndex="179"></asp:TextBox>&nbsp;<asp:TextBox ID="txtContractor3" runat="server" TabIndex="180"></asp:TextBox>
                                        <br />

                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        Do you own truck, hand tools & power tools?<br />
                                        &nbsp;
                                                        <br />
                                        <asp:RadioButton ID="rdoTruckToolsYes" runat="server" Text="Yes" GroupName="truckTools" TabIndex="186" />
                                        <asp:RadioButton ID="rdoTruckToolsNo" runat="server" Text="No" GroupName="truckTools" TabIndex="187" />
                                        <br />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <label>
                                            Start date:</label><asp:TextBox ID="txtStartDateNew" runat="server" Width="212px" TabIndex="194"></asp:TextBox>
                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender6" TargetControlID="txtStartDateNew" runat="server"></ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Availability :</label><asp:TextBox ID="txtAvailability" runat="server" Width="210px" TabIndex="195"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Craftmanship And  Warranty policy :</label><asp:TextBox ID="txtWarrantyPolicy" runat="server" Width="210px" TabIndex="196"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        How long have you been in business? (#)Yrs<br />
                                        .<asp:TextBox ID="txtYrs" runat="server" onkeypress="return IsNumeric(event);" MaxLength="2" TabIndex="200"></asp:TextBox>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Website Address (URL)<br />
                                        <asp:TextBox ID="txtWebsiteUrl" placeholder="eg.:www.example.com" runat="server" Width="242px" TabIndex="203"></asp:TextBox>
                                        <br />
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Enter valid URL" ControlToValidate="txtWebsiteUrl" ForeColor="Red" ValidationGroup="submit" ValidationExpression="^www.[a-z]{1,15}.[a-z]{1,15}$"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Please enter all principals that apply to your company.<br />
                                        <br />
                                        <asp:TextBox ID="txtPrinciple" runat="server" TextMode="MultiLine" Width="361px" TabIndex="205" Height="94px"></asp:TextBox>
                                    </td>
                                </tr>--%>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="auto-style15">Where did you receive your construction and sales training & what formal industry certifications do you have?
                                        <br />

                                                    <asp:TextBox ID="txtConsTraining" runat="server" Width="256px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style15">Calculate 1) how many square (a.)siding,(b.)concrete& (c.)tile. 2) & perimeter… for the shapes below:
                                        <br />
                                                    Height: 22’ 1/8’’&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Height: 35’ 1/8’’   
                                        <br />
                                                    Width: 8’&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Width: 82’
                                        <br />
                                                    <br />
                                                    a.<asp:TextBox ID="aone" runat="server" Width="63px"></asp:TextBox>Perimeter=<asp:TextBox ID="txtaonetwo" runat="server" Width="99px"></asp:TextBox>
                                                    <br />
                                                    <br />
                                                    b.<asp:TextBox ID="bOne" runat="server"></asp:TextBox><br />
                                                    <br />
                                                    c.<asp:TextBox ID="cOne" runat="server"></asp:TextBox>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style15">Height: 35’ 1/8’’   
                                        <br />
                                                    Width: 82’
                                        <br />
                                                    <br />
                                                    a.<asp:TextBox ID="txtaThree" runat="server" Width="63px"></asp:TextBox>Perimeter=<asp:TextBox ID="txtaThreeTwo" runat="server" Width="99px"></asp:TextBox>
                                                    <br />
                                                    <br />
                                                    b.<asp:TextBox ID="txtbThree" runat="server"></asp:TextBox><br />
                                                    <br />
                                                    c.<asp:TextBox ID="txtcThree" runat="server"></asp:TextBox>
                                                    <br />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <%--<tr>
                                    <td class="auto-style14">How many full time positions have you had in the last 5 years?
                                                            <br />
                                        <br />
                                        <asp:TextBox ID="txtFullTimePos"  onkeypress="return IsNumeric(event);" MaxLength="2" runat="server" Width="222px" TabIndex="177"></asp:TextBox>
                                        <br />
                                        <br />
                                        <br />
                                        <br />
                                    </td>
                                </tr>--%>
                                            <%--<tr>
                                    <td class="auto-style15">
                                        Please list major tools you own for your primary trade only!
                                                        <asp:TextBox ID="txtMajorTools" runat="server" TextMode="MultiLine" Width="230px" Height="33px" TabIndex="181"></asp:TextBox>

                                        <br />

                                    </td>
                                </tr>
                                <%--<tr>
                                    <td class="auto-style15">Have you previously worked for or applied at j.m grove construction or supply? 
                                                        <br />
                                        <br />
                                        <asp:RadioButton ID="rdoJMApplyYes" runat="server" Text="Yes" GroupName="JMApply" TabIndex="188" />
                                        <asp:RadioButton ID="rdoJMApplyNo" runat="server" Text="No" GroupName="JMApply" TabIndex="189" />
                                    </td>
                                </tr>-%>
                                <tr>
                                    
                                </tr>


                                <tr>
                                    <td class="auto-style15">
                                        <label>
                                            Certification/training
                                        </label>
                                        &nbsp;<asp:FileUpload ID="flpCirtification" runat="server" Width="221px" TabIndex="201" />
                                        &nbsp;
                                                        <asp:Button ID="btnCirtification" runat="server" CssClass="cancel" with="10%" Text="Upload" Height="27px" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnCirtification_Click" OnClientClick="return ValidateFileCirtificate()" TabIndex="202" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        How long have you been doing business under your present company name? Yrs.
                                                        <asp:TextBox ID="txtCurrentComp" runat="server" onkeypress="return IsNumeric(event);" TabIndex="204" MaxLength="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        Add Employee & Partners(If Any)
                                                        <br />
                                        <br />
                                        <label>Type:</label>
                                        <asp:DropDownList ID="ddlType" runat="server" TabIndex="206" ClientIDMode="Static">
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Employee" Value="Employee"></asp:ListItem>
                                            <asp:ListItem Text="Parnter" Value="Partner"></asp:ListItem>
                                        </asp:DropDownList>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlType" InitialValue="0" ValidationGroup="type" ForeColor="Red" ErrorMessage="Select type"></asp:RequiredFieldValidator>
                                        <br />
                                        <label>
                                            Name:</label>
                                        <asp:TextBox ID="txtName" runat="server" TabIndex="207" Width="242px"></asp:TextBox>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtName" runat="server" ValidationGroup="type" ForeColor="Red" ErrorMessage="Enter name"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        <asp:Button ID="btnAddEmpPartner" TabIndex="208" runat="server" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" ValidationGroup="type" CssClass="cancel" Height="27px" Text="Add" with="10%" OnClick="btnAddEmpPartner_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        <asp:UpdatePanel ID="UpdatePanel23" runat="server">
                                            <ContentTemplate>
                                                <asp:Panel runat="server" ID="Panel5">
                                                    <div class="form_panel" style="padding-bottom: 0px; min-height: 100px;">
                                                        <div class="grid">
                                                            <%--<table id="table2" class="auto-style11">
                                    <tr>
                                        <td>-%>
                                                            <asp:GridView ID="GridView2" Width="100%" ShowHeaderWhenEmpty="true" AutoGenerateColumns="False" AllowPaging="false" HeaderStyle-BackColor="#cccccc" AllowSorting="false" runat="server">
                                                                <EmptyDataTemplate>
                                                                    No data to display
                                                                </EmptyDataTemplate>
                                                                <Columns>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Deduction For" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeductionFor" runat="server" Text='<%#Eval("PersonName")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Type" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblType" runat="server" Text='<%#Eval("PersonType")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <br />
                                                            <%--</td>
                                    </tr>
                                </table>%>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="btnAddEmpPartner" EventName="Click" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>--%>



                                            <tr>
                                                <td>Long Term Availability:
                                                        <br />
                                                    <br />
                                                    <asp:TextBox ID="txtLongTermAvail" runat="server" Width="283px"></asp:TextBox>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <label>
                                                        Resume:</label>
                                                    <asp:FileUpload ID="flpResume" runat="server" Width="221px" Height="25px" /><%--TabIndex="198"--%>
                                        &nbsp;
                                                        <asp:Button ID="btnResume" runat="server" CssClass="cancel" Width="10%" Text="Upload" Height="25px" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnResume_Click" OnClientClick="return ValidateFileOne()" /><%--TabIndex="199"--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Job Board sites you have used
                                                        <br />
                                                    <br />
                                                    <asp:TextBox ID="txtJobBoard" runat="server" Width="283px"></asp:TextBox>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>How would you source for non-traditional  blue collar craft labor that does not 
                                                <br />
                                                    use social media, has no alumni, trade shows, job fairs, etc.
                                                <br />
                                                    What would be your sourcing approach?
                                                      
                                                <br />
                                                    <asp:TextBox ID="txtNOTTraditionalAppro" TextMode="MultiLine" runat="server" Width="283px" Height="32px"></asp:TextBox>

                                                </td>
                                            </tr>

                                            <tr>
                                                <td>What are your best 3 trades you are familiar with (select 3 from drop down)<br />
                                                    <br />
                                                    <asp:DropDownList ID="ddlBestTradeOne" runat="server" Width="90px">
                                                        <%--TabIndex="178"--%>
                                                        <%--<asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Temp1" Value="Temp1"></asp:ListItem>
                                            <asp:ListItem Text="Temp2" Value="Temp2"></asp:ListItem>
                                            <asp:ListItem Text="Temp3" Value="Temp3"></asp:ListItem>--%>
                                                    </asp:DropDownList>&nbsp;
                                        <asp:DropDownList ID="ddlBestTradeTwo" runat="server" Width="90px">
                                            <%--TabIndex="179"--%>
                                            <%--<asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Temp1" Value="Temp1"></asp:ListItem>
                                            <asp:ListItem Text="Temp2" Value="Temp2"></asp:ListItem>
                                            <asp:ListItem Text="Temp3" Value="Temp3"></asp:ListItem>--%>
                                        </asp:DropDownList>&nbsp;
                                        <asp:DropDownList ID="ddlBestTradeThree" runat="server" Width="90px">
                                            <%--TabIndex="180"--%>
                                            <%--<asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Temp1" Value="Temp1"></asp:ListItem>
                                            <asp:ListItem Text="Temp2" Value="Temp2"></asp:ListItem>
                                            <asp:ListItem Text="Temp3" Value="Temp3"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Height: 20’’
                                        <br />
                                                    Base 1: 15’ Base 2: 12’<br />
                                                    <br />
                                                    a.<asp:TextBox ID="aTwo" runat="server" Width="63px"></asp:TextBox>
                                                    Perimeter=<asp:TextBox ID="txtaTwotwo" runat="server" Width="99px"></asp:TextBox>
                                                    <br />
                                                    <br />
                                                    b.<asp:TextBox ID="bTwo" runat="server"></asp:TextBox>
                                                    <br />
                                                    <br />
                                                    c.<asp:TextBox ID="cTwo" runat="server"></asp:TextBox>
                                                    <br />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>

                            <table width="99%" style="height: 50px;" id="tblBasicAssessmentMain" class="tblBasicAssessmentMain">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">
                                        <input type="button" id="btnBasicPlusNew" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input type="button" id="btnBasicAssMinusNew" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />

                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div id="div-BasicAssessment"></div>
                                    </td>
                                </tr>
                            </table>

                        </li>
                        <li style="width: 99%;">

                            <table class="tblBasicAssessment" border="0" cellspacing="0" cellpadding="0" style="margin-left: 0;">
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tr-RadioButton">Have you previously worked for J.M Grove ? &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:RadioButton Width="45px" ID="rdoJMApplyYes" runat="server" Text="Yes" GroupName="JMApply" />
                                        <asp:RadioButton Width="45px" ID="rdoJMApplyNo" runat="server" Text="No" GroupName="JMApply" />
                                        <br />

                                    </td>
                                    <td class="tr-RadioButton">Are you currently employed?&nbsp;&nbsp;&nbsp;&nbsp;
                                                
                                                <asp:RadioButton Width="45px" ID="rdoCurrentlyEmployeedYes" runat="server" Text="Yes" GroupName="rdoCrEmp" /><%--TabIndex="190"--%>
                                        <asp:RadioButton Width="45px" ID="rdoCurrentlyEmployeedNo" runat="server" Text="No" GroupName="rdoCrEmp" />
                                        <br />

                                        <%--<label>
                                                    If Yes, where?&nbsp;
                                                </label>
                                                &nbsp;<asp:TextBox ID="txtEmpWhere" runat="server" Width="175px"></asp:TextBox>--%>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <td rowspan="2">Reason for leaving your current employer/position if applicable :
                                        <br />
                                        <asp:TextBox ID="txtREasonChange" runat="server" Width="330px" MaxLength="50"  Height="43px" onkeyDown="checkTextAreaMaxLength(this,event,'50');" TextMode="MultiLine"></asp:TextBox>
                                        <div id="textarea_CharCount"></div>
                                    </td>
                                    <td class="tr-RadioButton">Will you be able to pass a drug test and background check ?&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:RadioButton Width="45px" Style="padding-top: 0px" ID="rdoDrugtestYes" runat="server" Text="Yes" GroupName="drugTest" />
                                        <asp:RadioButton Width="45px" Style="padding-top: 0px" ID="rdoDrugtestNo" runat="server" Text="No" GroupName="drugTest" />
                                    </td>
                                </tr>
                                <tr>

                                    <td class="tr-RadioButton">Have you ever plead guilty to a felony or convicted of a crime?&nbsp;&nbsp;&nbsp;&nbsp;                    
                                        <asp:RadioButton ID="rdoGuiltyYes" Width="45px" runat="server" Text="Yes" GroupName="Guilty" TabIndex="192" />
                                        <asp:RadioButton ID="rdoGuiltyNo" Width="45px" runat="server" Text="No" GroupName="Guilty" TabIndex="193" />
                                    </td>
                                    
                                </tr>
                            </table>
                        </li>
                    </ul>

                    <%-- new code --%>


                    <%--New Hire , Fingure Print Report -- START--%>

                    <asp:Panel ID="pnlAll" runat="server">
                        <ul style="overflow: hidden; margin-bottom: 10px;">
                            <li style="width: 100%;">
                                <table width="100%" id="tblMainNewHire" style="height: 30px;">
                                    <tr>
                                        <td class="auto-style10" style="width: 60px;">
                                            <input type="button" id="btnNewHirePluse" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                            <input type="button" id="btnNewHireMinus" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        </td>
                                        <td style="font-weight: bold; font-size: large">New Hire</td>
                                    </tr>
                                </table>
                            </li>
                            <li style="width: 49%;">
                                <asp:Panel ID="pnlnewHire" runat="server">
                                    <table border="0" class="tblNewHire" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="height: 50px;">
                                                <label>
                                                    Hire Date<span><asp:Label ID="lblReqHireDate" runat="server" Text="*" ForeColor="Blue"></asp:Label></span></label>
                                                <asp:TextBox ID="txtHireDate" Enabled="false" runat="server" Width="231px"></asp:TextBox><%-- TabIndex="151"--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" TargetControlID="txtHireDate" runat="server"></ajaxToolkit:CalendarExtender>
                                                <br />
                                                <asp:RequiredFieldValidator ID="rqHireDate" runat="server" ControlToValidate="txtHireDate"
                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Enter Hire Date"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Workers Comp Code<span><asp:Label ID="lblReqWWC" Text="*" runat="server" ForeColor="Blue"></asp:Label></span></label>
                                                <asp:DropDownList ID="ddlWorkerCompCode" runat="server" Width="251px">
                                                    <%--TabIndex="153"--%>
                                                    <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="0951    Salesperson – Outside" Value="0951    Salesperson – Outside"></asp:ListItem>
                                                    <asp:ListItem Text="0953    Office" Value="0953    Office"></asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqWorkCompCode" runat="server" ControlToValidate="ddlWorkerCompCode"
                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Worker Comp Code"
                                                    InitialValue="0"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Pay Rates<span><asp:Label ID="lblReqPayRates" Text="*" ForeColor="Blue" runat="server"></asp:Label></span> $</label>
                                                <asp:TextBox ID="txtPayRates" runat="server" MaxLength="40" autocomplete="off"
                                                    EnableViewState="false" AutoCompleteType="None" Width="242px" onkeypress="return isNumericKey(event);"></asp:TextBox><%--TabIndex="157"--%>
                                                <br />
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqPayRate" Display="Dynamic" runat="server" ControlToValidate="txtPayRates"
                                                    ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Pay Rate"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblPaySource" runat="server" Text="Pay Source" Font-Bold="True"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:RadioButton ID="rdoCheque" runat="server" AutoPostBack="true" GroupName="paymethod" Text="Check" OnCheckedChanged="rdoCheque_CheckedChanged" Checked="True" /><%--TabIndex="166" --%>
                                                <asp:RadioButton ID="rdoDeposite" runat="server" GroupName="paymethod" Text="Direct Deposite" OnCheckedChanged="rdoDeposite_CheckedChanged" AutoPostBack="True" /><%-- TabIndex="167"--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    <asp:Label ID="lblAba" runat="server" ForeColor="Black">
                                                            ABA Routing #</asp:Label>
                                                </label>
                                                <asp:TextBox ID="txtRoutingNo" runat="server" MaxLength="40" autocomplete="off"
                                                    EnableViewState="false" onkeypress="return IsNumeric(event);" AutoCompleteType="None" Width="242px"></asp:TextBox><%--TabIndex="168"--%>
                                                <br />
                                                <label></label>
                                                <asp:RequiredFieldValidator ID="rqRoutingNo" Display="Dynamic" runat="server" ControlToValidate="txtRoutingNo"
                                                    ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Routing No."></asp:RequiredFieldValidator>
                                                <br />
                                                <label></label>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%--<asp:UpdatePanel ID="UpdatePanel15" UpdateMode="Always" runat="server">
                                                            <ContentTemplate>--%>
                                                <label>
                                                    <asp:Label ID="lblAccount" runat="server" ForeColor="Black">
                                                            Account #</asp:Label>
                                                </label>
                                                <asp:TextBox ID="txtAccountNo" runat="server" MaxLength="40" autocomplete="off"
                                                    EnableViewState="false" onkeypress="return IsNumeric(event);" AutoCompleteType="None" Width="242px"></asp:TextBox><%--TabIndex="169"--%>
                                                <br />
                                                <label></label>
                                                <asp:RequiredFieldValidator ID="rqAccountNo" Display="Dynamic" runat="server" ControlToValidate="txtAccountNo"
                                                    ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Account No."></asp:RequiredFieldValidator>
                                                <%--</ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="rdoDeposite" EventName="CheckedChanged" />
                                                                <asp:AsyncPostBackTrigger ControlID="rdoCheque" EventName="CheckedChanged" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                                <br />
                                                <label></label>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%--<asp:UpdatePanel ID="UpdatePanel16" runat="server" UpdateMode="Always">
                                                            <ContentTemplate>--%>
                                                <label>
                                                    <asp:Label ID="lblAccountType" runat="server" ForeColor="Black">
                                                            Account Type</asp:Label>
                                                </label>
                                                <asp:TextBox ID="txtAccountType" runat="server" MaxLength="40" autocomplete="off"
                                                    EnableViewState="false" AutoCompleteType="None" Width="242px"></asp:TextBox>
                                                <%--TabIndex="170"--%>
                                                <br />
                                                <label></label>
                                                <asp:RequiredFieldValidator ID="rqAccountType" Display="Dynamic" runat="server" ControlToValidate="txtAccountType"
                                                    ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Account Account Type"></asp:RequiredFieldValidator>
                                                <%--</ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="rdoDeposite" EventName="CheckedChanged" />
                                                                <asp:AsyncPostBackTrigger ControlID="rdoCheque" EventName="CheckedChanged" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                                <br />
                                                <label></label>

                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </li>

                            <li style="width: 49%;">
                                <asp:Panel ID="pnlNew2" runat="server">
                                    <table border="0" class="tblNewHire" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="height: 50px;">
                                                <label>
                                                    Termination Date/Reason<asp:Label ID="lblTermination" runat="server" ForeColor="Red" Text="*"></asp:Label></label>
                                                <asp:TextBox ID="dtResignation" runat="server" Width="222px"></asp:TextBox><%--TabIndex="152"--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender3" TargetControlID="dtResignation" runat="server"></ajaxToolkit:CalendarExtender>
                                                <br />
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqdtResignition" runat="server" ControlToValidate="dtResignation"
                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter Resignition Date"></asp:RequiredFieldValidator>

                                                <asp:CompareValidator ID="CompareValidator1" ValidationGroup="submit" Type="Date" Operator="GreaterThanEqual" Display="Dynamic" ControlToValidate="dtResignation" ControlToCompare="txtHireDate" runat="server" ForeColor="Red" ErrorMessage="Termination date should be greater than hire date."></asp:CompareValidator>


                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <label>
                                                    Next Review Date<asp:Label ID="lblNextReviewDate" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                                <asp:TextBox ID="dtReviewDate" runat="server" Width="230px"></asp:TextBox><%--TabIndex="154"--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender4" TargetControlID="dtReviewDate" Enabled="true" runat="server"></ajaxToolkit:CalendarExtender>
                                                <br />
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqDtNewReview" runat="server" ControlToValidate="dtReviewDate"
                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter New Review Date"></asp:RequiredFieldValidator>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <label>
                                                    Last Review Date<asp:Label ID="lblLastReview" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                                <asp:TextBox ID="dtLastDate" runat="server" Width="238px"></asp:TextBox><%--TabIndex="156"--%>
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender5" TargetControlID="dtLastDate" runat="server"></ajaxToolkit:CalendarExtender>
                                                <br />
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqLastReviewDate" runat="server" ControlToValidate="dtLastDate"
                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter LastReview Date"></asp:RequiredFieldValidator>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <%--<asp:UpdatePanel ID="UpdatePanel19" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>--%>
                                                <label>
                                                    Extra Earnings</label>
                                                <asp:DropDownList ID="ddlExtraEarning" runat="server" Width="110px">
                                                    <%--TabIndex="158"--%>
                                                    <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Test" Value="Test"></asp:ListItem>
                                                    <asp:ListItem Text="Test2" Value="Test2"></asp:ListItem>
                                                </asp:DropDownList>

                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <label style="width: 2%;">
                                    $</label>
                                                <asp:TextBox ID="txtExtraIncome" runat="server" onkeypress="return IsNumeric(event);" Width="75"></asp:TextBox>
                                                <%--TabIndex="159"--%>
                                                <br />
                                                <label></label>
                                                <asp:RequiredFieldValidator ID="rqExtraEarnings" runat="server" ControlToValidate="ddlExtraEarning"
                                                    ValidationGroup="SubmitNew" ForeColor="Red" Display="Dynamic" ErrorMessage="Select Extra Earning Type"
                                                    InitialValue="0"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator ID="rqExtraEarningAmt" runat="server" ControlToValidate="txtExtraIncome"
                                                    ValidationGroup="SubmitNew" ForeColor="Red" Display="Static" ErrorMessage="Enter Extra Earning"></asp:RequiredFieldValidator>
                                                <br />
                                                <label>
                                                    <asp:Label ID="lblExtraEarning" ForeColor="Black" runat="server"> Extra Earnings</asp:Label></label>
                                                <label>
                                                    <asp:Label ID="lblExtra" ForeColor="Black" runat="server"></asp:Label>
                                                </label>
                                                <label style="width: 3%;">
                                                    <asp:Label ID="lblExtraDollar" ForeColor="Black" runat="server">&amp;</asp:Label>
                                                </label>
                                                <label>
                                                    &nbsp;&nbsp;&nbsp;
                                                                <asp:Label ID="lblDoller" ForeColor="Black" runat="server"></asp:Label></label>
                                                <br />
                                                <label>
                                                </label>
                                                <%--            </ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="btnAddExtraIncome" EventName="Click" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <asp:Button ID="btnAddExtraIncome" ValidationGroup="SubmitNew" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" runat="server" Text="Add" Height="28px" Width="55px" OnClick="btnAddExtraIncome_Click" /><%--TabIndex="160" --%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <%--<asp:UpdatePanel ID="UpdatePanel17" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>--%>
                                                <label>
                                                    Deduction: $</label>
                                                <asp:TextBox ID="txtDeduction" runat="server" onkeypress="return IsNumeric(event);" Width="113px"></asp:TextBox>
                                                <%--TabIndex="161"--%>
                                                                &nbsp;
                                                        <label style="width: 45px;">
                                                            Reason</label>
                                                <asp:TextBox ID="txtDeducReason" runat="server" Width="113px"></asp:TextBox><%-- TabIndex="162"--%>
                                                                &nbsp;
                                                            <%--</ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="btnAddType" EventName="Click" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                                <label>
                                                </label>
                                                <asp:RequiredFieldValidator ID="rqDeductionAmt" Display="Static" runat="server" ControlToValidate="txtDeduction"
                                                    ForeColor="Red" ValidationGroup="Add" ErrorMessage="Enter Deduction"></asp:RequiredFieldValidator>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:RequiredFieldValidator ID="rqDeduction" Display="Static" runat="server" ControlToValidate="txtDeducReason"
                                                            ForeColor="Red" ValidationGroup="Add" ErrorMessage="Enter Deduction Reason"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <asp:RadioButton ID="rdoOneTime" runat="server" GroupName="Deduction" Text="One Time" Checked="True" />
                                                <%--TabIndex="163"--%>
                                                <asp:RadioButton ID="rdoReoccurance" runat="server" GroupName="Deduction" Text="Re-Occurance" />
                                                <%--TabIndex="164" --%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <%--<asp:UpdatePanel ID="UpdatePanel18" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>--%>
                                                <asp:Button ID="btnAddType" runat="server" Height="28px" OnClick="btnAddType_Click" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Text="Add" ValidationGroup="Add" Width="55px" /><%--TabIndex="165" --%>
                                                <%--</ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="btnAddType" EventName="Click" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style15">
                                                <%--<asp:UpdatePanel ID="UpdatePanel20" runat="server">
                                                            <ContentTemplate>--%>
                                                <asp:Panel runat="server" ID="Panel1">
                                                    <div class="form_panel" style="padding-bottom: 0px; min-height: 100px;">
                                                        <div class="grid">
                                                            <%--<table id="table2" class="auto-style11">
                                    <tr>
                                        <td>--%>
                                                            <asp:GridView ID="GridView1" Width="100%" ShowHeaderWhenEmpty="true" AutoGenerateColumns="False" AllowPaging="false" HeaderStyle-BackColor="#cccccc" AllowSorting="false" runat="server">
                                                                <EmptyDataTemplate>
                                                                    No data to display
                                                                </EmptyDataTemplate>
                                                                <Columns>

                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Deduction For" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeductionFor" runat="server" Text='<%#Eval("DeductionFor")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Type" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Amount" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblAmount" runat="server" Text='<%#Eval("Amount")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <br />
                                                            <%--</td>
                                    </tr>
                                </table>--%>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                                <%--  </ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="btnAddType" EventName="Click" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </li>

                            <li style="width: 99%;">
                                <table id="table1" class="tblNewHire">
                                    <tr>
                                        <td colspan="4" style="font-weight: bold">Fingure Print Report</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>Benifit Rate</td>
                                        <td>Available Days</td>
                                        <td>Used Days</td>
                                    </tr>
                                    <tr>
                                        <td>Personal Days</td>
                                        <td>
                                            <asp:TextBox ID="txtPDBR" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPDAD" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPDUD" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Sick Days</td>
                                        <td>
                                            <asp:TextBox ID="txtSDBR" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSDAD" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSDUD" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Vacation Days</td>
                                        <td>
                                            <asp:TextBox ID="txtVDBR" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtVDAD" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtVDUD" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Holidays</td>
                                        <td>
                                            <asp:TextBox ID="txtHDBR" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtHDAD" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtHDUD" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="4">
                                            <br />
                                            <%--Following Grid is not in Used. --%>
                                            <asp:Panel runat="server" ID="pnlGrid">
                                                <div class="form_panel" style="padding-bottom: 0px; min-height: 100px;">
                                                    <div class="grid">
                                                        <asp:GridView ID="gvYtd" Width="95%" ShowHeaderWhenEmpty="true" AutoGenerateColumns="False" AllowPaging="false" HeaderStyle-BackColor="#cccccc" AllowSorting="false" runat="server">
                                                            <EmptyDataTemplate>
                                                                No data to display
                                                            </EmptyDataTemplate>
                                                            <Columns>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Pay Period" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblPayPeriod" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Net Amount" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblNetAmount" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Fedral Income Tax" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblFedralTax" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="State Income Tax" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblStateTax" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="SS Tax" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblSSTax" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Mdicare" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblMedicare" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Deduction" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblDeduction" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="True" HeaderText="Gross Pay" ControlStyle-ForeColor="Black"
                                                                    ItemStyle-HorizontalAlign="Center">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblGrossPay" runat="server" Text=""></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ControlStyle ForeColor="Black" />
                                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                        <br />
                                                        <br />
                                                        <label>
                                                            YTD :
                                                        </label>
                                                        <br />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </td>

                                    </tr>
                                </table>
                            </li>

                        </ul>

                    </asp:Panel>

                    <ul style="overflow-x: hidden; margin-bottom: 10px;">
                        <li style="width: 100%;">
                            <%--<asp:UpdatePanel ID="UpdatePanel6" runat="server">
                        <ContentTemplate>--%>
                            <asp:Panel ID="pnlFngPrint" runat="server">
                                --
                            </asp:Panel>
                            <%--</ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>--%>
                        </li>
                    </ul>



                    <%--New Hire , Fingure Print Report -- END--%>
                    <ul style="margin-bottom: 10px;">
                        <li style="width: 99%;">

                            <table width="99%" style="height: 50px;" id="tblBasicAssessmentMain" class="tblBasicAssessmentMain">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">
                                        <input type="button" id="btnBasicPlusNew" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input type="button" id="btnBasicAssMinusNew" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />

                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div id="div-BasicAssessment"></div>
                                    </td>
                                </tr>
                            </table>

                            <table width="98%" style="height: 50px; max-width:1000px;">
                                <tr>
                                    <td class="auto-style10" style="width: 60px;">
                                        <input id="btnGeneralPlus" class="formCtrl" type="button" value="+" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                        <input id="btnGeneralMinus" class="formCtrl" type="button" value="-" style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />

                                    </td>
                                    <td style="font-weight: bold; font-size: large">
                                        <div>General Contact Info Confirmation </div>
                                    </td>
                                </tr>
                            </table>

                            <table border="0" class="tblGeneral" cellspacing="0" cellpadding="0" style="margin-left: 11px;">
                                <tr>
                                    <td>Company Email
                                            <br />
                                        <asp:TextBox ID="txtCompanyEmail" runat="server"></asp:TextBox>
                                    </td>
                                    <td colspan="1">
                                        <div style="float: left">
                                            <label style="display: none;">
                                                Password<asp:Label ID="lblPassReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                            Password<br />
                                            <asp:TextBox ID="txtpassword" runat="server" TextMode="Password" MaxLength="30" TabIndex="525"
                                                autocomplete="off" Width="242px"></asp:TextBox>
                                            <br />
                                            <label>
                                            </label>
                                            <asp:RequiredFieldValidator ID="rqPass" runat="server" ControlToValidate="txtpassword"
                                                ValidationGroup="OfferMade" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Enter Password"></asp:RequiredFieldValidator>
                                        </div>

                                        <div style="float: right">
                                            <label style="display: none;">
                                                Confirm Password<asp:Label ID="lblConfirmPass" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                            Confirm Password<br />
                                            <asp:TextBox ID="txtpassword1" runat="server" TextMode="Password" autocomplete="off"
                                                MaxLength="30" EnableViewState="false" AutoCompleteType="None" Width="242px" TabIndex="526"></asp:TextBox>
                                            <br />
                                            <label>
                                            </label>
                                            <asp:CompareValidator ID="password" runat="server" ControlToValidate="txtpassword1"
                                                Display="Dynamic" ControlToCompare="txtpassword" ForeColor="Red" ErrorMessage="Password didn't matched"
                                                ValidationGroup="OfferMade">
                                            </asp:CompareValidator>
                                            <asp:RequiredFieldValidator ID="rqConPass" runat="server" ControlToValidate="txtpassword1"
                                                ForeColor="Red" ValidationGroup="OfferMade" ErrorMessage="Enter Confirm Password"></asp:RequiredFieldValidator>

                                        </div>

                                    </td>

                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td style="width: 48%; vertical-align: top">
                                                    <table>
                                                        <tr>
                                                            <td>

                                                                <label style="display: none">
                                                                    Home Address<asp:Label ID="lblAddressReq" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                                                </label>
                                                                Home Address
                                                                    <br />
                                                                <asp:TextBox ID="txtaddress" runat="server" TextMode="MultiLine" Height="40px" Width="242px" onkeyup="sync()"
                                                                    TabIndex="516" OnTextChanged="txtaddress_TextChanged" AutoPostBack="true"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
															Zip
                                                                    <br />
                                                                <asp:TextBox ID="txtZipHomeAdd" Width="240" runat="server" onkeypress="return IsNumeric(event);" AutoPostBack="true" OnTextChanged="txtZip_TextChanged"></asp:TextBox>

                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    State
                                                                    <asp:Label ID="lblStateReq" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                                                </label>
                                                                <br />
                                                                <asp:TextBox ID="txtState" runat="server" MaxLength="40" onkeypress="return lettersOnly(event);" OnTextChanged="txtState_TextChanged" Width="242px" TabIndex="509"></asp:TextBox>
                                                                <br />
                                                                <label></label>
                                                                <asp:RequiredFieldValidator ID="rqState" runat="server" ControlToValidate="txtState"
                                                                    Display="Dynamic" ForeColor="Red" ValidationGroup="submit">Enter State</asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label>
                                                                    City
                                                                    <asp:Label ID="lblCityReq" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                                                </label>
                                                                <br />
                                                                <asp:TextBox ID="txtCity" runat="server" MaxLength="40" onkeypress="return lettersOnly(event);" OnTextChanged="txtCity_TextChanged" Width="242px" TabIndex="510"></asp:TextBox>
                                                                <br />
                                                                <label></label>
                                                                <asp:RequiredFieldValidator ID="rqCity" runat="server" ControlToValidate="txtCity"
                                                                    Display="Dynamic" ForeColor="Red" ValidationGroup="submit">Enter City</asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
															Country
                                                                    <br />                                                                  
                                                                <div style="padding-left: 5px; padding: 2px 5px 2px 5px;">
                                                                    <div id="dvFlag" style="background-image: url(img/flags24.png); background-repeat: no-repeat; float: left; height: 24px; width: 24px;margin-top: 2px;" class="in"></div>
                                                                    <asp:DropDownList ID="ddlCountry" Width="315" runat="server"></asp:DropDownList>
                                                                    <%--<select style="width: 250px; border-color: gray; border: none" onchange="changeFlag()" onkeypress="changeFlag()" id="CountryList">--%>
                                                                    </select>
                                                                </div>
                                                                
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
															Suite/Apt/Room(If applicable)
                                                                    <br />
                                                                <asp:TextBox ID="txtSuiteAptRoom" runat="server" MaxLength="5" TextMode="SingleLine" Width="240px"
                                                                    TabIndex="519"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <%-- <label>Date of Birth<span><asp:Label ID="lblReqDOB" runat="server" Text="*" ForeColor="Red"></asp:Label></span></label>--%>
                                                                    Date of Birth
                                                                    <br />
                                                                <asp:TextBox ID="DOBdatepicker" ClientIDMode="Static" runat="server" Width="242px"
                                                                    TabIndex="527" onkeypress="return false" OnTextChanged="DOBdatepicker_TextChanged"></asp:TextBox>

                                                                <br />
                                                                <asp:RequiredFieldValidator ID="rqDOB" runat="server" ControlToValidate="DOBdatepicker"
                                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter Date of Birth"></asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>

                                                    </table>
                                                </td>
                                                <td style="vertical-align: top;">
                                                    <table class="tblGen-Secon">
                                                        <tr>
                                                            <td>
                                                                <label style="display: none">
                                                                    &nbsp;
                                    <asp:Label ID="Label1" runat="server" Text="*" ForeColor="Blue"></asp:Label>

                                                                </label>
                                                                Secondary Address
                                                                    <br />
                                                                <asp:TextBox ID="txtMailingAddress" runat="server" TextMode="MultiLine" Height="40px" Width="242px"
                                                                    TabIndex="517"></asp:TextBox>

                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtMailingAddress"
                                                                    ForeColor="Blue" Display="Dynamic" ValidationGroup="submit">Enter Mailing Address</asp:RequiredFieldValidator><br />

                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Zip
                                                                    <br />
                                                                <asp:TextBox ID="txtZipSecAdd" Width="240" runat="server" onkeypress="return IsNumeric(event);"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>State
                                                                    <br />
                                                                <asp:TextBox ID="txtStateSecAdd" runat="server" MaxLength="40" Width="242px" TabIndex="509"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>City
                                                                    <br />
                                                                <asp:TextBox ID="txtCitySecAdd" runat="server" MaxLength="40" Width="242px" TabIndex="510"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Suite/Apt/Room(If applicable)
                                                                    <br />
                                                                <asp:TextBox ID="txtSuteAptRoomSecAdd" runat="server" MaxLength="5" TextMode="SingleLine" Width="240px"
                                                                    TabIndex="519"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>

                                                                <label>
                                                                    SSN<asp:Label ID="lblReqSSN" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                                                <asp:TextBox ID="txtssn" runat="server" MaxLength="3" TabIndex="524"
                                                                    onkeypress="return isNumericKey(event);" OnTextChanged="txtssn_TextChanged" Width="30px"></asp:TextBox>
                                                                -<asp:TextBox ID="txtssn0" runat="server" MaxLength="2" TabIndex="525"
                                                                    onkeypress="return isNumericKey(event);" OnTextChanged="txtssn0_TextChanged"
                                                                    Width="30px"></asp:TextBox>
                                                                -<asp:TextBox ID="txtssn1" runat="server" MaxLength="4" TabIndex="526"
                                                                    onkeypress="return isNumericKey(event);" OnTextChanged="txtssn1_TextChanged"
                                                                    Width="30px"></asp:TextBox>
                                                                <br />
                                                                <label></label>
                                                                <asp:RequiredFieldValidator ID="rqSSN1" runat="server" ControlToValidate="txtssn"
                                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter Complete SSN"></asp:RequiredFieldValidator>
                                                                <asp:RequiredFieldValidator ID="rqSSN2" runat="server" ControlToValidate="txtssn0"
                                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter Complete SSN"></asp:RequiredFieldValidator>
                                                                <asp:RequiredFieldValidator ID="rqSSN3" runat="server" ControlToValidate="txtssn1"
                                                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Enter Complete SSN"></asp:RequiredFieldValidator>

                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <input name="AddExtEmail" id="AddGeneralAddress." value="Add Address" style="margin-top: 12px; height: 30px; background: url(img/main-header-bg.png) repeat-x; color: #fff;" type="button">
                                    </td>
                                </tr>
                            </table>


                        </li>

                    </ul>
                    <ul style="margin-bottom: 10px;">
                        <li style="width: 49%;">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <label>
                                            <asp:Label ID="lblInstallerType" ForeColor="Black" runat="server" Text="Installer Type"></asp:Label></label>
                                        <asp:DropDownList ID="ddlInstallerType" runat="server" Width="252px">
                                            <%--TabIndex="106"--%>
                                            <asp:ListItem Text="Foreman" Value="Foreman"></asp:ListItem>
                                            <asp:ListItem Text="Journeyman" Value="Journeyman"></asp:ListItem>
                                            <asp:ListItem Text="Labor" Value="Labor"></asp:ListItem>
                                            <asp:ListItem Text="Lead Mechanic" Value="Lead Mechanic"></asp:ListItem>
                                            <asp:ListItem Text="Mechanic" Value="Mechanic"></asp:ListItem>
                                            <asp:ListItem Text="Sub-contractor" Value="Sub-contractor"></asp:ListItem>
                                        </asp:DropDownList>
                                        <%--</ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddldesignation" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                    </td>
                                </tr>
                                <%--<tr>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                    <ContentTemplate>
                                        <label>
                                            Primary Trade<span>*</span></label>
                                        <asp:DropDownList ID="ddlPrimaryTrade" runat="server" Width="251px" TabIndex="107" AutoPostBack="true" OnSelectedIndexChanged="ddlPrimaryTrade_SelectedIndexChanged"></asp:DropDownList>
                                        <br />
                                        <label>
                                        </label>
                                        <asp:TextBox ID="txtOtherTrade" runat="server" Width="238px" TabIndex="108"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <br />
                                <label></label>
                                <asp:RequiredFieldValidator ID="rqPrimaryTrade" runat="server" ControlToValidate="ddlPrimaryTrade"
                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Primary Trade"
                                    InitialValue="0"></asp:RequiredFieldValidator>

                            </td>
                        </tr>--%>
                                <%--<tr>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                                    <ContentTemplate>
                                        <label>
                                            SecondaryTrade<span>*</span></label>

                                        <asp:DropDownList ID="ddlSecondaryTrade" runat="server" AutoPostBack="true" Width="249px" TabIndex="110" OnSelectedIndexChanged="ddlSecondaryTrade_SelectedIndexChanged"></asp:DropDownList>
                                        <br />
                                        <label>
                                        </label>
                                        <asp:TextBox ID="txtSecTradeOthers" runat="server" Width="233px" TabIndex="111"></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <br />
                                <label></label>
                                <asp:RequiredFieldValidator ID="rqSecondaryTrade" runat="server" ControlToValidate="ddlSecondaryTrade"
                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select Secondary Trade"
                                    InitialValue="0"></asp:RequiredFieldValidator>

                            </td>
                        </tr>--%>


                                <%--<tr>
                            <td class="style2">
                                <label>
                                    ConfirmPassword<asp:Label ID="lblConfirmPass" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                <asp:TextBox ID="txtpassword1" runat="server" TextMode="Password" autocomplete="off"
                                    MaxLength="30"  EnableViewState="false" AutoCompleteType="None" Width="242px" TabIndex="513"></asp:TextBox>
                                <br />
                                <label>
                                </label>
                                <asp:CompareValidator ID="password" runat="server" ControlToValidate="txtpassword1"
                                    Display="Dynamic" ControlToCompare="txtpassword" ForeColor="Red" ErrorMessage="Password didn't matched"
                                    ValidationGroup="submit">
                                </asp:CompareValidator>
                                <asp:RequiredFieldValidator ID="rqConPass" runat="server" ControlToValidate="txtpassword1"
                                    ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Confirm Password"></asp:RequiredFieldValidator>
                            </td>
                        </tr>--%>

                                <%-- <tr>
                            <td>
                                <label>
                                    Business Name <span></span>
                                </label>
                                <asp:TextBox ID="txtBusinessName" runat="server" MaxLength="40" TabIndex="124" autocomplete="off"
                                    EnableViewState="false" AutoCompleteType="None" OnTextChanged="txtBusinessName_TextChanged" Width="250px"></asp:TextBox>
                            </td>
                        </tr>--%>
                                <tr>
                                    <td>
                                        <%--<asp:UpdatePanel ID="UpdatePanel11" runat="server">
                                    <ContentTemplate>--%>
                                        <label>
                                            <asp:Label ID="lblSignature" ForeColor="Black" runat="server">
                                    Signature</asp:Label><asp:Label ID="lblReqSig" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                        <asp:TextBox ID="txtSignature" runat="server" MaxLength="40" TabIndex="535" autocomplete="off"
                                            EnableViewState="false" AutoCompleteType="None" OnTextChanged="txtSignature_TextChanged" Width="242px"></asp:TextBox>
                                        <%--</ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddldesignation" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                        <label></label>
                                        <asp:RequiredFieldValidator ID="rqSign" runat="server" ControlToValidate="txtSignature"
                                            ForeColor="Red" ValidationGroup="submit" ErrorMessage="Enter Signature"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        <%-- <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                                    <ContentTemplate>--%>
                                        <label>
                                            <asp:Label runat="server" ForeColor="Black" ID="lblStatus">
                                    Marital Status</asp:Label><asp:Label ID="lblReqMarSt" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                        </label>
                                        <asp:DropDownList ID="ddlmaritalstatus" runat="server" Width="250px" TabIndex="517"
                                            OnSelectedIndexChanged="ddlmaritalstatus_SelectedIndexChanged">
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Married" Value="Married"></asp:ListItem>
                                            <asp:ListItem Text="Single" Value="Single"></asp:ListItem>
                                        </asp:DropDownList>
                                        <%--                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddldesignation" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqMaritalStatus" runat="server" ControlToValidate="ddlmaritalstatus"
                                            InitialValue="0" ForeColor="Red" ValidationGroup="submit" ErrorMessage="Please select Marital Status"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Picture
                                            <span>
                                                <asp:Label ID="lblReqPicture" runat="server" Text="*" ForeColor="Red" Style="margin-top: -14px; margin-left: 63px"></asp:Label>
                                            </span>
                                        </label>

                                        <%--<ajaxToolkit:AsyncFileUpload ID="flpUplaodPicture" runat="server" TabIndex="518" ClientIDMode="AutoID"
                                            Width="88%" OnClientUploadStarted="" />
                                        <asp:Button ID="btn_UploadPicture" runat="server" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btn_UploadPicture_Click"
                                            Width="10%" OnClientClick="return CheckFileExistence()" ValidationGroup="Image" Text="Upload" /><%--TabIndex="140"--%>
                                        &nbsp;&nbsp;
                                        
                                        <%------ UPLOAD STARTED -------%><div id="divUploadUserProfilPic" style="width: 250px;" class="dropzone work-file dropzonJgStyle">
                                            <div class="fallback">
                                                <input name="WorkFile" type="file" multiple />
                                                <%--<input type="submit" value="Upload Profile Picture" />--%>
                                            </div>
                                        </div>
                                        <div id="divWorkFileAdminPreview" class="dropzone-previews work-file-previews">
                                        </div>

                                        <%------ UPLOAD END -------%>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%--<asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                    <ContentTemplate>--%>
                                        <label>
                                            DL License<span><asp:Label ID="lblReqDL" runat="server" Text="*" ForeColor="Red" Style="margin-top: -14px; margin-left: 63px"></asp:Label></span></label>
                                        <%--    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                        <%--<asp:UpdatePanel ID="UpdatePanel3" runat="server" >
                                    <ContentTemplate>--%>
                                        <br />
                                        <asp:FileUpload ID="flpPqLicense" MaxLength="40" runat="server" class="multi" Width="50%"
                                            TabIndex="520" />
                                        <asp:Button ID="btnPqLicense" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" runat="server" CssClass="cancel"
                                            Width="10%" Text="Upload" OnClick="btnPqLicense_Click" /><%--TabIndex="142"--%>
                                        <%--</ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnPqLicense" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                        <br />
                                        <asp:Label ID="lblPL" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Attachments<span></span></label>
                                        <%--<asp:UpdatePanel ID="UpdatePanel6" runat="server" >
                                    <ContentTemplate>--%>
                                        <br />
                                        <asp:FileUpload ID="flpUploadFiles" MaxLength="40" runat="server" class="multi" Width="50%"
                                            TabIndex="523" />
                                        <asp:Button ID="btn_UploadFiles" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" runat="server" CssClass="cancel"
                                            Width="10%" Text="Upload" OnClick="btn_UploadFiles_Click" /><%--TabIndex="144"--%>
                                        <%-- </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btn_UploadFiles" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>

                                        <br />
                                        <%--<asp:Label ID="lblUF" runat="server"></asp:Label>--%>
                                        <br />

                                        <asp:GridView ID="gvUploadedFiles" runat="server" AutoGenerateColumns="False" Width="90%"
                                            DataKeyNames="FileName" EmptyDataText="No files uploaded" OnRowCommand="gvUploadedFiles_RowCommand"
                                            PageSize="5">
                                            <Columns>
                                                <asp:BoundField DataField="FileName" HeaderText="FileName" ControlStyle-Width="60%" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkDownload" runat="server" CommandArgument='<%#Eval("FileName")%>'
                                                            CommandName="DownloadRecord" Text="Download"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%#Eval("FileName")%>'
                                                            CommandName="deleteRecord" OnClientClick="return confirm('Are you sure you want to delete this?');" Text="Delete"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>

                            </table>
                            <ucAudit:UserListing runat="server" ID="ucAuditTrail" />
                        </li>
                        <li style="width: 49%;" class="last">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="style1">
                                        <style>
                                            /*.form_panel_custom ul li {
                                                width: 90% !important;
                                            }*/
                                            .dd .ddChild li {
                                                width: 95% !important;
                                            }
                                        </style>
                                        <%--<asp:UpdatePanel ID="upnl1" runat="server">
                                    <ContentTemplate>--%>

                                        <label></label>
                                        <asp:TextBox ID="txtReson" placeholder="Reason" runat="server" Height="28px" TextMode="MultiLine" Width="257px"></asp:TextBox><%--TabIndex="103"--%>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="txtReson" runat="server" ErrorMessage="Enter Reason" ForeColor="Red" Display="Dynamic" ValidationGroup="submit"></asp:RequiredFieldValidator>
                                        <br />
                                        <label></label>
                                        
                                        &nbsp;<br />
                                        <%--</ContentTemplate>
                                </asp:UpdatePanel>--%>

                                    </td>
                                </tr>









                                <tr>
                                    <td class="style1">
                                        <label>
                                            Notes<asp:Label ID="lblNotesReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                        <asp:TextBox ID="txtNotes" runat="server" MaxLength="40" autocomplete="off" Width="240px" Height="32px" TextMode="MultiLine" TabIndex="527"></asp:TextBox>
                                        <%--TabIndex="112"--%>
                                        <br />
                                        <label>
                                        </label>

                                        <asp:RequiredFieldValidator ID="rqNotes" runat="server" ControlToValidate="txtNotes"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit">Enter Notes</asp:RequiredFieldValidator><br />
                                    </td>
                                </tr>
                                <%--<tr>
                            <td class="style1">
                                <label>
                                    Last Name<span><asp:Label ID="lblReqLastName" Text="*" runat="server" ForeColor="Green"></asp:Label></span></label>
                                <asp:TextBox ID="txtlastname" runat="server" MaxLength="40"  onkeypress="return lettersOnly(event);" autocomplete="off"
                                    OnTextChanged="txtlastname_TextChanged" Width="242px" TabIndex="508"></asp:TextBox>
                                <br />
                                <label>
                                </label>
                                <asp:RequiredFieldValidator ID="rqLastName" runat="server" ControlToValidate="txtlastname"
                                    ForeColor="Red" Display="Dynamic" ValidationGroup="submit">Enter Last Name</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtlastname"
                                    ForeColor="Red" Display="Dynamic" ValidationGroup="Image">Enter Last Name</asp:RequiredFieldValidator>
                                <br />



                            </td>
                        </tr>--%>
                                <%-- <tr>
                                    <td class="style1">

                                        <label>
                                            Source<asp:Label ID="lblSourceReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                        <asp:DropDownList ID="ddlSource" runat="server" Width="249px" TabIndex="511">
                                        </asp:DropDownList>

                                   
                                        <br />
                                        <label></label>
                                        <asp:TextBox ID="txtSource" runat="server" Width="173px" TabIndex="512"></asp:TextBox>
                                        &nbsp;<asp:Button runat="server" ID="btnAddSource" Text="Add" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnAddSource_Click" Height="30px" />&nbsp;
                                <asp:Button runat="server" ID="btnDeleteSource" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Text="Delete" OnClick="btnDeleteSource_Click" Height="30px" />
                                        <br />
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqSource" runat="server" ControlToValidate="ddlSource" InitialValue="0"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit">Enter Source</asp:RequiredFieldValidator><br />
                                    </td>
                                </tr>--%>





                                <%--<tr>
                            <td>
                                <label>
                                    Password<asp:Label ID="lblPassReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                <asp:TextBox ID="txtpassword" runat="server" TextMode="Password" MaxLength="30" TabIndex="522"
                                    autocomplete="off" Width="242px"></asp:TextBox>
                                <br />
                                <label>
                                </label>
                                <asp:RequiredFieldValidator ID="rqPass" runat="server" ControlToValidate="txtpassword"
                                    ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Enter Password"></asp:RequiredFieldValidator><br />
                            </td>

                        </tr>--%>


                                <tr>
                                    <td class="style2" style="display: none;">
                                        <asp:CheckBox ID="chkMaddAdd" runat="server" Text="Is mailing address same as address" AutoPostBack="true" OnCheckedChanged="chkMaddAdd_CheckedChanged" />
                                        <br />
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqAddress" runat="server" ControlToValidate="txtaddress"
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="submit">Enter Address</asp:RequiredFieldValidator><br />

                                    </td>
                                </tr>




                                <%--<tr>
                            <td class="style2">
                                <label>
                                    EIN</label>
                                <asp:TextBox ID="txtEIN" runat="server" MaxLength="2" TabIndex="122" onkeyup="javascript:Numeric(this)"
                                    onkeypress="return isNumericKey(event);" Width="42px" OnTextChanged="txtEIN_TextChanged"></asp:TextBox>
                                -<asp:TextBox ID="txtEIN2" runat="server" MaxLength="7" TabIndex="123" onkeyup="javascript:Numeric(this)"
                                    onkeypress="return isNumericKey(event);" Width="55px" OnTextChanged="txtEIN2_TextChanged"></asp:TextBox>
                            </td>
                        </tr>--%>
                                <tr>
                                    <td class="style2">
                                        <label>
                                            Penalty of Perjury<asp:Label ID="lblReqPOP" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                        </label>
                                        <asp:DropDownList ID="ddlcitizen" runat="server" Width="150px" TabIndex="528" OnSelectedIndexChanged="ddlcitizen_SelectedIndexChanged">
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Alien authorized to work" Value="authorizedwork"></asp:ListItem>
                                            <asp:ListItem Text="Lawful permanent resident" Value="permanentresident"></asp:ListItem>
                                            <asp:ListItem Text="Non US Citizenship" Value="NonUSCitizenship"></asp:ListItem>
                                            <asp:ListItem Text="US Citizenship" Value="USCitizenship"></asp:ListItem>
                                        </asp:DropDownList>
                                        <br />
                                        <label>
                                        </label>
                                        <asp:RequiredFieldValidator ID="rqPenalty" runat="server" ControlToValidate="ddlcitizen" InitialValue="0"
                                            ValidationGroup="submit" ForeColor="Red" Display="Dynamic" ErrorMessage="Select Penalty of Perjury"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        <%--<asp:UpdatePanel ID="UpdatePanel9" runat="server">
                                    <ContentTemplate>--%>
                                        <asp:LinkButton ID="lnkw4Details" runat="server" CausesValidation="false" OnClick="lnkw4Details_Click">Add W4 Details</asp:LinkButton><%--TabIndex="133"--%>
                                        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="lnkw4Details"
                                            PopupControlID="pnlpopup" CancelControlID="btnCancel" BackgroundCssClass="modalBackground"
                                            Enabled="true">
                                        </ajaxToolkit:ModalPopupExtender>
                                        <asp:Panel ID="pnlpopup" runat="server" BackColor="White" Height="600px" Width="800px"
                                            Style="display: none" ScrollBars="Vertical">
                                            <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 100%"
                                                cellpadding="0" cellspacing="0">
                                                <tr style="background-color: #b04547">
                                                    <td colspan="2" style="height: 10%; color: White; font-weight: bold; font-size: larger"
                                                        align="center">W4 Details
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>A.</b>Enter “1” for yourself if no one else can claim you as a dependent . .
                                                        . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtA" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>B</b>.Enter “1” if: { • You are single and have only one job; or • You are married,
                                                        have only one job, and your spouse does not work; or . . . • Your wages from a second
                                                        job or your spouse’s wages (or the total of both) are $1,500 or less.}:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtB" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>C.</b>Enter “1” for your spouse. But, you may choose to enter “-0-” if you are
                                                        married and have either a working spouse or more than one job. (Entering “-0-” may
                                                        help you avoid having too little tax withheld.) . . . . . . . . . . . . . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtC" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">D.Enter number of dependents (other than your spouse or yourself) you will claim
                                                        on your tax return . . . . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtD" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>E.</b>Enter “1” if you will file as head of household on your tax return (see
                                                        conditions under Head of household above) . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtE" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>F.</b>Enter “1” if you have at least $1,900 of child or dependent care expenses
                                                        for which you plan to claim a credit .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtF" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>G.</b>Child Tax Credit (including additional child tax credit). See Pub. 972,
                                                        Child Tax Credit, for more information.: • If your total income will be less than
                                                        $61,000 ($90,000 if married), enter “2” for each eligible child; then less “1” if
                                                        you have three or more eligible children. • If your total income will be between
                                                        $61,000 and $84,000 ($90,000 and $119,000 if married), enter “1” for each eligible
                                                        child plus “1” additional if you have six or more eligible children . . . . . .
                                                        . . . .
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtG" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>H.</b>Add lines A through G and enter total here. (Note. This may be different
                                                        from the number of exemptions you claim on your tax return.):
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtH" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>5.</b>Total number of allowances you are claiming (from line H above or from
                                                        the applicable worksheet on page 2)..:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txt5" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>6.</b>Additional amount, if any, you want withheld from each paycheck . . . .
                                                        . . . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txt6" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <b>7.</b>I claim exemption from withholding for 2011, and I certify that I meet
                                                        both of the following conditions for exemption. • Last year I had a right to a refund
                                                        of all federal income tax withheld because I had no tax liability and • This year
                                                        I expect a refund of all federal income tax withheld because I expect to have no
                                                        tax liability. If you meet both conditions, write “Exempt” here . . . . . . . .
                                                        . . . . . . .:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txt7" Width="100%" runat="server" MaxLength="5"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="center">
                                                        <asp:Label ID="lblresult" runat="server"></asp:Label>
                                                        <asp:Button ID="Button1" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" CommandName="Submit" runat="server" Text="Submit" OnClientClick="return hidePnl();" />
                                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />
                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <%--</ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddldesignation" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        <asp:LinkButton ID="lnkW9" runat="server" OnClick="lnkW9_Click" ClientIDMode="Static">W9</asp:LinkButton>
                                        <%-- TabIndex="134"--%>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lnkI9" runat="server" OnClick="lnkI9_Click" ClientIDMode="Static">I9</asp:LinkButton>
                                        <%--TabIndex="135"--%>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lnkW4" Text="W4" runat="server" OnClick="lnkW4_Click" ClientIDMode="Static"></asp:LinkButton><%--TabIndex="136"--%>
                                        <br />
                                        &nbsp;<asp:LinkButton ID="lnkFacePage" runat="server" ClientIDMode="Static" OnClick="lnkFacePage_Click">FacePage</asp:LinkButton>
                                        <%--TabIndex="137"--%>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lnkEscrow" runat="server" OnClick="lnkEscrow_Click" ClientIDMode="Static">Escrow</asp:LinkButton>
                                        <%--TabIndex="138"--%>
                                &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 0px; margin: 0px;">
                                        <asp:Panel ID="pnlPrint" runat="server" Width="323.52px" Height="204px" Style="border-radius: 10.88503937px">
                                            <div>
                                                <asp:Image ID="imgbg" runat="server" ImageUrl="img/Logo_BG_JPG.jpg" Style="background-size: 323.52px 204px; top: 324px" Height="198px" Width="318px" />
                                                <table id="table3" style="padding: 0px; margin-top: -202px; margin-left: 0px; width: 100% !important; height: 204px;">
                                                    <tr>
                                                        <td class="auto-style13" style="height: 25px; padding: 0px; margin: 0px;" colspan="2">
                                                            <asp:Image ID="Image1" ImageUrl="img/JmHeaderNew.png" Height="25px" runat="server" Width="316px" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px; width: 118px !important;">
                                                            <asp:Image ID="Image2" runat="server" Height="150px" Width="118px" />
                                                        </td>
                                                        <td style="height: 150px; padding: 0px; margin: 0px;">
                                                            <table id="table4" style="width: 60%; height: 150px; padding: 0px; margin: 0px;">
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px;">Name :</td>
                                                                    <td style="padding: 0px; margin: 0px;">
                                                                        <asp:Label ID="lblICardName" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px;">Position :</td>
                                                                    <td style="padding: 0px; margin: 0px;">
                                                                        <asp:Label ID="lblICardPosition" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px;">Id # :</td>
                                                                    <td style="padding: 0px; margin: 0px;">
                                                                        <asp:Label ID="lblICardIDNo" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px;" colspan="2">
                                                                        <asp:Image ID="BarcodeImage" runat="server" Height="40px" Width="195px" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="height: 29px; padding: 0px; margin: 0px;" colspan="2">
                                                            <asp:Image ID="Image3" ImageUrl="img/jmFooter.png" Height="25px" runat="server" Width="316px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </asp:Panel>
                                        <%--<div style=""> 
                                    <table id="table3" style="">
                                        <tr>
                                            <td>
                                                <asp:Image ID="img" runat="server" ImageUrl="~/Sr_App/img/Logo_BG_JPG.jpg" style="height: 245px; float:left; position:absolute; width: 316px; top: 4092px; left: 808px;" />
                                               
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="auto-style13" style="height: 25px; padding: 0px; margin: -25px 0 0; position:absolute; z-index:999;" colspan="2">
                                                <asp:Image ID="Image1" ImageUrl="img/JmHeaderNew.png" Height="25px" runat="server" Width="316px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 0px; margin: 0px;width:118px !important;">
                                                <asp:Image ID="Image2" runat="server" Height="150px" Width="118px" />
                                            </td>
                                            <td style="height: 150px; padding: 0px; margin: 0px;">
                                                <table id="table4" style="width: 100%; height: 150px; padding: 0px; margin: 0px;">
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Name :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardName" runat="server"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Position :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardPosition" runat="server"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Id # :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardIDNo" runat="server"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;" colspan="2">
                                                            <div class="myfont" runat="server" id="barcode">
                                                                <%--<asp:PlaceHolder ID="plBarCode" runat="server" />--%>
                                        <%--<asp:Label ID="lblBarcode" runat="server"></asp:Label>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 29px; padding: 0px; margin: 0px;" colspan="2">
                                                <asp:Image ID="Image3" ImageUrl="img/jmFooter.png" Height="25px" runat="server" Width="316px" />
                                            </td>
                                        </tr>
                                    </table>
                                        </div>--%>
                                        <%-- <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>--%>
                                        <%-- <asp:Panel ID="pnlPrint"  runat="server" Width="323.52px" Height="204px" style="border-radius:10.88503937px">
                                    <table id="table3" style="padding: 0px; background-size: 100% 100%; margin: 0px; width: 323.52px;height:204px; background-image: url(img/Logo_BG_JPG.jpg)">
                                        <tr>
                                            <td style="height: 25px; padding: 0px; margin: 0px; background-image: url(img/JmHeaderNew.png); background-size: 100% 100%;" class="auto-style13" colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td style="width: 118px; height: 150px; padding: 0px; margin: 0px;">
                                                <asp:Image ID="Image2" runat="server" Height="150px" Width="118px" />
                                            </td>
                                            <td style="height: 150px; padding: 0px; margin: 0px;">
                                                <table id="table4" style="width: 100%; height: 150px; padding: 0px; margin: 0px;">
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Name&nbsp;&nbsp;&nbsp;&nbsp; :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardName" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Position&nbsp; :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardPosition" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 0px; margin: 0px;">Id #&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :</td>
                                                        <td style="padding: 0px; margin: 0px;">
                                                            <asp:Label ID="lblICardIDNo" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" style="padding: 0px; margin: 0px;">
                                                            <div class="myfont" style="color:orange" runat="server" id="barcode"> 
                                                            <%--<asp:PlaceHolder ID="plBarCode" runat="server" />--%>
                                        <%--<asp:Label ID="lblBarcode" runat="server"></asp:Label>--------------
                                                                </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style13" style="height: 29px; padding: 0px; margin: 0px; background-size: 100% 100%; background-image: url(img/jmFooter.png);" colspan="2">&nbsp;</td>
                                        </tr>
                                    </table>
                                </asp:Panel>--%>
                                        <%--    </ContentTemplate>--%>
                                        <%--<Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="lstboxUploadedImages" EventName="SelectedIndexChanged" />
                                    </Triggers>--%>
                                        <%-- </asp:UpdatePanel>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        <asp:Button ID="btnPrint" runat="server" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Text="Print" OnClientClick="return PrintPanel();" />
                                        <%--TabIndex="145"--%>
                                    </td>
                                </tr>
                            </table>
                        </li>
                        <asp:Label ID="lblMessage" runat="server" Visible="False"></asp:Label>
                    </ul>
                    <div>
                        <%--<asp:UpdatePanel ID="upnl3" runat="server">
                    <ContentTemplate>--%>
                        <asp:Panel runat="server" ID="pnlcolaps" Style="border: solid; border-color: black; border-width: 1px 1px 1px 1px;">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnl3" runat="server">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <%--<asp:UpdatePanel ID="UpdatePanel11" runat="server">
                                                            <ContentTemplate>--%>
                                                        <asp:Button ID="btnPluse" runat="server" Text="+" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnPluse_Click" Font-Size="Medium" Width="23px" /><%-- TabIndex="146"--%>
                                                        <asp:Button ID="btnMinus" runat="server" Text="-" OnClick="btnMinus_Click" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" Font-Size="Medium" Width="20px" />
                                                        <%--TabIndex="146"--%>
                                                        <%--</ContentTemplate>
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                                                                <asp:AsyncPostBackTrigger ControlID="btnPluse" EventName="Click" />
                                                                <asp:AsyncPostBackTrigger ControlID="btnMinus" EventName="Click" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>--%>
                                                    </td>
                                                    <td>
                                                        <h2>SubContract</h2>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <div class="cdata">
                                            <asp:Panel ID="pnl4" runat="server" ScrollBars="Auto" Height="250px">
                                                1 <b>Introduction</b><br />
                                                1.1 General These are the general terms and conditions pursuant to which JMG1 and
                                    J.M. Grove may use Service Provider and its employees and agents (“ Service Provider
                                    Personnel”) to provide services, products and/or materials (collectively, “Services”)
                                    to JMG1 and J.M. Grove retail customers (“Customer(s)”) with whom JMG1 and J.M.
                                    Grove has a separate contractual arrangement(“Customer(s)”), with whom JMG1 and
                                    J.M. Grove has a separate contractual arrangement ( (“Customer Contract”)/ These
                                    General Terms and Conditions are a part of the Service Provider Agreement (“SPA”)
                                    between JMG1 and J.M. Grove and service Provider dated as of the Effective Date
                                    located on the Signature Page. The Service Provider and JMG1 and J.M. Grove will
                                    sometimes be referred to individually as a “Party” or collectively as “Parties”.
                                    These general terms and conditions. These general terms and conditions may only
                                    be amended by an amendment to the SPA executed by the Parties, in the form attached
                                    as Attachment 3. The use of Service Provider by JMG1 and J.M. Grove with respect
                                    to any particular Customer Contract is an ´Assignment The necessary particulars
                                    of each Assignment will be communicated to a Service Provider in the form of a document
                                    referred to as a “Work order”, which may only be amended by a change order prepared
                                    by JMG1 and J.M. Grove and signed by Service Provider (“Change Order”). No adjustments,
                                    including adjustments to compensation due Service Provider, will be made for any
                                    deviations from a Work order that have not been requested or otherwise agreed to
                                    by JMG1 and J.M. Grove pursuant to a Change Order. Work order, and any Change Orders
                                    constitute an integral part of this SPA and are incorporated by reference. Work
                                    order and any Change Orders may be electronically transmitted
                                    <br />
                                                1.2 Relationship of the Parties Service Provider’s relationship to JMG1 and J.M.
                                    Grove and its affiliated companies for purposes of this SPA is that of an independent
                                    contractor. In no event will JMG1 and J.M. Grove and its affiliated companies be
                                    considered a joint employer of Service Provider or any of its affiliates or their
                                    respective personnel. Service Provider acknowledges that it has sole responsibility
                                    to hire, discipline, terminate, supervise and dictate the daily work of its employees.
                                    Service Provider or Service Provider Personnel do not have an employee status or
                                    any entitlement to participate in any plans, arrangements, or distributions by JMG1
                                    and J.M. Grove or its affiliated companies pertaining to, or in connection with,
                                    any pension, stock, bonus, or similar benefits for JMG1 and J.M. Grove employees.<br />
                                                1.3 Reference to Service Provider. Any reference to Service Provider refers to Service
                                    Provider Personnel, the equipment, facilities and resources used by Service Provider,
                                    and its agents or any other third parties that Service Provider engages to fulfill
                                    its obligations in providing the Services, regardless of whether Service Provider
                                    owns, operates or controls said equipment, facilities and/or resources.<br />
                                                1.4 No implied or Further Agreement. Nothing in this SPA obligates JMG1 and J.M.
                                    Grove to use the services of Service Provider for any Assignment or to issue Service
                                    Provider any Work order or to enter into any further agreement with Service Provider
                                    whatsoever. Without limiting the generality of the foregoing, Service Provider acknowledges
                                    that JMG1 and J.M. Grove makes no assurance whatsoever that Service Provider will
                                    receive a minimum or particular dollar amount of business under this SPA. In view
                                    of the foregoing, the Parties represent and warrant to on another that any investments
                                    or expenditures a Party has made, or may make, in anticipation of, or following
                                    execution of this SPA, are at such Party’s sole and knowing risk.<br />
                                                1.5 Non-Exclusivity This SPA is non-exclusive and JMG1 and J.M. Grove may use other
                                    providers to perform the same or similar services as those under this SPA similarly,
                                    Service Provider may perform like services for others, so long as the performance
                                    of such other services does not impair Service Provider’s ability to fulfill its
                                    obligations under this SPA cause Service Provider to breach this SPA, or result
                                    in an Event of Default as defined in Section 13 of this SPA.<br />
                                                2 <b>Term</b> 2.1 Renewals The term of this SPA is one (1) year from the Effective
                                    Date ( the Initial Term”) following which, it will automatically renew for consecutive
                                    one-year periods (“Renewal Term” and together with the initial term, the “Term”)
                                    unless terminated earlier in accordance with Section 15.<br />
                                                3 Services; Service Provider Reference Guide.<br />
                                                3.1 Services. If any services, functions or tasks to be performed by Service Provider
                                    are not specifically described or included within the definition of “Services” hereunder,
                                    but are required for proper performance, they are implied by, and included within,
                                    the scope of the Services to the same extent as if specifically described in this
                                    SPA. JMG1 and J.M. Grove may order the following types of services from Service
                                    Provider under this SPA as agreed by the Parties on the Face Page (“Program(s)”)’(i)
                                    “Service Only” where Service Provider shall provide property related Services to
                                    the Customer; (ii)”install Only” where JMG1 and J.M. Grove will sell the merchandise
                                    at the Customer’s service location; (iv) “Sell, Furnish and Install” where Service
                                    Provider will sell, furnish and install merchandise and provide the Services to
                                    a Customer of JMG1 and J.M. Grove pursuant to a Customer Contract; and (v) “Furnish
                                    and Deliver” where JMG1 and J.M. Grove will sell the merchandise to the Customer
                                    and the Service Provider will furnish and deliver the merchandise to the Customer.
                                    Pursuant to a written amendment, the Parties may agree to modify the types of Services
                                    provided by Service Provider.<br />
                                                3.2 Provision of Services. Service Provider will, at a minimum, provide all Services,
                                    fulfill all Work orders, and complete all Assignments in a timely, workmanlike,
                                    and professional manner in accordance with this SPA, any service level requirements
                                    specified in the SPRG (see 3.3), any applicable manufacturer’s warranty or warranties
                                    and all applicable laws, including business and professional licensing requirements,
                                    building and zoning codes and facilities and conditions standards. Service Provider
                                    will provide Service Provider Personnel who will be present at Customers’ service
                                    addresses with photo identification and uniforms bearing Service Provider’s marks
                                    and such other marks as may be designated by JMG1 and J.M. Grove in accordance with
                                    any further guidelines provided in the SPRG. Service Provider agrees to provide
                                    and will perform the Services described in this SPA in accordance with and subject
                                    to the terms and conditions set forth herein. Service Provider will not offer or
                                    provide any services to a Customer, other than those specifically identified in
                                    a Work order or written Change Order issued by JMG1 and J.M. Grove, while performing
                                    Services for the Customer.<br />
                                                3.3 Service Provider Reference Guide (“SPRG”). Service Provider acknowledges and
                                    agrees that additional terms and conditions applicable to these Services will be
                                    set forth by JMG1 and J.M. Grove in its Service Provider Reference Guide (:SPRG”),
                                    which constitutes an integral part of this SPA, is incorporated herein by reference
                                    and will be located on-line at a website established by JMG1 and J.M. Grove for
                                    that purpose The website is: www.JMG1serviceproviders.com<br />
                                                Login: Installer Password: JMG1ROVE JMG1 and J.M. Grove reserves the absolute right
                                    to modify the SPRG and JMG1 and J.M. Grove website from time to time in its own
                                    discretion. Service Provider will follow all of the applicable terms and conditions
                                    included in the SPRG. Certain sections of the SPRG may apply specifically to a particular
                                    Program, and Service Provider is responsible for following the guidelines of the
                                    SPRG specific to that Program, in addition to following its general guidelines.
                                    Notwithstanding any other provision herein to the contrary, any revisions made to
                                    the SPRG will be deemed effective immediately upon JMG1 and J.M. Grove posting of
                                    such revisions on JMG1 and J.M. Grove Website. Service Provider is responsible for
                                    checking V Services and the JMG1 and J.M. Grove website to note any changes made.<br />
                                                4 General Obligations of Service Provider.<br />
                                                4.1 Facilities and Conditions. Service Provider will act at all times with the safety
                                    of JMG1 and J.M. Grove Customers and Service Provider Personnel foremost in mind
                                    and will follow all applicable safety guidelines conforming to (i) those required
                                    or recommended by federal, state, and local governmental or quasi-governmental authorities
                                    with jurisdiction over the activities of Service Provider under this SPA, including,
                                    all applicable guidelines and regulations issued by the federal Occupational Safety
                                    and Health Administration: and (ii) the requirements of this SPA. All waste that
                                    is generated by the Services or residual chemicals that are otherwise used by Service
                                    Provider must be properly managed, stored, transported, and dispersed of in accordance
                                    with applicable local, state, and federal laws, rules, and regulations.<br />
                                                4.2 Liens: security Interests. To the extent permissible under applicable law, Service
                                    Provider will not place a lien on, or take any other security interest in, JMG1
                                    and J.M. Grove property or any property of a Customer.<br />
                                                Tariffs. The Parties agree that no tariffs, either those that may be maintained
                                    by Service Provider or by any carrier working on behalf of Service Provider, will
                                    apply to any transportation services provided under this SPA, except as may be specifically
                                    agreed to or acknowledged by JMG1 and J.M. Grove in writing. To the extent of any
                                    inconsistency between said tariffs and the terms of the SPA the applicable terms
                                    of this SPA will apply, The terms of the SPA will also apply over the terms of any
                                    bills of lading or any other shipping documents that may be issued by Service Provider
                                    to JMG1 and J.M. Grove in connection with its transportation service.
                                    <br />
                                                4.4 Permits. Service Provider must follow all legal requirements and obtain all
                                    required building and construction permits. And inceptions necessary to perform
                                    the Services. Service Provider will not request or require Customers to obtain permits
                                    unless permissible under applicable law and requested to do so in writing b\ JMG1
                                    and J.M. Grove Service Provider will maintain auditable records documenting its
                                    compliance with the requirements of this Section 4.4.
                                    <br />
                                                4.5 Taxes, Service Provider is solely responsible for all taxes related to the Services
                                    and fulfillment of its obligations to JMG1 and J.M. Grove under this SPA, Service
                                    Provider will pay accrue and remit an sales, use, ad valorem, franchise, income,
                                    license, occupation, and any other taxes cl imposts of every nature or description
                                    whatsoever, presently or hereinafter imposed by applicable law upon the operation
                                    of Service Provider's business in relation to its fulfillment of its obligations
                                    to JMG1 and J.M. Grove Provider will file all reports, make all returns and secure
                                    all licenses and permits with rasped to such taxes or imposts JMG1 and J.M. Grove
                                    will issue a resale certificate to Service Provider only if Service Provider is
                                    authorized to request such a certificate under applicable law. Additionally, the
                                    products or materials purchased under this SPA by Service Provide! From JMG1 and
                                    J.M. Grove for services by Service Provider do not qualify under applicable law
                                    as a real property improvement or are otherwise taxable to the property owner under
                                    applicable law. JMG1 and J.M. Grove will coiled all retail sales taxes for Customers
                                    and will remit such taxes to, and file all required reports with, the appropriate
                                    government’s authorities.<br />
                                                4.6 Property Losses. Service Provider is solely responsible for the care of, and
                                    for all losses that may occur with respect to any physical damage to the Customer's
                                    service location and/or merchandise, monies, funds negotiable instruments (for example,
                                    checks), valuables or other property of JMG1 and J.M. Grove or any Customer while
                                    in the custody or control of or while Service Provider or any Service Provider Personnel
                                    are present. Any property removed or replaced belonging to the Customer will not
                                    be carried away by the Service Provider unless such removal is provided for in the
                                    Customer Contract or requested in writing by the Customer.<br />
                                                4.7 Equipment. Service Provider will, at its own expense, provide all transportation
                                    capacity and provide and maintain all equipment, supplies, tools, uniforms, up-to-date
                                    maps and directional aids, and other resources (collectively, "Equipment"), necessary
                                    to fulfill its' obligations under this SPA. Service Provider will keep Equipment
                                    in good repair and safe operating condition, maintain Equipment according to the
                                    manufacturer’s recommendations, and only use Equipment fit for its intended purpose.
                                    Service Providers vehicular Equipment will be maintained consistent with the requirements
                                    of the Federal Motor Carrier Safety Regulations ("FMCSR") at` all times. Service
                                    Provider will comply with any additional vehicular specifications
                                    <br />
                                                as provided in the SPRG 4.8 Non-solicitation Service Provider will not use Confidential
                                    Information (defined in Section 8.1); information about Customers obtained as a
                                    consequence of Service Provider’s fulfillment of its obligations under this SPA,
                                    for the purpose of soliciting, directly or indirectly, any business from a Customer
                                    or prospective Customer. Service Provider will not use such information for the
                                    purpose of providing products or services that are the same as, similar to, or competitive
                                    with, Services or other products and services that are sold or provided by JMG1
                                    and J.M. Grove. Service Provider’s acknowledges and agrees that the restrictions
                                    contained in this section 4.8 are fair, reasonable, and necessary to protect JMG1
                                    and J.M. Grove legitimate business interests. The non-solicitation restrictions
                                    set forth in this Section 4.8 will survive for three (3) years upon termination
                                    or expiration of this SPA, provided that protections applicable to JMG1 and J.M.
                                    Grove Confidential information will continue for as long as permitted by applicable
                                    law.<br />
                                                4.9 Promotions. JMG1 and J.M. Grove may desire and hereby reserves the right to
                                    implement storewide or targeted promotions or purchase incentives applicable to
                                    Services or certain Programs. Such promotions may apply nationally, regionally,
                                    or only with respect to certain JMG1 and J.M. Grove stores. If such promotions affect
                                    the business of Service Provider JMG1 and J.M. Grove and Service Provider will engage
                                    in good faith discussions about the Parties respective responsibilities and any
                                    adjustments that may be appropriate for the pricing of services or compensation
                                    due Service Provider. Such arrangement regarding-the implementation of a promotion
                                    shall be agreed to by the Parties and reduced to a properly executed writing
                                    <br />
                                                4.10 Service Warranties. JMG1 and J.M. Grove will warrant to the Customer the workmanship
                                    of the Services pursuant to a Customer Contract. Service Provider will warrant its
                                    workmanship to JMG1 and J.M. Grove in accordance with this Section<br />
                                                4.10.If Service Provider breaches its warranty, the Service Provider will JMG1 and
                                    J.M. Grove in accordance with Section 10. Service Provider hereby warrants the workmanship
                                    of each installation to JMG1 and J.M. Grove for the longer of: (i) one (1) year
                                    and five (5)years for roofs from the date of the installation completion and signed
                                    Customer Approval/satisfaction, and collected remaining monies owed by Customer
                                    and installer signed Lien Waiver (as defined below), whichever is later; (ii) the
                                    applicable period specified in the Customer Contract or any warranty supplemental
                                    to such Customer Contract; or (iii) such period as may be required under applicable
                                    law. These warranties are in addition to any other warranties provided by Service
                                    Provider or required by applicable law or this SPA<br />
                                                <b>5 Payment and Chargebacks.</b> 5.1 Submission for Payment. Payment processing
                                    will begin upon the completion of an installation pursuant to a Work order Purchase
                                    order. Unless other terms are established in other sections of the SPA for the specific
                                    Program, Service Provider must submit to JMG1 and J.M. Grove a signed Customer Approval/satisfaction,
                                    and collected remaining monies owed by Customer and a signed lien waiver form ("Lien
                                    Waiver') as a condition of payment processing The payment procedures and adjustments
                                    are described in further detail in the SPRG.<br />
                                                5.2 Payment. Within ninety (90) days of JMG1 and J.M. Grove receipt of both the
                                    signed Customer Approval/satisfaction, and collected remaining monies owed by Customer
                                    and signed Lien Waiver. Contractor will hold in escrow 10% of money owed per “Work
                                    Order” until account reaches $5,000.00. Money will be held for 16 months past the
                                    date of termination as per this SPA. JMG1 and J.M. Grove will process and make payment
                                    to the Service Provider of any undisputed charges.<br />
                                                5.3 Cost Adjustments An undisputed error in the payment made to Service Provider
                                    will be corrected as follows: (i) if the cost adjustment results in a credit to
                                    the Service Provider, the amount will be included in the next scheduled payment
                                    cycle; or (ii) if the cost adjustment results in a debit to the Service Provider,
                                    the Service Provider's account will show a balance due and JMG1 and J.M. Grove will
                                    deduct the amount due from any future payments to the Service Provider.<br />
                                                5.4 Chargeback. If JMG1 and J.M. Grove incurs expenses to satisfy a Customer who
                                    is not completely satisfied because of substandard or faulty workmanship of the
                                    Service Provider or to repair damages caused by Service Provider and/or if the Service
                                    Provider has violated any of the requirements of the SPA that are or may be deemed
                                    in the future violations which provide a penalty to be imposed against the Service
                                    Provider, such expenses, regardless of the manner incurred, will be deducted as
                                    a "chargeback" from payments otherwise due the Service Provider from JMG1 and J.M.
                                    Grove. To the extent no further payments are due, JMG1 and J.M. Grove will invoice
                                    Service Provider for such expenses and Service Provider agrees to pay such invoice
                                    within thirty (30) days of the invoice date. JMG1 and J.M. Grove rights under this
                                    Section 5.4 will survive the expiration or termination of this SPA Additional information
                                    with regard to chargeback's is provided in the SPRG. Service Provider will have
                                    three (3) days to schedule re-work for Customer or Company call backs. After (3)
                                    days Company may cure unresolved Contractual obligations to Customer and “back charge”
                                    Service Provider at a time and material rate.<br />
                                                6 Background Investigations.<br />
                                                6.1 General. Service Provider Personnel must pass background investigations before
                                    the provision of any Services. These investigations will be conducted by a third-party
                                    agency or agencies approved or designated by JMG1 and J.M. Grove as set forth in
                                    the SPRG. Service Provider will be notified of the results, but will not receive
                                    access to or review the report, except to the extent JMG1 and J.M. Grove is required
                                    under applicable law to allow such access or review or unless the Service Provider
                                    is credentialed by the third-party agency. Later background investigations may
                                    <br />
                                                6.2 Prerequisite to Provision of Services. Until the requirements of this Section
                                    6 are fully satisfied, under no circumstances will Service Provider or its Service
                                    Provider Personnel provide any Services, have contact with any Customers, or have
                                    access to Confidential Information, including Customer information.<br />
                                                6.3 Felony Discovery of a felony criminal conviction (no matter the date of such
                                    conviction) of Service Provider or any significant owner, officer or director therof,
                                    or of any CO-Signer with Service Provider, or of any Service Provider Personnel,
                                    will be grounds for immediate termination of this SPA and any Work order purchase
                                    order issued by JMG1 and J.M. Grove.<br />
                                                7 Service Provider Personnel.<br />
                                                7.1 No Benefits Service Provider acknowledges and agrees that it and its Service
                                    Provider Personnel will have no right to the payment of wages or salary from JMG1
                                    and J.M. Grove or to participate in any employee benefits plans, arrangements, or
                                    distributions by JMG1 and J.M. Grove or its affiliated companies. Such employee
                                    wages, salary, benefits plans, arrangements, or distributions include, without limitation,
                                    those pertaining to, or connected with, any pension, stock, bonus or similar benefits
                                    for JMG1 and J.M. Grove employees. Service Provider will provide a signed benefits
                                    waiver for each of its Service Provider Personnel upon JMG1 and J.M. Grove request.<br />
                                                7.2 Tax and Reporting Requirements. Service Provider is exclusively liable for all
                                    tax withholding, deposit, and reporting requirements under federal or state income,
                                    social security, FICA, old age benefit, Medicare, unemployment insurance, or workers’
                                    compensation acts with respect to services provided by its Service Provider Personnel.
                                    Service Provider represents and warrants that it will comply, at its expense, with
                                    the Fair Labor Standards Act, all worker’s compensation, benefits, employment laws
                                    and all other laws applicable to it. JMG1 and J.M. Grove has the right to audit
                                    such records upon request.<br />
                                                7.3 Compliance with the immigration Reform and Control ACT. Service Provider is
                                    solely responsible for ensuring that all of its Service Provider Personnel are in
                                    compliance with the Immigration Reform and Control Act of 1986 (“IRCA) and will
                                    perform employment eligibility verifications and maintain I-9 forms for Service
                                    Provider Personnel. Service Provider will comply fully with the record-keeping requirements
                                    of IRCA, and certify its compliance to JMG1 and J.M. Grove upon request. Service
                                    Provider will only use workers for whom it has confirmed legal eligibility to perform
                                    services as employees in the United States and for whom all required record keeping
                                    under IRC has been performed and maintained.<br />
                                                7.4 No Sponsorship JMG1 and J.M. Grove is not responsible for sponsorship of, and
                                    will not sponsor, any workers used in fulfillment of Service Provider’s obligations
                                    under this SPA.<br />
                                                7.5 Reimbursement. If, for any reason JMG1 and J.M. Grove is required by law or
                                    regulation or the action of any governmental authority, to pay any sum of money
                                    by way of levy, tax, interest, penalty, or otherwise, to Service Provider Personnel,
                                    Service Provider Personnel, Service Provider authorizes JMG1 and J.M. Grove to deduct
                                    such amount from any sums then due or that thereafter become due Service Provider
                                    form JMG1 and J.M. Grove. To the extent no further payments are due Service Provider,
                                    JMG1 and J.M. Grove will invoice Service Provider for such reimbursement and Service
                                    Provider agrees to pay such invoice within thirty (30) days of the invoice date.
                                    This obligation and JMG1 and J.M. Grove rights hereunder will survive the expiration
                                    or termination of this SPA.<br />
                                                7.6 Labor Disputes. Service Provider agrees to immediately notify JMG1 and J.M.
                                    Grove in writing of any threatened, impending, or actual labor dispute involving
                                    Service Provider or Service Provider Personnel<br />
                                                7.7 Compliance with this SPA. Service Provider will ensure that Service Provider
                                    Personnel comply with the terms of this SPA, and any breach of any term of this
                                    SPA by Service Provider Personnel is a breach by Service Provider for liability,
                                    indemnification and other purposes.<br />
                                                8 Confidentiality; Publicity; Ownership of Works. 8.1 Confidential Information.
                                    Service Provider acknowledges that performance under this SPA will give Service
                                    Provider and Service Provider Personnel access to confidential, proprietary, and
                                    trade secret information of JMG1 and J.M. Grove and Customer information (collectively
                                    “Confidential Information”). Service Provider agrees that it will maintain all Confidential
                                    Information in strict confidence and not disclose or use Confidential Information
                                    other than as necessary to fulfill its obligations to JMG1 and J.M. Grove. Service
                                    Provider will inform its Service Provider Personnel about the JMG1 and J.M. Grove.
                                    Service Provider will inform its Service Provider personnel about the confidential
                                    and proprietary nature of the Confidential Information to which they may be exposed
                                    and will
                                    <br />
                                                8.2-9.1 Ensure that Service Provider Personnel keep Confidential Information strictly
                                    confidential and comply with a terms of this Section 8. "Confidential Information"
                                    means information disclosed to, made available to obtained by Service Provider in
                                    connection with this Agreement, and all material and reports prepared for JMG1 and
                                    J.M. Grove hereunder, including all information (whether or not specifically labeled
                                    or identified as confidential), in any form or medium, that is disclosed to or learned
                                    b_. Service Provider in the performance of Services related to this SPA and that
                                    relates to the business products, services, research or development of JMG1 and
                                    J.M. Grove or its service providers, suppliers, distributors, agents, representatives
                                    or Customers. Specifically, but not limiting the generality of the foregoing, Confidential
                                    Information further includes the following: internal business information (including
                                    information relating to strategic and staffing plans and practices, marketing, promotional
                                    sales plans, practices and programs, training practices and programs, costs, rate
                                    and pricing structures and accounting and business methods); identities of, individual
                                    requirements of, specific contractual arrangements with, and information about,
                                    JMG1 and J.M. Grove service providers, suppliers, distributors and Customers and
                                    their confidential, proprietary or personal information; (c) compilations of data
                                    and analyses, processes, methods, techniques, systems, formulae, research records,
                                    reports, Customer lists, manuals, documentation, models, data and data bases relatin5
                                    thereto; computer software and technology (including operating systems, application
                                    software, interfaces utilities, modifications, macros and their overall organization
                                    and interaction), program listing documentation, data and data bases, and any user
                                    IDs and passwords JMG1 and J.M. Grove provides Service Provider for access to JMG1
                                    and J.M. Grove internal systems; and Trade secrets, trade dress, ideas, inventions,
                                    designs, developments, devices, methods, processes and systems (whether or not patentable
                                    or copyrighted and whether or not reduced to practice of fixed in a tangible medium).
                                    8.2 Required Disclosures. If Service Provider receives a subpoena or other validly
                                    issued administrative of judicial process demanding information about this SPA and/or
                                    Confidential Information, Service Provider must promptly notify and tender the defense
                                    of that demand to JMG1 and J.M. Grove. Unless it has been timely limited, quashed
                                    or extended, Service Provider will thereafter be entitled to comply with such demand
                                    to the extent required by law. If requested, Service Provider will cooperate in
                                    the defense of such demand.<br />
                                                8.3 Publicity. Service Provider will not issue any press release or other statement,
                                    or otherwise disclose (in whole or in part) the contents or substance of this SPA
                                    or the Parties' activities under this SPA without first obtaining the express prior
                                    written consent of JMG1 and J.M. Grove. Any such consent must be requested at least
                                    thirty (30) calendar days before the intended date of the release or communication,
                                    Service Provider will immediately inform JMG1 and J.M. Grove if it believes that
                                    the issuance of any press or other media release is required by operation of applicable
                                    law.<br />
                                                8.4 Ownership of Works. Except as otherwise agreed by the Parties in writing, JMG1
                                    and J.M. Grove or its assignee own and have all right, title and interest in all
                                    ideas, concepts, plans, processes (including without limitation, sales and marketing
                                    processes) creations, trademarks, logos, intellectual property, displays (whether
                                    such displays are used on an in-store or in-home basis) or other work product (collectively,
                                    the "Works") produced by JMG1 and J.M. Grove, produced at JMG1 and J.M. Grove request,
                                    or produced by Service Provider or any Service Provider Personnel for JMG1 and J.M.
                                    Grove in furtherance of the Parties' obligations under this SPA. Service Provider
                                    will cooperate fully with JMG1 and J.M. Grove and execute documentation as JMG1
                                    and J.M. Grove may request in order to establish, secure, maintain, or protect JMG1
                                    and J.M. Grove rights with respect to the Works,<br />
                                                9 Representations and Warranties. 9.1 Mutual Re representations and Warranties.
                                    Each Party represents and warrants that, as of the Effective Date: (a) It is a corporation
                                    duly incorporated (or is any other form of legally recognized entity), validly existing
                                    and in good standing under the laws of the jurisdiction in which it is incorporated
                                    or otherwise formed, and is duly qualified and in good standing in each other jurisdiction
                                    where the failure to be so qualified and in good standing would have an adverse
                                    effect on its ability to perform its obligations under this SPA in accordance with
                                    the terms and conditions here of; and (b) Each Party has all necessary corporate
                                    power to enter into the SPA and to perform its obligations hereunder and the execution,
                                    delivery, and performance of this SPA by each Party has been duty authorized by
                                    all necessary corporate action on the part of each Party. 9.2 Service Provider Representations
                                    and Warranties. Service Provider further represents and warrants to JMG1 that as
                                    of the Effective Date and continuing throughout the Term;<br />
                                                (a) Service Provider is duly licensed, authorized and qualified to do business in
                                    each jurisdiction in which a license, authorization, or qualification is required
                                    for the transaction of business in fulfillment of Service Provider’s obligations
                                    under this SPA;<br />
                                                (b) there is no outstanding litigation, arbitration, claim, or other dispute to
                                    which Service Provider, [or any Cosigner]is a party that if decided unfavorably
                                    to it, would reasonably be expected to have a material adverse effect on the ability
                                    of any Party to fulfill its obligations under this SPA;<br />
                                                (c) neither Service Provider [nor any Cosigner] of Service Provider is a party to
                                    any contract, agreement, mortgage, note, deed, lease or similar understanding with
                                    any third party that would have an adverse effect on the ability of Service Provider
                                    to fulfill its obligations under this SPA;<br />
                                                (d) to Service Provider’s knowledge, no non-public fact or circumstance exists that
                                    would have, or potentially could result in an adverse effect on Service Provider’s
                                    or JMG1 and J.M. Grove public image or the public’s perception of any of Service
                                    Provider’s or JMG1 and the J.M. Grove brands or marks that may be used under this
                                    SPA;<br />
                                                (e) Service Provider will properly render the Services in accordance with this SPA
                                    and any Work order and will execute each in accordance with the practices and commercially
                                    and reasonable standards used in well-managed operations performing services similar
                                    to the Services, with an adequate number of qualified individuals with suitable
                                    training, experience and sill to perform the Services;<br />
                                                (f) Service Provider will maintain insurance coverage’s in amounts and as required
                                    in this SPA and the SPRG<br />
                                                (g) Service Provider will perform its obligations in a manner that complies with
                                    all laws applicable to Service Provider and its business, activities, facilities
                                    and the provision of Services hereunder ,including laws of any country or jurisdiction
                                    from which or through which Service Provider provides the Services or obtains resources
                                    or personnel to do so.<br />
                                                10 Indemnifications.<br />
                                                10.1 Mutual Indemnification JMG1 and J.M. Grove and Service Provider and its affiliates,
                                    will indemnify, defend, and gold one another and their respective owners, officers,
                                    shareholders, partners, members, parent, affiliates, subsidiaries, associates, directors,
                                    employees, subcontractors and agents harmless from and against any third party losses
                                    liabilities, claims, causes of action, lawsuits, judgments, civil penalties, damages
                                    and expenses suffered, incurred, or sustained by the indemnified Party or any of
                                    its owners, officers, shareholders, partners, members, parent, affiliates, subsidiaries,
                                    associates, directors, employees, subcontractors and agents to the extent resulting
                                    from, arising out of, or relating to, any claim that;<br />
                                                (a) the indemnifying Party or any owner, officer, shareholder, parent, affiliate,
                                    subsidiary, associate, director, employee, subcontractor and agent thereof is non-compliant
                                    with any applicable law or regulations, or;<br />
                                                (b) A Party’s intellectual property infringes upon the proprietary or other rights
                                    of any third party.<br />
                                                10.2 Service Provider Indemnification. Service Provider will further indemnify defend
                                    and hold harmless JMG1 and J.M. Grove and its owners, officers, shareholders, affiliates
                                    subsidiaries, associates, directors, employees, subcontractors and agents a from
                                    and against, any losses, liabilities, claims causes of action, lawsuits, judgments,
                                    civil penalties, damages and expenses suffered, incurred, or sustained by JMG1 and
                                    J.M. Grove or its owners, officers, shareholders, affiliates, subsidiaries, associates,
                                    directors, employees, subcontractors and agents, to the extent resulting from, arising
                                    out of, or relating to the following acts or failure to act of Service Provider
                                    and/or Service Provider Personnel;<br />
                                                (a) Any Services and/or work performed and/or products supplied by Service Provider
                                    and/or Service Provider Personnel;<br />
                                                (b) The inaccuracy, untruthfulness or breach of any representation, covenant, warranty,
                                    or any other agreement set forth in this SPA;<br />
                                                (c) Actual or alleged personal injury (including death);<br />
                                                (d) Actual or alleged property loss or damage;<br />
                                                (e) the marketing or sale of any products, materials or services under this SPA
                                    to any Customer; or (by agreement, plan, statute or otherwise), pension benefits,
                                    or severance or termination pay, by or on behalf of Service Provider or any owner,
                                    officer, shareholder, partner, member, parent or Service Provider Personnel, claiming
                                    an employment or other relationship with Service Provider and/or JMG1 and J.M. Grove<br />
                                                10.3 JMG1 and J.M. Grove Right to Assume Defense Notwithstanding anything else provided
                                    herein, and without limiting Service Provider’s obligation to fully indemnify JMG1
                                    and J.M. Grove under this SPA, and with respect to any claims for which JMG1 and
                                    J.M.Grove is entitled to indemnification from Service Provider hereunder. JMG1 and
                                    J.M Grove reserves the absolute right to assume the defense of any claim and JMG1
                                    and J.M. Grove may thereafter require from Service Provider reimbursement of any
                                    and all costs and expenses (including reasonable attorney’s fees). 10.4 Defense
                                    of Claims Subject to Section 10.3 above, the indemnified Party shall cooperate in
                                    the defense of any claim for which indemnification is sought under this Section
                                    10. The indemnifying Party agrees to do the following in connection with the conduct
                                    of the defense of any claim in which the indemnified Party has been named a party.<br />
                                                (a) Inform the indemnified Party or its agents about all material information pertaining
                                    to a claim;<br />
                                                (b) Inform the indemnified Party of the date of any mediation, arbitration, trial,
                                    or settlement conference as soon as possible after it receives such information;<br />
                                                (c) Choose defense counsel that is reasonably satisfactory to the indemnified Party;<br />
                                                (d) Use all reasonable efforts to promptly provide indemnified Party with copies
                                    of all discovery requests as soon as they are available to indemnifying Party;<br />
                                                (e) provide the indemnified Party with copies of all defensive pleadings in advance
                                    of filing to allow the indemnified Party the opportunity to provide comments; and<br />
                                                (f) Inform the indemnified Party of the outcome of any mediation, arbitration, motion,
                                    trial, or settlement or any other matter from which appeal rights could arise.<br />
                                                10.5 No Settlement Without Consent. The indemnifying Party will not enter into any
                                    settlement or compromise of the claim that would result in the admission of any
                                    liability, create any financial liability, or that would subject the indemnified
                                    Party to injunctive relief or otherwise bind, restrict or commit the indemnified
                                    Party without first obtaining the indemnified Party’s prior written consent<br />
                                                10.6 Participating in the Defense JMG1 and J.M. Grove have the right, but not the
                                    obligation, to participate, as it deems necessary, in the handling, adjustment,
                                    or defense of any claim. If JMG1 and J.M. Grove reasonably determines that defenses
                                    are available to it that are not available to Service Provider, and if raising such
                                    defenses would create a conflict of interest for the counsel defending the claim,
                                    JMG1 and J.M. Grove will be entitled to retain separate counsel, at Service Provider’s
                                    expense, to raise such defenses.<br />
                                                10.7 Assumption of Defense Should the indemnifying Party fail to assume its obligations,
                                    including its obligation to diligently pursue and pay for the defense of the indemnified
                                    Party under this Section 10, the indemnifying Party agrees that the indemnified
                                    Party will have the right but not the obligation, to proceed on its own behalf to
                                    so defend itself. The indemnified Party may require from the indemnifying Party
                                    reimbursement of any and all costs and expenses (including reasonable attorney’s
                                    fees) and amounts paid by the indemnified Party on behalf of the indemnifying Party.<br />
                                                10.8 Indemnification in Addition to Insurance Service Providers agreement to indemnify,
                                    defend and hold harmless JMG1 and J.M. Grove under the terms of this Section 10
                                    is in addition to Service Provider’s agreement to procure insurance as required
                                    under this SPA. Any losses, damages and expenses incurred by JMG1 and J.M. Grove
                                    will be covered, to the extent permissible by Service Provider’s insurer. Service
                                    Provider’s insurance coverage does not in any way limit Service Provider’s obligations
                                    to indemnify, defend and gold harmless JMG1 and J.M. Grove<br />
                                                10.9 Other Indemnification Obligations The foregoing obligations are in addition
                                    to any other indemnification obligations that may be seen forth elsewhere in this
                                    SPA or in any attachment to this SPA or which may arise by operation of law.<br />
                                                11 Insurance; Risk of Loss.<br />
                                                11.1 Licensing and Insuring of Employees. Service Provider will ensure that Service
                                    Provider Personnel performing work under this SPA are fully licensed as required
                                    by law with respect to all activities undertaken in fulfillment of Service Provider’s
                                    obligations under this SPA and insured consistent with JMG1 and J.M. Grove requirements
                                    as provided in the SPRG<br />
                                                11.2 Insurance Certificate All insurance certificates must list JMG1 and J.M. Grove
                                    LLC as the certificate holder. Additionally all insurance certificates, except for
                                    the Auto and Workers Compensation Certificate of Insurance must contain the following
                                    language exactly as provided; “ JMG1 and J.M. Grove LLC, its parents, affiliates,
                                    and subsidiaries are added as additional insured<br />
                                                11.3 Risk of Loss As of the Effective Date and continuing throughout the Term, each
                                    Party will be responsible for risk of physical or actual loss of, and damage to,
                                    any property, equipment, merchandise or any other items or information in its possession
                                    or under its control.<br />
                                                11.4 Insurance Coverage Service Provider will procure and maintain at all times
                                    Commercial General Liability Auto Liability and Workers Compensation Insurance with
                                    coverage amounts on an occurrence basis containing limits of no less than the amounts
                                    specified for the Services on the Insurance Requirements described in the SPRG.
                                    This insurance will not include any exceptions and/or exclusion that limit or minimize
                                    the coverage’s for the Services. Additional Insured and Products-Completed Operations
                                    Endorsements are required.<br />
                                                11.5 Insurance Proceeds For the avoidance of doubt, insurance proceeds received
                                    or owed to Service Provider for any Services provided under this SPA, will be paid
                                    or assigned, as necessary, to JMG1 and J.M. Grove to cover any costs or fees incurred
                                    by JMG1 and J.M. Grove as a result of the circumstances leading to the payment of
                                    any such insurance proceeds.<br />
                                                12 Limitations of Liability<br />
                                                12.1 LIABILITY FOR ACTIAL DAMAGES ONLY EXCEPT IN CONNECTION WITH SERVICE PROVIDER’S
                                    BREACH OF CONFIDENTIALITY, FRAUD, GROSS NEGLIGENCE, WILLFUL MISCONDUCT OR INDEMNIFICATION
                                    OBLIGATION TO JMG1 AND J.M. GROVE FOR INTELLECTUAL PROPERTY INFRINGEMENT CLAIMS,
                                    NO PARTY WILL BE LIABLE TO ANOTHERPARTY FOR, NOR WILL THE MEASURE OF DAMAGES INCLUDE,
                                    ANY CONSEQUENTIAL, ORINCIDENTAL, INDIRECT, EXEMPLARY, PUNITIVE, OR SPECIAL DAMAGES
                                    ARISING OUR OF OR RELATING TO ITS ACTS OR OMISSIONS UNDER RHIS SPA, REGARDLESS OF
                                    THE FORM OF ACTION, WHETHER IN CONTRACT, NEGLIGENCE, TORT STRICT LIABILITY, PRODUCTS
                                    LIABILITY OR OTHERWISE, AND EVEN IF FORESEEABLE OR IF SUCH PARTY HAS BEEN ADVISED
                                    OF THE POSSIBILITY OF SUCH DAMAGES. A PARTY WILL ONLY BE LIABLE TO THE OTHER PARTY
                                    FORDAMAGES ACTUALLY INCURRED BY A BREACHING PARTY.<br />
                                                12.2JMG1 AND J.M. GROVE MAXIMUM LIABILITY JMG1 AND J.M. GROVE MAXIMUM LIABILITY
                                    TO SERVICE PROVIDER UNDER THIS SPA (REGARDLESS OF CUASE OR FORM OF ACTION, WHETHER
                                    IN CONTRACT, TORT, OR OTHERWISE) WILL BE LIMITED TO THE TOTAL UNDISPUTED AMOUNT
                                    OWED SERVICE PROVIDER BY JMG1 AND J.M.GROVE IN PAYMENT FOR SERVICE PROVIDER’SFULFILLMENTOF
                                    ITS OBLIGATIONS UNDER THIS SPA<br />
                                                12.3 CLAIMS ONLY AGAINST JMG1 AND J.M. GROVE SERVICE PROVIDER AGREES THAT ITS SOLE
                                    RECOURSE FOR CLAIMS ARISING BETWEEN OR AMONG THE PARTIES WILL BE AGAINST JMG1 AND
                                    NOT J.M.GROVE OR J.M. GROVE’S SUCCESSORS AND ASSIGNS. IN NO EVENT WILL THE SHAREHOLDERS,
                                    DIREDTORS, OFFICERS, EMPLOYEES, AND AGENTS OF JMG1 AND J.M. GROVE AND ITS AFFILIATES
                                    BE PERSONALLY LIABLE OR BE NAMED AS PARTIES IN ANY ACTIONBETWEEN OR AMONG THE PARTIES.<br />
                                                12.4 Third party Liabilities. Nothing in this Section 12 will be construed to limit
                                    a Party’s right to recover any damages that such Party is obligated to pay to any
                                    third party. Nor will anything I this section 12 preclude any remedies available
                                    to a Party in the case of fraud by the other Party provided such fraud has been
                                    established by the finding (even if appealable) of a court of competent jurisdiction<br />
                                                12.5 Mutual Understanding Service Provider and JMG1 and J.M. Grove agree that the
                                    allocation of liability set forth I this Section 12 represents the mutually agreed
                                    upon and bargained-for understanding of the Parties and further agree that the compensation
                                    exchanged by the Parties under this SPA reflects such allocation.<br />
                                                13 Events of Default. The occurrence of any of the following will be deemed an “Event
                                    of Default”<br />
                                                13.1 Compliance The failure of Service Provider to: (i) comply with any term or
                                    condition of this SPA (ii) to make payment or reimbursement of funds owed JMG1 and
                                    J.M. Grove, (iii) cease conduct that JMG1 and J.M Grove reasonably deems harmful
                                    to its general business interests or public images even if unrelated to Service
                                    Provider’s obligations under the SPA, or(iv) complete an Assignment, which failure
                                    continues in effect or has otherwise not been remedied to JMG1 and J.M. Grove satisfaction
                                    within thirty (30) calendar days of JMG1 and J.M. Grove written notice thereof to
                                    Service Provider.<br />
                                                13.2 Corrections The failure to (i) correct rejected, defective or nonconforming
                                    workmanship, or (ii) repair or replace defective or nonconforming products or materials
                                    sourced, furnish, manufactured or fabricated by Service Provider within a commercially
                                    reasonable time, of thirty (30) calendar days or less, unless JMG1 and J.M. Grove
                                    provides a written extension of time<br />
                                                13.3 Payment to Others The failure of Service Provider to timely pay any Service
                                    Provider Personnel which failure results, or could result, in the placement of a
                                    lien, writ of execution or attachment, or other claim or security interest on or
                                    against any property of JMG1 and J.M. Grove or any property of JMG1 or J.M. Grove.
                                    Customer.<br />
                                                13.4 Liens The failure of Service Provider to satisfy, discharge, or release any
                                    lien, writ of execution or attachment, or other claim or security interest against
                                    the property of JMG1 and J.M. Grove or a customer filed in connection with the Services
                                    within ten (10) business days of the date that Service Provider was first made aware
                                    of such security interest.<br />
                                                13.5 Creditors and Bankruptcy (i) The making by Service by service Provider of an
                                    assignment for the benefit of creditors (ii) the institution of a judicial proceeding
                                    for the reorganization, liquidation, or involuntary dissolution of Service Provider
                                    or for its adjudication as bankrupt or insolvent, (iii) the appointment of receiver
                                    , trustee or liquidator of or for the property of Service Provider whereupon the
                                    receiver, trustee, or liquidator is not removed within thirty (30) calendar days
                                    of JMG1 and J.M.Grove written request or (iv) the taking advantage by Service Provider
                                    of any debtor relief proceedings, whereby the liabilities or obligations of Service
                                    Provider are, or are proposed to be, reduced, or payment therof deferred.<br />
                                                14 Remedies for Breach or Events of default.<br />
                                                14.1 Opportunity to Cure If Service Provider breaches any obligation under this
                                    SPA, or upon an Event of Default, JMG1 and J.M. Grove will provide written notice
                                    of the breach or event of default and an opportunity to cure. Unless a different
                                    period is specified in the written notice, Service Provider must cure the breach
                                    within thirty (30) calendar days of the date of the written notice. If Service Provider
                                    fails to cure within the applicable period, JMG1 and J.M. Grove may exercise an
                                    or more of the following remedies without any liability to Service Provider:<br />
                                                (a) Reject, in whole or in part, Service Provider’s submission for payment with
                                    respect to an Assignment under this SPA or, as the case may be, nullify, in whole
                                    or in part, a previously approved submission for payment;<br />
                                                (b) withhold from any sums due or that thereafter become due Service Provider the
                                    amount deemed necessary by JMG1 and J.M. Grove to protect JMG1 and J.M. Grove from
                                    actual or reasonably foreseeable direct damages resulting from the breach or Event
                                    of Default;<br />
                                                (c) Remove Service Provider from any or all Markets until Service Provider is no
                                    longer in breach of this SPA, or the Event of Default is ended:<br />
                                                (d) retain a third party to cure the breach or end the event of Default, at Service
                                    Provider’s sole expense which expense JMG1 and J.M. Grove may offset against any
                                    sums due or that there after become due Service Provider; or<br />
                                                (e) Terminate this SPA immediately upon written notice to Service Provider.<br />
                                                14.2 Cure of Remedies Service Provider’s cure of any breach or Event of Default
                                    under this SPA must be done in a manner satisfactory to both JMG1 and J.M. grove
                                    and the impacted Customer(s)<br />
                                                15 Termination<br />
                                                15.1 Breach of Default This Agreement may be terminated for cause (i.e. for breach
                                    or for the occurrence of an Event of Default) by JMG1 and J.M. Grove immediately
                                    upon expiration of the applicable cur period. If Service Provider commits the same
                                    or a substantially similar breach of this SPA, or if there is an occurrence of the
                                    same or a substantially similar Event of Default within six (6) months following
                                    the date that JMG1 and J.M. Grove became aware of the previous breach or Event of
                                    Default, JMG1 and J.M. Grove will have the right to immediately terminate this Spa.
                                    This right will not be waived if JMG1 and J.M. Grove permits the Service Provider
                                    to cure such subsequent breach or Event of Default within a reasonable amount of
                                    time.<br />
                                                15.2 Services Provider’s Obligations upon Termination Upon termination or expiration
                                    of this SPA, Service Provider must:<br />
                                                (a) Timely complete all Assignments;<br />
                                                (b) Pay to JMG1 and J.M. Grove all sums then due within thirty (30) calendar days
                                    after termination;<br />
                                                (c) Pay to JMG1 and J.M. Grove any sum that becomes due after termination within
                                    thirty (30) calendar days after the date it accrues<br />
                                                (d) return any and all property, including any confidential information, of JMG1
                                    and J.M. Grove and/or customer information in Service Provider’s possession or control
                                    within thirty (30) calendar days after termination;<br />
                                                (e) stop representing that Service Provider is or at any time was in a business
                                    relationship with JMG1 and J.M. Grove, except as necessary to fulfill any surviving
                                    obligations under this SPA; and<br />
                                                (f) Timely satisfy all obligations under this SPA still in effect.<br />
                                                15.4 JMG1 and J.M. Grove Obligations upon Termination. Upon termination of this
                                    Spa for any reason, JMG1 and J.M. Grove must:<br />
                                                (a) Pay all undisputed sums due Service Provider;<br />
                                                (b) Pay all undisputed sums that become due after termination;<br />
                                                (c) return Service Provider any and all property of Service Provider in JMG1 and
                                    J.M. Grove possession or control within thirty days after termination; and<br />
                                                (d) Satisfy any obligations remaining under this SPA.<br />
                                                15.5 Retainage JMG1 and J.M. Grove may withhold any payments due Service<br />
                                                16 Dispute Resolution.<br />
                                                16.1 Choice of Law. The laws of the State of Pennsylvania govern and control this
                                    SPA, and any disputes arising out or relating to it.<br />
                                                16.2 Non-Binding Mediation. All disputes by Service Provider shall first be referred
                                    to JMG1 and J.M. Grove Service Director and/or Installation Merchant and the Parties
                                    shall use good faith efforts to resolve such dispute. Before commencing legal or
                                    equitable action under Section 15.3 of this SPA. The mediation will, unless otherwise
                                    agreed in writing by the parties, be held in King of Russia, Pennsylvania, and will
                                    be conducted over a period of time not to exceed three (3) business days over a
                                    ten (10) business day period. The Parties will share equally the costs of any such
                                    mediation. If the Party that receives the request for mediation is not agreeable
                                    to pursuing mediation as a means of resolving the dispute, or if the Parties cannot
                                    agree upon a professional mediator, or if mediation fails to result In a resolution
                                    of the dispute then any Party may elect to proceed with further legal or equitable
                                    action under Section 16.3 of this SPA unless JMG1 and J.M. Grove elects binding
                                    arbitration under Section 16.4 of this Spa. Notwithstanding the foregoing, either
                                    party at any time may seek specific performance or injunctive relief if monetary
                                    damages or the ordinary forms of redress at law or as provided under this SPA would
                                    be inadequate.<br />
                                                17.9-17.15 Designated agent(s) may during the term and for a period of three (3)
                                    years following the terminate or expiration of this SPA, audit during normal business
                                    hours and upon not less than five (5) business days advance written notice to Service
                                    Provider, all books and records of Service Provider that are of direct relevance
                                    to Service Providers fulfillment of its obligations under this SPA. Service Provider’s
                                    authorized representative(s) or designated agent(s) may be present during such audit.<br />
                                                17.10 Notices" Any notices or other communication required to be in writing under
                                    this SPA must be either personally delivered; (2) sent by Certified mail, postage
                                    prepaid or (3) delivered by overnight courier,<br />
                                                addresses of the other Party set forth on the Face Page of this SPA- Notices are
                                    deemed to be served given upon receipt.<br />
                                                17.11 Survival. Termination of this SPA, alt provisions continue in effect as to
                                    disputed matters until resolved, as well as all provisions that survive termination
                                    of-this SPA, including without limitation, Service<br />
                                                Provider s various warranty obligations under this SPA, and Sections 3.2, 4,1, 4.2,
                                    4,4, 4,5, 4.8, 4.8, 5 7.57,k, 8, 9, 10, 11,5, 12, 14.l(d), 15,3, 15.5, 15, 17.5,
                                    17,8, 17.9 and 17,10.<br />
                                                17.12 Force Majeure. No Party will be in breach of this SPA if performance of its
                                    obligations or attempts to cure any breach or end an Event of default are delayed
                                    Of prevented by reason of any act of nature, fire,<br />
                                                disaster, failure of electrical power systems, or any other act or condition beyond
                                    the reasonable control of the Party affected ("_Event of Force Ma}aura"), provided
                                    that the affected Party makes commercially reasonable efforts to avoid or eliminate
                                    the causes of its nonperformance and continues performance immediately after such
                                    causes are eliminated. Notwithstanding this Section 17.12, any delay that exceeds
                                    sixty (60) calendar days will entitle the Party whose performance is not affected
                                    by the relevant Event of Force Majeure to terminate this SPA upon not less than
                                    thirty (30) calendar days' advance written notice to the other Party.<br />
                                                17.13 Entire Agreement. This SPA, together with the Face Page, exhibits, annexes,
                                    the SPRG and other duly incorporated attachments, constitutes the entire agreement
                                    and understanding between the parties. Any<br />
                                                previous negotiations, agreements or representations that have been made or retied
                                    upon that are not expressly set forth will have no force or effect.<br />
                                                17.14 Counterparts This SPA may be executed in one or more counterparts, each of
                                    which will be deemed an original, but all of which together will constitute one
                                    and the same instrument. 17.15 Other Provisions. Except where the context requires
                                    otherwise, whenever used, the singular includes the plural, the plural includes
                                    the singular, the word "or"' means "and/or, and the term "including" or "includes"<br />
                                                means "including without limitation," and without limiting the generality of any
                                    description preceding that term. When this SPA refers to a number of days, unless
                                    otherwise specified as business days, that reference is to calendar days, The headings
                                    in this SPA are provided for convenience only and do not affect its meaning. The
                                    wording of this SPA shall be deemed wording mutually chosen by the parties and no
                                    rule of strict construction shall be applied against either party. Any reference
                                    in this SPA to a Section, Annex, JMG, LLC AT JM Grove LLC HOLD HARMLESS AGREEMENT<br />
                                                I, the undersigned (“Subcontractor”) do not currently have Workers Compensation
                                    Insurance because I qualify for one or more of the allowable exemptions/exclusions
                                    listed below. I understand that Workers Compensation Insurance is mandatory in Hawaii,
                                    Idaho and New York.<br />
                                                In consideration of the Subcontractors engagement as detailed in the Independent
                                    Contractor Agreement and the services provided hereunder, the additional services
                                    that may be requested by JMG, LLC and other valuable consideration, the receipt
                                    and sufficiency of which are expressly acknowledged. JMG and Subcontractor hereby
                                    agree as follows:<br />
                                                If at any point in the future I am no longer exempt from obtaining Worker’s Compensation
                                    insurance, I will acquire the necessary Workers Compensation insurance before any
                                    of my employees are allowed to work on a job for which I have sub-contracted for
                                    JMG. A certificate of insurance will be provided to JMG at such time.<br />
                                                Sole Proprietorship/Partnership with no employees, that have rejected coverage and
                                    submitted the appropriate form and received the attached verification from the State
                                    Workers Compensation Agency that I am exempt and I have no employees and operate
                                    in:<br />
                                                Termination<br />
                                                Attachment 1 : TERM AND TERMINATION – ALTERNATE PROVISIONS Completion and execution
                                    of any of the provisions below requires the JMGrove legal department’s prior review
                                    and written approval. Absent such review and approval, the Effective Date of the
                                    SPA shall be deemed to be the date as of which the service provider affixed its
                                    signature to the Signature Page of the SPA; the initial term of the SPA shall be
                                    deemed to be one (1) year unless/until earlier terminated consistent with the SPA;
                                    the SPA shall continue in effect following the initial term, unless/until terminated
                                    consistent with the SPA; and the sections 2.1 of the SPA shall not be deemed modified
                                    or superseded. TERM OF AGREEMENT:<br />
                                                The following language supersedes the language in section 2.1 of the General Terms
                                    and Conditions if signed where indicated by an authorized representative(s) of both
                                    Parties: Beginning on the Effective Date, the SPA shall continue in effect for ______
                                    (______) year(s) (the “initial term”) unless/until earlier terminated consistent
                                    with the pertinent provisions of the SPA. Following the initial term, the SPA shall
                                    automatically renew for consecutive one year periods unless terminated pursuant
                                    to section 15 of the General Terms and Conditions of the SPA. ______________________________________________________Approval
                                    of The JMGrove Legal Department (required)______________________________________________________
                                    Signature of Service Providers Authorized Representative/Date______________________________________________________Signature
                                    of JMGrove’s Authorized Representative/Date TERMINATION FOR CONVENIENCE The following
                                    language supersedes the language in section 15.2 of the SPA if signed where indicated
                                    by an authorized representative of both Parties. Service Provider of JMGrove may,
                                    upon not less than _____ (_____) calendar days prior written notice to the other
                                    party, terminate the SPA at any time. _____________________________________________
                                    Approval of The JMGrove Legal Department.
                                            </asp:Panel>
                                        </div>

                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <%--</ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlstatus" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="btnPluse" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnMinus" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>--%>
                        <%--<ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server"
                                SuppressPostBack="true" ExpandedImage="~/img/minusicon.png" TargetControlID="pnl4"
                                CollapseControlID="pnl3" ExpandControlID="pnl3" CollapsedImage="~/img/plusicon.png"
                                Collapsed="true" ImageControlID="img2">
                            </ajaxToolkit:CollapsiblePanelExtender>--%>


                        <table>
                            <tr>
                                <td>

                                    <asp:CheckBox ID="chkboxcondition" runat="server" /><%--TabIndex="148" --%>

                                    <asp:Label ID="lblTerms" runat="server" Text="I accept Term and Conditions of the above mentioned Subcontract"></asp:Label>
                                </td>
                            </tr>
                        </table>

                    </div>
                    <div class="btn_sec">
                        <asp:Button ID="btncreate" Text="Create User" runat="server" OnClick="btncreate_Click" ValidationGroup="submit" />
                        <%--<asp:Button ID="btncreate" Text="Create User" runat="server" OnClick="btncreate_Click" ValidationGroup="submit" />--%>
                        <asp:Button ID="btnreset" Text="Reset" runat="server" OnClick="btnreset_Click" />
                        <%--TabIndex="210"--%>
                        <asp:Button ID="btnUpdate" Text="Update" runat="server" OnClick="btnUpdate_Click" ValidationGroup="submit" CausesValidation="False" />
                    </div>
                </div>
                <asp:Panel ID="panelPopup" runat="server">
                    <div id="light" class="white_content">
                        <h3></h3>
                        <%--<a href="javascript:void(0)" onclick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">
                Close</a>--%>
                        <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 100%"
                            cellpadding="0" cellspacing="0">
                            <tr style="background-color: #b04547">
                                <td colspan="2" style="color: White; font-weight: bold; font-size: larger"
                                    align="center"></td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">Email or Phone number already exists,do you want to update the existing record?
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2" style="height: 15px;"></td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Button ID="btnYesEdit" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Yes" Width="100px"
                                        ValidationGroup="IndiCred" OnClick="Yes_Click" />
                                    <%--TabIndex="119"--%>
                                    <%--<asp:Button ID="Button2" runat="server" OnClick="" />--%>
                                </td>
                                <td align="center">
                                    <asp:Button ID="Button2" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="No" Width="100px"
                                        ValidationGroup="IndiCred" OnClick="No_Click" /><%--TabIndex="119"--%>
                                    <%--<asp:Button ID="Button3" runat="server" OnClick="No_Click" />--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
                <div id="fade" class="black_overlay">
                </div>

                <asp:Panel ID="panel7" runat="server">
                    <div id="interviewDatelite" class="white_content" style="height: auto;">
                        <h3>Interview Details
                        </h3>
                        <%--<a href="javascript:void(0)" onclick="">Close</a>--%>
                        <asp:UpdatePanel runat="server" UpdateMode="Always">
                            <ContentTemplate>
                                <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 300px;"
                                    cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="center" style="height: 15px;">Date :
                                <asp:TextBox ID="dtInterviewDate" placeholder="Select Date" runat="server" ClientIDMode="Static" onkeypress="return false" TabIndex="104" Width="127px"></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" TargetControlID="dtInterviewDate" Format="MM/dd/yyyy" runat="server"></ajaxToolkit:CalendarExtender>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Select Date" ControlToValidate="dtInterviewDate" ValidationGroup="InterviewDate"></asp:RequiredFieldValidator>
                                        </td>
                                        <td align="center"></td>
                                        <td>Time :
                                    <asp:DropDownList ID="ddlInsteviewtime" runat="server" TabIndex="105" Width="112px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Recruiter</td>
                                        <td>: </td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlUsers" runat="server" />
                                            <asp:RequiredFieldValidator ID="rfvddlUsers" runat="server" ErrorMessage="Select Recruiter" ControlToValidate="ddlUsers"
                                                ValidationGroup="InterviewDate" InitialValue="0" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Task</td>
                                        <td>: </td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlTechTask" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <asp:Button ID="btnSaveInterview" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                                Style="height: 26px; font-weight: 700; line-height: 1em;" Text="OK" Width="100px" ValidationGroup="InterviewDate"
                                                TabIndex="119" OnClick="btnSaveInterview_Click" />
                                            <input type="button" value="Cancel" onclick="ClosePopupInterviewDate()" style="width: 100px; height: 26px; font-weight: 700; line-height: 1em;" />
                                            <%--<asp:Button ID="btnCancelInterview" runat="server" Text="Cancel" OnClick="btnCancelInterview_Click" Width="100px"
                                                Style="height: 26px; font-weight: 700; line-height: 1em;"
                                                OnClientClick="javascript:document.getElementById('interviewDatelite').style.display='none';document.getElementById('interviewDatefade').style.display='none'" />--%>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </asp:Panel>
                <div id="interviewDatefade" class="black_overlay">
                </div>

                <asp:Panel ID="panel5" runat="server">
                    <div id="litePassword" class="white_content">
                        <h3>Password
                        </h3>
                        <a href="javascript:void(0)" onclick="document.getElementById('litePassword').style.display='none';document.getElementById('fadePassword').style.display='none'">Close</a>
                        <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 70%"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" style="height: 54px; width: 200px;">Enter Password To Change Status
                                </td>
                                <td align="center" style="height: 54px;">
                                    <asp:TextBox ID="txtUserPassword" runat="server" placeholder="Enter Password" TextMode="Password"></asp:TextBox><%--TabIndex="513"--%>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Enter Password" ControlToValidate="txtPassword" ValidationGroup="Password"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2" style="height: 54px;">
                                    <asp:Button ID="btnPassword" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Save" Width="100px" ValidationGroup="Password"
                                        OnClick="btnPassword_Click" />
                                    <%--TabIndex="119"--%>
                                    <%--<asp:Button ID="Button2" runat="server" OnClick="" />--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
                <div id="fadePassword" class="black_overlay">
                </div>

                <asp:Panel ID="panel6" runat="server">
                    <div id="DivOfferMade" class="white_content" style="height: auto;">
                        <h3>Offer Made Details</h3>
                        <a href="javascript:void(0)" onclick="document.getElementById('DivOfferMade').style.display='none';document.getElementById('DivOfferMadefade').style.display='none'">Close</a>

                        <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 300px;"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <br />
                                    <label>
                                        Email<span><asp:Label ID="lblOfferReqEmail" Text="*" runat="server" ForeColor="Red"></asp:Label></span></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOfferReqMail" runat="server" MaxLength="40" Width="242px"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" runat="server" ControlToValidate="txtOfferReqMail"
                                        ValidationGroup="OfferPopUp" ForeColor="Red" ErrorMessage="Please Enter Email"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtOfferReqMail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                        Display="Dynamic" runat="server" ForeColor="Red" ErrorMessage="Please Enter a valid Email"
                                        ValidationGroup="OfferPopUp">
                                    </asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <label>
                                        Password<asp:Label ID="lblOfferPassword" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOfferPassword" runat="server" TextMode="Password" MaxLength="30"
                                        autocomplete="off" Width="242px"></asp:TextBox>
                                    <br />
                                    <label>
                                    </label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtOfferPassword"
                                        ValidationGroup="OfferPopUp" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Enter Password"></asp:RequiredFieldValidator><br />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <label>
                                        Confirm Password<asp:Label ID="Label4" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOfferConPassword" runat="server" TextMode="Password" autocomplete="off"
                                        MaxLength="30" EnableViewState="false" AutoCompleteType="None" Width="242px"></asp:TextBox>
                                    <br />
                                    <label>
                                    </label>
                                    <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="txtOfferConPassword"
                                        Display="Dynamic" ControlToCompare="txtOfferPassword" ForeColor="Red" ErrorMessage="Password didn't matched"
                                        ValidationGroup="OfferPopUp">
                                    </asp:CompareValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtOfferConPassword"
                                        ForeColor="Red" ValidationGroup="OfferPopUp" ErrorMessage="Enter Confirm Password"></asp:RequiredFieldValidator>

                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <asp:Button ID="btnSaveOfferMade" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Save" Width="100px" ValidationGroup="OfferPopUp"
                                        TabIndex="119" OnClick="btnSaveOfferMade_Click" />
                                    <%--<asp:Button ID="Button2" runat="server" OnClick="" />--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
                <div id="DivOfferMadefade" class="black_overlay">
                </div>


                <%-- <asp:Button ID="btnShowPopup" runat="server" Style="display: none" />
        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="btnShowPopup"
            PopupControlID="Panel6" CancelControlID="btnCancel" BackgroundCssClass="modalBackground"
            Enabled="true">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="Panel6" runat="server" BackColor="White" Height="600px" Width="800px"
            Style="display: none" ScrollBars="Vertical">
            <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 100%"
                cellpadding="0" cellspacing="0">
                <tr style="background-color: #b04547">
                    <td colspan="2" style="height: 10%; color: White; font-weight: bold; font-size: larger"
                        align="center"></td>
                </tr>
                <tr>
                    <td align="left" colspan="2">Email or Phone number already exists,do you want to update the existing record?
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        <asp:Button ID="btnYes" runat="server" OnClick="Yes_Click" />
                    </td>
                    <td>
                        <asp:Button ID="Button4" runat="server" OnClick="No_Click" />
                    </td>
                </tr>
            </table>
        </asp:Panel>--%>
            </div>
            <%--</div>--%>
    </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btncreate" />
            <asp:PostBackTrigger ControlID="txtZip" />
            <asp:PostBackTrigger ControlID="ddlstatus" />
            <asp:PostBackTrigger ControlID="ddlEmpType" />
        </Triggers>
    </asp:UpdatePanel>
    <div id="dialog" style="display: none" align="center"></div>
    
    <script type="text/javascript" src='<%=Page.ResolveUrl("~/js/jquery.dd.min.js")%>'></script>
    <script type="text/javascript" src='<%=Page.ResolveUrl("~/js/intTel/intlTelInput.js")%>'></script>
    <script type="text/javascript" src='<%=Page.ResolveUrl("~/js/dropzone.js")%>'></script>
    <script type="text/javascript">

        Dropzone.autoDiscover = false;

        $(function () {
            Initialize();
            $.fn.hitch = function (scope, fn) {
                return function () {
                    return fn.apply(scope, arguments);
                }
            }
        });

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Initialize();
        });

        function Initialize() {
            ApplyDropZone();
        }


        var objWorkFileDropzone;

        //Dropzone.autoDiscover = false;
        //Dropzone.options.dropzoneForm = false;

        function ApplyDropZone() {
            ////User's drag and drop file attachment related code

            //remove already attached dropzone.
            if (objWorkFileDropzone) {
                objWorkFileDropzone.destroy();
                objWorkFileDropzone = null;
            }

            objWorkFileDropzone = GetWorkFileDropzone("div.work-file", 'div.work-file-previews');
            //remove already attached dropzone.
        }

        function GetWorkFileDropzone(strDropzoneSelector, strPreviewSelector) {
            //;
            return new Dropzone(strDropzoneSelector,
                {
                    maxFiles: 5,
                    url: "UploadFile.aspx",
                    thumbnailWidth: 90,
                    thumbnailHeight: 90,
                    previewsContainer: strPreviewSelector,
                    acceptedFiles: ".png, .jpg, .jpeg, .tif, .gif ",
                    init: function () {
                        this.on("maxfilesexceeded", function (data) {
                            //var res = eval('(' + data.xhr.responseText + ')');
                            alert('you are reached maximum attachment upload limit.');
                        });

                        // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                        this.on("success", function (file, response) {
                            //;
                            var filename = response.split("^");
                            $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                            AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnWorkFiles.ClientID %>');

                            // saves attachment.
                            //$('#%=btnAddAttachment.ClientID%>').click(); console.log('clicked');
                            //this.removeFile(file);
                            //$(".loading").hide();
                        });
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

        $(document).ready(function () {


            $("#<%=ddlstatus.ClientID%>").click(function () {
                if ($('#<%=ddlstatus.ClientID%>').val() == "Active") {
                    $('#pnlcolaps').show(500);
                } else {
                    $("#pnlcolaps").hide(500);
                }
            });
            var des = $("#ddldesignation").val();
            $("#lnkW9").hide();
            $("#lnkw4").hide();
            $("#lnkI9").hide();
            $("#lnkEsrow").hide();
            $("#lnkface").hide();
            if (des == "ForeMan") {
                $("#lnkW9").hide();
                $("#lnkw4").show();
                $("#lnkI9").show();
                $("#lnkEsrow").hide();
                $("#lnkface").hide();
                Installer;
            }
            else if (des == "Installer") {
                $("#lnkW9").hide();
                $("#lnkw4").show();
                $("#lnkI9").show();
                $("#lnkEsrow").hide();
                $("#lnkface").hide();

            }
            else if (des == "SubContractor") {
                $("#lnkW9").show();
                $("#lnkw4").hide();
                $("#lnkI9").show();
                $("#lnkEsrow").show();
                $("#lnkface").show();

            }

            //On UpdatePanel Refresh
            //;
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm != null) {
                // ;
                prm.add_beginRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        $(".loading").show();
                    }
                });
                prm.add_endRequest(function (sender, e) {
                    if (sender._postBackSettings.panelsToUpdate != null) {
                        $(".loading").hide();
                        $("#<%=ddlstatus.ClientID %>").msDropDown();
                    }
                });

            };
        });

        try {
            $("#<%=ddlstatus.ClientID%>").msDropDown();
        } catch (e) {
            alert(e.message);
        }


        <%--try {
            $("#<%=ddlPhontType.ClientID%>").msDropDown();
        } catch (e) {
            alert(e.message);
        }
        --%>

    </script>

    <%--
    <asp:Panel ID="Panel2" runat="server">
                        <ul style="overflow: hidden; margin-bottom: 10px;">
                            <li style="width: 100%;">
                                
                            </li>
                            
                            <li style="width: 49%;">
                                 <asp:Panel ID="Panel4" runat="server">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                    <td class="auto-style14">How many full time positions have you had in the last 5 years?
                                                            <br />
                                        <br />
                                        <asp:TextBox ID="txtFullTimePos"  onkeypress="return IsNumeric(event);" MaxLength="2" runat="server" Width="222px" TabIndex="177"></asp:TextBox>
                                        <br />
                                        <br />
                                        <br />
                                        <br />
                                    </td>
                                </tr>--%>
    <%--<tr>
                                    <td class="auto-style15">
                                        Please list major tools you own for your primary trade only!
                                                        <asp:TextBox ID="txtMajorTools" runat="server" TextMode="MultiLine" Width="230px" Height="33px" TabIndex="181"></asp:TextBox>

                                        <br />

                                    </td>
                                </tr>
                                <%--<tr>
                                    <td class="auto-style15">Have you previously worked for or applied at j.m grove construction or supply? 
                                                        <br />
                                        <br />
                                        <asp:RadioButton ID="rdoJMApplyYes" runat="server" Text="Yes" GroupName="JMApply" TabIndex="188" />
                                        <asp:RadioButton ID="rdoJMApplyNo" runat="server" Text="No" GroupName="JMApply" TabIndex="189" />
                                    </td>
                                </tr>-%>
                                <tr>
                                    
                                </tr>


                                <tr>
                                    <td class="auto-style15">
                                        <label>
                                            Certification/training
                                        </label>
                                        &nbsp;<asp:FileUpload ID="flpCirtification" runat="server" Width="221px" TabIndex="201" />
                                        &nbsp;
                                                        <asp:Button ID="btnCirtification" runat="server" CssClass="cancel" with="10%" Text="Upload" Height="27px" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" OnClick="btnCirtification_Click" OnClientClick="return ValidateFileCirtificate()" TabIndex="202" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        How long have you been doing business under your present company name? Yrs.
                                                        <asp:TextBox ID="txtCurrentComp" runat="server" onkeypress="return IsNumeric(event);" TabIndex="204" MaxLength="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        Add Employee & Partners(If Any)
                                                        <br />
                                        <br />
                                        <label>Type:</label>
                                        <asp:DropDownList ID="ddlType" runat="server" TabIndex="206" ClientIDMode="Static">
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Employee" Value="Employee"></asp:ListItem>
                                            <asp:ListItem Text="Parnter" Value="Partner"></asp:ListItem>
                                        </asp:DropDownList>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlType" InitialValue="0" ValidationGroup="type" ForeColor="Red" ErrorMessage="Select type"></asp:RequiredFieldValidator>
                                        <br />
                                        <label>
                                            Name:</label>
                                        <asp:TextBox ID="txtName" runat="server" TabIndex="207" Width="242px"></asp:TextBox>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtName" runat="server" ValidationGroup="type" ForeColor="Red" ErrorMessage="Enter name"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        <asp:Button ID="btnAddEmpPartner" TabIndex="208" runat="server" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" ValidationGroup="type" CssClass="cancel" Height="27px" Text="Add" with="10%" OnClick="btnAddEmpPartner_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="auto-style15">
                                        <asp:UpdatePanel ID="UpdatePanel23" runat="server">
                                            <ContentTemplate>
                                                <asp:Panel runat="server" ID="Panel5">
                                                    <div class="form_panel" style="padding-bottom: 0px; min-height: 100px;">
                                                        <div class="grid">
                                                            <%--<table id="table2" class="auto-style11">
                                    <tr>
                                        <td>-%>
                                                            <asp:GridView ID="GridView2" Width="100%" ShowHeaderWhenEmpty="true" AutoGenerateColumns="False" AllowPaging="false" HeaderStyle-BackColor="#cccccc" AllowSorting="false" runat="server">
                                                                <EmptyDataTemplate>
                                                                    No data to display
                                                                </EmptyDataTemplate>
                                                                <Columns>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Deduction For" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeductionFor" runat="server" Text='<%#Eval("PersonName")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="True" HeaderText="Type" ControlStyle-ForeColor="Black"
                                                                        ItemStyle-HorizontalAlign="Center">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblType" runat="server" Text='<%#Eval("PersonType")%>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ControlStyle ForeColor="Black" />
                                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <br />
                                                            <%--</td>
                                    </tr>
                                </table>%>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="btnAddEmpPartner" EventName="Click" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                                           
                                    </table>
                                </asp:Panel>
                            </li>
                        </ul>
                    </asp:Panel>--%>
</asp:Content>
