@VotesIndexView = class VotesIndexView
  init: ->
    @initPollAvatars()

  initPollAvatars: ->
    $('form .contestant .avatar').click ->
      $('.avatar')
        .removeClass('active').parents('.contestant-container')
        .children('.contestant-input').attr 'checked', false

      $(@)
        .addClass('active').parents('.contestant-container')
        .children('.contestant-input').attr 'checked', true
      return
