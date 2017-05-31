var targetdata;
modalDialog = "addModal";
formName = 'aspnetForm';
deleteModalDialog = 'deleteModal';
tableName = "SMS";
pKey = "SMSID";
gridId = "listItems";


gridColumns = [
    {
        "mDataProp": "Message",
        "bSortable": true
    },
    {
        "mDataProp": "AddDate",
        "bSortable": true,
        "mData": function (d) {
            return moment(d.AddDate).format('DD/MM/YYYY h:mm a');
        }
    },
    {
        "mDataProp": "NumbersCount",
        "bSortable": false
    },
    {
        "mDataProp": "Numbers",
        "bSortable": true
    },
    {
        "mDataProp": "MsgID",
        "bSortable": false,
        "mData": function (d) {
            return d.MsgID ? d.MsgID : '';
        }
    },
    {
        "mDataProp": null,
        "bSortable": false,
        "sClass": 'hidden-print',
        "mData": function () {
            return '<button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>'
        }
    }];


DefaultGridManager.Init();