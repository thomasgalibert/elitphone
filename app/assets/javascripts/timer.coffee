startTime = ->
  today = new Date
  h = today.getHours()
  m = today.getMinutes()
  s = today.getSeconds()
  m = checkTime(m)
  s = checkTime(s)
  document.getElementById('timer').innerHTML = h + ':' + m + ':' + s
  t = setTimeout(startTime, 500)
  return

checkTime = (i) ->
  if i < 10
    i = '0' + i
  # add zero in front of numbers < 10
  i

jQuery ->
  startTime()
