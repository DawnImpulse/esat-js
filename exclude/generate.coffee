###require('../index').generate({exp:60000,rat:30000,payload:{"hey":"you"}},"abcdef").then((token)->
  console.info token
).catch (error) ->
  console.error error###

require('../index').generate({exp: 60000, rat: 30000, payload: {"hey": "you"}}, "abcdef", (err, token)->
  console.log(token)
)