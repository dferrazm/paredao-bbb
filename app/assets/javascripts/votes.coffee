$ ->
  initPollAvatars()
  getVotesPercentage()
  initCountdown()

initPollAvatars = ->
  $('form .contestant .avatar').click ->
    $('.avatar').removeClass('active').children('input[type="radio"]').attr 'checked', false
    $(@).addClass('active').children('input[type="radio"]').attr 'checked', true
    return

getVotesPercentage = ->
  $votesPercentageContainer = $ '#votes_percentage_container'

  $.get $votesPercentageContainer.data('source'), (data) ->    
    chart_data = []
    only_zeroes = true
    $.each data.percentages, (id, value) ->
      color = (if id == data.greater then '#FFA500' else '#D3D3D3')
      chart_data.push { value: value, color: color }
      $("#contestant_#{id}_container .percentage").css('color', color).text "#{value}%"
      only_zeroes = only_zeroes && value == 0
      return

    if only_zeroes
      chart_data[i].value = 1 for i in [0..chart_data.length - 1]

    ctx = document.getElementById("chart").getContext("2d")
    new Chart(ctx).Doughnut chart_data, { percentageInnerCutout : 70, showTooltips: false, tooltipEvents: [] }
  , 'json'

initCountdown = ->
  # get tag element
  countdown = $ '#countdown'
  countdown_timer = countdown.find '#timer'

  # set the date we're counting down to
  target_date = new Date(countdown.data 'finish').getTime()

  # variables for time units
  hours = undefined
  minutes = undefined
  seconds = undefined

  current_date = new Date().getTime()

  # update the tag with id "countdown" every 1 second
  countdownInterval = setInterval (->

    # find the amount of "seconds" between now and target
    current_date = new Date().getTime()
    seconds_left = (target_date - current_date) / 1000

    # do some time calculations
    hours = parseInt(seconds_left / 3600)
    seconds_left = seconds_left % 3600
    minutes = parseInt(seconds_left / 60)
    seconds = parseInt(seconds_left % 60)

    if seconds < 0
      countdown_timer.html("00:00:00")
      countdown.find('.label.bottom').text countdown.data('finish-label')
      clearInterval countdownInterval
    else
      # format countdown string + set tag value
      countdown_timer.html("#{formatNumber hours}:#{formatNumber minutes}:#{formatNumber seconds}")

    countdown.show() unless countdown.is ':visible'
    return
  ), 1000

formatNumber = (n) ->
  if (n < 10) then ("0" + n) else n