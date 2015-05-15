$ ->
  getHourlyVotes()

getHourlyVotes = ->
  $hourlyVotesContainer = $ '#total_hourly'

  $.get $hourlyVotesContainer.data('source'), (data) ->
    $hourlyVotesContainer.html ''
    $.each data, (hour, total) ->
      $hourlyVotesContainer.append "<p>#{hour}: #{total}</p>"
  , 'json'