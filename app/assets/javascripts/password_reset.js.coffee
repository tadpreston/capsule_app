window.PasswordResetHandler = (token) ->
  @token = token
  @messages =
    success: new Message('#success')
    error: new Message('#error')
    processing: new Message('#processing')
    noToken: new Message('#no-token')
    passwordForm: new ResetForm('#password-form')
  return

PasswordResetHandler.prototype =
  initialize: ->
    _this = this
    if @token.length <= 0
      @messages.noToken.show()
    else
      _this.messages.processing.show ->
        new Token(_this.token).verify (->
          _this.messages.processing.hide ->
            _this.showForm()
            return
          return
        ), ->
          _this.messages.processing.hide ->
            _this.messages.error.show()
            return
          return
        return
    return
  showForm: ->
    _this = this
    _this.messages.processing.hide ->
      _this.messages.passwordForm.show ->
        _this.messages.passwordForm.initialize _this
        return
      return
    return
  buildRequestData: (password, confirmPassword) ->
    { 'user':
      'password': password
      'password_confirmation': confirmPassword }
  doRequest: (password, confirmPassword) ->
    _this = this
    _this.messages.processing.hide ->
      $.ajax(
        url: 'https://stormy-crag-8840.herokuapp.com/api/v1/password_resets/' + _this.token
        method: 'PATCH'
        data: _this.buildRequestData(password, confirmPassword)
        beforeSend: (request) ->
          request.setRequestHeader 'Authorization', 'Token token=yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w'
          return
      ).success((response) ->
        _this.messages.processing.hide ->
          _this.messages.success.show()
          return
        return
      ).error (response) ->
        _this.messages.processing.hide ->
          _this.messages.error.show()
          return
        return
      return
    return


window.Message = (elementID) ->
  @elementID = elementID
  return

Message.prototype =
  show: (handler) ->
    $(@elementID).slideDown 1000, handler
    return
  hide: (handler) ->
    $(@elementID).slideUp 1000, handler
    return

window.ResetForm = (elementID) ->
  @elementID = elementID
  @elements =
    password: '#password'
    confirmPassword: '#confirm-password'
    button: '#btn-do-reset'
    passwordValidationMessage: '#passwordValidationMessage'
  return

window.ResetForm.prototype = new Message

ResetForm::initialize = (handler) ->
  _this = this
  $(@elements.button).click (e) ->
    e.preventDefault()
    if _this.validates()
      handler.messages.passwordForm.hide ->
        handler.messages.processing.show ->
          handler.doRequest $(_this.elements.password).val(), $(_this.elements.confirmPassword).val()
          return
        return
    return
  return

ResetForm::validates = ->
  password = $(@elements.password).val()
  cPassword = $(@elements.confirmPassword).val()
  requiredLength = 6
  everythingOK = true
  @resetValidation()
  if password.length < requiredLength
    $(@elements.passwordValidationMessage).text 'Your password must be at least ' + requiredLength + ' characters.'
    everythingOK = false
    $(@elements.password).css 'border', '1px solid red'
  else if password != cPassword
    $(@elements.passwordValidationMessage).text 'Your passwords do not match.'
    everythingOK = false
    $(@elements.password).css 'border', '1px solid red'
    $(@elements.confirmPassword).css 'border', '1px solid red'
  everythingOK

ResetForm::resetValidation = ->
  $(@elements.passwordValidationMessage).text ''
  $(@elements.password).css 'border', 'none'
  $(@elements.confirmPassword).css 'border', 'none'
  return

window.Token = (tokenString) ->
  @tokenString = tokenString
  return

Token.prototype = verify: (success, fail) ->
  $.ajax(
    url: 'https://stormy-crag-8840.herokuapp.com/api/v1/password_resets/' + @tokenString + '/edit'
    method: 'GET'
    beforeSend: (request) ->
      request.setRequestHeader 'Authorization', 'Token token=yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w'
      return
  ).success((response) ->
    success()
    return
  ).error (response) ->
    fail()
    return
  return
