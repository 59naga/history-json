HistoryJson= require '../'

describe 'HistoryJson',->
  it 'Walking the broadway of histories',->
    history= new HistoryJson
    expect(history.add 'one').toBe 0
    expect(history.add two:'two').toBe 1
    expect(history.add [{three:'three'}]).toBe 2
    expect(history.undo()).toEqual two:'two'
    expect(history.undo()).toEqual 'one'
    expect(history.undo()).toEqual undefined
    expect(history.undo()).toEqual undefined

    expect(history.redo()).toEqual two:'two'
    expect(history.redo()).toEqual [{three:'three'}]
    expect(history.redo()).toEqual undefined
    expect(history.redo()).toEqual undefined
    expect(history.undo()).toEqual two:'two'
    expect(history.redo()).toEqual [{three:'three'}]
    expect(history.undo()).toEqual two:'two'
    expect(history.undo()).toEqual 'one'

    expect(history.count()).toEqual 3
    expect(history.first()).toEqual 'one'
    expect(history.last()).toEqual [{three:'three'}]

  it 'Export / Import',->
    history= new HistoryJson
    expect(history.add 'one').toBe 0
    expect(history.add two:'two').toBe 1
    expect(history.add [{three:'three'}]).toBe 2
    expect(history.undo()).toEqual two:'two'
    expect(history.undo()).toEqual 'one'
    expect(history.undo()).toEqual undefined
    expect(history.undo()).toEqual undefined

    exported= JSON.stringify history
    imported= new HistoryJson exported

    expect(imported.redo()).toEqual two:'two'
    expect(imported.redo()).toEqual [{three:'three'}]
    expect(imported.redo()).toEqual undefined
    expect(imported.redo()).toEqual undefined
    expect(imported.undo()).toEqual two:'two'
    expect(imported.redo()).toEqual [{three:'three'}]
    expect(imported.undo()).toEqual two:'two'
    expect(imported.undo()).toEqual 'one'

    expect(history.count()).toEqual 3
    expect(history.first()).toEqual 'one'
    expect(history.last()).toEqual [{three:'three'}]

  it 'Every noop if history is not stacked',->
    history= new HistoryJson
    expect(history.count()).toEqual 0
    expect(history.canUndo()).toEqual no
    expect(history.canRedo()).toEqual no
    expect(history.redo()).toEqual undefined
    expect(history.undo()).toEqual undefined

    expect(history.count()).toEqual 0
    expect(history.first()).toEqual undefined
    expect(history.last()).toEqual undefined

    history.add 'one'
    expect(history.count()).toEqual 1
    expect(history.canUndo()).toEqual no
    expect(history.canRedo()).toEqual no
    expect(history.redo()).toEqual undefined
    expect(history.undo()).toEqual undefined

    expect(history.count()).toEqual 1
    expect(history.first()).toEqual 'one'
    expect(history.last()).toEqual 'one'

    history.add 'two'
    expect(history.count()).toEqual 2
    expect(history.canUndo()).toEqual yes
    expect(history.canRedo()).toEqual no
    expect(history.undo()).toEqual 'one'
    expect(history.undo()).toEqual undefined
    expect(history.redo()).toEqual 'two'
    expect(history.redo()).toEqual undefined

    expect(history.count()).toEqual 2
    expect(history.first()).toEqual 'one'
    expect(history.last()).toEqual 'two'

  it 'Ignore duplicate of previous history',->
    history= new HistoryJson
    history.add 'one'
    history.add 'one'
    expect(history.count()).toEqual 1

  it 'Prune history of subsequent',->
    history= new HistoryJson
    history.add 'one'
    history.add two:'two'
    history.add [{three:'three'}]
    history.undo()
    history.add [[[[four:'four']]]]

    expect(history.redo()).toEqual undefined
    expect(history.undo()).toEqual two:'two'
    expect(history.undo()).toEqual 'one'
    expect(history.undo()).toEqual undefined

    expect(history.count()).toEqual 3
    expect(history.first()).toEqual 'one'
    expect(history.last()).toEqual [[[[four:'four']]]]

  it 'Override self properties by undo/redo history',->
    class Tool extends HistoryJson
      constructor: ->
        super

        @use 'Hammer',power:20
      use: (@tool,@options={})->
        @add {tool:@tool,options:@options}

    tool= new Tool
    tool.use 'Drill',{power:50}

    expect(tool.undo(true)).toEqual tool:'Hammer',options:{power:20}
    expect(tool.undo(true)).toEqual undefined
    expect(tool.tool).toEqual 'Hammer'
    expect(tool.options.power).toEqual 20

    expect(tool.redo(true)).toEqual tool:'Drill',options:{power:50}
    expect(tool.redo(true)).toEqual undefined
    expect(tool.tool).toEqual 'Drill'
    expect(tool.options.power).toEqual 50

    expect(tool.count()).toEqual 2
    expect(tool.first()).toEqual tool:'Hammer',options:{power:20}
    expect(tool.last()).toEqual tool:'Drill',options:{power:50}

  it 'Destroy',->
    history= new HistoryJson
    expect(history.add 'one').toBe 0
    expect(history.add two:'two').toBe 1
    expect(history.add [{three:'three'}]).toBe 2
    expect(history.count()).toBe 3
    
    history.destroy()
    expect(history.count()).toBe 0
