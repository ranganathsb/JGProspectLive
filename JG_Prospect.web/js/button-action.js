// States
// 
var callStorage = {}, timer = "00:00:00";
(function ($){
  window.numberArray = [],
  window.phoneNumber = '',
  window.updateDisplay,
  window.numberDisplayEl,
  window.inCallModeActive,
  window.dialpadButton = $('div#dialpad li'),
  window.dialpadCase = $('div#dialpad'),
  window.clearButton = $('#actions .clear'),
  window.callButton = $('#actions .call'),
  window.actionButtons = $('#actions'),
  window.skipButton = $('#actions .skip'),
  window.numberDisplayEl = $('#numberDisplay input');

  function compilePhoneNumber(numberArray){
    if (window.numberArray.length > 1){ 
      window.phoneNumber = window.numberArray.join('');
    } else {
      window.phoneNumber = window.numberArray
    }
    return this.phoneNumber;
  };

  function updateDisplay(phoneNumber){
    window.numberDisplayEl.val(window.phoneNumber);
  };

  function clearPhoneNumber(){
    window.numberDisplayEl.val('');
    window.phoneNumber = '';
    window.numberArray = [];
  };

  function callNumber(){
    //window.numberDisplayEl.val('Calling...');
    activateInCallInterface();
    // Need timer interval to animate . . .
    // Trigger  "Hangup"
    // Trigger  "Call timer"
  };

  function holdNumber(){
    window.numberDisplayEl.val('On Hold.');
    changeHoldIntoUnhold();
  };

  function changeHoldIntoUnhold(){
    window.skipButton.html('Unhold');
    window.skipButton.addClass('ready');
  };

  function changeUnholdIntoHold(){
    window.skipButton.html('Hold');
  };

  function activateInCallInterface(){
    changeClearIntoHangUp();
    changeSkipIntoHold();
    disableCallButton();
    disableDialButton();
    removeReadyFromCall();
    enableReadOnlyInput();
    window.inCallModeActive = true;
  };

  function disableInCallInterface(){
    removeReadOnlyInput();
    enableCallButton();
    changeHoldIntoSkip();
    window.inCallModeActive = false;
  }

  function disableCallButton(){
    window.callButton.addClass('deactive');
  };

  function enableCallButton(){
    window.callButton.removeClass('deactive');
  };

  function enableDialButton(){
    window.dialpadCase.removeClass('deactive');
  };

  function disableDialButton(){
    window.dialpadCase.addClass('deactive');
  };

  function changeSkipIntoHold(){
    window.skipButton.html('Hold');
  };

  function changeHoldIntoSkip(){
    window.skipButton.html('Skip');
  };

  function changeClearIntoHangUp(){
    window.clearButton.html('Hang Up');
    window.clearButton.addClass('hangup');
  };

  function changeHangUpIntoClear(){
    if( window.clearButton.html('Hang Up') ){
      window.clearButton.html('Clear');
      window.clearButton.removeClass('hangup');
    }
  };

  function enableReadOnlyInput(){
    window.numberDisplayEl.attr('readonly','readonly');
  }

  function removeReadOnlyInput(){
    window.numberDisplayEl.removeAttr('readonly');
  }

  function refreshInputArray(){
    this.numberDisplayElContent = window.numberDisplayEl.val(); 
    window.numberArray = this.numberDisplayElContent.split('');
  };

  window.dialpadButton.click(function(){
    if( !$(dialpadCase).hasClass('deactive') ){
      var content = $(this).html();
      refreshInputArray();
      window.numberArray.push(content);
      compilePhoneNumber();
      updateDisplay();
      checkDisplayEl();
      saveNumberDisplayEl();
    }
  });

  window.skipButton.click(function(){
    if (window.inCallModeActive == true){
      holdNumber();
    }
  });

  function checkDisplayEl(){
    if( window.numberDisplayEl.val() != "" ){
      addReadyToClear();
      addReadyToCall();
      enableActionButtons();
    } else if ( window.numberDisplayEl.val() == "" ) {
      removeReadyFromClear();
      removeReadyFromCall();
      disableActionButtons();
    }
  }

  function disableActionButtons(){
    window.actionButtons.addClass('deactive');
  }

  function enableActionButtons(){
    window.actionButtons.removeClass('deactive');
  }

  function addReadyToCall(){
    window.callButton.addClass('ready');
  }

  function removeReadyFromCall(){
    window.callButton.removeClass('ready');
  }

  function addReadyToClear(){
    window.clearButton.addClass('ready');
  }

  function removeReadyFromClear(){
    window.clearButton.removeClass('ready');
  }

  function saveNumberDisplayEl(){
    lastNumberDisplayEl = window.numberDisplayEl.val()
  }

  function displayLastSavedNumberDisplayEl(){
    console.log('Last displayed element value: ' + lastNumberDisplayEl);
  }

  $('div#actions li.clear').click(function(){
    enableCallButton();
    enableDialButton();
    clearPhoneNumber();
    removeReadOnlyInput();
    changeHangUpIntoClear();
    updateDisplay();
    checkDisplayEl();
    disableInCallInterface();
  });

  $('div#actions li.call').click(function(){
    callNumber();
  });

})(jQuery);


