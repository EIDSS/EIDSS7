$(document).ready(function () {
    $(".slidetab").click(function () {
        $(".sidebar").toggle();
    });
});

function clearSearch() {
    $('.sidebar input[type="text"]').val('');
    $('.sidebar select > option:first').attr('selected', 'selected');
}