//=======================================
// Developer: M. Salah (3-1-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var pageManager = pageManager || {};
pageManager = function () {
    var
        Init = function () {
            tableName = 'Clients';
            smsProperties();

            // events handler
            pageEvents();
        },
        smsProperties = function () {
            var url = sUrl + 'GetDataDirect',
                obj = { actionName: 'SMS_Properties' },

                // bind data to controk on the form
                bindControlData = function (controlID, data) {
                    // select options
                    var options = $(data).map(function (i, v) {
                        var vKeys = Object.keys(v); // optionID, optionText
                        return $('<option />').val(v[vKeys[0]]).text(v[vKeys[1]]);
                    }).get();
                    // append options to select control
                    $(controlID).append(options);


                    $(controlID).chosen();
                },

                // handle returned data
                successCall = function (data) {
                    // json format
                    var allData = commonManger.decoData(data),
                        cities = allData.list,
                        // retuened lists count
                        smsSettings = allData.list1,
                        // settings
                        controlOnForm = '#CityID';

                    // show list
                    bindControlData(controlOnForm, cities);

                    // get sms settings
                    if (smsSettings) {
                        var $smsId = $('#Message');
                        $smsId.data('userid', smsSettings[0].Value);
                        $smsId.data('pass', smsSettings[1].Value);
                        $smsId.data('senderId', smsSettings[2].Value);
                    }
                };

            // featch data
            dataService.callAjax('GET', obj, url, successCall, commonManger.errorException);
        },
        pageEvents = function pageEvents() {
            $('#CityID').change(function () {
                var cityId = $(this).val();

                cityId = (cityId != null && cityId.length > 1) ? cityId.join(',') : cityId;

                getClients(cityId);
            });

            $('#SendAll').click(function (e) {
                e.preventDefault();

                // get all clients names and numbers from table
                var $message = $('#Message'),
                    _message = $message.val(),
                    clientsNumbers = getClientsToSMS(),
                    seUrl = '/api/sms/SMSToGroup',
                    unicode = $('#Lang label.active :radio').val(),
                    parm = {
                        MobileNo: clientsNumbers,
                        Message: _message,
                        Unicode: unicode ? unicode : 0,
                        UserID: $message.data('userid'),
                        Password: $message.data('pass'),
                        SenderID: $message.data('senderId')
                    },

                    // show success/fail message
                    successSendCall = function successSendCall(data) {

                        var jsnResult = commonManger.jsnFromXML(data);

                        if (jsnResult && jsnResult.Status === 'OK')
                            commonManger.showMessage('Success!:', jsnResult.Status + ' Your Message Queued for Delivery.');
                        else
                            commonManger.showMessage('SMS send results:', jsnResult.Error);
                    };

                // send sms below to every one
                if (_message !== '' && clientsNumbers.length > 0) {
                    dataService.callAjax('POST', JSON.stringify(parm), seUrl, successSendCall, commonManger.errorException);
                } else {
                    alert('Please enter sms message.');
                    $('#Message').focus();
                }
            });

            //And for the first simple table, which doesn't have TableTools or dataTables
            //select/deselect all rows according to table header checkbox
            var active_class = 'active',
                checkRows = function checkRows(rowsCount, th_checked) {
                    rowsCount = rowsCount ? rowsCount : 0;

                    $('#' + gridId + ' tbody > tr').each(function (i, row) {
                        //var row = this;
                        if (rowsCount === 0 || i <= rowsCount) {
                            if (th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true); else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
                        }
                    });

                    calulateSelectedRowsCount();
                };

            $('#' + gridId + ' > thead > tr > th input[type=checkbox]').eq(0).on('click', function () {
                var th_checked = this.checked; //checkbox inside "TH" table header

                // undefined select/not select all.
                checkRows(undefined, th_checked);
            });

            //select/deselect a row when the checkbox is checked/unchecked
            $('#' + gridId).on('click', 'td input[type=checkbox]', function () {
                var $row = $(this).closest('tr');
                if ($row.is('.detail-row ')) return;
                if (this.checked) $row.addClass(active_class); else $row.removeClass(active_class);

                // calculate selected rows
                calulateSelectedRowsCount();
            });

            $('a.select-rows').click(function (e) {
                e.preventDefault();

                var _rowsToSelect = $(this).data('rows');

                if (_rowsToSelect) {
                    // reset selection
                    checkRows(undefined, false);

                    // select first n rows
                    if (_rowsToSelect === 0) {
                        checkRows(undefined, true);
                    } else {
                        checkRows(_rowsToSelect, true);
                    }
                }
            });

            // auto size textarea
            autosize($('textarea[class*=autosize]'));

            ////message limit
            //var limitMsg = function (limit) {
            //    $('textarea.limited').inputlimiter({
            //        limit: limit ? limit : 140,
            //        remText: '%n character%s remaining...',
            //        limitText: 'max allowed : %n.'
            //    });
            //};
            //limitMsg();

            ////change message limit by selecting the message language
            //$('input[type=radio][name="Lang"]').change(function () {
            //    var _this = $(this),
            //        valu = _this.val(),
            //        txtMesg = $('textarea.limited'),
            //        minLimit = 70;

            //    if (valu === '1') { // Arabic
            //        txtMesg.attr('maxlength', minLimit);
            //        limitMsg(minLimit);

            //        if (txtMesg.val().toString().length > minLimit) {
            //            txtMesg.val(function () {
            //                return $(this).val().substring(0, minLimit);
            //            });
            //        }
            //    } else { // English
            //        txtMesg.attr('maxlength', 140);
            //        limitMsg();
            //    }
            //});
        },
        calulateSelectedRowsCount = function calulateSelectedRowsCount() {
            var selRows = $('#' + gridId + ' tbody tr.active').length;

            if (selRows > 0) commonManger.showMessage(selRows + ' client(s) has been selected:', 'You have ' + selRows + ' clients selected for SMS message.');
        },
        getClientsToSMS = function getClientsToSMS() {
            var clientsArr = [];

            // loop all clients and get their mobile numbers in array.
            $('#' + gridId + ' tbody tr.active td:last-child').each(function () {
                var //tr = $(this).closest('tr'),
                    mobile = uti.mobieFormat($(this).text());

                // mobile number like 0500000000
                if (mobile && mobile.length > 10) {

                    clientsArr.push(mobile);
                } else {
                    // add to bad numbers list
                }
            });

            // remove duplicated numbers.
            var uniqueArr = clientsArr.length > 0 ? clientsArr.filter(function (elem, index, self) {
                return index === self.indexOf(elem);
            }) : [];

            return uniqueArr.join(';');
        },
        getClients = function getClients(cityID) {
            formName = 'aspnetForm';

            var
                prm = {
                    actionName: tableName + '_ListByCity',
                    value: cityID
                },
                showClientsList = function showClientsList(data) {

                    data = commonManger.decoData(data);
                    var list = data.list;

                    if (list) {
                        var rows = $(list).map(function (i, v) {
                            return '<tr><td class="center"><label class="pos-rel"><input name="no_' + v.Mobile + '" type="checkbox" class="ace"><span class="lbl"></span></label></td><td>' + v.ClientName + '</td><td>' + v.CityName + '</td><td>' + v.Mobile + '</td></tr>';
                        }).get();

                        $('#' + gridId + ' tbody').html(rows);
                        $('#clientsListPanel,#' + formName).removeClass('hidden');
                    } else {
                        $('#clientsListPanel,#' + formName).addClass('hidden');
                        $('#' + gridId + ' tbody').html('');
                    }
                };



            dataService.callAjax('GET', prm, sUrl + 'getdata', showClientsList, commonManger.errorException);
        };

    return {
        Init: Init
    };
}();