function webrtcNotSupportedAlert() {
    $('#txtStatus').text("");
    alert("Your browser doesn't support WebRTC. You need Chrome 25 to use this demo");
}

function isNotEmpty(n) {
    return n.length > 0;
}

function formatUSNumber(n) {
    var dest = n.replace(/-/g, '');
    dest = dest.replace(/ /g, '');
    dest = dest.replace(/\+/g, '');
    dest = dest.replace(/\(/g, '');
    dest = dest.replace(/\)/g, '');
    if (!isNaN(dest)) {
        n = dest
        if (n.length == 10 && n.substr(0, 1) != "1") {
            n = "1" + n;
        }
    }
    return n;
}

function replaceAll(txt, replace, with_this) {
    return txt.replace(new RegExp(replace, 'g'), with_this);
}

function initUI() {
    //callbox
    $('#callcontainer').hide();
    $('#btn-container').hide();
    $('#status_txt').text('Waiting login');
    $('#login_box').show();
    $('#logout_box').hide();
}

function callUI() {
    //show outbound call UI
    dialpadHide();
    $('#incoming_callbox').hide('slow');
    $('#callcontainer').show();
    $('#status_txt').text('Ready');
    $('#make_call').text('Call');
}

function IncomingCallUI() {
    //show incoming call UI
    $('#status_txt').text('Incoming Call');
    $('#callcontainer').hide();
    $('#incoming_callbox').show('slow');
}

function callAnsweredUI() {
    $('#incoming_callbox').hide('slow');
    $('#callcontainer').hide();
    dialpadShow();
}


function onReady() {
    console.log("onReady...");
    //$('#status_txt').text('Login');
    //$('#login_box').show();
}

function login() {
    Plivo.conn.login($("#username").val(), $("#password").val());
}

function logout() {
    Plivo.conn.logout();
}

function onLogin() {
    //$('#status_txt').text('Logged in');
    $('#login_box').hide();
    $('#logout_box').show();
    $('#callcontainer').show();
}

function onLoginFailed() {
    $('#status_txt').text("Login Failed");
}

function onLogout() {
    initUI();
}

function onCalling() {
    console.log("onCalling");
    $('#status_txt').text('Connecting....');
}

function onCallRemoteRinging() {
    $('#status_txt').text('Ringing..');
}

function onCallAnswered() {
    console.log('onCallAnswered');
    callAnsweredUI();
    $('#status_txt').text('Call Answered');
    timer = 0;
    window.calltimer = setInterval(function () {
        timer = timer + 1;
        $('#callDuration').html(timer.toString().calltimer());
    }, 1000);
}

function onCallTerminated() {
    console.log("onCallTerminated");
    callUI();
}

