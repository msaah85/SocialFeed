//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================
var pageManager = function () {
    "use strict";
    var Init = function () {
        // set buyers and shippers lists for binding.
        setFormProperties();

        $('#ExpenseID').change(function (e) {
            getDefaultValue($(this).val());
        });

        // add client Expense to grid.
        $('#btnAddAmount').click(function (e) {
            e.preventDefault();
            var expenseID = $('#ExpenseID').val();
            if (expenseID != '') {
                BindGrid();
            } else {
                commonManger.showMessage('Required fields', 'Please enter all required fields.');
            }
        });

        // remove row from grid.
        $('#listItems tbody').delegate('tr button.remove', 'click', function (e) {
            e.preventDefault();
            var el = $(this).closest('tr');
            if (el) {
                el.css({ 'transition': 'background-color 1s', 'background-color': 'red' }).fadeOut('slow').promise().done(function () { el.remove(); showPaymentsTotal(); });
            }
        });

        // update total
        $('#listItems tbody').delegate('tr input[type="number"]', 'keyup', function (e) {
            showPaymentsTotal();
        });


        // save all data
        $('#SaveAll').click(function (e) {
            e.preventDefault();
            SaveAllData();
        });

        // reset form on open
        $('#addModal').on('shown.bs.modal', function () {
            $("#ExpenseID").val('');
            $("#Cost,#Amount").val('0.0');
        })
    },
    // start Save data.
    SaveAllData = function () {
        if (validateMayData()) {

            var valuesDetails = $('#listItems tbody tr').map(function (i, v) {
                return '0,0,' + $(v).find('td:eq(0)').text() + ',' + numeral().unformat($(v).find('td:eq(2) input').val()) + ',' + numeral().unformat($(v).find('td:eq(3) input').val());
            }).get();

            var namesMaster = ['InvoiceID', 'ClientID', 'AddDate', 'Deleted', 'TotalAmount', 'Profit', 'ContainerNo', 'DeclarationNo'],
                valuesMaster = [$('#InvoiceID').val(), $('#ClientID').val(), $('#AddDate').val(), 0, numeral().unformat($('#TotalAmount').text()), numeral().unformat($('#TotalProfit').text()), $('#ContainerNo').val(), $('#DeclarationNo').val()],
                namesDetails = ['InvoiceDetailsID', 'InvoiceID', 'ExpenseID', 'Cost', 'Amount'];

            SaveDataMasterDetails(namesMaster, valuesMaster, namesDetails, valuesDetails);

        } else {
            commonManger.showMessage('Data required', 'Please enter all mandatory fields.')
        }
    },
    SaveDataMasterDetails = function (fieldsMaster, valuesMaster, fieldsDetails, valuesDetails) {
        var DTO = {
            'fieldsMaster': fieldsMaster, 'valuesMaster': valuesMaster, 'fieldsDetails': fieldsDetails, 'valuesDetails': valuesDetails
        };

        dataService.callAjax('Post', JSON.stringify(DTO), 'InvoiceAdd.aspx/SaveDataMasterDetails', successSaved, commonManger.errorException);
    },
    validateMayData = function () {
        // validate all data before SaveAllData.
        var _valid = true,
            requiredFields = {
                client: $('#ClientID').val(),
                gridLength: $('#listItems tbody tr').length,
                date: $('#AddDate').val(),
                container: $('#AddDate').val(),
                declaration: $('#AddDate').val()
            };
        if (requiredFields.client === '' || requiredFields.gridLength <= 0 || requiredFields.date === '' || requiredFields.container === '' || requiredFields.declaration === '')
            _valid = false;
        return _valid;
    },
    successSaved = function (data) {
        data = data.d;
        if (data.Status) {
            window.location.href = 'InvoicePrint.aspx?id=' + data.ID; //InvoicesView
        } else {
            commonManger.showMessage('Error!', 'Error occured!:' + data.message);
        }
    },
    bindFormControls = function (d) {
        var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list, jsn1 = $.xml2json(xml).list1;
        // expenses
        if (jsn) {
            var options = $(jsn).map(function (i, v) { return $('<option />').val(v.ExpenseID).text(v.ExpenseName); }).get();
            $('#ExpenseID').append(options).trigger('chosen:updated').trigger("liszt:updated");

            // fill grid with default expenses
            var rows = $(jsn).map(function (i, v) {
                return $('<tr><td>' + v.ExpenseID + '</td><td>' + v.ExpenseName + '</td>\
                             <td><input type="number" value="' + numeral(v.DefaultValue).format('0.0') + '" /></td><td><input type="number" value="' + numeral(v.DefaultValue).format('0.0') + '" /></td>\
                             <td><button class="btn btn-minier btn-danger remove" data-rel="tooltip" data-placement="top" data-original-title="Delete" title="Delete"><i class="fa fa-remove icon-only"></i></button></td></tr>');
            }).get(),
            _tbl = $('#listItems tbody');

            _tbl.append(rows);

            // show payments total amount.
            showPaymentsTotal();
        }
        // clients
        if (jsn1) {
            var options = $(jsn1).map(function (i, v) { return $('<option />').val(v.ClientID).text(v.ClientName); }).get();
            $('#ClientID').append(options).trigger('chosen:updated').trigger("liszt:updated");
        }
    },
    setFormProperties = function () {
        var functionName = "Invoices_Properties", DTO = { 'actionName': functionName };
        dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetDataDirect', bindFormControls, commonManger.errorException);
    },
    BindGrid = function () {
        var jsn = {
            ExpenseID: $('#ExpenseID').val(),
            ExpenseName: $('#ExpenseID option:selected').text(),
            Cost: $('#Cost').val(),
            Amount: $('#Amount').val()
        }, _tbl = $('#listItems tbody');

        if (jsn) {
            // collect table rows
            var rows = $(jsn).map(function (i, v) {
                return $('<tr><td>' + v.ExpenseID + '</td><td>' + v.ExpenseName + '</td>\
                             <td><input type="number" value="' + numeral(v.Cost).format('0.0') + '" /></td><td><input type="number" value="' + numeral(v.Amount).format('0.0') + '" /></td>\
                             <td><button class="btn btn-minier btn-danger remove" data-rel="tooltip" data-placement="top" data-original-title="Delete" title="Delete"><i class="fa fa-remove icon-only"></i></button></td></tr>');
            }).get(), isExist = false;

            $('#listItems tbody tr').each(function (i, item) {
                if ($(this).children('td:eq(0)').text() === jsn.ExpenseID)
                    isExist = true;
            });

            if (!isExist) {
                // populate to payments table
                _tbl.append(rows);
                // show payments total amount.
                showPaymentsTotal();
            } else {
                commonManger.showMessage('Data Exists:', 'Data already exists before.');
            }
        }

        $('.modal').modal('hide');
    },
    showPaymentsTotal = function () {
        var _totalCost = 0, _total4Cust = 0;
        $('#listItems tbody tr').each(function (i, item) {
            try {
                var cstVal = $(this).find('td:eq(2) input').val(),
                    custVal = $(this).find('td:eq(3) input').val();

                _totalCost += numeral().unformat(cstVal && !isNaN(cstVal) ? cstVal : 0) * 1; // cost
                _total4Cust += numeral().unformat(custVal && !isNaN(custVal) > 0 ? custVal : 0) * 1; // amount/customer
            }
            catch (err) { }
        });

        // show total amount and profit.
        $('#TotalAmount').text(numeral(_total4Cust).format('0,0.0')); // show invoice total
        $('#TotalProfit').text(numeral(_total4Cust - _totalCost).format('0,0.0')); // show invoice total

        // show final save button.
        if (_total4Cust > 0) {
            $('#SaveAll').removeClass('hidden');
        } else {
            $('#SaveAll').addClass('hidden');
        }

    },
    resetMyForm = function () {
        $('#aspnetForm')[0].reset();
        $('#listItems tbody').html('');
        $('#TotalAmountDhs').text('0');
    },
    getDefaultValue = function (no) {
        var functionName = "Expenses_SelectRow", prm = { 'actionName': functionName, 'value': no };
        dataService.callAjax('Post', JSON.stringify(prm), sUrl + 'GetData', function (data) {
            var xml = $.parseXML(data.d), jsn = $.xml2json(xml).list;
            if (jsn) { $('#Cost').val(numeral(jsn.DefaultValue).format('0.00')); $('#Amount').val(numeral((jsn.DefaultValue)).format('0.00')); }
        }, commonManger.errorException);
    };
    return {
        Init: Init
    };
}();