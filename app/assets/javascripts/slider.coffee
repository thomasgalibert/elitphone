# TURN THE RANGE INTO A SLIDER
#
# selectedTick = ->
#   $('.tick').click ->
#     tick = $(@)
#     minutes = tick.children('.tick-value').text()
#     $('.active-tick').removeClass('active-tick')
#     tick.addClass('active-tick')
#     $('.range').children('input').attr('value', minutes)

# slider = ->

#   range = $('.range')
#   id_datalist = range.children('input').attr('list')
#   range.hide()
#   vals = ""
#   childs = $('#durations').children()
#   childs.each ->
#     child = $(@)
#     vals += "<div class='tick'><div class='tick-value'>#{child.val()}</div></div>"
#   range.after("<div class='slider'>#{vals}<div class='line'></div></div>")



# jQuery ->
#   slider()
#   selectedTick()
