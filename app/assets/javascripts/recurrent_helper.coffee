@openRecurrentDialog = ->
  checkbox = $('#event_is_recurring')
  checkbox.change ->
    if $('.recurrent-dialog').length
      $('.recurrent-dialog').remove()
    else
      checkbox.parent().parent().after(recurrentDialog)
      selectOnChooseFrequence()

recurrentDialog = ->
  openTag = '<div class="recurrent-dialog">'
  selectTag = selectRecurrence
  closingTag = '</div>'
  return openTag+selectTag+closingTag

selectRecurrence = 'Fréquence : <select id="chooseFrequence">'+
                    '<option value="">-- choisir la fréquence --</option>'+
                    '<option value="daily">Journalière</option>'+
                    '<option value="weekly">Hébdomadaire</option>'+
                    '<option value="monthly">Mensuelle</option>'+
                    '</select>'+
                    '<div class="every"></div>'

@selectOnChooseFrequence = ->
  selectFrequence = $('#chooseFrequence')
  every = $('.every')
  selectFrequence.change ->
    option = selectFrequence.val()
    if option == "daily"
      every.html(dailyWindow)
      updateDailyJson()
    else if option == "weekly"
      every.html(weeklyWindow)
    else if option == "monthly"
      every.html(monthlyWindow)
    else
      every.html('<span>Aucune récurrence</span>')

@updateDailyJson = ->
  numberDay = $('#dailyRec')
  numberDay.change ->
    valueDay = numberDay.val()
    $('#event_recurring_status').val({"recurrence": "daily"})


dailyWindow = '<span>tous les <input id="dailyRec" type="number" value="1" class="inline-input" /> jour(s) ? </span>'

weeklyWindow = '<span>vue semaine</span>'
monthlyWindow = '<span>vue mois</span>'

jQuery ->
  openRecurrentDialog()
