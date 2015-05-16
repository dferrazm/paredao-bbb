@VotesIndexView = class VotesIndexView
  init: ->
    @initPollAvatars()
    @handleFormSubmit()

  initPollAvatars: ->
    $('form .contestant .avatar').click ->
      $('.avatar')
        .removeClass('active').addClass('inactive').parents('.contestant-container')
        .children('.contestant-input').removeAttr 'checked'

      $(@)
        .addClass('active').removeClass('inactive').parents('.contestant-container')
        .children('.contestant-input').attr('checked', true).click()
      return

  handleFormSubmit: ->
    $('form input[type="submit"]').click (e) =>
      e.preventDefault() unless @isFormValid()

  isFormValid: ->
       @isVoteSelected() and @isCaptchaFilled()

  isVoteSelected: ->
    if $('.contestant-input:checked').length is 0
      $form = $ 'form'
      $form.scrollTo().find('.action').before @errorMsg($form.data 'error-empty')
      false
    else
      true

  isCaptchaFilled: ->
    if $('#recaptcha_response_field').val() is ''
      $captcha = $ '.captcha'
      $captcha.scrollTo().prepend @errorMsg($captcha.data 'error-empty')
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
