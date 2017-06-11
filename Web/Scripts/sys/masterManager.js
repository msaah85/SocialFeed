jQuery(function ($) {
    $('[data-rel="tooltip"]').tooltip();

    $('[data-rel=popover]').popover({ container: 'body' });

    autosize($('textarea[class*=autosize]'));

    $('.show-details-btn').on('click', function (e) {
        e.preventDefault();
        $(this).closest('tr').next().toggleClass('open');
        $(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
    });

    $('.date-picker').datepicker({
        autoclose: true,
        todayHighlight: true
    });

    $('.today').datepicker('setDate', new Date());

});

var setNavigation = function () {
    var path = location.href.toLowerCase().replace(/\/$/, ""); path = decodeURIComponent(path); $('.nav-list li.active').removeClass('active'); $("#sidebar ul.nav-list a").each(function () { var href = $(this).attr('href').toLowerCase(); if (path.indexOf(href) > -1) { $(this).closest('li').addClass('active').parent().parent().addClass("active open"); } });
}
setNavigation();