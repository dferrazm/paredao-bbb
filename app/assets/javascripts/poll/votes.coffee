@VotesController = class VotesController
  index: ->
    index = new VotesIndexView()
    index.init()

  create: -> @result()

  result: ->
    result = new VotesResultView()
    result.init()
