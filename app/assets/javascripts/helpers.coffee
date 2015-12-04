@removeClick = ->
  $('.remove-form').click ->
    $('#offcanvas').removeClass('target')

@closeFlash = ->
  $('.alert-closing').click ->
    $(this).parent().hide()

@showAgenda = ->
  $('#agenda_name').bind 'railsAutocomplete.select', (event, data) ->
    window.location.replace("/agendas/#{data.item.id}?user_id=#{data.item.user_id}")

@initBestInPlace = ->
  $('.best_in_place').best_in_place()

jQuery ->
  closeFlash()
  showAgenda()
  initBestInPlace()
