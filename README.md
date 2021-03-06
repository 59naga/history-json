# History-json [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

[![Sauce Test Status][sauce-image]][sauce]

> Implement undo/redo by Accumulating json

## Installation
### Via npm
```bash
$ npm install history-json --save
```
```js
var HistoryJson= require('history-json');
console.log(HistoryJson); //function
```

### Via bower
```bash
$ bower install history-json --save
```
```html
<script src="bower_components/history-json/history-json.min.js"></script>
<script>
  console.log(HistoryJson); //function
</script>
```

## Usage
```js
var history= new HistoryJson;

history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});

history.current();// { state: 'three' }
history.undo();// { state: 'two' }
history.undo();// { state: 'one' }
history.undo();// undefined

history.current();// { state: 'one' }
history.redo();// { state: 'two' }
history.redo();// { state: 'three' }
history.redo();// undefined

var exported= JSON.stringify(history);
// save to file or localStorage

var imported= new HistoryJson(exported);
imported.current();// { state: 'three' }
imported.undo();// { state: 'two' }
imported.undo();// { state: 'one' }
imported.undo();// undefined
```

# API
## `.add(history)`
Return `index` of added `history`
But, __Doesn't add__ if duplicate of previous history.

```js
var history= new HistoryJson;
history.add({state:'one'});// 0
history.add({state:'two'});// 1
history.add({state:'three'});// 2

history.add({state:'three'});// 2
```

## `.undo(override=false)`
Return `history` via Change `index` to previous

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.undo();// { state: 'two' }
```

## `.redo(override=false)`
Return `history` via Change `index` to following

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.undo();// { state: 'two' }
history.redo();// { state: 'three' }
```

## `.current(override=false)`
Return `history` by current `index`

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.current();// { state: 'three' }
```

## `.first(override=false)`
Return `history` via Change index to first

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.first();// { state: 'one' }
```

## `.last(override=false)`
Return `history` via Change index to last

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.last();// { state: 'three' }
```

## `.count()`
Return `number` of histories

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.count()// 3
```

## `.get(index)`
Return `history` by `index`

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.get(0)// { state: 'one' }
```

## `.destroy()`
Delete all `histories`

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.add({state:'three'});
history.count();// 3

history.destroy();
history.count();// 0
```

## `.canUndo()`
Return `true` if can undo.

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.canUndo();// true

history.undo();// { state: 'one' }
history.canUndo();// false
```

## `.canRedo()`
Return `true` if can redo.

```js
var history= new HistoryJson;
history.add({state:'one'});
history.add({state:'two'});
history.canRedo();// false

history.undo();// { state: 'one' }
history.canRedo();// true
```

## Override option
Override self properties by history if set `true`

```coffee
class Tool extends HistoryJson
  constructor: ->
    super

    @use 'Hammer',power:20
  use: (@tool,@options={})->
    @add {tool:@tool,options:@options}

tool= new Tool
tool.use 'Drill',{power:50}
console.log(tool)# tool:'Drill',options:{power:50}

tool.undo(true)
console.log(tool)# tool:'Hammer',options:{power:20}
```

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59naga/history-json.svg
[sauce]: https://saucelabs.com/u/history-json
[npm-image]:https://img.shields.io/npm/v/history-json.svg?style=flat-square
[npm]: https://npmjs.org/package/history-json
[travis-image]: http://img.shields.io/travis/59naga/history-json.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/history-json
[coveralls-image]: http://img.shields.io/coveralls/59naga/history-json.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/history-json?branch=master
