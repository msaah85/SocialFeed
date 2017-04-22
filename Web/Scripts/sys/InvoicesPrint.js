//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================
var pageManager = function () {
    "use strict";
    var Init = function () {
        // get report id
        var reportID = commonManger.getQueryStrs().id;
        getAllReport(reportID);

        // print report
        $('#printMe').click(function (e) {
            e.preventDefault();
            window.print();
        });
    },
    successSaved = function (data) {
        data = data.d;
        if (data.Status)
            window.location.href = 'InvoicesView.aspx';
    },
    BindReportControls = function (d) {
        var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list, jsn1 = $.xml2json(xml).list1;

        console.log(jsn);
        console.log(jsn1);

        if (jsn) {
            // set all data
            $.each(jsn, function (k, v) {
                $('#' + k).text(v);
            });

            // money format
            $('#TotalAmount').text(function () {
                return numeral($(this).text()).format('0,0');
            });
            // date format
            $('#AddDate').text(function () {
                return commonManger.formatJSONDateCal($(this).text(), 'dd/MM/yyyy');
            });
        }

        // expenses list
        if (jsn1) {
            var rows = $(jsn1).map(function (i, v) { return '<tr><td>' + (i + 1) + '</td><td>' + v.ExpenseName + '</td><td>' + numeral(v.Amount).format('0,0.00') + '</td></tr>'; }).get();
            $('.listItems tbody').append(rows);
        }
    },
    getAllReport = function (_id) {
        var functionName = "Invoices_SelectRow", DTO = { 'actionName': functionName, 'value': _id };
        dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetData', BindReportControls, commonManger.errorException);
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