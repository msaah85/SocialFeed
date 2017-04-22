var targetdata; modalDialog = "addModal";
formName = 'aspnetForm'; deleteModalDialog = 'deleteModal';
tableName = "Clients"; pKey = "ClientID"; gridId = "listItems";


gridColumns = [
    {
        "mDataProp": "ClientID",
        "bSortable": true
    },
{
    "mDataProp": "ClientName",
    "bSortable": true
},
{
    "mDataProp": "Mobile",
    "bSortable": false,
    //"sClass": "hidden-480"
},
{
    "mDataProp": "CityName",
    "bSortable": false
},
{
    "mDataProp": "Address",
    "bSortable": false,
    "sClass": "hidden-480"
},
{
    "mDataProp": null,
    "bSortable": false,
    "sClass": 'hidden-print',
    "mData": function () {
        return '<button class="btn btn-primary btn-mini edit" title="Edit"><i class="fa fa-pencil"></i></button> ' +
               '<button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>'
    }
}];
DefaultGridManager.Init();
DefaultGridManager.pageProperties();


//$.fn.beforeSave = function () {
//    if ($('#RouteURL').val().trim() == "") {
//        var news_title = $('#news_title').val();
//        news_title = news_title.replace(/\s+/g, '-').toLowerCase();
//        $('#RouteURL').val(news_title);
//        return true;
//    }
//    else { return true }
//}
//$.fn.afterLoadData = function (ArrayData) {
//    targetdata = ArrayData;
//}

//validation
$('#aspnetForm').validate({
    errorElement: 'div',
    errorClass: 'help-block',
    focusInvalid: false,
    ignore: "",
    highlight: function (e) {
        $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
    },
    success: function (e) {
        $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
        $(e).remove();
    },
    errorPlacement: function (error, element) {
        if (element.is('input[type=checkbox]') || element.is('input[type=radio]')) {
            var controls = element.closest('div[class*="col-"]');
            if (controls.find(':checkbox,:radio').length > 1) controls.append(error);
            else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
        }
        else if (element.is('.select2')) {
            error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
        }
        else if (element.is('.chosen-select')) {
            error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
        }
        else error.insertAfter(element.parent());
    },

    submitHandler: function (form) {
    },
    invalidHandler: function (form) {
    }
});
$('#btnSave').click(function (e) {
    e.preventDefault();
    $('#aspnetForm').submit();
});