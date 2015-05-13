class HistoryJson
  constructor: (histories=null)->
    @i= -1
    @histories= []

    if histories?
      properties= JSON.parse histories
      if typeof properties isnt 'object'
        throw new TypeError 'Invalid history'

      @[key]= value for key,value of properties

  canUndo: -> @histories[@i-1]?
  canRedo: -> @histories[@i+1]?

  count: -> @histories.length
  get: (i)-> @histories[i]
  add: (data)->
    history= JSON.stringify data
    if history isnt @histories[@i]
      @histories.length= @i+1
      @histories.push history

    @i= @count()-1
  destroy: ->
    @histories.length= 0

  current: (override=off)->
    history= @histories[@i]
    history= JSON.parse history if history?
    @[key]= value for key,value of history if override and history?

    history

  undo: ->
    if @canUndo()
      @i-= 1
      history= @current arguments...
    history

  redo: ->
    if @canRedo()
      @i+= 1
      history= @current arguments...
    history
  
  first: ->
    @i= 0
    history= @current arguments...
    history
    
  last: ->
    @i= @count()-1
    history= @current arguments...
    history

module.exports= HistoryJson