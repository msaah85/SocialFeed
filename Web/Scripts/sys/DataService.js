/// <reference path="../jquery-1.10.2" />

var dataService = function () {
    var
        callAjax = function (reqestType, postedData, url, successCallback, errorCallback) {
            jqueryAjax(reqestType, postedData, url, successCallback, errorCallback);
        },
        jqueryAjax = function (reqestType, postedData, url, successCallback, errorCallback) {
            $.ajax({
                type: reqestType,
                data: postedData,
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                url: url,
                success: function (data) {
                    successCallback(data);
                },
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Content-Encoding", "gzip");
                    $(".sinpper").html("<i class='icon-spinner icon-spin orange bigger-125'></i>");
                    $('div[id$=UpdateProgress1]').css('display', 'block');
                },
                complete: function () {
                    $(".sinpper").html(""); $('div[id$=UpdateProgress1]').css('display', 'none');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    errorCallback(jqXHR, textStatus, errorThrown);
                }
            });
        };
    return {
        callAjax: callAjax
    };
}();


