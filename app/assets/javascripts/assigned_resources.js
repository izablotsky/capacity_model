function changeInvolvementField(event) {
  const row = $(event.target).closest('.assigned_resource-row');
  const distributionInvolvement = row.find('.distribution_involvement');
  const allocationInvolvement = row.find('.allocation_involvement');

  if (distributionInvolvement.hasClass('d-none')) {
    distributionInvolvement.removeClass('d-none');
    allocationInvolvement.addClass('d-none');
  } else {
    distributionInvolvement.addClass('d-none');
    allocationInvolvement.removeClass('d-none');
  }
}

function editAssignedResource(event, resource_id) {
  $.ajax({
    url: '/assigned_resources/' + resource_id + '/edit',
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


function updateAssignedResource(event, resource_id) {
  var inputs =  $(event.target).closest('.assigned_resource-row').find('select, input');
  $.ajax({
    url: '/assigned_resources/' + resource_id,
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
