var HistoryJson;
if(require('module')._extensions['.coffee']==null){
  HistoryJson= require('./lib');
}
else{
  HistoryJson= require('./src');
}
module.exports= HistoryJson;