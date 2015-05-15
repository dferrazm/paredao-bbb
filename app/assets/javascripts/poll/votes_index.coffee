@VotesIndexView = class VotesIndexView
  init: ->
    @initPollAvatars()
    @handleFormSubmit()

  initPollAvatars: ->
    $('form .contestant .avatar').click ->
      $('.avatar')
        .removeClass('active').parents('.contestant-container')
        .children('.contestant-input').attr 'checked', false

      $(@)
        .addClass('active').parents('.contestant-container')
        .children('.contestant-input').attr 'checked', true
      return

  handleFormSubmit: ->
    $('form input[type="submit"]').click (e) =>
      e.preventDefault() unless @isFormValid()

  isFormValid: ->
       @isVoteSelected() and @isCaptchaFilled()

  isVoteSelected: ->
      if $('.contestant-input:checked').length is 0
        $('form').scrollTo().find('.action').before @errorMsg('Vote em alguém para sair!')
        false
      else
        true

  isCaptchaFilled: ->
    if $('#recaptcha_response_field').val() is ''
      $('.captcha').scrollTo().prepend @errorMsg('Preencha o teste abaixo.')
      false
    else
      true

  errorMsg: (text) ->
    $('.info-message.error').remove()
    "<p class='info-message error'>#{text}</p>"

$.fn.scrollTo = ->
  $('html,body').animate
    scrollTop: @.offset().top
  , 500
  return @
