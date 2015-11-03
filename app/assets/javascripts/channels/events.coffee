App.events = App.cable.subscriptions.create 'EventsChannel',
  received: (data) ->
    $(".week").html data.event
    $("#offcanvas").removeClass('target')
    openNewEvent()
