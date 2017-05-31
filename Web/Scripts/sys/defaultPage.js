var successMsg = "Login proceessing...",
    dangerMsg = "Error in username or password.",
    $userN = $('#userName'),
    sURL = '/api/data/';

$('#userName').val('');
$('#passWord').val('');

// set cursor in first control
var focusControl = function () {
    $userN.focus();
}
String.prototype.endsWith = function (pattern) {
    var d = this.length - pattern.length;
    return d >= 0 && this.lastIndexOf(pattern) === d;
};
var goToWebPage = function () {
    var isDefaultRout = false;
    $(["default", "default.aspx", "/"]).each(function (index, value) {
        if (window.location.href.toLowerCase().endsWith(value)) {
            isDefaultRout = true;
        }
    });
    if (isDefaultRout) {
        window.location.href = 'home.aspx';
    }
    else {
        window.location.href = window.location.href;
    }
}
// show error message

// success alert

// start login
var userLogin = function () {
    var pass = $("#passWord").val(),
        _user = $userN.val();

    if (_user !== "" && pass !== "") {
        var dto = { "text1": _user, "text2": pass },
            url = sURL + "login";

        dataService.callAjax('GET', dto, url,
            function (data) {
                if (data == false) {
                    commonManger.showMessage('danger', 'Incorrect Data', 'Incorrect Data');
                } else if (data == true) {
                    window.open("/sys/home.aspx", "_self");
                }
            }, function (jqXhr, textStatus, errorThrown) {
                console.log(jqXhr, textStatus, errorThrown);
            });
    }// endif
    else {
        commonManger.showMessage('warning', 'Please enter username and password', 'Please Enter Data');
    }
}


// initialize page methods.
focusControl();
$userN.on("keypress", function (e) {
    if (e.which == 13) { // enter key
        e.preventDefault();
        $('#passWord').focus();
    }
});

$('#passWord').keypress(function (e) {
    //var $btn = $("#loginBtn").button('loading');
    if (e.which == 13) { // enter key
        e.preventDefault();
        userLogin();
    }
    //$btn.button('reset');
});

$("#loginBtn").click(function (e) {
    //var $btn = $(this).button('loading');
    e.preventDefault();
    userLogin();
    //$btn.button('reset');
});

$("#SendMebtn").click(function (e) {
    var emailinput = $("#emailinput").val();
    if (emailinput !== "") {
        var dto = JSON.stringify({ "Email": emailinput });
        var url = sURL + "SendEmail";
        dataService.callAjax('Post', dto, url,
            function (data) {
                if (data == true) {
                    commonManger.showMessage('success', 'Send Succefully', 'Please check your email');
                } else if (data == false) {
                    commonManger.showMessage('danger', 'Incorrect Data', 'Incorrect Data');
                }
            }, function (jqXhr, textStatus, errorThrown) {
                console.log(jqXhr, textStatus, errorThrown);
            });
    }// endif
    else {
        commonManger.showMessage('warning', 'Please Enter Data', 'Please Enter Data');

    }
});

jQuery(function ($) {
    $(document).on('click', '.toolbar a[data-target]', function (e) {
        e.preventDefault();
        var target = $(this).data('target');
        $('.widget-box.visible').removeClass('visible');//hide others
        $(target).addClass('visible');//show target
    });
});

//you don't need this, just used for changing background
jQuery(function ($) {
    $('#btn-login-dark').on('click', function (e) {
        $('body').attr('class', 'login-layout');
        $('#id-text2').attr('class', 'white');
        $('#id-company-text').attr('class', 'blue');

        e.preventDefault();
    });
    $('#btn-login-light').on('click', function (e) {
        $('body').attr('class', 'login-layout light-login');
        $('#id-text2').attr('class', 'grey');
        $('#id-company-text').attr('class', 'blue');

        e.preventDefault();
    });
    $('#btn-login-blur').on('click', function (e) {
        $('body').attr('class', 'login-layout blur-login');
        $('#id-text2').attr('class', 'white');
        $('#id-company-text').attr('class', 'light-blue');

        e.preventDefault();
    });
});