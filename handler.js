'use strict';
const app = require('./index')
const serverless = require('serverless-http')
 
//module.exports.hello = serverless(app)
// module.exports.hello = async (event) => {
//   return {
//     statusCode: 200,
//     body: JSON.stringify(
//       {
//         message: 'Go Serverless v1.0! Your function executed successfully!',
//         input: event,
//       },
//       null,
//       2
//     ),
//   };
// }

module.exports.list = app.list
module.exports.add = app.add
module.exports.remove = app.remove
module.exports.tr_list = app.tr_list
module.exports.tr_add = app.tr_add
  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };

