$(document).on('ready', function() {
  $('#year-picker').on('change', function() {
    $('#hidden-year-field').val($(this).val());
    $('#year-form').submit();
  });
});
