@openNewEvent = ->
  $('.step').click ->
    date = $(this).data('date')
    agenda = $('.week-wrapper').data('agenda')

    $('.selected').removeClass('selected')

    if $(this).children().hasClass('active')
      event = $(this).children().data('id')
      $(this).addClass('selected')
      $.ajax
        url: "/agendas/#{agenda}/events/#{event}/edit"
        data: {set_date: date}
        dataType: "script"
    else
      $(this).addClass('selected')
      $.ajax
        url: "/agendas/#{agenda}/events/new"
        data: {set_date: date}
        dataType: "script"


jQuery ->
  openNewEvent()
