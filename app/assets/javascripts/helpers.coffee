@removeClick = ->
  $('.remove-form').click ->
    $('#offcanvas').removeClass('target')

@closeFlash = ->
  $('.alert-closing').click ->
    $(this).parent().hide()

jQuery ->
  closeFlash()
