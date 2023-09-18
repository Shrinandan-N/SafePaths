'use strict';
const app = require('./index')
const serverless = require('serverless-http')


module.exports.list = app.list
module.exports.add = app.add
module.exports.remove = app.remove
module.exports.tr_list = app.tr_list
module.exports.tr_add = app.tr_add

