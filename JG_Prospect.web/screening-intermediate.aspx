<%@ Page Title="" Language="C#" MasterPageFile="~/JGApplicant.Master" AutoEventWireup="true" CodeBehind="screening-intermediate.aspx.cs" Inherits="JG_Prospect.screening_intermediate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="screeningPopup" class="modal hide">
        <iframe id="ifScreening" style="width: 100%; overflow: auto; height: 100%;"></iframe>
    </div>

    <script type="text/javascript">
        var screeningDialog;
        function showScreeningPopup(urlToRedirect) {
            console.log("return url is: " + urlToRedirect);

            $("#ifScreening").attr('src', "screening-popup.aspx?returnurl=" + urlToRedirect);

            $('#screeningPopup').removeClass('hide');

          screeningDialog =  $('#screeningPopup').dialog({
                modal: false,
                height: 700,
                width: 1000,
                title: "Your attention required...",
                closeOnEscape: false,
                open: function (event, ui) {
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                }
            }).parent().appendTo($("#formScreening"));

            $('#screeningPopup').show();
            return true;
        }

    </script>
</asp:Content>
