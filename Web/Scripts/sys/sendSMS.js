//=======================================
// Developer: M. Salah (3-1-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var
    pageManager = pageManager || {},
    pageManager = function () {
        "use strict";

        var
            Init = function () {

                formName = 'masterForm';
                tableName = "Clients";


                DefaultGridManager.pageProperties();


                // events handler
                pageEvents();
            },
            pageEvents = function (cityID) {
                $('#CityID').change(function () {
                    var cityId = $(this).val();
                    getClients(cityId);
                });

                $('#SendAll').click(function (e) {
                    e.preventDefault();

                    // get all clients names and numbers from table
                    var message = $('#Message').val(),
                        clientsNumbers = getClientsToSMS(),
                        seUrl = '/api/sms.aspx/BulkSMS3',
                        unicode = $('#Lang label.active :radio').val(),
                        parm = { nums: clientsNumbers, msg: message, enAr: unicode ? unicode : 0 },
                        // show success/fail message
                        successSendCall = function (data) {
                            var jsnResult = commonManger.jsnFromXML(data.Result);


                            if (jsnResult && jsnResult.Status === 'Error')
                                commonManger.showMessage('SMS send results:', jsnResult.Error);
                            else
                                commonManger.showMessage('SMS has been sent:', jsnResult.Status + ' Your Message Queued for Delivery.');


                            console.log(jsnResult);
                        };

                    // send sms below to every one
                    if (message !== '' && clientsNumbers.length > 0) {
                        
                        dataService.callAjax('Post', JSON.stringify(parm), seUrl, successSendCall, commonManger.errorException);
                    }
                    else {
                        alert('Please enter sms message.')
                        $('#Message').focus();
                    }
                });


                //And for the first simple table, which doesn't have TableTools or dataTables
                //select/deselect all rows according to table header checkbox
                var active_class = 'active',
                    checkRows = function (rowsCount, th_checked) {
                        rowsCount = rowsCount ? rowsCount : 0;


                        $('#' + gridId + ' tbody > tr').each(function (i, row) {
                            //var row = this;

                            if (rowsCount === 0 || (i <= rowsCount)) {
                                if (th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
                                else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
                            }

                        });

                        calulateSelectedRowsCount();
                    };

                $('#' + gridId + ' > thead > tr > th input[type=checkbox]').eq(0).on('click', function () {
                    var th_checked = this.checked; //checkbox inside "TH" table header

                    // undefined select/not select all.
                    checkRows(undefined, th_checked)
                });

                //select/deselect a row when the checkbox is checked/unchecked
                $('#' + gridId).on('click', 'td input[type=checkbox]', function () {
                    var $row = $(this).closest('tr');
                    if ($row.is('.detail-row ')) return;
                    if (this.checked) $row.addClass(active_class);
                    else $row.removeClass(active_class);

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
                        }
                        else {
                            checkRows(_rowsToSelect, true);
                        }
                    }
                });

                // auto size textarea
                autosize($('textarea[class*=autosize]'));

                // message limit
                //var limitMsg = function (limit) {
                //    $('textarea.limited').inputlimiter({
                //        limit: limit ? limit : 140,
                //        remText: '%n character%s remaining...',
                //        limitText: 'max allowed : %n.'
                //    });
                //};
                //limitMsg();

                // change message limit by selecting the message language
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
            calulateSelectedRowsCount = function () {
                var selRows = $('#' + gridId + ' tbody tr.active').length;

                if (selRows > 0)
                    commonManger.showMessage(selRows + ' client(s) has been selected:', 'You have ' + selRows + ' clients selected for SMS message.');
            },
            getClientsToSMS = function () {
                var clientsArr = [];

                // loop all clients and get their mobile numbers in array.
                $('#' + gridId + ' tbody tr.active td:last-child').each(function () {
                    var //tr = $(this).closest('tr'),
                        mobile = uti.mobieFormat($(this).text());

                    // mobile number like 0500000000
                    if (mobile && mobile.length > 10) {

                        clientsArr.push(mobile);

                    }
                    else {
                        // add to bad numbers list
                    }
                });

                // remove duplicated numbers.
                var uniqueArr = clientsArr.length > 0 ?
                    clientsArr.filter(function (elem, index, self) {
                        return index === self.indexOf(elem);
                    }) : [];


                return uniqueArr.join(',');
            },
            getClients = function (cityID) {

                formName = 'aspnetForm';
                var prm = { actionName: tableName + '_ListByCity', value: cityID },
                    showClientsList = function (data) {

                        data = commonManger.decoData(data);
                        var list = data.list;


                        if (list) {
                            var rows = $(list).map(function (i, v) {
                                return '<tr><td class="center"><label class="pos-rel"><input name="no_' + v.Mobile + '" type="checkbox" class="ace"><span class="lbl"></span></label></td><td>' + v.ClientName + '</td><td>' + v.CityName + '</td><td>' + v.Mobile + '</td></tr>';
                            }).get();


                            $('#' + gridId + ' tbody').html(rows);
                            $('#clientsListPanel,#' + formName).removeClass('hidden');
                        }
                        else {
                            $('#clientsListPanel,#' + formName).addClass('hidden');
                            $('#' + gridId + ' tbody').html('');
                        }

                    };


                dataService.callAjax('GET', prm, sUrl + 'getdata',
                    showClientsList, commonManger.errorException);
            };


        return {
            Init: Init
        };

    }();