function onCallFailed(cause) {
    console.log("onCallFailed:" + cause);
    callUI();
    $('#status_txt').text("Call Failed:" + cause);
    $('#actions .clear').trigger('click');
    callOff(cause);
}
function date() {
    return (new Date()).toISOString().substring(0, 10) + " " + Date().split(" ")[4];
}
function call() {
    var dest = $("#to").val();
    $('#callDuration').text('');
    if (isNotEmpty(dest)) {
        $('#status_txt').text('Calling..');
        Plivo.conn.call(dest);
        callStorage.mode = "out";
        callStorage.startTime = date();
        callStorage.num = dest;
        timer = 0;
        window.calltimer = setInterval(function () {
            timer = timer + 1;
            $('#callDuration').html(timer.toString().calltimer());
        }, 1000);
    }
    else {
        $('#status_txt').text('Invalid Destination');
        setTimeout(function () {
            $('#actions .clear').trigger('click');
        }, 1000);
    }
    /*
    if ($('#make_call').text() == "Call") {
        var dest = $("#to").val();
        if (isNotEmpty(dest)) {
            $('#status_txt').text('Calling..');

            Plivo.conn.call(dest);
            $('#make_call').text('End');
        }
        else {
            $('#status_txt').text('Invalid Destination');
        }

    }
    else if ($('#make_call').text() == "End") {
        $('#status_txt').text('Ending..');
        Plivo.conn.hangup();
        $('#make_call').text('Call');
        $('#status_txt').text('Ready');
    }
    */
}

function hangup() {
    $('#status_txt').text('Hanging up..');
    Plivo.conn.hangup();
    callUI();
    $('#status_txt').text('Ready');
    callOff();
}

function dtmf(digit) {
    console.log("send dtmf=" + digit);
    Plivo.conn.send_dtmf(digit);
}
function dialpadShow() {
    $('#btn-container').show();
}

function dialpadHide() {
    $('#btn-container').hide();
}

function mute() {
    Plivo.conn.mute();
    $('#linkUnmute').show('slow');
    $('#linkMute').hide('slow');
}

function unmute() {
    Plivo.conn.unmute();
    $('#linkUnmute').hide('slow');
    $('#linkMute').show('slow');
}

function onIncomingCall(account_name, extraHeaders) {
    console.log("onIncomingCall:" + account_name);
    console.log("extraHeaders=");
    for (var key in extraHeaders) {
        console.log("key=" + key + ".val=" + extraHeaders[key]);
    }
    IncomingCallUI();
}

function onIncomingCallCanceled() {
    callUI();
}

function onMediaPermission(result) {
    if (result) {
        console.log("get media permission");
    } else {
        alert("you don't allow media permission, you can't make a call until you allow it");
    }
}

function answer() {
    console.log("answering")
    $('#status_txt').text('Answering....');
    Plivo.conn.answer();
    callAnsweredUI()
}

function reject() {
    callUI()
    Plivo.conn.reject();
}

$(document).ready(function () {
    Plivo.onWebrtcNotSupported = webrtcNotSupportedAlert;
    Plivo.onReady = onReady;
    Plivo.onLogin = onLogin;
    Plivo.onLoginFailed = onLoginFailed;
    Plivo.onLogout = onLogout;
    Plivo.onCalling = onCalling;
    Plivo.onCallRemoteRinging = onCallRemoteRinging;
    Plivo.onCallAnswered = onCallAnswered;
    Plivo.onCallTerminated = onCallTerminated;
    Plivo.onCallFailed = onCallFailed;
    Plivo.onMediaPermission = onMediaPermission;
    Plivo.onIncomingCall = onIncomingCall;
    Plivo.onIncomingCallCanceled = onIncomingCallCanceled;
    Plivo.init();
    Plivo.conn.login('jgdeveloper180225074457', 'Admin@123');
});

String.prototype.calltimer = function () {
    var sec_num = parseInt(this, 10);
    var hours = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);
    if (hours < 10) { hours = "0" + hours; }
    if (minutes < 10) { minutes = "0" + minutes; }
    if (seconds < 10) { seconds = "0" + seconds; }
    return hours + ':' + minutes + ':' + seconds;
}

function callOff(reason) {
    if (typeof reason == "object") {
       // customAlert('Hangup', JSON.stringify(reason));
    } else if (typeof reason == "string") {
       // customAlert('Hangup', reason);
    }
    window.calltimer ? clearInterval(window.calltimer) : false;
    callStorage.dur = timer.toString().calltimer();
    if (timer == "00:00:00" && callStorage.mode == "in") {
        callStorage.mode = "missed";
    }
    //saveCallLog(callStorage);
    //$('#callstatus').html('Idle');
    //$('.callinfo').hide();
    callStorage = {}; // reset callStorage
    timer = "00:00:00"; //reset the timer
    setTimeout(function () {
        $('#callDuration').html('');
    },3000);
}