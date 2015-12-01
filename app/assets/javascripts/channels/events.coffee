App.events = App.cable.subscriptions.create 'EventsChannel',

  agenda: -> $("[data-channel='events']")

  connected: ->
    setTimeout =>
      @followCurrentAgenda()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    unless @userIsCurrentUser()
      $(".week-wrapper").html data.event
      $("#offcanvas").removeClass('target')
      openNewEvent()

  userIsCurrentUser: ->
    @agenda().data('user') is $('meta[name=current-user]').attr('id')

  followCurrentAgenda: ->
    if agendaId = @agenda().data('agenda')
      @perform 'follow', agenda: agendaId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      if App.events
        $(document).on 'page:change', -> App.events.followCurrentAgenda()
