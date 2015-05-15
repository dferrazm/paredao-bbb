@VotesController = class VotesController
  index: ->
    index = new VotesIndexView()
    index.init()

  create: ->
    if $('#votes_percentage_container').length is 0
      @index()
    else
      @result()

  result: ->
    result = new VotesResultView()
    result.init()
