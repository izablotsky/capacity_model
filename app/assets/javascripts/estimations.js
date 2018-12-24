function editEstimation(event, resource_id) {
  $.ajax({
    url: '/estimations/' + resource_id + '/edit',
    dataType: 'script',
    success: function (result) {
      $(event.target).closest('.assigned_resource-row').html(result);
    },
    complete: function (result) {
      $(event.target).closest('.assigned_resource-row').html(result.responseText);
     //console.log(result.responseText);
    }
  });
}


function updateEstimation(event, resource_id) {
  var inputs =  $(event.target).closest('.assigned_resource-row').find('select, input');
  $.ajax({
    url: '/estimations/' + resource_id,
    method: 'put',
    dataType: 'script',
    data: inputs.serialize(),
    success: function (result) {
      $(event.target).closest('form').html(result);
    },
    complete: function (result) {
      $(event.target).closest('.assigned_resource-row').html(result.responseText);
    }
  })
}
