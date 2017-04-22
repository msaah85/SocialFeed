//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================
var pageManager = function () {
    "use strict";
    var Init = function () {
        getReport();

        // print report
        $('#printMe').click(function (e) {
            e.preventDefault();
            window.print();
        });
    },
    BindReportControls = function (d) {
        var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list;

        if (jsn) {
            $.each(jsn, function (k, v) {
                $('#' + k).text(numeral(v).format('0,0.00'));
            });

            // balance
            $('#TotalBalances').text(function () {
                var balance = parseFloat(jsn.TotalInvoices) - parseFloat(jsn.TotalPayments);

                if (balance > 0) { $(this).removeClass('red').addClass('green'); } // profit case

                return numeral(balance).format('0,0.00');
            });

            //// date format
            $('#AddDate').text(function () {
                return commonManger.formatJSONDateCal(new Date(), 'dd/MM/yyyy');
            });
        }
    },
    getReport = function () {
        var functionName = "Balances_Select", DTO = { 'actionName': functionName };
        dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetDataDirect', BindReportControls, commonManger.errorException);
    },
    showPaymentsTotal = function () {
        var _total = 0;
        $('#listItems tbody tr').each(function (i, item) {
            _total += numeral($(this).children('td:eq(2)').text()) * 1;
        });

        // show final save button.
        if (_total > 0) {
            $('#SaveAll').removeClass('hidden');
        } else {
            $('#SaveAll').addClass('hidden');
        }

        // show total amount.
        $('#AmountDhs').val(numeral(_total).format('0,0'));
        _total = numeral(_total).format('0,0.0');
        $('#TotalAmountDhs').text(_total);
    };
    return {
        Init: Init
    };
}();