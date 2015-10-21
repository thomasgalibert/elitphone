@openNewEvent = ->
  $('.step').click ->
    date = $(this).data('date')
    $('.selected').removeClass('selected')

    if $(this).children().hasClass('active')
    else
      $(this).addClass('selected')
      $.ajax
        url: "/events/new"
        data: {set_date: date}
        dataType: "script"


jQuery ->
  openNewEvent()
