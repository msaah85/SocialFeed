//=======================================
// Developer: M. Salah (30-5-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var pageManager = pageManager || {};
pageManager = function () {
    var
        Init = function Init() {
            getStatistics();
        },
        getStatistics = function smsProperties() {
            var url = sUrl + 'GetDataDirect',
                obj = { actionName: 'Dashboard' },

                // handle returned data
                successCall = function successCall(data) {
                    // json format
                    var allData = commonManger.decoData(data),
                        jsn = allData.list;


                    // get sms settings
                    if (jsn) {
                        $.each(jsn, function (k, v) {
                            $('#' + k).text(v);
                        });
                    }
                };


            // featch data
            dataService.callAjax('GET', obj, url, successCall,
                commonManger.errorException);
        };

    return {
        Init: Init
    };
}();
