App.events = App.cable.subscriptions.create 'EventsChannel',
  received: (data) ->
    $(".main-content").html data.event
    $("#offcanvas").removeClass('target')
    openNewEvent()
