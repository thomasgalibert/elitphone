@removeClick = ->
  $('.remove-form').click ->
    $('#offcanvas').removeClass('target')

@closeFlash = ->
  $('.alert-closing').click ->
    $(this).parent().hide()

@showAgenda = ->
  $('#agenda_name').bind 'railsAutocomplete.select', (event, data) ->
    window.location.replace("/agendas/#{data.item.id}?user_id=#{data.item.user_id}")

jQuery ->
  closeFlash()
  showAgenda()
