jQuery(function ($) {
    var removeSelectedFile = function () {
        $('.ace-file-input a.remove').trigger('click');
    };

    $('input[type="file"]').ace_file_input({
        no_file: 'No File ...',
        btn_choose: 'Choose',
        btn_change: 'Change',
        droppable: false,
        onchange: null,
        thumbnail: true //| true | large
        , whitelist: 'xls|xlsx|csv|xlsb'
        , blacklist: 'exe|php|asp|aspx|jpg|png'
        , before_change: function (file, dropped) {
            // validate the selected file type as excel
            if (file[0]) {
                var ext = file[0].name.split('.').pop().toLowerCase();
                if ($.inArray(ext, ['xlsx']) == -1) {
                    alert('Invalid extension!, please select excel file');
                    removeSelectedFile();
                    return false;
                }
                // validate file size
                if (file[0].size > 10000000) { // 10 MB
                    alert('Large size!, a maximum size of excel file 10 MB.');
                    removeSelectedFile();
                    return false;
                }
            }
            return true;
        }
    });
});