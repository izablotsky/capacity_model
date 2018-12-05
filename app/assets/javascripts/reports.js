$(document).on('ready', function() {
  $('#year-picker').on('change', function() {
    $('#hidden-year-field').val($(this).val());
    $('#year-form').submit();
  });

  $('#project-picker').on('change', function(){
    $('#hidden-year-field').val($('#year-picker').val());
    $('#hidden-project-field').val($(this).val());
    $('#year-form').submit();
  })
});
